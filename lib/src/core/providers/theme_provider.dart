import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider untuk mengelola theme mode (dark/light)
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier();
});

/// Notifier untuk mengubah theme mode
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.system);

  /// Toggle antara dark dan light mode
  void toggleTheme() {
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }

  /// Set theme mode secara langsung
  void setThemeMode(ThemeMode mode) {
    state = mode;
  }

  /// Reset ke system theme
  void resetToSystem() {
    state = ThemeMode.system;
  }
}
