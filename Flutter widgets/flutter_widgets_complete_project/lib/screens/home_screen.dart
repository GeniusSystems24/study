import 'package:flutter/material.dart';
import '../models/widget_category.dart';
import '../screens/material_widgets_screen.dart';
import '../screens/cupertino_widgets_screen.dart';
import '../screens/accessibility_screen.dart';
import '../screens/animation_screen.dart';
import '../screens/assets_screen.dart';
import '../screens/async_screen.dart';
import '../screens/basics_screen.dart';
import '../screens/input_screen.dart';
import '../screens/interaction_screen.dart';
import '../screens/layout_screen.dart';
import '../screens/painting_screen.dart';
import '../screens/scrolling_screen.dart';
import '../screens/styling_screen.dart';
import '../screens/text_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigateToScreen(BuildContext context, String route) {
    Widget? screen;
    
    switch (route) {
      case '/material':
        screen = const MaterialWidgetsScreen();
        break;
      case '/cupertino':
        screen = const CupertinoWidgetsScreen();
        break;
      case '/accessibility':
        screen = const AccessibilityScreen();
        break;
      case '/animation':
        screen = const AnimationScreen();
        break;
      case '/assets':
        screen = const AssetsScreen();
        break;
      case '/async':
        screen = const AsyncScreen();
        break;
      case '/basics':
        screen = const BasicsScreen();
        break;
      case '/input':
        screen = const InputScreen();
        break;
      case '/interaction':
        screen = const InteractionScreen();
        break;
      case '/layout':
        screen = const LayoutScreen();
        break;
      case '/painting':
        screen = const PaintingScreen();
        break;
      case '/scrolling':
        screen = const ScrollingScreen();
        break;
      case '/styling':
        screen = const StylingScreen();
        break;
      case '/text':
        screen = const TextScreen();
        break;
    }

    if (screen != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => screen!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // شريط التطبيق المتقدم
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Flutter Widgets',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDark
                        ? [Colors.blue.shade900, Colors.purple.shade900]
                        : [Colors.blue.shade400, Colors.purple.shade400],
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.widgets,
                    size: 80,
                    color: Colors.white70,
                  ),
                ),
              ),
            ),
          ),

          // معلومات تمهيدية
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: theme.colorScheme.primary,
                              size: 28,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'المرجع الشامل',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'مشروع متكامل يحتوي على جميع أمثلة Flutter Widgets المقسمة حسب الفئات الـ 14 الرسمية من التوثيق.',
                          style: theme.textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _buildInfoChip(
                              context,
                              '14 فئة',
                              Icons.category,
                            ),
                            _buildInfoChip(
                              context,
                              '100+ مثال',
                              Icons.code,
                            ),
                            _buildInfoChip(
                              context,
                              'Material 3',
                              Icons.palette,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // العنوان
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Text(
                'استكشف الفئات',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // شبكة الفئات
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.85,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return _buildCategoryCard(
                    context,
                    widgetCategories[index],
                    index,
                  );
                },
                childCount: widgetCategories.length,
              ),
            ),
          ),

          // مسافة في الأسفل
          const SliverToBoxAdapter(
            child: SizedBox(height: 30),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(BuildContext context, String label, IconData icon) {
    return Chip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
    );
  }

  Widget _buildCategoryCard(
    BuildContext context,
    WidgetCategory category,
    int index,
  ) {
    final theme = Theme.of(context);
    
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + (index * 50)),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: Card(
        elevation: 4,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => _navigateToScreen(context, category.route),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.colorScheme.primaryContainer,
                  theme.colorScheme.secondaryContainer,
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // الأيقونة
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        category.icon,
                        style: const TextStyle(fontSize: 28),
                      ),
                    ),
                  ),
                  const Spacer(),
                  
                  // العنوان
                  Text(
                    category.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  
                  // الوصف
                  Text(
                    category.description,
                    style: theme.textTheme.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  
                  // عدد الأمثلة
                  Row(
                    children: [
                      Icon(
                        Icons.arrow_forward,
                        size: 16,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${category.features.length} أقسام',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
