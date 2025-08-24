import '../models/submission.dart';

abstract class SubmissionRepository {
  Future<Submission> createSubmission(String userId, String missionId, SubmissionType type, String payload);
  Future<Submission?> getSubmissionById(String id);
  Future<List<Submission>> getUserSubmissions(String userId);
  Future<Submission> updateSubmissionStatus(String submissionId, SubmissionStatus status);
}
