import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:ipsewallet/config/config.dart';
import 'package:ipsewallet/model/ipse_register_status_model.dart';
import 'package:ipsewallet/pages/my/add_label/ipse_miner_manage/ipse_mortgage_ranking.dart';
import 'package:ipsewallet/pages/my/add_label/ipse_miner_mining_history.dart';
import 'package:ipsewallet/pages/my/tx_confirm_page.dart';
import 'package:ipsewallet/service/substrate_api/api.dart';
import 'package:ipsewallet/store/app.dart';
import 'package:ipsewallet/utils/adapt.dart';
import 'package:ipsewallet/utils/format.dart';
import 'package:ipsewallet/utils/i18n/index.dart';
import 'package:ipsewallet/utils/my_utils.dart';
import 'package:ipsewallet/widgets/my_appbar.dart';
import 'package:ipsewallet/widgets/my_tile.dart';

import 'ipse_miner_orders.dart';

class IpseMinerManage extends StatefulWidget {
  IpseMinerManage(this.appStore);
  final AppStore appStore;
  static String route = "/my/ipseMinerManage";
  @override
  _IpseMinerManageState createState() => _IpseMinerManageState(appStore);
}

class _IpseMinerManageState extends State<IpseMinerManage> {
  _IpseMinerManageState(this.store);

  final AppStore store;
  IpseRegisterStatusModel ipseRegisterStatus;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      webApi.ipse.fetchIpseMinersList();
    });
  }


  Future<void> _exitRanking() async {
    var args = {
      "title": I18n.of(context).ipse['exit_mortgage_ranking'],
      "txInfo": {
        "module": 'ipse',
        "call": 'dropOutRecommendedList',
      },
      "detail": jsonEncode({}),
      "params": [],
      'onFinish': (BuildContext txPageContext, Map res) {
        webApi.ipse.fetchIpseMinersList();
        Navigator.pop(context);
      }
    };
    Navigator.of(context).pushNamed(TxConfirmPage.route, arguments: args);
  }

  TextStyle style = TextStyle(
    color: Config.color999,
    fontSize: Adapt.px(24),
  );
  TextStyle style26 = TextStyle(
    color: Config.color999,
    fontSize: Adapt.px(26),
  );

  @override
  Widget build(BuildContext context) {
    Map dic = I18n.of(context).ipse;
    final int decimals = store.settings.networkState.tokenDecimals;
    final String symbol = store.settings.networkState.tokenSymbol;
    return Observer(builder: (_) {
      ipseRegisterStatus = store.ipse.ipseRegisterStatus;
      String myAddr = store.account.currentAddress;
      bool isInRanking = store.ipse.ipseMinersList?.indexWhere(
              (IpseRegisterStatusModel e) => e.accountId == myAddr) !=
          -1;

      return Scaffold(
        appBar:
            myAppBar(context, dic['miner_manage'], isThemeBg: true, actions: [
          CupertinoButton(
            child: Text(
              dic['confirmed_orders'],
              style: TextStyle(color: Colors.white, fontSize: Adapt.px(22)),
            ),
            onPressed: () =>
                Navigator.of(context).pushNamed(IpseMinerOrders.route),
          ),
        ]),
        backgroundColor: Theme.of(context).primaryColor,
        body: Container(
          color: Config.bgColor,
          child: Column(
            children: <Widget>[
              Container(
                color: Theme.of(context).primaryColor,
                child: Padding(
                  padding: EdgeInsets.only(top: 8, bottom: 28),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            '${dic['expected_profits']} ($symbol)',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: Adapt.px(26),
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            width: Adapt.px(750),
                            child: Text(
                              '${Fmt.token(ipseRegisterStatus?.totalStaking ?? BigInt.zero, decimals)} ',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: Adapt.px(70),
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
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
                                                  'confirm_exit_ranking_ipse']),
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
                                            .pushNamed(
                                                IpseMortgageRanking.route),
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
                                                        fontSize: Adapt.px(18),
                                                        color: Config.color999),
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
                                      IpseMinerMiningHistory(store, myAddr),
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
                    myTile(
                      noMore: true,
                      title: dic['disk_space'],
                      trailing:
                          '${Fmt.doubleFormat((ipseRegisterStatus.capacity ?? BigInt.zero) / BigInt.from(1024) / 1024 / 1024)} G',
                    ),
                    myTile(
                      noMore: true,
                      title: dic["nickname"],
                      onTap: () =>
                          copy(context, '${ipseRegisterStatus.nickname}'),
                      trailing: '${ipseRegisterStatus.nickname}',
                    ),
                    myTile(
                      noMore: true,
                      title: dic["reward_address"],
                      onTap: () =>
                          copy(context, ipseRegisterStatus.stashAddress),
                      trailing: Fmt.address(ipseRegisterStatus.stashAddress),
                    ),
                    myTile(
                      noMore: true,
                      title: dic["region"],
                      onTap: () => copy(context, ipseRegisterStatus.region),
                      trailing: '${ipseRegisterStatus.region}',
                    ),
                    myTile(
                      noMore: true,
                      title: dic["unit_price"],
                      onTap: () => copy(context,
                          '${Fmt.token(ipseRegisterStatus.unitPrice, decimals, length: decimals)} $symbol'),
                      trailing:
                          '${Fmt.token(ipseRegisterStatus.unitPrice, decimals, length: decimals)} $symbol',
                    ),
                    myTile(
                      noMore: true,
                      title: "url",
                      onTap: () => copy(context, ipseRegisterStatus.url),
                      trailing: '${ipseRegisterStatus.url}',
                    ),
                    myTile(
                      noMore: true,
                      title: dic["violation_times"],
                      trailing: '${ipseRegisterStatus.violationTimes}',
                    ),
                    ipseRegisterStatus?.createTs != null
                        ? myTile(
                            noMore: true,
                            title: dic["create_time"],
                            trailing: Fmt.dateTime(
                                DateTime.fromMillisecondsSinceEpoch(
                                    ipseRegisterStatus?.createTs)),
                          )
                        : Container(),
                    ipseRegisterStatus?.updateTs != null
                        ? myTile(
                            noMore: true,
                            title: dic["update_time"],
                            trailing: Fmt.dateTime(
                                DateTime.fromMillisecondsSinceEpoch(
                                    ipseRegisterStatus?.updateTs)),
                            noborder: true,
                          )
                        : Container(),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
