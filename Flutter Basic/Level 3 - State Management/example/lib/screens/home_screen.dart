import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/widgets/demo_card.dart';

// استيراد شاشات العرض (سيتم إنشاؤها لاحقاً)
import '21_state_basics/state_basics_demo.dart';
import '22_inherited_widget/inherited_widget_demo.dart';
import '23_provider/provider_demo.dart';
import '24_riverpod/riverpod_demo.dart';
import '25_bloc/bloc_demo.dart';
import '26_getx/getx_demo.dart';
import '27_mobx/mobx_demo.dart';
import '28_redux/redux_demo.dart';
import '29_comparison/comparison_screen.dart';
import '30_patterns/patterns_screen.dart';

class HomeScreen extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback onThemeToggle;

  const HomeScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('State Management Project'),
        actions: [
          // زر تبديل الثيم
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: onThemeToggle,
            tooltip: isDarkMode ? 'Light Mode' : 'Dark Mode',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // العنوان والوصف
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: [
                Text(
                  'معرض إدارة الحالة',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'استكشف جميع حلول State Management في Flutter',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // شبكة الفئات
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            children: [
              // 21. State Basics
              DemoCard(
                title: 'State Basics',
                subtitle: 'setState & Lifecycle',
                icon: Icons.widgets_outlined,
                color: Colors.blue,
                onTap: () => Get.to(() => const StateBasicsDemo()),
              ),
              
              // 22. InheritedWidget
              DemoCard(
                title: 'InheritedWidget',
                subtitle: 'Widget Tree Sharing',
                icon: Icons.share_outlined,
                color: Colors.green,
                onTap: () => Get.to(() => const InheritedWidgetDemo()),
              ),
              
              // 23. Provider
              DemoCard(
                title: 'Provider',
                subtitle: 'Most Popular',
                icon: Icons.verified_outlined,
                color: Colors.orange,
                onTap: () => Get.to(() => const ProviderDemo()),
              ),
              
              // 24. Riverpod
              DemoCard(
                title: 'Riverpod',
                subtitle: 'Improved Provider',
                icon: Icons.rocket_launch_outlined,
                color: Colors.purple,
                onTap: () => Get.to(() => const RiverpodDemo()),
              ),
              
              // 25. BLoC
              DemoCard(
                title: 'BLoC Pattern',
                subtitle: 'Stream-Based',
                icon: Icons.stream_outlined,
                color: Colors.red,
                onTap: () => Get.to(() => const BlocDemo()),
              ),
              
              // 26. GetX
              DemoCard(
                title: 'GetX',
                subtitle: 'Simplified',
                icon: Icons.flash_on_outlined,
                color: Colors.cyan,
                onTap: () => Get.to(() => const GetXDemo()),
              ),
              
              // 27. MobX
              DemoCard(
                title: 'MobX',
                subtitle: 'Reactive',
                icon: Icons.autorenew_outlined,
                color: Colors.teal,
                onTap: () => Get.to(() => const MobXDemo()),
              ),
              
              // 28. Redux
              DemoCard(
                title: 'Redux',
                subtitle: 'Predictable State',
                icon: Icons.storage_outlined,
                color: Colors.indigo,
                onTap: () => Get.to(() => const ReduxDemo()),
              ),
              
              // 29. Comparison
              DemoCard(
                title: 'Comparison',
                subtitle: 'All Solutions',
                icon: Icons.compare_outlined,
                color: Colors.pink,
                onTap: () => Get.to(() => const ComparisonScreen()),
              ),
              
              // 30. Patterns
              DemoCard(
                title: 'Best Practices',
                subtitle: 'Patterns & Tips',
                icon: Icons.lightbulb_outline,
                color: Colors.amber,
                onTap: () => Get.to(() => const PatternsScreen()),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // معلومات إضافية
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'معلومات المشروع',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text('• يغطي هذا المشروع جميع حلول إدارة الحالة في Flutter'),
                  const SizedBox(height: 4),
                  const Text('• كل قسم يحتوي على أمثلة عملية وشرح مفصل'),
                  const SizedBox(height: 4),
                  const Text('• اختر أي فئة للبدء في التعلم'),
                  const SizedBox(height: 4),
                  const Text('• يمكنك التبديل بين Dark/Light Mode من الأعلى'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
