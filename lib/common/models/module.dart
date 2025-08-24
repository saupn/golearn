enum ModuleStatus { locked, inProgress, completed }
enum StrandType { theory, practice, project }

class Module {
  final String id;
  final String domainId;
  final String levelId;
  final String name;
  final StrandType strandType;
  final int indexInLevel;
  final String description;
  final ModuleStatus status;
  final DateTime createdAt;

  const Module({
    required this.id,
    required this.domainId,
    required this.levelId,
    required this.name,
    required this.strandType,
    required this.indexInLevel,
    required this.description,
    required this.status,
    required this.createdAt,
  });

  Module copyWith({
    String? id,
    String? domainId,
    String? levelId,
    String? name,
    StrandType? strandType,
    int? indexInLevel,
    String? description,
    ModuleStatus? status,
    DateTime? createdAt,
  }) {
    return Module(
      id: id ?? this.id,
      domainId: domainId ?? this.domainId,
      levelId: levelId ?? this.levelId,
      name: name ?? this.name,
      strandType: strandType ?? this.strandType,
      indexInLevel: indexInLevel ?? this.indexInLevel,
      description: description ?? this.description,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
