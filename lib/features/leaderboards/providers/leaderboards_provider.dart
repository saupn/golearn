import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/models/leaderboard.dart';
import '../../../common/repositories/leaderboard_repository.dart';
import '../../../mock/mock_leaderboard_repository.dart';
import '../../auth/providers/auth_provider.dart';

final leaderboardRepositoryProvider = Provider<LeaderboardRepository>((ref) {
  return MockLeaderboardRepository();
});

final leaderboardProvider =
    FutureProvider.family<List<LeaderboardEntry>, String>((ref, boardId) async {
      final leaderboardRepo = ref.read(leaderboardRepositoryProvider);
      return leaderboardRepo.getLeaderboard(boardId);
    });

final myLeaderboardPositionProvider =
    FutureProvider.family<LeaderboardEntry?, String>((ref, boardId) async {
      final authState = ref.watch(authProvider);
      return authState.when(
        data: (user) async {
          if (user == null) return null;
          final leaderboardRepo = ref.read(leaderboardRepositoryProvider);
          return leaderboardRepo.getUserPosition(boardId, user.id);
        },
        loading: () => null,
        error: (_, __) => null,
      );
    });
