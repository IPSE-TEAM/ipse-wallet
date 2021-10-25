import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:ipsewallet/config/config.dart';
import 'package:ipsewallet/model/poc_staking_info_model.dart';
import 'package:ipsewallet/pages/my/mortgage/miner_manage/change_disk_info.dart';
import 'package:ipsewallet/pages/my/mortgage/miner_manage/change_pid.dart';
import 'package:ipsewallet/pages/my/mortgage/miner_manage/change_proportion.dart';
import 'package:ipsewallet/pages/my/mortgage/miner_manage/change_reward_address.dart';
import 'package:ipsewallet/pages/my/mortgage/poc_miner_mining_history.dart';
import 'package:ipsewallet/pages/my/tx_confirm_page.dart';
import 'package:ipsewallet/service/substrate_api/api.dart';
import 'package:ipsewallet/store/app.dart';
import 'package:ipsewallet/utils/UI.dart';
import 'package:ipsewallet/utils/adapt.dart';
import 'package:ipsewallet/utils/format.dart';
import 'package:ipsewallet/utils/i18n/index.dart';
import 'package:ipsewallet/utils/my_utils.dart';
import 'package:ipsewallet/widgets/address_icon.dart';
import 'package:ipsewallet/widgets/my_appbar.dart';
import 'package:ipsewallet/widgets/my_tile.dart';
import 'package:ipsewallet/widgets/no_data.dart';

import 'mortgage_ranking.dart';

class MinerManage extends StatefulWidget {
  MinerManage(this.appStore);
  final AppStore appStore;
  static String route = "/my/MinerManage";
  @override
  _MinerManageState createState() => _MinerManageState(appStore);
}

class _MinerManageState extends State<MinerManage> {
  _MinerManageState(this.store);

  final AppStore store;
  PocStakingInfoModel pocStakingInfo;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });
  }

  Future<void> _fetchData() async {
    await Future.wait([
      webApi.ipse.fetchPocRegisterStatus(),
      webApi.ipse.fetchPocStakingInfo(),
      webApi.ipse.fetchPocMinersList(),
    ]);
  }

  Future<void> _stopMiner() async {
    var args = {
      "title": I18n.of(context).ipse['stop_mining'],
      "txInfo": {
        "module": 'pocStaking',
        "call": 'stopMining',
      },
      "detail": jsonEncode({}),
      "params": [],
      'onFinish': (BuildContext txPageContext, Map res) {
        globalMinerManageRefreshKey.currentState.show();
        Navigator.pop(context);
      }
    };
    Navigator.of(context).pushNamed(TxConfirmPage.route, arguments: args);
  }

  Future<void> _startMiner() async {
    var args = {
      "title": I18n.of(context).ipse['start_mining'],
      "txInfo": {
        "module": 'pocStaking',
        "call": 'restartMining',
      },
      "detail": jsonEncode({}),
      "params": [],
      'onFinish': (BuildContext txPageContext, Map res) {
        globalMinerManageRefreshKey.currentState.show();
        Navigator.pop(context);
      }
    };
    Navigator.of(context).pushNamed(TxConfirmPage.route, arguments: args);
  }

  Future<void> _exitRanking() async {
    var args = {
      "title": I18n.of(context).ipse['exit_mortgage_ranking'],
      "txInfo": {
        "module": 'pocStaking',
        "call": 'requestDownFromList',
      },
      "detail": jsonEncode({}),
      "params": [],
      'onFinish': (BuildContext txPageContext, Map res) {
        webApi.ipse.fetchPocMinersList();
        Navigator.pop(context);
      }
    };
    Navigator.of(context).pushNamed(TxConfirmPage.route, arguments: args);
  }

  Future<void> _removeStaker(String address) async {
    var args = {
      "title": I18n.of(context).ipse['remove_mortgager'],
      "txInfo": {
        "module": 'pocStaking',
        "call": 'removeStaker',
      },
      "detail": jsonEncode({
        "staker": address,
      }),
      "params": [address],
      'onFinish': (BuildContext txPageContext, Map res) {
        webApi.ipse.fetchPocStakingInfo();
        Navigator.pop(context);
      }
    };
    Navigator.of(context).pushNamed(TxConfirmPage.route, arguments: args);
  }

  List<Widget> _getListWidget(int decimals, String symbol) {
    Map dic = I18n.of(context).ipse;
    List<Widget> listWidget = [];
    for (var i = 0; i < pocStakingInfo.others.length; i++) {
      PocStakingInfoOthers e = pocStakingInfo.others[i];
      listWidget.add(Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: i + 1 == pocStakingInfo.others.length
              ? null
              : Border(
                  bottom: BorderSide(
                    width: Adapt.px(1),
                    color: Color(0xFFEFEFEF),
                  ),
                ),
        ),
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.only(bottom: 10),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 0),
          leading: AddressIcon(e.staker),
          title: Text(Fmt.address(e.staker)),
          trailing: IconButton(
            icon: Image.asset(
              'assets/images/ipse/delete.png',
            ),
            onPressed: () {
              showConfrim(context, Text(dic['confirm_remove_mortgager']),
                  I18n.of(context).home['yes'], () {
                _removeStaker(e.staker);
              });
            },
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  '${dic['mortgage']}: ${Fmt.token(e.amount, decimals)} $symbol',
                  style: style),
              Text(
                  '${dic['reserved']}: ${Fmt.token(e.reserved, decimals)} $symbol',
                  style: style),
            ],
          ),
        ),
      ));
    }
    return listWidget;
  }

  TextStyle style = TextStyle(
    color: Config.color999,
    fontSize: Adapt.px(24),
  );
  TextStyle style26 = TextStyle(
    color: Config.color999,
    fontSize: Adapt.px(26),
  );

  _showNotOpTips() {
    showErrorMsg(I18n.of(context).ipse['cooling_can_op']);
  }

  @override
  Widget build(BuildContext context) {
    Map dic = I18n.of(context).ipse;
    final int decimals = store.settings.networkState.tokenDecimals;
    final String symbol = store.settings.networkState.tokenSymbol;
    return Observer(builder: (_) {
      pocStakingInfo = store.ipse.pocStakingInfo;
      List<Widget> listWidget = [];
      if (pocStakingInfo != null &&
          pocStakingInfo.others != null &&
          pocStakingInfo.others.isNotEmpty) {
        listWidget = _getListWidget(decimals, symbol);
      }
      bool isChillTime =
          store.ipse.pocIsChillTime == null ? false : store.ipse.pocIsChillTime;
      String myAddr = store.account.currentAddress;

      bool isInRanking = store.ipse.pocMinersList
              ?.indexWhere((PocStakingInfoModel e) => e.miner == myAddr) !=
          -1;
      int blockDuration =
          store.settings.networkConst['babe']['expectedBlockTime'];

      if (store.ipse.pocChillTime != null &&store.ipse.newHeads?.number!=null&&
          (store.ipse.pocChillTime[isChillTime ? 1 : 0] -
                  (store.ipse.newHeads.number ) <
              0)) {
      
        webApi.ipse.fetchPocIsChillTime();
        webApi.ipse.fetchPocChillTime();
      }
      return Scaffold(
        appBar: myAppBar(
          context,
          dic['miner_manage'],
          isThemeBg: true,
          actions: store.ipse.pocRegisterStatus != null
              ? [
                  store.ipse.pocRegisterStatus.isStop
                      ? TextButton(
                          onPressed: _startMiner,
                          child: Text(
                            dic['start_mining'],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: Adapt.px(26),
                            ),
                          ),
                        )
                      : TextButton(
                          onPressed: () {
                            showConfrim(
                                context,
                                Text(dic['confirm_stop_mining']),
                                I18n.of(context).home['yes'],
                                _stopMiner);
                          },
                          child: Text(
                            dic['stop_mining'],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: Adapt.px(26),
                            ),
                          ),
                        )
                ]
              : null,
        ),
        backgroundColor: Theme.of(context).primaryColor,
        body: Container(
          color: Config.bgColor,
          child: Column(
            children: <Widget>[
              Container(
                color: Theme.of(context).primaryColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 8, bottom: 8),
                      child: Column(
                        children: [
                          Text(
                            '${dic['total_mortgage_amount']} ($symbol)',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: Adapt.px(26),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            '${Fmt.token(pocStakingInfo?.totalStaking ?? BigInt.zero, decimals)} ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: Adapt.px(70),
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: Adapt.px(11),
                      decoration: BoxDecoration(
                        color: Color(0xFF168DCB),
                        borderRadius: BorderRadiusDirectional.vertical(
                          top: Radius.circular(Adapt.px(12)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _fetchData,
                  key: globalMinerManageRefreshKey,
                  child: ListView(
                    children: [
                      Container(
                        color: Color(0xFF168DCB),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset('assets/images/ipse/cooling-p.png'),
                                SizedBox(width: 6),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 2.0),
                                  child: Text(
                                    isChillTime
                                        ? dic['cooling_off_period']
                                        : dic['not_cooling_off_period'],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: Adapt.px(26),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 16),
                                Text(
                                  store.ipse.pocChillTime != null
                                      ? '${I18n.of(context).gov['remain']}:  ${Fmt.blockToTime(store.ipse.pocChillTime[isChillTime ? 1 : 0] - store.ipse.newHeads?.number, blockDuration)}'
                                      : '',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: Adapt.px(20),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 6),
                            Container(
                              decoration: BoxDecoration(
                                  color: isChillTime
                                      ? Colors.white
                                      : Config.bgColor,
                                  border: new Border.all(
                                      color: Config.bgColor, width: 2),
                                  borderRadius: new BorderRadius.vertical(
                                      top: Radius.circular(Adapt.px(12)))),
                              child: Column(
                                children: <Widget>[
                                  !isChillTime
                                      ? Container(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Row(
                                            children: [
                                              Image.asset(
                                                  'assets/images/ipse/tips.png'),
                                              SizedBox(width: 6),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 2.0),
                                                child: Text(
                                                  dic['cooling_can_op'],
                                                  style: TextStyle(
                                                    color: Config.color999,
                                                    fontSize: Adapt.px(22),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : Container(),
                                  myTile(
                                    title:
                                        I18n.of(context).ipse['reward_address'],
                                    titleColor:
                                        isChillTime ? null : Config.color999,
                                    trailing: Fmt.address(store
                                        .ipse.pocRegisterStatus.rewardDest),
                                    onLongPress:()=>copy(context, store.ipse.pocRegisterStatus.rewardDest) ,
                                    onTap: isChillTime
                                        ? () => Navigator.of(context).pushNamed(
                                            ChangeRewardAddress.route)
                                        : _showNotOpTips,
                                  ),
                                  myTile(
                                    title:
                                        I18n.of(context).ipse['plot_disk_id'],
                                    titleColor:
                                        isChillTime ? null : Config.color999,
                                    trailing: store.ipse.pocRegisterStatus.pid
                                        .toString(),
                                        onLongPress: ()=>copy(context, store.ipse.pocRegisterStatus.pid.toString()),
                                    onTap: isChillTime
                                        ? () => Navigator.of(context)
                                            .pushNamed(ChangePID.route)
                                        : _showNotOpTips,
                                  ),
                                  myTile(
                                    title: dic['plot_disk_space'],
                                    titleColor:
                                        isChillTime ? null : Config.color999,
                                    trailing:
                                        (store.ipse.pocRegisterStatus.disk /
                                                    BigInt.from(1024) /
                                                    1024 /
                                                    1024)
                                                .toStringAsFixed(0) +
                                            "G",
                                    onTap: isChillTime
                                        ? () => Navigator.of(context)
                                            .pushNamed(ChangeDiskInfo.route)
                                        : _showNotOpTips,
                                  ),
                                  pocStakingInfo != null
                                      ? myTile(
                                          title: I18n.of(context)
                                              .ipse['commission'],
                                          titleColor: isChillTime
                                              ? null
                                              : Config.color999,
                                          trailing:
                                              '${pocStakingInfo.minerProportion}%',
                                          noborder: true,
                                          onTap: isChillTime
                                              ? () => Navigator.of(context)
                                                  .pushNamed(
                                                      ChangeProportion.route)
                                              : _showNotOpTips,
                                        )
                                      : Container(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            isInRanking == null
                                ? Container()
                                : isInRanking
                                    ? Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            showConfrim(
                                                context,
                                                Text(dic[
                                                    'confirm_exit_ranking']),
                                                I18n.of(context).home['yes'],
                                                _exitRanking);
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                  'assets/images/ipse/ranking.png'),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                dic['exit_mortgage_ranking'],
                                                style: TextStyle(
                                                    fontSize: Adapt.px(30)),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : Expanded(
                                        child: GestureDetector(
                                          onTap: () => Navigator.of(context)
                                              .pushNamed(MortgageRanking.route),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                  'assets/images/ipse/ranking.png'),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    dic['mortgage_ranking'],
                                                    style: TextStyle(
                                                        fontSize: Adapt.px(30)),
                                                  ),
                                                  Container(
                                                    width: Adapt.px(200),
                                                    child: Text(
                                                      dic['ranking_tip'],
                                                      style: TextStyle(
                                                          fontSize:
                                                              Adapt.px(18),
                                                          color:
                                                              Config.color999),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                            Container(
                              color: Color(0xFFE6E6E6),
                              width: Adapt.px(1),
                              height: Adapt.px(100),
                            ),
                            Expanded(
                              child: GestureDetector(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                        'assets/images/ipse/miningrecord.png'),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      dic['mining_history'],
                                      style: TextStyle(fontSize: Adapt.px(30)),
                                    ),
                                  ],
                                ),
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        PocMinerMiningHistory(store, myAddr),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0),
                                child: Text(
                                  dic['mortgager_list'],
                                  style: TextStyle(
                                    fontSize: Adapt.px(30),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(height: 5),
                              Divider(
                                color: Color(0xFFEFEFEF),
                              ),
                              listWidget.length != 0
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15.0),
                                      child: Column(
                                        children: listWidget,
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: NoData(),
                                    ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
