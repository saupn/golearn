import '../common/models/mission.dart';
import '../common/repositories/mission_repository.dart';
import 'seed_data.dart';

class MockMissionRepository implements MissionRepository {
  @override
  Future<List<Mission>> getMissionsByLesson(String lessonId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return SeedData.missions.where((m) => m.lessonId == lessonId).toList();
  }

  @override
  Future<Mission?> getMissionById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return SeedData.missions.where((m) => m.id == id).firstOrNull;
  }

  @override
  Future<Mission?> getMission(String id) async {
    return getMissionById(id);
  }
}
