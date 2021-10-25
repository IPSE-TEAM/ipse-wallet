
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:ipsewallet/config/config.dart';
import 'package:ipsewallet/model/ipse_order_model.dart';
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

class IpseMinerOrders extends StatefulWidget {
  IpseMinerOrders(this.appStore);
  final AppStore appStore;
  static String route = "/my/ipseMinerOrders";
  @override
  _IpseMinerOrdersState createState() => _IpseMinerOrdersState(appStore);
}

class _IpseMinerOrdersState extends State<IpseMinerOrders> {
  _IpseMinerOrdersState(this.store);

  final AppStore store;
  List<IpseOrderModel> orderList;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getData();
    });
  }

  Future<void> _getData() async {
    List<IpseOrderModel> data = await webApi.ipse.fetchIpseMinerOrderList();
    setState(() {
      orderList = data;
    });
  }

  List<Widget> _getListWidget(Map dic) {
    List<Widget> listWidget = [];
    for (var i = 0; i < orderList.length; i++) {
      IpseOrderModel order = orderList[i];
      listWidget.add(Container(
        decoration: BoxDecoration(
          border: i + 1 == orderList.length
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
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(dic[order.status]),
              Text(Fmt.dateTime(
                  DateTime.fromMillisecondsSinceEpoch(order.updateTs))),
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
    return Observer(builder: (_) {
      List<Widget> listWidget = [];
      if (orderList != null && orderList.isNotEmpty) {
        listWidget = _getListWidget(dic);
      }

      return Scaffold(
        appBar: myAppBar(
          context,
          dic['confirmed_orders'],
        ),
        body: Container(
          child: Column(
            children: [
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
                      dic['latest_data100'],
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
                  onRefresh: _getData,
                  key: globalIpseMinerOrdersRefreshKey,
                  child: ListView(
                    children: [
                      SizedBox(height: 15),
                      store.ipse == null || orderList == null
                          ? LoadingWidget()
                          : orderList.length > 0
                              ? Container(
                                  padding: EdgeInsets.only(left: 15),
                                  child: Column(children: listWidget),
                                )
                              : NoData(),
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
