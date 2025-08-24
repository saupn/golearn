import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/models/domain.dart';
import '../../../common/repositories/domain_repository.dart';
import '../../../mock/mock_domain_repository.dart';
import '../../auth/providers/auth_provider.dart';

final domainRepositoryProvider = Provider<DomainRepository>((ref) {
  return MockDomainRepository();
});

final domainsProvider = FutureProvider<List<Domain>>((ref) async {
  final domainRepo = ref.read(domainRepositoryProvider);
  return domainRepo.getAllDomains();
});

final enrolledDomainsProvider = FutureProvider<List<Domain>>((ref) async {
  final user = await ref.watch(authProvider.future);
  if (user == null) return <Domain>[];
  
  final domainRepo = ref.read(domainRepositoryProvider);
  return domainRepo.getEnrolledDomains(user.id);
});

final domainProvider = FutureProvider.family<Domain?, String>((ref, domainId) async {
  final domainRepo = ref.read(domainRepositoryProvider);
  return domainRepo.getDomainById(domainId);
});
