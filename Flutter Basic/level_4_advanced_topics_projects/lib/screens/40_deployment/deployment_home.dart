import 'package:flutter/material.dart';

class DeploymentHome extends StatelessWidget {
  const DeploymentHome({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 7,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Deployment'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'المقدمة'),
              Tab(text: 'App Icon & Splash'),
              Tab(text: 'Build & Release'),
              Tab(text: 'Play Store'),
              Tab(text: 'App Store'),
              Tab(text: 'CI/CD'),
              Tab(text: 'Best Practices'),
            ],
          ),
        ),
        body: const Center(
          child: Text('قيد التطوير - Coming Soon'),
        ),
      ),
    );
  }
}
