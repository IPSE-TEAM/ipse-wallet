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

class ChangePID extends StatefulWidget {
  ChangePID(this.appStore);
  static String route = "/my/ChangePID";
  final AppStore appStore;
  @override
  _ChangePIDState createState() => _ChangePIDState(appStore);
}

class _ChangePIDState extends State<ChangePID> {
  _ChangePIDState(this.store);
  final AppStore store;

  final Api api = webApi;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _pidCtrl = new TextEditingController();

  final FocusNode _pidNode = FocusNode();

  bool _enableBtn = false;

  Future<void> _onSave() async {
    if (_formKey.currentState.validate()) {
      String pid = _pidCtrl.text.trim();

      var args = {
        "title": I18n.of(context).ipse['plot_disk_id'],
        "txInfo": {
          "module": 'pocStaking',
          "call": 'updateNumericId',
        },
        "detail": jsonEncode({
          "numeric_id": pid,
        }),
        "params": [pid],
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
    _pidCtrl.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Map dic = I18n.of(context).ipse;
    return Scaffold(
      appBar: myAppBar(context, I18n.of(context).ipse['plot_disk_id']),
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
                        hintText: dic['plot_disk_id'],
                        suffixIcon: IconButton(
                          iconSize: 18,
                          icon: Icon(
                            CupertinoIcons.clear_thick_circled,
                            color: Theme.of(context).unselectedWidgetColor,
                          ),
                          onPressed: () {
                            WidgetsBinding.instance
                                .addPostFrameCallback((_) => _pidCtrl.clear());
                          },
                        ),
                      ),
                      onChanged: (v) {
                        if (v.trim().startsWith("0")) {
                          WidgetsBinding.instance
                              .addPostFrameCallback((_) => _pidCtrl.clear());
                        }
                      },
                      validator: (v) {
                        return v.trim().length > 0
                            ? null
                            : I18n.of(context).home['required'];
                      },
                      focusNode: _pidNode,
                      onFieldSubmitted: (v) {
                        if (_enableBtn) {
                          _onSave();
                        }
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                      ],
                       maxLength: 19,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.done,
                      controller: _pidCtrl,
                    ),
                    SizedBox(
                      height: 15,
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
