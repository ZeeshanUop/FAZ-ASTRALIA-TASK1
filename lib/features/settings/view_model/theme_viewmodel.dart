import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../../core/app_theme.dart';
import '../../../core/constant.dart';

class ThemeViewModel extends ChangeNotifier {
  bool _isDark = false;
  Color _seedColor = AppTheme.presetSeeds.first;

  bool get isDark => _isDark;
  Color get seedColor => _seedColor;

  ThemeData get theme =>
      _isDark ? AppTheme.dark(_seedColor) : AppTheme.light(_seedColor);

  Future<void> load() async {
    final box = Hive.box(AppConstants.settingsBox);

    // Load saved values
    _isDark = box.get('isDark', defaultValue: false) as bool;

    final seedIndex = box.get('seedIndex', defaultValue: 0) as int;
    if (seedIndex >= 0 && seedIndex < AppTheme.presetSeeds.length) {
      _seedColor = AppTheme.presetSeeds[seedIndex];
    } else {
      _seedColor = AppTheme.presetSeeds.first;
    }

    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDark = !_isDark;
    final box = Hive.box(AppConstants.settingsBox);
    await box.put('isDark', _isDark);
    notifyListeners();
  }

  Future<void> setSeed(Color seed) async {
    _seedColor = seed;
    final box = Hive.box(AppConstants.settingsBox);

    // ✅ Make sure we don’t store -1
    final index = AppTheme.presetSeeds.indexOf(seed);
    await box.put('seedIndex', index == -1 ? 0 : index);

    notifyListeners();
  }
}

