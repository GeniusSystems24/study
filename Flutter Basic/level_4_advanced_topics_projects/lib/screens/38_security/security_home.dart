import 'package:flutter/material.dart';

class SecurityHome extends StatelessWidget {
  const SecurityHome({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Security'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'المقدمة'),
              Tab(text: 'Encryption'),
              Tab(text: 'Biometric Auth'),
              Tab(text: 'Secure Storage'),
              Tab(text: 'SSL Pinning'),
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
