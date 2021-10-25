import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:ipsewallet/config/config.dart';
import 'package:ipsewallet/pages/my/add_label/add_label.dart';
import 'package:ipsewallet/pages/my/address_qr.dart';
import 'package:ipsewallet/pages/my/assets/asset.dart';
import 'package:ipsewallet/pages/my/claim/claim.dart';
import 'package:ipsewallet/pages/my/contacts/contacts_page.dart';
import 'package:ipsewallet/pages/my/council/councilPage.dart';
import 'package:ipsewallet/pages/my/democracy/democracyPage.dart';
import 'package:ipsewallet/pages/my/manage_account/manage_account.dart';
import 'package:ipsewallet/pages/my/mortgage/mortgage.dart';
import 'package:ipsewallet/pages/my/select_account.dart';
import 'package:ipsewallet/pages/my/setting/set_node/set_node.dart';
import 'package:ipsewallet/pages/my/setting/setting.dart';
import 'package:ipsewallet/pages/my/staking/index.dart';
import 'package:ipsewallet/pages/my/treasury/treasuryPage.dart';
import 'package:ipsewallet/store/app.dart';
import 'package:ipsewallet/store/assets/types/balancesInfo.dart';
import 'package:ipsewallet/utils/adapt.dart';
import 'package:ipsewallet/utils/format.dart';
import 'package:ipsewallet/utils/i18n/index.dart';
import 'package:ipsewallet/utils/my_utils.dart';
import 'package:ipsewallet/widgets/gradient_bg.dart';
import 'package:ipsewallet/widgets/loading_widget.dart';
import 'package:ipsewallet/widgets/my_tile.dart';
import 'package:url_launcher/url_launcher.dart';

import '../home.dart';

class My extends StatefulWidget {
  My(this.store);
  final AppStore store;
  static String route = "/my";
  @override
  _MyState createState() => _MyState(store);
}

class _MyState extends State<My> {
  _MyState(this.store);
  final AppStore store;

  @override
  Widget build(BuildContext context) {
  
    return Observer(builder: (_) {
      if (store == null || store.account.currentAccountPubKey.isEmpty) {
        return Scaffold(
          body: Center(
            child: LoadingWidget(),
          ),
        );
      }
    
      int decimals = store.settings.networkState.tokenDecimals ?? 14;
      String symbol = store.settings.networkState.tokenSymbol;
      BalancesInfo balancesInfo = store.assets.balances[symbol];
      return Scaffold(
        body: GredientBg(
          title: store.account.currentAccount.name,
          onBack: () =>
              Navigator.popUntil(context, ModalRoute.withName(Home.route)),
          action: IconButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(SelectAccount.route),
            icon: Icon(
              Icons.menu,
              color: Colors.white,
            ),
          ),
          child: Container(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.white,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: Adapt.px(30)),
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          alignment: Alignment.centerRight,
                          image: AssetImage('assets/images/ipse/ipse.png'),
                        ),
                      ),
                      height: Adapt.px(356),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  height: Adapt.px(20),
                                ),
                                store.settings.loading
                                    ? InkWell(
                                        onTap: () => Navigator.of(context)
                                            .pushNamed(SetNode.route),
                                        child: Text(
                                          I18n.of(context).my['nodeConnecting'],
                                          style: TextStyle(
                                            color: Config.color333,
                                            fontSize: Adapt.px(40),
                                          ),
                                        ),
                                      )
                                    : store.settings.networkName == null
                                        ? InkWell(
                                            onTap: () => Navigator.of(context)
                                                .pushNamed(SetNode.route),
                                            child: Text(
                                              I18n.of(context)
                                                  .my['nodeConnectFailed'],
                                              style: TextStyle(
                                                color: Config.color333,
                                                fontSize: Adapt.px(40),
                                              ),
                                            ),
                                          )
                                        : Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Image.asset(
                                                    'assets/images/coins/${store.settings.endpoint.info.toLowerCase()}.png',
                                                    width: 18,
                                                  ),
                                                  SizedBox(width: 5),
                                                  Text(
                                                    store.settings.networkName +
                                                        " " +
                                                        I18n.of(context)
                                                            .my['totalAssets'] +
                                                        ' ( ${symbol ?? ""} )',
                                                    style: TextStyle(
                                                      color: Config.color999,
                                                      fontSize: Adapt.px(26),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 5),
                                              GestureDetector(
                                                onTap: () =>
                                                    Navigator.of(context)
                                                        .pushNamed(Asset.route),
                                                child: Text(
                                                  Fmt.token(
                                                    balancesInfo != null
                                                        ? balancesInfo.total
                                                        : BigInt.zero,
                                                    decimals,
                                                  ),
                                                  style: TextStyle(
                                                    fontSize: Adapt.px(60),
                                                    fontFamily: 'Roboto',
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Container(
                                                    child: Text(
                                                      Fmt.address(store.account
                                                          .currentAddress),
                                                      style: TextStyle(
                                                        color: Config.color999,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  IconButton(
                                                    icon: Image.asset(
                                                        'assets/images/ipse/code.png'),
                                                    onPressed: () =>
                                                        Navigator.of(context)
                                                            .pushNamed(AddressQR
                                                                .route),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  symbol == Config.tokenSymbol
                                                      ? Row(
                                                          children: [
                                                            ElevatedButton(
                                                              onPressed: () =>
                                                                  Navigator.of(
                                                                          context)
                                                                      .pushNamed(
                                                                          Claim
                                                                              .route),
                                                              child: Text(
                                                                I18n.of(context)
                                                                            .ipse[
                                                                        'claim'] +
                                                                    " " +
                                                                    (symbol ??
                                                                        ''),
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        Adapt.px(
                                                                            28)),
                                                              ),
                                                            ),
                                                            SizedBox(width: 10),
                                                          ],
                                                        )
                                                      : Container(),
                                                  OutlinedButton(
                                                    onPressed: () =>
                                                        Navigator.of(context)
                                                            .pushNamed(
                                                                Asset.route),
                                                    child: Text(
                                                      I18n.of(context).ipse[
                                                          'assets_detail'],
                                                      style: TextStyle(
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          fontSize:
                                                              Adapt.px(28)),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // 4444
                  SizedBox(
                    height: Adapt.px(20),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: Adapt.px(30), vertical: Adapt.px(30)),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(Adapt.px(12)),
                          ),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(I18n.of(context).ipse['blockNumber'],
                                    style: TextStyle(
                                      fontSize: Adapt.px(26),
                                      color: Config.color999,
                                    )),
                                SizedBox(
                                  height: Adapt.px(6),
                                ),
                                Text(store.ipse.newHeads == null
                                    ? "~"
                                    : store.ipse.newHeads.number.toString()),
                              ]),
                        ),
                      ),
                      SizedBox(
                        width: Adapt.px(20),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: Adapt.px(30), vertical: Adapt.px(30)),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(Adapt.px(12)),
                          ),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(I18n.of(context).ipse['blockTime'],
                                    style: TextStyle(
                                      fontSize: Adapt.px(26),
                                      color: Config.color999,
                                    )),
                                SizedBox(
                                  height: Adapt.px(6),
                                ),
                                Text(store.ipse.pocGlobalData == null
                                    ? "~"
                                    : (store.ipse.pocGlobalData.blockTime /
                                                1000)
                                            .toStringAsFixed(0) +
                                        " s"),
                              ]),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: Adapt.px(20),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: Adapt.px(30), vertical: Adapt.px(30)),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(Adapt.px(12)),
                          ),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(I18n.of(context).ipse['netPower'],
                                    style: TextStyle(
                                      fontSize: Adapt.px(26),
                                      color: Config.color999,
                                    )),
                                SizedBox(
                                  height: Adapt.px(6),
                                ),
                                Text(
                                  store.ipse.pocGlobalData == null
                                      ? "~"
                                      :sizefilter((store.ipse.pocGlobalData.netPower*((1024*1024*1024*1024)/(1000*1000*1000*1000))~/1024))
                                     
                                )
                              ]),
                        ),
                      ),
                      SizedBox(
                        width: Adapt.px(20),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: Adapt.px(30), vertical: Adapt.px(30)),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(Adapt.px(12)),
                          ),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(I18n.of(context).ipse['capacityPrice'],
                                    style: TextStyle(
                                      fontSize: Adapt.px(26),
                                      color: Config.color999,
                                    )),
                                SizedBox(
                                  height: Adapt.px(6),
                                ),
                                Text(store.ipse.pocGlobalData == null
                                    ? "~"
                                    : "${Fmt.token(store.ipse.pocGlobalData.capacityPrice, decimals)} $symbol"),
                              ]),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: Adapt.px(20),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(Adapt.px(12)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        InkWell(
                          onTap: () =>
                              Navigator.of(context).pushNamed(Staking.route),
                          child: Container(
                            width: Adapt.px(157),
                            height: Adapt.px(180),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(Adapt.px(12)),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image.asset('assets/images/ipse/staking.png'),
                                SizedBox(
                                  height: Adapt.px(12),
                                ),
                                Text(
                                  I18n.of(context).my['staking'],
                                  style: TextStyle(
                                    color: Config.color333,
                                    fontWeight: FontWeight.w400,
                                    fontSize: Adapt.px(28),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () => Navigator.of(context)
                              .pushNamed(CouncilPage.route),
                          child: Container(
                            width: Adapt.px(157),
                            height: Adapt.px(180),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image.asset('assets/images/ipse/council.png'),
                                SizedBox(
                                  height: Adapt.px(12),
                                ),
                                Text(
                                  I18n.of(context).my['council'],
                                  style: TextStyle(
                                    color: Config.color333,
                                    fontWeight: FontWeight.w400,
                                    fontSize: Adapt.px(28),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () => Navigator.of(context)
                              .pushNamed(TreasuryPage.route),
                          child: Container(
                            width: Adapt.px(157),
                            height: Adapt.px(180),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image.asset('assets/images/ipse/treasury.png'),
                                SizedBox(
                                  height: Adapt.px(12),
                                ),
                                Text(
                                  I18n.of(context).my['treasury'],
                                  style: TextStyle(
                                    color: Config.color333,
                                    fontWeight: FontWeight.w400,
                                    fontSize: Adapt.px(28),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () => Navigator.of(context)
                              .pushNamed(DemocracyPage.route),
                          child: Container(
                            width: Adapt.px(157),
                            height: Adapt.px(180),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image.asset('assets/images/ipse/democracy.png'),
                                SizedBox(
                                  height: Adapt.px(12),
                                ),
                                Text(
                                  I18n.of(context).my['democracy'],
                                  style: TextStyle(
                                    color: Config.color333,
                                    fontWeight: FontWeight.w400,
                                    fontSize: Adapt.px(28),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// ipse
                  symbol == Config.tokenSymbol
                      ? Column(
                          children: [
                            SizedBox(
                              height: Adapt.px(20),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.circular(Adapt.px(12)),
                              ),
                              child: Column(
                                children: <Widget>[
                                  myTile(
                                    leading: Image.asset(
                                        'assets/images/ipse/add-label.png'),
                                    title: I18n.of(context).ipse['add_label'],
                                    noborder: true,
                                    onTap: () => Navigator.of(context)
                                        .pushNamed(AddLabel.route),
                                  ),
                                  myTile(
                                    leading: Image.asset(
                                        'assets/images/ipse/mortgage.png'),
                                    title: 'PoC ' +
                                        I18n.of(context).ipse['mortgage'],
                                    noborder: true,
                                    onTap: () => Navigator.of(context)
                                        .pushNamed(Mortgage.route),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : Container(),
                  SizedBox(
                    height: Adapt.px(20),
                  ),

                
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(Adapt.px(12)),
                    ),
                    child: Column(
                      children: <Widget>[
                        store.account.currentAccount.observation != null &&
                                store.account.currentAccount.observation
                            ? Container()
                            : myTile(
                                leading: Image.asset(
                                    'assets/images/ipse/accountmanage.png'),
                                title: I18n.of(context).my['manageAccount'],
                                noborder: true,
                                onTap: () => Navigator.of(context)
                                    .pushNamed(ManageAccount.route),
                              ),
                        myTile(
                          leading:
                              Image.asset('assets/images/ipse/contact.png'),
                          title: I18n.of(context).profile['contact'],
                          noborder: true,
                          onTap: () => Navigator.of(context)
                              .pushNamed(ContactsPage.route),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: Adapt.px(20),
                  ),

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(Adapt.px(12)),
                    ),
                    child: Column(
                      children: <Widget>[
                        myTile(
                          leading:
                              Image.asset('assets/images/ipse/tutorial.png'),
                          title: I18n.of(context).ipse['tutorial'],
                          noborder: true,
                          onTap: () async {
                            String url =Config.tutorialUrl;
                            if (await canLaunch(url)) {
                              await launch(url);
                            }
                          },
                        ),
                        myTile(
                          leading:
                              Image.asset('assets/images/ipse/setting.png'),
                          title: I18n.of(context).my['setting'],
                          noborder: true,
                          onTap: () =>
                              Navigator.of(context).pushNamed(Setting.route),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: Adapt.px(34),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
