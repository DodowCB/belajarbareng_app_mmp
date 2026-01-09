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

  bool _isOnline = false; // Start as offline until first ping test completes
  bool get isOnline => _isOnline;
  bool get isOffline => !_isOnline;

  int _consecutiveFailures = 0;
  int _consecutiveSuccesses = 0;
  static const int _maxFailures = 5;
  static const int _failuresToGoOffline = 3; // Go offline after 3 failures
  static const int _successesToGoOnline = 2; // Require 2 successes to go online
  bool _wasOfflineDueToMaxFailures = false;

  // Debounce timer for status changes
  Timer? _statusChangeDebounceTimer;
  bool _pendingOnlineStatus = false; // Start as offline until verified

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
    _pingTimer = Timer.periodic(const Duration(seconds: 10), (timer) async {
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
      final List<String> testUrls = kIsWeb
          ? [
              'https://jsonplaceholder.typicode.com/posts/1', // CORS-friendly
              'https://httpbin.org/status/200', // CORS-friendly
              'https://api.github.com/zen', // CORS-friendly
            ]
          : [
              'https://www.google.com/generate_204',
              'https://firestore.googleapis.com/',
              'https://jsonplaceholder.typicode.com/posts/1',
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
              .timeout(
                const Duration(seconds: 3),
                onTimeout: () {
                  throw TimeoutException('Connection timeout');
                },
              );

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

      // If standard endpoints fail and we're not web platform, try Firebase-specific test
      // Skip Firebase test for web to avoid false positives from CORS issues
      // Also skip if already in offline mode (consecutiveFailures >= failuresToGoOffline)
      if (!hasInternet &&
          !kIsWeb &&
          _consecutiveFailures < _failuresToGoOffline) {
        debugPrint(
          '🔥 Standard endpoints failed, testing Firebase connectivity...',
        );
        hasInternet = await _testFirebaseConnectivity();
      }

      if (!hasInternet) {
        if (_consecutiveFailures < _maxFailures) {
          _consecutiveFailures++;
        }
        _consecutiveSuccesses = 0; // Reset success counter on failure

        debugPrint(
          '🔴 Consecutive failures: $_consecutiveFailures/$_maxFailures',
        );

        // Switch to offline after 3 consecutive failures
        if (_consecutiveFailures >= _failuresToGoOffline) {
          debugPrint(
            '🚨 $_failuresToGoOffline failures reached! Switching to OFFLINE mode',
          );
          hasInternet = false;
          _wasOfflineDueToMaxFailures = true;
        }
      } else {
        // Increment success counter
        _consecutiveSuccesses++;

        // Reset failure counter only after multiple successes
        if (_consecutiveSuccesses >= _successesToGoOnline) {
          if (_consecutiveFailures > 0) {
            debugPrint(
              '🎉 Connection restored! $_consecutiveSuccesses successes confirmed. Resetting failure counter',
            );
          }
          _consecutiveFailures = 0;
          _wasOfflineDueToMaxFailures = false;
        } else {
          debugPrint(
            '✅ Ping success $_consecutiveSuccesses/$_successesToGoOnline (still verifying stability)',
          );
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

      // IMPORTANT: Always use Source.server to ensure real connectivity test
      // Using cache or serverAndCache can return success even when offline
      await firestore
          .collection('kelas')
          .limit(1)
          .get(const GetOptions(source: Source.server))
          .timeout(const Duration(seconds: 3));
      debugPrint('✅ Firebase connection successful!');
      return true;
    } catch (e) {
      debugPrint('❌ Firebase connection failed: $e');
      return false;
    }
  }

  /// Update online status and notify listeners with debouncing
  void _updateOnlineStatus(bool isConnected) {
    // Cancel any pending status change
    _statusChangeDebounceTimer?.cancel();

    // Store pending status
    _pendingOnlineStatus = isConnected;

    // OFFLINE: Apply after meeting failure threshold (handled in _performPingTest)
    // Only apply if we've reached the failure threshold
    if (!isConnected &&
        _isOnline &&
        _consecutiveFailures >= _failuresToGoOffline) {
      _isOnline = false;
      debugPrint(
        '🌐 ❌ OFFLINE MODE ACTIVATED after $_consecutiveFailures failures',
      );
      notifyListeners();
      debugPrint('🌐 Status updated at: ${DateTime.now()}');
      return;
    }

    // ONLINE: Require multiple successes and debounce for stability
    if (isConnected &&
        !_isOnline &&
        _consecutiveSuccesses >= _successesToGoOnline) {
      _statusChangeDebounceTimer = Timer(const Duration(milliseconds: 1500), () {
        if (_pendingOnlineStatus && !_isOnline) {
          _isOnline = true;
          debugPrint(
            '🌐 ✅ BACK ONLINE after $_consecutiveSuccesses verified successes!',
          );
          notifyListeners();
          debugPrint('🌐 Status updated at: ${DateTime.now()}');
        }
      });
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
    _statusChangeDebounceTimer?.cancel();
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
