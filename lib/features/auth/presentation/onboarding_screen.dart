import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../l10n/l10n.dart';
import '../../../theme/app_theme.dart';
import '../../../common/widgets/primary_button.dart';
import '../../learn/providers/domain_provider.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  String _selectedLanguage = 'en';
  String? _selectedDomainId;
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to ${l10n.appTitle}'),
        automaticallyImplyLeading: false,
      ),
      body: Stepper(
        currentStep: _currentStep,
        onStepTapped: (step) => setState(() => _currentStep = step),
        controlsBuilder: (context, details) {
          return Row(
            children: [
              if (details.stepIndex < 2)
                PrimaryButton(
                  text: 'Next',
                  onPressed: details.onStepContinue,
                ),
              if (details.stepIndex == 2)
                PrimaryButton(
                  text: 'Get Started',
                  onPressed: () => context.go('/home'),
                ),
              const SizedBox(width: AppSpacing.md),
              if (details.stepIndex > 0)
                OutlinedButton(
                  onPressed: details.onStepCancel,
                  child: const Text('Back'),
                ),
            ],
          );
        },
        steps: [
          Step(
            title: const Text('Choose Language'),
            content: _buildLanguageStep(),
            isActive: _currentStep >= 0,
          ),
          Step(
            title: const Text('Select Domain'),
            content: _buildDomainStep(),
            isActive: _currentStep >= 1,
          ),
          Step(
            title: const Text('Ready to Learn'),
            content: _buildReadyStep(),
            isActive: _currentStep >= 2,
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Select your preferred language for the app:'),
        const SizedBox(height: AppSpacing.md),
        RadioListTile<String>(
          title: const Text('English'),
          value: 'en',
          groupValue: _selectedLanguage,
          onChanged: (value) => setState(() => _selectedLanguage = value!),
        ),
        RadioListTile<String>(
          title: const Text('Tiếng Việt'),
          value: 'vi',
          groupValue: _selectedLanguage,
          onChanged: (value) => setState(() => _selectedLanguage = value!),
        ),
      ],
    );
  }

  Widget _buildDomainStep() {
    final domainsAsync = ref.watch(domainsProvider);
    
    return domainsAsync.when(
      data: (domains) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Choose a domain to start your learning journey:'),
          const SizedBox(height: AppSpacing.md),
          ...domains.map((domain) => RadioListTile<String>(
            title: Text(domain.name),
            subtitle: Text(domain.description),
            value: domain.id,
            groupValue: _selectedDomainId,
            onChanged: (value) => setState(() => _selectedDomainId = value),
          )),
        ],
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Text('Error loading domains: $error'),
    );
  }

  Widget _buildReadyStep() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('You\'re all set! Here\'s what you can do:'),
        SizedBox(height: AppSpacing.md),
        ListTile(
          leading: Icon(Icons.play_circle),
          title: Text('Start Learning'),
          subtitle: Text('Begin with lessons and quizzes'),
        ),
        ListTile(
          leading: Icon(Icons.assignment),
          title: Text('Complete Missions'),
          subtitle: Text('Submit proof and earn rewards'),
        ),
        ListTile(
          leading: Icon(Icons.leaderboard),
          title: Text('Compete'),
          subtitle: Text('Climb the leaderboards'),
        ),
        ListTile(
          leading: Icon(Icons.local_fire_department),
          title: Text('Build Streaks'),
          subtitle: Text('Learn daily for bonus rewards'),
        ),
      ],
    );
  }
}
