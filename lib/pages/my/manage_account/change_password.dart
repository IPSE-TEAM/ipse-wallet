import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ipsewallet/pages/my/manage_account/manage_account.dart';
import 'package:ipsewallet/service/substrate_api/api.dart';
import 'package:ipsewallet/store/account/account.dart';
import 'package:ipsewallet/store/account/types/accountData.dart';
import 'package:ipsewallet/utils/adapt.dart';
import 'package:ipsewallet/utils/format.dart';
import 'package:ipsewallet/utils/i18n/index.dart';
import 'package:ipsewallet/utils/local_storage.dart';
import 'package:ipsewallet/widgets/my_appbar.dart';
import 'package:ipsewallet/widgets/rounded_button.dart';

class ChangePassword extends StatefulWidget {
  ChangePassword(this.store);

  static final String route = '/my/manageAccount/password';
  final AccountStore store;

  @override
  _ChangePassword createState() => _ChangePassword(store);
}

class _ChangePassword extends State<ChangePassword> {
  _ChangePassword(this.store);

  final Api api = webApi;
  final AccountStore store;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passOldCtrl = new TextEditingController();
  final TextEditingController _passCtrl = new TextEditingController();
  final TextEditingController _pass2Ctrl = new TextEditingController();

  Future<void> _onSave() async {
    if (_formKey.currentState.validate()) {
      var dic = I18n.of(context).profile;
      var acc = await api.evalJavascript(
          'account.changePassword("${store.currentAccount.pubKey}", "${_passOldCtrl.text}", "${_passCtrl.text}")');
      if (acc == null) {
        showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: Text(dic['pass.error']),
              content: Text(dic['pass.error.txt']),
              actions: <Widget>[
                CupertinoButton(
                  child: Text(I18n.of(context).home['ok']),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            );
          },
        );
      } else {
        LocalStorage.setPassword(_passCtrl.text,store.currentAccount.pubKey);
        // use local name, not webApi returned name
        Map<String, dynamic> localAcc =
            AccountData.toJson(store.currentAccount);
        acc['meta']['name'] = localAcc['meta']['name'];
        store.updateAccount(acc);
        // update encrypted seed after password updated
        store.updateSeed(
            store.currentAccount.pubKey, _passOldCtrl.text, _passCtrl.text);
        showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: Text(dic['pass.success']),
              content: Text(dic['pass.success.txt']),
              actions: <Widget>[
                CupertinoButton(
                  child: Text(I18n.of(context).home['ok']),
                  onPressed: () => Navigator.popUntil(
                      context, ModalRoute.withName(ManageAccount.route)),
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var dic = I18n.of(context).profile;
    var accDic = I18n.of(context).account;
    return Scaffold(
      appBar: myAppBar(context, dic['pass.change']),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: EdgeInsets.all(Adapt.px(30)),
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.lock),
                        fillColor: Colors.white,
                        filled: true,
                        hintText: dic['pass.old'],
                        suffixIcon: IconButton(
                          iconSize: 18,
                          icon: Icon(
                            CupertinoIcons.clear_thick_circled,
                            color: Theme.of(context).unselectedWidgetColor,
                          ),
                          onPressed: () {
                            WidgetsBinding.instance.addPostFrameCallback(
                                (_) => _passOldCtrl.clear());
                          },
                        ),
                      ),
                     
                      controller: _passOldCtrl,
                      validator: (v) {
                        return Fmt.checkPassword(v.trim())
                            ? null
                            : accDic['create.password.error'];
                      },
                      obscureText: true,
                    ),
                    SizedBox(height: 15,),
                    TextFormField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.lock),
                        fillColor: Colors.white,
                        filled: true,
                        hintText: dic['pass.new'],
                      ),
                      controller: _passCtrl,
                      validator: (v) {
                        return Fmt.checkPassword(v.trim())
                            ? null
                            : accDic['create.password.error'];
                      },
                      obscureText: true,
                    ),
                    SizedBox(height: 15,),
                    TextFormField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.lock),
                        fillColor: Colors.white,
                        filled: true,
                        hintText: dic['pass.new2'],
                      ),
                      controller: _pass2Ctrl,
                      validator: (v) {
                        return v.trim() != _passCtrl.text
                            ? accDic['create.password2.error']
                            : null;
                      },
                      obscureText: true,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(16),
              child:
                  RoundedButton(text: dic['contact.save'], onPressed: _onSave),
            ),
          ],
        ),
      ),
    );
  }
}
