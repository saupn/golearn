import 'dart:math';
import '../common/models/leaderboard.dart';
import '../common/repositories/leaderboard_repository.dart';
import 'seed_data.dart';

class MockLeaderboardRepository implements LeaderboardRepository {
  final Random _random = Random();

  @override
  Future<List<LeaderboardEntry>> getLeaderboard(
    String boardId, {
    int limit = 100,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final entries = SeedData.leaderboardEntries
        .where((e) => e.boardId == boardId)
        .toList();

    if (entries.length < limit) {
      for (int i = entries.length; i < limit && i < 50; i++) {
        entries.add(
          LeaderboardEntry(
            boardId: boardId,
            userId: 'user_${i + 10}',
            displayName: 'User ${i + 1}',
            avatarUrl: 'https://via.placeholder.com/100?text=U${i + 1}',
            metricValue: 100 - (i * 2) + _random.nextDouble() * 10,
            rank: i + 1,
            updatedAt: DateTime.now().subtract(Duration(hours: i)),
          ),
        );
      }
    }

    entries.sort((a, b) => a.rank.compareTo(b.rank));
    return entries.take(limit).toList();
  }

  @override
  Future<LeaderboardEntry?> getUserPosition(
    String boardId,
    String userId,
  ) async {
    await Future.delayed(const Duration(milliseconds: 200));

    final entries = await getLeaderboard(boardId);
    return entries.where((e) => e.userId == userId).firstOrNull;
  }
}
