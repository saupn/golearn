import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/models/mission.dart';
import '../../../common/repositories/mission_repository.dart';
import '../../../mock/mock_mission_repository.dart';

final missionRepositoryProvider = Provider<MissionRepository>((ref) {
  return MockMissionRepository();
});

final missionsByLessonProvider = FutureProvider.family<List<Mission>, String>((ref, lessonId) async {
  final missionRepo = ref.read(missionRepositoryProvider);
  return missionRepo.getMissionsByLesson(lessonId);
});

final missionProvider = FutureProvider.family<Mission?, String>((ref, missionId) async {
  final missionRepo = ref.read(missionRepositoryProvider);
  return missionRepo.getMission(missionId);
});
