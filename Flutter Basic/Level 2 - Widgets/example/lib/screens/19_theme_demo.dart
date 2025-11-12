import 'package:flutter/material.dart';

/// شاشة توضيحية للـ Theme (الموضوع 19)
class ThemeDemo extends StatefulWidget {
  const ThemeDemo({super.key});

  @override
  State<ThemeDemo> createState() => _ThemeDemoState();
}

class _ThemeDemoState extends State<ThemeDemo> {
  bool _isDark = false;
  Color _primaryColor = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _isDark ? _buildDarkTheme() : _buildLightTheme(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('19. Theme'),
          actions: [
            IconButton(
              icon: Icon(_isDark ? Icons.light_mode : Icons.dark_mode),
              onPressed: () => setState(() => _isDark = !_isDark),
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // تغيير اللون الأساسي
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('اختر اللون الأساسي:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      children: [
                        _buildColorButton(Colors.blue),
                        _buildColorButton(Colors.red),
                        _buildColorButton(Colors.green),
                        _buildColorButton(Colors.purple),
                        _buildColorButton(Colors.orange),
                        _buildColorButton(Colors.teal),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // أمثلة على الثيم
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('عناصر بالثيم:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('ElevatedButton'),
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton(
                      onPressed: () {},
                      child: const Text('OutlinedButton'),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () {},
                      child: const Text('TextButton'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // النصوص
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Headline Large', style: Theme.of(context).textTheme.headlineLarge),
                    Text('Headline Medium', style: Theme.of(context).textTheme.headlineMedium),
                    Text('Title Large', style: Theme.of(context).textTheme.titleLarge),
                    Text('Body Large', style: Theme.of(context).textTheme.bodyLarge),
                    Text('Body Medium', style: Theme.of(context).textTheme.bodyMedium),
                    Text('Label Small', style: Theme.of(context).textTheme.labelSmall),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // الألوان
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('ألوان الثيم:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    _buildColorBox('Primary', Theme.of(context).colorScheme.primary),
                    _buildColorBox('Secondary', Theme.of(context).colorScheme.secondary),
                    _buildColorBox('Surface', Theme.of(context).colorScheme.surface),
                    _buildColorBox('Error', Theme.of(context).colorScheme.error),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorButton(Color color) {
    final isSelected = _primaryColor == color;
    return GestureDetector(
      onTap: () => setState(() => _primaryColor = color),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: isSelected ? Border.all(color: Colors.white, width: 3) : null,
          boxShadow: isSelected
              ? [BoxShadow(color: color.withOpacity(0.5), blurRadius: 8, spreadRadius: 2)]
              : null,
        ),
        child: isSelected ? const Icon(Icons.check, color: Colors.white) : null,
      ),
    );
  }

  Widget _buildColorBox(String label, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 30,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 12),
          Text(label),
        ],
      ),
    );
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _primaryColor,
        brightness: Brightness.light,
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _primaryColor,
        brightness: Brightness.dark,
      ),
    );
  }
}
