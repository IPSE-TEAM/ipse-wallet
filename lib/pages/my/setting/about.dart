import 'package:flutter/material.dart';
import 'package:ipsewallet/config/config.dart';
import 'package:ipsewallet/service/check_version.dart';
import 'package:ipsewallet/utils/adapt.dart';
import 'package:ipsewallet/utils/i18n/index.dart';
import 'package:ipsewallet/widgets/my_appbar.dart';

class About extends StatefulWidget {
  static const route='/my/setting/about';
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  String _version;

  @override
  void initState() {
    super.initState();
    getVersion();
  }

  Future<void> getVersion() async {
    String version = await CheckVersion.getPackageVersion();
    setState(() {
      _version = version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(context, I18n.of(context).setting['about']),
      body: Container(
         
          child: Center(
              child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset('assets/images/app.png',width: Adapt.px(160)),
                SizedBox(height: 20,),
                Text(
                  "IPSE 2.0",
                  style: TextStyle(
                      color: Config.color333,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 19, 10, 10),
                  child: Text(
                    I18n.of(context).ipse['appDesc1'],
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Config.color333, fontSize: 14),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 16),
                  child: Text(
                    I18n.of(context).ipse['appDesc2'],
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Config.color333, fontSize: 14),
                  ),
                ),
                Text(
                  I18n.of(context).my['version'] + ": $_version",
                  style: TextStyle(color: Config.color999, fontSize: 12),
                ),
                SizedBox(height: 55,),
              ],
            ),
          ))),
    );
  }
}
