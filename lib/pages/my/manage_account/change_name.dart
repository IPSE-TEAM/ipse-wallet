import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ipsewallet/store/account/account.dart';
import 'package:ipsewallet/utils/adapt.dart';
import 'package:ipsewallet/utils/i18n/index.dart';
import 'package:ipsewallet/widgets/my_appbar.dart';
import 'package:ipsewallet/widgets/rounded_button.dart';

class ChangeName extends StatefulWidget {
  ChangeName(this.store);
  static final String route = '/my/manageAccount/name';
  final AccountStore store;

  @override
  _ChangeName createState() => _ChangeName(store);
}

class _ChangeName extends State<ChangeName> {
  _ChangeName(this.store);

  final AccountStore store;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameCtrl = new TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _nameCtrl.text = store.currentAccount.name;
  }

  @override
  Widget build(BuildContext context) {
    var dic = I18n.of(context).profile;
    return Scaffold(
      appBar: myAppBar(context, dic['name.change']),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(
                        Adapt.px(30),
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          
                          fillColor: Colors.white,
                          filled: true,
                          hintText: dic['create.name'],
                        ),
                        controller: _nameCtrl,
                        maxLength: 10,
                        validator: (v) {
                          String name = v.trim();
                          if (name.length == 0) {
                            return dic['contact.name.error'];
                          }
                          int exist = store.optionalAccounts
                              .indexWhere((i) => i.name == name);
                          if (exist > -1) {
                            return dic['contact.name.exist'];
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(16),
              child: RoundedButton(
                text: dic['contact.save'],
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    store.updateAccountName(_nameCtrl.text.trim());
                    Navigator.of(context).pop();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
