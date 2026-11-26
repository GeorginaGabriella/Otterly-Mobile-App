import 'dart:convert';
import 'dart:math';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user_model.dart';
import 'storage_service.dart';

class AuthService {
  final StorageService _storage = StorageService();

  final FlutterSecureStorage _secureStorage =
      const FlutterSecureStorage();

  static const String _credentialPrefix = 'credential_';

  String _createId() {
    return DateTime.now().microsecondsSinceEpoch.toString();
  }

  String _createSalt() {
    final random = Random.secure();

    return List.generate(
      32,
      (_) => random.nextInt(256).toRadixString(16).padLeft(2, '0'),
    ).join();
  }

  // Demonstration only, not secure password hashing.
  String _demoDigest(String password, String salt) {
    return base64Encode(
      utf8.encode('$salt:$password'),
    );
  }

  Future<String?> register({
    required String fullName,
    required String nim,
    required String email,
    required String password,
    required String faculty,
    required String studyProgram,
    required String entryYear,
    required String avatar,
  }) async {
    final users = await _storage.getUsers();

    final normalizedEmail = email.trim().toLowerCase();
    final normalizedNim = nim.trim();

    final emailExists = users.any(
      (user) => user.email.toLowerCase() == normalizedEmail,
    );

    if (emailExists) {
      return 'Email is already registered.';
    }

    final nimExists = users.any(
      (user) => user.nim == normalizedNim,
    );

    if (nimExists) {
      return 'NIM is already registered.';
    }

    final id = _createId();
    final salt = _createSalt();

    final credential = jsonEncode({
      'salt': salt,
      'digest': _demoDigest(password, salt),
    });

    final user = UserModel(
      id: id,
      fullName: fullName.trim(),
      nim: normalizedNim,
      email: normalizedEmail,
      faculty: faculty,
      studyProgram: studyProgram,
      entryYear: entryYear,
      avatar: avatar,
      isVerified: false,
    );

    try {
      try {
        await _secureStorage.write(
          key: '$_credentialPrefix$id',
          value: credential,
        );
      } catch (_) {
        // Fallback to SharedPreferences on platforms without secure storage support.
      }
      await _storage.saveFallbackCredential(id, credential);

      users.add(user);
      await _storage.saveUsers(users);

      return null;
    } catch (_) {
      try {
        await _secureStorage.delete(
          key: '$_credentialPrefix$id',
        );
      } catch (_) {}
      await _storage.deleteFallbackCredential(id);
      return 'Unable to save account. Please try again.';
    }
  }

  Future<UserModel?> login({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    final users = await _storage.getUsers();

    final normalizedEmail = email.trim().toLowerCase();

    UserModel? matchedUser;

    for (final user in users) {
      if (user.email.toLowerCase() == normalizedEmail) {
        matchedUser = user;
        break;
      }
    }

    if (matchedUser == null) {
      return null;
    }

    String? storedCredential;
    try {
      storedCredential = await _secureStorage.read(
        key: '$_credentialPrefix${matchedUser.id}',
      );
    } catch (_) {
      storedCredential = null;
    }
    storedCredential ??=
        await _storage.getFallbackCredential(matchedUser.id);

    if (storedCredential == null) {
      return null;
    }

    final credential =
        jsonDecode(storedCredential) as Map<String, dynamic>;

    final salt = credential['salt'] as String;
    final expectedDigest = credential['digest'] as String;

    final actualDigest = _demoDigest(password, salt);

    if (actualDigest != expectedDigest) {
      return null;
    }

    if (rememberMe) {
      await _storage.saveSession(matchedUser.id);
    } else {
      await _storage.clearSession();
    }

    return matchedUser;
  }

  Future<UserModel?> getCurrentUser() async {
    final userId = await _storage.getSession();

    if (userId == null) {
      return null;
    }

    final users = await _storage.getUsers();

    for (final user in users) {
      if (user.id == userId) {
        return user;
      }
    }

    await _storage.clearSession();
    return null;
  }

  Future<void> logout() async {
    await _storage.clearSession();
  }
}
