import '../models/mission.dart';

abstract class MissionRepository {
  Future<List<Mission>> getMissionsByLesson(String lessonId);
  Future<Mission?> getMissionById(String id);
}
