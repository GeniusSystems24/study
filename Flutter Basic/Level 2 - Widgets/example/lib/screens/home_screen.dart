import 'package:flutter/material.dart';
import '../widgets/category_card.dart';
import '11_basic_widgets_demo.dart';
import '12_layout_widgets_demo.dart';
import '13_button_widgets_demo.dart';
import '14_input_widgets_demo.dart';
import '15_scrollview_widgets_demo.dart';
import '16_dialog_snackbar_demo.dart';
import '17_navigation_demo.dart';
import '18_animation_demo.dart';
import '19_theme_demo.dart';
import '20_card_listtile_demo.dart';

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
        title: const Text('Flutter Widgets Gallery'),
        actions: [
          // زر تغيير الثيم
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: onThemeToggle,
            tooltip: isDarkMode ? 'الوضع الفاتح' : 'الوضع الداكن',
          ),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: [
          // 11. Basic Widgets
          CategoryCard(
            title: '11. Basic Widgets',
            subtitle: 'الويدجت الأساسية',
            icon: Icons.widgets,
            color: Colors.blue,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const BasicWidgetsDemo(),
              ),
            ),
          ),

          // 12. Layout Widgets
          CategoryCard(
            title: '12. Layout Widgets',
            subtitle: 'التخطيط والتنسيق',
            icon: Icons.dashboard,
            color: Colors.green,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LayoutWidgetsDemo(),
              ),
            ),
          ),

          // 13. Button Widgets
          CategoryCard(
            title: '13. Button Widgets',
            subtitle: 'الأزرار',
            icon: Icons.smart_button,
            color: Colors.orange,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ButtonWidgetsDemo(),
              ),
            ),
          ),

          // 14. Input Widgets
          CategoryCard(
            title: '14. Input Widgets',
            subtitle: 'حقول الإدخال',
            icon: Icons.input,
            color: Colors.purple,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const InputWidgetsDemo(),
              ),
            ),
          ),

          // 15. ScrollView Widgets
          CategoryCard(
            title: '15. ScrollView',
            subtitle: 'القوائم والتمرير',
            icon: Icons.view_list,
            color: Colors.teal,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ScrollViewWidgetsDemo(),
              ),
            ),
          ),

          // 16. Dialog & SnackBar
          CategoryCard(
            title: '16. Dialog & SnackBar',
            subtitle: 'النوافذ والإشعارات',
            icon: Icons.message,
            color: Colors.pink,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const DialogSnackBarDemo(),
              ),
            ),
          ),

          // 17. Navigation
          CategoryCard(
            title: '17. Navigation',
            subtitle: 'التنقل بين الصفحات',
            icon: Icons.navigation,
            color: Colors.indigo,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NavigationDemo(),
              ),
            ),
          ),

          // 18. Animation
          CategoryCard(
            title: '18. Animation',
            subtitle: 'الحركة والرسوم المتحركة',
            icon: Icons.animation,
            color: Colors.deepOrange,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AnimationDemo(),
              ),
            ),
          ),

          // 19. Theme
          CategoryCard(
            title: '19. Theme',
            subtitle: 'الثيمات والتنسيق',
            icon: Icons.palette,
            color: Colors.cyan,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ThemeDemo(),
              ),
            ),
          ),

          // 20. Card & ListTile
          CategoryCard(
            title: '20. Card & ListTile',
            subtitle: 'البطاقات والقوائم',
            icon: Icons.card_giftcard,
            color: Colors.amber,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CardListTileDemo(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
