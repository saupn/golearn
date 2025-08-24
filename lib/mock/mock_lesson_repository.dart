import '../common/models/lesson.dart';
import '../common/repositories/lesson_repository.dart';
import 'seed_data.dart';

class MockLessonRepository implements LessonRepository {
  @override
  Future<List<Lesson>> getLessonsByModule(String moduleId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return SeedData.lessons.where((l) => l.moduleId == moduleId).toList();
  }

  @override
  Future<Lesson?> getLessonById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return SeedData.lessons.where((l) => l.id == id).firstOrNull;
  }

  @override
  Future<Lesson> updateLessonStatus(String lessonId, String userId, LessonStatus status) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final lesson = SeedData.lessons.where((l) => l.id == lessonId).first;
    final updatedLesson = lesson.copyWith(status: status);
    final index = SeedData.lessons.indexWhere((l) => l.id == lessonId);
    SeedData.lessons[index] = updatedLesson;
    return updatedLesson;
  }

  @override
  Future<Lesson?> getNextLesson(String userId) async {
    await Future.delayed(const Duration(milliseconds: 250));
    return SeedData.lessons.where((l) => l.status == LessonStatus.inProgress).firstOrNull ??
           SeedData.lessons.where((l) => l.status == LessonStatus.locked).firstOrNull;
  }
}
