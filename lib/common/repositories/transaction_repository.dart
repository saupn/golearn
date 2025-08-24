import '../models/transaction.dart';

abstract class TransactionRepository {
  Future<List<Transaction>> getUserTransactions(String userId);
  Future<Transaction> createTransaction(String userId, TransactionType type, double amount);
  Future<Transaction> updateTransactionStatus(String transactionId, TransactionStatus status);
}
