import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';

class Analytics with FirebaseAnalytics {
  static Analytics _instance = Analytics._();

  FirebaseAnalytics _firebaseAnalytics;

  Analytics._() {
    if (Platform.isAndroid || Platform.isIOS) {
      _firebaseAnalytics = FirebaseAnalytics();
    }
  }

  factory Analytics() {
    return _instance;
  }

  @override
  Future<void> setCurrentScreen({String screenName, String screenClassOverride = 'Flutter'}) {
    return _firebaseAnalytics?.setCurrentScreen(screenName: screenName, screenClassOverride: 'Flutter')
        ?? Future.value();
  }

  @override
  Future<void> logEvent({String name, Map<String, dynamic> parameters}) {
    return _firebaseAnalytics?.logEvent(name: name, parameters: parameters)
        ?? Future.value();
  }

  @override
  Future<void> logSelectContent({String contentType, String itemId}) {
    return _firebaseAnalytics?.logSelectContent(contentType: contentType, itemId: itemId)
        ?? Future.value();
  }

  @override
  Future<void> logViewItemList({String itemCategory}) {
    return _firebaseAnalytics?.logViewItemList(itemCategory: itemCategory)
        ?? Future.value();
  }

  @override
  Future<void> logLogin({String loginMethod}) {
    return _firebaseAnalytics?.logLogin(loginMethod: loginMethod)
        ?? Future.value();
  }
}
