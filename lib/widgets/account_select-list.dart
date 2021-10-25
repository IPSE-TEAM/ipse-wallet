import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ipsewallet/store/account/types/accountData.dart';
import 'package:ipsewallet/store/app.dart';
import 'package:ipsewallet/utils/format.dart';
import 'package:ipsewallet/widgets/address_icon.dart';

class AccountSelectList extends StatelessWidget {
  AccountSelectList(this.store, this.list);

  final AppStore store;
  final List<AccountData> list;

  @override
  Widget build(BuildContext context) {
    Map<String, String> pubKeyAddressMap =
        store.account.pubKeyAddressMap[store.settings.endpoint.ss58];
    return ListView(
      children: list.map((i) {
        return ListTile(
          leading: AddressIcon(i.address, pubKey: i.pubKey),
          title: Text(Fmt.accountName(context, i)),
          subtitle: Text(Fmt.address(
                  i.encoded != null &&pubKeyAddressMap!=null? pubKeyAddressMap[i.pubKey] : i.address) ??
              ''),
          trailing: Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () => Navigator.of(context).pop(i),
        );
      }).toList(),
    );
  }
}
