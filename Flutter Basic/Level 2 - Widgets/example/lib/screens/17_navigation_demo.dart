import 'package:flutter/material.dart';

/// شاشة توضيحية للـ Navigation (الموضوع 17)
class NavigationDemo extends StatelessWidget {
  const NavigationDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('17. Navigation'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Navigator.push/pop
          _buildCard(
            'Navigator.push/pop',
            'الانتقال إلى صفحة جديدة والعودة',
            Icons.arrow_forward,
            Colors.blue,
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SecondScreen(title: 'صفحة جديدة'),
              ),
            ),
          ),

          // تمرير البيانات
          _buildCard(
            'تمرير البيانات',
            'إرسال بيانات إلى الصفحة التالية',
            Icons.send,
            Colors.green,
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SecondScreen(
                  title: 'صفحة مع بيانات',
                  data: 'هذه بيانات تم تمريرها من الصفحة السابقة',
                ),
              ),
            ),
          ),

          // استقبال البيانات
          _buildCard(
            'استقبال البيانات',
            'استقبال بيانات عند العودة من صفحة',
            Icons.reply,
            Colors.orange,
            () async {
              final result = await Navigator.push<String>(
                context,
                MaterialPageRoute(
                  builder: (context) => const DataReturnScreen(),
                ),
              );
              if (context.mounted && result != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('البيانات المستلمة: $result')),
                );
              }
            },
          ),

          // Hero Animation
          _buildCard(
            'Hero Animation',
            'انتقال سلس مع مشاركة عنصر',
            Icons.favorite,
            Colors.red,
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HeroAnimationScreen(),
              ),
            ),
          ),

          // Named Routes
          _buildCard(
            'Named Routes',
            'التنقل باستخدام أسماء الصفحات',
            Icons.route,
            Colors.purple,
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Named Routes تتطلب إعداداً في MaterialApp'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCard(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}

// صفحة ثانية
class SecondScreen extends StatelessWidget {
  final String title;
  final String? data;

  const SecondScreen({super.key, required this.title, this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            if (data != null) ...[
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(data!, textAlign: TextAlign.center),
              ),
            ],
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('العودة'),
            ),
          ],
        ),
      ),
    );
  }
}

// صفحة لإرجاع البيانات
class DataReturnScreen extends StatelessWidget {
  const DataReturnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('اختر خياراً'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context, 'الخيار 1'),
              child: const Text('الخيار 1'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, 'الخيار 2'),
              child: const Text('الخيار 2'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, 'الخيار 3'),
              child: const Text('الخيار 3'),
            ),
          ],
        ),
      ),
    );
  }
}

// صفحة Hero Animation
class HeroAnimationScreen extends StatelessWidget {
  const HeroAnimationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hero Animation'),
      ),
      body: Center(
        child: Hero(
          tag: 'hero-icon',
          child: Container(
            width: 200,
            height: 200,
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.favorite, size: 100, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
