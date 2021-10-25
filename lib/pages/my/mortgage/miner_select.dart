import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:ipsewallet/model/poc_staking_info_model.dart';
import 'package:ipsewallet/pages/my/mortgage/mortgage_detail.dart';
import 'package:ipsewallet/pages/my/mortgage/poc_miner_mining_history.dart';
import 'package:ipsewallet/service/substrate_api/api.dart';
import 'package:ipsewallet/store/app.dart';
import 'package:ipsewallet/utils/format.dart';
import 'package:ipsewallet/utils/i18n/index.dart';
import 'package:ipsewallet/widgets/loading_widget.dart';
import 'package:ipsewallet/widgets/my_appbar.dart';
import 'package:ipsewallet/widgets/no_data.dart';

class MinerSelect extends StatefulWidget {
  MinerSelect(this.appStore);
  final AppStore appStore;
  static String route = "/my/mortgage/minerselect";
  @override
  _MinerSelectState createState() => _MinerSelectState(appStore);
}

class _MinerSelectState extends State<MinerSelect> {
  _MinerSelectState(this.store);
  final AppStore store;

  BigInt computeNeedAmount(BigInt disk) {
   
    return BigInt.from((store.ipse.pocGlobalData.capacityPrice) *
        disk /
        BigInt.from(1024) /
        1024 /
        1024);
  }

  @override
  Widget build(BuildContext context) => Observer(
        builder: (_) {
          if (store.ipse.pocMinersList != null &&
              store.ipse.pocMinersList.isNotEmpty) {
            webApi.account.getAddressIcons(
                store.ipse.pocMinersList.map((e) => e.miner).toList());
          }
          Map dic = I18n.of(context).ipse;
          int decimals = store.settings.networkState.tokenDecimals;
          String symbol = store.settings.networkState.tokenSymbol;
          return Scaffold(
            appBar: myAppBar(context, I18n.of(context).ipse['miner']),
            body: store.ipse.pocMinersList != null
                ? store.ipse.pocMinersList.isNotEmpty
                    ? Container(
                        child: ListView(
                          children: store.ipse.pocMinersList
                              .map((PocStakingInfoModel i) {
                            String address = i.miner;

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
                                leading: IconButton(
                                  iconSize:35,
                                  icon: Icon(Icons.account_circle),
                                  onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          MortgageDetail(store, address),
                                    ),
                                  ),
                                ),
                                title: Text(
                                  Fmt.address(address),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    i.isStop != null && i.isStop
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Icon(
                                                Icons.warning_rounded,
                                                color: Colors.red,
                                                size: 16,
                                              ),
                                              Text(
                                                dic['mining_stopped'],
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          )
                                        : Container(),
                                    Text(
                                      '${dic['mortgage_ranking_amount']}: ${Fmt.token(i.minerStaking, decimals, length: decimals)} $symbol',
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .unselectedWidgetColor,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      '${dic['need_mortgage_amount']}: ${store.ipse.pocGlobalData?.capacityPrice==null?"~":Fmt.token(computeNeedAmount(i.disk), decimals, length: decimals)}  $symbol',
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .unselectedWidgetColor,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      '${dic['total_mortgage_amount']}: ${Fmt.token(i.totalStaking, decimals, length: decimals)}  $symbol',
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .unselectedWidgetColor,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      '${dic['commission']}: ${i.minerProportion}%',
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .unselectedWidgetColor,
                                        fontSize: 12,
                                      ),
                                    ),
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
                                          PocMinerMiningHistory(store, address),
                                    ),
                                  ),
                                ),
                                onTap: () => Navigator.of(context).pop(address),
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
