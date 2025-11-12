import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import 'core/theme/app_theme.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(
    // Riverpod ProviderScope في الأعلى
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Theme Mode State
  bool _isDarkMode = false;

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    // استخدام GetMaterialApp بدلاً من MaterialApp لدعم GetX
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'State Management Project',
      
      // الثيمات
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      
      // الصفحة الرئيسية
      home: HomeScreen(
        isDarkMode: _isDarkMode,
        onThemeToggle: _toggleTheme,
      ),
      
      // GetX Translations (اختياري)
      // translations: AppTranslations(),
      // locale: const Locale('ar', 'SA'),
      // fallbackLocale: const Locale('en', 'US'),
    );
  }
}
