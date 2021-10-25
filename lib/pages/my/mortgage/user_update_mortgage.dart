import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ipsewallet/pages/my/mortgage/mortgage.dart';
import 'package:ipsewallet/pages/my/tx_confirm_page.dart';
import 'package:ipsewallet/service/substrate_api/api.dart';
import 'package:ipsewallet/store/app.dart';
import 'package:ipsewallet/utils/UI.dart';
import 'package:ipsewallet/utils/adapt.dart';
import 'package:ipsewallet/utils/format.dart';
import 'package:ipsewallet/utils/i18n/index.dart';
import 'package:ipsewallet/utils/my_utils.dart';
import 'package:ipsewallet/widgets/address_icon.dart';
import 'package:ipsewallet/widgets/my_appbar.dart';
import 'package:ipsewallet/widgets/rounded_button.dart';

class UserUpdateMortgage extends StatefulWidget {
  UserUpdateMortgage(this.appStore, this.mapData);
  final AppStore appStore;
  final Map mapData;
  static String route = "/my/UserUpdateMortgage";
  @override
  _UserUpdateMortgageState createState() => _UserUpdateMortgageState(appStore);
}

class _UserUpdateMortgageState extends State<UserUpdateMortgage> {
  _UserUpdateMortgageState(this.store);
  final AppStore store;

  final Api api = webApi;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountCtrl = new TextEditingController();
  bool _enableBtn = false;
  String operate = "Add";

  Future<void> _onSave() async {
    if (_formKey.currentState.validate()) {
      String address = widget.mapData['address'];
      int decimals = store.settings.networkState.tokenDecimals;
      var args = {
        "title": I18n.of(context).ipse['update_my_mortgage'],
        "txInfo": {
          "module": 'pocStaking',
          "call": 'updateStaking',
        },
        "detail": jsonEncode({
          "miner": address,
          "operate": operate,
          "amount": _amountCtrl.text.trim(),
        }),
        "params": [
          address,
          operate,
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
  void dispose() {
    _amountCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var dic = I18n.of(context).ipse;
    var assetDic = I18n.of(context).assets;
    String symbol = store.settings.networkState.tokenSymbol;
    int decimals = store.settings.networkState.tokenDecimals;
    String address = widget.mapData['address'];
    double hasMortgageAmount = widget.mapData['hasMortgageAmount'];
    double available = 0;
    if (store.assets.balances[symbol] != null) {
      available = Fmt.bigIntToDouble(
          store.assets.balances[symbol].transferable, decimals);
    }

    return Scaffold(
      appBar: myAppBar(context, I18n.of(context).ipse['update_my_mortgage']),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Form(
                key: _formKey,
                onChanged: () => setState(
                    () => _enableBtn = _formKey.currentState.validate()),
                child: ListView(
                  padding: EdgeInsets.all(Adapt.px(30)),
                  children: <Widget>[
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      color: Colors.black12,
                      child: Row(
                        children: [
                          AddressIcon(address),
                          SizedBox(width: 4),
                          Text(Fmt.address(address)),
                        ],
                      ),
                    ),
                    RadioListTile<String>(
                      value: 'Add',
                      title: Text(I18n.of(context).ipse['add']),
                      groupValue: operate,
                      onChanged: (String result) {
                        setState(() {
                          operate = result;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      value: 'Sub',
                      title: Text(I18n.of(context).ipse['subside']),
                      groupValue: operate,
                      onChanged: (String result) {
                        setState(() {
                          operate = result;
                        });
                      },
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
                      inputFormatters: [UI.decimalInputFormatter(decimals)],
                      controller: _amountCtrl,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      validator: (v) {
                        if (v.isEmpty) {
                          return assetDic['amount.error'];
                        }
                        if (operate == 'Add' &&
                            double.parse(v.trim()) >= available) {
                          return assetDic['amount.low'];
                        }
                        if (operate == 'Sub' &&
                            double.parse(v.trim()) > hasMortgageAmount) {
                          return I18n.of(context).ipse['exceed_mortgage_mount'];
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
                onPressed: _enableBtn
                    ? () {
                        if (operate == "Sub") {
                          showConfrim(
                              context,
                              Text(dic['confirm_reduce_mortgage_amount']),
                              I18n.of(context).home['yes'],
                              _onSave);
                        } else {
                          _onSave();
                        }
                      }
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
