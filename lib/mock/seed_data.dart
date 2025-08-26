import '../common/models/domain.dart';
import '../common/models/level.dart';
import '../common/models/module.dart';
import '../common/models/lesson.dart';
import '../common/models/quiz.dart';
import '../common/models/mission.dart';
import '../common/models/reward.dart';
import '../common/models/leaderboard.dart';
import '../common/models/notification.dart';

class SeedData {
  static final List<Domain> domains = [
    Domain(
      id: 'domain_1',
      name: 'Web Development',
      slug: 'web-development',
      description:
          'Learn modern web development with HTML, CSS, JavaScript, and popular frameworks',
      thumbnailUrl: 'https://via.placeholder.com/300x200?text=Web+Dev',
      metrics: const DomainMetrics(
        levelCount: 10,
        moduleCount: 30,
        lessonCount: 120,
      ),
      createdAt: DateTime.now().subtract(const Duration(days: 100)),
    ),
    Domain(
      id: 'domain_2',
      name: 'Mobile App Development',
      slug: 'mobile-app-development',
      description:
          'Build native and cross-platform mobile applications with Flutter and React Native',
      thumbnailUrl: 'https://via.placeholder.com/300x200?text=Mobile+Dev',
      metrics: const DomainMetrics(
        levelCount: 8,
        moduleCount: 24,
        lessonCount: 96,
      ),
      createdAt: DateTime.now().subtract(const Duration(days: 90)),
    ),
    Domain(
      id: 'domain_3',
      name: 'Data Science',
      slug: 'data-science',
      description:
          'Master data analysis, machine learning, and AI with Python and R',
      thumbnailUrl: 'https://via.placeholder.com/300x200?text=Data+Science',
      metrics: const DomainMetrics(
        levelCount: 12,
        moduleCount: 36,
        lessonCount: 144,
      ),
      createdAt: DateTime.now().subtract(const Duration(days: 80)),
    ),
  ];

  static final List<Level> levels = [
    Level(
      id: 'level_1',
      domainId: 'domain_1',
      levelNumber: 1,
      title: 'HTML Fundamentals',
      incomeTargetUsd: 500,
      gatingRule: const GatingRule(
        minQuizScore: 0.7,
        requiredMissions: 2,
        requirePrevLevel: false,
        minRealResultUsd: 0,
      ),
      rewardRule: const RewardRule(
        baseToken: 10,
        multiplierRule: 1.0,
        realResultPerUsd: 0.1,
      ),
      status: LevelStatus.inProgress,
      createdAt: DateTime.now().subtract(const Duration(days: 50)),
    ),
    Level(
      id: 'level_2',
      domainId: 'domain_1',
      levelNumber: 2,
      title: 'CSS Styling & Layout',
      incomeTargetUsd: 750,
      gatingRule: const GatingRule(
        minQuizScore: 0.75,
        requiredMissions: 3,
        requirePrevLevel: true,
        minRealResultUsd: 100,
      ),
      rewardRule: const RewardRule(
        baseToken: 15,
        multiplierRule: 1.2,
        realResultPerUsd: 0.12,
      ),
      status: LevelStatus.locked,
      createdAt: DateTime.now().subtract(const Duration(days: 45)),
    ),
    Level(
      id: 'level_3',
      domainId: 'domain_1',
      levelNumber: 3,
      title: 'JavaScript Basics',
      incomeTargetUsd: 1000,
      gatingRule: const GatingRule(
        minQuizScore: 0.8,
        requiredMissions: 4,
        requirePrevLevel: true,
        minRealResultUsd: 200,
      ),
      rewardRule: const RewardRule(
        baseToken: 20,
        multiplierRule: 1.5,
        realResultPerUsd: 0.15,
      ),
      status: LevelStatus.locked,
      createdAt: DateTime.now().subtract(const Duration(days: 40)),
    ),
    Level(
      id: 'level_4',
      domainId: 'domain_2',
      levelNumber: 1,
      title: 'Flutter Basics',
      incomeTargetUsd: 800,
      gatingRule: const GatingRule(
        minQuizScore: 0.7,
        requiredMissions: 2,
        requirePrevLevel: false,
        minRealResultUsd: 0,
      ),
      rewardRule: const RewardRule(
        baseToken: 12,
        multiplierRule: 1.0,
        realResultPerUsd: 0.1,
      ),
      status: LevelStatus.locked,
      createdAt: DateTime.now().subtract(const Duration(days: 35)),
    ),
    Level(
      id: 'level_5',
      domainId: 'domain_3',
      levelNumber: 1,
      title: 'Python for Data Science',
      incomeTargetUsd: 1200,
      gatingRule: const GatingRule(
        minQuizScore: 0.75,
        requiredMissions: 3,
        requirePrevLevel: false,
        minRealResultUsd: 0,
      ),
      rewardRule: const RewardRule(
        baseToken: 18,
        multiplierRule: 1.3,
        realResultPerUsd: 0.13,
      ),
      status: LevelStatus.locked,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
  ];

  static final List<Module> modules = [
    Module(
      id: 'module_1',
      domainId: 'domain_1',
      levelId: 'level_1',
      name: 'HTML Structure',
      strandType: StrandType.theory,
      indexInLevel: 0,
      description: 'Learn the basic structure of HTML documents',
      status: ModuleStatus.inProgress,
      createdAt: DateTime.now().subtract(const Duration(days: 25)),
    ),
    Module(
      id: 'module_2',
      domainId: 'domain_1',
      levelId: 'level_1',
      name: 'HTML Elements',
      strandType: StrandType.practice,
      indexInLevel: 1,
      description: 'Practice with common HTML elements',
      status: ModuleStatus.locked,
      createdAt: DateTime.now().subtract(const Duration(days: 24)),
    ),
    Module(
      id: 'module_3',
      domainId: 'domain_1',
      levelId: 'level_1',
      name: 'HTML Project',
      strandType: StrandType.project,
      indexInLevel: 2,
      description: 'Build your first HTML webpage',
      status: ModuleStatus.locked,
      createdAt: DateTime.now().subtract(const Duration(days: 23)),
    ),
  ];

  static final List<Lesson> lessons = [
    Lesson(
      id: 'lesson_1',
      domainId: 'domain_1',
      levelId: 'level_1',
      moduleId: 'module_1',
      title: 'Introduction to HTML',
      slug: 'introduction-to-html',
      contentType: ContentType.video,
      videoUrl: 'https://via.placeholder.com/640x360?text=HTML+Intro+Video',
      estimatedMinutes: 15,
      hasQuiz: true,
      status: LessonStatus.completed,
      indexInModule: 0,
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
    ),
    Lesson(
      id: 'lesson_2',
      domainId: 'domain_1',
      levelId: 'level_1',
      moduleId: 'module_1',
      title: 'HTML Document Structure',
      slug: 'html-document-structure',
      contentType: ContentType.reading,
      estimatedMinutes: 10,
      hasQuiz: true,
      status: LessonStatus.inProgress,
      indexInModule: 1,
      createdAt: DateTime.now().subtract(const Duration(days: 19)),
    ),
    Lesson(
      id: 'lesson_3',
      domainId: 'domain_1',
      levelId: 'level_1',
      moduleId: 'module_1',
      title: 'HTML Tags and Attributes',
      slug: 'html-tags-and-attributes',
      contentType: ContentType.interactive,
      estimatedMinutes: 20,
      hasQuiz: true,
      status: LessonStatus.locked,
      indexInModule: 2,
      createdAt: DateTime.now().subtract(const Duration(days: 18)),
    ),
  ];

  static final List<Quiz> quizzes = [
    Quiz(
      id: 'quiz_1',
      lessonId: 'lesson_1',
      passScore: 0.7,
      questions: [
        const QuizQuestion(
          id: 'q1',
          question: 'What does HTML stand for?',
          options: [
            'Hyper Text Markup Language',
            'High Tech Modern Language',
            'Home Tool Markup Language',
            'Hyperlink and Text Markup Language',
          ],
          correctAnswers: [0],
          type: QuestionType.singleChoice,
          explanation:
              'HTML stands for Hyper Text Markup Language, which is the standard markup language for creating web pages.',
        ),
        const QuizQuestion(
          id: 'q2',
          question:
              'Which of the following are valid HTML elements? (Select all that apply)',
          options: ['<div>', '<span>', '<paragraph>', '<section>'],
          correctAnswers: [0, 1, 3],
          type: QuestionType.multipleChoice,
          explanation:
              '<div>, <span>, and <section> are valid HTML elements. <paragraph> is not a valid HTML element; use <p> instead.',
        ),
        const QuizQuestion(
          id: 'q3',
          question: 'What is the correct HTML element for the largest heading?',
          options: ['<h6>', '<h1>', '<heading>', '<header>'],
          correctAnswers: [1],
          type: QuestionType.singleChoice,
          explanation:
              '<h1> is the HTML element for the largest heading. Headings range from <h1> (largest) to <h6> (smallest).',
        ),
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
    ),
    Quiz(
      id: 'quiz_2',
      lessonId: 'lesson_2',
      passScore: 0.75,
      questions: [
        const QuizQuestion(
          id: 'q4',
          question: 'Which HTML element defines the document type?',
          options: ['<!DOCTYPE html>', '<doctype>', '<html>', '<document>'],
          correctAnswers: [0],
          type: QuestionType.singleChoice,
          explanation:
              '<!DOCTYPE html> declares the document type and version of HTML.',
        ),
        const QuizQuestion(
          id: 'q5',
          question: 'What are the main sections of an HTML document?',
          options: ['<head>', '<body>', '<footer>', '<main>'],
          correctAnswers: [0, 1],
          type: QuestionType.multipleChoice,
          explanation:
              'The main sections of an HTML document are <head> and <body>. <footer> and <main> are semantic elements within the body.',
        ),
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 14)),
    ),
  ];

  static final List<Mission> missions = [
    Mission(
      id: 'mission_1',
      lessonId: 'lesson_1',
      title: 'Create Your First HTML Page',
      description:
          'Create a simple HTML page with a title, heading, and paragraph. Upload the HTML file or provide a link to your hosted page.',
      proofType: ProofType.link,
      acceptanceRule:
          'Must contain valid HTML structure with <!DOCTYPE html>, <html>, <head>, <title>, <body>, <h1>, and <p> elements',
      rewardBaseToken: 5.0,
      createdAt: DateTime.now().subtract(const Duration(days: 12)),
    ),
    Mission(
      id: 'mission_2',
      lessonId: 'lesson_2',
      title: 'HTML Document Analysis',
      description:
          'Analyze an existing website and document its HTML structure. Provide a written report explaining the document structure.',
      proofType: ProofType.text,
      acceptanceRule:
          'Report must identify DOCTYPE, head elements, body structure, and semantic elements used',
      rewardBaseToken: 7.5,
      createdAt: DateTime.now().subtract(const Duration(days: 11)),
    ),
    Mission(
      id: 'mission_3',
      lessonId: 'lesson_3',
      title: 'HTML Elements Showcase',
      description:
          'Create an HTML page demonstrating at least 10 different HTML elements with proper attributes.',
      proofType: ProofType.link,
      acceptanceRule:
          'Must use at least 10 different HTML elements with appropriate attributes and semantic meaning',
      rewardBaseToken: 10.0,
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
  ];

  static final List<Reward> rewards = [
    Reward(
      id: 'reward_1',
      userId: 'user_1',
      sourceType: RewardSourceType.quiz,
      sourceRef: 'quiz_1',
      tokenAwarded: 5.0,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    Reward(
      id: 'reward_2',
      userId: 'user_1',
      sourceType: RewardSourceType.mission,
      sourceRef: 'mission_1',
      tokenAwarded: 5.0,
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
    ),
    Reward(
      id: 'reward_3',
      userId: 'user_1',
      sourceType: RewardSourceType.streak,
      sourceRef: 'streak_7_days',
      tokenAwarded: 15.0,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  static final List<LeaderboardEntry> leaderboardEntries = [
    LeaderboardEntry(
      boardId: 'daily',
      userId: 'user_2',
      displayName: 'Alice Johnson',
      avatarUrl: 'https://via.placeholder.com/100?text=AJ',
      metricValue: 250.0,
      rank: 1,
      updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    LeaderboardEntry(
      boardId: 'daily',
      userId: 'user_1',
      displayName: 'John Doe',
      avatarUrl: 'https://via.placeholder.com/100?text=JD',
      metricValue: 125.5,
      rank: 2,
      updatedAt: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    LeaderboardEntry(
      boardId: 'daily',
      userId: 'user_3',
      displayName: 'Bob Smith',
      avatarUrl: 'https://via.placeholder.com/100?text=BS',
      metricValue: 98.0,
      rank: 3,
      updatedAt: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    LeaderboardEntry(
      boardId: 'weekly',
      userId: 'user_1',
      displayName: 'John Doe',
      avatarUrl: 'https://via.placeholder.com/100?text=JD',
      metricValue: 875.5,
      rank: 1,
      updatedAt: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    LeaderboardEntry(
      boardId: 'weekly',
      userId: 'user_2',
      displayName: 'Alice Johnson',
      avatarUrl: 'https://via.placeholder.com/100?text=AJ',
      metricValue: 750.0,
      rank: 2,
      updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
  ];

  static final List<AppNotification> notifications = [
    AppNotification(
      id: 'notif_1',
      userId: 'user_1',
      type: NotificationType.streak,
      title: 'Streak Alert!',
      message:
          'You\'re on a 7-day learning streak! Keep it up to earn bonus rewards.',
      deepLink: '/home',
      isRead: false,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    AppNotification(
      id: 'notif_2',
      userId: 'user_1',
      type: NotificationType.mission,
      title: 'Mission Available',
      message:
          'New mission available in HTML Fundamentals. Complete it to earn 10 tokens!',
      deepLink: '/mission/mission_3',
      isRead: false,
      createdAt: DateTime.now().subtract(const Duration(hours: 6)),
    ),
    AppNotification(
      id: 'notif_3',
      userId: 'user_1',
      type: NotificationType.leaderboard,
      title: 'Leaderboard Update',
      message:
          'Weekly leaderboard closes in 2 days. You\'re currently in 1st place!',
      deepLink: '/leaderboards?board=weekly',
      isRead: true,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];
}
