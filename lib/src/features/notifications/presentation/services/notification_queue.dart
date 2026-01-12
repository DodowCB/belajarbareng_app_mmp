import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class NotificationQueue {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final List<Map<String, dynamic>> _queue = [];
  bool _isProcessing = false;

  static const String _queueKey = 'notification_queue';

  // Singleton
  static final NotificationQueue _instance = NotificationQueue._internal();
  factory NotificationQueue() => _instance;
  NotificationQueue._internal() {
    _loadQueueFromLocal();
  }

  /// Add notification to queue
  Future<void> enqueue(Map<String, dynamic> notification) async {
    _queue.add(notification);
    await _saveQueueToLocal();

    if (!_isProcessing) {
      _processQueue();
    }
  }

  /// Process queue - send pending notifications
  Future<void> _processQueue() async {
    if (_isProcessing || _queue.isEmpty) return;

    _isProcessing = true;

    while (_queue.isNotEmpty) {
      // Check connectivity
      if (!await _hasConnection()) {
        print('No connection, stopping queue processing');
        break;
      }

      final notification = _queue.first;

      try {
        // Send to Firestore
        await _firestore.collection('notifications').add(notification);
        print('Notification sent from queue: ${notification['title']}');

        // Remove from queue
        _queue.removeAt(0);
        await _saveQueueToLocal();
      } catch (e) {
        print('Failed to send notification from queue: $e');
        break; // Stop processing on error
      }
    }

    _isProcessing = false;
  }

  /// Check internet connectivity
  Future<bool> _hasConnection() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      return connectivityResult != ConnectivityResult.none;
    } catch (e) {
      print('Error checking connectivity: $e');
      return false;
    }
  }

  /// Save queue to local storage
  Future<void> _saveQueueToLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_queueKey, jsonEncode(_queue));
    } catch (e) {
      print('Error saving queue to local: $e');
    }
  }

  /// Load queue from local storage
  Future<void> _loadQueueFromLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final queueJson = prefs.getString(_queueKey);

      if (queueJson != null) {
        final List<dynamic> decoded = jsonDecode(queueJson);
        _queue.clear();
        _queue.addAll(decoded.cast<Map<String, dynamic>>());
        print('Loaded ${_queue.length} notifications from local queue');

        // Try to process queue
        _processQueue();
      }
    } catch (e) {
      print('Error loading queue from local: $e');
    }
  }

  /// Clear queue
  Future<void> clear() async {
    _queue.clear();
    await _saveQueueToLocal();
  }

  /// Get queue size
  int get size => _queue.length;

  /// Check if queue is being processed
  bool get isProcessing => _isProcessing;

  /// Force retry processing queue
  Future<void> retryProcessing() async {
    if (!_isProcessing && _queue.isNotEmpty) {
      await _processQueue();
    }
  }
}
