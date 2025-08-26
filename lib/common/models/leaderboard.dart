class LeaderboardEntry {
  final String boardId;
  final String userId;
  final String displayName;
  final String? avatarUrl;
  final double metricValue;
  final int rank;
  final DateTime updatedAt;

  const LeaderboardEntry({
    required this.boardId,
    required this.userId,
    required this.displayName,
    this.avatarUrl,
    required this.metricValue,
    required this.rank,
    required this.updatedAt,
  });

  LeaderboardEntry copyWith({
    String? boardId,
    String? userId,
    String? displayName,
    String? avatarUrl,
    double? metricValue,
    int? rank,
    DateTime? updatedAt,
  }) {
    return LeaderboardEntry(
      boardId: boardId ?? this.boardId,
      userId: userId ?? this.userId,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      metricValue: metricValue ?? this.metricValue,
      rank: rank ?? this.rank,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
