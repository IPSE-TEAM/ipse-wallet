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

class ChangeDiskInfo extends StatefulWidget {
  ChangeDiskInfo(this.appStore);
  static String route = "/my/ChangeDiskInfo";
  final AppStore appStore;
  @override
  _ChangeDiskInfoState createState() => _ChangeDiskInfoState(appStore);
}

class _ChangeDiskInfoState extends State<ChangeDiskInfo> {
  _ChangeDiskInfoState(this.store);
  final AppStore store;

  final Api api = webApi;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _sizeCtrl = new TextEditingController();

  final FocusNode _sizeNode = FocusNode();

  bool _enableBtn = false;

  Future<void> _onSave() async {
    if (_formKey.currentState.validate()) {
      var args = {
        "title": I18n.of(context).ipse['plot_disk_space'],
        "txInfo": {
          "module": 'pocStaking',
          "call": 'updatePlotSize',
        },
        "detail": jsonEncode({
          "plot_size": _sizeCtrl.text.trim(),
        }),
        "params": [_sizeCtrl.text.trim()],
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
    _sizeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Map dic = I18n.of(context).ipse;
    return Scaffold(
      appBar: myAppBar(context, I18n.of(context).ipse['plot_disk_space']),
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
                        hintText: dic['plot_disk_space'] + dic['unit_G'],
                        suffixText: "G",
                      ),
                      maxLength: 9,
                      onChanged: (v) {
                        if (v.trim().startsWith("0")) {
                          WidgetsBinding.instance
                              .addPostFrameCallback((_) => _sizeCtrl.clear());
                        }
                      },
                      validator: (v) {
                        return v.trim().length > 0
                            ? null
                            : I18n.of(context).home['required'];
                      },
                      focusNode: _sizeNode,
                      onFieldSubmitted: (v) {
                        if (_enableBtn) {
                          _onSave();
                        }
                      },
                      textInputAction: TextInputAction.next,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                      ],
                      keyboardType: TextInputType.phone,
                      controller: _sizeCtrl,
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
