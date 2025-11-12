import 'package:flutter/material.dart';

class MapsLocationHome extends StatelessWidget {
  const MapsLocationHome({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Maps & Location'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'المقدمة'),
              Tab(text: 'Google Maps'),
              Tab(text: 'Geolocator'),
              Tab(text: 'Geocoding'),
              Tab(text: 'Directions'),
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
