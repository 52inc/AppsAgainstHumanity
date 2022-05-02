import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:appsagainsthumanity/l10n/messages_all.dart';

class AppLocalization {
  static Locale currentLocale = Locale('en', 'US');

  static Future<AppLocalization> load(Locale locale) {
    currentLocale = locale;
    final String name =
        locale.countryCode == null ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((bool _) {
      Intl.defaultLocale = localeName;
      return new AppLocalization();
    });
  }

  static AppLocalization? of(BuildContext context) {
    return Localizations.of<AppLocalization>(context, AppLocalization);
  }

  String get appName => Intl.message('AppsAgainstHumanity', name: 'appName');
  String get appNameDisplay =>
      Intl.message('Apps Against\nHumanity', name: 'appNameDisplay');
  String get actionSignIn =>
      Intl.message('Sign in with Google', name: 'actionSignIn');
  String get actionSignInAnonymously =>
      Intl.message('Sign in anonymously', name: 'actionSignInAnonymously');
  String get actionSignInEmail =>
      Intl.message('Sign in with Email', name: 'actionSignInEmail');
  String get actionEmailSignUp =>
      Intl.message('Sign up', name: 'actionEmailSignUp');
  String get actionEmailSignIn =>
      Intl.message('Sign in', name: 'actionEmailSignIn');
  String get actionEmailAltSignUp =>
      Intl.message('or sign up', name: 'actionEmailAltSignUp');
  String get actionEmailAltSignIn =>
      Intl.message('or sign in', name: 'actionEmailAltSignIn');
  String get hintEmail => Intl.message('Email', name: 'hintEmail');
  String get hintPassword => Intl.message('Password', name: 'hintPassword');
  String get hintConfirmPassword =>
      Intl.message('Confirm password', name: 'hintConfirmPassword');
  String get hintUserName => Intl.message('Username', name: 'hintUserName');
  String get errorInvalidUserName =>
      Intl.message('Please enter a valid username',
          name: 'errorInvalidUserName');
  String get errorInvalidEmailAddress =>
      Intl.message('Please enter a valid email address',
          name: 'errorInvalidEmailAddress');
  String get errorInvalidPasswordLength =>
      Intl.message('You must enter a password of at lease 8 characters',
          name: 'errorInvalidPasswordLength');
  String get errorMismatchingPasswords =>
      Intl.message('This must match the above password',
          name: 'errorMismatchingPasswords');

  String get titleNewGame => Intl.message('New game', name: 'titleNewGame');
  String get actionStartGame =>
      Intl.message('Start game', name: 'actionStartGame');
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
  AppLocalization get strings => AppLocalization.of(this)!;
}
