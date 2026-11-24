import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class StorageService {
  static const String _usersKey = 'otterly_users';
  static const String _sessionKey = 'otterly_session';

  Future<List<UserModel>> getUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final rawData = prefs.getString(_usersKey);

    if (rawData == null) {
      return [];
    }

    final List<dynamic> decoded = jsonDecode(rawData);

    return decoded.map((item) {
      return UserModel.fromJson(
        Map<String, dynamic>.from(item),
      );
    }).toList();
  }

  Future<void> saveUsers(List<UserModel> users) async {
    final prefs = await SharedPreferences.getInstance();

    final encoded = jsonEncode(
      users.map((user) => user.toJson()).toList(),
    );

    await prefs.setString(_usersKey, encoded);
  }

  Future<void> saveSession(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_sessionKey, userId);
  }

  Future<String?> getSession() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_sessionKey);
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionKey);
  }
}
