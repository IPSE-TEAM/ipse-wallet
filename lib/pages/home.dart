import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:ipsewallet/config/config.dart';
import 'package:ipsewallet/pages/my/create_account/create_account_entry.dart';
import 'package:ipsewallet/pages/my/my.dart';
import 'package:ipsewallet/pages/search/search.dart';
import 'package:ipsewallet/service/notification.dart';
import 'package:ipsewallet/store/app.dart';
import 'package:ipsewallet/utils/adapt.dart';
import 'package:ipsewallet/utils/i18n/index.dart';
import 'package:ipsewallet/widgets/ip_setting.dart';
import 'package:ipsewallet/widgets/loading_widget.dart';

class Home extends StatefulWidget {
  Home(this.store);

  final AppStore store;
  static String route = "/";
  @override
  _HomePageState createState() => new _HomePageState(store);
}

class _HomePageState extends State<Home> {
  _HomePageState(this.store);

  final AppStore store;
  // MysearchResult _delegate;
  NotificationPlugin _notificationPlugin;
 String _ip;

  @override
  void initState() {
    super.initState();
    

    if (_notificationPlugin == null) {
      _notificationPlugin = NotificationPlugin();
      _notificationPlugin.init(context);
    }
  }

  Future<void> settingIp() async{
    var ip = await showDialog(
        context: context, builder: (BuildContext context) => IpSetting(store.ipse));
    if (ip != null) {
      setState(() {
        _ip = ip;
      });
    }else if(_ip==null){
      store.ipse.setip("");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      if (store.account == null) {
        return Scaffold(
          body: Center(
            child: LoadingWidget(),
          ),
        );
      }
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            color: Colors.grey,
            icon: Icon(Icons.settings),
            onPressed: settingIp,
          ),
          actions: [
            store.account == null
                ? Text('')
                : store.account.accountList.length > 0
                    ? TextButton(
                        child: Row(
                          children: [
                            Text(
                              store.account.currentAccount.name ?? '',
                              style: TextStyle(
                                  color: Config.color333,
                                  fontWeight: FontWeight.w400),
                            ),
                            Icon(
                              Icons.arrow_drop_down,
                              color: Config.color333,
                            )
                          ],
                        ),
                        onPressed: () =>
                            Navigator.of(context).pushNamed(My.route),
                      )
                    : TextButton(
                        onPressed: () => Navigator.of(context)
                            .pushNamed(CreateAccountEntryPage.route),
                        child: Text(
                          I18n.of(context).ipse['create/import'],
                          style: TextStyle(
                              color: Color(0xff1574AB),
                              fontWeight: FontWeight.w400),
                        ),
                      ),
          ],
        ),
        body: SafeArea(
          child: Container(
            child: Stack(
              children: <Widget>[
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          width: Adapt.px(342),
                          child:
                              Image.asset("assets/images/logo-full-color.png")),
                      SizedBox(
                        height: 20.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: OutlineButton(
                                padding: EdgeInsets.all(12.0),
                                color: Colors.blue,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      I18n.of(context).ipse['search_whatever'],
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w300),
                                    ),
                                    Icon(
                                      Icons.search,
                                      color: Colors.grey,
                                    )
                                  ],
                                ),
                                onPressed: () async {
                                  Navigator.of(context).pushNamed(Search.route);
                                  
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: Adapt.px(10),
                      ),
                      Text(
                        I18n.of(context).ipse['new_search_engine'],
                        style: TextStyle(
                            color: Colors.black, fontSize: Adapt.px(26)),
                      ),
                      SizedBox(
                        height: Adapt.px(180),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
