import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/config/theme.dart';
import '../../../../core/providers/user_provider.dart';
import '../widgets/admin_header.dart';
import '../../../notifications/data/repositories/notification_repository.dart';
import '../../../notifications/data/models/notification_model.dart';

class NotificationsScreenLive extends StatefulWidget {
  const NotificationsScreenLive({super.key});

  @override
  State<NotificationsScreenLive> createState() => _NotificationsScreenLiveState();
}

class _NotificationsScreenLiveState extends State<NotificationsScreenLive> {
  final NotificationRepository _notificationRepo = NotificationRepository();
  String _selectedFilter = 'all'; // all, unread, read

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final userId = userProvider.userId ?? '';

    if (userId.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Notifikasi')),
        body: const Center(child: Text('User ID tidak ditemukan')),
      );
    }

    return Scaffold(
      backgroundColor: isDark ? AppTheme.backgroundDark : AppTheme.backgroundLight,
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
            const Text('Notifikasi', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        backgroundColor: isDark ? AppTheme.backgroundDark : AppTheme.backgroundLight,
        elevation: 0,
        actions: [
          // Mark all as read button
          StreamBuilder<List<NotificationModel>>(
            stream: _notificationRepo.getUnreadNotifications(userId),
            builder: (context, snapshot) {
              final hasUnread = snapshot.hasData && snapshot.data!.isNotEmpty;
              
              if (!hasUnread) return const SizedBox.shrink();

              return IconButton(
                icon: const Icon(Icons.done_all),
                onPressed: () async {
                  await _notificationRepo.markAllAsRead(userId);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Semua notifikasi ditandai sudah dibaca'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
                tooltip: 'Tandai semua sudah dibaca',
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterBar(userId, isDark),
          Expanded(
            child: _buildNotificationsList(userId, isDark),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar(String userId, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: StreamBuilder<List<NotificationModel>>(
        stream: _notificationRepo.getUserNotifications(userId),
        builder: (context, allSnapshot) {
          return StreamBuilder<List<NotificationModel>>(
            stream: _notificationRepo.getUnreadNotifications(userId),
            builder: (context, unreadSnapshot) {
              final totalCount = allSnapshot.data?.length ?? 0;
              final unreadCount = unreadSnapshot.data?.length ?? 0;
              final readCount = totalCount - unreadCount;

              return Row(
                children: [
                  _buildFilterChip('all', 'Semua', totalCount),
                  const SizedBox(width: 8),
                  _buildFilterChip('unread', 'Belum Dibaca', unreadCount),
                  const SizedBox(width: 8),
                  _buildFilterChip('read', 'Sudah Dibaca', readCount),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildFilterChip(String filter, String label, int count) {
    final isSelected = _selectedFilter == filter;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedFilter = filter),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.primaryPurple : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? AppTheme.primaryPurple : Colors.grey[300]!,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey[700],
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 13,
                ),
              ),
              if (count > 0) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : AppTheme.primaryPurple,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    count.toString(),
                    style: TextStyle(
                      color: isSelected ? AppTheme.primaryPurple : Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationsList(String userId, bool isDark) {
    Stream<List<NotificationModel>> stream;

    if (_selectedFilter == 'unread') {
      stream = _notificationRepo.getUnreadNotifications(userId);
    } else {
      stream = _notificationRepo.getUserNotifications(userId);
    }

    return StreamBuilder<List<NotificationModel>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _buildEmptyState();
        }

        var notifications = snapshot.data!;

        // Filter by read status if needed
        if (_selectedFilter == 'read') {
          notifications = notifications.where((n) => n.isRead).toList();
        }

        if (notifications.isEmpty) {
          return _buildEmptyState();
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            return _buildNotificationCard(notifications[index], isDark, userId);
          },
        );
      },
    );
  }

  Widget _buildNotificationCard(NotificationModel notification, bool isDark, String userId) {
    final priorityColor = _getPriorityColor(notification.priority);
    final typeIcon = _getTypeIcon(notification.type);

    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) async {
        await _notificationRepo.deleteNotification(notification.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Notifikasi dihapus'),
              action: SnackBarAction(
                label: 'BATAL',
                onPressed: () {
                  // TODO: Implement undo functionality
                },
              ),
            ),
          );
        }
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: notification.isRead ? 0 : 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: notification.isRead 
                ? Colors.transparent 
                : priorityColor.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: InkWell(
          onTap: () async {
            if (!notification.isRead) {
              await _notificationRepo.markAsRead(notification.id);
            }
            
            // TODO: Navigate to actionUrl if available
            if (notification.actionUrl != null) {
              // Navigator.pushNamed(context, notification.actionUrl!);
            }
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: notification.isRead 
                  ? (isDark ? Colors.grey[850] : Colors.grey[50])
                  : (isDark ? const Color(0xFF1E1E1E) : Colors.white),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: priorityColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(typeIcon, color: priorityColor, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: notification.isRead 
                                    ? FontWeight.normal 
                                    : FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black87,
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
                      const SizedBox(height: 4),
                      Text(
                        notification.message,
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 14,
                            color: Colors.grey[500],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatTime(notification.createdAt),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                          const Spacer(),
                          if (notification.priority == NotificationPriority.high)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'PENTING',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
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
          Icon(Icons.notifications_off, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            _selectedFilter == 'unread' 
                ? 'Tidak ada notifikasi belum dibaca'
                : _selectedFilter == 'read'
                    ? 'Tidak ada notifikasi sudah dibaca'
                    : 'Belum ada notifikasi',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Color _getPriorityColor(NotificationPriority priority) {
    switch (priority) {
      case NotificationPriority.high:
        return Colors.red;
      case NotificationPriority.medium:
        return AppTheme.accentOrange;
      case NotificationPriority.low:
        return Colors.grey;
    }
  }

  IconData _getTypeIcon(NotificationType type) {
    switch (type) {
      case NotificationType.tugasBaru:
        return Icons.assignment_add;
      case NotificationType.tugasDeadline:
        return Icons.alarm;
      case NotificationType.tugasSubmitted:
        return Icons.assignment_turned_in;
      case NotificationType.nilaiKeluar:
        return Icons.grade;
      case NotificationType.pengumuman:
        return Icons.campaign;
    }
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Baru saja';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} menit yang lalu';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} jam yang lalu';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} hari yang lalu';
    } else {
      return DateFormat('dd MMM yyyy', 'id_ID').format(dateTime);
    }
  }
}
