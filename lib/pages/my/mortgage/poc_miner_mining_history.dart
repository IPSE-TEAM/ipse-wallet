import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:ipsewallet/config/config.dart';
import 'package:ipsewallet/model/poc_mining_history_model.dart';
import 'package:ipsewallet/service/substrate_api/api.dart';
import 'package:ipsewallet/store/app.dart';
import 'package:ipsewallet/utils/UI.dart';
import 'package:ipsewallet/utils/adapt.dart';
import 'package:ipsewallet/utils/format.dart';
import 'package:ipsewallet/utils/i18n/index.dart';
import 'package:ipsewallet/widgets/loading_widget.dart';
import 'package:ipsewallet/widgets/my_appbar.dart';
import 'package:ipsewallet/widgets/no_data.dart';

class PocMinerMiningHistory extends StatefulWidget {
  PocMinerMiningHistory(this.appStore, this.address);
  final AppStore appStore;
  final String address;

  @override
  _PocMinerMiningHistoryState createState() =>
      _PocMinerMiningHistoryState(appStore);
}

class _PocMinerMiningHistoryState extends State<PocMinerMiningHistory> {
  _PocMinerMiningHistoryState(this.store);
  final AppStore store;
  PocMiningHistoryModel _pocMiningHistory;
  bool loading = true;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });
  }

  Future<void> _fetchData() async {
    PocMiningHistoryModel res =
        await webApi.ipse.fetchPocMinersMiningHistoryList(widget.address);
    if (res != null && res.history != null && res.history.length > 0) {
      res.history.sort((a, b) => b[0].compareTo(a[0]));
    }

    if (mounted) {
      setState(() {
        loading = false;
        _pocMiningHistory = res;
      });
    }
  }

  List<Widget> _getListWidget(int decimals, String symbol, Map dic) {
    List<Widget> listWidget = [];
    for (var i = 0; i < _pocMiningHistory.history.length; i++) {
      List list = _pocMiningHistory.history[i];
      listWidget.add(Container(
        decoration: BoxDecoration(
          border: i + 1 == _pocMiningHistory.history.length
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
      if (_pocMiningHistory != null &&
          _pocMiningHistory.history != null &&
          _pocMiningHistory.history.isNotEmpty) {
        listWidget = _getListWidget(decimals, symbol, dic);
        totalNum = _pocMiningHistory.totalNum.toString();
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
                          style: TextStyle(fontSize: Adapt.px(22),color: Colors.white),
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
                            dic['latest_data300'],
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
                        : _pocMiningHistory == null
                            ? Padding(
                                padding: EdgeInsets.only(top: 150, bottom: 650),
                                child: NoData(),
                              )
                            : _pocMiningHistory.history != null &&
                                    _pocMiningHistory.history.length > 0
                                ? Container(
                                    padding: EdgeInsets.only(left: 15),
                                    child: Column(children: listWidget),
                                  )
                                : Padding(
                                  padding: EdgeInsets.only(top: 150, bottom: 650),
                                  child: NoData(),
                                ),
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
