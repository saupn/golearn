import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../l10n/l10n.dart';
import '../../../theme/app_theme.dart';
import '../../../common/widgets/l2e_card.dart';
import '../../../common/widgets/streak_widget.dart';
import '../../../common/widgets/primary_button.dart';
import '../../auth/providers/auth_provider.dart';
import '../../learn/providers/domain_provider.dart';
import '../providers/home_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final userAsync = ref.watch(authProvider);
    final enrolledDomainsAsync = ref.watch(enrolledDomainsProvider);
    final tokenBalance = ref.watch(tokenBalanceProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.home),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () => context.push('/notifications'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(enrolledDomainsProvider);
          ref.invalidate(tokenBalanceProvider);
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              userAsync.when(
                data: (user) => user != null
                    ? _buildWelcomeSection(context, user.displayName)
                    : const SizedBox.shrink(),
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),
              const SizedBox(height: AppSpacing.lg),
              userAsync.when(
                data: (user) => user != null
                    ? StreakWidget(
                        currentStreak: user.stats.currentStreakDays,
                        longestStreak: user.stats.longestStreakDays,
                      )
                    : const SizedBox.shrink(),
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),
              const SizedBox(height: AppSpacing.lg),
              tokenBalance.when(
                data: (balance) => _buildTokenBalanceCard(context, balance),
                loading: () => const Card(
                  child: Padding(
                    padding: EdgeInsets.all(AppSpacing.md),
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (_, __) => const SizedBox.shrink(),
              ),
              const SizedBox(height: AppSpacing.lg),
              _buildQuickActions(context),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'My Domains',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              enrolledDomainsAsync.when(
                data: (domains) => domains.isEmpty
                    ? L2ECard(
                        child: Column(
                          children: [
                            const Icon(Icons.school, size: 48),
                            const SizedBox(height: AppSpacing.md),
                            const Text('No domains enrolled yet'),
                            const SizedBox(height: AppSpacing.md),
                            PrimaryButton(
                              text: 'Browse Domains',
                              onPressed: () => context.push('/domains'),
                            ),
                          ],
                        ),
                      )
                    : Column(
                        children: domains
                            .map(
                              (domain) => L2ECard(
                                onTap: () =>
                                    context.push('/domain/${domain.id}'),
                                child: ListTile(
                                  leading: domain.thumbnailUrl != null
                                      ? Image.network(
                                          domain.thumbnailUrl!,
                                          width: 48,
                                          height: 48,
                                          fit: BoxFit.cover,
                                        )
                                      : const Icon(Icons.school, size: 48),
                                  title: Text(domain.name),
                                  subtitle: Text(domain.description),
                                  trailing: const Icon(Icons.arrow_forward_ios),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Text('Error: $error'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context, String displayName) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return L2ECard(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${l10n.welcome}, $displayName!',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Ready to learn something new today?',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.waving_hand, size: 32, color: theme.colorScheme.primary),
        ],
      ),
    );
  }

  Widget _buildTokenBalanceCard(BuildContext context, double balance) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return L2ECard(
      backgroundColor: theme.colorScheme.primaryContainer,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.tokenBalance,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                '${balance.toStringAsFixed(2)} L2E',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
            ],
          ),
          Icon(
            Icons.account_balance_wallet,
            size: 32,
            color: theme.colorScheme.onPrimaryContainer,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Row(
      children: [
        Expanded(
          child: PrimaryButton(
            text: l10n.continueLesson,
            icon: Icons.play_arrow,
            onPressed: () => context.push('/domains'),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => context.push('/rewards'),
            icon: const Icon(Icons.card_giftcard),
            label: Text(l10n.claimRewards),
          ),
        ),
      ],
    );
  }
}
