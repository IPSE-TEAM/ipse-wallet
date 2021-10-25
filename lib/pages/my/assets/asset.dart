import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:ipsewallet/common/colors.dart';
import 'package:ipsewallet/config/config.dart';
import 'package:ipsewallet/pages/my/address_qr.dart';
import 'package:ipsewallet/pages/my/assets/transfer/transfer.dart';
import 'package:ipsewallet/pages/my/assets/transfer/transfer_detail.dart';
import 'package:ipsewallet/service/request_service.dart';
import 'package:ipsewallet/store/app.dart';
import 'package:ipsewallet/store/assets/types/balancesInfo.dart';
import 'package:ipsewallet/store/assets/types/transferData.dart';
import 'package:ipsewallet/utils/adapt.dart';
import 'package:ipsewallet/utils/format.dart';
import 'package:ipsewallet/utils/i18n/index.dart';
import 'package:ipsewallet/utils/result_data.dart';
import 'package:ipsewallet/widgets/loading_widget.dart';
import 'package:ipsewallet/widgets/my_appbar.dart';
import 'package:ipsewallet/widgets/no_data.dart';
import 'package:ipsewallet/widgets/tap_tooltip.dart';

import 'package:intl/intl.dart';
import 'package:refresh_loadmore/refresh_loadmore.dart';

class Asset extends StatefulWidget {
  Asset(this.store);

  static final String route = '/my/assets/detail';

  final AppStore store;

  @override
  _AssetState createState() => _AssetState(store);
}

class _AssetState extends State<Asset> with SingleTickerProviderStateMixin {
  _AssetState(this.store);

  final AppStore store;

  bool _isLastPage = false;

  final List<String> _tabTxt = ['all', 'in', 'out'];
  List _transList;
  bool _isRequesting = false;
  int _page = 0;
  int _size = 10;
  List allData = List<TransferData>();

  TabController _tabController;
  @override
  void initState() {
    super.initState();
    _transList = List(_tabTxt.length);
    _tabController = TabController(vsync: this, length: _tabTxt.length);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {}
    });
    _onRefresh();
  }


  Future<void> _getData() async {
    if (_isRequesting || _isLastPage) {
      return;
    }
    String networkName = store.settings.networkName.toLowerCase();

    if (Config.supportNetworkList.contains(networkName) == false) {
      setState(() {
        _transList = [[], [], []];
      });
      return;
    }
    _isRequesting = true;
    bool isLast = false;
    List inData = [];
    List outData = [];
    ResultData res = await RequestService.getTokenTransactionTxs(
        store.account.currentAddress, networkName, _page, _size);
    if (res.code != 111 && mounted && res.data["data"] != null) {
      isLast = _isLastPage = 
          res.data["data"].length < _size;

      List list = res.data["data"] == null
          ? []
          : res.data["data"]
              .map((json) => TransferData.fromJson(json))
              .toList();
      if (_page == 0) {
        allData = list;
      } else {
        allData.addAll(list);
      }
      _page = _page + 1;
    }

    allData.forEach((element) {
      if (element.to == store.account.currentAddress) {
        inData.add(element);
      } else {
        outData.add(element);
      }
    });
    List transList = [allData, inData, outData];

    if (mounted) {
      setState(() {
        _transList = transList;
        _isLastPage = isLast;
      });
    }
    _isRequesting = false;
  }

  Future<void> _onRefresh() async {
    setState(() {
      _page = 0;
      _isLastPage = false;
    });
    await _getData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget mainList(BuildContext context, List list) {
    if (list == null) {
      return Padding(
        padding: const EdgeInsets.only(top: 50.0),
        child: LoadingWidget(),
      );
    } else if (list.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 50.0),
        child: NoData(),
      );
    } else {
      int decimals = store.settings.networkState.tokenDecimals;
      return Column(
        children: list
            .map(
              (f) => Container(
                padding: EdgeInsets.symmetric(
                    vertical: Adapt.px(12), horizontal: Adapt.px(30.0)),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            width: Adapt.px(1), color: Color(0xFFEFEFEF)))),
                child: InkWell(
                  onTap: () => Navigator.pushNamed(
                    context,
                    TransferDetailPage.route,
                    arguments: f,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 12, bottom: 12, right: 20),
                              child: Text(
                                Fmt.address(f.to == store.account.currentAddress
                                    ? f.from
                                    : f.to),
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Config.color333,
                                  fontSize: Adapt.px(32),
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'PingFang SC',
                                ),
                              ),
                            ),
                          ), 
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Text(
                              "${f.to == store.account.currentAddress ? "+" : "-"}${Fmt.token(f.amount, decimals)} ${store.settings.networkState.tokenSymbol ?? ''}",
                              style: TextStyle(
                                color: f.to == store.account.currentAddress
                                    ? Config.themeColor
                                    : Color(0xffFF8429),
                                fontSize: Adapt.px(32),
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Roboto',
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Text(
                                DateFormat('yyyy-MM-dd HH:mm:ss').format(
                                    DateTime.fromMillisecondsSinceEpoch(
                                        f.blockTimestamp )),
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: Config.color999),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
            .toList(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final String symbol = store.settings.networkState.tokenSymbol;

    final dic = I18n.of(context).assets;

    return Scaffold(
      body: Observer(builder: (_) {
        int decimals = store.settings.networkState.tokenDecimals;

        BalancesInfo balancesInfo = store.assets.balances[symbol];
        String lockedInfo = '\n';
        if (balancesInfo == null) {
          return Scaffold(
            appBar: myAppBar(context, ''),
            body: Center(child: LoadingWidget()),
          );
        }
        if (balancesInfo.lockedBreakdown != null) {
          balancesInfo.lockedBreakdown.forEach((i) {
            if (i.amount > BigInt.zero) {
              String use = dic['lock.${i.use}'];
              lockedInfo += "${Fmt.token(i.amount, decimals)} $symbol $use\n";
            }
          });
        }
        return Scaffold(
          appBar: myAppBar(context, symbol),
          // title: symbol,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                  boxShadow: [
                
                    BoxShadow(
                        color: Color.fromRGBO(35, 174, 132, 0.12),
                        offset: Offset(0, Adapt.px(4)),
                        blurRadius: Adapt.px(12)),
                  ],
                ),
                padding: EdgeInsets.fromLTRB(0, 25, 0, 25),
                child: Column(
                  children: <Widget>[
                    Text(
                      I18n.of(context).my['totalAssets'],
                      style: TextStyle(
                        color: Config.color333,
                        fontSize: Adapt.px(30),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: Text(
                        Fmt.token(balancesInfo.total, decimals, length: 3),
                        style: TextStyle(
                          color: Config.color333,
                          fontSize: Adapt.px(60),
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Builder(
                      builder: (_) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(right: 12),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        dic['locked'],
                                        style: TextStyle(
                                          color: Config.color999,
                                          fontSize: Adapt.px(32),
                                        ),
                                      ),
                                      lockedInfo.length > 2
                                          ? TapTooltip(
                                              message: lockedInfo,
                                              child: Padding(
                                                padding:
                                                    EdgeInsets.only(right: 6),
                                                child: Image.asset(
                                                    'assets/images/a/assets-tips.png'),
                                              ),
                                              waitDuration:
                                                  Duration(seconds: 0),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    Fmt.token(
                                        balancesInfo.lockedBalance, decimals),
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: Adapt.px(32),
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: <Widget>[
                                Text(
                                  dic['available'],
                                  style: TextStyle(
                                    color: Config.color999,
                                    fontSize: Adapt.px(32),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  Fmt.token(
                                      balancesInfo.transferable, decimals),
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: Adapt.px(32),
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Text(
                                  dic['reserved'],
                                  style: TextStyle(
                                    color: Config.color999,
                                    fontSize: Adapt.px(32),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  Fmt.token(balancesInfo.reserved, decimals),
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: Adapt.px(32),
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                    SizedBox(height: Adapt.px(40)),

             
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(15),
                            child: RaisedButton(
                              padding: EdgeInsets.all(10),
                              elevation: 0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(right: 16),
                                    child: Image.asset(
                                        'assets/images/a/assets-send.png'),
                                  ),
                                  Text(
                                    I18n.of(context).assets['transfer'],
                                    style: TextStyle(color: Colors.white),
                                  )
                                ],
                              ),
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  TransferPage.route,
                                  arguments: TransferPageParams(
                                    redirect: Asset.route,
                                    symbol: symbol,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(15),
                            child: RaisedButton(
                              elevation: 0,
                              color: Colors.green,
                              padding: EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(right: 16),
                                    child: Image.asset(
                                        'assets/images/a/assets-receive-qr.png'),
                                  ),
                                  Text(
                                    I18n.of(context).assets['receive'],
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                              onPressed: () {
                                Navigator.pushNamed(context, AddressQR.route);
                              },
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              //  Divider(),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Center(
                  child: Flex(
                    direction: Axis.horizontal,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(
                          margin: EdgeInsets.only(right: 20),
                          child: TabBar(
                            tabs: _tabTxt
                                .map((e) => Text(
                                      I18n.of(context).assets[e],
                                      style: TextStyle(fontSize: Adapt.px(30)),
                                    ))
                                .toList(),
                            isScrollable: false,
                            labelPadding: EdgeInsets.all(0),
                            controller: _tabController,
                            indicatorColor: MyColors.text,
                            labelColor: MyColors.text,
                            labelStyle: TextStyle(
                                fontSize: 22,
                                color: MyColors.text,
                                fontWeight: FontWeight.bold),
                            // indicator: const BoxDecoration(),
                            unselectedLabelColor: MyColors.text_gray,
                            unselectedLabelStyle:
                                TextStyle(fontSize: 18, color: MyColors.text),
                            indicatorSize: TabBarIndicatorSize.label,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(
                  dragStartBehavior: DragStartBehavior.start,
                  controller: _tabController,
                  children: _tabTxt
                      .asMap()
                      .keys
                      .map(
                        (i) => Container(
                          key: ObjectKey(i),
                          child: RefreshLoadmore(
                            onRefresh: _onRefresh,
                            onLoadmore: _getData,
                            noMoreText: I18n.of(context).assets['end'],
                            isLastPage:
                                _transList[i] == null || _transList[i].isEmpty
                                    ? false
                                    : _isLastPage,
                            child: mainList(context, _transList[i]),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
