import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ipsewallet/utils/format.dart';
import 'package:ipsewallet/utils/i18n/index.dart';
import 'package:ipsewallet/widgets/rounded_button.dart';

class CreateAccountForm extends StatelessWidget {
  CreateAccountForm({this.setNewAccount, this.submitting, this.onSubmit});

  final Function setNewAccount;
  final Function onSubmit;
  final bool submitting;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameCtrl = new TextEditingController();
  final TextEditingController _passCtrl = new TextEditingController();
  final TextEditingController _pass2Ctrl = new TextEditingController();
  final FocusNode _nameFocusNode = new FocusNode();
  final FocusNode _passFocusNode = new FocusNode();
  final FocusNode _pass2FocusNode = new FocusNode();

  @override
  Widget build(BuildContext context) {
    final Map<String, String> dic = I18n.of(context).account;

    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal:15),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.person),
                      fillColor: Colors.white,
                      filled: true,
                      hintText: dic['create.name'],
                    ),
                    focusNode: _nameFocusNode,
                    onFieldSubmitted: (v) {
                      _passFocusNode.requestFocus();
                    },
                    textInputAction: TextInputAction.next,
                    controller: _nameCtrl,
                    validator: (v) {
                      return v.trim().length > 0
                          ? null
                          : dic['create.name.error'];
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.lock),
                      fillColor: Colors.white,
                      filled: true,
                      hintText: dic['create.password'],
                    ),
                    focusNode: _passFocusNode,
                    onFieldSubmitted: (v) {
                      _pass2FocusNode.requestFocus();
                    },
                    textInputAction: TextInputAction.next,
                    controller: _passCtrl,
                    validator: (v) {
                      return Fmt.checkPassword(v.trim())
                          ? null
                          : dic['create.password.error'];
                    },
                    obscureText: true,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.lock),
                      fillColor: Colors.white,
                      filled: true,
                      hintText: dic['create.password2'],
                    ),
                    focusNode: _pass2FocusNode,
                    textInputAction: TextInputAction.done,
                    controller: _pass2Ctrl,
                    obscureText: true,
                    validator: (v) {
                      return _passCtrl.text != v
                          ? dic['create.password2.error']
                          : null;
                    },
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              child: RoundedButton(
                text: I18n.of(context).home['next'],
                onPressed: submitting
                    ? null
                    : () {
                        if (_formKey.currentState.validate()) {
                          setNewAccount(_nameCtrl.text.trim(), _passCtrl.text.trim());
                          onSubmit();
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
