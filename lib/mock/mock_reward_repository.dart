import '../common/models/reward.dart';
import '../common/repositories/reward_repository.dart';
import 'seed_data.dart';

class MockRewardRepository implements RewardRepository {
  final List<Reward> _rewards = List.from(SeedData.rewards);
  double _currentBalance = 125.50;

  @override
  Future<List<Reward>> getUserRewards(String userId) async {
    await Future.delayed(const Duration(milliseconds: 250));
    return _rewards.where((r) => r.userId == userId).toList();
  }

  @override
  Future<Reward> createReward(String userId, RewardSourceType sourceType, String sourceRef, double amount) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    final reward = Reward(
      id: 'reward_${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      sourceType: sourceType,
      sourceRef: sourceRef,
      tokenAwarded: amount,
      createdAt: DateTime.now(),
    );
    
    _rewards.add(reward);
    _currentBalance += amount;
    return reward;
  }

  @override
  Future<double> getUserTokenBalance(String userId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _currentBalance;
  }
}
