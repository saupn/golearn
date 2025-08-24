import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../l10n/l10n.dart';
import '../../../theme/app_theme.dart';
import '../../../common/widgets/l2e_card.dart';
import '../../../common/widgets/primary_button.dart';
import '../../../common/widgets/empty_state.dart';
import '../providers/lesson_provider.dart';

class LessonDetailScreen extends ConsumerWidget {
  final String lessonId;

  const LessonDetailScreen({super.key, required this.lessonId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final lessonAsync = ref.watch(lessonProvider(lessonId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lesson'),
      ),
      body: lessonAsync.when(
        data: (lesson) => lesson == null
            ? const EmptyState(
                icon: Icons.school_outlined,
                title: 'Lesson Not Found',
                message: 'The requested lesson could not be found.',
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
                          Text(
                            lesson.title,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Row(
                            children: [
                              Icon(
                                lesson.contentType == 'video'
                                    ? Icons.play_circle
                                    : Icons.article,
                                color: theme.colorScheme.primary,
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Text(
                                '${lesson.estimatedMinutes} minutes',
                                style: theme.textTheme.bodyMedium,
                              ),
                              const Spacer(),
                              if (lesson.hasQuiz)
                                Row(
                                  children: [
                                    Icon(
                                      Icons.quiz,
                                      size: 16,
                                      color: theme.colorScheme.secondary,
                                    ),
                                    const SizedBox(width: AppSpacing.xs),
                                    Text(
                                      'Quiz Available',
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        color: theme.colorScheme.secondary,
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    if (lesson.contentType == 'video') ...[
                      L2ECard(
                        child: Column(
                          children: [
                            Container(
                              height: 200,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surfaceVariant,
                                borderRadius: BorderRadius.circular(AppRadius.md),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.play_circle_filled,
                                    size: 64,
                                    color: theme.colorScheme.primary,
                                  ),
                                  const SizedBox(height: AppSpacing.md),
                                  Text(
                                    'Video Content',
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Mock video player',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            LinearProgressIndicator(
                              value: 0.3,
                              backgroundColor: theme.colorScheme.surfaceVariant,
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              'Progress: 30%',
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ] else ...[
                      L2ECard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.article,
                                  color: theme.colorScheme.primary,
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                Text(
                                  'Reading Material',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Text(
                              'This is mock reading content for the lesson. In a real implementation, this would contain the actual lesson content, images, and interactive elements.',
                              style: theme.textTheme.bodyLarge,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Text(
                              'Key Learning Points:',
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            ...List.generate(3, (index) => Padding(
                              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('• ', style: theme.textTheme.bodyMedium),
                                  Expanded(
                                    child: Text(
                                      'Learning point ${index + 1} - Important concept to understand',
                                      style: theme.textTheme.bodyMedium,
                                    ),
                                  ),
                                ],
                              ),
                            )),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: AppSpacing.lg),
                    if (lesson.hasQuiz) ...[
                      PrimaryButton(
                        text: 'Take Quiz',
                        onPressed: () => context.push('/quiz/${lesson.id}'),
                      ),
                      const SizedBox(height: AppSpacing.md),
                    ],
                    OutlinedButton(
                      onPressed: () => context.push('/mission/${lesson.id}'),
                      child: const Text('View Missions'),
                    ),
                  ],
                ),
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => EmptyState(
          icon: Icons.error,
          title: 'Error Loading Lesson',
          message: 'Failed to load lesson: $error',
          actionText: 'Retry',
          onAction: () => ref.invalidate(lessonProvider(lessonId)),
        ),
      ),
    );
  }
}
