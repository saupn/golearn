import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/models/submission.dart';
import '../../../common/models/evaluation.dart';
import '../../../common/repositories/submission_repository.dart';
import '../../../common/repositories/evaluation_repository.dart';
import '../../../mock/mock_submission_repository.dart';
import '../../../mock/mock_evaluation_repository.dart';

final submissionRepositoryProvider = Provider<SubmissionRepository>((ref) {
  return MockSubmissionRepository();
});

final evaluationRepositoryProvider = Provider<EvaluationRepository>((ref) {
  return MockEvaluationRepository();
});

final submissionProvider =
    StateNotifierProvider.family<
      SubmissionNotifier,
      AsyncValue<Submission?>,
      String
    >((ref, submissionId) {
      return SubmissionNotifier(ref, submissionId);
    });

final evaluationBySubmissionProvider =
    FutureProvider.family<Evaluation?, String>((ref, submissionId) async {
      final evaluationRepo = ref.read(evaluationRepositoryProvider);
      return evaluationRepo.getEvaluationBySubmission(submissionId);
    });

class SubmissionNotifier extends StateNotifier<AsyncValue<Submission?>> {
  final Ref _ref;
  final String _submissionId;

  SubmissionNotifier(this._ref, this._submissionId)
    : super(const AsyncValue.loading()) {
    _loadSubmission();
  }

  Future<void> _loadSubmission() async {
    try {
      final submissionRepo = _ref.read(submissionRepositoryProvider);
      final submission = await submissionRepo.getSubmission(_submissionId);
      state = AsyncValue.data(submission);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> simulateEvaluation() async {
    final currentSubmission = state.value;
    if (currentSubmission == null) return;

    state = AsyncValue.data(
      currentSubmission.copyWith(status: SubmissionStatus.processing),
    );

    await Future.delayed(const Duration(seconds: 3));

    final submissionRepo = _ref.read(submissionRepositoryProvider);
    await submissionRepo.updateSubmissionStatus(
      _submissionId,
      SubmissionStatus.evaluated,
    );

    final updatedSubmission = await submissionRepo.getSubmission(_submissionId);
    state = AsyncValue.data(updatedSubmission);

    _ref.invalidate(evaluationBySubmissionProvider(_submissionId));
  }
}
