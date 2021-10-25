import 'package:flutter/material.dart';
import 'package:ipsewallet/config/config.dart';
import 'package:ipsewallet/store/ipse.dart';
import 'package:ipsewallet/utils/adapt.dart';
import 'package:ipsewallet/utils/i18n/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IpSetting extends StatefulWidget {
  IpSetting(this.ipseStore);
  final IpseStore ipseStore;
  @override
  _IpSettingState createState() => _IpSettingState(ipseStore);
}

class _IpSettingState extends State<IpSetting> {
  _IpSettingState(this.ipseStore);
  final IpseStore ipseStore;
  TextEditingController _textEditingController = TextEditingController();
  String _initIP;
  SharedPreferences _sharedPreferences;

  @override
  void initState() {
    super.initState();
    getInitIp();
  }

  getInitIp() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    String ip = _sharedPreferences.getString("ip");
    setState(() {
      _initIP = ip;
      _textEditingController.text = ip;
    });
  }

  setInitIp() async {
    ipseStore.setip(_initIP);
    await _sharedPreferences.setString("ip", _initIP);
    Navigator.of(context).pop(_initIP);
  }

  @override
  Widget build(BuildContext context) {
    Map dic = I18n.of(context).ipse;
    return AlertDialog(
      title: Text(
        dic['connect_ip'],
        style: TextStyle(fontSize: 15.0),
      ),
      backgroundColor: Config.bgColor,
      contentPadding: EdgeInsets.symmetric(horizontal: Adapt.px(20)),
      content: Container(
        height: 140.0,
        color: Config.bgColor,
        padding: EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                dic['set_ip_tips'],
                style: TextStyle(fontSize: 12.0, color: Config.color666),
              ),
              TextField(
                controller: _textEditingController,
                keyboardType: TextInputType.phone,
                autofocus: true,
                onChanged: (v) {
                  setState(() {
                    _initIP = v;
                  });
                },
                decoration: InputDecoration(
                    hintText: "192.168.0.1", helperText: dic['enter_ip']),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          // textColor: Config.color666,
          child: Text(dic['not_want'],
              style: TextStyle(
                  fontWeight: FontWeight.w300, color: Config.color666)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          child: Text(
            I18n.of(context).home['ok'],
          ),
          onPressed: () {
            setInitIp();
          },
        )
      ],
    );
  }
}
