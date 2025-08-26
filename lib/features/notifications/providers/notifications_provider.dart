import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/models/notification.dart';
import '../../../common/repositories/notification_repository.dart';
import '../../../mock/mock_notification_repository.dart';
import '../../auth/providers/auth_provider.dart';

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return MockNotificationRepository();
});

final userNotificationsProvider = FutureProvider<List<AppNotification>>((
  ref,
) async {
  final authState = ref.watch(authProvider);
  return authState.when(
    data: (user) async {
      if (user == null) return <AppNotification>[];
      final notificationRepo = ref.read(notificationRepositoryProvider);
      return notificationRepo.getUserNotifications(user.id);
    },
    loading: () => <AppNotification>[],
    error: (_, __) => <AppNotification>[],
  );
});

final notificationsProvider =
    NotifierProvider<
      NotificationsNotifier,
      AsyncValue<List<AppNotification>>
    >(NotificationsNotifier.new);

class NotificationsNotifier
    extends Notifier<AsyncValue<List<AppNotification>>> {
  @override
  AsyncValue<List<AppNotification>> build() {
    return const AsyncValue.loading();
  }

  Future<void> markAsRead(String notificationId) async {
    final notificationRepo = ref.read(notificationRepositoryProvider);
    await notificationRepo.markAsRead(notificationId);
    ref.invalidate(userNotificationsProvider);
  }

  Future<void> markAllAsRead() async {
    final authState = ref.read(authProvider);
    final user = authState.value;
    if (user == null) return;

    final notificationRepo = ref.read(notificationRepositoryProvider);
    await notificationRepo.markAllAsRead(user.id);
    ref.invalidate(userNotificationsProvider);
  }
}
