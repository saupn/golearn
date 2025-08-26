import '../models/reward.dart';

abstract class RewardRepository {
  Future<List<Reward>> getUserRewards(String userId);
  Future<Reward> createReward(
    String userId,
    RewardSourceType sourceType,
    String sourceRef,
    double amount,
  );
  Future<double> getUserTokenBalance(String userId);
}
