enum QuestionType { singleChoice, multipleChoice }

class Quiz {
  final String id;
  final String lessonId;
  final List<QuizQuestion> questions;
  final double passScore;
  final DateTime createdAt;

  const Quiz({
    required this.id,
    required this.lessonId,
    required this.questions,
    required this.passScore,
    required this.createdAt,
  });

  Quiz copyWith({
    String? id,
    String? lessonId,
    List<QuizQuestion>? questions,
    double? passScore,
    DateTime? createdAt,
  }) {
    return Quiz(
      id: id ?? this.id,
      lessonId: lessonId ?? this.lessonId,
      questions: questions ?? this.questions,
      passScore: passScore ?? this.passScore,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class QuizQuestion {
  final String id;
  final String question;
  final List<String> options;
  final List<int> correctAnswers;
  final QuestionType type;
  final String? explanation;

  const QuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswers,
    required this.type,
    this.explanation,
  });

  QuizQuestion copyWith({
    String? id,
    String? question,
    List<String>? options,
    List<int>? correctAnswers,
    QuestionType? type,
    String? explanation,
  }) {
    return QuizQuestion(
      id: id ?? this.id,
      question: question ?? this.question,
      options: options ?? this.options,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      type: type ?? this.type,
      explanation: explanation ?? this.explanation,
    );
  }
}

class QuizResult {
  final String quizId;
  final List<int> userAnswers;
  final double score;
  final bool passed;
  final DateTime completedAt;

  const QuizResult({
    required this.quizId,
    required this.userAnswers,
    required this.score,
    required this.passed,
    required this.completedAt,
  });

  QuizResult copyWith({
    String? quizId,
    List<int>? userAnswers,
    double? score,
    bool? passed,
    DateTime? completedAt,
  }) {
    return QuizResult(
      quizId: quizId ?? this.quizId,
      userAnswers: userAnswers ?? this.userAnswers,
      score: score ?? this.score,
      passed: passed ?? this.passed,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}
