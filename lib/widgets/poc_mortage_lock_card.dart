import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ipsewallet/config/config.dart';
import 'package:ipsewallet/pages/my/my.dart';
import 'package:ipsewallet/pages/my/tx_confirm_page.dart';
import 'package:ipsewallet/store/app.dart';
import 'package:ipsewallet/utils/adapt.dart';
import 'package:ipsewallet/utils/format.dart';
import 'package:ipsewallet/utils/i18n/index.dart';
import 'package:ipsewallet/widgets/loading_widget.dart';
import 'package:ipsewallet/widgets/tap_tooltip.dart';

class PocMortageLockCard extends StatelessWidget {
  PocMortageLockCard({
    this.store,
    this.lockDataList,
    this.decimals,
    this.symbol,
    this.blockTime,
    this.blockDuration,
    this.networkLoading,
  });

  final AppStore store;
  final List lockDataList;
  final int decimals;
  final int blockTime;
  final int blockDuration;

  final String symbol;
  final bool networkLoading;

  Future<void> _pocRedeem(BuildContext context) async {
    var args = {
      "title": I18n.of(context).staking['action.redeem'],
      "txInfo": {
        "module": 'pocStaking',
        "call": 'unlock',
      },
      "detail": jsonEncode({}),
      "params": [],
      'onFinish': (BuildContext txPageContext, Map res) {
        // globalMortgageRefreshKey.currentState.show();
        Navigator.popUntil(txPageContext, ModalRoute.withName(My.route));
      }
    };
    Navigator.of(context).pushNamed(TxConfirmPage.route, arguments: args);
  }

  @override
  Widget build(BuildContext context) {
    BigInt unlocking = BigInt.zero;
    List unlockingList = [];
    BigInt redeemable = BigInt.zero;

    final Map<String, String> dic = I18n.of(context).staking;
    final Map<String, String> dicGov = I18n.of(context).gov;
    Color actionButtonColor = Theme.of(context).primaryColor;
    if (lockDataList != null && blockDuration != null) {
      lockDataList.forEach((e) => {
            if (e[0] > blockTime)
              {
                unlockingList.add(e),
                unlocking = unlocking + BigInt.parse(e[1].toString()),
              }
            else
              {redeemable = redeemable + BigInt.parse(e[1].toString())},
          });
    }

    final unlockDetail = unlockingList
        .map((e) {
          return '${dic['bond.unlocking']}:  ${Fmt.balance(e[1].toString(), decimals)}\n'
              '${dicGov['remain']}:  ${Fmt.blockToTime(e[0] - blockTime, blockDuration)}';
        })
        .toList()
        .join('\n\n');
    return Card(
      elevation: 0,
      margin: EdgeInsets.all(
        15,
      ),
      child: Container(
        height: Adapt.px(170),
        padding: EdgeInsets.only(top: 15, bottom: 15),
        child: lockDataList == null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LoadingWidget(),
                ],
              )
            : Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          dic['bond.unlocking'] + "($symbol)",
                          style: TextStyle(
                            color: Config.color999,
                            fontSize: Adapt.px(24),
                          ),
                        ),
                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            unlocking > BigInt.zero
                                ? TapTooltip(
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 2),
                                      child: Icon(
                                        Icons.access_time,
                                        size: 20,
                                        color: actionButtonColor,
                                      ),
                                    ),
                                    message: '\n$unlockDetail\n',
                                  )
                                : Container(),
                            Text(
                              Fmt.priceFloorBigInt(unlocking, decimals,
                                  lengthMax: 3),
                              style: TextStyle(
                                fontSize: Adapt.px(30),
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).unselectedWidgetColor,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    color: Color(0xFFE6E6E6),
                    width: Adapt.px(1),
                    height: Adapt.px(100),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          dic['bond.redeemable'] + "($symbol)",
                          style: TextStyle(
                            color: Config.color999,
                            fontSize: Adapt.px(24),
                          ),
                        ),
                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              Fmt.priceFloorBigInt(
                                redeemable,
                                decimals,
                                lengthMax: 3,
                              ),
                              style: TextStyle(
                                fontSize: Adapt.px(30),
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).unselectedWidgetColor,
                              ),
                            ),
                            redeemable > BigInt.zero
                                ? GestureDetector(
                                    child: Container(
                                      padding: EdgeInsets.only(left: 4),
                                      child: Icon(
                                        Icons.lock_open,
                                        size: 20,
                                        color: actionButtonColor,
                                      ),
                                    ),
                                    onTap: () => _pocRedeem(context),
                                  )
                                : Container()
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
