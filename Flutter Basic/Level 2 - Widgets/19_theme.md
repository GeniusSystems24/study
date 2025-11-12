# 19 - Theme والتنسيق الموحد

## 📋 المحتويات

- [المقدمة](#المقدمة)
- [ThemeData الأساسي](#themedata-الأساسي)
- [Dark Mode](#dark-mode)
- [Custom Theme](#custom-theme)
- [Theme Extensions](#theme-extensions)
- [أمثلة عملية](#أمثلة-عملية)

---

## 🎯 المقدمة

Theme في Flutter يوفر نظام تنسيق موحد للتطبيق بأكمله.

---

## 🎨 ThemeData الأساسي

تعريف Theme للتطبيق:

```dart
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Theme Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey.shade100,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 2,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      home: const HomePage(),
    );
  }
}
```

### استخدام Theme

```dart
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'النص الأساسي',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            Text(
              'نص فرعي',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: const Text('زر'),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 🌓 Dark Mode

تطبيق الوضع الليلي:

```dart
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dark Mode Demo',
      themeMode: _themeMode,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
      ),
      home: HomePage(onThemeToggle: _toggleTheme),
    );
  }
}

class HomePage extends StatelessWidget {
  final VoidCallback onThemeToggle;

  const HomePage({super.key, required this.onThemeToggle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dark Mode'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: onThemeToggle,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'الوضع الحالي:',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              Theme.of(context).brightness == Brightness.light
                  ? 'فاتح'
                  : 'داكن',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 🎨 Custom Theme

إنشاء Theme مخصص:

```dart
class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: const Color(0xFF2196F3),
    scaffoldBackgroundColor: const Color(0xFFF5F5F5),
    
    // AppBar Theme
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF2196F3),
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    
    // Card Theme
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.white,
    ),
    
    // Button Themes
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF2196F3),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 2,
      ),
    ),
    
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: const Color(0xFF2196F3),
      ),
    ),
    
    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF2196F3), width: 2),
      ),
    ),
    
    // Text Theme
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Color(0xFF212121),
      ),
      headlineMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Color(0xFF212121),
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: Color(0xFF424242),
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: Color(0xFF616161),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF1976D2),
    scaffoldBackgroundColor: const Color(0xFF121212),
    
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E1E1E),
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),
    
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: const Color(0xFF1E1E1E),
    ),
    
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1976D2),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF1E1E1E),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
}

// الاستخدام
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const HomePage(),
    );
  }
}
```

---

## 🔧 Theme Extensions

إضافة ألوان مخصصة:

```dart
class CustomColors extends ThemeExtension<CustomColors> {
  final Color? success;
  final Color? warning;
  final Color? danger;
  final Color? info;

  const CustomColors({
    this.success,
    this.warning,
    this.danger,
    this.info,
  });

  @override
  ThemeExtension<CustomColors> copyWith({
    Color? success,
    Color? warning,
    Color? danger,
    Color? info,
  }) {
    return CustomColors(
      success: success ?? this.success,
      warning: warning ?? this.warning,
      danger: danger ?? this.danger,
      info: info ?? this.info,
    );
  }

  @override
  ThemeExtension<CustomColors> lerp(
    ThemeExtension<CustomColors>? other,
    double t,
  ) {
    if (other is! CustomColors) return this;
    return CustomColors(
      success: Color.lerp(success, other.success, t),
      warning: Color.lerp(warning, other.warning, t),
      danger: Color.lerp(danger, other.danger, t),
      info: Color.lerp(info, other.info, t),
    );
  }
}

// إضافة للـ Theme
ThemeData lightTheme = ThemeData(
  extensions: const [
    CustomColors(
      success: Color(0xFF4CAF50),
      warning: Color(0xFFFF9800),
      danger: Color(0xFFF44336),
      info: Color(0xFF2196F3),
    ),
  ],
);

// الاستخدام
final customColors = Theme.of(context).extension<CustomColors>()!;

Container(
  color: customColors.success,
  child: const Text('نجاح'),
);
```

---

## 💼 أمثلة عملية

### تطبيق مع تبديل Theme

```dart
class ThemeSwitcherApp extends StatefulWidget {
  const ThemeSwitcherApp({super.key});

  @override
  State<ThemeSwitcherApp> createState() => _ThemeSwitcherAppState();
}

class _ThemeSwitcherAppState extends State<ThemeSwitcherApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _changeTheme(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: _themeMode,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: SettingsPage(
        currentThemeMode: _themeMode,
        onThemeChanged: _changeTheme,
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  final ThemeMode currentThemeMode;
  final Function(ThemeMode) onThemeChanged;

  const SettingsPage({
    super.key,
    required this.currentThemeMode,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الإعدادات')),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'المظهر',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          RadioListTile<ThemeMode>(
            title: const Text('فاتح'),
            value: ThemeMode.light,
            groupValue: currentThemeMode,
            onChanged: (value) => onThemeChanged(value!),
          ),
          RadioListTile<ThemeMode>(
            title: const Text('داكن'),
            value: ThemeMode.dark,
            groupValue: currentThemeMode,
            onChanged: (value) => onThemeChanged(value!),
          ),
          RadioListTile<ThemeMode>(
            title: const Text('تلقائي (حسب النظام)'),
            value: ThemeMode.system,
            groupValue: currentThemeMode,
            onChanged: (value) => onThemeChanged(value!),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'معاينة الألوان',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildColorBox(
                  'Primary',
                  Theme.of(context).colorScheme.primary,
                ),
                _buildColorBox(
                  'Secondary',
                  Theme.of(context).colorScheme.secondary,
                ),
                _buildColorBox(
                  'Surface',
                  Theme.of(context).colorScheme.surface,
                ),
                _buildColorBox(
                  'Error',
                  Theme.of(context).colorScheme.error,
                ),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'معاينة المكونات',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'عنوان البطاقة',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'محتوى البطاقة هنا',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Elevated Button'),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () {},
                  child: const Text('Outlined Button'),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {},
                  child: const Text('Text Button'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorBox(String label, Color color) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}
```

---

## 📚 المراجع والمصادر

1. **ThemeData**
   - [ThemeData](https://api.flutter.dev/flutter/material/ThemeData-class.html)
   - [Use Themes](https://docs.flutter.dev/cookbook/design/themes)

2. **Dark Mode**
   - [ThemeMode](https://api.flutter.dev/flutter/material/ThemeMode.html)
   - [Dark Theme](https://docs.flutter.dev/cookbook/design/themes#creating-a-theme)

3. **Material 3**
   - [Material 3](https://m3.material.io/)
   - [Material 3 in Flutter](https://docs.flutter.dev/ui/design/material)

4. **Theme Extensions**
   - [ThemeExtension](https://api.flutter.dev/flutter/material/ThemeExtension-class.html)

---

## 💡 نصائح

- ✅ استخدم `Theme.of(context)` للوصول للألوان والأنماط
- ✅ `ThemeMode.system` يتبع إعدادات النظام تلقائياً
- ✅ Theme Extensions مفيدة للألوان المخصصة
- ✅ Material 3 (`useMaterial3: true`) للتصميم الحديث
- ✅ احفظ تفضيلات Theme في SharedPreferences

---

[⬅️ السابق: Animation](18_animation.md)
[🏠 العودة للفهرس](../README.md)
[التالي: Card و ListTile ➡️](20_card_listtile.md)
