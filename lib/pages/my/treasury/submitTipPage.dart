import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ipsewallet/common/address_form_item.dart';
import 'package:ipsewallet/pages/my/contacts/contact_list_page.dart';
import 'package:ipsewallet/pages/my/treasury/treasuryPage.dart';
import 'package:ipsewallet/pages/my/tx_confirm_page.dart';
import 'package:ipsewallet/store/account/types/accountData.dart';
import 'package:ipsewallet/store/app.dart';
import 'package:ipsewallet/utils/UI.dart';
import 'package:ipsewallet/utils/format.dart';
import 'package:ipsewallet/utils/i18n/index.dart';
import 'package:ipsewallet/widgets/my_appbar.dart';
import 'package:ipsewallet/widgets/rounded_button.dart';

class SubmitTipPage extends StatefulWidget {
  SubmitTipPage(this.store);

  static const String route = '/gov/treasury/tip/add';

  final AppStore store;

  @override
  _SubmitTipPageState createState() => _SubmitTipPageState();
}

class _SubmitTipPageState extends State<SubmitTipPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountCtrl = new TextEditingController();
  final TextEditingController _reasonCtrl = new TextEditingController();
  static const MAX_REASON_LEN = 128;
  static const MIN_REASON_LEN = 5;

  AccountData _beneficiary;

  Future<void> _onSubmit() async {
    if (_formKey.currentState.validate()) {
      var dic = I18n.of(context).gov;
      final int decimals = widget.store.settings.networkState.tokenDecimals;
      final bool isCouncil = ModalRoute.of(context).settings.arguments;
      final String amt = _amountCtrl.text.trim();
      final String address = Fmt.addressOfAccount(_beneficiary, widget.store);
      var args = {
        "title": isCouncil ? dic['treasury.tipNew'] : dic['treasury.report'],
        "txInfo": {
          "module": 'treasury',
          "call": isCouncil ? 'tipNew' : 'reportAwesome',
        },
        "detail": jsonEncode(isCouncil
            ? {
                "beneficiary": address,
                "reason": _reasonCtrl.text.trim(),
                "value": amt,
              }
            : {
                "beneficiary": address,
                "reason": _reasonCtrl.text.trim(),
              }),
        "params": isCouncil
            ? [
                // "reason"
                _reasonCtrl.text.trim(),
                // "beneficiary"
                address,
                // "value"
                Fmt.tokenInt(amt, decimals).toString(),
              ]
            : [
                // "reason"
                _reasonCtrl.text.trim(),
                // "beneficiary"
                address,
              ],
        'onFinish': (BuildContext txPageContext, Map res) {
          Navigator.popUntil(
              txPageContext, ModalRoute.withName(TreasuryPage.route));
        }
      };
      Navigator.of(context).pushNamed(TxConfirmPage.route, arguments: args);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _beneficiary = widget.store.account.currentAccount;
      });
    });
  }

  @override
  void dispose() {
    _reasonCtrl.dispose();
    _amountCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Map dic = I18n.of(context).gov;
    final Map dicAsset = I18n.of(context).assets;
    final int decimals = widget.store.settings.networkState.tokenDecimals;
    final String symbol = widget.store.settings.networkState.tokenSymbol;
    final bool isCouncil = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: myAppBar(context,  dic[isCouncil ? 'treasury.tipNew' : 'treasury.report']),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: _beneficiary == null
                  ? Container()
                  : ListView(
                      padding: EdgeInsets.all(16),
                      children: <Widget>[
                        AddressFormItem(
                          _beneficiary,
                          label: dic['treasury.beneficiary'],
                          onTap: () async {
                            final acc = await Navigator.of(context)
                                .pushNamed(ContactListPage.route);
                            if (acc != null) {
                              setState(() {
                                _beneficiary = acc;
                              });
                            }
                          },
                        ),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                decoration: InputDecoration(
                                  hintText: dic['treasury.reason'],
                                  labelText: dic['treasury.reason'],
                                ),
                                controller: _reasonCtrl,
                                maxLines: 3,
                                validator: (v) {
                                  final String reason = v.trim();
                                  if (reason.length < MIN_REASON_LEN ||
                                      reason.length > MAX_REASON_LEN) {
                                    return I18n.of(context)
                                        .home['input.invalid'];
                                  }
                                  return null;
                                },
                              ),
                              isCouncil
                                  ? TextFormField(
                                      decoration: InputDecoration(
                                        hintText: dicAsset['amount'],
                                        labelText:
                                            '${dicAsset['amount']} ($symbol)',
                                      ),
                                      inputFormatters: [
                                        UI.decimalInputFormatter(decimals)
                                      ],
                                      controller: _amountCtrl,
                                      keyboardType:
                                          TextInputType.numberWithOptions(
                                              decimal: true),
                                      validator: (v) {
                                        if (v.isEmpty) {
                                          return dicAsset['amount.error'];
                                        }
                                        return null;
                                      },
                                    )
                                  : Container(),
                            ],
                          ),
                        )
                      ],
                    ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: RoundedButton(
                text: dic['treasury.submit'],
                onPressed: _onSubmit,
              ),
            )
          ],
        ),
      ),
    );
  }
}
