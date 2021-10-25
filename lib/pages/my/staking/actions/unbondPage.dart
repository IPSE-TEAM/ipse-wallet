import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ipsewallet/common/address_form_item.dart';
import 'package:ipsewallet/pages/my/tx_confirm_page.dart';
import 'package:ipsewallet/store/app.dart';
import 'package:ipsewallet/utils/UI.dart';
import 'package:ipsewallet/utils/format.dart';
import 'package:ipsewallet/utils/i18n/index.dart';
import 'package:ipsewallet/widgets/my_appbar.dart';
import 'package:ipsewallet/widgets/rounded_button.dart';

class UnBondPage extends StatefulWidget {
  UnBondPage(this.store);
  static final String route = '/staking/unbond';
  final AppStore store;
  @override
  _UnBondPageState createState() => _UnBondPageState(store);
}

class _UnBondPageState extends State<UnBondPage> {
  _UnBondPageState(this.store);
  final AppStore store;

  final _formKey = GlobalKey<FormState>();
  bool _enableBtn = false;

  final TextEditingController _amountCtrl = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    var dic = I18n.of(context).staking;
    var assetDic = I18n.of(context).assets;
    String symbol = store.settings.networkState.tokenSymbol;
    int decimals = store.settings.networkState.tokenDecimals;
    double bonded = 0;
    if (store.staking.ownStashInfo != null) {
      bonded = Fmt.bigIntToDouble(
          BigInt.parse(
              store.staking.ownStashInfo.stakingLedger['active'].toString()),
          decimals);
    }

    return Scaffold(
      appBar: myAppBar(context, dic['action.unbond']),
      body: Builder(builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onChanged: () => setState(
                      () => _enableBtn = _formKey.currentState.validate()),
                  child: ListView(
                    padding: EdgeInsets.all(16),
                    children: <Widget>[
                      AddressFormItem(
                        store.account.currentAccount,
                        label: dic['controller'],
                      ),
                      Text(_enableBtn.toString()),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: assetDic['amount'],
                          labelText:
                              '${assetDic['amount']} (${dic['bonded']}: ${Fmt.priceFloor(
                            bonded,
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
                          if (double.parse(v.trim()) > bonded) {
                            return assetDic['amount.low'];
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: RoundedButton(
                  text: I18n.of(context).home['submit.tx'],
                  onPressed: _enableBtn
                      ? () {
                          if (_formKey.currentState.validate()) {
                            var args = {
                              "title": dic['action.unbond'],
                              "txInfo": {
                                "module": 'staking',
                                "call": 'unbond',
                              },
                              "detail": jsonEncode({
                                "amount": _amountCtrl.text.trim(),
                              }),
                              "params": [
                                // "amount"
                                (double.parse(_amountCtrl.text.trim()) *
                                        pow(10, decimals))
                                    .toStringAsFixed(0),
                              ],
                              'onFinish':
                                  (BuildContext txPageContext, Map res) {
                                Navigator.popUntil(
                                    txPageContext, ModalRoute.withName('/my'));
                                globalBondingRefreshKey.currentState.show();
                              }
                            };
                            Navigator.of(context).pushNamed(TxConfirmPage.route,
                                arguments: args);
                          }
                        }
                      : null,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
