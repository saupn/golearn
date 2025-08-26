import '../models/leaderboard.dart';

abstract class LeaderboardRepository {
  Future<List<LeaderboardEntry>> getLeaderboard(
    String boardId, {
    int limit = 100,
  });
  Future<LeaderboardEntry?> getUserPosition(String boardId, String userId);
}
