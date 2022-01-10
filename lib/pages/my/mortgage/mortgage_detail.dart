import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:ipsewallet/config/config.dart';
import 'package:ipsewallet/model/poc_register_status_model.dart';
import 'package:ipsewallet/model/poc_staking_info_model.dart';
import 'package:ipsewallet/pages/my/mortgage/poc_miner_mining_history.dart';
import 'package:ipsewallet/pages/my/mortgage/poc_my_mining_history.dart';
import 'package:ipsewallet/pages/my/mortgage/user_update_mortgage.dart';
import 'package:ipsewallet/pages/my/my.dart';
import 'package:ipsewallet/pages/my/tx_confirm_page.dart';
import 'package:ipsewallet/service/substrate_api/api.dart';
import 'package:ipsewallet/store/app.dart';
import 'package:ipsewallet/utils/UI.dart';
import 'package:ipsewallet/utils/adapt.dart';
import 'package:ipsewallet/utils/format.dart';
import 'package:ipsewallet/utils/i18n/index.dart';
import 'package:ipsewallet/widgets/account_info.dart';
import 'package:ipsewallet/widgets/address_icon.dart';
import 'package:ipsewallet/widgets/gradient_bg.dart';
import 'package:ipsewallet/widgets/loading_widget.dart';
import 'package:ipsewallet/widgets/no_data.dart';

class MortgageDetail extends StatefulWidget {
  MortgageDetail(this.store, this.address);
  final String address;
  final AppStore store;

  @override
  _MortgageDetailState createState() => _MortgageDetailState(store);
}

class _MortgageDetailState extends State<MortgageDetail> {
  _MortgageDetailState(this.store);

  final AppStore store;
  PocStakingInfoModel pocStakingInfo;
  PocRegisterStatusModel pocRegisterStatus;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getData();
    });
  }

  Future<void> getData() async {
    PocStakingInfoModel res =
        await webApi.ipse.fetchPocStakingInfoByAddr(widget.address);
    PocRegisterStatusModel pocRegisterStatusModel =
        await webApi.ipse.fetchPocMinerRegisterStatus(widget.address);
    if (mounted) {
      setState(() {
        pocStakingInfo = res;
        pocRegisterStatus = pocRegisterStatusModel;
      });
    }
  }

  Future<void> _exit() async {
    var args = {
      "title": I18n.of(context).ipse['exit_mortgage'],
      "txInfo": {
        "module": 'pocStaking',
        "call": 'exitStaking',
      },
      "detail": jsonEncode({'miner': widget.address}),
      "params": [widget.address],
      'onFinish': (BuildContext txPageContext, Map res) {
        Navigator.popUntil(txPageContext, ModalRoute.withName(My.route));
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
  @override
  Widget build(BuildContext context) {
    Map dic = I18n.of(context).ipse;
    final int decimals = store.settings.networkState.tokenDecimals;
    final String symbol = store.settings.networkState.tokenSymbol;
    return Scaffold(
      body: Observer(
        builder: (_) {
          PocStakingInfoOthers myStaker;
          List<Widget> listWidget = [];
          if (pocStakingInfo != null &&
              pocStakingInfo.others != null &&
              pocStakingInfo.others.isNotEmpty) {
            try {
              myStaker = pocStakingInfo.others
                  .firstWhere((e) => e.staker == store.account.currentAddress);
            } catch (e) {
              print(e);
            }
            listWidget = _getListWidget(decimals, symbol);
          }

          return GredientBg(
            title: dic['miner_mortgage_detail'],
            action: IconButton(
              icon: Icon(Icons.list_alt_rounded),
              iconSize: 18,
              color: Colors.white,
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      PocMinerMiningHistory(store, widget.address),
                ),
              ),
            ),
            child: RefreshIndicator(
              onRefresh: getData,
              key: globalPocMinerMortgageDetailRefreshKey,
              child: ListView(
                children: <Widget>[
                  Card(
                    child: Container(
                      height: Adapt.px(430),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          AccountInfo(address: widget.address),
                          pocStakingInfo != null && pocRegisterStatus != null
                              ? Padding(
                                  padding: EdgeInsets.only(top: 8, bottom: 8),
                                  child: Column(
                                    children: [
                                      pocRegisterStatus.isStop
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.warning_rounded,
                                                  color: Colors.red,
                                                ),
                                                Text(
                                                  dic['mining_stopped'],
                                                  style: TextStyle(
                                                    fontSize: Adapt.px(30),
                                                    color: Colors.red,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.check_circle,
                                                  color: Colors.green,
                                                ),
                                                Text(
                                                  dic['mining'],
                                                  style: TextStyle(
                                                    fontSize: Adapt.px(30),
                                                    color: Colors.green,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                      SizedBox(height: 10),
                                      Text(
                                        '${dic['total_mortgage_amount']} ($symbol)',
                                        style: style26,
                                      ),
                                      Text(
                                        Fmt.token(pocStakingInfo.totalStaking,
                                            decimals),
                                        style: TextStyle(
                                          fontSize: Adapt.px(58),
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      RichText(
                                        text: TextSpan(
                                          text: '${dic['commission']}: ',
                                          style: style26,
                                          children: [
                                            TextSpan(
                                                text:
                                                    '${pocStakingInfo.minerProportion} %',
                                                style: TextStyle(
                                                    color: Config.color333))
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  ),
                  pocStakingInfo != null
                      ? Container(
                          child: Column(
                            children: [
                              myStaker != null
                                  ? Card(
                                      child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              dic['my_mortgage'],
                                              style: TextStyle(
                                                fontSize: Adapt.px(30),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: 13),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "${dic['mortgage']} ($symbol)",
                                                  style: style,
                                                ),
                                                Text(
                                                  "${dic['reserved']} ($symbol)",
                                                  style: style,
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 5),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  Fmt.token(myStaker.amount,
                                                      decimals),
                                                  style: TextStyle(
                                                    fontSize: Adapt.px(34),
                                                    fontFamily: 'Roboto',
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  Fmt.token(myStaker.reserved,
                                                      decimals),
                                                  style: TextStyle(
                                                    fontSize: Adapt.px(34),
                                                    fontFamily: 'Roboto',
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Divider(
                                              color: Color(0xFFEFEFEF),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                OutlineButton(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 3,
                                                      horizontal: 5),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadiusDirectional
                                                            .all(
                                                      Radius.circular(
                                                        Adapt.px(50),
                                                      ),
                                                    ),
                                                  ),
                                                  child: Container(
                                                    width: Adapt.px(230),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Image.asset(
                                                            'assets/images/ipse/update-mortgage.png'),
                                                        SizedBox(width: 3),
                                                        Text(
                                                          dic['update_my_mortgage'],
                                                          style: style,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  onPressed: () =>
                                                      Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          UserUpdateMortgage(
                                                              store, {
                                                        "address":
                                                            widget.address,
                                                        "hasMortgageAmount":
                                                            Fmt.bigIntToDouble(
                                                                myStaker.amount,
                                                                decimals),
                                                      }),
                                                    ),
                                                  ),
                                                ),
                                                OutlineButton(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 3,
                                                      horizontal: 5),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadiusDirectional
                                                            .all(
                                                      Radius.circular(
                                                        Adapt.px(50),
                                                      ),
                                                    ),
                                                  ),
                                                  child: Container(
                                                    width: Adapt.px(230),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Image.asset(
                                                            'assets/images/ipse/exit-mortgage.png'),
                                                        SizedBox(width: 3),
                                                        Text(
                                                          dic['exit_mortgage'],
                                                          style: style,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  onPressed: _exit,
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                OutlineButton(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 3,
                                                      horizontal: 5),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadiusDirectional
                                                            .all(
                                                      Radius.circular(
                                                        Adapt.px(50),
                                                      ),
                                                    ),
                                                  ),
                                                  child: Container(
                                                    width: Adapt.px(230),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .list_alt_rounded,
                                                          size: 15,
                                                          color:
                                                              Config.color999,
                                                        ),
                                                        SizedBox(width: 3),
                                                        Text(
                                                          dic['my'] +
                                                              dic['mining_history'],
                                                          style: style,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pushNamed(
                                                              PocMyMiningHistory
                                                                  .route),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 3,
                                                      horizontal: 5),
                                                  child: Container(
                                                    width: Adapt.px(230),
                                                    height: 10,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : Container(),
                              Card(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 15.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                      listWidget.length > 0
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15.0),
                                              child: Column(
                                                children: listWidget,
                                              ),
                                            )
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.all(25.0),
                                              child: NoData(),
                                            )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(25.0),
                          child: LoadingWidget(),
                        ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
