
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ipsewallet/pages/my/scan_page.dart';
import 'package:ipsewallet/widgets/rounded_button.dart';
import 'package:ipsewallet/service/substrate_api/api.dart';
import 'package:ipsewallet/store/account/types/accountData.dart';
import 'package:ipsewallet/store/app.dart';
import 'package:ipsewallet/utils/format.dart';
import 'package:ipsewallet/utils/i18n/index.dart';
import 'package:ipsewallet/utils/loading.dart';
import 'package:ipsewallet/utils/my_utils.dart';
import 'package:ipsewallet/widgets/my_appbar.dart';
import 'package:ipsewallet/widgets/tap_tooltip.dart';

class ContactPage extends StatefulWidget {
  ContactPage(this.store);

  static final String route = '/my/contact';
  final AppStore store;

  @override
  _Contact createState() => _Contact(store);
}

class _Contact extends State<ContactPage> {
  _Contact(this.store);
  final AppStore store;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _addressCtrl = new TextEditingController();
  final TextEditingController _nameCtrl = new TextEditingController();
  final TextEditingController _memoCtrl = new TextEditingController();

  String _errAddr;
  bool _enableBtn = false;

  bool _isObservation = false;
  final FocusNode _addrFocusNode = new FocusNode();
  final FocusNode _nameFocusNode = new FocusNode();
  final FocusNode _memoFocusNode = new FocusNode();
  AccountData _args;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _args = ModalRoute.of(context).settings.arguments;
    if (_args != null) {
      _addressCtrl.text = _args.address;
      _nameCtrl.text = _args.name;
      _memoCtrl.text = _args.memo;
      _isObservation = _args.observation;
    }
  }

  Future<void> _onSave() async {
    if (_formKey.currentState.validate()) {
      Loading.showLoading(context);
      var dic = I18n.of(context).profile;
      String addr = _addressCtrl.text.trim();
      Map pubKeyAddress = await webApi.account.decodeAddress([addr]);


      if (pubKeyAddress == null) {
        setState(() {
          _errAddr = addr;
        });
        _enableBtn = _formKey.currentState.validate();
        Loading.hideLoading(context);
        return;
      }
      String pubKey = pubKeyAddress.keys.toList()[0];
      Map<String, dynamic> con = {
        'address': addr,
        'name': _nameCtrl.text,
        'memo': _memoCtrl.text,
        'observation': _isObservation,
        'pubKey': pubKey,
      };
      if (_args == null) {
        // create new contact
        int exist =
            store.settings.contactList.indexWhere((i) => i.address == addr);
        if (exist > -1) {
          Loading.hideLoading(context);
          showCupertinoDialog(
            context: context,
            builder: (BuildContext context) {
              return CupertinoAlertDialog(
                title: Container(),
                content: Text(dic['contact.exist']),
                actions: <Widget>[
                  CupertinoButton(
                    child: Text(I18n.of(context).home['ok']),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              );
            },
          );
          return;
        } else {
          store.settings.addContact(con);
        }
      } else {
        // edit contact
        store.settings.updateContact(con);
      }

      // get contact info
      if (_isObservation) {
        webApi.account.encodeAddress([pubKey]);
        webApi.account.getPubKeyIcons([pubKey]);
      }
      webApi.account.getAddressIcons([addr]);
      Loading.hideLoading(context);
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _addressCtrl.dispose();
    _nameCtrl.dispose();
    _memoCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, String> dic = I18n.of(context).profile;
    List<Widget> action = <Widget>[
      IconButton(
        icon: Image.asset('assets/images/a/scan.png'),
        onPressed: () async {
          try {
            var to = await Navigator.pushNamed(context, ScanPage.route);
            if (to != null) {
              _addressCtrl.text = to.toString();
            }
          } catch (e) {
            if (e is PlatformException) {
              showErrorMsg(I18n.of(context).my['noCamaraPremission']);
            }
          }
        },
      )
    ];
    return Scaffold(
      appBar: myAppBar(
        context,
        dic['contact'],
        actions: _args == null ? action : null,
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Form(
                key: _formKey,
                onChanged: () => setState(
                    () => _enableBtn = _formKey.currentState.validate()),
                child: ListView(
                  padding: EdgeInsets.only(top: 8, bottom: 8),
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 16, right: 16, top: 16),
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: dic['contact.address'],
                          // labelText: dic['contact.address'],
                        ),
                        controller: _addressCtrl,
                        validator: (v) {
                          if (!Fmt.isAddress(v.trim()) ||
                              _errAddr == v.trim()) {
                            return dic['contact.address.error'];
                          }
                          if (store.account.currentAddress == v.trim()) {
                            return I18n.of(context)
                                .my['doNotAddYourOwnAddresses'];
                          }

                          return null;
                        },
                        focusNode: _addrFocusNode,
                        onFieldSubmitted: (v) {
                          _addrFocusNode.nextFocus();
                        },
                        textInputAction: TextInputAction.next,
                        readOnly: _args != null,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 16, right: 16, top: 16),
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: dic['contact.name'],
                          // labelText: dic['contact.name'],
                        ),
                        controller: _nameCtrl,
                        validator: (v) {
                          return v.trim().length > 0
                              ? null
                              : dic['contact.name.error'];
                        },
                        focusNode: _nameFocusNode,
                        onFieldSubmitted: (v) {
                          _nameFocusNode.nextFocus();
                        },
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 16, right: 16, top: 16),
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: dic['contact.memo'],
                          // labelText: dic['contact.memo'],
                        ),
                        controller: _memoCtrl,
                        focusNode: _memoFocusNode,
                        onFieldSubmitted: (v) {
                          if (_enableBtn) {
                            _onSave();
                          }
                        },
                        textInputAction: TextInputAction.done,
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Checkbox(
                          value: _isObservation,
                          onChanged: (v) {
                            setState(() {
                              _isObservation = v;
                            });
                          },
                        ),
                        GestureDetector(
                          child: Text(I18n.of(context).account['observe']),
                          onTap: () {
                            setState(() {
                              _isObservation = !_isObservation;
                            });
                          },
                        ),
                        TapTooltip(
                          child: Padding(
                            padding: EdgeInsets.only(left: 8),
                            child: Icon(Icons.info_outline, size: 16),
                          ),
                          message: I18n.of(context).account['observe.brief'],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(16),
              child: RoundedButton(
                text: dic['contact.save'],
                onPressed: _enableBtn ? _onSave : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
