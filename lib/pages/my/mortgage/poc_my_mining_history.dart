import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:ipsewallet/config/config.dart';
import 'package:ipsewallet/service/substrate_api/api.dart';
import 'package:ipsewallet/store/app.dart';
import 'package:ipsewallet/utils/UI.dart';
import 'package:ipsewallet/utils/adapt.dart';
import 'package:ipsewallet/utils/format.dart';
import 'package:ipsewallet/utils/i18n/index.dart';
import 'package:ipsewallet/widgets/loading_widget.dart';
import 'package:ipsewallet/widgets/my_appbar.dart';
import 'package:ipsewallet/widgets/no_data.dart';

class PocMyMiningHistory extends StatefulWidget {
  PocMyMiningHistory(this.appStore);
  final AppStore appStore;
  static String route = "/my/mortgage/PocMyMiningHistory";

  @override
  _PocMyMiningHistoryState createState() => _PocMyMiningHistoryState(appStore);
}

class _PocMyMiningHistoryState extends State<PocMyMiningHistory> {
  _PocMyMiningHistoryState(this.store);
  final AppStore store;
  List _pocMyMiningHistory;
  bool loading = true;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });
  }

  Future<void> _fetchData() async {
    List res = await webApi.ipse.fetchPocMyMiningHistoryList();
    if (res != null && res.length > 0) {
      res.sort((a, b) => b[0].compareTo(a[0]));
    }

    if (mounted) {
      setState(() {
        loading = false;
        _pocMyMiningHistory = res;
      });
    }
  }

  List<Widget> _getListWidget(int decimals, String symbol, Map dic) {
    List<Widget> listWidget = [];
    for (var i = 0; i < _pocMyMiningHistory.length; i++) {
      List list = _pocMyMiningHistory[i];
      listWidget.add(Container(
        decoration: BoxDecoration(
          border: i + 1 == _pocMyMiningHistory.length
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

      if (_pocMyMiningHistory != null && _pocMyMiningHistory.isNotEmpty) {
        listWidget = _getListWidget(decimals, symbol, dic);
      }
      return Scaffold(
        appBar: myAppBar(
          context,
          dic['my'] + dic['mining_history'],
        ),
        body: RefreshIndicator(
          onRefresh: _fetchData,
          key: globalPocMyMiningHistoryfreshKey,
          child: ListView(
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
                      child: LoadingWidget())
                  : _pocMyMiningHistory == null ||
                          _pocMyMiningHistory.length > 0
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
      );
    });
  }
}
