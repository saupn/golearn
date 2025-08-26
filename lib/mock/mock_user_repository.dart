import 'dart:async';
import '../common/models/user.dart';
import '../common/repositories/user_repository.dart';

class MockUserRepository implements UserRepository {
  User? _currentUser;

  @override
  Future<User?> getCurrentUser() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _currentUser;
  }

  @override
  Future<User> signInWithEmail(String email) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUser = User(
      id: 'user_1',
      displayName: email.split('@').first,
      email: email,
      stats: const UserStats(
        xp: 1250,
        currentStreakDays: 7,
        longestStreakDays: 15,
        tokenOffchain: 125.50,
        lastActivityDate: null,
      ),
      wallets: const UserWallets(
        polygonAddress: '0x1234567890abcdef1234567890abcdef12345678',
      ),
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    );
    return _currentUser!;
  }

  @override
  Future<User> signInWithGoogle() async {
    await Future.delayed(const Duration(milliseconds: 800));
    _currentUser = User(
      id: 'user_1',
      displayName: 'John Doe',
      email: 'john.doe@gmail.com',
      avatarUrl: 'https://via.placeholder.com/150',
      stats: const UserStats(
        xp: 1250,
        currentStreakDays: 7,
        longestStreakDays: 15,
        tokenOffchain: 125.50,
        lastActivityDate: null,
      ),
      wallets: const UserWallets(
        polygonAddress: '0x1234567890abcdef1234567890abcdef12345678',
      ),
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    );
    return _currentUser!;
  }

  @override
  Future<User> updateUser(User user) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _currentUser = user;
    return user;
  }

  @override
  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 100));
    _currentUser = null;
  }
}
