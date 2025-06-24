import 'package:shared_preferences/shared_preferences.dart';

/// A class to manage session tokens and user names in shared preferences.
class SessionManager {
  static const String _sessionKey = 'sessionToken';
  static const String _userKey = 'userName';

  static late SharedPreferences _prefs;

  // Initialize SharedPreferences instance.
  static Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Method to check if a user is logged in (has an active session).
  static Future<bool> isLoggedIn() async {
    await _init();
    final sessionToken = _prefs.getString(_sessionKey);
    return sessionToken != null;
  }

  // Method to retrieve the session token.
  static Future<String> getSessionToken() async {
    await _init();
    final sessionToken = _prefs.getString(_sessionKey) ?? '';
    return 'Bearer $sessionToken';
  }

  // Method to retrieve the user name.
  static Future<String> getUserName() async {
    await _init();
    return _prefs.getString(_userKey) ?? '';
  }

  // Method to set the session token.
  static Future<void> setSessionToken(String token) async {
    await _init();
    await _prefs.setString(_sessionKey, token);
  }

  // Method to set the user name.
  static Future<void> setUserName(String userName) async {
    await _init();
    await _prefs.setString(_userKey, userName);
  }

  // Method to clear the session token, effectively logging the user out.
  static Future<void> clearSession() async {
    await _init();
    await _prefs.remove(_sessionKey);
  }
}
