import '../common/models/level.dart';
import '../common/repositories/level_repository.dart';
import 'seed_data.dart';

class MockLevelRepository implements LevelRepository {
  @override
  Future<List<Level>> getLevelsByDomain(String domainId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return SeedData.levels.where((l) => l.domainId == domainId).toList();
  }

  @override
  Future<Level?> getLevelById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return SeedData.levels.where((l) => l.id == id).firstOrNull;
  }

  @override
  Future<Level?> getNextLevel(String domainId, String userId) async {
    await Future.delayed(const Duration(milliseconds: 250));
    final levels = SeedData.levels
        .where((l) => l.domainId == domainId)
        .toList();
    levels.sort((a, b) => a.levelNumber.compareTo(b.levelNumber));
    return levels
            .where((l) => l.status == LevelStatus.inProgress)
            .firstOrNull ??
        levels.where((l) => l.status == LevelStatus.locked).firstOrNull;
  }

  @override
  Future<Level> updateLevelStatus(
    String levelId,
    String userId,
    LevelStatus status,
  ) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final level = SeedData.levels.where((l) => l.id == levelId).first;
    final updatedLevel = level.copyWith(status: status);
    final index = SeedData.levels.indexWhere((l) => l.id == levelId);
    SeedData.levels[index] = updatedLevel;
    return updatedLevel;
  }
}
