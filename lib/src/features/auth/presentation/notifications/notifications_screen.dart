import 'package:flutter/material.dart';
import '../../../../core/config/theme.dart';
import '../widgets/admin_header.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String _selectedTab = 'All';
  final List<NotificationItem> _notifications = [
    NotificationItem(
      id: '1',
      title: 'New Student Registered',
      message: 'John Doe has been registered as a new student',
      time: '5 minutes ago',
      type: NotificationType.info,
      isRead: false,
      icon: Icons.person_add,
    ),
    NotificationItem(
      id: '2',
      title: 'Class Updated',
      message: 'Class 10 A schedule has been updated',
      time: '1 hour ago',
      type: NotificationType.success,
      isRead: false,
      icon: Icons.update,
    ),
    NotificationItem(
      id: '3',
      title: 'System Maintenance',
      message: 'System will be under maintenance on Sunday, 2:00 AM',
      time: '2 hours ago',
      type: NotificationType.warning,
      isRead: false,
      icon: Icons.construction,
    ),
    NotificationItem(
      id: '4',
      title: 'New Message',
      message: 'You have a new message from Teacher Sarah',
      time: '3 hours ago',
      type: NotificationType.info,
      isRead: true,
      icon: Icons.message,
    ),
    NotificationItem(
      id: '5',
      title: 'Payment Received',
      message: 'Payment received from student Jane Smith',
      time: '5 hours ago',
      type: NotificationType.success,
      isRead: true,
      icon: Icons.payment,
    ),
    NotificationItem(
      id: '6',
      title: 'Low Storage',
      message: 'Storage is running low. Please free up some space.',
      time: '1 day ago',
      type: NotificationType.error,
      isRead: true,
      icon: Icons.storage,
    ),
    NotificationItem(
      id: '7',
      title: 'Backup Completed',
      message: 'Your data has been successfully backed up',
      time: '2 days ago',
      type: NotificationType.success,
      isRead: true,
      icon: Icons.backup,
    ),
    NotificationItem(
      id: '8',
      title: 'Profile Updated',
      message: 'Your profile information has been updated',
      time: '3 days ago',
      type: NotificationType.info,
      isRead: true,
      icon: Icons.person,
    ),
  ];

  List<NotificationItem> get _filteredNotifications {
    switch (_selectedTab) {
      case 'Unread':
        return _notifications.where((n) => !n.isRead).toList();
      case 'Read':
        return _notifications.where((n) => n.isRead).toList();
      default:
        return _notifications;
    }
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount = _notifications.where((n) => !n.isRead).length;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: AppTheme.sunsetGradient,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.notifications, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Notifications',
                style: TextStyle(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
          tooltip: 'Back',
        ),
        actions: [
          Builder(builder: (ctx) {
            final w = MediaQuery.of(ctx).size.width;
            if (unreadCount > 0) {
              // On narrow screens, show icon-only to avoid overflow
              if (w < 420) {
                return IconButton(
                  icon: const Icon(Icons.done_all),
                  onPressed: _markAllAsRead,
                  tooltip: 'Mark all read',
                );
              }

              return TextButton.icon(
                onPressed: _markAllAsRead,
                icon: const Icon(Icons.done_all, size: 18),
                label: const Text('Mark all read'),
                style: TextButton.styleFrom(
                  foregroundColor: AppTheme.primaryPurple,
                ),
              );
            }

            return const SizedBox.shrink();
          }),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: _showNotificationSettings,
            tooltip: 'Notification Settings',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildTabBar(unreadCount),
          Expanded(
            child: _filteredNotifications.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredNotifications.length,
                    itemBuilder: (context, index) {
                      return _buildNotificationCard(_filteredNotifications[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(int unreadCount) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildTab('All', _notifications.length),
          const SizedBox(width: 12),
          _buildTab('Unread', unreadCount),
          const SizedBox(width: 12),
          _buildTab('Read', _notifications.length - unreadCount),
        ],
      ),
    );
  }

  Widget _buildTab(String label, int count) {
    final isSelected = _selectedTab == label;
    return Expanded(
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => setState(() => _selectedTab = label),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppTheme.primaryPurple.withOpacity(0.15)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected
                    ? AppTheme.primaryPurple
                    : Colors.grey.withOpacity(0.3),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected ? AppTheme.primaryPurple : Colors.grey[600],
                  ),
                ),
                if (count > 0) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.primaryPurple
                          : Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      count.toString(),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationCard(NotificationItem notification) {
    return Dismissible(
      key: Key(notification.id),
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        setState(() => _notifications.remove(notification));
        _showSnackbar('Notification deleted');
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => _markAsRead(notification),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: notification.isRead
                  ? Theme.of(context).cardColor
                  : _getNotificationTypeColor(notification.type).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: notification.isRead
                    ? Colors.grey.withOpacity(0.2)
                    : _getNotificationTypeColor(notification.type).withOpacity(0.3),
                width: notification.isRead ? 1 : 2,
              ),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _getNotificationTypeColor(notification.type).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  notification.icon,
                  color: _getNotificationTypeColor(notification.type),
                  size: 24,
                ),
              ),
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      notification.title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: notification.isRead ? FontWeight.w500 : FontWeight.bold,
                      ),
                    ),
                  ),
                  if (!notification.isRead)
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppTheme.primaryPurple,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    notification.message,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 12, color: Colors.grey[500]),
                      const SizedBox(width: 4),
                      Text(
                        notification.time,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              trailing: PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (value) {
                  if (value == 'mark_read') {
                    _markAsRead(notification);
                  } else if (value == 'delete') {
                    setState(() => _notifications.remove(notification));
                    _showSnackbar('Notification deleted');
                  }
                },
                itemBuilder: (context) => [
                  if (!notification.isRead)
                    const PopupMenuItem(
                      value: 'mark_read',
                      child: Row(
                        children: [
                          Icon(Icons.check, size: 18),
                          SizedBox(width: 8),
                          Text('Mark as read'),
                        ],
                      ),
                    ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, size: 18, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Delete', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No notifications',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You\'re all caught up!',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Color _getNotificationTypeColor(NotificationType type) {
    switch (type) {
      case NotificationType.success:
        return AppTheme.accentGreen;
      case NotificationType.warning:
        return AppTheme.accentOrange;
      case NotificationType.error:
        return Colors.red;
      case NotificationType.info:
      default:
        return AppTheme.primaryPurple;
    }
  }

  void _markAsRead(NotificationItem notification) {
    setState(() {
      notification.isRead = true;
    });
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in _notifications) {
        notification.isRead = true;
      }
    });
    _showSnackbar('All notifications marked as read');
  }

  void _showNotificationSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.settings, color: AppTheme.primaryPurple),
            SizedBox(width: 12),
            Text('Notification Settings'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: const Text('Push Notifications'),
              value: true,
              onChanged: (value) {},
              activeColor: AppTheme.primaryPurple,
            ),
            SwitchListTile(
              title: const Text('Email Notifications'),
              value: true,
              onChanged: (value) {},
              activeColor: AppTheme.primaryPurple,
            ),
            SwitchListTile(
              title: const Text('Sound'),
              value: true,
              onChanged: (value) {},
              activeColor: AppTheme.primaryPurple,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.accentGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

enum NotificationType {
  info,
  success,
  warning,
  error,
}

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final String time;
  final NotificationType type;
  bool isRead;
  final IconData icon;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    required this.type,
    required this.isRead,
    required this.icon,
  });
}
