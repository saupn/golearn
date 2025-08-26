enum ProofType { text, link, image, document }

class Mission {
  final String id;
  final String lessonId;
  final String title;
  final String description;
  final ProofType proofType;
  final String acceptanceRule;
  final double rewardBaseToken;
  final DateTime createdAt;

  const Mission({
    required this.id,
    required this.lessonId,
    required this.title,
    required this.description,
    required this.proofType,
    required this.acceptanceRule,
    required this.rewardBaseToken,
    required this.createdAt,
  });

  Mission copyWith({
    String? id,
    String? lessonId,
    String? title,
    String? description,
    ProofType? proofType,
    String? acceptanceRule,
    double? rewardBaseToken,
    DateTime? createdAt,
  }) {
    return Mission(
      id: id ?? this.id,
      lessonId: lessonId ?? this.lessonId,
      title: title ?? this.title,
      description: description ?? this.description,
      proofType: proofType ?? this.proofType,
      acceptanceRule: acceptanceRule ?? this.acceptanceRule,
      rewardBaseToken: rewardBaseToken ?? this.rewardBaseToken,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
