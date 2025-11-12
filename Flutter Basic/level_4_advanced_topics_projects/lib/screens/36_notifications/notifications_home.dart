import 'package:flutter/material.dart';

class NotificationsHome extends StatelessWidget {
  const NotificationsHome({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Notifications'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'المقدمة'),
              Tab(text: 'Local Notifications'),
              Tab(text: 'Push Notifications'),
              Tab(text: 'Scheduling'),
              Tab(text: 'Actions'),
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
