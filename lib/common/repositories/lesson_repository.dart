import '../models/lesson.dart';

abstract class LessonRepository {
  Future<List<Lesson>> getLessonsByModule(String moduleId);
  Future<Lesson?> getLessonById(String id);
  Future<Lesson> updateLessonStatus(String lessonId, String userId, LessonStatus status);
  Future<Lesson?> getNextLesson(String userId);
}
