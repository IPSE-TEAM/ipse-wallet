import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ipsewallet/config/config.dart';
import 'package:ipsewallet/pages/my/manage_account/export_account.dart';
import 'package:ipsewallet/utils/i18n/index.dart';
import 'package:ipsewallet/utils/my_utils.dart';
import 'package:ipsewallet/widgets/my_appbar.dart';

class ExportResult extends StatelessWidget {
  static final String route = '/my/manageAccount/key';

  
  @override
  Widget build(BuildContext context) {
    final Map<String, String> dic = I18n.of(context).profile;
    final Map args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: myAppBar(context, dic['export']),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(16),
                children: <Widget>[
                  args['type'] == ExportAccount.exportTypeKeystore
                      ? Container()
                      : Text(dic['export.warn']),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      RaisedButton(
                        elevation: 0,
                        color: Config.themeColor,
                        child: Text(
                          I18n.of(context).my['copy'],
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          copy(context, args['key']);
                        },
                      )
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.black12,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(4))),
                    padding: EdgeInsets.all(16),
                    child: Text(
                      args['key'],
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
