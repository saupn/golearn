import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/models/notification.dart';
import '../../../common/repositories/notification_repository.dart';
import '../../../mock/mock_notification_repository.dart';
import '../../auth/providers/auth_provider.dart';

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return MockNotificationRepository();
});

final userNotificationsProvider = FutureProvider<List<AppNotification>>((ref) async {
  final user = await ref.watch(authProvider.future);
  if (user == null) return <AppNotification>[];
  
  final notificationRepo = ref.read(notificationRepositoryProvider);
  return notificationRepo.getUserNotifications(user.id);
});

final notificationsProvider = StateNotifierProvider<NotificationsNotifier, AsyncValue<List<AppNotification>>>((ref) {
  return NotificationsNotifier(ref);
});

class NotificationsNotifier extends StateNotifier<AsyncValue<List<AppNotification>>> {
  final Ref _ref;

  NotificationsNotifier(this._ref) : super(const AsyncValue.loading());

  Future<void> markAsRead(String notificationId) async {
    final notificationRepo = _ref.read(notificationRepositoryProvider);
    await notificationRepo.markAsRead(notificationId);
    _ref.invalidate(userNotificationsProvider);
  }

  Future<void> markAllAsRead() async {
    final user = await _ref.read(authProvider.future);
    if (user == null) return;
    
    final notificationRepo = _ref.read(notificationRepositoryProvider);
    await notificationRepo.markAllAsRead(user.id);
    _ref.invalidate(userNotificationsProvider);
  }
}
