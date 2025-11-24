import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

/// Service untuk mengelola status koneksi internet
/// Mengecek apakah device online atau offline dengan ping test yang sebenarnya
class ConnectivityService extends ChangeNotifier {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  Timer? _pingTimer;

  bool _isOnline = true;
  bool get isOnline => _isOnline;
  bool get isOffline => !_isOnline;

  int _consecutiveFailures = 0;
  static const int _maxFailures = 5;
  bool _wasOfflineDueToMaxFailures = false;

  /// Initialize connectivity monitoring
  Future<void> initialize() async {
    // Check initial connectivity status with ping test
    await _updateConnectionStatus();

    // Listen to connectivity changes
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) async {
      await _updateConnectionStatusFromResults(results);
    });

    // Start periodic ping test every 10 seconds
    _startPeriodicPingTest();
  }

  /// Start periodic ping test to verify real internet connection
  void _startPeriodicPingTest() {
    _pingTimer?.cancel();
    _pingTimer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      debugPrint(
        '🔍 Performing periodic connectivity test... (failures: $_consecutiveFailures/$_maxFailures)',
      );
      await _performPingTest();
    });
  }

  /// Update connection status by checking current connectivity
  Future<void> _updateConnectionStatus() async {
    try {
      final List<ConnectivityResult> results = await _connectivity
          .checkConnectivity();
      await _updateConnectionStatusFromResults(results);
    } catch (e) {
      debugPrint('Error checking connectivity: $e');
      _updateOnlineStatus(false);
    }
  }

  /// Update connection status from connectivity results with ping test
  Future<void> _updateConnectionStatusFromResults(
    List<ConnectivityResult> results,
  ) async {
    bool hasNetworkConnection = false;

    for (final result in results) {
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi ||
          result == ConnectivityResult.ethernet ||
          result == ConnectivityResult.vpn) {
        hasNetworkConnection = true;
        break;
      }
    }

    if (hasNetworkConnection) {
      // If network connection exists, perform ping test to verify internet
      await _performPingTest();
    } else {
      // No network connection at all
      _updateOnlineStatus(false);
    }
  }

  /// Perform actual ping test to verify internet connectivity
  Future<void> _performPingTest() async {
    try {
      // Try multiple endpoints for reliability - Use CORS-friendly endpoints for web
      final List<String> testUrls = [
        'https://firestore.googleapis.com/',
        'https://www.google.com/generate_204', // Google's connectivity check endpoint
        'https://httpbin.org/status/200', // Always returns 200 OK
        'https://jsonplaceholder.typicode.com/posts/1', // Free API endpoint
      ];

      bool hasInternet = false;

      for (String url in testUrls) {
        try {
          // debugPrint('🔍 Testing connectivity to: $url');
          final response = await http
              .get(
                Uri.parse(url),
                headers: {
                  'User-Agent': 'ConnectivityCheck',
                  'Accept': '*/*',
                  'Cache-Control': 'no-cache',
                },
              )
              .timeout(const Duration(seconds: 5));

          // Accept various success status codes
          if (response.statusCode >= 200 && response.statusCode < 300) {
            hasInternet = true;
            _consecutiveFailures = 0; // Reset counter on success
            debugPrint(
              '✅ Successfully connected to: $url (Status: ${response.statusCode})',
            );
            break;
          }
        } catch (e) {
          debugPrint('❌ Failed to connect to $url: ${e.toString()}');
          continue;
        }
      }

      // If standard endpoints fail, try Firebase-specific test
      if (!hasInternet) {
        debugPrint(
          '🔥 Standard endpoints failed, testing Firebase connectivity...',
        );
        hasInternet = await _testFirebaseConnectivity();
      }

      if (!hasInternet) {
        if (_consecutiveFailures < _maxFailures) {
          _consecutiveFailures++;
        }
        debugPrint(
          '🔴 Consecutive failures: $_consecutiveFailures/$_maxFailures',
        );

        if (_consecutiveFailures >= _maxFailures) {
          debugPrint('🚨 Max failures reached! Switching to OFFLINE mode');
          hasInternet = false;
          // Force notify listeners when switching to offline due to max failures
          _wasOfflineDueToMaxFailures = true;
        }
      } else {
        // Reset failure counter on successful connection
        if (_consecutiveFailures > 0) {
          debugPrint('🎉 Connection restored! Resetting failure counter');
          _consecutiveFailures = 0;
          _wasOfflineDueToMaxFailures = false;
        }
      }

      _updateOnlineStatus(hasInternet);
    } catch (e) {
      if (_consecutiveFailures < _maxFailures) {
        _consecutiveFailures++;
      }
      debugPrint('Ping test failed: $e');
      debugPrint(
        '🔴 Consecutive failures: $_consecutiveFailures/$_maxFailures',
      );
      _updateOnlineStatus(false);
    }
  }

  /// Test Firebase-specific connectivity
  Future<bool> _testFirebaseConnectivity() async {
    try {
      // Try a simple Firestore operation to test real Firebase connectivity
      debugPrint('🔥 Testing Firebase Firestore connectivity...');

      final firestore = FirebaseFirestore.instance;

      // Try to get a simple document or collection count with timeout
      await firestore
          .collection('_test_connection')
          .limit(1)
          .get()
          .timeout(const Duration(seconds: 5));

      debugPrint('✅ Firebase Firestore connection successful!');
      return true;
    } catch (e) {
      debugPrint('❌ Firebase Firestore connection failed: $e');
      return false;
    }
  }

  /// Update online status and notify listeners
  void _updateOnlineStatus(bool isConnected) {
    if (_isOnline != isConnected) {
      _isOnline = isConnected;

      if (isConnected) {
        _consecutiveFailures = 0; // Reset counter when back online
        debugPrint('🌐 ✅ BACK ONLINE! Consecutive failures reset to 0');
      }

      notifyListeners();
      debugPrint(
        '🌐 Internet connectivity changed: ${_isOnline ? 'ONLINE' : 'OFFLINE'}',
      );
      debugPrint('🌐 Status updated at: ${DateTime.now()}');
    }
  }

  /// Manually refresh connectivity status
  Future<void> refreshConnectivity() async {
    await _updateConnectionStatus();
  }

  /// Get connection type as string for display
  Future<String> getConnectionType() async {
    try {
      final List<ConnectivityResult> results = await _connectivity
          .checkConnectivity();
      if (results.isEmpty || results.contains(ConnectivityResult.none)) {
        return 'Offline';
      }

      // Return the first active connection type
      for (final result in results) {
        switch (result) {
          case ConnectivityResult.wifi:
            return 'WiFi';
          case ConnectivityResult.mobile:
            return 'Mobile Data';
          case ConnectivityResult.ethernet:
            return 'Ethernet';
          case ConnectivityResult.vpn:
            return 'VPN';
          case ConnectivityResult.bluetooth:
            return 'Bluetooth';
          case ConnectivityResult.other:
            return 'Other';
          case ConnectivityResult.none:
            continue;
        }
      }

      return 'Unknown';
    } catch (e) {
      debugPrint('Error getting connection type: $e');
      return 'Unknown';
    }
  }

  /// Dispose resources
  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    _pingTimer?.cancel();
    super.dispose();
  }
}

/// Extension untuk kemudahan penggunaan
extension ConnectivityServiceExtension on ConnectivityService {
  /// Check if device has internet connection
  bool get hasConnection => isOnline;

  /// Check if device is disconnected
  bool get hasNoConnection => isOffline;

  /// Get status as string
  String get statusText => isOnline ? 'Online' : 'Offline';

  /// Get status icon
  String get statusIcon => isOnline ? '🟢' : '🔴';
}
