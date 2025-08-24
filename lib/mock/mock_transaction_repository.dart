import 'dart:async';
import '../common/models/transaction.dart';
import '../common/repositories/transaction_repository.dart';

class MockTransactionRepository implements TransactionRepository {
  final List<Transaction> _transactions = [];
  double _currentBalance = 125.50;

  @override
  Future<List<Transaction>> getUserTransactions(String userId) async {
    await Future.delayed(const Duration(milliseconds: 250));
    return _transactions.where((t) => t.userId == userId).toList();
  }

  @override
  Future<Transaction> createTransaction(String userId, TransactionType type, double amount) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    final newBalance = type == TransactionType.claim 
      ? _currentBalance - amount 
      : _currentBalance + amount;
    
    final transaction = Transaction(
      id: 'tx_${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      type: type,
      amount: amount,
      balanceAfter: newBalance,
      status: TransactionStatus.pending,
      createdAt: DateTime.now(),
    );
    
    _transactions.add(transaction);
    _simulateConfirmation(transaction.id);
    return transaction;
  }

  @override
  Future<Transaction> updateTransactionStatus(String transactionId, TransactionStatus status) async {
    await Future.delayed(const Duration(milliseconds: 200));
    
    final index = _transactions.indexWhere((t) => t.id == transactionId);
    if (index != -1) {
      _transactions[index] = _transactions[index].copyWith(
        status: status,
        confirmedAt: status == TransactionStatus.confirmed ? DateTime.now() : null,
      );
      
      if (status == TransactionStatus.confirmed) {
        _currentBalance = _transactions[index].balanceAfter;
      }
    }
    return _transactions[index];
  }

  void _simulateConfirmation(String transactionId) {
    Timer(const Duration(seconds: 3), () async {
      await updateTransactionStatus(transactionId, TransactionStatus.confirmed);
    });
  }
}
