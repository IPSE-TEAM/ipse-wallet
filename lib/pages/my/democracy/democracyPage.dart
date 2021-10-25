import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ipsewallet/common/settings.dart';
import 'package:ipsewallet/pages/my/democracy/democracy.dart';
import 'package:ipsewallet/pages/my/democracy/proposals.dart';
import 'package:ipsewallet/store/app.dart';
import 'package:ipsewallet/utils/i18n/index.dart';
import 'package:ipsewallet/widgets/my_appbar.dart';
import 'package:ipsewallet/widgets/top_taps.dart';

class DemocracyPage extends StatefulWidget {
  DemocracyPage(this.store);

  static const String route = '/gov/democracy/index';

  final AppStore store;

  @override
  _DemocracyPageState createState() => _DemocracyPageState();
}

class _DemocracyPageState extends State<DemocracyPage> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    var dic = I18n.of(context).gov;
    var tabs = [dic['democracy.referendum'], dic['democracy.proposal']];
    bool isKusama =
        widget.store.settings.endpoint.info == network_name_kusama;
    String imageColor = isKusama ? 'black' : 'pink';
    if(widget.store.gov==null){
      return Scaffold(
         appBar: myAppBar(context, dic['democracy']),
          body: Center(
            child: CupertinoActivityIndicator(),
          ),
        ); 
    }
    return 
    // BackgroundWrapper(
    //   AssetImage("assets/images/staking/top_bg_$imageColor.png"),
      Scaffold(
        // backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.only(top: 20),
            color: Colors.transparent,
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    IconButton(
                      icon: Image.asset('assets/images/a/back.png'),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    TopTabs(
                      names: tabs,
                      activeTab: _tab,
                      onTab: (v) {
                        setState(() {
                          if (_tab != v) {
                            _tab = v;
                          }
                        });
                      },
                    ),
                  ],
                ),
                Expanded(
                  child: _tab == 0
                      ? Democracy(widget.store)
                      : Proposals(widget.store),
                ),
              ],
            ),
          ),
        ),
      // ),
    );
  }
}
