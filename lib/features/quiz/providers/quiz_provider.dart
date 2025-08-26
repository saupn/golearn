import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/models/quiz.dart';
import '../../../common/repositories/quiz_repository.dart';
import '../../../mock/mock_quiz_repository.dart';

final quizRepositoryProvider = Provider<QuizRepository>((ref) {
  return MockQuizRepository();
});

final quizByLessonProvider = FutureProvider.family<Quiz?, String>((
  ref,
  lessonId,
) async {
  final quizRepo = ref.read(quizRepositoryProvider);
  return quizRepo.getQuizByLesson(lessonId);
});
