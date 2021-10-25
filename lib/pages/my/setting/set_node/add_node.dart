import 'package:flutter/material.dart';
import 'package:ipsewallet/config/config.dart';
import 'package:ipsewallet/store/settings.dart';
import 'package:ipsewallet/utils/i18n/index.dart';
import 'package:ipsewallet/utils/local_storage.dart';
import 'package:ipsewallet/widgets/my_appbar.dart';

class AddNode extends StatefulWidget {
  static const route = '/my/setting/setNode/add';
  AddNode(this.settingStore);
  final SettingsStore settingStore;

  @override
  _AddNodeState createState() => _AddNodeState(settingStore);
}

class _AddNodeState extends State<AddNode> {
  _AddNodeState(this.settingStore);
  SettingsStore settingStore;
  final _formkey = GlobalKey<FormState>();

  final TextEditingController _descCtrl = new TextEditingController();
  final TextEditingController _addressCtrl = new TextEditingController();
  final FocusNode _descFocusNode= new FocusNode();
  String _info=Config.networkList[0];
  bool _enableBtn = false;

  void _save(context) {
    var _form = _formkey.currentState;
    if (_form.validate()) {
      Map<String, String> newNode = {
        'info': _info,
        'text': _descCtrl.text.trim(),
        'value': _addressCtrl.text.trim(),
      };
      LocalStorage.addCustomEnterPointListInfo(newNode);
      // settingStore.setEndpoint(newNode);

      Navigator.of(context).pop(1);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(context, I18n.of(context).my['custom']),
      body: Column(
        children: <Widget>[
          Expanded(
              child: Form(
            key: _formkey,
            onChanged: () =>
                setState(() => _enableBtn = _formkey.currentState.validate()),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    DropdownButtonFormField(
                      value: _info,
                      items: Config.networkList
                          .map((f) => DropdownMenuItem(
                                child: Text(
                                  f.toString(),
                                  textAlign: TextAlign.left,
                                ),
                                value: f,
                              ))
                          .toList(),
                      onChanged: (v) {
                        setState(() {
                          _info = v;
                         });
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                        filled: true,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: _descCtrl,
                      maxLength: 30,
                      keyboardType: TextInputType.text,
                      validator: (val) {
                        return val == null || val == ""
                            ? I18n.of(context).home['required']
                            : null;
                      },
                      focusNode: _descFocusNode,
                      onFieldSubmitted: (v){
                        _descFocusNode.nextFocus();
                      },
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        fillColor: Colors.white,
                        helperMaxLines: 4,
                        filled: true,
                        hintText: I18n.of(context).my['desc'],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: _addressCtrl,
                      maxLength: 45,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        fillColor: Colors.white,
                        filled: true,
                        hintText: I18n.of(context).my['enterNode'],
                        helperText: "ws://192.168.1.1:9944",
                      ),
                      validator: (val) {
                        if(val == null || val == ""){
                         return I18n.of(context).home['required']; 
                        }else if(RegExp("^(wss|ws)://").hasMatch(val)){
                          return null;
                        }
                        return I18n.of(context).my['formatMistake'];
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
            ),
          )),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15.0, 8.0, 15.0, 8.0),
                  child: RaisedButton(
                    padding: EdgeInsets.fromLTRB(70, 13, 70, 13),
                    elevation: 0,
                    color: Config.themeColor,
                    child: Text(
                      I18n.of(context).my['save'],
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: _enableBtn
                        ? () {
                            _save(context);
                          }
                        : null,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
