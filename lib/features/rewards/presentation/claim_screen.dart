import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../l10n/l10n.dart';
import '../../../theme/app_theme.dart';
import '../../../common/widgets/l2e_card.dart';
import '../../../common/widgets/primary_button.dart';
import '../providers/claim_provider.dart';

class ClaimScreen extends ConsumerWidget {
  const ClaimScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final claimState = ref.watch(claimProvider);
    final balanceAsync = ref.watch(availableBalanceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Claim Rewards'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            L2ECard(
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Available to Claim',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  balanceAsync.when(
                    data: (balance) => Text(
                      '${balance.toStringAsFixed(2)} L2E',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                    loading: () => const CircularProgressIndicator(),
                    error: (error, _) => Text('Error: $error'),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Minimum claim amount: 10 L2E',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer.withOpacity(0.7),
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
                    'Claim Process',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _buildProcessStep(
                    context,
                    1,
                    'Request Claim',
                    'Submit your claim request',
                    claimState.step >= 1,
                  ),
                  _buildProcessStep(
                    context,
                    2,
                    'Processing',
                    'Your claim is being processed',
                    claimState.step >= 2,
                  ),
                  _buildProcessStep(
                    context,
                    3,
                    'Confirmed',
                    'Tokens transferred to your wallet',
                    claimState.step >= 3,
                  ),
                ],
              ),
            ),
            const Spacer(),
            if (claimState.isProcessing)
              Column(
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    claimState.statusMessage,
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              )
            else if (claimState.isCompleted)
              Column(
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 64,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Claim Successful!',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  OutlinedButton(
                    onPressed: () => context.pop(),
                    child: const Text('Back to Rewards'),
                  ),
                ],
              )
            else
              balanceAsync.when(
                data: (balance) => PrimaryButton(
                  text: 'Claim ${balance.toStringAsFixed(2)} L2E',
                  onPressed: balance >= 10.0
                      ? () => ref.read(claimProvider.notifier).startClaim(balance)
                      : null,
                ),
                loading: () => const PrimaryButton(
                  text: 'Loading...',
                  onPressed: null,
                ),
                error: (_, __) => const PrimaryButton(
                  text: 'Error',
                  onPressed: null,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildProcessStep(
    BuildContext context,
    int stepNumber,
    String title,
    String description,
    bool isCompleted,
  ) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isCompleted
                  ? theme.colorScheme.primary
                  : theme.colorScheme.surfaceVariant,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: isCompleted
                  ? Icon(
                      Icons.check,
                      color: theme.colorScheme.onPrimary,
                      size: 16,
                    )
                  : Text(
                      stepNumber.toString(),
                      style: TextStyle(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isCompleted
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface,
                  ),
                ),
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
