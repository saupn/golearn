import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../l10n/l10n.dart';
import '../../../theme/app_theme.dart';
import '../../../common/widgets/l2e_card.dart';
import '../../../common/widgets/primary_button.dart';
import '../../../common/widgets/empty_state.dart';
import '../providers/level_provider.dart';
import '../providers/module_provider.dart';

class LevelDetailScreen extends ConsumerWidget {
  final String levelId;

  const LevelDetailScreen({super.key, required this.levelId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final levelAsync = ref.watch(levelProvider(levelId));
    final modulesAsync = ref.watch(modulesByLevelProvider(levelId));

    return Scaffold(
      body: levelAsync.when(
        data: (level) => CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 200,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text('Level ${level?.levelNumber ?? 0}'),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        theme.colorScheme.primary,
                        theme.colorScheme.primaryContainer,
                      ],
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),
                        Text(
                          level?.title ?? 'Unknown Level',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            color: theme.colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'Target: \$${level?.incomeTargetUsd.toStringAsFixed(0) ?? '0'}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onPrimary.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    L2ECard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Level Overview',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Row(
                            children: [
                              Icon(
                                Icons.emoji_events,
                                color: theme.colorScheme.primary,
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Text(
                                'Reward: ${level?.rewardRule.baseToken ?? 0} L2E tokens',
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Row(
                            children: [
                              Icon(
                                Icons.quiz,
                                color: theme.colorScheme.secondary,
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Text(
                                'Min Quiz Score: ${((level?.gatingRule.minQuizScore ?? 0) * 100).toInt()}%',
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Row(
                            children: [
                              Icon(
                                Icons.assignment,
                                color: theme.colorScheme.tertiary,
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Text(
                                'Required Missions: ${level?.gatingRule.requiredMissions ?? 0}',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'Modules',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],
                ),
              ),
            ),
            modulesAsync.when(
              data: (modules) => modules.isEmpty
                  ? const SliverToBoxAdapter(
                      child: EmptyState(
                        icon: Icons.folder_open,
                        title: 'No Modules Available',
                        message: 'This level doesn\'t have any modules yet.',
                      ),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final module = modules[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.sm,
                          ),
                          child: L2ECard(
                            onTap: () => context.push('/module/${module.id}'),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor:
                                    theme.colorScheme.secondaryContainer,
                                child: Text(
                                  '${module.indexInLevel + 1}',
                                  style: TextStyle(
                                    color:
                                        theme.colorScheme.onSecondaryContainer,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              title: Text(
                                module.name,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(module.description),
                                  const SizedBox(height: AppSpacing.xs),
                                  Text(
                                    'Type: ${module.strandType}',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: const Icon(Icons.arrow_forward_ios),
                            ),
                          ),
                        );
                      }, childCount: modules.length),
                    ),
              loading: () => const SliverToBoxAdapter(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (error, _) => SliverToBoxAdapter(
                child: EmptyState(
                  icon: Icons.error,
                  title: 'Error Loading Modules',
                  message: 'Failed to load modules: $error',
                  actionText: 'Retry',
                  onAction: () =>
                      ref.invalidate(modulesByLevelProvider(levelId)),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),
          ],
        ),
        loading: () =>
            const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (error, _) => Scaffold(
          appBar: AppBar(title: const Text('Level')),
          body: EmptyState(
            icon: Icons.error,
            title: 'Error Loading Level',
            message: 'Failed to load level: $error',
            actionText: 'Retry',
            onAction: () => ref.invalidate(levelProvider(levelId)),
          ),
        ),
      ),
    );
  }
}
