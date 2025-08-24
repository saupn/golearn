enum LevelStatus { locked, inProgress, passed }

class Level {
  final String id;
  final String domainId;
  final int levelNumber;
  final String title;
  final double incomeTargetUsd;
  final GatingRule gatingRule;
  final RewardRule rewardRule;
  final LevelStatus status;
  final DateTime createdAt;

  const Level({
    required this.id,
    required this.domainId,
    required this.levelNumber,
    required this.title,
    required this.incomeTargetUsd,
    required this.gatingRule,
    required this.rewardRule,
    required this.status,
    required this.createdAt,
  });

  Level copyWith({
    String? id,
    String? domainId,
    int? levelNumber,
    String? title,
    double? incomeTargetUsd,
    GatingRule? gatingRule,
    RewardRule? rewardRule,
    LevelStatus? status,
    DateTime? createdAt,
  }) {
    return Level(
      id: id ?? this.id,
      domainId: domainId ?? this.domainId,
      levelNumber: levelNumber ?? this.levelNumber,
      title: title ?? this.title,
      incomeTargetUsd: incomeTargetUsd ?? this.incomeTargetUsd,
      gatingRule: gatingRule ?? this.gatingRule,
      rewardRule: rewardRule ?? this.rewardRule,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class GatingRule {
  final double minQuizScore;
  final int requiredMissions;
  final bool requirePrevLevel;
  final double minRealResultUsd;

  const GatingRule({
    required this.minQuizScore,
    required this.requiredMissions,
    required this.requirePrevLevel,
    required this.minRealResultUsd,
  });

  GatingRule copyWith({
    double? minQuizScore,
    int? requiredMissions,
    bool? requirePrevLevel,
    double? minRealResultUsd,
  }) {
    return GatingRule(
      minQuizScore: minQuizScore ?? this.minQuizScore,
      requiredMissions: requiredMissions ?? this.requiredMissions,
      requirePrevLevel: requirePrevLevel ?? this.requirePrevLevel,
      minRealResultUsd: minRealResultUsd ?? this.minRealResultUsd,
    );
  }
}

class RewardRule {
  final double baseToken;
  final double multiplierRule;
  final double realResultPerUsd;

  const RewardRule({
    required this.baseToken,
    required this.multiplierRule,
    required this.realResultPerUsd,
  });

  RewardRule copyWith({
    double? baseToken,
    double? multiplierRule,
    double? realResultPerUsd,
  }) {
    return RewardRule(
      baseToken: baseToken ?? this.baseToken,
      multiplierRule: multiplierRule ?? this.multiplierRule,
      realResultPerUsd: realResultPerUsd ?? this.realResultPerUsd,
    );
  }
}
