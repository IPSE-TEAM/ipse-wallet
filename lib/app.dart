import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:ipsewallet/pages/home.dart';
import 'package:ipsewallet/pages/my/add_label/add_label.dart';
import 'package:ipsewallet/pages/my/add_label/create_order.dart';
import 'package:ipsewallet/pages/my/add_label/ipse_miner_manage/ipse_miner_manage.dart';
import 'package:ipsewallet/pages/my/add_label/ipse_miner_manage/ipse_miner_orders.dart';
import 'package:ipsewallet/pages/my/add_label/ipse_miner_manage/ipse_mortgage_ranking.dart';
import 'package:ipsewallet/pages/my/add_label/ipse_miner_register.dart';
import 'package:ipsewallet/pages/my/add_label/ipse_miner_select.dart';
import 'package:ipsewallet/pages/my/add_label/order_detail.dart';
import 'package:ipsewallet/pages/my/address_qr.dart';
import 'package:ipsewallet/pages/my/claim/claim.dart';
import 'package:ipsewallet/pages/my/claim/claim_record.dart';
import 'package:ipsewallet/pages/my/contacts/contact_list_page.dart';
import 'package:ipsewallet/pages/my/contacts/contact_page.dart';
import 'package:ipsewallet/pages/my/contacts/contacts_page.dart';
import 'package:ipsewallet/pages/my/council/candidateDetailPage.dart';
import 'package:ipsewallet/pages/my/council/candidateListPage.dart';
import 'package:ipsewallet/pages/my/assets/asset.dart';
import 'package:ipsewallet/pages/my/assets/transfer/transfer_detail.dart';
import 'package:ipsewallet/pages/my/council/councilPage.dart';
import 'package:ipsewallet/pages/my/council/councilVotePage.dart';
import 'package:ipsewallet/pages/my/council/motionDetailPage.dart';
import 'package:ipsewallet/pages/my/create_account/create/backup_account.dart';
import 'package:ipsewallet/pages/my/create_account/create/create_account.dart';
import 'package:ipsewallet/pages/my/create_account/create_account_entry.dart';
import 'package:ipsewallet/pages/my/create_account/import/import_account.dart';
import 'package:ipsewallet/pages/my/democracy/democracyPage.dart';
import 'package:ipsewallet/pages/my/democracy/proposalDetailPage.dart';
import 'package:ipsewallet/pages/my/democracy/referendumVotePage.dart';
import 'package:ipsewallet/pages/my/manage_account/change_name.dart';
import 'package:ipsewallet/pages/my/manage_account/change_password.dart';
import 'package:ipsewallet/pages/my/manage_account/export_account.dart';
import 'package:ipsewallet/pages/my/manage_account/export_result.dart';
import 'package:ipsewallet/pages/my/manage_account/manage_account.dart';
import 'package:ipsewallet/pages/my/mortgage/miner_manage/change_disk_info.dart';
import 'package:ipsewallet/pages/my/mortgage/miner_manage/change_pid.dart';
import 'package:ipsewallet/pages/my/mortgage/miner_manage/change_proportion.dart';
import 'package:ipsewallet/pages/my/mortgage/miner_manage/change_reward_address.dart';
import 'package:ipsewallet/pages/my/mortgage/miner_manage/miner_manage.dart';
import 'package:ipsewallet/pages/my/mortgage/miner_manage/mortgage_ranking.dart';
import 'package:ipsewallet/pages/my/mortgage/miner_select.dart';
import 'package:ipsewallet/pages/my/mortgage/mortgage.dart';
import 'package:ipsewallet/pages/my/mortgage/poc_my_mining_history.dart';
import 'package:ipsewallet/pages/my/mortgage/poc_register.dart';
import 'package:ipsewallet/pages/my/mortgage/user_mortgage.dart';
import 'package:ipsewallet/pages/my/my.dart';
import 'package:ipsewallet/pages/my/scan_page.dart';
import 'package:ipsewallet/pages/my/select_account.dart';
import 'package:ipsewallet/pages/my/setting/about.dart';
import 'package:ipsewallet/pages/my/setting/custom_types.dart';
import 'package:ipsewallet/pages/my/setting/set_node/add_node.dart';
import 'package:ipsewallet/pages/my/setting/set_node/set_node.dart';
import 'package:ipsewallet/pages/my/setting/setting.dart';
import 'package:ipsewallet/pages/my/staking/actions/accountSelectPage.dart';
import 'package:ipsewallet/pages/my/staking/actions/bondExtraPage.dart';
import 'package:ipsewallet/pages/my/staking/actions/bondPage.dart';
import 'package:ipsewallet/pages/my/staking/actions/payoutPage.dart';
import 'package:ipsewallet/pages/my/staking/actions/redeemPage.dart';
import 'package:ipsewallet/pages/my/staking/actions/setControllerPage.dart';
import 'package:ipsewallet/pages/my/staking/actions/setPayeePage.dart';
import 'package:ipsewallet/pages/my/staking/actions/stakingDetailPage.dart';
import 'package:ipsewallet/pages/my/staking/actions/unbondPage.dart';
import 'package:ipsewallet/pages/my/staking/index.dart';
import 'package:ipsewallet/pages/my/staking/validators/nominatePage.dart';
import 'package:ipsewallet/pages/my/staking/validators/validatorDetailPage.dart';
import 'package:ipsewallet/pages/my/treasury/spendProposalPage.dart';
import 'package:ipsewallet/pages/my/treasury/submitProposalPage.dart';
import 'package:ipsewallet/pages/my/treasury/submitTipPage.dart';
import 'package:ipsewallet/pages/my/treasury/tipDetailPage.dart';
import 'package:ipsewallet/pages/my/treasury/treasuryPage.dart';
import 'package:ipsewallet/pages/my/tx_confirm_page.dart';
import 'package:ipsewallet/pages/search/search.dart';
import 'package:ipsewallet/service/check_version.dart';
import 'package:ipsewallet/service/notification.dart';
import 'package:ipsewallet/service/substrate_api/api.dart';
import 'package:ipsewallet/store/app.dart';
import 'package:ipsewallet/widgets/loading_widget.dart';

import 'pages/my/assets/transfer/transfer.dart';
import 'utils/i18n/index.dart';
import 'common/theme.dart';

class IpseApp extends StatefulWidget {
  const IpseApp();

  @override
  _IpseAppState createState() => _IpseAppState();
}

class _IpseAppState extends State<IpseApp> {
  AppStore _appStore;
  Locale _locale = const Locale('zh', '');
  Timer timer;
  void _changeLang(BuildContext context, String code) {
    Locale res;
    switch (code) {
      case 'zh':
        res = const Locale('zh', '');
        break;
      case 'en':
        res = const Locale('en', '');
        break;
      default:
        res = Localizations.localeOf(context);
    }
    setState(() {
      _locale = res;
    });
  }

  void _changeTheme() {
   
  }

  Future<int> _initStore(BuildContext context) async {
    if (_appStore == null) {
      _appStore = globalAppStore;
     
      await _appStore.init(Localizations.localeOf(context).toString());

      // init webApi after store initiated
      webApi = Api(context, _appStore);
      webApi.init();

      _changeLang(context, _appStore.settings.localeCode);

      
      CheckVersion().getNewVersion(context);
    }
    return _appStore.account.accountList.length;
  }

  @override
  void dispose() async {
    didReceiveLocalNotificationSubject.close();
    selectNotificationSubject.close();
    webApi.close();
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        localizationsDelegates: [
          AppLocalizationsDelegate(_locale),
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en', ''),
          const Locale('zh', ''),
        ],
        initialRoute: Home.route,
        theme: AppTheme.getThemeData(),
        routes: {
          Home.route: (context) => Observer(
                builder: (_) {
                  return FutureBuilder<int>(
                    future: _initStore(context),
                    builder: (_, AsyncSnapshot<int> snapshot) {
                      if (snapshot.hasData) {
                        return Home(_appStore);
                      } else {
                        return Scaffold(
                          body: Center(child: LoadingWidget()),
                        );
                      }
                    },
                  );
                },
              ),

          CreateAccountEntryPage.route: (_) => CreateAccountEntryPage(),
          My.route: (_) => My(_appStore),
          Search.route: (_) => Search(_appStore.ipse),
          Claim.route: (_) => Claim(_appStore),
          ClaimRecord.route: (_) => ClaimRecord(_appStore),

          Staking.route: (_) => Staking(_appStore),
          // governance
          DemocracyPage.route: (_) => DemocracyPage(_appStore),
          CouncilPage.route: (_) => CouncilPage(_appStore),
          MotionDetailPage.route: (_) => MotionDetailPage(_appStore),
          TreasuryPage.route: (_) => TreasuryPage(_appStore),
          SpendProposalPage.route: (_) => SpendProposalPage(_appStore),
          TipDetailPage.route: (_) => TipDetailPage(_appStore),
          SubmitProposalPage.route: (_) => SubmitProposalPage(_appStore),
          SubmitTipPage.route: (_) => SubmitTipPage(_appStore),
          CandidateDetailPage.route: (_) => CandidateDetailPage(_appStore),
          CouncilVotePage.route: (_) => CouncilVotePage(_appStore),
          CandidateListPage.route: (_) => CandidateListPage(_appStore),
          ReferendumVotePage.route: (_) => ReferendumVotePage(_appStore),
          ProposalDetailPage.route: (_) => ProposalDetailPage(_appStore),

          /// create account
          CreateAccountEntryPage.route: (_) => CreateAccountEntryPage(),
          CreateAccountPage.route: (_) =>
              CreateAccountPage(_appStore.account.setNewAccount),
          BackupAccountPage.route: (_) => BackupAccountPage(_appStore),
          ImportAccountPage.route: (_) => ImportAccountPage(_appStore),

          /// contact
          ContactListPage.route: (_) => ContactListPage(_appStore),
          ContactPage.route: (_) => ContactPage(_appStore),
          ContactsPage.route: (_) => ContactsPage(_appStore.settings),

          /// my
          SelectAccount.route: (_) => SelectAccount(_appStore, _changeTheme),
          AddLabel.route: (_) => AddLabel(_appStore),
          IpseMinerRegister.route: (_) => IpseMinerRegister(_appStore),
          IpseMinerManage.route: (_) => IpseMinerManage(_appStore),
          IpseMinerSelect.route: (_) => IpseMinerSelect(_appStore),
          IpseMortgageRanking.route: (_) => IpseMortgageRanking(_appStore),
          CreateOrder.route: (_) => CreateOrder(_appStore),
          IpseMinerOrders.route: (_) => IpseMinerOrders(_appStore),
          OrderDetail.route: (_) => OrderDetail(_appStore),

          MortgageRanking.route: (_) => MortgageRanking(_appStore),
          MinerSelect.route: (_) => MinerSelect(_appStore),
          MinerManage.route: (_) => MinerManage(_appStore),
          Mortgage.route: (_) => Mortgage(_appStore),
          PocMyMiningHistory.route: (_) => PocMyMiningHistory(_appStore),
          PocRegister.route: (_) => PocRegister(_appStore),
          UserMortgage.route: (_) => UserMortgage(_appStore),
          ChangeDiskInfo.route: (_) => ChangeDiskInfo(_appStore),
          ChangePID.route: (_) => ChangePID(_appStore),
          ChangeRewardAddress.route: (_) => ChangeRewardAddress(_appStore),
          ChangeProportion.route: (_) => ChangeProportion(_appStore),

          AddressQR.route: (_) => AddressQR(_appStore.account),
          ScanPage.route: (_) => ScanPage(),

          ChangeName.route: (_) => ChangeName(_appStore.account),
          ChangePassword.route: (_) => ChangePassword(_appStore.account),
          ExportAccount.route: (_) => ExportAccount(_appStore.account),
          ExportResult.route: (_) => ExportResult(),
          ManageAccount.route: (_) => ManageAccount(_appStore),

          Setting.route: (_) =>
              Setting(_appStore.settings, _changeLang, _appStore.ipse),

          SetNode.route: (_) => SetNode(_appStore.settings),
          CustomTypes.route: (_) => CustomTypes(_appStore),
          AddNode.route: (_) => AddNode(_appStore.settings),
          About.route: (_) => About(),

          TxConfirmPage.route: (_) => TxConfirmPage(_appStore),
          Asset.route: (_) => Asset(_appStore),
          TransferPage.route: (_) => TransferPage(_appStore),
          TransferDetailPage.route: (_) => TransferDetailPage(_appStore),

          // staking
          StakingDetailPage.route: (_) => StakingDetailPage(_appStore),
          ValidatorDetailPage.route: (_) => ValidatorDetailPage(_appStore),
          BondPage.route: (_) => BondPage(_appStore),
          BondExtraPage.route: (_) => BondExtraPage(_appStore),
          UnBondPage.route: (_) => UnBondPage(_appStore),
          NominatePage.route: (_) => NominatePage(_appStore),
          SetPayeePage.route: (_) => SetPayeePage(_appStore),
          RedeemPage.route: (_) => RedeemPage(_appStore),
          PayoutPage.route: (_) => PayoutPage(_appStore),
          SetControllerPage.route: (_) => SetControllerPage(_appStore),
          AccountSelectPage.route: (_) => AccountSelectPage(_appStore),
        });
  }
}
