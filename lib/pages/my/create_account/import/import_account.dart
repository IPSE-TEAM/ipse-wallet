import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ipsewallet/pages/my/create_account/create/create_account_form.dart';
import 'package:ipsewallet/pages/my/create_account/import/import_account_form.dart';
import 'package:ipsewallet/pages/my/my.dart';

import 'package:ipsewallet/service/substrate_api/api.dart';
import 'package:ipsewallet/store/app.dart';
import 'package:ipsewallet/utils/UI.dart';
import 'package:ipsewallet/utils/format.dart';
import 'package:ipsewallet/utils/i18n/index.dart';
import 'package:ipsewallet/utils/loading.dart';
import 'package:ipsewallet/widgets/my_appbar.dart';

class ImportAccountPage extends StatefulWidget {
  const ImportAccountPage(this.store);

  static final String route = '/my/createAccount/import';
  final AppStore store;

  @override
  _ImportAccountPageState createState() => _ImportAccountPageState(store);
}

class _ImportAccountPageState extends State<ImportAccountPage> {
  _ImportAccountPageState(this.store);
  final AppStore store;

  int _step = 0;
  String _keyType = '';
  String _cryptoType = '';
  String _derivePath = '';
  bool _submitting = false;

  Future<void> _importAccount() async {
    setState(() {
      _submitting = true;
    });
    Loading.showLoading(context);

    var acc = await webApi.account.importAccount(
      keyType: _keyType,
      cryptoType: _cryptoType,
      derivePath: _derivePath,
    );
    setState(() {
      _submitting = false;
    });
    Loading.hideLoading(context);

    /// check if account duplicate
    if (acc != null) {
      if (acc['error'] != null) {
        UI.alertWASM(context, () {
          setState(() {
            _step = 0;
          });
        });
        return;
      }
      _checkAccountDuplicate(acc);
      return;
    }

    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        final Map<String, String> accDic = I18n.of(context).account;
        return CupertinoAlertDialog(
          title: Container(),
          content:
              Text('${accDic['import.invalid']} ${accDic['create.password']}'),
          actions: <Widget>[
            CupertinoButton(
              child: Text(I18n.of(context).home['cancel']),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  Future<void> _checkAccountDuplicate(Map<String, dynamic> acc) async {
    int index =
        store.account.accountList.indexWhere((i) => i.pubKey == acc['pubKey']);
    if (index > -1) {
      Map<String, String> pubKeyMap =
          store.account.pubKeyAddressMap[store.settings.endpoint.ss58];
      String address = pubKeyMap[acc['pubKey']];
      if (address != null) {
        showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: Text(Fmt.address(address)),
              content: Text(I18n.of(context).account['import.duplicate']),
              actions: <Widget>[
                CupertinoButton(
                  child: Text(I18n.of(context).home['cancel']),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                CupertinoButton(
                  child: Text(I18n.of(context).home['ok']),
                  onPressed: () {
                    _saveAccount(acc);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } else {
      _saveAccount(acc);
    }
  }

  Future<void> _saveAccount(Map<String, dynamic> acc) async {
    Loading.showLoading(context);
    
    await webApi.account.saveAccount(acc);

   
    Loading.hideLoading(context);
     Navigator.of(context).pushNamed(My.route);
   
  }

  @override
  Widget build(BuildContext context) {
    if (_step == 1) {
      return Scaffold(
        appBar: AppBar(
          title: Text(I18n.of(context).home['import']),
          centerTitle: true,
          leading: IconButton(
            icon: Image.asset('assets/images/a/back.png'),
            onPressed: () {
              setState(() {
                _step = 0;
              });
            },
          ),
        ),
        body: SafeArea(
          child: CreateAccountForm(
            setNewAccount: store.account.setNewAccount,
            submitting: _submitting,
            onSubmit: _importAccount,
          ),
        ),
      );
    }
    return Scaffold(
      appBar: myAppBar(context, I18n.of(context).home['import']),
      body: SafeArea(
        child: ImportAccountForm(store.account, (Map<String, dynamic> data) {
          if (data['finish'] == null) {
            setState(() {
              _keyType = data['keyType'];
              _cryptoType = data['cryptoType'];
              _derivePath = data['derivePath'];
              _step = 1;
            });
          } else {
            setState(() {
              _keyType = data['keyType'];
              _cryptoType = data['cryptoType'];
              _derivePath = data['derivePath'];
            });
            _importAccount();
          }
        }),
      ),
    );
  }
}
