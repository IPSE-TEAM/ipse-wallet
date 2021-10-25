import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:ipsewallet/config/config.dart';
import 'package:ipsewallet/model/ipse_order_model.dart';
import 'package:ipsewallet/pages/my/add_label/ipse_miner_manage/ipse_miner_manage.dart';
import 'package:ipsewallet/pages/my/add_label/ipse_miner_register.dart';
import 'package:ipsewallet/pages/my/add_label/ipse_miner_select.dart';
import 'package:ipsewallet/pages/my/add_label/order_detail.dart';
import 'package:ipsewallet/service/substrate_api/api.dart';
import 'package:ipsewallet/store/app.dart';
import 'package:ipsewallet/utils/UI.dart';
import 'package:ipsewallet/utils/adapt.dart';
import 'package:ipsewallet/utils/format.dart';
import 'package:ipsewallet/utils/i18n/index.dart';
import 'package:ipsewallet/widgets/loading_widget.dart';
import 'package:ipsewallet/widgets/my_appbar.dart';
import 'package:ipsewallet/widgets/no_data.dart';

class AddLabel extends StatefulWidget {
  AddLabel(this.appStore);
  final AppStore appStore;
  static String route = "/my/addLabel";
  @override
  _AddLabelState createState() => _AddLabelState(appStore);
}

class _AddLabelState extends State<AddLabel> {
  _AddLabelState(this.store);
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
      webApi.ipse.fetchIpseRegisterStatus(),
      webApi.ipse.fetchIpseMinersList(),
      webApi.ipse.fetchIpseOrderList(),
    ]);
  }

  List<Widget> _getListWidget(Map dic) {
    List<Widget> listWidget = [];
    for (var i = 0; i < store.ipse.ipseListOrder.length; i++) {
      IpseOrderModel order = store.ipse.ipseListOrder[i];
      listWidget.add(Container(
        decoration: BoxDecoration(
          border: i + 1 == store.ipse.ipseListOrder.length
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
          title: Text(Fmt.address(order.hash)),
          subtitle: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: Text(Fmt.dateTime(DateTime.fromMillisecondsSinceEpoch(order.updateTs)))),
              SizedBox(width:10),
              Text(dic[order.status]),
            ],
          ),
          trailing: Image.asset('assets/images/a/more.png'),
          onTap: () =>
              Navigator.pushNamed(context, OrderDetail.route, arguments: order),
        ),
      ));
    }
    return listWidget;
  }

  @override
  Widget build(BuildContext context) {
    Map dic = I18n.of(context).ipse;
    return Observer(builder: (_) {
      List<Widget> listWidget = [];
      if (store.ipse.ipseListOrder != null &&
          store.ipse.ipseListOrder.isNotEmpty) {
        listWidget = _getListWidget(dic);
      }
      return Scaffold(
        appBar: myAppBar(context, I18n.of(context).ipse['add_label'],
            isThemeBg: true),
        backgroundColor: Theme.of(context).primaryColor,
        body: Container(
          color: Config.bgColor,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    border: Border.all(
                      color: Theme.of(context).primaryColor,
                    )),
                padding: EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 8, bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          store.ipse.ipseRegisterStatus == null
                              ? GestureDetector(
                                  onTap: () => Navigator.of(context)
                                      .pushNamed(IpseMinerRegister.route),
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
                                      .pushNamed(IpseMinerManage.route),
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
                            onTap: () => Navigator.of(context)
                                .pushNamed(IpseMinerSelect.route),
                            child: Row(
                              children: [
                                Image.asset(
                                    'assets/images/ipse/go-mortgage.png'),
                                SizedBox(width: 3),
                                Text(
                                  dic['add_label'],
                                  style: TextStyle(
                                      color: Colors.white,
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
                      dic['new_order_list'],
                      style: TextStyle(
                        fontSize: Adapt.px(30),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _fetchData,
                  key: globalAddLabelRefreshKey,
                  child: ListView(
                    children: [
                      SizedBox(height: 15),
                      store.ipse == null || store.ipse.ipseListOrder == null
                          ? LoadingWidget()
                          : store.ipse.ipseListOrder.length > 0
                              ? Container(
                                  padding: EdgeInsets.only(left: 15),
                                  child: Column(children: listWidget),
                                )
                              : NoData(),
                      // store.ipse.ipseListOrder != null &&
                      //         store.ipse.ipseListOrder.isNotEmpty
                      //     ? FutureBuilder(
                      //         future: webApi.account.getAddressIcons(
                      //             store.ipse.pocMinersOf.toList()),
                      //         builder: (_, __) => Container(),
                      //       )
                      //     : Container(),
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
