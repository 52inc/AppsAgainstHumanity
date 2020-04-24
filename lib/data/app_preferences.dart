import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class AppPreferences {
    static AppPreferences _instance = AppPreferences._internal();

    static Future<void> loadInstance() async {
        if (_instance._prefs == null) {
            _instance._prefs = await SharedPreferences.getInstance();
        }
        return _instance;
    }

    static const KEY_AGREE_TO_TERMS = "agree_to_terms_of_service";
    static const KEY_PUSH_TOKEN = "push_token";
    static const KEY_DEVICE_ID = "device_id";

    SharedPreferences _prefs;

    AppPreferences._internal();

    factory AppPreferences() {
        return _instance;
    }

    bool get agreedToTermsOfService => _prefs.getBool(KEY_AGREE_TO_TERMS) ?? false;
    set agreedToTermsOfService(bool agreed) => _prefs.setBool(KEY_AGREE_TO_TERMS, agreed);

    String get pushToken => _prefs.getString(KEY_PUSH_TOKEN);
    set pushToken(String token) => _prefs.setString(KEY_PUSH_TOKEN, token);

    String get deviceId {
        var dId = _prefs.getString(KEY_DEVICE_ID);
        if (dId == null) {
            dId = Uuid().v4();
            deviceId = dId;
        }
        return dId;
    }
    set deviceId(String deviceId) => _prefs.setString(KEY_DEVICE_ID, deviceId);

    clear() async {
        var _deviceId = deviceId;
        await _prefs.clear();
        deviceId = _deviceId;
    }
}
