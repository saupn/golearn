import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../l10n/l10n.dart';
import '../../../theme/app_theme.dart';
import '../../../common/widgets/l2e_card.dart';
import '../../../common/widgets/primary_button.dart';
import '../../../common/widgets/empty_state.dart';
import '../../../common/models/mission.dart';
import '../../../common/models/submission.dart';
import '../providers/mission_provider.dart';

class MissionDetailScreen extends ConsumerWidget {
  final String missionId;

  const MissionDetailScreen({super.key, required this.missionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final missionAsync = ref.watch(missionProvider(missionId));

    return Scaffold(
      appBar: AppBar(title: const Text('Mission')),
      body: missionAsync.when(
        data: (mission) => mission == null
            ? const EmptyState(
                icon: Icons.assignment_outlined,
                title: 'Mission Not Found',
                message: 'The requested mission could not be found.',
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
                            children: [
                              Icon(
                                Icons.assignment,
                                color: theme.colorScheme.primary,
                                size: 32,
                              ),
                              const SizedBox(width: AppSpacing.md),
                              Expanded(
                                child: Text(
                                  mission.title,
                                  style: theme.textTheme.headlineSmall
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          Text(
                            'Mission Brief',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            mission.description,
                            style: theme.textTheme.bodyLarge,
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
                            'Submission Requirements',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Row(
                            children: [
                              Icon(
                                _getProofTypeIcon(mission.proofType),
                                color: theme.colorScheme.secondary,
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Text(
                                'Proof Type: ${_getProofTypeLabel(mission.proofType)}',
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
                                  'Acceptance Criteria:',
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.sm),
                                Text(
                                  mission.acceptanceRule,
                                  style: theme.textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    L2ECard(
                      backgroundColor: theme.colorScheme.primaryContainer,
                      child: Row(
                        children: [
                          Icon(
                            Icons.emoji_events,
                            color: theme.colorScheme.onPrimaryContainer,
                            size: 32,
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Reward',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.onPrimaryContainer,
                                  ),
                                ),
                                Text(
                                  '${mission.rewardBaseToken} L2E Tokens',
                                  style: theme.textTheme.headlineSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: theme
                                            .colorScheme
                                            .onPrimaryContainer,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    PrimaryButton(
                      text: 'Submit Proof',
                      onPressed: () =>
                          _showSubmissionBottomSheet(context, mission),
                    ),
                  ],
                ),
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => EmptyState(
          icon: Icons.error,
          title: 'Error Loading Mission',
          message: 'Failed to load mission: $error',
          actionText: 'Retry',
          onAction: () => ref.invalidate(missionProvider(missionId)),
        ),
      ),
    );
  }

  IconData _getProofTypeIcon(ProofType proofType) {
    switch (proofType) {
      case ProofType.text:
        return Icons.text_fields;
      case ProofType.image:
        return Icons.image;
      case ProofType.link:
        return Icons.link;
      case ProofType.document:
        return Icons.attach_file;
      default:
        return Icons.description;
    }
  }

  String _getProofTypeLabel(ProofType proofType) {
    switch (proofType) {
      case ProofType.text:
        return 'Text Description';
      case ProofType.image:
        return 'Image Upload';
      case ProofType.link:
        return 'Web Link';
      case ProofType.document:
        return 'File Upload';
      default:
        return proofType.name;
    }
  }

  void _showSubmissionBottomSheet(BuildContext context, mission) {
    final theme = Theme.of(context);
    final textController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Submit Proof',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Proof Type: ${_getProofTypeLabel(mission.proofType)}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              if (mission.proofType == ProofType.text) ...[
                TextField(
                  controller: textController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    hintText: 'Enter your proof description...',
                    border: OutlineInputBorder(),
                  ),
                ),
              ] else ...[
                Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.colorScheme.outline),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _getProofTypeIcon(mission.proofType),
                        size: 48,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Tap to upload ${mission.proofType.name}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                TextField(
                  controller: textController,
                  decoration: const InputDecoration(
                    hintText: 'Add a note (optional)...',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () =>
                          _submitProof(context, mission, textController.text),
                      child: const Text('Submit'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitProof(BuildContext context, mission, String proofText) {
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Proof submitted successfully! Redirecting to submission details...',
        ),
        backgroundColor: Colors.green,
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      context.push('/submission/mock-submission-id');
    });
  }
}
