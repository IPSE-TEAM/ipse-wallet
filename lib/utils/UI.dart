import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ipsewallet/common/reg_input_formatter.dart';
import 'package:ipsewallet/store/app.dart';
import 'package:ipsewallet/utils/i18n/index.dart';
import 'package:url_launcher/url_launcher.dart';

class UI {
  static void copyAndNotify(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text ?? ''));

    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        final Map<String, String> dic = I18n.of(context).assets;
        return CupertinoAlertDialog(
          title: Container(),
          content: Text('${dic['copy']} ${dic['success']}'),
        );
      },
    );

    Timer(Duration(seconds: 2), () {
      Navigator.of(context).pop();
    });
  }

  static Future<void> launchURL(String url) async {
    if (await canLaunch(url)) {
      try {
        await launch(url);
      } catch (err) {
        print(err);
      }
    } else {
      print('Could not launch $url');
    }
  }

  // static Future<void> checkUpdate(BuildContext context, Map versions,
  //     {bool autoCheck = false}) async {
  //   if (versions == null || !Platform.isAndroid && !Platform.isIOS) return;
  //   String platform = Platform.isAndroid ? 'android' : 'ios';
  //   final Map dic = I18n.of(context).home;
  //   String latest = versions[platform]['version'];
  //   String latestBeta = versions[platform]['version-beta'];

  //   PackageInfo info = await PackageInfo.fromPlatform();

  //   bool needUpdate = false;
  //   if (autoCheck) {
  //     if (latest.compareTo(info.version) > 0) {
  //       // new version found
  //       needUpdate = true;
  //     } else {
  //       return;
  //     }
  //   } else {
  //     if (latestBeta.compareTo(app_beta_version) > 0) {
  //       // new version found
  //       needUpdate = true;
  //     }
  //   }

  //   showCupertinoDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       List versionInfo = versions[platform]['info']
  //           [I18n.of(context).locale.toString().contains('zh') ? 'zh' : 'en'];
  //       return CupertinoAlertDialog(
  //         title: Text('v$latestBeta'),
  //         content: Column(
  //           children: [
  //             Padding(
  //               padding: EdgeInsets.only(top: 12, bottom: 8),
  //               child:
  //                   Text(needUpdate ? dic['update.up'] : dic['update.latest']),
  //             ),
  //             needUpdate
  //                 ? Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: versionInfo
  //                         .map((e) => Text(
  //                               '- $e',
  //                               textAlign: TextAlign.left,
  //                             ))
  //                         .toList(),
  //                   )
  //                 : Container()
  //           ],
  //         ),
  //         actions: <Widget>[
  //           CupertinoButton(
  //             child: Text(dic['cancel']),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //           CupertinoButton(
  //             child: Text(dic['ok']),
  //             onPressed: () async {
  //               Navigator.of(context).pop();
  //               if (!needUpdate) {
  //                 return;
  //               }
  //               if (Platform.isIOS) {
  //                 // go to ios download page
  //                 launchURL('https://polkawallet.io/#download');
  //               } else if (Platform.isAndroid) {
  //                 // download apk
  //                 // START LISTENING FOR DOWNLOAD PROGRESS REPORTING EVENTS
  //                 try {
  //                   String url = versions['android']['url'];
  //                   UpdateApp.updateApp(url: url, appleId: "1520301768");
  //                 } catch (e) {
  //                   print('Failed to make OTA update. Details: $e');
  //                 }
  //               }
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // static Future<bool> checkJSCodeUpdate(
  //   BuildContext context,
  //   int jsVersion,
  //   String network,
  // ) async {
  //   if (jsVersion != null) {
  //     final currentVersion = WalletApi.getPolkadotJSVersion(
  //       webApi.jsStorage,
  //       network,
  //     );
  //     if (jsVersion > currentVersion) {
  //       final Map dic = I18n.of(context).home;
  //       final bool isOk = await showCupertinoDialog(
  //         context: context,
  //         builder: (BuildContext context) {
  //           return CupertinoAlertDialog(
  //             title: Text('metadata v$jsVersion'),
  //             content: Text(dic['update.js.up']),
  //             actions: <Widget>[
  //               CupertinoButton(
  //                 child: Text(dic['cancel']),
  //                 onPressed: () {
  //                   Navigator.of(context).pop(false);
  //                   exit(0);
  //                 },
  //               ),
  //               CupertinoButton(
  //                 child: Text(dic['ok']),
  //                 onPressed: () {
  //                   Navigator.of(context).pop(true);
  //                 },
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //       return isOk;
  //     }
  //   }
  //   return false;
  // }

  // static Future<void> updateJSCode(
  //   BuildContext context,
  //   GetStorage jsStorage,
  //   String network,
  //   int version,
  // ) async {
  //   final Map dic = I18n.of(context).home;
  //   showCupertinoDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return CupertinoAlertDialog(
  //         title: Text(dic['update.download']),
  //         content: CupertinoActivityIndicator(),
  //       );
  //     },
  //   );
  //   final String code = await WalletApi.fetchPolkadotJSCode(network);
  //   Navigator.of(context).pop();
  //   showCupertinoDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return CupertinoAlertDialog(
  //         title: Container(),
  //         content:
  //             code == null ? Text(dic['update.error']) : Text(dic['success']),
  //         actions: <Widget>[
  //           CupertinoButton(
  //             child: Text(dic['ok']),
  //             onPressed: () {
  //               WalletApi.setPolkadotJSCode(jsStorage, network, code, version);
  //               Navigator.of(context).pop();
  //               if (code == null) {
  //                 exit(0);
  //               }
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  static Future<void> alertWASM(BuildContext context, Function onCancel) async {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Container(),
          content: Text(I18n.of(context).account['backup.error']),
          actions: <Widget>[
            CupertinoButton(
              child: Text(I18n.of(context).home['ok']),
              onPressed: () {
                Navigator.of(context).pop();
                onCancel();
              },
            ),
          ],
        );
      },
    );
  }

  static bool checkBalanceAndAlert(
      BuildContext context, AppStore store, BigInt amountNeeded) {
    String symbol = store.settings.networkState.tokenSymbol;
    if (store.assets.balances[symbol].transferable <= amountNeeded) {
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(I18n.of(context).assets['amount.low']),
            content: Container(),
            actions: <Widget>[
              CupertinoButton(
                child: Text(I18n.of(context).home['ok']),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );
      return false;
    } else {
      return true;
    }
  }

  static TextInputFormatter decimalInputFormatter(int decimals) {
    return RegExInputFormatter.withRegex(
        '^[0-9]{0,$decimals}(\\.[0-9]{0,$decimals})?\$');
  }
}

// access the refreshIndicator globally
// assets index page:
final GlobalKey<RefreshIndicatorState> globalBalanceRefreshKey =
    new GlobalKey<RefreshIndicatorState>();
// asset page:
final GlobalKey<RefreshIndicatorState> globalAssetRefreshKey =
    new GlobalKey<RefreshIndicatorState>();
// staking bond page:
final GlobalKey<RefreshIndicatorState> globalBondingRefreshKey =
    new GlobalKey<RefreshIndicatorState>();
// staking nominate page:
final GlobalKey<RefreshIndicatorState> globalNominatingRefreshKey =
    new GlobalKey<RefreshIndicatorState>();
// council & motions page:
final GlobalKey<RefreshIndicatorState> globalCouncilRefreshKey =
    new GlobalKey<RefreshIndicatorState>();
final GlobalKey<RefreshIndicatorState> globalMotionsRefreshKey =
    new GlobalKey<RefreshIndicatorState>();
// democracy page:
final GlobalKey<RefreshIndicatorState> globalDemocracyRefreshKey =
    new GlobalKey<RefreshIndicatorState>();
// treasury proposals&tips page:
final GlobalKey<RefreshIndicatorState> globalProposalsRefreshKey =
    new GlobalKey<RefreshIndicatorState>();
final GlobalKey<RefreshIndicatorState> globalTipsRefreshKey =
    new GlobalKey<RefreshIndicatorState>();
// recovery settings page:
final GlobalKey<RefreshIndicatorState> globalRecoverySettingsRefreshKey =
    new GlobalKey<RefreshIndicatorState>();
// recovery state page:
final GlobalKey<RefreshIndicatorState> globalRecoveryStateRefreshKey =
    new GlobalKey<RefreshIndicatorState>();
// recovery vouch page:
final GlobalKey<RefreshIndicatorState> globalRecoveryProofRefreshKey =
    new GlobalKey<RefreshIndicatorState>();

// mortgage page:
final GlobalKey<RefreshIndicatorState> globalMortgageRefreshKey =
    new GlobalKey<RefreshIndicatorState>();

// mortgage Manage page:
final GlobalKey<RefreshIndicatorState> globalMinerManageRefreshKey =
    new GlobalKey<RefreshIndicatorState>();

// mortgage detail page:
final GlobalKey<RefreshIndicatorState> globalPocMinerMortgageDetailRefreshKey =
    new GlobalKey<RefreshIndicatorState>();

// PocMinerMiningHistory page:
final GlobalKey<RefreshIndicatorState> globalPocMinerMiningHistoryfreshKey =
    new GlobalKey<RefreshIndicatorState>();

// PocMyMiningHistory page:
final GlobalKey<RefreshIndicatorState> globalPocMyMiningHistoryfreshKey =
    new GlobalKey<RefreshIndicatorState>();

// add label page:
final GlobalKey<RefreshIndicatorState> globalAddLabelRefreshKey =
    new GlobalKey<RefreshIndicatorState>();

// IpseMinerOrders page:
final GlobalKey<RefreshIndicatorState> globalIpseMinerOrdersRefreshKey =
    new GlobalKey<RefreshIndicatorState>();
