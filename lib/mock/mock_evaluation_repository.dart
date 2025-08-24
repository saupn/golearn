import 'dart:math';
import '../common/models/evaluation.dart';
import '../common/repositories/evaluation_repository.dart';

class MockEvaluationRepository implements EvaluationRepository {
  final List<Evaluation> _evaluations = [];
  final Random _random = Random();

  @override
  Future<Evaluation?> getEvaluationBySubmissionId(String submissionId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _evaluations.where((e) => e.submissionId == submissionId).firstOrNull;
  }

  @override
  Future<Evaluation> createMockEvaluation(String submissionId) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    
    final criteria = [
      EvalItem(
        label: 'Content Quality',
        weight: 0.4,
        score: 0.7 + _random.nextDouble() * 0.3,
        comment: 'Good understanding of the concepts with room for improvement in detail.',
      ),
      EvalItem(
        label: 'Technical Implementation',
        weight: 0.3,
        score: 0.6 + _random.nextDouble() * 0.4,
        comment: 'Solid technical execution with proper use of HTML elements.',
      ),
      EvalItem(
        label: 'Creativity',
        weight: 0.2,
        score: 0.5 + _random.nextDouble() * 0.5,
        comment: 'Shows creative thinking in approach and presentation.',
      ),
      EvalItem(
        label: 'Code Quality',
        weight: 0.1,
        score: 0.8 + _random.nextDouble() * 0.2,
        comment: 'Clean, well-structured code following best practices.',
      ),
    ];
    
    final totalScore = criteria.fold(0.0, (sum, item) => sum + (item.score * item.weight));
    final passed = totalScore >= 0.7;
    
    final flags = <EvaluationFlag>[];
    if (_random.nextDouble() < 0.1) flags.add(EvaluationFlag.plagiarism);
    if (_random.nextDouble() < 0.05) flags.add(EvaluationFlag.suspiciousImage);
    
    final evaluation = Evaluation(
      id: 'eval_${DateTime.now().millisecondsSinceEpoch}',
      submissionId: submissionId,
      rubricId: 'rubric_default',
      perCriteria: criteria,
      totalScore: totalScore,
      passed: passed,
      flags: flags,
      feedback: passed 
        ? 'Great work! You\'ve demonstrated a solid understanding of the concepts.'
        : 'Good effort! Please review the feedback and consider resubmitting.',
      createdAt: DateTime.now(),
    );
    
    _evaluations.add(evaluation);
    return evaluation;
  }
}
