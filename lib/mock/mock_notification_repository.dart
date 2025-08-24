import '../common/models/notification.dart';
import '../common/repositories/notification_repository.dart';
import 'seed_data.dart';

class MockNotificationRepository implements NotificationRepository {
  final List<AppNotification> _notifications = List.from(SeedData.notifications);

  @override
  Future<List<AppNotification>> getUserNotifications(String userId) async {
    await Future.delayed(const Duration(milliseconds: 250));
    return _notifications
        .where((n) => n.userId == userId)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  @override
  Future<AppNotification> markAsRead(String notificationId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
    }
    return _notifications[index];
  }

  @override
  Future<int> getUnreadCount(String userId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _notifications
        .where((n) => n.userId == userId && !n.isRead)
        .length;
  }
}
