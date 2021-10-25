import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:ipsewallet/pages/my/mortgage/miner_select.dart';
import 'package:ipsewallet/pages/my/mortgage/mortgage.dart';
import 'package:ipsewallet/pages/my/tx_confirm_page.dart';
import 'package:ipsewallet/store/app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:ipsewallet/service/substrate_api/api.dart';
import 'package:ipsewallet/utils/UI.dart';
import 'package:ipsewallet/utils/adapt.dart';
import 'package:ipsewallet/utils/format.dart';
import 'package:ipsewallet/utils/i18n/index.dart';
import 'package:ipsewallet/widgets/address_icon.dart';
import 'package:ipsewallet/widgets/loading_widget.dart';
import 'package:ipsewallet/widgets/my_appbar.dart';
import 'package:ipsewallet/widgets/rounded_button.dart';

class UserMortgage extends StatefulWidget {
  UserMortgage(this.appStore);
  final AppStore appStore;
  static String route = "/my/UserMortgage";
  @override
  _UserMortgageState createState() => _UserMortgageState(appStore);
}

class _UserMortgageState extends State<UserMortgage> {
  _UserMortgageState(this.store);
  final AppStore store;

  final Api api = webApi;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _amountCtrl = new TextEditingController();
  bool _enableBtn = false;
  String _miner;

  Future<void> _changeMiner(BuildContext context) async {
    var miner = await Navigator.of(context).pushNamed(MinerSelect.route);
    if (miner != null) {
      setState(() {
        _miner = miner;
      });
    }
  }

  Future<void> _onSave() async {
    if (_formKey.currentState.validate() &&
        _miner != null &&
        _miner.isNotEmpty) {
      int decimals = store.settings.networkState.tokenDecimals;
      var args = {
        "title": I18n.of(context).ipse['participate_in_mortgage'],
        "txInfo": {
          "module": 'pocStaking',
          "call": 'staking',
        },
        "detail": jsonEncode({
          "miner": _miner,
          "amount": _amountCtrl.text.trim(),
        }),
        "params": [
          _miner,
          Fmt.tokenInt(_amountCtrl.text.trim(), decimals).toString(),
        ],
        'onFinish': (BuildContext txPageContext, Map res) {
          globalMortgageRefreshKey.currentState.show();
          Navigator.popUntil(
              txPageContext, ModalRoute.withName(Mortgage.route));
        }
      };
      Navigator.of(context).pushNamed(TxConfirmPage.route, arguments: args);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      webApi.ipse.fetchPocMinersList();
    });
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var dic = I18n.of(context).ipse;
    var assetDic = I18n.of(context).assets;

    return Observer(builder: (_) {
      String symbol = store.settings.networkState.tokenSymbol;
      int decimals = store.settings.networkState.tokenDecimals;

      double available = 0;
      if (store.assets.balances[symbol] != null) {
        available = Fmt.bigIntToDouble(
            store.assets.balances[symbol].transferable, decimals);
      }
      BigInt minBondAmount = store.settings.networkConst["pocStaking"] != null
          ? BigInt.parse(store
                  .settings.networkConst["pocStaking"]["pocStakingMinAmount"]
                  ?.toString() ??
              "0")
          : null;
      return Scaffold(
        appBar:
            myAppBar(context, I18n.of(context).ipse['participate_in_mortgage']),
        body: minBondAmount == null
            ? LoadingWidget()
            : SafeArea(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onChanged: () => setState(() => _enableBtn =
                            _formKey.currentState.validate() && _miner != null),
                        child: ListView(
                          padding: EdgeInsets.all(Adapt.px(30)),
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(top: 4),
                                  child: Text(
                                    dic['miner'],
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => _changeMiner(context),
                                  child: Container(
                                    margin: EdgeInsets.only(top: 4, bottom: 4),
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                      border: Border.all(
                                          color:
                                              Theme.of(context).disabledColor,
                                          width: 0.5),
                                    ),
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.only(right: 8),
                                          child: AddressIcon(_miner, size: 32),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                _miner != null
                                                    ? Fmt.address(_miner)
                                                    : dic['select_miner'],
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey),
                                              )
                                            ],
                                          ),
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          size: 18,
                                          color: Colors.grey,
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 15),
                            TextFormField(
                              decoration: InputDecoration(
                                hintText: assetDic['amount'],
                                labelText:
                                    '${assetDic['amount']} (${assetDic['balance']}: ${Fmt.priceFloor(
                                  available,
                                  lengthMax: 3,
                                )} $symbol)',
                              ),
                              inputFormatters: [
                                UI.decimalInputFormatter(decimals)
                              ],
                              controller: _amountCtrl,
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
                              validator: (v) {
                                if (v.isEmpty) {
                                  return assetDic['amount.error'];
                                }
                                if (double.parse(v.trim()) >= available) {
                                  return assetDic['amount.low'];
                                }
                                if (double.parse(v.trim()) <
                                    Fmt.bigIntToDouble(
                                        minBondAmount, decimals)) {
                                  return I18n.of(context)
                                          .gov["treasury.bond.min"] +
                                      " " +
                                      Fmt.token(minBondAmount, decimals) +
                                      " " +
                                      symbol;
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(16),
                      child: RoundedButton(
                        text: I18n.of(context).ipse['submit'],
                        onPressed: _enableBtn ? _onSave : null,
                      ),
                    ),
                  ],
                ),
              ),
      );
    });
  }
}
