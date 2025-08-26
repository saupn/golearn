enum RewardSourceType { quiz, mission, streak, bonus, level }

class Reward {
  final String id;
  final String userId;
  final RewardSourceType sourceType;
  final String sourceRef;
  final double tokenAwarded;
  final DateTime createdAt;

  const Reward({
    required this.id,
    required this.userId,
    required this.sourceType,
    required this.sourceRef,
    required this.tokenAwarded,
    required this.createdAt,
  });

  Reward copyWith({
    String? id,
    String? userId,
    RewardSourceType? sourceType,
    String? sourceRef,
    double? tokenAwarded,
    DateTime? createdAt,
  }) {
    return Reward(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      sourceType: sourceType ?? this.sourceType,
      sourceRef: sourceRef ?? this.sourceRef,
      tokenAwarded: tokenAwarded ?? this.tokenAwarded,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
