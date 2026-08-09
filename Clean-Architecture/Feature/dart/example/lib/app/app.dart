import 'package:flutter/material.dart';

import '../features/auth/presentation/pages/login_page.dart';
import 'app_dependencies.dart';

class CleanArchitectureApp extends StatefulWidget {
  const CleanArchitectureApp({super.key, required this.dependencies});
  final AppDependencies dependencies;

  @override
  State<CleanArchitectureApp> createState() => _CleanArchitectureAppState();
}

class _CleanArchitectureAppState extends State<CleanArchitectureApp> {
  @override
  void dispose() {
    widget.dependencies.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Clean Architecture Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0B2A4A)),
        useMaterial3: true,
        inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder()),
      ),
      home: LoginPage(
        authController: widget.dependencies.authController,
        notificationController: widget.dependencies.notificationController,
      ),
    );
  }
}
