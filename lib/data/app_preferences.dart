import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
    static AppPreferences _instance = AppPreferences._internal();

    static Future<void> loadInstance() async {
        if (_instance._prefs == null) {
            _instance._prefs = await SharedPreferences.getInstance();
        }
        return _instance;
    }

    SharedPreferences _prefs;

    AppPreferences._internal();

    factory AppPreferences() {
        return _instance;
    }

    clear() async {
        await _prefs.clear();
    }
}
