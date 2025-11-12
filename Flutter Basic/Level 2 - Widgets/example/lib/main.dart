import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const FlutterWidgetsGalleryApp());
}

class FlutterWidgetsGalleryApp extends StatefulWidget {
  const FlutterWidgetsGalleryApp({super.key});

  @override
  State<FlutterWidgetsGalleryApp> createState() =>
      _FlutterWidgetsGalleryAppState();
}

class _FlutterWidgetsGalleryAppState extends State<FlutterWidgetsGalleryApp> {
  bool _isDarkMode = false;

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Widgets Gallery',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: HomeScreen(
        isDarkMode: _isDarkMode,
        onThemeToggle: _toggleTheme,
      ),
    );
  }
}
