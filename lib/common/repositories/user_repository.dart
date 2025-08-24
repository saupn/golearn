import '../models/user.dart';

abstract class UserRepository {
  Future<User?> getCurrentUser();
  Future<User> updateUser(User user);
  Future<void> signOut();
  Future<User> signInWithEmail(String email);
  Future<User> signInWithGoogle();
}
