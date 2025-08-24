import 'dart:async';
import '../common/models/submission.dart';
import '../common/repositories/submission_repository.dart';

class MockSubmissionRepository implements SubmissionRepository {
  final List<Submission> _submissions = [];
  final Map<String, Timer> _statusTimers = {};

  @override
  Future<Submission> createSubmission(String userId, String missionId, SubmissionType type, String payload) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    final submission = Submission(
      id: 'submission_${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      missionId: missionId,
      type: type,
      payloadRaw: payload,
      status: SubmissionStatus.pending,
      createdAt: DateTime.now(),
    );
    
    _submissions.add(submission);
    _simulateStatusTransition(submission.id);
    return submission;
  }

  @override
  Future<Submission?> getSubmissionById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _submissions.where((s) => s.id == id).firstOrNull;
  }

  @override
  Future<List<Submission>> getUserSubmissions(String userId) async {
    await Future.delayed(const Duration(milliseconds: 250));
    return _submissions.where((s) => s.userId == userId).toList();
  }

  @override
  Future<Submission> updateSubmissionStatus(String submissionId, SubmissionStatus status) async {
    await Future.delayed(const Duration(milliseconds: 200));
    
    final index = _submissions.indexWhere((s) => s.id == submissionId);
    if (index != -1) {
      _submissions[index] = _submissions[index].copyWith(
        status: status,
        updatedAt: DateTime.now(),
      );
    }
    return _submissions[index];
  }

  void _simulateStatusTransition(String submissionId) {
    Timer(const Duration(seconds: 2), () async {
      await updateSubmissionStatus(submissionId, SubmissionStatus.processing);
      
      Timer(const Duration(seconds: 3), () async {
        await updateSubmissionStatus(submissionId, SubmissionStatus.evaluated);
      });
    });
  }
}
