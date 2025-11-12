# 10 - بنية تطبيق Flutter

## 📋 المحتويات

- [المقدمة](#المقدمة)
- [بنية المشروع](#بنية-المشروع)
- [ملف pubspec.yaml](#ملف-pubspecyaml)
- [الملف الرئيسي main.dart](#الملف-الرئيسي-maindart)
- [تنظيم الملفات](#تنظيم-الملفات)
- [إدارة الأصول](#إدارة-الأصول)
- [أول تطبيق Flutter](#أول-تطبيق-flutter)

---

## 🎯 المقدمة

فهم بنية مشروع Flutter ضروري لبناء تطبيقات منظمة وقابلة للصيانة.

### مكونات المشروع الأساسية

- 📁 **lib/**: كود Dart الخاص بالتطبيق
- 📄 **pubspec.yaml**: ملف التبعيات والإعدادات
- 📱 **android/**: كود Android الخاص بالمنصة
- 🍎 **ios/**: كود iOS الخاص بالمنصة
- 🌐 **web/**: ملفات الويب (إن وُجدت)

---

## 📁 بنية المشروع

### هيكل المجلدات الكامل

```
my_flutter_app/
│
├── android/                 # ملفات Android
├── ios/                    # ملفات iOS
├── web/                    # ملفات الويب
├── linux/                  # ملفات Linux
├── macos/                  # ملفات macOS
├── windows/                # ملفات Windows
│
├── lib/                    # كود التطبيق (Dart)
│   ├── main.dart          # نقطة الدخول
│   ├── screens/           # شاشات التطبيق
│   ├── widgets/           # مكونات قابلة لإعادة الاستخدام
│   ├── models/            # نماذج البيانات
│   ├── services/          # خدمات (API, Database, etc.)
│   └── utils/             # دوال مساعدة
│
├── assets/                 # الأصول (صور، خطوط، إلخ)
│   ├── images/
│   ├── fonts/
│   └── icons/
│
├── test/                   # ملفات الاختبار
│
├── pubspec.yaml           # ملف التبعيات
├── pubspec.lock          # قفل إصدارات التبعيات
├── analysis_options.yaml  # خيارات التحليل
└── README.md             # وصف المشروع
```

---

## 📄 ملف pubspec.yaml

الملف الأساسي لإدارة التبعيات والأصول.

### بنية pubspec.yaml

```yaml
name: my_flutter_app           # اسم التطبيق
description: تطبيق Flutter تجريبي
publish_to: 'none'             # عدم نشره على pub.dev

version: 1.0.0+1               # الإصدار

environment:
  sdk: '>=3.0.0 <4.0.0'       # إصدار Dart SDK

dependencies:
  flutter:
    sdk: flutter
  
  # تبعيات أخرى
  cupertino_icons: ^1.0.2
  http: ^1.1.0
  provider: ^6.0.5

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^2.0.0

flutter:
  uses-material-design: true
  
  # الأصول
  assets:
    - assets/images/
    - assets/icons/
  
  # الخطوط
  fonts:
    - family: Cairo
      fonts:
        - asset: assets/fonts/Cairo-Regular.ttf
        - asset: assets/fonts/Cairo-Bold.ttf
          weight: 700
```

### إضافة تبعية

```bash
# في Terminal
flutter pub add http
flutter pub add provider
```

### تحديث التبعيات

```bash
flutter pub get
flutter pub upgrade
```

---

## 🚀 الملف الرئيسي main.dart

### البنية الأساسية

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'تطبيقي الأول',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الصفحة الرئيسية'),
      ),
      body: const Center(
        child: Text(
          'مرحباً بك في Flutter!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
```

### شرح المكونات

```dart
// 1. استيراد المكتبات
import 'package:flutter/material.dart';

// 2. نقطة الدخول
void main() {
  runApp(const MyApp());  // تشغيل التطبيق
}

// 3. Widget الجذر
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // إعدادات التطبيق
      title: 'اسم التطبيق',
      
      // الثيم
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Cairo',
      ),
      
      // الصفحة الرئيسية
      home: const MyHomePage(),
      
      // إعدادات إضافية
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar', 'SA'),
    );
  }
}
```

---

## 🗂️ تنظيم الملفات

### نمط Feature-First

```
lib/
├── main.dart
├── app/
│   ├── app.dart           # Widget الرئيسي
│   └── routes.dart        # تعريف المسارات
│
├── features/
│   ├── auth/
│   │   ├── screens/
│   │   │   ├── login_screen.dart
│   │   │   └── register_screen.dart
│   │   ├── widgets/
│   │   │   └── login_form.dart
│   │   └── services/
│   │       └── auth_service.dart
│   │
│   └── home/
│       ├── screens/
│       │   └── home_screen.dart
│       └── widgets/
│           └── product_card.dart
│
├── core/
│   ├── constants/
│   │   ├── colors.dart
│   │   └── strings.dart
│   ├── utils/
│   │   └── validators.dart
│   └── widgets/
│       └── custom_button.dart
│
└── shared/
    ├── models/
    │   └── user.dart
    └── services/
        └── api_service.dart
```

### مثال: screens/home_screen.dart

```dart
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الرئيسية'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'مرحباً بك!',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // الانتقال لصفحة أخرى
              },
              child: const Text('ابدأ'),
            ),
          ],
        ),
      ),
    );
  }
}
```

### مثال: models/user.dart

```dart
class User {
  final String id;
  final String name;
  final String email;
  final String? imageUrl;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.imageUrl,
  });

  // تحويل من JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      imageUrl: json['image_url'] as String?,
    );
  }

  // تحويل إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'image_url': imageUrl,
    };
  }
}
```

---

## 🎨 إدارة الأصول

### إضافة الصور

1. إنشاء مجلد `assets/images/`
2. وضع الصور في المجلد
3. تحديث `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/images/
    # أو تحديد ملفات معينة
    - assets/images/logo.png
    - assets/images/background.jpg
```

4. استخدام الصور في الكود:

```dart
Image.asset('assets/images/logo.png')

// مع خصائص
Image.asset(
  'assets/images/logo.png',
  width: 100,
  height: 100,
  fit: BoxFit.cover,
)
```

### إضافة الخطوط

1. إنشاء مجلد `assets/fonts/`
2. وضع ملفات الخطوط (.ttf)
3. تحديث `pubspec.yaml`:

```yaml
flutter:
  fonts:
    - family: Cairo
      fonts:
        - asset: assets/fonts/Cairo-Regular.ttf
        - asset: assets/fonts/Cairo-Bold.ttf
          weight: 700
        - asset: assets/fonts/Cairo-Light.ttf
          weight: 300
```

4. استخدام الخط:

```dart
Text(
  'مرحباً',
  style: TextStyle(
    fontFamily: 'Cairo',
    fontSize: 20,
    fontWeight: FontWeight.bold,
  ),
)

// أو في الثيم
ThemeData(
  fontFamily: 'Cairo',
)
```

### إضافة الأيقونات

```yaml
flutter:
  assets:
    - assets/icons/
```

```dart
Image.asset('assets/icons/home.png', width: 24, height: 24)
```

---

## 📱 أول تطبيق Flutter

### تطبيق عداد بسيط

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'تطبيق العداد',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Cairo',
      ),
      home: const CounterScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CounterScreen extends StatefulWidget {
  const CounterScreen({super.key});

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      _counter--;
    });
  }

  void _resetCounter() {
    setState(() {
      _counter = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تطبيق العداد'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'العدد الحالي:',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 10),
            Text(
              '$_counter',
              style: const TextStyle(
                fontSize: 72,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  onPressed: _decrementCounter,
                  tooltip: 'إنقاص',
                  child: const Icon(Icons.remove),
                ),
                const SizedBox(width: 20),
                FloatingActionButton(
                  onPressed: _resetCounter,
                  tooltip: 'إعادة تعيين',
                  backgroundColor: Colors.grey,
                  child: const Icon(Icons.refresh),
                ),
                const SizedBox(width: 20),
                FloatingActionButton(
                  onPressed: _incrementCounter,
                  tooltip: 'زيادة',
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
```

### تشغيل التطبيق

```bash
# في Terminal
flutter run

# اختيار منصة محددة
flutter run -d chrome       # ويب
flutter run -d windows      # Windows
flutter run -d android      # Android
```

---

## 📚 للتعمق أكثر

الآن أنت جاهز لتعلم Widgets في المستوى الثاني!

**التالي**: [المستوى الثاني - Widgets](11_basic_widgets.md)

---

## 📖 المراجع والمصادر

### مصادر Flutter الرسمية

1. **Flutter Project Structure**
   - [Project Structure Overview](https://docs.flutter.dev/development/tools/sdk)
   - [Assets and Images](https://docs.flutter.dev/development/ui/assets-and-images)
   - [Using Custom Fonts](https://docs.flutter.dev/cookbook/design/fonts)

2. **pubspec.yaml**
   - [The pubspec File](https://dart.dev/tools/pub/pubspec)
   - [Package Dependencies](https://docs.flutter.dev/development/packages-and-plugins/using-packages)
   - [Assets Declaration](https://docs.flutter.dev/development/ui/assets-and-images#specifying-assets)

3. **App Architecture**
   - [Flutter Architectural Overview](https://docs.flutter.dev/resources/architectural-overview)
   - [State Management](https://docs.flutter.dev/development/data-and-backend/state-mgmt/intro)

### البداية السريعة

4. **Getting Started**
   - [Write Your First Flutter App](https://docs.flutter.dev/get-started/codelab)
   - [Building Layouts](https://docs.flutter.dev/development/ui/layout/tutorial)
   - [Adding Interactivity](https://docs.flutter.dev/development/ui/interactive)

5. **Flutter Samples**
   - [Flutter Gallery](https://gallery.flutter.dev/)
   - [Flutter Samples on GitHub](https://github.com/flutter/samples)

### مصادر داخل المستودع

6. **خطة تعلم Flutter الشاملة**
   - [فهرس Flutter الكامل](README.md)
   - [إعداد البيئة](02_setup.md)

### الأدوات والتطوير

7. **Development Tools**
   - [Flutter DevTools](https://docs.flutter.dev/development/tools/devtools/overview)
   - [Hot Reload](https://docs.flutter.dev/development/tools/hot-reload)
   - [Debugging](https://docs.flutter.dev/testing/debugging)

### مصادر إضافية

8. **Community Resources**
   - [Flutter Community on Medium](https://medium.com/flutter)
   - [Flutter on Stack Overflow](https://stackoverflow.com/questions/tagged/flutter)
   - [Flutter Awesome - Curated List](https://flutterawesome.com/)

9. **Video Tutorials**
   - [Flutter YouTube Channel](https://www.youtube.com/flutterdev)
   - [Flutter Widget of the Week](https://www.youtube.com/playlist?list=PLjxrf2q8roU23XGwz3Km7sQZFTdB996iG)

10. **Best Practices**
    - [Flutter Best Practices](https://docs.flutter.dev/development/tools/formatting)
    - [Effective Dart](https://dart.dev/guides/language/effective-dart)
    - [Flutter Code Style](https://github.com/flutter/flutter/wiki/Style-guide-for-Flutter-repo)

---

## 💡 نصائح

- ✅ نظّم ملفاتك حسب الميزات (features)
- ✅ استخدم `const` للـ widgets الثابتة
- ✅ افصل الـ widgets الكبيرة إلى widgets أصغر
- ✅ استخدم أسماء واضحة للملفات والفئات
- ✅ ضع الأصول في مجلدات منفصلة حسب النوع
- ✅ استخدم `flutter pub get` بعد تعديل pubspec.yaml
- ✅ استفد من Hot Reload أثناء التطوير
- ✅ اقرأ رسائل الأخطاء بعناية

---

## 🎯 تمرين عملي

أنشئ تطبيقاً بسيطاً يحتوي على:

1. صفحة رئيسية بعنوان وصورة
2. زر للانتقال لصفحة ثانية
3. استخدام خط مخصص
4. استخدام الألوان من ملف constants

---

[⬅️ السابق: البرمجة التفاعلية](09_async_programming.md)
[🏠 العودة للفهرس](../README.md)
[التالي: Widgets الأساسية ➡️](../Level%202%20-%20Widgets/11_basic_widgets.md)
