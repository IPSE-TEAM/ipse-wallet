import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:ipsewallet/config/config.dart';
import 'package:ipsewallet/pages/my/claim/claim_record.dart';
import 'package:ipsewallet/pages/my/my.dart';
import 'package:ipsewallet/pages/my/tx_confirm_page.dart';
import 'package:ipsewallet/store/app.dart';
import 'package:ipsewallet/utils/adapt.dart';
import 'package:ipsewallet/utils/format.dart';
import 'package:ipsewallet/utils/i18n/index.dart';
import 'package:ipsewallet/utils/my_utils.dart';
import 'package:ipsewallet/widgets/my_appbar.dart';
import 'package:ipsewallet/widgets/rounded_button.dart';

class Claim extends StatefulWidget {
  Claim(this.store);

  static final String route = '/my/claim';
  final AppStore store;
  @override
  _ClaimState createState() => _ClaimState(store);
}

class _ClaimState extends State<Claim> {
  _ClaimState(this.store);

  final AppStore store;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _txCtrl = new TextEditingController();
  bool _enableBtn = false;
  // int _claimStopTime;

  Future<void> _submit() async {
    if (_formKey.currentState.validate()) {
      String tx = "0x" + _txCtrl.text.trim();

      var args = {
        "title": I18n.of(context).ipse['claim'],
        "txInfo": {
          "module": 'exchange',
          "call": 'exchange',
        },
        "detail": jsonEncode({
          "tx": tx,
        }),
        "params": [tx],
        'onFinish': (BuildContext txPageContext, Map res) {
          Navigator.popUntil(txPageContext, ModalRoute.withName(My.route));
        }
      };
      Navigator.of(context).pushNamed(TxConfirmPage.route, arguments: args);
    }
  }

  // Future _getClaimStopTime() async {
  //   int time = await webApi.ipse.fetchIpseClaimStopTime();
  //   if (time != null && mounted) {
  //     setState(() {
  //       _claimStopTime = time;
  //     });
  //   }
  // }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _txCtrl.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Map dic = I18n.of(context).ipse;
    return Observer(builder: (_) {
      int blockDuration =
          store.settings.networkConst['babe']['expectedBlockTime'];

      return Scaffold(
        appBar: myAppBar(context, dic['claim'], actions: [
          IconButton(
            icon: Icon(Icons.list_alt_rounded),
            iconSize: 18,
            color: Colors.grey,
            onPressed: () {
              Navigator.of(context).pushNamed(ClaimRecord.route);
            },
          )
        ]),
        body: Form(
                child: 
                // _claimStopTime > store.ipse.newHeads.number? 
                    Column(
                        children: <Widget>[
                          Expanded(
                            child: Form(
                              key: _formKey,
                              onChanged: () => setState(() => _enableBtn =
                                  _formKey.currentState.validate()),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: Adapt.px(30),
                                ),
                                child: ListView(
                                  children: <Widget>[
                                    Text(
                                      I18n.of(context).ipse['claim_steps'],
                                      style: TextStyle(
                                          fontSize: Adapt.px(34),
                                          color: Config.color333),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      I18n.of(context).ipse['claim_1'],
                                      style: TextStyle(
                                          fontSize: Adapt.px(24),
                                          color: Config.color666),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 15),
                                      child: GestureDetector(
                                        onTap: () =>
                                            copy(context, Config.eosAddr),
                                        child: Container(
                                          padding:
                                              EdgeInsets.symmetric(vertical: 8),
                                          child: Row(
                                            children: [
                                              Text(
                                                Config.eosAddr,
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                ),
                                              ),
                                              SizedBox(width: 4),
                                              Image.asset(
                                                'assets/images/a/copy.png',
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                       padding: const EdgeInsets.only(left: 15),
                                      child: Text(
                                        I18n.of(context).ipse['claim_3'],
                                        style: TextStyle(
                                            fontSize: Adapt.px(24),
                                            color: Config.errorColor),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 15),
                                      child: GestureDetector(
                                        onTap: () => copy(context,
                                            store.account.currentAddress),
                                        child: Container(
                                          padding:
                                              EdgeInsets.symmetric(vertical: 8),
                                          child: Row(
                                            children: [
                                              Text(
                                                Fmt.address(
                                                    store.account.currentAddress),
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                ),
                                              ),
                                              SizedBox(width: 4),
                                              Image.asset(
                                                'assets/images/a/copy.png',
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      I18n.of(context).ipse['claim_4'],
                                      style: TextStyle(
                                          fontSize: Adapt.px(24),
                                          color: Config.errorColor),
                                    ),
                                    Text(
                                      I18n.of(context).ipse['claim_5'],
                                      style: TextStyle(
                                          fontSize: Adapt.px(24),
                                          color: Config.color666),
                                    ),
                                    Text(
                                      I18n.of(context).ipse['claim_6'],
                                      style: TextStyle(
                                          fontSize: Adapt.px(24),
                                          color: Config.color666),
                                    ),
                                    // Text(
                                    //   I18n.of(context).ipse['claim_7'],
                                    //   style: TextStyle(
                                    //       fontSize: Adapt.px(24),
                                    //       color: Config.color666),
                                    // ),
                                    // Container(
                                    //   height: Adapt.px(134),
                                    //   padding: EdgeInsets.only(top: 10),
                                    //   child: Text(
                                    //     Fmt.blockToTime(
                                    //         _claimStopTime -
                                    //             store.ipse.newHeads.number,
                                    //         blockDuration),
                                    //     style: TextStyle(
                                    //         fontSize: Adapt.px(54),
                                    //         color: Config.color333),
                                    //   ),
                                    // ),
                                    SizedBox(height: 20,),
                                    TextFormField(
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        fillColor: Colors.white,
                                        filled: true,
                                        hintText: dic['tx'],
                                      ),
                                      maxLength: 64,
                                      controller: _txCtrl,
                                      validator: (v) {
                                        String tx = v.trim();
                                        if (tx.length == 0) {
                                          return I18n.of(context)
                                              .home['required'];
                                        }
                                        if (!RegExp(r"[0-9a-zA-Z]{64}")
                                            .hasMatch(tx)) {
                                          return dic['tx_error'];
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(16),
                            child: RoundedButton(
                              text: dic['submit'],
                              onPressed: _enableBtn ? _submit : null,
                            ),
                          ),
                        ],
                      )
                    // : Padding(
                    //     padding: const EdgeInsets.fromLTRB(15, 58.0, 15, 15),
                    //     child: Text(
                    //       I18n.of(context).ipse['finishClaimTip'],
                    //       style: TextStyle(
                    //           fontSize: Adapt.px(34), color: Config.color666),
                    //     ),
                    //   ),
              )
            // : Center(child: LoadingWidget()),
      );
    });
  }
}
