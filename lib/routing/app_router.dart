import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/presentation/auth_screen.dart';
import '../features/auth/presentation/onboarding_screen.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/learn/presentation/domains_screen.dart';
import '../features/learn/presentation/domain_detail_screen.dart';
import '../features/learn/presentation/levels_screen.dart';
import '../features/learn/presentation/level_detail_screen.dart';
import '../features/learn/presentation/module_detail_screen.dart';
import '../features/learn/presentation/lesson_detail_screen.dart';
import '../features/quiz/presentation/quiz_screen.dart';
import '../features/missions/presentation/mission_detail_screen.dart';
import '../features/submissions/presentation/submission_detail_screen.dart';
import '../features/rewards/presentation/rewards_screen.dart';
import '../features/rewards/presentation/claim_screen.dart';
import '../features/leaderboards/presentation/leaderboards_screen.dart';
import '../features/notifications/presentation/notifications_screen.dart';
import '../features/profile/presentation/profile_screen.dart';
import '../common/widgets/app_scaffold.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/auth',
    routes: [
      GoRoute(
        path: '/auth',
        builder: (context, state) => const AuthScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => AppScaffold(child: child),
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/domains',
            builder: (context, state) => const DomainsScreen(),
          ),
          GoRoute(
            path: '/domain/:id',
            builder: (context, state) => DomainDetailScreen(
              domainId: state.pathParameters['id']!,
            ),
          ),
          GoRoute(
            path: '/domain/:id/levels',
            builder: (context, state) => LevelsScreen(
              domainId: state.pathParameters['id']!,
            ),
          ),
          GoRoute(
            path: '/level/:id',
            builder: (context, state) => LevelDetailScreen(
              levelId: state.pathParameters['id']!,
            ),
          ),
          GoRoute(
            path: '/module/:id',
            builder: (context, state) => ModuleDetailScreen(
              moduleId: state.pathParameters['id']!,
            ),
          ),
          GoRoute(
            path: '/lesson/:id',
            builder: (context, state) => LessonDetailScreen(
              lessonId: state.pathParameters['id']!,
            ),
          ),
          GoRoute(
            path: '/quiz/:lessonId',
            builder: (context, state) => QuizScreen(
              lessonId: state.pathParameters['lessonId']!,
            ),
          ),
          GoRoute(
            path: '/mission/:id',
            builder: (context, state) => MissionDetailScreen(
              missionId: state.pathParameters['id']!,
            ),
          ),
          GoRoute(
            path: '/submission/:id',
            builder: (context, state) => SubmissionDetailScreen(
              submissionId: state.pathParameters['id']!,
            ),
          ),
          GoRoute(
            path: '/rewards',
            builder: (context, state) => const RewardsScreen(),
          ),
          GoRoute(
            path: '/claim',
            builder: (context, state) => const ClaimScreen(),
          ),
          GoRoute(
            path: '/leaderboards',
            builder: (context, state) => const LeaderboardsScreen(),
          ),
          GoRoute(
            path: '/notifications',
            builder: (context, state) => const NotificationsScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
    ],
  );
});
