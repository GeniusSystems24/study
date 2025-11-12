import 'package:flutter/material.dart';

class FirebaseHome extends StatelessWidget {
  const FirebaseHome({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Firebase'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'المقدمة'),
              Tab(text: 'Authentication'),
              Tab(text: 'Firestore'),
              Tab(text: 'Storage'),
              Tab(text: 'Push Notifications'),
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
