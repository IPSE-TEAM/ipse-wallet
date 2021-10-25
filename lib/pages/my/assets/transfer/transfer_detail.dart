import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ipsewallet/pages/my/assets/transfer/tx_detail.dart';
import 'package:ipsewallet/store/app.dart';
import 'package:ipsewallet/store/assets/types/transferData.dart';
import 'package:ipsewallet/utils/format.dart';
import 'package:ipsewallet/utils/i18n/index.dart';

class TransferDetailPage extends StatelessWidget {
  TransferDetailPage(this.store);

  static final String route = '/my/assets/tx';
  final AppStore store;

  @override
  Widget build(BuildContext context) {
    final Map<String, String> dic = I18n.of(context).assets;
    final String symbol = store.settings.networkState.tokenSymbol;
    final int decimals = store.settings.networkState.tokenDecimals;

    final TransferData tx = ModalRoute.of(context).settings.arguments;

    final String txType = tx.from == store.account.currentAddress
        ? dic['transfer']
        : dic['receive'];

    return TxDetail(
      success: true,
      action: txType,
      eventId: tx.extrinsicIndex,
      hash: tx.hash,
      blockTime: DateFormat('yyyy-MM-dd HH:mm:ss').format( DateTime.fromMillisecondsSinceEpoch(tx.blockTimestamp ))
          .toString(),
      blockNum: tx.blockNum,
      networkName: store.settings.endpoint.info,
      info: <DetailInfoItem>[
        DetailInfoItem(
          label: dic['value'],
          title: '${Fmt.token(tx.amount, decimals)} $symbol',
        ),
       
        DetailInfoItem(
          label: dic['from'],
          title: Fmt.address(tx.from),
          address: tx.from,
        ),
        DetailInfoItem(
          label: dic['to'],
          title: Fmt.address(tx.to),
          address: tx.to,
        )
      ],
    );
  }
}
