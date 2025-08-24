import '../models/quiz.dart';

abstract class QuizRepository {
  Future<Quiz?> getQuizByLessonId(String lessonId);
  Future<QuizResult> submitQuizResult(String quizId, String userId, List<int> answers);
  Future<List<QuizResult>> getUserQuizResults(String userId);
}
