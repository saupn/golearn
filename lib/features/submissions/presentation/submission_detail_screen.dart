import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../l10n/l10n.dart';
import '../../../theme/app_theme.dart';
import '../../../common/widgets/l2e_card.dart';
import '../../../common/widgets/primary_button.dart';
import '../../../common/widgets/empty_state.dart';
import '../../../common/models/submission.dart';
import '../providers/submission_provider.dart';

class SubmissionDetailScreen extends ConsumerWidget {
  final String submissionId;

  const SubmissionDetailScreen({super.key, required this.submissionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final submissionAsync = ref.watch(submissionProvider(submissionId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Submission'),
      ),
      body: submissionAsync.when(
        data: (submission) => submission == null
            ? const EmptyState(
                icon: Icons.assignment_outlined,
                title: 'Submission Not Found',
                message: 'The requested submission could not be found.',
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    L2ECard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Submission Status',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              _buildStatusChip(theme, submission.status),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            'Submitted: ${_formatDateTime(submission.createdAt)}',
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
                            'Submission Details',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Row(
                            children: [
                              Icon(
                                _getSubmissionTypeIcon(submission.type),
                                color: theme.colorScheme.primary,
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Text(
                                'Type: ${submission.type}',
                                style: theme.textTheme.bodyMedium,
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Container(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceVariant,
                              borderRadius: BorderRadius.circular(AppRadius.md),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Submitted Content:',
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.sm),
                                Text(
                                  submission.payloadRaw,
                                  style: theme.textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    if (submission.status == SubmissionStatus.pending ||
                        submission.status == SubmissionStatus.processing) ...[
                      L2ECard(
                        backgroundColor: theme.colorScheme.secondaryContainer,
                        child: Column(
                          children: [
                            Icon(
                              Icons.hourglass_empty,
                              size: 48,
                              color: theme.colorScheme.onSecondaryContainer,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Text(
                              submission.status == SubmissionStatus.pending
                                  ? 'Waiting for Evaluation'
                                  : 'AI Evaluation in Progress',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSecondaryContainer,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              'Your submission is being processed. This may take a few minutes.',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSecondaryContainer,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            PrimaryButton(
                              text: 'Run AI Evaluation (Mock)',
                              onPressed: () => ref.read(submissionProvider(submissionId).notifier)
                                  .simulateEvaluation(),
                            ),
                          ],
                        ),
                      ),
                    ] else if (submission.status == SubmissionStatus.evaluated) ...[
                      Consumer(
                        builder: (context, ref, child) {
                          final evaluationAsync = ref.watch(evaluationBySubmissionProvider(submissionId));
                          return evaluationAsync.when(
                            data: (evaluation) => evaluation == null
                                ? const EmptyState(
                                    icon: Icons.assessment,
                                    title: 'No Evaluation Available',
                                    message: 'Evaluation results are not available yet.',
                                  )
                                : _buildEvaluationResults(theme, evaluation),
                            loading: () => const Center(child: CircularProgressIndicator()),
                            error: (error, _) => EmptyState(
                              icon: Icons.error,
                              title: 'Error Loading Evaluation',
                              message: 'Failed to load evaluation: $error',
                            ),
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => EmptyState(
          icon: Icons.error,
          title: 'Error Loading Submission',
          message: 'Failed to load submission: $error',
          actionText: 'Retry',
          onAction: () => ref.invalidate(submissionProvider(submissionId)),
        ),
      ),
    );
  }

  Widget _buildStatusChip(ThemeData theme, SubmissionStatus status) {
    Color backgroundColor;
    Color textColor;
    IconData icon;

    switch (status) {
      case SubmissionStatus.pending:
        backgroundColor = Colors.orange.withOpacity(0.2);
        textColor = Colors.orange;
        icon = Icons.schedule;
        break;
      case SubmissionStatus.processing:
        backgroundColor = Colors.blue.withOpacity(0.2);
        textColor = Colors.blue;
        icon = Icons.sync;
        break;
      case SubmissionStatus.evaluated:
        backgroundColor = Colors.green.withOpacity(0.2);
        textColor = Colors.green;
        icon = Icons.check_circle;
        break;
      case SubmissionStatus.reviewRequired:
        backgroundColor = Colors.purple.withOpacity(0.2);
        textColor = Colors.purple;
        icon = Icons.rate_review;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: textColor),
          const SizedBox(width: 4),
          Text(
            status.name.toUpperCase(),
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEvaluationResults(ThemeData theme, evaluation) {
    return Column(
      children: [
        L2ECard(
          backgroundColor: evaluation.passed
              ? Colors.green.withOpacity(0.1)
              : Colors.red.withOpacity(0.1),
          child: Column(
            children: [
              Icon(
                evaluation.passed ? Icons.check_circle : Icons.cancel,
                size: 64,
                color: evaluation.passed ? Colors.green : Colors.red,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                evaluation.passed ? 'Evaluation Passed!' : 'Evaluation Failed',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: evaluation.passed ? Colors.green : Colors.red,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Total Score: ${(evaluation.totalScore * 100).toInt()}%',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
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
                'Detailed Evaluation',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              ...evaluation.perCriteria.map((criteria) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          criteria.label,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${(criteria.score * 100).toInt()}%',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: criteria.score >= 0.7 ? Colors.green : Colors.red,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    LinearProgressIndicator(
                      value: criteria.score,
                      backgroundColor: theme.colorScheme.surfaceVariant,
                      color: criteria.score >= 0.7 ? Colors.green : Colors.red,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      criteria.comment,
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              )).toList(),
            ],
          ),
        ),
        if (evaluation.flags.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.lg),
          L2ECard(
            backgroundColor: Colors.orange.withOpacity(0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.flag, color: Colors.orange),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      'Flags Detected',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                ...evaluation.flags.map((flag) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Row(
                    children: [
                      Icon(Icons.warning, size: 16, color: Colors.orange),
                      const SizedBox(width: AppSpacing.sm),
                      Text(flag, style: theme.textTheme.bodyMedium),
                    ],
                  ),
                )).toList(),
              ],
            ),
          ),
        ],
      ],
    );
  }

  IconData _getSubmissionTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'text':
        return Icons.text_fields;
      case 'image':
        return Icons.image;
      case 'video':
        return Icons.videocam;
      case 'link':
        return Icons.link;
      case 'file':
        return Icons.attach_file;
      default:
        return Icons.description;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} at ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
