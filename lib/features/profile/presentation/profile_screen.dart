import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../l10n/l10n.dart';
import '../../../theme/app_theme.dart';
import '../../../common/widgets/l2e_card.dart';
import '../../../common/widgets/primary_button.dart';
import '../../auth/providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final userAsync = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profile),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _showSettingsDialog(context, ref),
          ),
        ],
      ),
      body: userAsync.when(
        data: (user) => user == null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.person_off, size: 64),
                    const SizedBox(height: AppSpacing.md),
                    const Text('Not signed in'),
                    const SizedBox(height: AppSpacing.md),
                    PrimaryButton(
                      text: 'Sign In',
                      onPressed: () => context.go('/auth'),
                    ),
                  ],
                ),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  children: [
                    L2ECard(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 48,
                            backgroundImage: user.avatarUrl != null
                                ? NetworkImage(user.avatarUrl!)
                                : null,
                            child: user.avatarUrl == null
                                ? Text(
                                    user.displayName.isNotEmpty
                                        ? user.displayName[0].toUpperCase()
                                        : 'U',
                                    style: theme.textTheme.headlineMedium,
                                  )
                                : null,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            user.displayName,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            user.email,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    L2ECard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Statistics',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildStat(
                                context,
                                'XP',
                                user.stats.xp.toString(),
                                Icons.star,
                              ),
                              _buildStat(
                                context,
                                'Current Streak',
                                '${user.stats.currentStreakDays} days',
                                Icons.local_fire_department,
                              ),
                              _buildStat(
                                context,
                                'Tokens',
                                user.stats.tokenOffchain.toStringAsFixed(1),
                                Icons.monetization_on,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    L2ECard(
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.language),
                            title: const Text('Language'),
                            subtitle: Text(
                              user.preferredLanguage == 'vi'
                                  ? 'Tiếng Việt'
                                  : 'English',
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios),
                            onTap: () =>
                                _showLanguageDialog(context, ref, user),
                          ),
                          const Divider(),
                          ListTile(
                            leading: const Icon(Icons.notifications),
                            title: const Text('Notifications'),
                            trailing: const Icon(Icons.arrow_forward_ios),
                            onTap: () => _showNotificationSettings(context),
                          ),
                          const Divider(),
                          ListTile(
                            leading: const Icon(Icons.account_balance_wallet),
                            title: const Text('Wallet'),
                            subtitle: user.wallets.polygonAddress != null
                                ? Text(
                                    '${user.wallets.polygonAddress!.substring(0, 6)}...${user.wallets.polygonAddress!.substring(user.wallets.polygonAddress!.length - 4)}',
                                  )
                                : const Text('No wallet connected'),
                            trailing: const Icon(Icons.arrow_forward_ios),
                            onTap: () => _showWalletInfo(
                              context,
                              user.wallets.polygonAddress,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    DestructiveButton(
                      text: 'Sign Out',
                      onPressed: () => _signOut(context, ref),
                    ),
                  ],
                ),
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 64),
              const SizedBox(height: AppSpacing.md),
              Text('Error: $error'),
              const SizedBox(height: AppSpacing.md),
              PrimaryButton(
                text: 'Retry',
                onPressed: () => ref.invalidate(authProvider),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStat(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Icon(icon, color: theme.colorScheme.primary, size: 32),
        const SizedBox(height: AppSpacing.sm),
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

  void _showSettingsDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Settings'),
        content: const Text('Settings functionality coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, WidgetRef ref, user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('English'),
              value: 'en',
              groupValue: user.preferredLanguage,
              onChanged: (value) {
                if (value != null) {
                  ref
                      .read(authProvider.notifier)
                      .updateUser(user.copyWith(preferredLanguage: value));
                  Navigator.of(context).pop();
                }
              },
            ),
            RadioListTile<String>(
              title: const Text('Tiếng Việt'),
              value: 'vi',
              groupValue: user.preferredLanguage,
              onChanged: (value) {
                if (value != null) {
                  ref
                      .read(authProvider.notifier)
                      .updateUser(user.copyWith(preferredLanguage: value));
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showNotificationSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notification Settings'),
        content: const Text('Notification settings coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showWalletInfo(BuildContext context, String? address) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Wallet Information'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Polygon Address:'),
            const SizedBox(height: AppSpacing.sm),
            SelectableText(
              address ?? 'No wallet connected',
              style: const TextStyle(fontFamily: 'monospace'),
            ),
            const SizedBox(height: AppSpacing.md),
            const Text(
              'This is a mock wallet address for demonstration purposes.',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _signOut(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(authProvider.notifier).signOut();
              Navigator.of(context).pop();
              context.go('/auth');
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}
