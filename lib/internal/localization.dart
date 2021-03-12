import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:appsagainsthumanity/l10n/messages_all.dart';

class AppLocalization {
  static Locale currentLocale = Locale('en', 'US');

  static Future<AppLocalization> load(Locale locale) {
    currentLocale = locale;
    final String name = locale.countryCode == null ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((bool _) {
      Intl.defaultLocale = localeName;
      return new AppLocalization();
    });
  }

  static AppLocalization of(BuildContext context) {
    return Localizations.of<AppLocalization>(context, AppLocalization);
  }

  String get appName => Intl.message('AppsAgainstHumanity', name: 'appName');
  String get appNameDisplay => Intl.message('Apps Against\nHumanity', name: 'appNameDisplay');
  String get actionSignIn => Intl.message('Sign in with Google', name: 'actionSignIn');
  String get actionSignInEmail => Intl.message('Sign in with Email', name: 'actionSignIn');

  String get titleNewGame => Intl.message('New game', name: 'titleNewGame');
  String get actionStartGame => Intl.message('Start game', name: 'actionStartGame');
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalization> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'es'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalization> load(Locale locale) {
    return AppLocalization.load(locale);
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalization> old) {
    return false;
  }
}

extension AppLocalizationExt on BuildContext {

  AppLocalization get strings => AppLocalization.of(this);
}
