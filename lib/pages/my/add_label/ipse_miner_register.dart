import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ipsewallet/config/config.dart';
import 'package:ipsewallet/pages/my/add_label/add_label.dart';
import 'package:ipsewallet/pages/my/tx_confirm_page.dart';
import 'package:ipsewallet/service/substrate_api/api.dart';
import 'package:ipsewallet/store/app.dart';
import 'package:ipsewallet/utils/format.dart';
import 'package:ipsewallet/utils/i18n/index.dart';
import 'package:ipsewallet/widgets/my_appbar.dart';
import 'package:url_launcher/url_launcher.dart';

class IpseMinerRegister extends StatefulWidget {
  IpseMinerRegister(this.appStore);
  static String route = "/my/IpseMinerRegister";
  final AppStore appStore;
  @override
  _IpseMinerRegisterState createState() => _IpseMinerRegisterState(appStore);
}

class _IpseMinerRegisterState extends State<IpseMinerRegister> {
  _IpseMinerRegisterState(this.store);
  final AppStore store;

  final Api api = webApi;
  int kb;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nicknameCtrl = new TextEditingController();
  final TextEditingController _regionCtrl = new TextEditingController();
  final TextEditingController _urlCtrl = new TextEditingController();
  final TextEditingController _sizeCtrl = new TextEditingController();
  final TextEditingController _unitPriceCtrl = new TextEditingController();
  final FocusNode _nicknameNode = FocusNode();
  final FocusNode _regionNode = FocusNode();
  final FocusNode _urlNode = FocusNode();
  final FocusNode _sizeNode = FocusNode();
  final FocusNode _unitPriceNode = FocusNode();
  bool _enableBtn = false;

  Future<void> _onSave() async {
    if (_formKey.currentState.validate()) {
      int decimals = store.settings.networkState.tokenDecimals;
      String nickname = _nicknameCtrl.text.trim();
      String region = _regionCtrl.text.trim();
      String url = _urlCtrl.text.trim();
      int capacity = kb;
      String unitPrice =
          Fmt.tokenInt(_unitPriceCtrl.text.trim(), decimals).toString();
      // (nickname, region, url, capacity, unit_price)

      var args = {
        "title": I18n.of(context).ipse['miner_register'],
        "txInfo": {
          "module": 'ipse',
          "call": 'registerMiner',
        },
        "detail": jsonEncode({
          "nickname": nickname,
          "region": region,
          "url": url,
          "capacity": capacity,
          "unit_price": _unitPriceCtrl.text.trim(),
        }),
        "params": [nickname, region, url, capacity, unitPrice],
        'onFinish': (BuildContext txPageContext, Map res) {
          webApi.ipse.fetchIpseRegisterStatus();
          Navigator.popUntil(
              txPageContext, ModalRoute.withName(AddLabel.route));
        }
      };
      Navigator.of(context).pushNamed(TxConfirmPage.route, arguments: args);
    }
  }

  @override
  void dispose() {
    _nicknameCtrl.dispose();
    _regionCtrl.dispose();
    _urlCtrl.dispose();
    _sizeCtrl.dispose();
    _unitPriceCtrl.dispose();
    _sizeNode.dispose();
    _unitPriceNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
        appBar: myAppBar(context, I18n.of(context).ipse['miner_register']),
        body: Center(
          child: TextButton(onPressed: ()async{
            String url=Config.tutorialUrl;
            if (await canLaunch(url)) {
              await launch(url);
            } 
          },child: Text(I18n.of(context).ipse["View_tutorial"])),
        )

        // SafeArea(
        //   child: Column(
        //     children: <Widget>[
        //       Expanded(
        //         child: Form(
        //           key: _formKey,
        //           onChanged: () => setState(
        //               () => _enableBtn = _formKey.currentState.validate()),
        //           child: ListView(
        //             padding: EdgeInsets.all(Adapt.px(30)),
        //             children: <Widget>[
        //               TextFormField(
        //                 decoration: InputDecoration(
        //                   border: InputBorder.none,
        //                   fillColor: Colors.white,
        //                   filled: true,
        //                   hintText: dic['nickname'],
        //                 ),
        //                 focusNode: _nicknameNode,
        //                 onFieldSubmitted: (v) {
        //                   _regionNode.requestFocus();
        //                 },
        //                 maxLength: 18,
        //                 validator: (v) {
        //                   if (v.trim().isEmpty) {
        //                     return I18n.of(context).home['required'];
        //                   }

        //                   return null;
        //                 },
        //                 textInputAction: TextInputAction.next,
        //                 controller: _nicknameCtrl,
        //               ),
        //               SizedBox(
        //                 height: 15,
        //               ),
        //               TextFormField(
        //                 decoration: InputDecoration(
        //                   border: InputBorder.none,
        //                   fillColor: Colors.white,
        //                   filled: true,
        //                   hintText: dic['region'],
        //                 ),
        //                 focusNode: _regionNode,
        //                 onFieldSubmitted: (v) {
        //                   _regionNode.requestFocus();
        //                 },
        //                 maxLength: 15,
        //                 validator: (v) {
        //                   if (v.trim().isEmpty) {
        //                     return I18n.of(context).home['required'];
        //                   }

        //                   return null;
        //                 },
        //                 textInputAction: TextInputAction.next,
        //                 controller: _regionCtrl,
        //               ),
        //               SizedBox(
        //                 height: 15,
        //               ),
        //               TextFormField(
        //                 decoration: InputDecoration(
        //                   border: InputBorder.none,
        //                   fillColor: Colors.white,
        //                   filled: true,
        //                   hintText: dic['url'],
        //                   helperText: dic['url_tip'],
        //                 ),
        //                 focusNode: _urlNode,
        //                 onFieldSubmitted: (v) {
        //                   _sizeNode.requestFocus();
        //                 },
        //                 maxLength: 20,
        //                 validator: (v) {
        //                   if (v.trim().isEmpty) {
        //                     return I18n.of(context).home['required']+" "+dic['url_tip'];
        //                   }
        //                   if(!RegExp(r"(https?|ftp|file)://[-A-Za-z0-9+&@#/%?=~_|!:,.;]+[-A-Za-z0-9+&@#/%=~_|]").hasMatch(v)){
        //                     return  I18n.of(context).my['formatMistake']+" "+dic['url_tip'];
        //                   }
        //                   return null;
        //                 },
        //                 textInputAction: TextInputAction.next,
        //                 controller: _urlCtrl,
        //               ),
        //               SizedBox(
        //                 height: 15,
        //               ),
        //               TextFormField(
        //                 decoration: InputDecoration(
        //                   border: InputBorder.none,
        //                   fillColor: Colors.white,
        //                   filled: true,
        //                   hintText: dic['disk_space'] + dic['unit_G'],
        //                   helperText: kb != null ? '= $kb Kb' : null,
        //                   suffixText: 'G'
        //                 ),
        //                 onChanged: (v) {
        //                   if (v.trim().isNotEmpty) {
        //                     int n = int.parse(v.trim()) * 1024 * 1024;
        //                     print(n);
        //                     setState(() {
        //                       kb = n;
        //                     });
        //                   } else {
        //                     setState(() {
        //                       kb = null;
        //                     });
        //                   }
        //                 },
        //                 validator: (v) {
        //                   return v.trim().length > 0
        //                       ? null
        //                       : I18n.of(context).home['required'];
        //                 },
        //                 focusNode: _sizeNode,
        //                 onFieldSubmitted: (v) {
        //                   _unitPriceNode.requestFocus();
        //                 },
        //                 textInputAction: TextInputAction.next,
        //                 inputFormatters: [
        //                   FilteringTextInputFormatter.allow(RegExp('[0-9]')),
        //                 ],
        //                 keyboardType: TextInputType.phone,
        //                 controller: _sizeCtrl,
        //               ),
        //               SizedBox(
        //                 height: 15,
        //               ),
        //               TextFormField(
        //                 decoration: InputDecoration(
        //                   border: InputBorder.none,
        //                   fillColor: Colors.white,
        //                   filled: true,
        //                   hintText: dic['unit_price'],
        //                   suffixText: store.settings.networkState.tokenSymbol
        //                 ),
        //                 validator: (v) {
        //                   return v.trim().length > 0
        //                       ? null
        //                       : I18n.of(context).home['required'];
        //                 },
        //                 focusNode: _unitPriceNode,
        //                 onFieldSubmitted: (v) {
        //                   if (_enableBtn) {
        //                     _onSave();
        //                   }
        //                 },
        //                 inputFormatters: [
        //                   FilteringTextInputFormatter.allow(RegExp('[0-9\.]')),
        //                 ],
        //                 keyboardType: TextInputType.phone,
        //                 textInputAction: TextInputAction.done,
        //                 controller: _unitPriceCtrl,
        //               ),
        //             ],
        //           ),
        //         ),
        //       ),
        //       Container(
        //         margin: EdgeInsets.all(16),
        //         child: RoundedButton(
        //           text: I18n.of(context).ipse['submit'],
        //           onPressed: _enableBtn ? _onSave : null,
        //         ),
        //       ),
        //     ],
        //   ),
        // ),

        );
  }
}
