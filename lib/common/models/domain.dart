class Domain {
  final String id;
  final String name;
  final String slug;
  final String description;
  final String? thumbnailUrl;
  final DomainMetrics metrics;
  final DateTime createdAt;

  const Domain({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    this.thumbnailUrl,
    required this.metrics,
    required this.createdAt,
  });

  Domain copyWith({
    String? id,
    String? name,
    String? slug,
    String? description,
    String? thumbnailUrl,
    DomainMetrics? metrics,
    DateTime? createdAt,
  }) {
    return Domain(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      description: description ?? this.description,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      metrics: metrics ?? this.metrics,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class DomainMetrics {
  final int levelCount;
  final int moduleCount;
  final int lessonCount;

  const DomainMetrics({
    required this.levelCount,
    required this.moduleCount,
    required this.lessonCount,
  });

  DomainMetrics copyWith({
    int? levelCount,
    int? moduleCount,
    int? lessonCount,
  }) {
    return DomainMetrics(
      levelCount: levelCount ?? this.levelCount,
      moduleCount: moduleCount ?? this.moduleCount,
      lessonCount: lessonCount ?? this.lessonCount,
    );
  }
}
