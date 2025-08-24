import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../l10n/l10n.dart';
import '../../../theme/app_theme.dart';
import '../../../common/widgets/l2e_card.dart';
import '../../../common/widgets/primary_button.dart';
import '../../../common/widgets/empty_state.dart';
import '../providers/domain_provider.dart';
import '../providers/level_provider.dart';

class DomainDetailScreen extends ConsumerWidget {
  final String domainId;

  const DomainDetailScreen({super.key, required this.domainId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final domainAsync = ref.watch(domainProvider(domainId));
    final nextLevelAsync = ref.watch(nextLevelProvider(domainId));

    return Scaffold(
      body: domainAsync.when(
        data: (domain) => domain == null
            ? EmptyState(
                icon: Icons.error,
                title: 'Domain Not Found',
                message: 'The requested domain could not be found.',
                actionText: 'Go Back',
                onAction: () => context.pop(),
              )
            : CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 200,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      title: Text(domain.name),
                      background: domain.thumbnailUrl != null
                          ? Image.network(
                              domain.thumbnailUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                color: Theme.of(context).colorScheme.surfaceVariant,
                                child: const Icon(Icons.school, size: 64),
                              ),
                            )
                          : Container(
                              color: Theme.of(context).colorScheme.surfaceVariant,
                              child: const Icon(Icons.school, size: 64),
                            ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        L2ECard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'About',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              Text(domain.description),
                              const SizedBox(height: AppSpacing.md),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  _buildMetric(
                                    context,
                                    'Levels',
                                    domain.metrics.levelCount.toString(),
                                    Icons.layers,
                                  ),
                                  _buildMetric(
                                    context,
                                    'Modules',
                                    domain.metrics.moduleCount.toString(),
                                    Icons.book,
                                  ),
                                  _buildMetric(
                                    context,
                                    'Lessons',
                                    domain.metrics.lessonCount.toString(),
                                    Icons.play_lesson,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        nextLevelAsync.when(
                          data: (nextLevel) => nextLevel != null
                              ? L2ECard(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Next Level',
                                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: AppSpacing.sm),
                                      Text(
                                        'Level ${nextLevel.levelNumber}: ${nextLevel.title}',
                                        style: Theme.of(context).textTheme.titleSmall,
                                      ),
                                      const SizedBox(height: AppSpacing.sm),
                                      Text(
                                        'Target Income: \$${nextLevel.incomeTargetUsd.toStringAsFixed(0)}',
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                      const SizedBox(height: AppSpacing.md),
                                      PrimaryButton(
                                        text: 'Start Level',
                                        onPressed: () => context.push('/level/${nextLevel.id}'),
                                      ),
                                    ],
                                  ),
                                )
                              : L2ECard(
                                  child: Column(
                                    children: [
                                      const Icon(Icons.check_circle, size: 48),
                                      const SizedBox(height: AppSpacing.md),
                                      const Text('All levels completed!'),
                                      const SizedBox(height: AppSpacing.md),
                                      OutlinedButton(
                                        onPressed: () => context.push('/domain/$domainId/levels'),
                                        child: const Text('View All Levels'),
                                      ),
                                    ],
                                  ),
                                ),
                          loading: () => const L2ECard(
                            child: Center(child: CircularProgressIndicator()),
                          ),
                          error: (error, _) => L2ECard(
                            child: Text('Error loading next level: $error'),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        PrimaryButton(
                          text: 'View All Levels',
                          icon: Icons.list,
                          onPressed: () => context.push('/domain/$domainId/levels'),
                        ),
                      ]),
                    ),
                  ),
                ],
              ),
        loading: () => const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
        error: (error, stack) => Scaffold(
          appBar: AppBar(),
          body: EmptyState(
            icon: Icons.error,
            title: 'Error Loading Domain',
            message: 'Failed to load domain: $error',
            actionText: 'Go Back',
            onAction: () => context.pop(),
          ),
        ),
      ),
    );
  }

  Widget _buildMetric(BuildContext context, String label, String value, IconData icon) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        Icon(icon, color: theme.colorScheme.primary),
        const SizedBox(height: AppSpacing.xs),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
