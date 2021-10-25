import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:ipsewallet/config/config.dart';
import 'package:ipsewallet/pages/my/manage_account/change_name.dart';
import 'package:ipsewallet/pages/my/manage_account/change_password.dart';
import 'package:ipsewallet/pages/my/manage_account/export_account.dart';
import 'package:ipsewallet/service/substrate_api/api.dart';
import 'package:ipsewallet/store/app.dart';
import 'package:ipsewallet/utils/format.dart';
import 'package:ipsewallet/utils/i18n/index.dart';
import 'package:ipsewallet/utils/loading.dart';
import 'package:ipsewallet/utils/local_storage.dart';
import 'package:ipsewallet/utils/my_utils.dart';
import 'package:ipsewallet/widgets/address_icon.dart';
import 'package:ipsewallet/widgets/loading_widget.dart';
import 'package:ipsewallet/widgets/my_appbar.dart';
import 'package:ipsewallet/widgets/my_tile.dart';
import 'package:local_auth/local_auth.dart';

import '../../home.dart';

class ManageAccount extends StatefulWidget {
  ManageAccount(this.store);
  static const route = '/my/manageAccount';
  final AppStore store;

  @override
  _ManageAccountState createState() => _ManageAccountState(store);
}

class _ManageAccountState extends State<ManageAccount> {
  _ManageAccountState(this.store);
  final Api api = webApi;
  final AppStore store;

  final TextEditingController _passCtrl = new TextEditingController();

  bool _supportBiometric = false; // if device support biometric
  bool _isBiometricAuthorized = false; // if user authorized biometric usage

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkBiometricAuth();
    });
  }

  Future<void> _checkBiometricAuth() async {
    final LocalAuthentication auth = LocalAuthentication();
    List<BiometricType> availableBiometrics = [];
    bool supportBiometric = false;
    try {
      bool canCheckBiometrics = await auth.canCheckBiometrics;

      if (canCheckBiometrics) {
        availableBiometrics = await auth.getAvailableBiometrics();
      } else {
        showErrorMsg(I18n.of(context).home['not_support_fingerprint']);
      }
      if (availableBiometrics.contains(BiometricType.fingerprint)) {
        supportBiometric = true;
      }
    } catch (e) {
      print(e);

      showErrorMsg(I18n.of(context).home['fingerprint_error']);
    }
    if (!supportBiometric) {
      return;
    }
    bool isUseFingerprint = await LocalStorage.getUseBioFingerprint(
        store.account.currentAccountPubKey);
    if (mounted) {
      setState(() {
        _supportBiometric = supportBiometric;
        _isBiometricAuthorized = isUseFingerprint;
      });
    }
  }

  changeBio(v) async {
    if (v != _isBiometricAuthorized) {
      final LocalAuthentication auth = LocalAuthentication();
      List<BiometricType> availableBiometrics = [];
      String password;
      if (v) {
        password = await showPasswordDialog(
            context, store.account.currentAccountPubKey,isShowGoAuth: false);
        if (password == null) return;
      }
      try {
        bool canCheckBiometrics = await auth.canCheckBiometrics;

        if (canCheckBiometrics) {
          availableBiometrics = await auth.getAvailableBiometrics();
        }
        if (availableBiometrics.contains(BiometricType.fingerprint)) {
          bool isAuth = await fingerprintAuth(auth, context);
          if (isAuth) {
            await LocalStorage.setUseBioFingerprint(
                v, store.account.currentAccountPubKey);
            if (mounted) {
              setState(() {
                _isBiometricAuthorized = v;
              });
            }
          }
        }
      } catch (e) {
        print(e);
        auth.stopAuthentication();
        showErrorMsg(I18n.of(context).home['fingerprint_error']);
      }
    }
  }

  void _onDeleteAccount(BuildContext context) {
    final Map<String, String> dic = I18n.of(context).profile;
    final Map<String, String> accDic = I18n.of(context).account;

    Future<void> onOk() async {
      Loading.showLoading(context);
      var res = await api.account.checkAccountPassword(_passCtrl.text);
      Loading.hideLoading(context);
      if (res == null) {
        showErrorMsg(dic['pass.error']);
      } else {
        await LocalStorage.setUseBioFingerprint(
            false, store.account.currentAccountPubKey);
        await LocalStorage.setPassword(
            null, store.account.currentAccountPubKey);
        await store.account.removeAccount(store.account.currentAccount);
        store.ipse.clearState();

        store.assets.loadAccountCache();

        // refresh user's staking info
        store.staking.loadAccountCache();
        webApi.loadAccountData();

        Navigator.popUntil(context, ModalRoute.withName(Home.route));
      }
    }

    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(dic['delete.confirm']),
          content: Padding(
            padding: EdgeInsets.only(top: 16),
            child: CupertinoTextField(
              placeholder: dic['pass.old'],
              controller: _passCtrl,
              onChanged: (v) {
                return Fmt.checkPassword(v.trim())
                    ? null
                    : accDic['create.password.error'];
              },
              obscureText: true,
              clearButtonMode: OverlayVisibilityMode.editing,
            ),
          ),
          actions: <Widget>[
            CupertinoButton(
              child: Text(I18n.of(context).home['cancel']),
              onPressed: () {
                Navigator.of(context).pop();
                _passCtrl.clear();
              },
            ),
            CupertinoButton(
              child: Text(I18n.of(context).home['ok']),
              onPressed: onOk,
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, String> dic = I18n.of(context).profile;

    return Observer(builder: (_) {
      if (store.account.currentAccountPubKey.isEmpty) {
        return Scaffold(
          body: Center(
            child: LoadingWidget(),
          ),
        );
      }
      return Scaffold(
        appBar: myAppBar(context, I18n.of(context).my['manageAccount']),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  children: <Widget>[
                    Container(
                      color: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: ListTile(
                        leading: AddressIcon(
                          '',
                          pubKey: store.account.currentAccount.pubKey,
                        ),
                        title: Text(store.account.currentAccount.name ?? 'name',
                            style: TextStyle(
                                fontSize: 18, color: Config.color333)),
                        subtitle: Text(
                          Fmt.address(store.account.currentAddress) ?? '',
                          style:
                              TextStyle(fontSize: 13, color: Config.color999),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          myTile(
                            title: dic['name.change'],
                            onTap: () => Navigator.of(context)
                                .pushNamed(ChangeName.route),
                          ),
                          myTile(
                            title: dic['pass.change'],
                            onTap: () => Navigator.of(context)
                                .pushNamed(ChangePassword.route),
                          ),
                          myTile(
                            title: dic['export'],
                            onTap: () => Navigator.of(context)
                                .pushNamed(ExportAccount.route),
                            // noborder: true,
                          ),
                          _supportBiometric
                              ? ListTile(
                                  title: Text(
                                    I18n.of(context).home['unlock.bio.enable'],
                                    style: TextStyle(
                                      color: Config.color333,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                  trailing: CupertinoSwitch(
                                    activeColor: Theme.of(context).primaryColor,
                                    value: _isBiometricAuthorized,
                                    onChanged: changeBio,
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.all(16)),
                        backgroundColor: MaterialStateProperty.all(Colors.pink)
                      ),
                      child: Text(
                        dic['delete'],
                      ),
                      onPressed: () => _onDeleteAccount(context),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
