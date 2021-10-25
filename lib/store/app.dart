import 'package:mobx/mobx.dart';
import 'package:ipsewallet/store/council/council.dart';
import 'package:ipsewallet/store/democracy/democracy.dart';
import 'package:ipsewallet/store/public.dart';
import 'package:ipsewallet/store/account/account.dart';
import 'package:ipsewallet/store/assets/assets.dart';
import 'package:ipsewallet/store/gov/governance.dart';
import 'package:ipsewallet/store/settings.dart';
import 'package:ipsewallet/store/staking/staking.dart';
import 'package:ipsewallet/store/ipse.dart';
import 'package:ipsewallet/store/treasury/treasury.dart';
import 'package:ipsewallet/utils/local_storage.dart';

part 'app.g.dart';

final AppStore globalAppStore = AppStore();

class AppStore extends _AppStore with _$AppStore {}

abstract class _AppStore with Store {
  @observable
  AccountStore account;

  @observable
  AssetsStore assets;

  @observable
  PublicStore public;

  @observable
  StakingStore staking;

  @observable
  DemocracyStore democ;

  @observable
  CouncilStore council;

  @observable
  GovernanceStore gov;

  @observable
  TreasuryStore treasury;

  @observable
  SettingsStore settings;

  @observable
  bool isReady = false;

  @observable
  IpseStore ipse;

  LocalStorage localStorage = LocalStorage();

  @action
  Future<void> init(String sysLocaleCode) async {
    // wait settings store loaded
    settings = SettingsStore(this);
    await settings.init(sysLocaleCode);
    ipse = IpseStore(this);
    await ipse.init();

    account = AccountStore(this);
    await account.loadAccount();
    assets = AssetsStore(this);
    staking = StakingStore(this);
    gov = GovernanceStore(this);
    public = PublicStore(account);
    democ = DemocracyStore(account);
    council = CouncilStore(account);
    treasury = TreasuryStore(account);

    assets.loadCache();
    staking.loadCache();
    // gov.loadCache();

    isReady = true;
  }
}
