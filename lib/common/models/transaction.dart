enum TransactionType { claim, stake, unstake, reward }

enum TransactionStatus { pending, confirmed, reversed }

class Transaction {
  final String id;
  final String userId;
  final TransactionType type;
  final double amount;
  final double balanceAfter;
  final TransactionStatus status;
  final DateTime createdAt;
  final DateTime? confirmedAt;

  const Transaction({
    required this.id,
    required this.userId,
    required this.type,
    required this.amount,
    required this.balanceAfter,
    required this.status,
    required this.createdAt,
    this.confirmedAt,
  });

  Transaction copyWith({
    String? id,
    String? userId,
    TransactionType? type,
    double? amount,
    double? balanceAfter,
    TransactionStatus? status,
    DateTime? createdAt,
    DateTime? confirmedAt,
  }) {
    return Transaction(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      balanceAfter: balanceAfter ?? this.balanceAfter,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      confirmedAt: confirmedAt ?? this.confirmedAt,
    );
  }
}
