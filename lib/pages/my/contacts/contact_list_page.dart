import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ipsewallet/pages/my/contacts/contact_page.dart';
import 'package:ipsewallet/store/account/types/accountData.dart';
import 'package:ipsewallet/store/app.dart';
import 'package:ipsewallet/utils/i18n/index.dart';
import 'package:ipsewallet/widgets/account_select-list.dart';
import 'package:ipsewallet/widgets/my_appbar.dart';

class ContactListPage extends StatelessWidget {
  ContactListPage(this.store);

  static final String route = '/my/contacts/list';
  final AppStore store;

  @override
  Widget build(BuildContext context) {
    final List<AccountData> args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: myAppBar(
        context,
        args == null
            ? I18n.of(context).profile['contact']
            : I18n.of(context).account['list'],
        actions: <Widget>[
          args == null
              ? Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: IconButton(
                    icon: Icon(Icons.add, size: 28),
                    onPressed: () =>
                        Navigator.of(context).pushNamed(ContactPage.route),
                  ),
                )
              : Container()
        ],
      ),
      body: SafeArea(
        child: AccountSelectList(
          store,
          args ?? store.settings.contactListAll.toList(),
        ),
      ),
    );
  }
}
