import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ipsewallet/utils/format.dart';
import 'package:ipsewallet/utils/i18n/index.dart';
import 'package:ipsewallet/utils/my_utils.dart';
import 'package:ipsewallet/widgets/jump_to_browser_link.dart';
import 'package:ipsewallet/widgets/my_appbar.dart';

class TxDetail extends StatelessWidget {
  TxDetail({
    this.success,
    this.networkName,
    this.action,
    @required this.eventId,
    this.hash,
    this.blockTime,
    this.blockNum,
    this.info,
  });

  final bool success;
  final String networkName;
  final String action;
  final String eventId;
  final String hash;
  final String blockTime;
  final int blockNum;
  final List<DetailInfoItem> info;

  List<Widget> _buildListView(BuildContext context) {
    final Map<String, String> dic = I18n.of(context).assets;
    Widget buildLabel(String name) {
      return Container(
          padding: EdgeInsets.only(left: 8),
          width: 80,
          child: Text(name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).unselectedWidgetColor,
              )));
    }

    var list = <Widget>[
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(24),
            child: success
                ? Image.asset('assets/images/a/receive-success.png')
                : Text(''),
          ),
          Text(
            '$action ${success ? dic['success'] : dic['fail']}',
            style: Theme.of(context).textTheme.headline5,
          ),
          Padding(
            padding: EdgeInsets.only(top: 8, bottom: 32),
            child: Text(blockTime),
          ),
        ],
      ),
      Divider(),
    ];
    info.forEach((i) {
      list.add(ListTile(
        leading: buildLabel(i.label),
        title: Text(i.title),
        subtitle: i.subtitle != null ? Text(i.subtitle) : null,
        trailing: i.address != null
            ? IconButton(
                icon: Image.asset('assets/images/a/copy.png'),
                onPressed: () => {
                  copy(context, i.address)
                },
              )
            : null,
      ));
    });

String ipseLink='https://scan.ipse.io/IPSE2.0/transaction/$hash';
    
    list.addAll(<Widget>[
      ListTile(
        leading: buildLabel(dic['event']),
        title: Text(eventId),
      ),
      ListTile(
        leading: buildLabel(dic['block']),
        title: Text('#$blockNum'),
      ),
      ListTile(
        leading: buildLabel(dic['hash']),
        title: Text(Fmt.address(hash)),
        trailing: Container(
          width: 140,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              JumpToBrowserLink(
                ipseLink,
                text: 'IPSESCAN',
              ),
              
            ],
          ),
        ),
      ),
    ]);
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(context, '${I18n.of(context).assets['detail']}'),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.only(bottom: 32),
          children: _buildListView(context),
        ),
      ),
    );
  }
}

class DetailInfoItem {
  DetailInfoItem({this.label, this.title, this.subtitle, this.address});
  final String label;
  final String title;
  final String subtitle;
  final String address;
}
