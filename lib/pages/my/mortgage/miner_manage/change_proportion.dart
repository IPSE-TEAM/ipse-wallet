import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ipsewallet/pages/my/mortgage/mortgage.dart';
import 'package:ipsewallet/pages/my/tx_confirm_page.dart';
import 'package:ipsewallet/service/substrate_api/api.dart';
import 'package:ipsewallet/store/app.dart';
import 'package:ipsewallet/utils/UI.dart';
import 'package:ipsewallet/utils/adapt.dart';
import 'package:ipsewallet/utils/i18n/index.dart';
import 'package:ipsewallet/widgets/my_appbar.dart';
import 'package:ipsewallet/widgets/rounded_button.dart';

class ChangeProportion extends StatefulWidget {
  ChangeProportion(this.appStore);
  static String route = "/my/ChangeProportion";
  final AppStore appStore;
  @override
  _ChangeProportionState createState() => _ChangeProportionState(appStore);
}

class _ChangeProportionState extends State<ChangeProportion> {
  _ChangeProportionState(this.store);
  final AppStore store;

  final Api api = webApi;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _proportionCtrl = new TextEditingController();

  final FocusNode _proportionNode = FocusNode();
  bool _enableBtn = false;

  Future<void> _onSave() async {
    if (_formKey.currentState.validate()) {
      int proportion = int.tryParse(_proportionCtrl.text);
      var args = {
        "title": I18n.of(context).ipse['commission'],
        "txInfo": {
          "module": 'pocStaking',
          "call": 'updateProportion',
        },
        "detail": jsonEncode({
          "proportion": proportion,
        }),
        "params": [proportion],
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
    _proportionCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Map dic = I18n.of(context).ipse;
    return Scaffold(
      appBar: myAppBar(context, I18n.of(context).ipse['commission']),
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
                    TextFormField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        fillColor: Colors.white,
                        filled: true,
                        hintText: dic['commission'],
                        suffixText: '%',
                      ),
                      focusNode: _proportionNode,
                      onFieldSubmitted: (v) {
                        if (_enableBtn) {
                          _onSave();
                        }
                      },
                      validator: (v) {
                        if (v.trim().isEmpty) {
                          return I18n.of(context).home['required'];
                        }
                        if (int.parse(v.trim()) > 100) {
                          return dic['exceed100'];
                        }
                        return v.trim().length > 0
                            ? null
                            : I18n.of(context).home['required'];
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                      ],
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.done,
                      controller: _proportionCtrl,
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
  }
}
