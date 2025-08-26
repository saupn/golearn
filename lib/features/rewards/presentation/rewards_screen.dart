import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../l10n/l10n.dart';
import '../../../theme/app_theme.dart';
import '../../../common/widgets/l2e_card.dart';
import '../../../common/widgets/primary_button.dart';
import '../../../common/widgets/empty_state.dart';
import '../../../common/models/reward.dart';
import '../providers/rewards_provider.dart';

class RewardsScreen extends ConsumerWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final rewardsAsync = ref.watch(userRewardsProvider);
    final balanceAsync = ref.watch(tokenBalanceProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.rewards)),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(userRewardsProvider);
          ref.invalidate(tokenBalanceProvider);
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              balanceAsync.when(
                data: (balance) => L2ECard(
                  backgroundColor: theme.colorScheme.primaryContainer,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total Balance',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: theme.colorScheme.onPrimaryContainer,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              Text(
                                '${balance.toStringAsFixed(2)} L2E',
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onPrimaryContainer,
                                ),
                              ),
                            ],
                          ),
                          Icon(
                            Icons.account_balance_wallet,
                            size: 48,
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      PrimaryButton(
                        text: 'Claim Rewards',
                        onPressed: balance >= 10.0
                            ? () => context.push('/claim')
                            : null,
                      ),
                      if (balance < 10.0) ...[
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'Minimum 10 L2E required to claim',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onPrimaryContainer
                                .withOpacity(0.7),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                loading: () => const L2ECard(
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (error, _) =>
                    L2ECard(child: Text('Error loading balance: $error')),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Recent Rewards',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              rewardsAsync.when(
                data: (rewards) => rewards.isEmpty
                    ? EmptyState(
                        icon: Icons.card_giftcard,
                        title: 'No Rewards Yet',
                        message:
                            'Complete quizzes and missions to earn your first rewards!',
                        actionText: 'Start Learning',
                        onAction: () => context.push('/domains'),
                      )
                    : Column(
                        children: rewards
                            .map(
                              (reward) => Padding(
                                padding: const EdgeInsets.only(
                                  bottom: AppSpacing.sm,
                                ),
                                child: L2ECard(
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor:
                                          theme.colorScheme.secondaryContainer,
                                      child: Icon(
                                        _getRewardIcon(reward.sourceType),
                                        color: theme
                                            .colorScheme
                                            .onSecondaryContainer,
                                      ),
                                    ),
                                    title: Text(
                                      _getRewardTitle(reward.sourceType),
                                    ),
                                    subtitle: Text(
                                      _formatDateTime(reward.createdAt),
                                      style: theme.textTheme.bodySmall,
                                    ),
                                    trailing: Text(
                                      '+${reward.tokenAwarded.toStringAsFixed(1)} L2E',
                                      style: theme.textTheme.titleMedium
                                          ?.copyWith(
                                            color: theme.colorScheme.primary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => EmptyState(
                  icon: Icons.error,
                  title: 'Error Loading Rewards',
                  message: 'Failed to load rewards: $error',
                  actionText: 'Retry',
                  onAction: () => ref.invalidate(userRewardsProvider),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getRewardIcon(RewardSourceType sourceType) {
    switch (sourceType) {
      case RewardSourceType.quiz:
        return Icons.quiz;
      case RewardSourceType.mission:
        return Icons.assignment;
      case RewardSourceType.streak:
        return Icons.local_fire_department;
      case RewardSourceType.level:
        return Icons.layers;
      case RewardSourceType.bonus:
        return Icons.card_giftcard;
    }
  }

  String _getRewardTitle(RewardSourceType sourceType) {
    switch (sourceType) {
      case RewardSourceType.quiz:
        return 'Quiz Completed';
      case RewardSourceType.mission:
        return 'Mission Completed';
      case RewardSourceType.streak:
        return 'Streak Bonus';
      case RewardSourceType.level:
        return 'Level Completed';
      case RewardSourceType.bonus:
        return 'Bonus Reward';
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }
}
