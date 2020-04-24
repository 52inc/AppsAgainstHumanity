import 'dart:io';

import 'package:appsagainsthumanity/data/app_preferences.dart';
import 'package:appsagainsthumanity/data/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DeviceRepository {
    static DeviceRepository _instance = DeviceRepository._();

    final FirebaseAuth _auth = FirebaseAuth.instance;
    final Firestore _db = Firestore.instance;
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    DeviceRepository._();

    factory DeviceRepository() {
        return _instance;
    }

    void updatePushToken(String token) async {
        AppPreferences().pushToken = token;
        var currentUser = await _auth.currentUser();
        if (currentUser != null) {
            // If current token is not null, attempt to pull existing device info and copy it to new push token
            var document = _db.collection(FirebaseConstants.COLLECTION_USERS)
                .document(currentUser.uid)
                .collection(FirebaseConstants.COLLECTION_DEVICES)
                .document(AppPreferences().deviceId);

            var snapshot = await document.get();
            if (snapshot.exists) {
                await document.updateData({
                    "token": token
                });
            } else {
                var newDevice = await _createNewDevice(token);
                await document.setData(newDevice);
            }
        }
    }

    Future<Map<String, dynamic>> _createNewDevice(String token) async {
        return {
            "token": token,
            "platform": _getPlatform(),
            "info": await _getDeviceInfo(),
            "createdAt": Timestamp.now(),
            "updatedAt": Timestamp.now()
        };
    }

    String _getPlatform() {
        if (Platform.isAndroid) {
            return "android";
        } else if (Platform.isIOS) {
            return "ios";
        } else {
            return Platform.operatingSystem;
        }
    }

    Future<String> _getDeviceInfo() async {
        if (Platform.isAndroid) {
            var androidInfo = await deviceInfo.androidInfo;
            return "${androidInfo.manufacturer}/${androidInfo.model}/${androidInfo.product}/isPhysicalDevice(${androidInfo.isPhysicalDevice})/sdk(${androidInfo.version.sdkInt})";
        } else {
            var iosInfo = await deviceInfo.iosInfo;
            return "${iosInfo.model}/${iosInfo.systemName}/${iosInfo.systemVersion}";
        }
    }
}
