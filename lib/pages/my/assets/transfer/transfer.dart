import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:ipsewallet/common/reg_input_formatter.dart';
import 'package:ipsewallet/pages/my/contacts/contact_list_page.dart';
import 'package:ipsewallet/pages/my/scan_page.dart';
import 'package:ipsewallet/pages/my/tx_confirm_page.dart';
import 'package:ipsewallet/store/account/types/accountData.dart';
import 'package:ipsewallet/store/app.dart';
import 'package:ipsewallet/utils/format.dart';
import 'package:ipsewallet/utils/i18n/index.dart';
import 'package:ipsewallet/utils/my_utils.dart';
import 'package:ipsewallet/widgets/my_appbar.dart';
import 'package:ipsewallet/widgets/rounded_button.dart';

class TransferPageParams {
  TransferPageParams({
    this.symbol,
    this.address,
    this.redirect,
  });
  final String address;
  final String redirect;
  final String symbol;
}

class TransferPage extends StatefulWidget {
  const TransferPage(this.store);

  static final String route = '/my/assets/transfer';
  final AppStore store;

  @override
  _TransferPageState createState() => _TransferPageState(store);
}

class _TransferPageState extends State<TransferPage> {
  _TransferPageState(this.store);

  final AppStore store;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _addressCtrl = new TextEditingController();
  final TextEditingController _amountCtrl = new TextEditingController();

  String _tokenSymbol;
  bool _enableBtn = false;

  void _handleSubmit() {
    if (_formKey.currentState.validate()) {
      String symbol = _tokenSymbol ?? store.settings.networkState.tokenSymbol;
      int decimals = store.settings.networkState.tokenDecimals;
      var args = {
        "title": I18n.of(context).assets['transfer'] + ' $symbol',
        "txInfo": {
          "module": 'balances',
          "call": 'transfer',
        },
        "detail": jsonEncode({
          "destination": _addressCtrl.text.trim(),
          "amount": _amountCtrl.text.trim(),
        }),
        "params": [
          // params.to
          _addressCtrl.text.trim(),
          // params.amount
          Fmt.tokenInt(_amountCtrl.text.trim(), decimals).toString(),
        ],
      };

      args['onFinish'] = (BuildContext txPageContext, Map res) {
        final TransferPageParams routeArgs =
            ModalRoute.of(context).settings.arguments;

        Navigator.popUntil(
            txPageContext, ModalRoute.withName(routeArgs.redirect));
      };
      Navigator.of(context).pushNamed(TxConfirmPage.route, arguments: args);
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final TransferPageParams args = ModalRoute.of(context).settings.arguments;
      if (args.address != null) {
        setState(() {
          _addressCtrl.text = args.address;
        });
      }
      if (args.symbol != null) {
        setState(() {
          _tokenSymbol = args.symbol;
        });
      }
    });
  }

  @override
  void dispose() {
    _addressCtrl.dispose();
    _amountCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        final Map<String, String> dic = I18n.of(context).assets;
        String baseTokenSymbol = store.settings.networkState.tokenSymbol;
        String symbol = _tokenSymbol ?? baseTokenSymbol;
        final bool isBaseToken = _tokenSymbol == baseTokenSymbol;

        List symbolOptions = store.settings.networkConst['currencyIds'];

        int decimals = store.settings.networkState.tokenDecimals;

        BigInt available = isBaseToken
            ? store.assets.balances[symbol].transferable
            : Fmt.balanceInt(store.assets.tokenBalances[symbol]);

        return Scaffold(
          appBar: myAppBar(context, dic['transfer'], actions: <Widget>[
            IconButton(
              icon: Image.asset('assets/images/a/scan.png'),
              onPressed: () async {
                try {
                  var to = await Navigator.pushNamed(context, ScanPage.route);
                  if (to != null) {
                    _addressCtrl.text = to.toString();
                  }
                } catch (e) {
                  if (e is PlatformException) {
                    showErrorMsg(I18n.of(context).my['noCamaraPremission']);
                  }
                }
              },
            )
          ]),
          body: SafeArea(
            child: Builder(
              builder: (BuildContext context) {
                return Column(
                  children: <Widget>[
                    Expanded(
                      child: Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onChanged: () => setState(() =>
                            _enableBtn = _formKey.currentState.validate()),
                        child: ListView(
                          padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                          children: <Widget>[
                            // Text(dic['address']),
                            TextFormField(
                              decoration: InputDecoration(
                                hintText: dic['address'],
                                labelText: dic['address'],
                                suffix: GestureDetector(
                                  child: Image.asset(
                                      'assets/images/a/my-accountmanage.png'),
                                  onTap: () async {
                                    var to = await Navigator.of(context)
                                        .pushNamed(ContactListPage.route);
                                    if (to != null) {
                                      setState(() {
                                        _addressCtrl.text =
                                            (to as AccountData).address;
                                      });
                                    }
                                  },
                                ),
                              ),
                              controller: _addressCtrl,
                              validator: (v) {
                                if (v.trim().isEmpty) {
                                  return I18n.of(context).home['required'];
                                }
                                return Fmt.isAddress(v.trim())
                                    ? null
                                    : dic['address.error'];
                              },
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                hintText: dic['amount'],
                                labelText:
                                    '${dic['amount']} (${dic['balance']}: ${Fmt.token(available, decimals)})',
                              ),
                              inputFormatters: [
                                RegExInputFormatter.withRegex(
                                    '^[0-9]{0,6}(\\.[0-9]{0,$decimals})?\$')
                              ],
                              controller: _amountCtrl,
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
                              validator: (v) {
                                if (v.isEmpty) {
                                  return dic['amount.error'];
                                }
                                if (double.parse(v.trim()) >=
                                    available / BigInt.from(pow(10, decimals)) -
                                        0.001) {
                                  return dic['amount.low'];
                                }
                                return null;
                              },
                            ),

                            Padding(
                              padding: EdgeInsets.only(top: 16),
                              child: Text(
                                  'existentialDeposit: ${store.settings.existentialDeposit} $baseTokenSymbol',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black54)),
                            ),

                            Padding(
                              padding: EdgeInsets.only(top: 16),
                              child: Text(
                                  'transactionByteFee: ${store.settings.transactionByteFee} $baseTokenSymbol',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black54)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(16),
                      child: RoundedButton(
                        text: I18n.of(context).assets['make'],
                        onPressed: _enableBtn ? _handleSubmit : null,
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
