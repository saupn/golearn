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
    NotifierProvider.family<
      SubmissionNotifier,
      AsyncValue<Submission?>,
      String
    >(SubmissionNotifier.new);

final evaluationBySubmissionProvider =
    FutureProvider.family<Evaluation?, String>((ref, submissionId) async {
      final evaluationRepo = ref.read(evaluationRepositoryProvider);
      return evaluationRepo.getEvaluationBySubmission(submissionId);
    });

class SubmissionNotifier extends FamilyNotifier<AsyncValue<Submission?>, String> {
  @override
  AsyncValue<Submission?> build(String submissionId) {
    _loadSubmission();
    return const AsyncValue.loading();
  }

  Future<void> _loadSubmission() async {
    try {
      final submissionRepo = ref.read(submissionRepositoryProvider);
      final submission = await submissionRepo.getSubmission(arg);
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

    final submissionRepo = ref.read(submissionRepositoryProvider);
    await submissionRepo.updateSubmissionStatus(
      arg,
      SubmissionStatus.evaluated,
    );

    final updatedSubmission = await submissionRepo.getSubmission(arg);
    state = AsyncValue.data(updatedSubmission);

    ref.invalidate(evaluationBySubmissionProvider(arg));
  }
}
