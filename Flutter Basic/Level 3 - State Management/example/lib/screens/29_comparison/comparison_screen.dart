import 'package:flutter/material.dart';

/// شاشة المقارنة بين الحلول - الموضوع 29
class ComparisonScreen extends StatelessWidget {
  const ComparisonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('State Comparison'),
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
                    '📊 مقارنة شاملة بين حلول State Management',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'كل حل له مزايا وعيوب. اختر الحل المناسب حسب:\n'
                    '• حجم التطبيق\n'
                    '• تعقيد State\n'
                    '• خبرة الفريق\n'
                    '• متطلبات الأداء',
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // جدول المقارنة
          _buildComparisonTable(context),
          
          const SizedBox(height: 16),
          
          // Provider
          _buildSolutionCard(
            context,
            title: 'Provider',
            color: Colors.orange,
            ease: 4,
            performance: 4,
            scalability: 4,
            pros: [
              'سهل التعلم',
              'موصى به من Google',
              'مجتمع كبير',
              'أداء ممتاز',
            ],
            cons: [
              'يعتمد على BuildContext',
              'Boilerplate code متوسط',
            ],
            useCase: 'التطبيقات المتوسطة والكبيرة',
          ),
          
          const SizedBox(height: 16),
          
          // Riverpod
          _buildSolutionCard(
            context,
            title: 'Riverpod',
            color: Colors.purple,
            ease: 3,
            performance: 5,
            scalability: 5,
            pros: [
              'لا يعتمد على BuildContext',
              'Compile-time safety',
              'Testing سهل',
              'أفضل للمشاريع الكبيرة',
            ],
            cons: [
              'منحنى تعلم أعلى قليلاً',
              'مجتمع أصغر من Provider',
            ],
            useCase: 'التطبيقات الكبيرة والمعقدة',
          ),
          
          const SizedBox(height: 16),
          
          // BLoC
          _buildSolutionCard(
            context,
            title: 'BLoC',
            color: Colors.red,
            ease: 2,
            performance: 5,
            scalability: 5,
            pros: [
              'فصل تام بين UI و Logic',
              'Stream-based',
              'Testable جداً',
              'مثالي للفرق الكبيرة',
            ],
            cons: [
              'صعب قليلاً للمبتدئين',
              'Boilerplate code كثير',
            ],
            useCase: 'التطبيقات الكبيرة جداً والمعقدة',
          ),
          
          const SizedBox(height: 16),
          
          // GetX
          _buildSolutionCard(
            context,
            title: 'GetX',
            color: Colors.cyan,
            ease: 5,
            performance: 4,
            scalability: 3,
            pros: [
              'سهل جداً',
              'كود قليل',
              'All-in-one solution',
              'تطوير سريع',
            ],
            cons: [
              'Magic code',
              'صعوبة debugging أحياناً',
              'لا يتبع Flutter guidelines',
            ],
            useCase: 'التطبيقات الصغيرة والمتوسطة، MVP',
          ),
          
          const SizedBox(height: 16),
          
          // Recommendations
          Card(
            color: Colors.green.withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.recommend, color: Colors.green, size: 32),
                      const SizedBox(width: 12),
                      Text(
                        'التوصيات',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text('🌟 للمبتدئين: Provider أو GetX'),
                  const SizedBox(height: 8),
                  const Text('🏢 للشركات الكبيرة: BLoC أو Riverpod'),
                  const SizedBox(height: 8),
                  const Text('⚡ للتطوير السريع: GetX'),
                  const SizedBox(height: 8),
                  const Text('🎯 للتطبيقات المعقدة: BLoC أو Redux'),
                  const SizedBox(height: 8),
                  const Text('📱 للتطبيقات المتوسطة: Provider'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildComparisonTable(BuildContext context) {
    return Card(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('الحل', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('السهولة', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('الأداء', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('القابلية للتوسع', style: TextStyle(fontWeight: FontWeight.bold))),
          ],
          rows: [
            _buildTableRow('setState', '⭐⭐⭐⭐⭐', '⭐⭐⭐⭐', '⭐⭐'),
            _buildTableRow('Provider', '⭐⭐⭐⭐', '⭐⭐⭐⭐', '⭐⭐⭐⭐'),
            _buildTableRow('Riverpod', '⭐⭐⭐', '⭐⭐⭐⭐⭐', '⭐⭐⭐⭐⭐'),
            _buildTableRow('BLoC', '⭐⭐', '⭐⭐⭐⭐⭐', '⭐⭐⭐⭐⭐'),
            _buildTableRow('GetX', '⭐⭐⭐⭐⭐', '⭐⭐⭐⭐', '⭐⭐⭐'),
            _buildTableRow('MobX', '⭐⭐⭐', '⭐⭐⭐⭐', '⭐⭐⭐⭐'),
            _buildTableRow('Redux', '⭐⭐', '⭐⭐⭐⭐', '⭐⭐⭐⭐⭐'),
          ],
        ),
      ),
    );
  }
  
  DataRow _buildTableRow(String solution, String ease, String performance, String scalability) {
    return DataRow(
      cells: [
        DataCell(Text(solution, style: const TextStyle(fontWeight: FontWeight.w600))),
        DataCell(Text(ease)),
        DataCell(Text(performance)),
        DataCell(Text(scalability)),
      ],
    );
  }
  
  Widget _buildSolutionCard(
    BuildContext context, {
    required String title,
    required Color color,
    required int ease,
    required int performance,
    required int scalability,
    required List<String> pros,
    required List<String> cons,
    required String useCase,
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
                  width: 4,
                  height: 24,
                  color: color,
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Ratings
            Row(
              children: [
                Expanded(
                  child: _buildRating('السهولة', ease, color),
                ),
                Expanded(
                  child: _buildRating('الأداء', performance, color),
                ),
                Expanded(
                  child: _buildRating('القابلية', scalability, color),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Pros
            Text(
              'المزايا:',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 8),
            ...pros.map((pro) => Padding(
              padding: const EdgeInsets.only(left: 8, bottom: 4),
              child: Text('✓ $pro'),
            )),
            
            const SizedBox(height: 12),
            
            // Cons
            Text(
              'العيوب:',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 8),
            ...cons.map((con) => Padding(
              padding: const EdgeInsets.only(left: 8, bottom: 4),
              child: Text('✗ $con'),
            )),
            
            const SizedBox(height: 12),
            
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: color),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'الاستخدام الأمثل: $useCase',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildRating(String label, int rating, Color color) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12)),
        const SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(5, (index) {
            return Icon(
              index < rating ? Icons.star : Icons.star_border,
              size: 16,
              color: color,
            );
          }),
        ),
      ],
    );
  }
}
