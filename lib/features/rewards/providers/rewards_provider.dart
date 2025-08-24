import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/models/reward.dart';
import '../../../common/repositories/reward_repository.dart';
import '../../../mock/mock_reward_repository.dart';
import '../../auth/providers/auth_provider.dart';

final rewardRepositoryProvider = Provider<RewardRepository>((ref) {
  return MockRewardRepository();
});

final userRewardsProvider = FutureProvider<List<Reward>>((ref) async {
  final user = await ref.watch(authProvider.future);
  if (user == null) return <Reward>[];
  
  final rewardRepo = ref.read(rewardRepositoryProvider);
  return rewardRepo.getUserRewards(user.id);
});

final tokenBalanceProvider = FutureProvider<double>((ref) async {
  final user = await ref.watch(authProvider.future);
  if (user == null) return 0.0;
  
  final rewardRepo = ref.read(rewardRepositoryProvider);
  return rewardRepo.getUserTokenBalance(user.id);
});
