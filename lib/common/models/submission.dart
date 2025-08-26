enum SubmissionStatus { pending, processing, evaluated, reviewRequired }

enum SubmissionType { text, link, image, document }

class Submission {
  final String id;
  final String userId;
  final String missionId;
  final SubmissionType type;
  final String payloadRaw;
  final SubmissionStatus status;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Submission({
    required this.id,
    required this.userId,
    required this.missionId,
    required this.type,
    required this.payloadRaw,
    required this.status,
    required this.createdAt,
    this.updatedAt,
  });

  Submission copyWith({
    String? id,
    String? userId,
    String? missionId,
    SubmissionType? type,
    String? payloadRaw,
    SubmissionStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Submission(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      missionId: missionId ?? this.missionId,
      type: type ?? this.type,
      payloadRaw: payloadRaw ?? this.payloadRaw,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
