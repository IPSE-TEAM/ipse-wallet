import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:ipsewallet/pages/my/mortgage/mortgage.dart';
import 'package:ipsewallet/pages/my/tx_confirm_page.dart';
import 'package:ipsewallet/service/substrate_api/api.dart';
import 'package:ipsewallet/store/app.dart';
import 'package:ipsewallet/utils/UI.dart';
import 'package:ipsewallet/utils/adapt.dart';
import 'package:ipsewallet/utils/format.dart';
import 'package:ipsewallet/utils/i18n/index.dart';
import 'package:ipsewallet/widgets/my_appbar.dart';
import 'package:ipsewallet/widgets/rounded_button.dart';

class MortgageRanking extends StatefulWidget {
  MortgageRanking(this.appStore);
  static String route = "/my/mortgageRanking";
  final AppStore appStore;
  @override
  _MortgageRankingState createState() => _MortgageRankingState(appStore);
}

class _MortgageRankingState extends State<MortgageRanking> {
  _MortgageRankingState(this.store);
  final AppStore store;

  final Api api = webApi;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _amountCtrl = new TextEditingController();

  bool _enableBtn = false;

  Future<void> _onSave() async {
    if (_formKey.currentState.validate()) {
      int decimals = store.settings.networkState.tokenDecimals;

      var args = {
        "title": I18n.of(context).ipse['mortgage_ranking'],
        "txInfo": {
          "module": 'pocStaking',
          "call": 'requestUpToList',
        },
        "detail": jsonEncode({
          "amount": _amountCtrl.text.trim(),
        }),
        "params": [
          Fmt.tokenInt(_amountCtrl.text.trim(), decimals).toString(),
        ],
        'onFinish': (BuildContext txPageContext, Map res) {
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
    return Scaffold(
      appBar: myAppBar(context, dic['mortgage_ranking']),
      body: Observer(builder: (_) {
        String symbol = store.settings.networkState.tokenSymbol;
        int decimals = store.settings.networkState.tokenDecimals;

        double available = 0;
        if (store.assets.balances[symbol] != null) {
          available = Fmt.bigIntToDouble(
              store.assets.balances[symbol].transferable, decimals);
        }

        return SafeArea(
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
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: dic['mortgage_ranking_amount'],
                          labelText:
                              '${dic['mortgage_ranking_amount']} (${assetDic['balance']}: ${Fmt.priceFloor(
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
                          if (double.parse(v.trim()) >= available) {
                            return assetDic['amount.low'];
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
        );
      }),
    );
  }
}
