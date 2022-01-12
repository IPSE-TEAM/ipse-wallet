import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ipsewallet/config/config.dart';
import 'package:ipsewallet/pages/my/create_account/create/create_account.dart';
import 'package:ipsewallet/pages/my/create_account/import/import_account.dart';
import 'package:ipsewallet/utils/adapt.dart';
import 'package:ipsewallet/utils/i18n/index.dart';
import 'package:ipsewallet/widgets/my_appbar.dart';
import 'package:ipsewallet/widgets/rounded_button.dart';

class CreateAccountEntryPage extends StatelessWidget {
  static final String route = '/my/createAccount/entry';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(context, I18n.of(context).home['create']),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Container(
                  width: Adapt.px(400),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: Adapt.px(150),
                      ),
                      Image.asset('assets/images/app.png',
                          width: Adapt.px(160)),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'IPSE 2.0',
                        style: TextStyle(fontSize: Adapt.px(36)),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: RoundedButton(
                          round: true,
                          text: I18n.of(context).home['create'],
                          onPressed: () {
                            Navigator.pushNamed(
                                context, CreateAccountPage.route);
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                        child: RoundedButton(
                          round: true,
                          color: Config.secondColor,
                          text: I18n.of(context).home['import'],
                          onPressed: () {
                            Navigator.pushNamed(
                                context, ImportAccountPage.route);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(8),
                child: Column(
                  children: <Widget>[
                    Text(
                      I18n.of(context).ipse['appDesc1'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Config.color999, fontSize: Adapt.px(27)),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      I18n.of(context).ipse['appDesc2'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Config.color999, fontSize: Adapt.px(27)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
