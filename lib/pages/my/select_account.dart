import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:ipsewallet/pages/my/create_account/create_account_entry.dart';
import 'package:ipsewallet/pages/my/setting/set_node/set_node.dart';
import 'package:ipsewallet/service/substrate_api/api.dart';
import 'package:ipsewallet/store/account/types/accountData.dart';
import 'package:ipsewallet/store/app.dart';
import 'package:ipsewallet/store/settings.dart';
import 'package:ipsewallet/utils/format.dart';
import 'package:ipsewallet/utils/i18n/index.dart';
import 'package:ipsewallet/utils/loading.dart';
import 'package:ipsewallet/widgets/address_icon.dart';
import 'package:ipsewallet/widgets/my_appbar.dart';
import 'package:ipsewallet/widgets/rounded_card.dart';

class SelectAccount extends StatefulWidget {
  SelectAccount(this.store, this.changeTheme);

  static final String route = '/my/SelectAccount';
  final AppStore store;
  final Function changeTheme;

  @override
  _SelectAccountState createState() => _SelectAccountState(store, changeTheme);
}

class _SelectAccountState extends State<SelectAccount> {
  _SelectAccountState(this.store, this.changeTheme);

  final AppStore store;
  final Function changeTheme;

  final List<EndpointData> networks = [
    defaultNode,
    // networkEndpointPolkadot,
    // networkEndpointKusama,
  ];

  EndpointData _selectedNetwork;
  bool _networkChanging = false;

  void _loadAccountCache() {
    // refresh balance
    store.assets.clearTxs();
    store.assets.loadAccountCache();

    // refresh user's staking info if network is kusama or polkadot
    store.staking.clearState();
    store.staking.loadAccountCache();
  }

  Future<void> _reloadNetwork() async {
    setState(() {
      _networkChanging = true;
    });
    Loading.showLoading(context);
    

    store.settings.setNetworkLoading(true);
    await store.settings.setNetworkConst({}, needCache: false);
    store.settings.setEndpoint(_selectedNetwork);

    await store.settings.loadNetworkStateCache();

    store.gov.clearState();
    store.ipse.clearState();
    store.assets.loadCache();
    store.staking.clearState();
    store.staking.loadCache();

    webApi.launchWebview();
    changeTheme();
    if (mounted) {
      Navigator.of(context).pop();
      setState(() {
        _networkChanging = false;
      });
    }
  }

  Future<void> _onSelect(AccountData i, String address) async {
    bool isCurrentNetwork =
        _selectedNetwork.info == store.settings.endpoint.info;
    if (address != store.account.currentAddress || !isCurrentNetwork) {
      /// set current account
      store.account.setCurrentAccount(i.pubKey);

      if (isCurrentNetwork) {
        _loadAccountCache();

        /// reload account info
        webApi.loadAccountData();
      } else {
        /// set new network and reload web view
        await _reloadNetwork();
      }
    }
    Navigator.of(context).pop();
  }

  Future<void> _onCreateAccount() async {
    bool isCurrentNetwork =
        _selectedNetwork.info == store.settings.endpoint.info;
    if (!isCurrentNetwork) {
      await _reloadNetwork();
    }
    Navigator.of(context).pushNamed(CreateAccountEntryPage.route);
  }

  List<Widget> _buildAccountList() {
    List<Widget> res = [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            _selectedNetwork.info.toUpperCase(),
            style: Theme.of(context).textTheme.headline4,
          ),
          IconButton(
            icon: Icon(Icons.add_circle_outline),
            color: Theme.of(context).primaryColor,
            onPressed: () => _onCreateAccount(),
          )
        ],
      ),
    ];

    /// first item is current account
    List<AccountData> accounts = [store.account.currentAccount];

    /// add optional accounts
    accounts.addAll(store.account.optionalAccounts);

    res.addAll(accounts.map((i) {
      String address = i.address;
      if (store.account.pubKeyAddressMap[_selectedNetwork.ss58] != null) {
        address =
            store.account.pubKeyAddressMap[_selectedNetwork.ss58][i.pubKey];
      }
      final bool isCurrentNetwork =
          _selectedNetwork.info == store.settings.endpoint.info;
      final accInfo = store.account.accountIndexMap[i.address];
      final String accIndex =
          isCurrentNetwork && accInfo != null && accInfo['accountIndex'] != null
              ? '${accInfo['accountIndex']}\n'
              : '';
      final double padding = accIndex.isEmpty ? 0 : 7;
      return RoundedCard(
        border: address == store.account.currentAddress
            ? Border.all(color: Theme.of(context).primaryColorLight, width: 2)
            : Border.all(color: Theme.of(context).cardColor),
        margin: EdgeInsets.only(bottom: 16),
        padding: EdgeInsets.only(top: padding, bottom: padding),
        child: ListTile(
          leading: AddressIcon('', pubKey: i.pubKey, addressToCopy: address),
          title: Text(Fmt.accountName(context, i)),
          subtitle: Text('$accIndex${Fmt.address(address)}', maxLines: 2),
          onTap: _networkChanging ? null : () => _onSelect(i, address),
        ),
      );
    }).toList());
    return res;
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _selectedNetwork = store.settings.endpoint;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map doc = I18n.of(context).home;
    return Scaffold(
      appBar: myAppBar(context, doc['setting.network']),
      body: Observer(
        builder: (_) {
          if (_selectedNetwork == null) return Container();
          return Container(
            // decoration: BoxDecoration(
            //   border: Border(top: BorderSide(width: 2, color: Colors.black12)),
            // ),
            child: ListView(
              padding: EdgeInsets.only(
                  left: 16, right: 16, bottom: 16, top: 10),
              children: _buildAccountList(),
            ),
          );
        },
      ),
    );
  }
}
