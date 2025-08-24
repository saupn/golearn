import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../l10n/l10n.dart';
import '../../../theme/app_theme.dart';
import '../../../common/widgets/l2e_card.dart';
import '../../../common/widgets/metric_chip.dart';
import '../../../common/widgets/empty_state.dart';
import '../providers/module_provider.dart';
import '../providers/lesson_provider.dart';

class ModuleDetailScreen extends ConsumerWidget {
  final String moduleId;

  const ModuleDetailScreen({super.key, required this.moduleId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final moduleAsync = ref.watch(moduleProvider(moduleId));
    final lessonsAsync = ref.watch(lessonsByModuleProvider(moduleId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Module'),
      ),
      body: moduleAsync.when(
        data: (module) => module == null
            ? const EmptyState(
                icon: Icons.folder_off,
                title: 'Module Not Found',
                message: 'The requested module could not be found.',
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
                              Expanded(
                                child: Text(
                                  module.name,
                                  style: theme.textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              MetricChip.fromModuleStatus(module.status),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            module.description,
                            style: theme.textTheme.bodyLarge,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Row(
                            children: [
                              Icon(
                                Icons.category,
                                size: 16,
                                color: theme.colorScheme.primary,
                              ),
                              const SizedBox(width: AppSpacing.xs),
                              Text(
                                'Type: ${module.strandType}',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'Lessons',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    lessonsAsync.when(
                      data: (lessons) => lessons.isEmpty
                          ? EmptyState(
                              icon: Icons.school,
                              title: 'No Lessons Available',
                              message: 'This module doesn\'t have any lessons yet.',
                            )
                          : Column(
                              children: lessons.map((lesson) => Padding(
                                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                                child: L2ECard(
                                  onTap: () => context.push('/lesson/${lesson.id}'),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: theme.colorScheme.secondaryContainer,
                                      child: Icon(
                                        lesson.contentType == 'video'
                                            ? Icons.play_arrow
                                            : Icons.article,
                                        color: theme.colorScheme.onSecondaryContainer,
                                      ),
                                    ),
                                    title: Text(
                                      lesson.title,
                                      style: theme.textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('${lesson.estimatedMinutes} min'),
                                        if (lesson.hasQuiz)
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.quiz,
                                                size: 14,
                                                color: theme.colorScheme.secondary,
                                              ),
                                              const SizedBox(width: AppSpacing.xs),
                                              Text(
                                                'Has Quiz',
                                                style: theme.textTheme.bodySmall?.copyWith(
                                                  color: theme.colorScheme.secondary,
                                                ),
                                              ),
                                            ],
                                          ),
                                      ],
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        MetricChip.fromLessonStatus(lesson.status),
                                        const SizedBox(width: AppSpacing.sm),
                                        const Icon(Icons.arrow_forward_ios),
                                      ],
                                    ),
                                  ),
                                ),
                              )).toList(),
                            ),
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (error, _) => EmptyState(
                        icon: Icons.error,
                        title: 'Error Loading Lessons',
                        message: 'Failed to load lessons: $error',
                        actionText: 'Retry',
                        onAction: () => ref.invalidate(lessonsByModuleProvider(moduleId)),
                      ),
                    ),
                  ],
                ),
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => EmptyState(
          icon: Icons.error,
          title: 'Error Loading Module',
          message: 'Failed to load module: $error',
          actionText: 'Retry',
          onAction: () => ref.invalidate(moduleProvider(moduleId)),
        ),
      ),
    );
  }
}
