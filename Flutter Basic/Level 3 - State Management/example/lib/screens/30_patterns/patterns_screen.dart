import 'package:flutter/material.dart';

/// شاشة أفضل الممارسات والأنماط - الموضوع 30
class PatternsScreen extends StatelessWidget {
  const PatternsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Best Practices & Patterns'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '🎓 أفضل الممارسات والأنماط',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'تعلم أفضل الممارسات لإدارة الحالة والأنماط المعمارية الشائعة.',
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Clean Architecture
          _buildPatternCard(
            context,
            title: 'Clean Architecture',
            icon: Icons.layers,
            color: Colors.blue,
            description: 'فصل الكود إلى طبقات واضحة',
            layers: [
              'Presentation Layer - UI',
              'Domain Layer - Business Logic',
              'Data Layer - Data Sources',
            ],
          ),
          
          const SizedBox(height: 16),
          
          // MVVM Pattern
          _buildPatternCard(
            context,
            title: 'MVVM Pattern',
            icon: Icons.view_column,
            color: Colors.green,
            description: 'Model-View-ViewModel',
            layers: [
              'Model - البيانات',
              'View - الواجهة (Widgets)',
              'ViewModel - Logic (Provider/BLoC)',
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Repository Pattern
          _buildPatternCard(
            context,
            title: 'Repository Pattern',
            icon: Icons.storage,
            color: Colors.orange,
            description: 'فصل Data Sources عن Business Logic',
            layers: [
              'Repository Interface',
              'Repository Implementation',
              'Data Sources (API, Local DB)',
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Best Practices
          Card(
            color: Colors.purple.withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.lightbulb, color: Colors.purple, size: 32),
                      const SizedBox(width: 12),
                      Text(
                        'أفضل الممارسات',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  const Text('1️⃣ اختر الحل المناسب للمشروع',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const Text('   • صغير → setState أو GetX'),
                  const Text('   • متوسط → Provider'),
                  const Text('   • كبير → BLoC أو Riverpod'),
                  const SizedBox(height: 12),
                  
                  const Text('2️⃣ افصل UI عن Business Logic',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const Text('   • استخدم MVVM أو Clean Architecture'),
                  const Text('   • لا تضع logic في Widgets'),
                  const SizedBox(height: 12),
                  
                  const Text('3️⃣ استخدم Immutable State',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const Text('   • لا تعدل state مباشرة'),
                  const Text('   • أنشئ نسخة جديدة'),
                  const SizedBox(height: 12),
                  
                  const Text('4️⃣ اكتب Tests',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const Text('   • Unit tests للـ logic'),
                  const Text('   • Widget tests للـ UI'),
                  const SizedBox(height: 12),
                  
                  const Text('5️⃣ استخدم Dependency Injection',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const Text('   • سهل Testing'),
                  const Text('   • كود أكثر مرونة'),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Common Mistakes
          Card(
            color: Colors.red.withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.warning, color: Colors.red, size: 32),
                      const SizedBox(width: 12),
                      Text(
                        'أخطاء شائعة',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  const Text('❌ استخدام setState للـ App State'),
                  const SizedBox(height: 8),
                  const Text('❌ وضع Business Logic في Widgets'),
                  const SizedBox(height: 8),
                  const Text('❌ عدم فصل Concerns'),
                  const SizedBox(height: 8),
                  const Text('❌ تعديل State مباشرة'),
                  const SizedBox(height: 8),
                  const Text('❌ عدم كتابة Tests'),
                  const SizedBox(height: 8),
                  const Text('❌ استخدام Global State بكثرة'),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Performance Tips
          Card(
            color: Colors.green.withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.speed, color: Colors.green, size: 32),
                      const SizedBox(width: 12),
                      Text(
                        'نصائح للأداء',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  const Text('✓ استخدم const Widgets حيثما أمكن'),
                  const SizedBox(height: 8),
                  const Text('✓ استخدم Selector/Consumer بذكاء'),
                  const SizedBox(height: 8),
                  const Text('✓ تجنب rebuilds غير الضرورية'),
                  const SizedBox(height: 8),
                  const Text('✓ استخدم Keys للـ Lists'),
                  const SizedBox(height: 8),
                  const Text('✓ استخدم ListView.builder للقوائم الطويلة'),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Summary
          Card(
            color: Colors.amber.withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.bookmark, color: Colors.amber, size: 32),
                      const SizedBox(width: 12),
                      Text(
                        'خلاصة',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  const Text(
                    'لا يوجد "أفضل" حل لإدارة الحالة. '
                    'كل حل مناسب لحالة استخدام معينة.\n\n'
                    'المهم:\n'
                    '• افهم المشكلة أولاً\n'
                    '• اختر الحل المناسب\n'
                    '• اتبع أفضل الممارسات\n'
                    '• اكتب كود نظيف وقابل للاختبار\n'
                    '• استمر في التعلم!',
                    style: TextStyle(height: 1.5),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildPatternCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required String description,
    required List<String> layers,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 32),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            ...layers.asMap().entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          '${entry.key + 1}',
                          style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Text(entry.value)),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
