enum EvaluationFlag { plagiarism, poorAudio, suspiciousImage }

class Evaluation {
  final String id;
  final String submissionId;
  final String rubricId;
  final List<EvalItem> perCriteria;
  final double totalScore;
  final bool passed;
  final List<EvaluationFlag> flags;
  final String? feedback;
  final DateTime createdAt;

  const Evaluation({
    required this.id,
    required this.submissionId,
    required this.rubricId,
    required this.perCriteria,
    required this.totalScore,
    required this.passed,
    required this.flags,
    this.feedback,
    required this.createdAt,
  });

  Evaluation copyWith({
    String? id,
    String? submissionId,
    String? rubricId,
    List<EvalItem>? perCriteria,
    double? totalScore,
    bool? passed,
    List<EvaluationFlag>? flags,
    String? feedback,
    DateTime? createdAt,
  }) {
    return Evaluation(
      id: id ?? this.id,
      submissionId: submissionId ?? this.submissionId,
      rubricId: rubricId ?? this.rubricId,
      perCriteria: perCriteria ?? this.perCriteria,
      totalScore: totalScore ?? this.totalScore,
      passed: passed ?? this.passed,
      flags: flags ?? this.flags,
      feedback: feedback ?? this.feedback,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class EvalItem {
  final String label;
  final double weight;
  final double score;
  final String comment;

  const EvalItem({
    required this.label,
    required this.weight,
    required this.score,
    required this.comment,
  });

  EvalItem copyWith({
    String? label,
    double? weight,
    double? score,
    String? comment,
  }) {
    return EvalItem(
      label: label ?? this.label,
      weight: weight ?? this.weight,
      score: score ?? this.score,
      comment: comment ?? this.comment,
    );
  }
}
