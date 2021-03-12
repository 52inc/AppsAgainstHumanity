import 'dart:io';

import 'package:appsagainsthumanity/data/app_preferences.dart';
import 'package:appsagainsthumanity/data/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DeviceRepository {
    static DeviceRepository _instance = DeviceRepository._();

    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseFirestore _db = FirebaseFirestore.instance;
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    DeviceRepository._();

    factory DeviceRepository() {
        return _instance;
    }

    void updatePushToken(String token) async {
        AppPreferences().pushToken = token;
        var currentUser = _auth.currentUser;
        if (currentUser != null) {
            // If current token is not null, attempt to pull existing device info and copy it to new push token
            var document = _db.collection(FirebaseConstants.COLLECTION_USERS)
                .doc(currentUser.uid)
                .collection(FirebaseConstants.COLLECTION_DEVICES)
                .doc(AppPreferences().deviceId);

            var snapshot = await document.get();
            if (snapshot.exists) {
                await document.update({
                    "token": token
                });
            } else {
                var newDevice = await _createNewDevice(token);
                await document.set(newDevice);
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
        return "unknown";
        // if (Platform.isAndroid) {
        //     return "android";
        // } else if (Platform.isIOS) {
        //     return "ios";
        // } else {
        //     return "other";
        // }
    }

    Future<String> _getDeviceInfo() async {
        var androidInfo = await deviceInfo.androidInfo;
        if (androidInfo != null) {
            return "${androidInfo.manufacturer}/${androidInfo.model}/${androidInfo.product}/isPhysicalDevice(${androidInfo.isPhysicalDevice})/sdk(${androidInfo.version.sdkInt})";
        } else {
            var iosInfo = await deviceInfo.iosInfo;
            return "${iosInfo.model}/${iosInfo.systemName}/${iosInfo.systemVersion}";
        }
    }
}
