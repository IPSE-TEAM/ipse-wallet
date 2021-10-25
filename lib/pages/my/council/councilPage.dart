import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:ipsewallet/common/settings.dart';
import 'package:ipsewallet/pages/my/council/council.dart';
import 'package:ipsewallet/pages/my/council/motions.dart';
import 'package:ipsewallet/service/substrate_api/api.dart';
import 'package:ipsewallet/store/app.dart';
import 'package:ipsewallet/utils/i18n/index.dart';
import 'package:ipsewallet/widgets/my_appbar.dart';
import 'package:ipsewallet/widgets/top_taps.dart';

class CouncilPage extends StatefulWidget {
  CouncilPage(this.store);

  static const String route = '/gov/council/index';

  final AppStore store;

  @override
  _GovernanceState createState() => _GovernanceState();
}

class _GovernanceState extends State<CouncilPage> {
  int _tab = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.store.settings.loading) {
        return;
      }
      webApi.gov.fetchCouncilInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    var dic = I18n.of(context).gov;
    var tabs = [dic['council'], dic['council.motions']];
    bool isKusama = widget.store.settings.endpoint.info == network_name_kusama;
    String imageColor = isKusama ? 'black' : 'pink';
    if (widget.store.gov == null) {
      return Scaffold(
        appBar: myAppBar(context, dic['council']),
        body: Center(
          child: CupertinoActivityIndicator(),
        ),
      );
    }
    return
        // BackgroundWrapper(
        // AssetImage("assets/images/staking/top_bg_$imageColor.png"),
        Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.only(top: 20),
          // color: Colors.transparent,
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Image.asset('assets/images/a/back.png'),
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
              Observer(
                builder: (_) {
                  return Expanded(
                    child: widget.store.gov.council.members == null
                        ? CupertinoActivityIndicator()
                        : _tab == 0
                            ? Council(widget.store)
                            : Motions(widget.store),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      // ),
    );
  }
}
