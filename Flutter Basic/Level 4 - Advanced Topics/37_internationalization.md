# 37 - التدويل واللغات - Internationalization (i18n)

## 📋 المحتويات

- [المقدمة](#المقدمة)
- [إعداد التدويل](#إعداد-التدويل)
- [easy_localization](#easy_localization)
- [تغيير اللغة ديناميكياً](#تغيير-اللغة-ديناميكياً)

---

## 🎯 المقدمة

التدويل (i18n) يجعل تطبيقك يدعم لغات متعددة ويصل لجمهور أوسع.

---

## 🌍 إعداد التدويل

### استخدام Flutter المدمج

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  intl: ^0.18.1
```

---

### إنشاء ملفات الترجمة

`lib/l10n/app_ar.arb`:

```json
{
  "@@locale": "ar",
  "appTitle": "تطبيقي",
  "welcome": "مرحباً",
  "login": "تسجيل الدخول",
  "email": "البريد الإلكتروني",
  "password": "كلمة المرور",
  "helloUser": "مرحباً {name}!",
  "@helloUser": {
    "placeholders": {
      "name": {
        "type": "String"
      }
    }
  },
  "itemCount": "{count, plural, =0{لا توجد عناصر} =1{عنصر واحد} other{{count} عناصر}}",
  "@itemCount": {
    "placeholders": {
      "count": {
        "type": "int"
      }
    }
  }
}
```

`lib/l10n/app_en.arb`:

```json
{
  "@@locale": "en",
  "appTitle": "My App",
  "welcome": "Welcome",
  "login": "Login",
  "email": "Email",
  "password": "Password",
  "helloUser": "Hello {name}!",
  "@helloUser": {
    "placeholders": {
      "name": {
        "type": "String"
      }
    }
  },
  "itemCount": "{count, plural, =0{No items} =1{One item} other{{count} items}}",
  "@itemCount": {
    "placeholders": {
      "count": {
        "type": "int"
      }
    }
  }
}
```

---

### التكوين في pubspec.yaml

```yaml
flutter:
  generate: true
```

`l10n.yaml`:

```yaml
arb-dir: lib/l10n
template-arb-file: app_ar.arb
output-localization-file: app_localizations.dart
```

---

### الاستخدام

```dart
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Multi-language App',
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar'),
        Locale('en'),
      ],
      locale: const Locale('ar'), // Default language
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.appTitle)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(l10n.welcome),
            Text(l10n.helloUser('محمد')),
            Text(l10n.itemCount(5)),
          ],
        ),
      ),
    );
  }
}
```

---

## 📦 easy_localization

### التثبيت

```yaml
dependencies:
  easy_localization: ^3.0.3
```

---

### إنشاء ملفات JSON

`assets/translations/ar.json`:

```json
{
  "app_title": "تطبيقي",
  "welcome": "مرحباً",
  "hello_user": "مرحباً {}!",
  "items_count": "{} عناصر",
  "login": {
    "title": "تسجيل الدخول",
    "email": "البريد الإلكتروني",
    "password": "كلمة المرور",
    "submit": "دخول",
    "forgot_password": "نسيت كلمة المرور؟"
  },
  "settings": {
    "title": "الإعدادات",
    "language": "اللغة",
    "theme": "المظهر",
    "notifications": "الإشعارات"
  }
}
```

`assets/translations/en.json`:

```json
{
  "app_title": "My App",
  "welcome": "Welcome",
  "hello_user": "Hello {}!",
  "items_count": "{} items",
  "login": {
    "title": "Login",
    "email": "Email",
    "password": "Password",
    "submit": "Submit",
    "forgot_password": "Forgot Password?"
  },
  "settings": {
    "title": "Settings",
    "language": "Language",
    "theme": "Theme",
    "notifications": "Notifications"
  }
}
```

---

### التكوين في pubspec.yaml

```yaml
flutter:
  assets:
    - assets/translations/
```

---

### الاستخدام

```dart
import 'package:easy_localization/easy_localization.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('ar'), Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('ar'),
      startLocale: const Locale('ar'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'app_title'.tr(),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('app_title'.tr())),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('welcome'.tr()),
            Text('hello_user'.tr(args: ['محمد'])),
            Text('items_count'.tr(args: ['5'])),
            const SizedBox(height: 20),
            Text('login.title'.tr()),
            Text('login.email'.tr()),
            Text('settings.language'.tr()),
          ],
        ),
      ),
    );
  }
}
```

---

## 🔄 تغيير اللغة ديناميكياً

### مع easy_localization

```dart
class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('settings.language'.tr())),
      body: ListView(
        children: [
          ListTile(
            title: const Text('العربية'),
            leading: Radio<Locale>(
              value: const Locale('ar'),
              groupValue: context.locale,
              onChanged: (locale) {
                if (locale != null) {
                  context.setLocale(locale);
                }
              },
            ),
          ),
          ListTile(
            title: const Text('English'),
            leading: Radio<Locale>(
              value: const Locale('en'),
              groupValue: context.locale,
              onChanged: (locale) {
                if (locale != null) {
                  context.setLocale(locale);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
```

---

### مع Provider

```dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('ar');

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }
}

// في main.dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LocaleProvider(),
      child: Consumer<LocaleProvider>(
        builder: (context, provider, child) {
          return MaterialApp(
            locale: provider.locale,
            // ... الباقي
          );
        },
      ),
    );
  }
}
```

---

## 💼 أمثلة عملية

### تطبيق كامل متعدد اللغات

```dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final savedLocale = prefs.getString('locale') ?? 'ar';

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('ar'), Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('ar'),
      startLocale: Locale(savedLocale),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'app_title'.tr(),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: context.locale.languageCode == 'ar' ? 'Cairo' : 'Roboto',
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('app_title'.tr()),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'welcome'.tr(),
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: const Icon(Icons.login),
                title: Text('login.title'.tr()),
                subtitle: Text('login.email'.tr()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _changeLanguage(BuildContext context, Locale locale) async {
    await context.setLocale(locale);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', locale.languageCode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('settings.title'.tr())),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.language),
            title: Text('settings.language'.tr()),
          ),
          RadioListTile<Locale>(
            title: const Text('العربية'),
            value: const Locale('ar'),
            groupValue: context.locale,
            onChanged: (locale) {
              if (locale != null) {
                _changeLanguage(context, locale);
              }
            },
          ),
          RadioListTile<Locale>(
            title: const Text('English'),
            value: const Locale('en'),
            groupValue: context.locale,
            onChanged: (locale) {
              if (locale != null) {
                _changeLanguage(context, locale);
              }
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info),
            title: Text('Current: ${context.locale.languageCode}'),
          ),
        ],
      ),
    );
  }
}
```

---

### تنسيق التواريخ والأرقام

```dart
import 'package:intl/intl.dart';

class FormattingExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final locale = context.locale.toString();

    // تنسيق التاريخ
    final dateFormat = DateFormat.yMMMd(locale);
    final formattedDate = dateFormat.format(now);

    // تنسيق الأرقام
    final numberFormat = NumberFormat('#,##0', locale);
    final formattedNumber = numberFormat.format(123456);

    // تنسيق العملات
    final currencyFormat = NumberFormat.currency(
      locale: locale,
      symbol: context.locale.languageCode == 'ar' ? 'ر.س' : 'SAR',
    );
    final formattedCurrency = currencyFormat.format(1234.56);

    return Scaffold(
      appBar: AppBar(title: const Text('التنسيق')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('التاريخ: $formattedDate'),
            Text('الرقم: $formattedNumber'),
            Text('العملة: $formattedCurrency'),
          ],
        ),
      ),
    );
  }
}
```

---

## 📚 المراجع والمصادر

1. **Packages**
   - [easy_localization](https://pub.dev/packages/easy_localization)
   - [intl](https://pub.dev/packages/intl)
   - [flutter_localizations](https://api.flutter.dev/flutter/flutter_localizations/flutter_localizations-library.html)

2. **Documentation**
   - [Flutter Internationalization](https://flutter.dev/docs/development/accessibility-and-localization/internationalization)

---

## 💡 نصائح

- ✅ ابدأ بالتدويل من البداية
- ✅ استخدم مفاتيح واضحة للترجمات
- ✅ احفظ اختيار اللغة في SharedPreferences
- ✅ اختبر التطبيق بجميع اللغات
- ✅ انتبه لاتجاه النص (RTL/LTR)
- ✅ استخدم خطوط مناسبة لكل لغة

---

[⬅️ السابق: الإشعارات](36_notifications.md)
[🏠 العودة للفهرس](../README.md)
[التالي: الأمان ➡️](38_security.md)
