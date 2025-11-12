import 'package:flutter/material.dart';

/// شاشة توضيحية لـ ScrollView Widgets (الموضوع 15)
class ScrollViewWidgetsDemo extends StatelessWidget {
  const ScrollViewWidgetsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('15. ScrollView Widgets'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'ListView'),
              Tab(text: 'GridView'),
              Tab(text: 'PageView'),
              Tab(text: 'Custom'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildListViewTab(),
            _buildGridViewTab(),
            _buildPageViewTab(),
            _buildCustomScrollView(),
          ],
        ),
      ),
    );
  }

  Widget _buildListViewTab() {
    return ListView.builder(
      itemCount: 30,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.primaries[index % Colors.primaries.length],
            child: Text('${index + 1}'),
          ),
          title: Text('عنصر ${index + 1}'),
          subtitle: Text('هذا هو الوصف للعنصر رقم ${index + 1}'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {},
        );
      },
    );
  }

  Widget _buildGridViewTab() {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: 30,
      itemBuilder: (context, index) {
        return Card(
          color: Colors.primaries[index % Colors.primaries.length][100],
          child: Center(
            child: Text(
              '${index + 1}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPageViewTab() {
    return PageView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          color: Colors.primaries[index][100],
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _getPageIcon(index),
                  size: 100,
                  color: Colors.primaries[index],
                ),
                const SizedBox(height: 24),
                Text(
                  'صفحة ${index + 1}',
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text('اسحب لليمين أو اليسار'),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCustomScrollView() {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 200,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: const Text('Custom ScrollView'),
            background: Image.network(
              'https://picsum.photos/800/400',
              fit: BoxFit.cover,
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => ListTile(
              title: Text('عنصر $index'),
            ),
            childCount: 20,
          ),
        ),
      ],
    );
  }

  IconData _getPageIcon(int index) {
    const icons = [
      Icons.home,
      Icons.favorite,
      Icons.star,
      Icons.settings,
      Icons.person,
    ];
    return icons[index];
  }
}
