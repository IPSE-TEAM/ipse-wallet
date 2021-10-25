import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:ipsewallet/config/config.dart';
import 'package:ipsewallet/pages/my/mortgage/miner_manage/miner_manage.dart';
import 'package:ipsewallet/pages/my/mortgage/mortgage_detail.dart';
import 'package:ipsewallet/pages/my/mortgage/poc_register.dart';
import 'package:ipsewallet/pages/my/mortgage/user_mortgage.dart';
import 'package:ipsewallet/service/substrate_api/api.dart';
import 'package:ipsewallet/store/app.dart';
import 'package:ipsewallet/utils/UI.dart';
import 'package:ipsewallet/utils/adapt.dart';
import 'package:ipsewallet/utils/format.dart';
import 'package:ipsewallet/utils/i18n/index.dart';
import 'package:ipsewallet/utils/my_utils.dart';
import 'package:ipsewallet/widgets/address_icon.dart';
import 'package:ipsewallet/widgets/loading_widget.dart';
import 'package:ipsewallet/widgets/my_appbar.dart';
import 'package:ipsewallet/widgets/no_data.dart';
import 'package:ipsewallet/widgets/poc_mortage_lock_card.dart';

class Mortgage extends StatefulWidget {
  Mortgage(this.appStore);
  final AppStore appStore;
  static String route = "/my/mortgage";
  @override
  _MortgageState createState() => _MortgageState(appStore);
}

class _MortgageState extends State<Mortgage> {
  _MortgageState(this.store);
  final AppStore store;

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
      webApi.ipse.fetchPocIsChillTime(),
      webApi.ipse.fetchPocChillTime(),
      webApi.ipse.fetchPocMinersOf(),
      webApi.ipse.fetchPoclockList(),
    ]);
  }

  _showNotOpTips() {
    showErrorMsg(I18n.of(context).ipse['cooling_cannot_op']);
  }

  List<Widget> _getListWidget() {
    List<Widget> listWidget = [];
    for (var i = 0; i < store.ipse.pocMinersOf.length; i++) {
      String e = store.ipse.pocMinersOf[i];
      listWidget.add(Container(
        decoration: BoxDecoration(
          border: i + 1 == store.ipse.pocMinersOf.length
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
          leading: AddressIcon(e),
          title: Text(Fmt.address(e)),
          trailing: Image.asset('assets/images/a/more.png'),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MortgageDetail(store, e),
            ),
          ),
        ),
      ));
    }
    return listWidget;
  }

  @override
  Widget build(BuildContext context) {
    Map dic = I18n.of(context).ipse;
    int decimals = store.settings.networkState.tokenDecimals;
    String symbol = store.settings.networkState.tokenSymbol;
    int blockDuration =
        store.settings.networkConst['babe']['expectedBlockTime'];
    return Observer(builder: (_) {
      Color coolingColor =
          store.ipse.pocIsChillTime == null || store.ipse.pocIsChillTime
              ? Colors.white70
              : Colors.white;
      List<Widget> listWidget = [];
      if (store.ipse.pocMinersOf != null && store.ipse.pocMinersOf.isNotEmpty) {
        listWidget = _getListWidget();
      }
      return Scaffold(
        appBar: myAppBar(
          context,
          'PoC' + I18n.of(context).ipse['mortgage'],
          isThemeBg: true,
        ),
        backgroundColor: Theme.of(context).primaryColor,
        body: Container(
          color: Config.bgColor,
          child: Column(
            children: [
              Container(
                color: Theme.of(context).primaryColor,
                padding: EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 8, bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          store.ipse.pocRegisterStatus == null
                              ? GestureDetector(
                                  onTap: () => Navigator.of(context)
                                      .pushNamed(PocRegister.route),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                          'assets/images/ipse/miner-register.png'),
                                      SizedBox(width: 3),
                                      Text(
                                        dic['miner_register'],
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: Adapt.px(28)),
                                      ),
                                    ],
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () => Navigator.of(context)
                                      .pushNamed(MinerManage.route),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                          'assets/images/ipse/miner-manage.png'),
                                      SizedBox(width: 3),
                                      Text(
                                        dic['miner_manage'],
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: Adapt.px(28)),
                                      ),
                                    ],
                                  ),
                                ),
                          GestureDetector(
                            onTap:
                               
                                store.ipse.pocIsChillTime == null ||
                                        store.ipse.pocIsChillTime
                                    ? _showNotOpTips:
                                () => Navigator.of(context)
                                    .pushNamed(UserMortgage.route),
                            child: Row(
                              children: [
                                Image.asset(
                                    'assets/images/ipse/go-mortgage.png'),
                                SizedBox(width: 3),
                                Text(
                                  dic['participate_in_mortgage'],
                                  style: TextStyle(
                                      color: coolingColor,
                                      fontSize: Adapt.px(28)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _fetchData,
                  key: globalMortgageRefreshKey,
                  child: ListView(
                    children: [
                      PocMortageLockCard(
                        store: store,
                        lockDataList: store.ipse.poclockList?.toList(),
                        decimals: decimals,
                        symbol: symbol,
                        blockTime: store.ipse.newHeads?.number,
                        blockDuration: blockDuration,
                        networkLoading: store.settings.loading,
                      ),
                      SizedBox(height: 15),
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
                              dic['my_mortgage'],
                              style: TextStyle(
                                fontSize: Adapt.px(30),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 15),
                      store.ipse == null || store.ipse.pocMinersOf == null
                          ? LoadingWidget()
                          : store.ipse.pocMinersOf.length > 0
                              ? Container(
                                  padding: EdgeInsets.only(left: 15),
                                  child: Column(children: listWidget),
                                )
                              : NoData(),
                      store.ipse.pocMinersOf != null &&
                              store.ipse.pocMinersOf.isNotEmpty
                          ? FutureBuilder(
                              future: webApi.account.getAddressIcons(
                                  store.ipse.pocMinersOf.toList()),
                              builder: (_, __) => Container(),
                            )
                          : Container(),
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
