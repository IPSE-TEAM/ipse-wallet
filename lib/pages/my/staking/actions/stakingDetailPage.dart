import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ipsewallet/pages/my/assets/transfer/tx_detail.dart';
import 'package:ipsewallet/store/app.dart';
import 'package:ipsewallet/store/staking/types/stakingTxData.dart';
import 'package:ipsewallet/utils/format.dart';
import 'package:ipsewallet/utils/i18n/index.dart';

class StakingDetailPage extends StatelessWidget {
  StakingDetailPage(this.store);

  static final String route = '/staking/tx';
  final AppStore store;

  @override
  Widget build(BuildContext context) {
    var dic = I18n.of(context).staking;
    final int decimals = store.settings.networkState.tokenDecimals;
    final StakingTxData detail = ModalRoute.of(context).settings.arguments;
    List<DetailInfoItem> info = <DetailInfoItem>[
      DetailInfoItem(label: dic['action'], title: detail.call),
    ];
    List params = jsonDecode(detail.params);
    info.addAll(params.map((i) {
      String value = i['value'].toString();
      switch (i['type']) {
        case "Address":
          value = Fmt.address(value);
          break;
        case "Compact<BalanceOf>":
          final symbol = store.settings.networkState.tokenSymbol;
          value = '${Fmt.balance(value, decimals)} $symbol';
          break;
        case "AccountId":
          value = value.contains('0x') ? value : '0x$value';
          String address = store
              .account.pubKeyAddressMap[store.settings.endpoint.ss58][value];
          value = Fmt.address(address);
          break;
      }
      return DetailInfoItem(
        label: i['name'],
        title: value,
      );
    }));
    return TxDetail(
      networkName: store.settings.networkName,
      success: detail.success,
      action: detail.call,
      hash: detail.hash,
      eventId: detail.txNumber,
      info: info,
      blockTime: Fmt.dateTime(
          DateTime.fromMillisecondsSinceEpoch(detail.blockTimestamp )),
      blockNum: detail.blockNum,
    );
  }
}
