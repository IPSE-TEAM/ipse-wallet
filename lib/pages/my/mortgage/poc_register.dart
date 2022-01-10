import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ipsewallet/config/config.dart';
import 'package:ipsewallet/pages/my/mortgage/mortgage.dart';
import 'package:ipsewallet/pages/my/tx_confirm_page.dart';
import 'package:ipsewallet/service/substrate_api/api.dart';
import 'package:ipsewallet/store/app.dart';
import 'package:ipsewallet/utils/UI.dart';
import 'package:ipsewallet/utils/adapt.dart';
import 'package:ipsewallet/utils/i18n/index.dart';
import 'package:ipsewallet/widgets/my_appbar.dart';
import 'package:ipsewallet/widgets/rounded_button.dart';
import 'package:url_launcher/url_launcher.dart';

class PocRegister extends StatefulWidget {
  PocRegister(this.appStore);
  static String route = "/my/PocRegister";
  final AppStore appStore;
  @override
  _PocRegisterState createState() => _PocRegisterState(appStore);
}

class _PocRegisterState extends State<PocRegister> {
  _PocRegisterState(this.store);
  final AppStore store;

  final Api api = webApi;
  // BigInt kib;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _sizeCtrl = new TextEditingController();
  final TextEditingController _pidCtrl = new TextEditingController();
  final TextEditingController _proportionCtrl = new TextEditingController();
  final FocusNode _sizeNode = FocusNode();
  final FocusNode _pidNode = FocusNode();
  final FocusNode _proportionNode = FocusNode();
  bool _enableBtn = false;

  Future<void> _onSave() async {
    if (_formKey.currentState.validate()) {
      String pid = _pidCtrl.text.trim();
      int proportion = int.tryParse(_proportionCtrl.text);
      String address = store.account.currentAddress;
      var args = {
        "title": 'PoC '+I18n.of(context).ipse['miner_register'],
        "txInfo": {
          "module": 'pocStaking',
          "call": 'register',
        },
        "detail": jsonEncode({
          "plot_size": _sizeCtrl.text.trim(),
          "numeric_id": pid,
          "miner_proportion": proportion,
          "reward_dest": address,
        }),
        "params": [_sizeCtrl.text.trim(), pid, proportion, address],
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
    _pidCtrl.dispose();
    _proportionCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Map dic = I18n.of(context).ipse;
    return Scaffold(
      appBar: myAppBar(context,'PoC '+ I18n.of(context).ipse['miner_register']),
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
                        _pidNode.requestFocus();
                      },
                      textInputAction: TextInputAction.next,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                      ],
                      keyboardType: TextInputType.phone,
                      controller: _sizeCtrl,
                    ),
                    SizedBox(
                      height: 15,
                    ),
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
                      maxLength: 19,
                      focusNode: _pidNode,
                      onFieldSubmitted: (v) {
                        _proportionNode.requestFocus();
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                      ],
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      controller: _pidCtrl,
                    ),
                    SizedBox(
                      height: 15,
                    ),
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
                    SizedBox(
                      height: 15,
                    ),
                    TextButton(
                      onPressed: () async {
                        String url = Config.tutorialUrl;
                        if (await canLaunch(url)) {
                          await launch(url);
                        }
                      },
                      child: Text(I18n.of(context).ipse["View_tutorial"]),
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
