import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/config/theme.dart';
import '../../../../core/providers/user_provider.dart';
import '../../../notifications/presentation/bloc/notification_bloc.dart';
import '../../../notifications/presentation/bloc/notification_event.dart';
import '../../../notifications/data/models/notification_model.dart';
import '../../../notifications/data/repositories/notification_repository.dart';
import 'notification_preferences_screen.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String _selectedTab = 'All';
  late NotificationBloc _notificationBloc;
  late NotificationRepository _repository;
  String? _userId;
  String? _userRole;

  @override
  void initState() {
    super.initState();
    _repository = NotificationRepository();
    _notificationBloc = NotificationBloc(repository: _repository);
    _initializeUser();
  }

  void _initializeUser() {
    // Get userId and role from userProvider
    setState(() {
      _userId = userProvider.userId;
      _userRole = userProvider.userType; // 'guru' or 'siswa'
    });

    print('🔔 NotificationScreen - userId: $_userId, role: $_userRole');

    if (_userId != null && _userRole != null) {
      _notificationBloc.add(FetchNotifications(
        userId: _userId!,
        role: _userRole!,
      ));

      // Check for deadline reminders
      _notificationBloc.add(const CheckDeadlineReminders());
    } else {
      print('⚠️ User not logged in or userProvider not initialized');
    }
  }

  @override
  void dispose() {
    _notificationBloc.close();
    super.dispose();
  }

  List<NotificationModel> _filterNotifications(
    List<NotificationModel> notifications,
  ) {
    switch (_selectedTab) {
      case 'Unread':
        return notifications.where((n) => !n.isRead).toList();
      case 'Read':
        return notifications.where((n) => n.isRead).toList();
      default:
        return notifications;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _notificationBloc,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: _buildAppBar(),
        body: _userId == null || _userRole == null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    const Text(
                      'User not logged in',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'userId: $_userId\nrole: $_userRole',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              )
            : StreamBuilder<List<NotificationModel>>(
                stream: _repository.watchNotifications(_userId!, _userRole!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }

                  final notifications = snapshot.data ?? [];
                  final unreadCount =
                      notifications.where((n) => !n.isRead).length;

                  return Column(
                    children: [
                      _buildTabBar(notifications.length, unreadCount),
                      Expanded(
                        child: _buildNotificationList(notifications),
                      ),
                    ],
                  );
                },
              ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Row(
        mainAxisSize: MainAxisSize.min,
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
          const Flexible(
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
        // Preferences Button
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NotificationPreferencesScreen(),
              ),
            );
          },
          tooltip: 'Pengaturan Notifikasi',
        ),
        StreamBuilder<List<NotificationModel>>(
          stream: _userId != null && _userRole != null
              ? _repository.watchNotifications(_userId!, _userRole!)
              : null,
          builder: (context, snapshot) {
            final notifications = snapshot.data ?? [];
            final unreadCount = notifications.where((n) => !n.isRead).length;

            if (unreadCount > 0) {
              return LayoutBuilder(
                builder: (context, constraints) {
                  // Pada layar kecil, tampilkan hanya icon
                  if (MediaQuery.of(context).size.width < 400) {
                    return IconButton(
                      onPressed: () => _markAllAsRead(context),
                      icon: const Icon(Icons.done_all, size: 20),
                      tooltip: 'Mark all read',
                      color: AppTheme.primaryPurple,
                    );
                  }
                  // Pada layar besar, tampilkan text button
                  return TextButton.icon(
                    onPressed: () => _markAllAsRead(context),
                    icon: const Icon(Icons.done_all, size: 18),
                    label: const Text('Mark all'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.primaryPurple,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                  );
                },
              );
            }

            return const SizedBox.shrink();
          },
        ),
        IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: () => _showDeleteAllDialog(context),
          tooltip: 'Delete All',
        ),
      ],
    );
  }

  Widget _buildTabBar(int totalCount, int unreadCount) {
    final readCount = totalCount - unreadCount;

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
          _buildTab('All', totalCount),
          const SizedBox(width: 8),
          _buildTab('Unread', unreadCount),
          const SizedBox(width: 8),
          _buildTab('Read', readCount),
        ],
      ),
    );
  }

  Widget _buildTab(String label, int count) {
    final isSelected = _selectedTab == label;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            gradient: isSelected ? AppTheme.sunsetGradient : null,
            color: isSelected ? null : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 14,
                ),
              ),
              if (count > 0)
                Text(
                  count.toString(),
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppTheme.primaryPurple,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationList(List<NotificationModel> notifications) {
    final filteredNotifications = _filterNotifications(notifications);

    if (filteredNotifications.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: () async {
        if (_userId != null && _userRole != null) {
          _notificationBloc.add(RefreshNotifications(
            userId: _userId!,
            role: _userRole!,
          ));
        }
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filteredNotifications.length,
        itemBuilder: (context, index) {
          return _buildNotificationCard(filteredNotifications[index]);
        },
      ),
    );
  }

  Widget _buildNotificationCard(NotificationModel notification) {
    return Dismissible(
      key: Key(notification.id),
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        _notificationBloc.add(DeleteNotification(notification.id));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Notification deleted')),
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: notification.isRead ? 0 : 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: notification.isRead
                ? Colors.transparent
                : _getPriorityColor(notification.priority).withOpacity(0.3),
            width: 2,
          ),
        ),
        child: InkWell(
          onTap: () => _handleNotificationTap(notification),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _getPriorityColor(notification.priority)
                        .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    _getNotificationIcon(notification.type),
                    color: _getPriorityColor(notification.priority),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
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
                                fontWeight: notification.isRead
                                    ? FontWeight.normal
                                    : FontWeight.bold,
                                fontSize: 16,
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
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _formatTime(notification.createdAt),
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 12,
                        ),
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
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              gradient: AppTheme.sunsetGradient.scale(0.3),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_off_outlined,
              size: 64,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No notifications',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _getEmptyStateMessage(),
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _getEmptyStateMessage() {
    switch (_selectedTab) {
      case 'Unread':
        return 'You\'re all caught up!';
      case 'Read':
        return 'No read notifications yet';
      default:
        return 'You don\'t have any notifications yet';
    }
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'tugas_baru':
        return Icons.assignment_outlined;
      case 'tugas_deadline':
        return Icons.alarm;
      case 'tugas_submitted':
        return Icons.check_circle_outline;
      case 'nilai_keluar':
        return Icons.grade;
      case 'pengumuman':
        return Icons.campaign;
      default:
        return Icons.notifications;
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return DateFormat('dd MMM yyyy').format(dateTime);
    }
  }

  void _handleNotificationTap(NotificationModel notification) {
    // Track notification viewed/clicked
    if (_userId != null) {
      _notificationBloc.add(TrackNotificationViewed(
        userId: _userId!,
        notificationId: notification.id,
      ));
      _notificationBloc.add(TrackNotificationClicked(
        userId: _userId!,
        notificationId: notification.id,
        action: 'opened',
      ));
    }

    // Mark as read
    if (!notification.isRead) {
      _notificationBloc.add(MarkAsRead(notification.id));
    }

    // Navigate to actionUrl if available
    if (notification.actionUrl != null && notification.actionUrl!.isNotEmpty) {
      // Handle navigation based on action URL
      _handleNavigation(notification.actionUrl!);
    } else if (notification.actions != null &&
        notification.actions!.isNotEmpty) {
      // Show action sheet if notification has actions
      _showActionSheet(notification);
    }
  }

  void _handleNavigation(String actionUrl) {
    // Role-based navigation with error handling
    try {
      if (!actionUrl.startsWith('/')) {
        print('⚠️ Invalid action URL: $actionUrl (must start with /)');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid navigation URL: $actionUrl')),
        );
        return;
      }

      // Validate route based on user role
      final userRole = _userRole ?? userProvider.userType;
      final isValidRoute = _isRouteValidForRole(actionUrl, userRole);

      if (!isValidRoute) {
        print('⚠️ Route $actionUrl not valid for role: $userRole');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You do not have access to this page'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      print('🔀 Navigating to: $actionUrl (role: $userRole)');
      Navigator.of(context).pushNamed(actionUrl);
    } catch (e) {
      print('❌ Error navigating to $actionUrl: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Navigation error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  bool _isRouteValidForRole(String route, String? userRole) {
    if (userRole == null) return false;

    // Parse route
    final uri = Uri.parse(route);
    final segments = uri.pathSegments;
    
    if (segments.isEmpty) return true;

    final firstSegment = segments[0];

    // Check role-based access
    switch (firstSegment) {
      case 'admin':
        return userRole == 'admin';
      case 'guru':
        return userRole == 'guru';
      case 'siswa':
        return userRole == 'siswa';
      case 'notifications':
      case 'profile':
      case 'settings':
        return true; // Accessible by all roles
      default:
        return true; // Allow other routes
    }
  }

  void _showActionSheet(NotificationModel notification) {
    if (notification.actions == null || notification.actions!.isEmpty) return;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                notification.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ...notification.actions!.map((action) {
                return ListTile(
                  leading: const Icon(Icons.touch_app),
                  title: Text(action['label'] ?? 'Action'),
                  onTap: () {
                    Navigator.pop(context);
                    
                    // Track action
                    if (_userId != null) {
                      _notificationBloc.add(TrackNotificationAction(
                        userId: _userId!,
                        notificationId: notification.id,
                        actionId: action['id'] ?? '',
                      ));
                    }

                    // Navigate
                    final route = action['route'];
                    if (route != null && route.isNotEmpty) {
                      _handleNavigation(route);
                    }
                  },
                );
              }).toList(),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _markAllAsRead(BuildContext context) {
    if (_userId != null && _userRole != null) {
      _notificationBloc.add(MarkAllAsRead(
        userId: _userId!,
        role: _userRole!,
      ));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All notifications marked as read')),
      );
    }
  }

  void _showDeleteAllDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete All Notifications'),
        content: const Text(
          'Are you sure you want to delete all notifications? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (_userId != null && _userRole != null) {
                _notificationBloc.add(DeleteAllNotifications(
                  userId: _userId!,
                  role: _userRole!,
                ));
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('All notifications deleted'),
                  ),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete All'),
          ),
        ],
      ),
    );
  }
}
