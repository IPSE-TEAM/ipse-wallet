import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:ipsewallet/pages/my/setting/about.dart';
import 'package:ipsewallet/pages/my/setting/custom_types.dart';
import 'package:ipsewallet/pages/my/setting/set_node/set_node.dart';
import 'package:ipsewallet/store/settings.dart';
import 'package:ipsewallet/store/ipse.dart';
import 'package:ipsewallet/utils/i18n/index.dart';
import 'package:ipsewallet/widgets/my_appbar.dart';
import 'package:ipsewallet/widgets/my_tile.dart';

class Setting extends StatefulWidget {
  static const route = '/my/setting';
  final SettingsStore store;
  final IpseStore ipseStore;
  final Function changeLang;

  Setting(this.store, this.changeLang, this.ipseStore);
  @override
  _SettingState createState() => _SettingState(store, changeLang, ipseStore);
}

class _SettingState extends State<Setting> {
  _SettingState(this.store, this.changeLang, this.ipseStore);

  final SettingsStore store;
  final IpseStore ipseStore;
  final Function changeLang;

  final _langOptions = [null, 'en', 'zh'];

  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    var dic = I18n.of(context).profile;
    String getLang(String code) {
      switch (code) {
        case 'zh':
          return '简体中文';
        case 'en':
          return 'English';
        default:
          return dic['setting.lang.auto'];
      }
    }

    void _onLanguageTap() {
      showCupertinoModalPopup(
        context: context,
        builder: (_) => Container(
          height: MediaQuery.of(context).copyWith().size.height / 3,
          child: WillPopScope(
            child: CupertinoPicker(
              backgroundColor: Colors.white,
              itemExtent: 58,
              scrollController: FixedExtentScrollController(
                  initialItem: _langOptions.indexOf(store.localeCode)),
              children: _langOptions.map((i) {
                return Padding(
                    padding: EdgeInsets.all(16), child: Text(getLang(i)));
              }).toList(),
              onSelectedItemChanged: (v) {
                setState(() {
                  _selected = v;
                });
              },
            ),
            onWillPop: () async {
              String code = _langOptions[_selected];
              if (code != store.localeCode) {
                store.setLocalCode(code);
                changeLang(context, code);
              }
              return true;
            },
          ),
        ),
      );
    }

    return Scaffold(
      appBar: myAppBar(context, I18n.of(context).my['setting']),
      body: Observer(builder: (_) {
        return Container(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    myTile(
                      title: I18n.of(context).setting['setNode'],
                      onTap: () =>
                          Navigator.of(context).pushNamed(SetNode.route),
                    ),
                    myTile(
                      title: I18n.of(context).ipse['custom_types'],
                      onTap: () =>
                          Navigator.of(context).pushNamed(CustomTypes.route),
                    ),
                    myTile(
                      title: I18n.of(context).setting['language'],
                      onTap: _onLanguageTap,
                      noborder: true,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                color: Colors.white,
                child: myTile(
                  title: I18n.of(context).setting['about'],
                  noborder: true,
                  onTap: () => Navigator.of(context).pushNamed(About.route),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
