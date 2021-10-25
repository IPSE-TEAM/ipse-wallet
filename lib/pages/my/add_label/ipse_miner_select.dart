import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:ipsewallet/model/ipse_register_status_model.dart';
import 'package:ipsewallet/pages/my/add_label/create_order.dart';
import 'package:ipsewallet/pages/my/add_label/ipse_miner_mining_history.dart';
import 'package:ipsewallet/service/substrate_api/api.dart';
import 'package:ipsewallet/store/app.dart';
import 'package:ipsewallet/utils/format.dart';
import 'package:ipsewallet/utils/i18n/index.dart';
import 'package:ipsewallet/widgets/address_icon.dart';
import 'package:ipsewallet/widgets/loading_widget.dart';
import 'package:ipsewallet/widgets/my_appbar.dart';
import 'package:ipsewallet/widgets/no_data.dart';

class IpseMinerSelect extends StatefulWidget {
  IpseMinerSelect(this.appStore);
  final AppStore appStore;
  static String route = "/my/addlabel/ipseminerselect";
  @override
  _IpseMinerSelectState createState() => _IpseMinerSelectState(appStore);
}

class _IpseMinerSelectState extends State<IpseMinerSelect> {
  _IpseMinerSelectState(this.store);
  final AppStore store;

  @override
  Widget build(BuildContext context) => Observer(
        builder: (_) {
          if (store.ipse.ipseMinersList != null &&
              store.ipse.ipseMinersList.isNotEmpty) {
            webApi.account.getAddressIcons(
                store.ipse.ipseMinersList.map((e) => e.accountId).toList());
          }
          Map dic = I18n.of(context).ipse;
          int decimals = store.settings.networkState.tokenDecimals;
          String symbol = store.settings.networkState.tokenSymbol;
          return Scaffold(
            appBar: myAppBar(context, I18n.of(context).ipse['select_miner']),
            body: store.ipse.ipseMinersList != null
                ? store.ipse.ipseMinersList.isNotEmpty
                    ? Container(
                        child: ListView(
                          children: store.ipse.ipseMinersList
                              .map((IpseRegisterStatusModel i) {
                            String address = i.accountId;

                            Color grey = Theme.of(context).disabledColor;
                            return Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    width: 1,
                                    color: Color(0xffe5e5e5),
                                  ),
                                ),
                              ),
                              child: ListTile(
                                isThreeLine: true,
                                leading: AddressIcon(address),
                                title: Text(
                                  Fmt.address(address),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      '${i.nickname}',
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .unselectedWidgetColor,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      '${dic['mortgage_ranking_amount']}: ${Fmt.token(i.minerStaking, decimals, length: decimals)} $symbol',
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .unselectedWidgetColor,
                                        fontSize: 12,
                                      ),
                                    ),
                                    // Text(
                                    //   '${dic['expected_profits']}: ${Fmt.token(i.totalStaking, decimals, length: decimals)} $symbol',
                                    //   style: TextStyle(
                                    //     color: Theme.of(context)
                                    //         .unselectedWidgetColor,
                                    //     fontSize: 12,
                                    //   ),
                                    // ),
                                    Text(
                                      '${dic['unit_price']}: ${Fmt.token(i.unitPrice, decimals, length: decimals)} $symbol',
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .unselectedWidgetColor,
                                        fontSize: 12,
                                      ),
                                    )
                                  ],
                                ),
                                trailing: IconButton(
                                  icon: Icon(Icons.list_alt_rounded),
                                  iconSize: 18,
                                  color: grey,
                                  onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          IpseMinerMiningHistory(
                                              store, address),
                                    ),
                                  ),
                                ),
                                onTap: () => Navigator.of(context)
                                    .pushNamed(CreateOrder.route, arguments: i),
                              ),
                            );
                          }).toList(),
                        ),
                      )
                    : NoData()
                : Center(child: LoadingWidget()),
          );
        },
      );
}
