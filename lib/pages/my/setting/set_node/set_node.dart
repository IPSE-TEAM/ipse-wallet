import 'package:flutter/material.dart';
import 'package:ipsewallet/config/config.dart';
import 'package:ipsewallet/pages/my/setting/set_node/add_node.dart';
import 'package:ipsewallet/service/substrate_api/api.dart';
import 'package:ipsewallet/store/settings.dart';
import 'package:ipsewallet/utils/adapt.dart';
import 'package:ipsewallet/utils/i18n/index.dart';
import 'package:ipsewallet/utils/local_storage.dart';
import 'package:ipsewallet/widgets/my_appbar.dart';

const default_ss58_map = {
  'kusama': 2,
  'ipse': 42,
  'substrate': 42,
  'polkadot': 0,
};

const network_ss58_map = {
  'kusama': 2,
  'ipse': 42,
  'substrate': 42,
  'polkadot': 0,
};

EndpointData defaultNode = EndpointData.fromJson({
  'color': 'blue',
  'info': 'ipse',
  'text': 'mainnet  ( hosted by Europe )',
  'value': 'wss://mainnet-europe.ipse.io',
  'ss58': default_ss58_map['ipse']
});
EndpointData mainnetNode1 = EndpointData.fromJson({
  'color': 'blue',
  'info': 'ipse',
  'text': 'mainnet ( hosted by USA )',
  'value': 'wss://mainnet-usa.ipse.io',
  'ss58': default_ss58_map['ipse']
});
EndpointData mainnetNode2 = EndpointData.fromJson({
  'color': 'blue',
  'info': 'ipse',
  'text': 'mainnet  ( hosted by china )',
  'value': 'wss://mainnet-china.ipse.io',
  'ss58': default_ss58_map['ipse']
});


List<EndpointData> networkEndpoints = [
  defaultNode,
  mainnetNode1,
  mainnetNode2,
 
];

class SetNode extends StatefulWidget {
  static const route = '/my/setting/setNode';
  SetNode(this.store);

  final SettingsStore store;

  @override
  _SetNodeState createState() => _SetNodeState();
}

class _SetNodeState extends State<SetNode> {
  final Api api = webApi;
  List<EndpointData> _nodeList = networkEndpoints;
  @override
  void initState() {
    _getCustomNodeList();
    super.initState();
  }

  _getCustomNodeList() async {
    Iterable<Map<String, dynamic>> list =
        await LocalStorage.getCustomEnterPointList();
    setState(() {
      _nodeList = [];
      _nodeList.addAll(networkEndpoints);
      _nodeList.addAll(list.map((e) => EndpointData.fromJson(e)).toList());
    });
  }


  _clearAllCustomNode(BuildContext context) {
    var homeI18n = I18n.of(context).home;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Text(
          I18n.of(context).my['clearCustomNodes'] + "?",
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              homeI18n['cancel'],
              style: TextStyle(color: Colors.grey),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: Text(homeI18n['ok']),
            onPressed: () {
              LocalStorage.removeCustomEnterPointList();
              setState(() {
                _nodeList = [];
                _nodeList.addAll(networkEndpoints);
              });
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> list = _nodeList
        .map((i) => ListTile(
              title: Text(i.info),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(i.text),
                  Text(i.value),
                ],
              ),
              leading: Config.networkList.contains(i.info.toLowerCase())
                  ? Image.asset(
                      'assets/images/coins/${i.info.toLowerCase()}.png',
                      width: Adapt.px(70),
                      height: Adapt.px(70),
                    )
                  : CircleAvatar(
                      backgroundColor: Colors.grey,
                    ),
              isThreeLine: true,
              selected: widget.store.endpoint.value == i.value,
              trailing: widget.store.endpoint.value == i.value
                  ? Icon(
                      Icons.check,
                      color: Theme.of(context).primaryColor,
                    )
                  : null,
              onTap: () async {
                if (widget.store.endpoint.value == i.value) {
                  Navigator.of(context).pop();
                  return;
                }
                widget.store.setEndpoint(i);
                api.changeNode();
                // await api.close();
                // api.init();
                // RestartWidget.restartApp(context);
                Navigator.of(context).pop();
              },
            ))
        .toList();

    return Scaffold(
      appBar: myAppBar(context, I18n.of(context).setting['selectNode'],
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.clear_all),
              onPressed: () {
                _clearAllCustomNode(context);
              },
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () async {
                var res = await Navigator.pushNamed(context, AddNode.route);
                if (res == 1) {
                  _getCustomNodeList();
                }
              },
            ),
          ]),
      body: SafeArea(
        child: ListView(padding: EdgeInsets.only(top: 8), children: list),
      ),
    );
  }
}
