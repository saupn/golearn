import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../l10n/l10n.dart';

class StreakWidget extends StatelessWidget {
  final int currentStreak;
  final int longestStreak;
  final int nextBonusAt;

  const StreakWidget({
    super.key,
    required this.currentStreak,
    required this.longestStreak,
    this.nextBonusAt = 10,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.local_fire_department,
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Streak',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _StreakStat(
                  label: l10n.currentStreak,
                  value: '$currentStreak days',
                  color: theme.colorScheme.primary,
                ),
                _StreakStat(
                  label: l10n.longestStreak,
                  value: '$longestStreak days',
                  color: theme.colorScheme.secondary,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            LinearProgressIndicator(
              value: currentStreak / nextBonusAt,
              backgroundColor: theme.colorScheme.surfaceVariant,
              valueColor: AlwaysStoppedAnimation<Color>(
                theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Next bonus at $nextBonusAt days',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StreakStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StreakStat({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
