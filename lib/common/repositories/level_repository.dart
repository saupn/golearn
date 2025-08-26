import '../models/level.dart';

abstract class LevelRepository {
  Future<List<Level>> getLevelsByDomain(String domainId);
  Future<Level?> getLevelById(String id);
  Future<Level?> getNextLevel(String domainId, String userId);
  Future<Level> updateLevelStatus(
    String levelId,
    String userId,
    LevelStatus status,
  );
}
