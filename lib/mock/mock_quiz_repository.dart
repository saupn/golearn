import '../common/models/quiz.dart';
import '../common/repositories/quiz_repository.dart';
import 'seed_data.dart';

class MockQuizRepository implements QuizRepository {
  final List<QuizResult> _results = [];

  @override
  Future<Quiz?> getQuizByLessonId(String lessonId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return SeedData.quizzes.where((q) => q.lessonId == lessonId).firstOrNull;
  }

  @override
  Future<QuizResult> submitQuizResult(
    String quizId,
    String userId,
    List<int> answers,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final quiz = SeedData.quizzes.where((q) => q.id == quizId).first;
    int correctAnswers = 0;

    for (int i = 0; i < quiz.questions.length && i < answers.length; i++) {
      final question = quiz.questions[i];
      if (question.type == QuestionType.singleChoice) {
        if (question.correctAnswers.contains(answers[i])) {
          correctAnswers++;
        }
      } else {
        if (question.correctAnswers.contains(answers[i])) {
          correctAnswers++;
        }
      }
    }

    final score = correctAnswers / quiz.questions.length;
    final passed = score >= quiz.passScore;

    final result = QuizResult(
      quizId: quizId,
      userAnswers: answers,
      score: score,
      passed: passed,
      completedAt: DateTime.now(),
    );

    _results.add(result);
    return result;
  }

  @override
  Future<List<QuizResult>> getUserQuizResults(String userId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _results;
  }

  @override
  Future<Quiz?> getQuizByLesson(String lessonId) async {
    return getQuizByLessonId(lessonId);
  }
}
