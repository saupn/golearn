import '../common/models/module.dart';
import '../common/repositories/module_repository.dart';
import 'seed_data.dart';

class MockModuleRepository implements ModuleRepository {
  @override
  Future<List<Module>> getModulesByLevel(String levelId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return SeedData.modules.where((m) => m.levelId == levelId).toList();
  }

  @override
  Future<Module?> getModuleById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return SeedData.modules.where((m) => m.id == id).firstOrNull;
  }

  @override
  Future<Module> updateModuleStatus(
    String moduleId,
    String userId,
    ModuleStatus status,
  ) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final module = SeedData.modules.where((m) => m.id == moduleId).first;
    final updatedModule = module.copyWith(status: status);
    final index = SeedData.modules.indexWhere((m) => m.id == moduleId);
    SeedData.modules[index] = updatedModule;
    return updatedModule;
  }

  @override
  Future<Module?> getModule(String id) async {
    return getModuleById(id);
  }
}
