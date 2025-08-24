import 'package:flutter/widgets.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('vi'),
  ];

  String get appTitle => _localizedValues[locale.languageCode]?['app_title'] ?? 'L2E - Learn to Earn';
  String get home => _localizedValues[locale.languageCode]?['home'] ?? 'Home';
  String get learn => _localizedValues[locale.languageCode]?['learn'] ?? 'Learn';
  String get rewards => _localizedValues[locale.languageCode]?['rewards'] ?? 'Rewards';
  String get profile => _localizedValues[locale.languageCode]?['profile'] ?? 'Profile';
  String get signIn => _localizedValues[locale.languageCode]?['sign_in'] ?? 'Sign In';
  String get signInWithEmail => _localizedValues[locale.languageCode]?['sign_in_with_email'] ?? 'Sign in with Email';
  String get signInWithGoogle => _localizedValues[locale.languageCode]?['sign_in_with_google'] ?? 'Sign in with Google';
  String get welcome => _localizedValues[locale.languageCode]?['welcome'] ?? 'Welcome';
  String get currentStreak => _localizedValues[locale.languageCode]?['current_streak'] ?? 'Current Streak';
  String get longestStreak => _localizedValues[locale.languageCode]?['longest_streak'] ?? 'Longest Streak';
  String get tokenBalance => _localizedValues[locale.languageCode]?['token_balance'] ?? 'Token Balance';
  String get continueLesson => _localizedValues[locale.languageCode]?['continue_lesson'] ?? 'Continue Lesson';
  String get claimRewards => _localizedValues[locale.languageCode]?['claim_rewards'] ?? 'Claim Rewards';
  String get leaderboard => _localizedValues[locale.languageCode]?['leaderboard'] ?? 'Leaderboard';
  String get domains => _localizedValues[locale.languageCode]?['domains'] ?? 'Domains';
  String get levels => _localizedValues[locale.languageCode]?['levels'] ?? 'Levels';
  String get lessons => _localizedValues[locale.languageCode]?['lessons'] ?? 'Lessons';
  String get quiz => _localizedValues[locale.languageCode]?['quiz'] ?? 'Quiz';
  String get mission => _localizedValues[locale.languageCode]?['mission'] ?? 'Mission';
  String get submitProof => _localizedValues[locale.languageCode]?['submit_proof'] ?? 'Submit Proof';
  String get evaluation => _localizedValues[locale.languageCode]?['evaluation'] ?? 'Evaluation';
  String get passed => _localizedValues[locale.languageCode]?['passed'] ?? 'Passed';
  String get failed => _localizedValues[locale.languageCode]?['failed'] ?? 'Failed';
  String get pending => _localizedValues[locale.languageCode]?['pending'] ?? 'Pending';
  String get processing => _localizedValues[locale.languageCode]?['processing'] ?? 'Processing';
  String get evaluated => _localizedValues[locale.languageCode]?['evaluated'] ?? 'Evaluated';

  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'app_title': 'L2E - Learn to Earn',
      'home': 'Home',
      'learn': 'Learn',
      'rewards': 'Rewards',
      'profile': 'Profile',
      'sign_in': 'Sign In',
      'sign_in_with_email': 'Sign in with Email',
      'sign_in_with_google': 'Sign in with Google',
      'welcome': 'Welcome',
      'current_streak': 'Current Streak',
      'longest_streak': 'Longest Streak',
      'token_balance': 'Token Balance',
      'continue_lesson': 'Continue Lesson',
      'claim_rewards': 'Claim Rewards',
      'leaderboard': 'Leaderboard',
      'domains': 'Domains',
      'levels': 'Levels',
      'lessons': 'Lessons',
      'quiz': 'Quiz',
      'mission': 'Mission',
      'submit_proof': 'Submit Proof',
      'evaluation': 'Evaluation',
      'passed': 'Passed',
      'failed': 'Failed',
      'pending': 'Pending',
      'processing': 'Processing',
      'evaluated': 'Evaluated',
    },
    'vi': {
      'app_title': 'L2E - Học để Kiếm',
      'home': 'Trang chủ',
      'learn': 'Học tập',
      'rewards': 'Phần thưởng',
      'profile': 'Hồ sơ',
      'sign_in': 'Đăng nhập',
      'sign_in_with_email': 'Đăng nhập bằng Email',
      'sign_in_with_google': 'Đăng nhập bằng Google',
      'welcome': 'Chào mừng',
      'current_streak': 'Chuỗi hiện tại',
      'longest_streak': 'Chuỗi dài nhất',
      'token_balance': 'Số dư Token',
      'continue_lesson': 'Tiếp tục bài học',
      'claim_rewards': 'Nhận thưởng',
      'leaderboard': 'Bảng xếp hạng',
      'domains': 'Lĩnh vực',
      'levels': 'Cấp độ',
      'lessons': 'Bài học',
      'quiz': 'Câu hỏi',
      'mission': 'Nhiệm vụ',
      'submit_proof': 'Nộp bằng chứng',
      'evaluation': 'Đánh giá',
      'passed': 'Đạt',
      'failed': 'Không đạt',
      'pending': 'Chờ xử lý',
      'processing': 'Đang xử lý',
      'evaluated': 'Đã đánh giá',
    },
  };
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppLocalizations.supportedLocales.contains(locale);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
