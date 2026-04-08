import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Manages the app's theme mode (light/dark) with persistence via Hive.
class ThemeCubit extends Cubit<ThemeMode> {
  static const String _boxName = 'settings';
  static const String _themeKey = 'dark_mode';

  ThemeCubit() : super(_loadInitial());

  static ThemeMode _loadInitial() {
    final box = Hive.box<bool>(_boxName);
    final isDark = box.get(_themeKey, defaultValue: false)!;
    return isDark ? ThemeMode.dark : ThemeMode.light;
  }

  void toggleTheme() {
    final next = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    Hive.box<bool>(_boxName).put(_themeKey, next == ThemeMode.dark);
    emit(next);
  }

  bool get isDark => state == ThemeMode.dark;
}
