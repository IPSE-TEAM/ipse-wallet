import 'package:flutter/material.dart';
import 'package:ipsewallet/config/config.dart';
import 'package:ipsewallet/pages/my/staking/actions/actions.dart';
import 'package:ipsewallet/pages/my/staking/validators/overview.dart';
import 'package:ipsewallet/store/app.dart';
import 'package:ipsewallet/utils/adapt.dart';
import 'package:ipsewallet/utils/i18n/index.dart';
import 'package:ipsewallet/widgets/my_appbar.dart';

class Staking extends StatefulWidget {
  Staking(this.store);
  static const route = '/my/staking';
  final AppStore store;

  @override
  _StakingState createState() => _StakingState(store);
}

class _StakingState extends State<Staking> with TickerProviderStateMixin {
  TabController _tabBarController;
  final AppStore store;

  _StakingState(this.store);

  @override
  void initState() {
    super.initState();
    _tabBarController = new TabController(length: 2, vsync: this)..addListener((){
      if (!_tabBarController.indexIsChanging) return;
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (_tabBarController != null) _tabBarController.dispose();
  }
  String dic(String key) => I18n.of(context).staking[key];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(context, '${I18n.of(context).my["staking"]}', backgroundColor: Config.bgColor),
      backgroundColor: Config.bgColor,
      body: new Column(
        children: <Widget>[
          _buildTabBar(),
          Expanded(child: _buildTabBarView())
        ]
      )
    );
  }

  /// buildTabBar
  Widget _buildTabBar() => new Container(
    height: Adapt.px(100),
    child: new TabBar(
      controller: _tabBarController,
      indicatorColor: Config.themeColor,
      labelColor: Config.themeColor,
      unselectedLabelColor: Config.color666,
      labelPadding: EdgeInsets.zero,
      indicatorSize: TabBarIndicatorSize.label,
      labelStyle: TextStyle(fontSize: 15.0),
      tabs: <Widget>[
        Tab(text: '${dic('actions')}'),
        Tab(text: '${dic('validators')}')
      ]
    )
  );

  /// buildTabBarView
  Widget _buildTabBarView() => new TabBarView(
    physics: NeverScrollableScrollPhysics(),
    controller: _tabBarController,
    children: [
      StakingActions(store), 
      StakingOverviewPage(store)
    ]
  );
}
