import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/models/level.dart';
import '../../../common/repositories/level_repository.dart';
import '../../../mock/mock_level_repository.dart';
import '../../auth/providers/auth_provider.dart';

final levelRepositoryProvider = Provider<LevelRepository>((ref) {
  return MockLevelRepository();
});

final levelsByDomainProvider = FutureProvider.family<List<Level>, String>((
  ref,
  domainId,
) async {
  final levelRepo = ref.read(levelRepositoryProvider);
  return levelRepo.getLevelsByDomain(domainId);
});

final levelProvider = FutureProvider.family<Level?, String>((
  ref,
  levelId,
) async {
  final levelRepo = ref.read(levelRepositoryProvider);
  return levelRepo.getLevelById(levelId);
});

final nextLevelProvider = FutureProvider.family<Level?, String>((
  ref,
  domainId,
) async {
  final authState = ref.watch(authProvider);
  return authState.when(
    data: (user) async {
      if (user == null) return null;
      final levelRepo = ref.read(levelRepositoryProvider);
      return levelRepo.getNextLevel(domainId, user.id);
    },
    loading: () => null,
    error: (_, __) => null,
  );
});
