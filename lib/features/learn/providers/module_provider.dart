import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/models/module.dart';
import '../../../common/repositories/module_repository.dart';
import '../../../mock/mock_module_repository.dart';

final moduleRepositoryProvider = Provider<ModuleRepository>((ref) {
  return MockModuleRepository();
});

final modulesByLevelProvider = FutureProvider.family<List<Module>, String>((
  ref,
  levelId,
) async {
  final moduleRepo = ref.read(moduleRepositoryProvider);
  return moduleRepo.getModulesByLevel(levelId);
});

final moduleProvider = FutureProvider.family<Module?, String>((
  ref,
  moduleId,
) async {
  final moduleRepo = ref.read(moduleRepositoryProvider);
  return moduleRepo.getModule(moduleId);
});
