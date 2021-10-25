import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:ipsewallet/config/config.dart';
import 'package:ipsewallet/model/ipse_mining_history_model.dart';
import 'package:ipsewallet/service/substrate_api/api.dart';
import 'package:ipsewallet/store/app.dart';
import 'package:ipsewallet/utils/UI.dart';
import 'package:ipsewallet/utils/adapt.dart';
import 'package:ipsewallet/utils/format.dart';
import 'package:ipsewallet/utils/i18n/index.dart';
import 'package:ipsewallet/widgets/loading_widget.dart';
import 'package:ipsewallet/widgets/my_appbar.dart';
import 'package:ipsewallet/widgets/no_data.dart';

class IpseMinerMiningHistory extends StatefulWidget {
  IpseMinerMiningHistory(this.appStore, this.address);
  final AppStore appStore;
  final String address;

  @override
  _IpseMinerMiningHistoryState createState() =>
      _IpseMinerMiningHistoryState(appStore);
}

class _IpseMinerMiningHistoryState extends State<IpseMinerMiningHistory> {
  _IpseMinerMiningHistoryState(this.store);
  final AppStore store;
  IpseMiningHistoryModel _ipseMiningHistory;
  bool loading = true;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });
  }

  Future<void> _fetchData() async {
    IpseMiningHistoryModel res =
        await webApi.ipse.fetchIpseMinersMiningHistoryList(widget.address);
    if (res != null && res.history != null && res.history.length > 0) {
      res.history.sort((a, b) => b[0].compareTo(a[0]));
    }

    if (mounted) {
      setState(() {
        loading = false;
        _ipseMiningHistory = res;
      });
    }
  }

  List<Widget> _getListWidget(int decimals, String symbol, Map dic) {
    List<Widget> listWidget = [];
    for (var i = 0; i < _ipseMiningHistory.history.length; i++) {
      List list = _ipseMiningHistory.history[i];
      listWidget.add(Container(
        decoration: BoxDecoration(
          border: i + 1 == _ipseMiningHistory.history.length
              ? null
              : Border(
                  bottom: BorderSide(
                    width: Adapt.px(1),
                    color: Color(0xFFEFEFEF),
                  ),
                ),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.only(right: 15),
          title: Text(
            "${dic['block_num']} ${list[0]}",
            style: TextStyle(color: Config.color666),
          ),
          trailing: Text(
            "+" + Fmt.token(BigInt.parse(list[1].toString()), decimals) + " $symbol",
            style: TextStyle(color: Config.color999),
          ),
        ),
      ));
    }
    return listWidget;
  }

  @override
  Widget build(BuildContext context) {
    Map dic = I18n.of(context).ipse;
    final int decimals = store.settings.networkState.tokenDecimals;
    final String symbol = store.settings.networkState.tokenSymbol;
    return Observer(builder: (_) {
      List<Widget> listWidget = [];
      String totalNum;
      if (_ipseMiningHistory != null &&
          _ipseMiningHistory.history != null &&
          _ipseMiningHistory.history.isNotEmpty) {
        listWidget = _getListWidget(decimals, symbol, dic);
        totalNum = _ipseMiningHistory.totalNum.toString();
      }
      return Scaffold(
        appBar: myAppBar(
          context,
          dic['miner'] + dic['mining_history'],
          isThemeBg: true,
        ),
        backgroundColor: Theme.of(context).primaryColor,
        body: RefreshIndicator(
          onRefresh: _fetchData,
          key: globalPocMinerMiningHistoryfreshKey,
          child: ListView(
            children: [
              totalNum != null
                  ? Center(
                      child: Column(
                      children: [
                        Text(
                          dic['total_mining_num'],
                          style: TextStyle(
                              fontSize: Adapt.px(22), color: Colors.white),
                        ),
                        SizedBox(height: 10),
                        Text(
                          totalNum,
                          style: TextStyle(
                              fontSize: Adapt.px(62), color: Colors.white),
                        ),
                      ],
                    ))
                  : Container(),
              SizedBox(height: 15),
              Container(
                color: Config.bgColor,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal:15,vertical:8),
                      child: Text(
                        I18n.of(context).ipse["reward_desc"],
                        style: TextStyle(
                          fontSize: Adapt.px(26),
                          color: Config.color666,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 5, top: 2),
                            width: Adapt.px(6),
                            height: Adapt.px(33),
                            color: Theme.of(context).primaryColor,
                          ),
                          Text(
                            dic['latest_data100'],
                            style: TextStyle(
                              fontSize: Adapt.px(30),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    loading
                        ? Padding(
                            padding: EdgeInsets.only(top: 150, bottom: 650),
                            child: LoadingWidget(),
                          )
                        : _ipseMiningHistory == null
                            ? Padding(
                                padding: EdgeInsets.only(top: 150, bottom: 650),
                                child: NoData(),
                              )
                            : _ipseMiningHistory.history != null &&
                                    _ipseMiningHistory.history.length > 0
                                ? Container(
                                    padding:
                                        EdgeInsets.only(left: 15, bottom: 650),
                                    child: Column(children: listWidget),
                                  )
                                : NoData(),
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
