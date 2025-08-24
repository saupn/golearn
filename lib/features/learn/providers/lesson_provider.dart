import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/models/lesson.dart';
import '../../../common/repositories/lesson_repository.dart';
import '../../../mock/mock_lesson_repository.dart';

final lessonRepositoryProvider = Provider<LessonRepository>((ref) {
  return MockLessonRepository();
});

final lessonsByModuleProvider = FutureProvider.family<List<Lesson>, String>((ref, moduleId) async {
  final lessonRepo = ref.read(lessonRepositoryProvider);
  return lessonRepo.getLessonsByModule(moduleId);
});

final lessonProvider = FutureProvider.family<Lesson?, String>((ref, lessonId) async {
  final lessonRepo = ref.read(lessonRepositoryProvider);
  return lessonRepo.getLesson(lessonId);
});
