import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/repositories/reward_repository.dart';
import '../../../mock/mock_reward_repository.dart';
import '../../auth/providers/auth_provider.dart';

final rewardRepositoryProvider = Provider<RewardRepository>((ref) {
  return MockRewardRepository();
});

final tokenBalanceProvider = FutureProvider<double>((ref) async {
  final authState = ref.watch(authProvider);
  return authState.when(
    data: (user) async {
      if (user == null) return 0.0;
      final rewardRepo = ref.read(rewardRepositoryProvider);
      return rewardRepo.getUserTokenBalance(user.id);
    },
    loading: () => 0.0,
    error: (_, __) => 0.0,
  );
});
