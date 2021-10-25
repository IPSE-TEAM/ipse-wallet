import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'package:ipsewallet/utils/i18n/assets.dart';
import 'package:ipsewallet/utils/i18n/gov.dart';
import 'package:ipsewallet/utils/i18n/ipse.dart';
import 'package:ipsewallet/utils/i18n/my.dart';
import 'package:ipsewallet/utils/i18n/setting.dart';
import 'package:ipsewallet/utils/i18n/staking.dart';
import 'package:ipsewallet/utils/i18n/treasury.dart';
import 'package:ipsewallet/utils/i18n/council.dart';
import 'package:ipsewallet/utils/i18n/democracy.dart';

import 'home.dart';
import 'account.dart';
import 'profile.dart';

class AppLocalizationsDelegate extends LocalizationsDelegate<I18n> {
  const AppLocalizationsDelegate(this.overriddenLocale);

  final Locale overriddenLocale;

  @override
  bool isSupported(Locale locale) => ['en', 'zh'].contains(locale.languageCode);

  @override
  Future<I18n> load(Locale locale) {
    return SynchronousFuture<I18n>(I18n(overriddenLocale));
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => true;
}

class I18n {
  I18n(this.locale);

  final Locale locale;

  static I18n of(BuildContext context) {
    return Localizations.of<I18n>(context, I18n);
  }

  static Map<String, Map<String, Map<String, String>>> _localizedValues = {
    'en': {
      'home': enHome,
      'ipse': enIpse,
      'my': enMy,
      'setting': enSetting,
      'account': enAccount,
      'assets': enAssets,
      'staking': enStaking,
      'gov': enGov,
      'profile': enProfile,
      'treasury': enTreasury,
      'council': enCouncil,
      'democracy': enDemocracy
    },
    'zh': {
      'home': zhHome,
      'ipse': zhIpse,
      'my': zhMy,
      'setting': zhSetting,
      'account': zhAccount,
      'assets': zhAssets,
      'staking': zhStaking,
      'gov': zhGov,
      'profile': zhProfile,
      'treasury': zhTreasury,
      'council': zhCouncil,
      'democracy': zhDemocracy
    },
  };

  Map<String, String> get home {
    return _localizedValues[locale.languageCode]['home'];
  }

  Map<String, String> get transaction {
    return _localizedValues[locale.languageCode]['transaction'];
  }

  Map<String, String> get ipse {
    return _localizedValues[locale.languageCode]['ipse'];
  }

  Map<String, String> get my {
    return _localizedValues[locale.languageCode]['my'];
  }

  Map<String, String> get setting {
    return _localizedValues[locale.languageCode]['setting'];
  }

  Map<String, String> get account {
    return _localizedValues[locale.languageCode]['account'];
  }

  Map<String, String> get assets {
    return _localizedValues[locale.languageCode]['assets'];
  }

  Map<String, String> get staking {
    return _localizedValues[locale.languageCode]['staking'];
  }

  Map<String, String> get profile {
    return _localizedValues[locale.languageCode]['profile'];
  }

  Map<String, String> get treasury {
    return _localizedValues[locale.languageCode]['treasury'];
  }

  Map<String, String> get council {
    return _localizedValues[locale.languageCode]['council'];
  }

  Map<String, String> get democracy {
    return _localizedValues[locale.languageCode]['democracy'];
  }

  Map<String, String> get gov {
    return _localizedValues[locale.languageCode]['gov'];
  }
}
