import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/repositories/transaction_repository.dart';
import '../../../mock/mock_transaction_repository.dart';
import '../../auth/providers/auth_provider.dart';

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  return MockTransactionRepository();
});

final availableBalanceProvider = FutureProvider<double>((ref) async {
  final user = await ref.watch(authProvider.future);
  if (user == null) return 0.0;
  
  return user.stats.tokenOffchain;
});

final claimProvider = StateNotifierProvider<ClaimNotifier, ClaimState>((ref) {
  return ClaimNotifier(ref);
});

class ClaimNotifier extends StateNotifier<ClaimState> {
  final Ref _ref;

  ClaimNotifier(this._ref) : super(const ClaimState());

  Future<void> startClaim(double amount) async {
    state = state.copyWith(
      isProcessing: true,
      step: 1,
      statusMessage: 'Submitting claim request...',
    );

    await Future.delayed(const Duration(seconds: 2));

    state = state.copyWith(
      step: 2,
      statusMessage: 'Processing your claim...',
    );

    await Future.delayed(const Duration(seconds: 3));

    final user = await _ref.read(authProvider.future);
    if (user == null) return;

    final transactionRepo = _ref.read(transactionRepositoryProvider);
    await transactionRepo.createClaimTransaction(user.id, amount);

    state = state.copyWith(
      isProcessing: false,
      isCompleted: true,
      step: 3,
      statusMessage: 'Claim completed successfully!',
    );

    _ref.invalidate(authProvider);
    _ref.invalidate(availableBalanceProvider);
  }

  void reset() {
    state = const ClaimState();
  }
}

class ClaimState {
  final bool isProcessing;
  final bool isCompleted;
  final int step;
  final String statusMessage;

  const ClaimState({
    this.isProcessing = false,
    this.isCompleted = false,
    this.step = 0,
    this.statusMessage = '',
  });

  ClaimState copyWith({
    bool? isProcessing,
    bool? isCompleted,
    int? step,
    String? statusMessage,
  }) {
    return ClaimState(
      isProcessing: isProcessing ?? this.isProcessing,
      isCompleted: isCompleted ?? this.isCompleted,
      step: step ?? this.step,
      statusMessage: statusMessage ?? this.statusMessage,
    );
  }
}
