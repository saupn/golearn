import '../models/evaluation.dart';

abstract class EvaluationRepository {
  Future<Evaluation?> getEvaluationBySubmissionId(String submissionId);
  Future<Evaluation> createMockEvaluation(String submissionId);
}
