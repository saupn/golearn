class User {
  final String id;
  final String displayName;
  final String email;
  final String? avatarUrl;
  final UserStats stats;
  final UserWallets wallets;
  final String preferredLanguage;
  final DateTime createdAt;

  const User({
    required this.id,
    required this.displayName,
    required this.email,
    this.avatarUrl,
    required this.stats,
    required this.wallets,
    this.preferredLanguage = 'en',
    required this.createdAt,
  });

  User copyWith({
    String? id,
    String? displayName,
    String? email,
    String? avatarUrl,
    UserStats? stats,
    UserWallets? wallets,
    String? preferredLanguage,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      stats: stats ?? this.stats,
      wallets: wallets ?? this.wallets,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class UserStats {
  final int xp;
  final int currentStreakDays;
  final int longestStreakDays;
  final double tokenOffchain;
  final DateTime? lastActivityDate;

  const UserStats({
    required this.xp,
    required this.currentStreakDays,
    required this.longestStreakDays,
    required this.tokenOffchain,
    this.lastActivityDate,
  });

  UserStats copyWith({
    int? xp,
    int? currentStreakDays,
    int? longestStreakDays,
    double? tokenOffchain,
    DateTime? lastActivityDate,
  }) {
    return UserStats(
      xp: xp ?? this.xp,
      currentStreakDays: currentStreakDays ?? this.currentStreakDays,
      longestStreakDays: longestStreakDays ?? this.longestStreakDays,
      tokenOffchain: tokenOffchain ?? this.tokenOffchain,
      lastActivityDate: lastActivityDate ?? this.lastActivityDate,
    );
  }
}

class UserWallets {
  final String? polygonAddress;

  const UserWallets({
    this.polygonAddress,
  });

  UserWallets copyWith({
    String? polygonAddress,
  }) {
    return UserWallets(
      polygonAddress: polygonAddress ?? this.polygonAddress,
    );
  }
}
