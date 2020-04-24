import 'dart:convert';

import 'package:appsagainsthumanity/data/app_preferences.dart';
import 'package:appsagainsthumanity/data/features/devices/device_repository.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:logging/logging.dart';

class PushNotifications {
    PushNotifications._();

    static PushNotifications _instance = PushNotifications._();

    factory PushNotifications() {
        return _instance;
    }

    void setup() {
        // Setup firebase messaging
        final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
        _firebaseMessaging.onTokenRefresh.listen((token) {
            DeviceRepository().updatePushToken(token);
        });
        _firebaseMessaging.configure(
            onLaunch: (Map<String, dynamic> message) async {
                print("onLaunch()");
                print(JsonEncoder().convert(message));
            },
            onMessage: (Map<String, dynamic> message) async {
                print("onMessage()");
                print(JsonEncoder().convert(message));
            },
            onResume: (Map<String, dynamic> message) async {
                print("onResume()");
                print(JsonEncoder().convert(message));
            }
        );

        checkAndUpdateToken();
    }

    Future<void> checkAndUpdateToken() async {
        final FirebaseMessaging messaging = FirebaseMessaging();
        String token = await messaging.getToken();
        if (token != AppPreferences().pushToken) {
            Logger.root.fine("FCM Token is different from what is stored in preferences, updating device...");
            DeviceRepository().updatePushToken(token);
        }
    }
}
