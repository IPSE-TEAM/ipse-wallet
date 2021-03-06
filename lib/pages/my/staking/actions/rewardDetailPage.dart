import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ipsewallet/pages/my/assets/transfer/tx_detail.dart';
import 'package:ipsewallet/store/app.dart';
import 'package:ipsewallet/store/staking/types/stakingTxData.dart';

import 'package:ipsewallet/utils/format.dart';
import 'package:ipsewallet/utils/i18n/index.dart';


class RewardDetailPage extends StatelessWidget {
  RewardDetailPage(this.store);

  static final String route = '/staking/rewards';
  final AppStore store;

  @override
  Widget build(BuildContext context) {
    var dic = I18n.of(context).staking;
    final int decimals = store.settings.networkState.tokenDecimals;
    final String symbol = store.settings.networkState.tokenSymbol;
    final StakingTxRewardData detail = ModalRoute.of(context).settings.arguments;

    return TxDetail(
      networkName: store.settings.networkName,
      success: true,
      action: detail.eventId,
      hash: detail.extrinsicHash,
      eventId: detail.eventIndex,
      info: <DetailInfoItem>[
        DetailInfoItem(label: dic['txs.event'], title: detail.eventId),
        DetailInfoItem(
          label: I18n.of(context).assets['amount'],
          title: '${Fmt.balance(detail.amount, decimals)} $symbol',
        ),
      ],
      blockTime: Fmt.dateTime(
          DateTime.fromMillisecondsSinceEpoch(detail.blockTimestamp )),
      blockNum: detail.blockNum,
    );
  }
}
