import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ipsewallet/config/config.dart';
import 'package:ipsewallet/service/substrate_api/api.dart';
import 'package:ipsewallet/store/app.dart';
import 'package:ipsewallet/utils/adapt.dart';
import 'package:ipsewallet/utils/i18n/index.dart';
import 'package:ipsewallet/utils/local_storage.dart';
import 'package:ipsewallet/utils/my_utils.dart';
import 'package:ipsewallet/widgets/my_appbar.dart';

class CustomTypes extends StatefulWidget {
  CustomTypes(this.store);
  static const route = '/my/setting/CustomTypes';
  final AppStore store;
  @override
  _CustomTypesState createState() => _CustomTypesState(store);
}

class _CustomTypesState extends State<CustomTypes> {
  _CustomTypesState(this.store);

  final AppStore store;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _typesCtrl = new TextEditingController();
  bool _enableBtn = true;

  @override
  void initState() {
    super.initState();
    _getTypes();
  }

  @override
  void dispose() {
    _typesCtrl.dispose();
    super.dispose();
  }

  Future<void> _getTypes() async {
    String types = await LocalStorage.getCustomTypes();
    if (types != null) {
      try {
        jsonDecode(types);
        setState(() {
          _typesCtrl.text = types;
        });
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> _onSave() async {
    if (_formKey.currentState.validate()) {
      try {
        String types;
        if (_typesCtrl.text.trim().isNotEmpty) {
          jsonEncode(_typesCtrl.text.trim());
          types = _typesCtrl.text.trim();
        } else {
          types = null;
        }

        LocalStorage.setCustomTypes(types);
        webApi.changeNode();
        Navigator.of(context).pop();
      } catch (e) {
        print(e);
        showErrorMsg(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Map dic = I18n.of(context).ipse;
    return Scaffold(
      appBar: myAppBar(context, dic['custom_types']),
      body: Column(
        children: [
          Expanded(
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onChanged: () => setState(
                () => _enableBtn = _formKey.currentState.validate(),
              ),
              child: ListView(
                padding: EdgeInsets.all(Adapt.px(30)),
                children: <Widget>[
                  Text(
                    dic['add_custom_types'],
                    style: TextStyle(
                        color: Config.color333,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: Colors.white,
                      filled: true,
                    ),
                    onFieldSubmitted: (v) {
                      if (_enableBtn) {
                        _onSave();
                      }
                    },
                    scrollPadding: EdgeInsets.all(5),
                    maxLines: 15,
                    maxLength: 20000,
                    validator: (v) {
                      if (v.trim().isNotEmpty) {
                        try {
                          jsonDecode(v.trim());
                        } catch (e) {
                          return I18n.of(context).my['formatMistake'];
                        }
                      }

                      return null;
                    },
                    textInputAction: TextInputAction.done,
                    controller: _typesCtrl,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                RaisedButton(
                  elevation: 0,
                  color: Config.secondColor,
                  child: Text(
                    I18n.of(context).my['copy'],
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    copy(context, _typesCtrl.text.trim());
                  },
                ),
                RaisedButton(
                  elevation: 0,
                  color: Config.errorColor,
                  child: Text(
                    dic['clear'],
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    WidgetsBinding.instance
                        .addPostFrameCallback((_) => _typesCtrl.clear());
                  },
                ),
                RaisedButton(
                  elevation: 0,
                  color: Config.themeColor,
                  child: Text(
                    I18n.of(context).my['save'],
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: _enableBtn ? _onSave : null,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
