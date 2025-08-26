import '../models/notification.dart';

abstract class NotificationRepository {
  Future<List<AppNotification>> getUserNotifications(String userId);
  Future<AppNotification> markAsRead(String notificationId);
  Future<void> markAllAsRead(String userId);
  Future<int> getUnreadCount(String userId);
}
