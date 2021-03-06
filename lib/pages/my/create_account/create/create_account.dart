import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ipsewallet/pages/my/create_account/create/backup_account.dart';
import 'package:ipsewallet/pages/my/create_account/create/create_account_form.dart';
import 'package:ipsewallet/utils/i18n/index.dart';
import 'package:ipsewallet/widgets/my_appbar.dart';
import 'package:ipsewallet/widgets/rounded_button.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage(this.setNewAccount);

  static final String route = '/my/createAccount/create';
  final Function setNewAccount;

  @override
  _CreateAccountPageState createState() =>
      _CreateAccountPageState(setNewAccount);
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  _CreateAccountPageState(this.setNewAccount);

  final Function setNewAccount;

  int _step = 1;

  void _onFinish() {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Container(),
          content: Column(
            children: <Widget>[
              
              Container(
                padding: EdgeInsets.only(top: 16, bottom: 24),
                child: Text(
                  I18n.of(context).account['create.warn9'],
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
              Text(I18n.of(context).account['create.warn10']),
            ],
          ),
          actions: <Widget>[
            CupertinoButton(
              child: Text(I18n.of(context).home['cancel']),
              onPressed: () => Navigator.of(context).pop(),
            ),
            CupertinoButton(
              child: Text(I18n.of(context).home['ok']),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, BackupAccountPage.route);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildStep2(BuildContext context) {
    var theme = Theme.of(context).textTheme;
    final Map<String, String> i18n = I18n.of(context).account;

    return Scaffold(
      appBar: AppBar(
        title: Text(I18n.of(context).home['create']),
         centerTitle: true,
        leading: IconButton(
          icon: Image.asset('assets/images/a/back.png'),
          onPressed: () {
            setState(() {
              _step = 1;
            });
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(16),
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(bottom: 16),
                    child: Text(i18n['create.warn1'], style: theme.headline4),
                  ),
                  Text(i18n['create.warn2']),
                  Container(
                    padding: EdgeInsets.only(bottom: 16, top: 32),
                    child: Text(i18n['create.warn3'], style: theme.headline4),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Text(i18n['create.warn4']),
                  ),
                  Text(i18n['create.warn5']),
                  Container(
                    padding: EdgeInsets.only(bottom: 16, top: 32),
                    child: Text(i18n['create.warn6'], style: theme.headline4),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Text(i18n['create.warn7']),
                  ),
                  Text(i18n['create.warn8']),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              child: RoundedButton(
                text: I18n.of(context).home['next'],
                onPressed: _onFinish,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_step == 2) {
      return _buildStep2(context);
    }
    return Scaffold(
      appBar:myAppBar(context, I18n.of(context).home['create']),
      body: SafeArea(
        child: CreateAccountForm(
          setNewAccount: setNewAccount,
          submitting: false,
          onSubmit: () {
            setState(() {
              _step = 2;
            });
          },
        ),
      ),
    );
  }
}
