// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AppStore on _AppStore, Store {
  final _$accountAtom = Atom(name: '_AppStore.account');

  @override
  AccountStore get account {
    _$accountAtom.reportRead();
    return super.account;
  }

  @override
  set account(AccountStore value) {
    _$accountAtom.reportWrite(value, super.account, () {
      super.account = value;
    });
  }

  final _$assetsAtom = Atom(name: '_AppStore.assets');

  @override
  AssetsStore get assets {
    _$assetsAtom.reportRead();
    return super.assets;
  }

  @override
  set assets(AssetsStore value) {
    _$assetsAtom.reportWrite(value, super.assets, () {
      super.assets = value;
    });
  }

  final _$publicAtom = Atom(name: '_AppStore.public');

  @override
  PublicStore get public {
    _$publicAtom.reportRead();
    return super.public;
  }

  @override
  set public(PublicStore value) {
    _$publicAtom.reportWrite(value, super.public, () {
      super.public = value;
    });
  }

  final _$stakingAtom = Atom(name: '_AppStore.staking');

  @override
  StakingStore get staking {
    _$stakingAtom.reportRead();
    return super.staking;
  }

  @override
  set staking(StakingStore value) {
    _$stakingAtom.reportWrite(value, super.staking, () {
      super.staking = value;
    });
  }

  final _$democAtom = Atom(name: '_AppStore.democ');

  @override
  DemocracyStore get democ {
    _$democAtom.reportRead();
    return super.democ;
  }

  @override
  set democ(DemocracyStore value) {
    _$democAtom.reportWrite(value, super.democ, () {
      super.democ = value;
    });
  }

  final _$councilAtom = Atom(name: '_AppStore.council');

  @override
  CouncilStore get council {
    _$councilAtom.reportRead();
    return super.council;
  }

  @override
  set council(CouncilStore value) {
    _$councilAtom.reportWrite(value, super.council, () {
      super.council = value;
    });
  }

  final _$govAtom = Atom(name: '_AppStore.gov');

  @override
  GovernanceStore get gov {
    _$govAtom.reportRead();
    return super.gov;
  }

  @override
  set gov(GovernanceStore value) {
    _$govAtom.reportWrite(value, super.gov, () {
      super.gov = value;
    });
  }

  final _$treasuryAtom = Atom(name: '_AppStore.treasury');

  @override
  TreasuryStore get treasury {
    _$treasuryAtom.reportRead();
    return super.treasury;
  }

  @override
  set treasury(TreasuryStore value) {
    _$treasuryAtom.reportWrite(value, super.treasury, () {
      super.treasury = value;
    });
  }

  final _$settingsAtom = Atom(name: '_AppStore.settings');

  @override
  SettingsStore get settings {
    _$settingsAtom.reportRead();
    return super.settings;
  }

  @override
  set settings(SettingsStore value) {
    _$settingsAtom.reportWrite(value, super.settings, () {
      super.settings = value;
    });
  }

  final _$isReadyAtom = Atom(name: '_AppStore.isReady');

  @override
  bool get isReady {
    _$isReadyAtom.reportRead();
    return super.isReady;
  }

  @override
  set isReady(bool value) {
    _$isReadyAtom.reportWrite(value, super.isReady, () {
      super.isReady = value;
    });
  }

  final _$ipseAtom = Atom(name: '_AppStore.ipse');

  @override
  IpseStore get ipse {
    _$ipseAtom.reportRead();
    return super.ipse;
  }

  @override
  set ipse(IpseStore value) {
    _$ipseAtom.reportWrite(value, super.ipse, () {
      super.ipse = value;
    });
  }

  final _$initAsyncAction = AsyncAction('_AppStore.init');

  @override
  Future<void> init(String sysLocaleCode) {
    return _$initAsyncAction.run(() => super.init(sysLocaleCode));
  }

  @override
  String toString() {
    return '''
account: ${account},
assets: ${assets},
public: ${public},
staking: ${staking},
democ: ${democ},
council: ${council},
gov: ${gov},
treasury: ${treasury},
settings: ${settings},
isReady: ${isReady},
ipse: ${ipse}
    ''';
  }
}
