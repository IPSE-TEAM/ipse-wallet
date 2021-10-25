import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ipsewallet/pages/my/contacts/contact_list_page.dart';
import 'package:ipsewallet/pages/my/mortgage/mortgage.dart';
import 'package:ipsewallet/pages/my/tx_confirm_page.dart';
import 'package:ipsewallet/service/substrate_api/api.dart';
import 'package:ipsewallet/store/account/types/accountData.dart';
import 'package:ipsewallet/store/app.dart';
import 'package:ipsewallet/utils/UI.dart';
import 'package:ipsewallet/utils/adapt.dart';
import 'package:ipsewallet/utils/format.dart';
import 'package:ipsewallet/utils/i18n/index.dart';
import 'package:ipsewallet/widgets/my_appbar.dart';
import 'package:ipsewallet/widgets/rounded_button.dart';

class ChangeRewardAddress extends StatefulWidget {
  ChangeRewardAddress(this.appStore);
  static String route = "/my/ChangeRewardAddress";
  final AppStore appStore;
  @override
  _ChangeRewardAddressState createState() =>
      _ChangeRewardAddressState(appStore);
}

class _ChangeRewardAddressState extends State<ChangeRewardAddress> {
  _ChangeRewardAddressState(this.store);
  final AppStore store;

  final Api api = webApi;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _rewardAddressCtrl = new TextEditingController();


  bool _enableBtn = false;

  Future<void> _onSave() async {
    if (_formKey.currentState.validate()) {
      String rewardAddress = _rewardAddressCtrl.text.trim();

      var args = {
        "title": I18n.of(context).ipse['change_reward_address'],
        "txInfo": {
          "module": 'pocStaking',
          "call": 'updateRewardDest',
        },
        "detail": jsonEncode({
          "dest": rewardAddress,
        }),
        "params": [rewardAddress],
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
    _rewardAddressCtrl.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Map dic = I18n.of(context).ipse;
    return Scaffold(
      appBar: myAppBar(context, I18n.of(context).ipse['change_reward_address']),
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
                        hintText: dic['reward_address'],
                        labelText: dic['reward_address'],
                        suffix: GestureDetector(
                          child: Image.asset(
                              'assets/images/a/my-accountmanage.png'),
                          onTap: () async {
                            var to = await Navigator.of(context)
                                .pushNamed(ContactListPage.route);
                            if (to != null) {
                              setState(() {
                                _rewardAddressCtrl.text =
                                    (to as AccountData).address;
                              });
                            }
                          },
                        ),
                      ),
                      controller: _rewardAddressCtrl,
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
