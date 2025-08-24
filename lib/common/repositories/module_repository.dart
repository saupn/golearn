import '../models/module.dart';

abstract class ModuleRepository {
  Future<List<Module>> getModulesByLevel(String levelId);
  Future<Module?> getModuleById(String id);
  Future<Module> updateModuleStatus(String moduleId, String userId, ModuleStatus status);
}
