import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../l10n/l10n.dart';
import '../../../theme/app_theme.dart';
import '../../../common/widgets/l2e_card.dart';
import '../../../common/widgets/metric_chip.dart';
import '../../../common/widgets/empty_state.dart';
import '../providers/level_provider.dart';

class LevelsScreen extends ConsumerWidget {
  final String domainId;

  const LevelsScreen({super.key, required this.domainId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final levelsAsync = ref.watch(levelsByDomainProvider(domainId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Levels'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(levelsByDomainProvider(domainId));
        },
        child: levelsAsync.when(
          data: (levels) => levels.isEmpty
              ? EmptyState(
                  icon: Icons.layers,
                  title: 'No Levels Available',
                  message: 'This domain doesn\'t have any levels yet.',
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  itemCount: levels.length,
                  itemBuilder: (context, index) {
                    final level = levels[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: L2ECard(
                        onTap: level.status != LevelStatus.locked
                            ? () => context.push('/level/${level.id}')
                            : null,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    'Level ${level.levelNumber}: ${level.title}',
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                MetricChip.fromLevelStatus(level.status),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              'Target Income: \$${level.incomeTargetUsd.toStringAsFixed(0)}',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              'Base Reward: ${level.rewardRule.baseToken} L2E tokens',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            if (level.status == LevelStatus.locked) ...[
                              const SizedBox(height: AppSpacing.sm),
                              Row(
                                children: [
                                  Icon(
                                    Icons.lock,
                                    size: 16,
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                                  const SizedBox(width: AppSpacing.xs),
                                  Text(
                                    level.gatingRule.requirePrevLevel
                                        ? 'Complete previous level to unlock'
                                        : 'Requirements not met',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => EmptyState(
            icon: Icons.error,
            title: 'Error Loading Levels',
            message: 'Failed to load levels: $error',
            actionText: 'Retry',
            onAction: () => ref.invalidate(levelsByDomainProvider(domainId)),
          ),
        ),
      ),
    );
  }
}
