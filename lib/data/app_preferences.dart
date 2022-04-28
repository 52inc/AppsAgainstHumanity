import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class AppPreferences {
  static AppPreferences _instance = AppPreferences._internal();

  static Future<void> loadInstance() async {
    if (_instance._prefs == "") {
      _instance._prefs = await SharedPreferences.getInstance();
    }
    return _instance;
  }

  static const KEY_AGREE_TO_TERMS = "agree_to_terms_of_service";
  static const KEY_PUSH_TOKEN = "push_token";
  static const KEY_DEVICE_ID = "device_id";
  static const KEY_PRIZES_TO_WIN = "prizes_to_win";
  static const KEY_PLAYER_LIMIT = "player_limit";
  static const KEY_DEVELOPER_PACKS = "developer_packs";

  SharedPreferences _prefs;

  AppPreferences._internal();

  factory AppPreferences() {
    return _instance;
  }

  /// Whether or not the user has agreed to TOS
  bool get agreedToTermsOfService =>
      _prefs.getBool(KEY_AGREE_TO_TERMS) ?? false;
  set agreedToTermsOfService(bool agreed) =>
      _prefs.setBool(KEY_AGREE_TO_TERMS, agreed);

  /// The Push Token
  String get pushToken => _prefs.getString(KEY_PUSH_TOKEN)!;
  set pushToken(String token) => _prefs.setString(KEY_PUSH_TOKEN, token);

  /// The last used # of prizes to win
  int get prizesToWin => _prefs.getInt(KEY_PRIZES_TO_WIN) ?? 7;
  set prizesToWin(int value) => _prefs.setInt(KEY_PRIZES_TO_WIN, value);

  /// The last used player limit of new games
  int get playerLimit => _prefs.getInt(KEY_PLAYER_LIMIT) ?? 15;
  set playerLimit(int value) => _prefs.setInt(KEY_PLAYER_LIMIT, value);

  /// Whether or not the user has unlocked the developer pack(s)
  bool get developerPackEnabled => _prefs.getBool(KEY_DEVELOPER_PACKS) ?? false;
  set developerPackEnabled(bool enabled) =>
      _prefs.setBool(KEY_DEVELOPER_PACKS, enabled);

  /// The persistent device id
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
    var _tos = agreedToTermsOfService;
    var _deviceId = deviceId;
    await _prefs.clear();
    deviceId = _deviceId;
    agreedToTermsOfService = _tos;
  }
}
