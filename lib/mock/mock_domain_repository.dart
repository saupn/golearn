import '../common/models/domain.dart';
import '../common/repositories/domain_repository.dart';
import 'seed_data.dart';

class MockDomainRepository implements DomainRepository {
  @override
  Future<List<Domain>> getAllDomains() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return SeedData.domains;
  }

  @override
  Future<Domain?> getDomainById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return SeedData.domains.where((d) => d.id == id).firstOrNull;
  }

  @override
  Future<List<Domain>> getEnrolledDomains(String userId) async {
    await Future.delayed(const Duration(milliseconds: 250));
    return SeedData.domains.take(2).toList();
  }
}
