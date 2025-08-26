enum LessonStatus { locked, inProgress, completed }

enum ContentType { video, reading, interactive }

class Lesson {
  final String id;
  final String domainId;
  final String levelId;
  final String moduleId;
  final String title;
  final String slug;
  final ContentType contentType;
  final String? videoUrl;
  final int estimatedMinutes;
  final bool hasQuiz;
  final LessonStatus status;
  final int indexInModule;
  final DateTime createdAt;

  const Lesson({
    required this.id,
    required this.domainId,
    required this.levelId,
    required this.moduleId,
    required this.title,
    required this.slug,
    required this.contentType,
    this.videoUrl,
    required this.estimatedMinutes,
    required this.hasQuiz,
    required this.status,
    required this.indexInModule,
    required this.createdAt,
  });

  Lesson copyWith({
    String? id,
    String? domainId,
    String? levelId,
    String? moduleId,
    String? title,
    String? slug,
    ContentType? contentType,
    String? videoUrl,
    int? estimatedMinutes,
    bool? hasQuiz,
    LessonStatus? status,
    int? indexInModule,
    DateTime? createdAt,
  }) {
    return Lesson(
      id: id ?? this.id,
      domainId: domainId ?? this.domainId,
      levelId: levelId ?? this.levelId,
      moduleId: moduleId ?? this.moduleId,
      title: title ?? this.title,
      slug: slug ?? this.slug,
      contentType: contentType ?? this.contentType,
      videoUrl: videoUrl ?? this.videoUrl,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      hasQuiz: hasQuiz ?? this.hasQuiz,
      status: status ?? this.status,
      indexInModule: indexInModule ?? this.indexInModule,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
