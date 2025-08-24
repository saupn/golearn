import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../l10n/l10n.dart';
import '../../../theme/app_theme.dart';
import '../../../common/widgets/l2e_card.dart';
import '../../../common/widgets/primary_button.dart';
import '../../../common/widgets/empty_state.dart';
import '../providers/quiz_provider.dart';

class QuizScreen extends ConsumerStatefulWidget {
  final String lessonId;

  const QuizScreen({super.key, required this.lessonId});

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  int currentQuestionIndex = 0;
  Map<int, List<int>> selectedAnswers = {};
  bool isCompleted = false;
  double? finalScore;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final quizAsync = ref.watch(quizByLessonProvider(widget.lessonId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz'),
        actions: [
          if (!isCompleted)
            TextButton(
              onPressed: () => _showExitDialog(context),
              child: const Text('Exit'),
            ),
        ],
      ),
      body: quizAsync.when(
        data: (quiz) => quiz == null
            ? const EmptyState(
                icon: Icons.quiz_outlined,
                title: 'Quiz Not Found',
                message: 'No quiz available for this lesson.',
              )
            : isCompleted
                ? _buildResultsView(context, theme, quiz)
                : _buildQuizView(context, theme, quiz),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => EmptyState(
          icon: Icons.error,
          title: 'Error Loading Quiz',
          message: 'Failed to load quiz: $error',
          actionText: 'Retry',
          onAction: () => ref.invalidate(quizByLessonProvider(widget.lessonId)),
        ),
      ),
    );
  }

  Widget _buildQuizView(BuildContext context, ThemeData theme, quiz) {
    final question = quiz.questions[currentQuestionIndex];
    final progress = (currentQuestionIndex + 1) / quiz.questions.length;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LinearProgressIndicator(
            value: progress,
            backgroundColor: theme.colorScheme.surfaceVariant,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Question ${currentQuestionIndex + 1} of ${quiz.questions.length}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          L2ECard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  question.question,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                ...question.options.asMap().entries.map((entry) {
                  final index = entry.key;
                  final option = entry.value;
                  final isSelected = selectedAnswers[currentQuestionIndex]?.contains(index) ?? false;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: InkWell(
                      onTap: () => _selectAnswer(currentQuestionIndex, index, question.type == 'single'),
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      child: Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isSelected
                                ? theme.colorScheme.primary
                                : theme.colorScheme.outline,
                            width: isSelected ? 2 : 1,
                          ),
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          color: isSelected
                              ? theme.colorScheme.primaryContainer.withOpacity(0.3)
                              : null,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              question.type == 'single'
                                  ? (isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked)
                                  : (isSelected ? Icons.check_box : Icons.check_box_outline_blank),
                              color: isSelected
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Text(
                                option,
                                style: theme.textTheme.bodyLarge,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
          const Spacer(),
          Row(
            children: [
              if (currentQuestionIndex > 0)
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => setState(() => currentQuestionIndex--),
                    child: const Text('Previous'),
                  ),
                ),
              if (currentQuestionIndex > 0) const SizedBox(width: AppSpacing.md),
              Expanded(
                child: PrimaryButton(
                  text: currentQuestionIndex == quiz.questions.length - 1
                      ? 'Submit Quiz'
                      : 'Next',
                  onPressed: selectedAnswers[currentQuestionIndex]?.isNotEmpty == true
                      ? () => _handleNext(quiz)
                      : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResultsView(BuildContext context, ThemeData theme, quiz) {
    final passed = finalScore! >= quiz.passScore;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.xl),
          Icon(
            passed ? Icons.check_circle : Icons.cancel,
            size: 80,
            color: passed ? Colors.green : Colors.red,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            passed ? 'Quiz Passed!' : 'Quiz Failed',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: passed ? Colors.green : Colors.red,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          L2ECard(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Your Score:',
                      style: theme.textTheme.titleMedium,
                    ),
                    Text(
                      '${(finalScore! * 100).toInt()}%',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: passed ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Pass Score:',
                      style: theme.textTheme.bodyMedium,
                    ),
                    Text(
                      '${(quiz.passScore * 100).toInt()}%',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                LinearProgressIndicator(
                  value: finalScore!,
                  backgroundColor: theme.colorScheme.surfaceVariant,
                  color: passed ? Colors.green : Colors.red,
                ),
              ],
            ),
          ),
          const Spacer(),
          Column(
            children: [
              if (!passed)
                PrimaryButton(
                  text: 'Retry Quiz',
                  onPressed: () => _resetQuiz(),
                ),
              if (!passed) const SizedBox(height: AppSpacing.md),
              OutlinedButton(
                onPressed: () => context.pop(),
                child: const Text('Back to Lesson'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _selectAnswer(int questionIndex, int optionIndex, bool isSingleChoice) {
    setState(() {
      if (isSingleChoice) {
        selectedAnswers[questionIndex] = [optionIndex];
      } else {
        final current = selectedAnswers[questionIndex] ?? [];
        if (current.contains(optionIndex)) {
          current.remove(optionIndex);
        } else {
          current.add(optionIndex);
        }
        selectedAnswers[questionIndex] = current;
      }
    });
  }

  void _handleNext(quiz) {
    if (currentQuestionIndex == quiz.questions.length - 1) {
      _submitQuiz(quiz);
    } else {
      setState(() => currentQuestionIndex++);
    }
  }

  void _submitQuiz(quiz) {
    double score = 0;
    for (int i = 0; i < quiz.questions.length; i++) {
      final question = quiz.questions[i];
      final userAnswers = selectedAnswers[i] ?? [];
      final correctAnswers = question.correctAnswers;
      
      if (userAnswers.toSet().containsAll(correctAnswers) && 
          correctAnswers.toSet().containsAll(userAnswers)) {
        score += 1;
      }
    }
    
    setState(() {
      finalScore = score / quiz.questions.length;
      isCompleted = true;
    });
  }

  void _resetQuiz() {
    setState(() {
      currentQuestionIndex = 0;
      selectedAnswers.clear();
      isCompleted = false;
      finalScore = null;
    });
  }

  void _showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit Quiz?'),
        content: const Text('Your progress will be lost if you exit now.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.pop();
            },
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }
}
