import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});

final authProvider =
    NotifierProvider<AuthNotifier, UserModel?>(AuthNotifier.new);

class AuthNotifier extends Notifier<UserModel?> {
  AuthService get _authService => ref.read(authServiceProvider);
  StorageService get _storageService => ref.read(storageServiceProvider);

  @override
  UserModel? build() {
    return null;
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
  }) {
    return _authService.register(
      fullName: fullName,
      nim: nim,
      email: email,
      password: password,
      faculty: faculty,
      studyProgram: studyProgram,
      entryYear: entryYear,
      avatar: avatar,
    );
  }

  Future<bool> login({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    final user = await _authService.login(
      email: email,
      password: password,
      rememberMe: rememberMe,
    );

    state = user;
    return user != null;
  }

  Future<void> restoreSession() async {
    state = await _authService.getCurrentUser();
  }

  Future<void> logout() async {
    await _authService.logout();
    state = null;
  }

  Future<void> updateProfile(UserModel updatedUser) async {
    await _storageService.updateUser(updatedUser);
    state = updatedUser;
  }
}
