import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../l10n/l10n.dart';
import '../../../theme/app_theme.dart';
import '../../../common/widgets/l2e_card.dart';
import '../../../common/widgets/empty_state.dart';
import '../providers/domain_provider.dart';

class DomainsScreen extends ConsumerWidget {
  const DomainsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final domainsAsync = ref.watch(domainsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.domains),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(domainsProvider);
        },
        child: domainsAsync.when(
          data: (domains) => domains.isEmpty
              ? EmptyState(
                  icon: Icons.school,
                  title: 'No Domains Available',
                  message: 'Check back later for new learning domains.',
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: AppSpacing.md,
                    mainAxisSpacing: AppSpacing.md,
                  ),
                  itemCount: domains.length,
                  itemBuilder: (context, index) {
                    final domain = domains[index];
                    return L2ECard(
                      onTap: () => context.push('/domain/${domain.id}'),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (domain.thumbnailUrl != null)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(AppRadius.sm),
                              child: Image.network(
                                domain.thumbnailUrl!,
                                height: 100,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                  height: 100,
                                  color: Theme.of(context).colorScheme.surfaceVariant,
                                  child: const Icon(Icons.school, size: 48),
                                ),
                              ),
                            )
                          else
                            Container(
                              height: 100,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surfaceVariant,
                                borderRadius: BorderRadius.circular(AppRadius.sm),
                              ),
                              child: const Icon(Icons.school, size: 48),
                            ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            domain.name,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            domain.description,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${domain.metrics.levelCount} levels',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              const Icon(Icons.arrow_forward_ios, size: 16),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => EmptyState(
            icon: Icons.error,
            title: 'Error Loading Domains',
            message: 'Failed to load domains: $error',
            actionText: 'Retry',
            onAction: () => ref.invalidate(domainsProvider),
          ),
        ),
      ),
    );
  }
}
