import 'package:flutter/material.dart';

class AccessibilityScreen extends StatelessWidget {
  const AccessibilityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Accessibility - إمكانية الوصول')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildHeader(context, '♿ Semantics Widget'),
          _buildSemanticsExample(),
          const SizedBox(height: 24),
          
          _buildHeader(context, '🔇 ExcludeSemantics'),
          _buildExcludeSemanticsExample(),
          const SizedBox(height: 24),
          
          _buildHeader(context, '🔗 MergeSemantics'),
          _buildMergeSemanticsExample(),
          const SizedBox(height: 24),
          
          _buildHeader(context, '✅ Best Practices'),
          _buildBestPractices(),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildSemanticsExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'مثال: إضافة معلومات دلالية لصورة',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            // بدون Semantics
            const Text('بدون Semantics:'),
            const SizedBox(height: 8),
            Container(
              width: 100,
              height: 100,
              color: Colors.blue,
              child: const Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 16),
            
            // مع Semantics
            const Text('مع Semantics (جرب قارئ الشاشة):'),
            const SizedBox(height: 8),
            Semantics(
              label: 'صورة شخصية للمستخدم أحمد',
              hint: 'انقر لعرض الملف الشخصي',
              button: true,
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  width: 100,
                  height: 100,
                  color: Colors.green,
                  child: const Icon(Icons.person, size: 50, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExcludeSemanticsExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'استبعاد عناصر زخرفية من قارئ الشاشة',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                // أيقونة زخرفية مستبعدة
                ExcludeSemantics(
                  child: Icon(Icons.star, color: Colors.amber, size: 30),
                ),
                const SizedBox(width: 12),
                // النص المهم
                const Expanded(
                  child: Text('هذا نص مهم، الأيقونة الزخرفية مستبعدة من قارئ الشاشة'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMergeSemanticsExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'دمج معلومات عدة عناصر',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            MergeSemantics(
              child: ListTile(
                leading: const Icon(Icons.email),
                title: const Text('رسالة جديدة'),
                subtitle: const Text('من: محمد - قبل 5 دقائق'),
                trailing: const Icon(Icons.arrow_forward_ios),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'قارئ الشاشة سيقرأ: "رسالة جديدة، من: محمد - قبل 5 دقائق"',
              style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBestPractices() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            ListTile(
              leading: Icon(Icons.check_circle, color: Colors.green),
              title: Text('استخدم Semantics لجميع العناصر التفاعلية'),
            ),
            ListTile(
              leading: Icon(Icons.check_circle, color: Colors.green),
              title: Text('أضف labels واضحة ووصفية'),
            ),
            ListTile(
              leading: Icon(Icons.check_circle, color: Colors.green),
              title: Text('استبعد العناصر الزخرفية بـ ExcludeSemantics'),
            ),
            ListTile(
              leading: Icon(Icons.check_circle, color: Colors.green),
              title: Text('اختبر التطبيق مع قارئ الشاشة'),
            ),
            ListTile(
              leading: Icon(Icons.check_circle, color: Colors.green),
              title: Text('حافظ على نسبة تباين ألوان 4.5:1 على الأقل'),
            ),
          ],
        ),
      ),
    );
  }
}
