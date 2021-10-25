import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ipsewallet/common/address_form_item.dart';
import 'package:ipsewallet/pages/my/staking/actions/accountSelectPage.dart';
import 'package:ipsewallet/pages/my/tx_confirm_page.dart';
import 'package:ipsewallet/store/account/types/accountData.dart';
import 'package:ipsewallet/store/app.dart';
import 'package:ipsewallet/utils/UI.dart';
import 'package:ipsewallet/utils/format.dart';
import 'package:ipsewallet/utils/i18n/index.dart';
import 'package:ipsewallet/widgets/my_appbar.dart';
import 'package:ipsewallet/widgets/rounded_button.dart';

class SetControllerPage extends StatefulWidget {
  SetControllerPage(this.store);
  static final String route = '/staking/controller';
  final AppStore store;
  @override
  _SetControllerPageState createState() => _SetControllerPageState(store);
}

class _SetControllerPageState extends State<SetControllerPage> {
  _SetControllerPageState(this.store);
  final AppStore store;

  AccountData _controller;

  void _onSubmit(BuildContext context) {
    var currentController = ModalRoute.of(context).settings.arguments;
    if (currentController != null &&
        _controller.pubKey == (currentController as AccountData).pubKey) {
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Container(),
            content: Text(I18n.of(context).staking['controller.warn']),
            actions: <Widget>[
              CupertinoButton(
                child: Text(I18n.of(context).home['ok']),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );
      return;
    }

    String address = Fmt.addressOfAccount(_controller, store);
    Map<String, dynamic> args = {
      "title": I18n.of(context).staking['action.control'],
      "txInfo": {
        "module": 'staking',
        "call": 'setController',
      },
      "detail": jsonEncode({"controllerId": address}),
      "params": [address],
      'onFinish': (BuildContext txPageContext, Map res) {
        Navigator.popUntil(txPageContext, ModalRoute.withName('/my'));
        globalBondingRefreshKey.currentState.show();
      }
    };
    Navigator.of(context).pushNamed(TxConfirmPage.route, arguments: args);
  }

  Future<void> _changeControllerId(BuildContext context) async {
    var acc = await Navigator.of(context).pushNamed(AccountSelectPage.route);
    if (acc != null) {
      setState(() {
        _controller = acc;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_controller == null) {
      var acc = ModalRoute.of(context).settings.arguments;
      setState(() {
        _controller = acc;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, String> dic = I18n.of(context).staking;

    return Scaffold(
      appBar: myAppBar(context, '${dic['action.control']}'),
      body: Builder(builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  padding: EdgeInsets.all(16),
                  children: <Widget>[
                    AddressFormItem(
                      store.account.currentAccount,
                      label: dic['stash'],
                    ),
                    AddressFormItem(
                      _controller ?? store.account.currentAccount,
                      label: dic['controller'],
                      onTap: () => _changeControllerId(context),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: RoundedButton(
                  text: I18n.of(context).home['submit.tx'],
                  onPressed: () => _onSubmit(context),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
