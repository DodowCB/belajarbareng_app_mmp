import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationPreferences {
  final bool enableTugasNotif;
  final bool enableQuizNotif;
  final bool enableQnaNotif;
  final bool enablePengumumanNotif;
  final bool enableNilaiNotif;
  final bool enableDeadlineReminder;
  final bool enableUserManagementNotif; // For admin

  const NotificationPreferences({
    this.enableTugasNotif = true,
    this.enableQuizNotif = true,
    this.enableQnaNotif = true,
    this.enablePengumumanNotif = true,
    this.enableNilaiNotif = true,
    this.enableDeadlineReminder = true,
    this.enableUserManagementNotif = true,
  });

  // Default preferences
  static const NotificationPreferences defaultPreferences =
      NotificationPreferences();

  // Copy with
  NotificationPreferences copyWith({
    bool? enableTugasNotif,
    bool? enableQuizNotif,
    bool? enableQnaNotif,
    bool? enablePengumumanNotif,
    bool? enableNilaiNotif,
    bool? enableDeadlineReminder,
    bool? enableUserManagementNotif,
  }) {
    return NotificationPreferences(
      enableTugasNotif: enableTugasNotif ?? this.enableTugasNotif,
      enableQuizNotif: enableQuizNotif ?? this.enableQuizNotif,
      enableQnaNotif: enableQnaNotif ?? this.enableQnaNotif,
      enablePengumumanNotif:
          enablePengumumanNotif ?? this.enablePengumumanNotif,
      enableNilaiNotif: enableNilaiNotif ?? this.enableNilaiNotif,
      enableDeadlineReminder:
          enableDeadlineReminder ?? this.enableDeadlineReminder,
      enableUserManagementNotif:
          enableUserManagementNotif ?? this.enableUserManagementNotif,
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'enableTugasNotif': enableTugasNotif,
      'enableQuizNotif': enableQuizNotif,
      'enableQnaNotif': enableQnaNotif,
      'enablePengumumanNotif': enablePengumumanNotif,
      'enableNilaiNotif': enableNilaiNotif,
      'enableDeadlineReminder': enableDeadlineReminder,
      'enableUserManagementNotif': enableUserManagementNotif,
    };
  }

  // From JSON
  factory NotificationPreferences.fromJson(Map<String, dynamic> json) {
    return NotificationPreferences(
      enableTugasNotif: json['enableTugasNotif'] ?? true,
      enableQuizNotif: json['enableQuizNotif'] ?? true,
      enableQnaNotif: json['enableQnaNotif'] ?? true,
      enablePengumumanNotif: json['enablePengumumanNotif'] ?? true,
      enableNilaiNotif: json['enableNilaiNotif'] ?? true,
      enableDeadlineReminder: json['enableDeadlineReminder'] ?? true,
      enableUserManagementNotif: json['enableUserManagementNotif'] ?? true,
    );
  }

  // Save to SharedPreferences
  Future<bool> save(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'notification_preferences_$userId';
      return await prefs.setString(key, jsonEncode(toJson()));
    } catch (e) {
      print('Error saving notification preferences: $e');
      return false;
    }
  }

  // Load from SharedPreferences
  static Future<NotificationPreferences> load(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'notification_preferences_$userId';
      final jsonString = prefs.getString(key);

      if (jsonString == null) {
        return NotificationPreferences.defaultPreferences;
      }

      return NotificationPreferences.fromJson(jsonDecode(jsonString));
    } catch (e) {
      print('Error loading notification preferences: $e');
      return NotificationPreferences.defaultPreferences;
    }
  }

  // Clear preferences
  static Future<bool> clear(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'notification_preferences_$userId';
      return await prefs.remove(key);
    } catch (e) {
      print('Error clearing notification preferences: $e');
      return false;
    }
  }
}
