import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
    static AppPreferences _instance = AppPreferences._internal();

    static Future<void> loadInstance() async {
        if (_instance._prefs == null) {
            _instance._prefs = await SharedPreferences.getInstance();
        }
        return _instance;
    }

    static const KEY_AGREE_TO_TERMS = "agree_to_terms_of_service";

    SharedPreferences _prefs;

    AppPreferences._internal();

    factory AppPreferences() {
        return _instance;
    }

    bool get agreedToTermsOfService => _prefs.getBool(KEY_AGREE_TO_TERMS) ?? false;
    set agreedToTermsOfService(bool agreed) => _prefs.setBool(KEY_AGREE_TO_TERMS, agreed);

    clear() async {
        await _prefs.clear();
    }
}
