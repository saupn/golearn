import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../l10n/l10n.dart';
import '../../../theme/app_theme.dart';
import '../../../common/widgets/l2e_card.dart';
import '../../../common/widgets/empty_state.dart';
import '../../../common/models/notification.dart';
import '../providers/notifications_provider.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final notificationsAsync = ref.watch(userNotificationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.notifications),
        actions: [
          IconButton(
            icon: const Icon(Icons.mark_email_read),
            onPressed: () =>
                ref.read(notificationsProvider.notifier).markAllAsRead(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(userNotificationsProvider);
        },
        child: notificationsAsync.when(
          data: (notifications) => notifications.isEmpty
              ? EmptyState(
                  icon: Icons.notifications_none,
                  title: 'No Notifications',
                  message:
                      'You\'re all caught up! Check back later for updates.',
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: L2ECard(
                        backgroundColor: notification.isRead
                            ? null
                            : theme.colorScheme.primaryContainer.withOpacity(
                                0.1,
                              ),
                        onTap: () {
                          if (!notification.isRead) {
                            ref
                                .read(notificationsProvider.notifier)
                                .markAsRead(notification.id);
                          }
                          if (notification.deepLink != null) {
                            context.push(notification.deepLink!);
                          }
                        },
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: _getNotificationColor(
                              theme,
                              notification.type,
                            ),
                            child: Icon(
                              _getNotificationIcon(notification.type),
                              color: theme.colorScheme.onPrimary,
                            ),
                          ),
                          title: Text(
                            notification.title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: notification.isRead
                                  ? FontWeight.normal
                                  : FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: AppSpacing.xs),
                              Text(notification.message),
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                _formatDateTime(notification.createdAt),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                          trailing: notification.isRead
                              ? null
                              : Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primary,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                        ),
                      ),
                    );
                  },
                ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => EmptyState(
            icon: Icons.error,
            title: 'Error Loading Notifications',
            message: 'Failed to load notifications: $error',
            actionText: 'Retry',
            onAction: () => ref.invalidate(userNotificationsProvider),
          ),
        ),
      ),
    );
  }

  Color _getNotificationColor(ThemeData theme, NotificationType type) {
    switch (type) {
      case NotificationType.streak:
        return Colors.orange;
      case NotificationType.capstone:
        return theme.colorScheme.secondary;
      case NotificationType.leaderboard:
        return Colors.purple;
      case NotificationType.mission:
        return theme.colorScheme.primary;
    }
  }

  IconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.streak:
        return Icons.local_fire_department;
      case NotificationType.capstone:
        return Icons.emoji_events;
      case NotificationType.leaderboard:
        return Icons.leaderboard;
      case NotificationType.mission:
        return Icons.assignment;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }
}
