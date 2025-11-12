import 'package:flutter/material.dart';

class FilesMediaHome extends StatelessWidget {
  const FilesMediaHome({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Files & Media'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'المقدمة'),
              Tab(text: 'Camera'),
              Tab(text: 'Image Picker'),
              Tab(text: 'File Picker'),
              Tab(text: 'Path Provider'),
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
