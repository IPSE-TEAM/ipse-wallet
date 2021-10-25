import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:ipsewallet/config/config.dart';
import 'package:ipsewallet/model/ipse_order_model.dart';
import 'package:ipsewallet/store/app.dart';
import 'package:ipsewallet/utils/adapt.dart';
import 'package:ipsewallet/utils/format.dart';
import 'package:ipsewallet/utils/i18n/index.dart';
import 'package:ipsewallet/utils/my_utils.dart';
import 'package:ipsewallet/widgets/gradient_bg.dart';
import 'package:ipsewallet/widgets/my_tile.dart';

class OrderDetail extends StatefulWidget {
  OrderDetail(this.store);

  final AppStore store;
  static String route = "/my/addlabel/ipseOrderDetail";
  @override
  _OrderDetailState createState() => _OrderDetailState(store);
}

class _OrderDetailState extends State<OrderDetail> {
  _OrderDetailState(this.store);

  final AppStore store;

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
          final IpseOrderModel order =
              ModalRoute.of(context).settings.arguments;

          return GredientBg(
            title: dic['order_detail'],
            child: ListView(
              children: <Widget>[
                Card(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 8, bottom: 8),
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(24),
                                child: order.status == 'Confirmed'
                                    ? Image.asset(
                                        'assets/images/a/receive-success.png')
                                    : Image.asset(
                                        'assets/images/a/confirming.png'),
                              ),
                              Text(
                                dic[order.status],
                                style: Theme.of(context).textTheme.headline5,
                              ),
                              SizedBox(height: 55),
                              myTile(
                                noMore: true,
                                title: dic['miner'],
                                trailing: Fmt.address(order.miner),
                                onTap: () {
                                  copy(context, order.miner);
                                },
                              ),
                              myTile(
                                noMore: true,
                                title: dic['creator'],
                                trailing: Fmt.address(order.user),
                                onTap: () {
                                  copy(context, order.user);
                                },
                              ),
                              myTile(
                                noMore: true,
                                title: dic['price'],
                                trailing: Fmt.token(
                                        order.orders[0].totalPrice, decimals,
                                        length: decimals) +
                                    ' $symbol',
                              ),
                              myTile(
                                noMore: true,
                                title: dic['days'],
                                trailing: order.duration,
                              ),
                              myTile(
                                noMore: true,
                                title: dic['hash'],
                                trailing: Fmt.address(order.hash),
                                onTap: () {
                                  copy(context, order.hash);
                                },
                              ),
                              myTile(
                                noMore: true,
                                title: dic['label'],
                                trailing: order.label,
                                onTap: () {
                                  copy(context, order.label);
                                },
                              ),
                              myTile(
                                noMore: true,
                                title: dic['size'],
                                trailing:
                                    (order.size / 1024).toStringAsFixed(0) +
                                        ' kb',
                              ),
                              myTile(
                                noMore: true,
                                noborder: true,
                                title: dic['create_time'],
                                trailing: Fmt.dateTime(
                                    DateTime.fromMillisecondsSinceEpoch(
                                        order.updateTs)),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
