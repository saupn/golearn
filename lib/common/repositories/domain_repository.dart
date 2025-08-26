import '../models/domain.dart';

abstract class DomainRepository {
  Future<List<Domain>> getAllDomains();
  Future<Domain?> getDomainById(String id);
  Future<List<Domain>> getEnrolledDomains(String userId);
}
