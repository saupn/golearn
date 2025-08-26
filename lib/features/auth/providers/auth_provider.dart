import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/models/user.dart';
import '../../../common/repositories/user_repository.dart';
import '../../../mock/mock_user_repository.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return MockUserRepository();
});

final authProvider = NotifierProvider<AuthNotifier, AsyncValue<User?>>(() {
  return AuthNotifier();
});

class AuthNotifier extends Notifier<AsyncValue<User?>> {
  late final UserRepository _userRepository;

  @override
  AsyncValue<User?> build() {
    _userRepository = ref.read(userRepositoryProvider);
    _checkCurrentUser();
    return const AsyncValue.loading();
  }

  Future<void> _checkCurrentUser() async {
    try {
      final user = await _userRepository.getCurrentUser();
      state = AsyncValue.data(user);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> signInWithEmail(String email) async {
    state = const AsyncValue.loading();
    try {
      final user = await _userRepository.signInWithEmail(email);
      state = AsyncValue.data(user);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncValue.loading();
    try {
      final user = await _userRepository.signInWithGoogle();
      state = AsyncValue.data(user);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _userRepository.signOut();
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateUser(User user) async {
    try {
      final updatedUser = await _userRepository.updateUser(user);
      state = AsyncValue.data(updatedUser);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
