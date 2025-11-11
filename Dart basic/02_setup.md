# 2. إعداد بيئة التطوير

## تثبيت Dart SDK

### Windows

1. قم بتحميل Dart SDK من [الموقع الرسمي](https://dart.dev/get-dart)
2. استخدم Chocolatey:
```powershell
choco install dart-sdk
```

### macOS

استخدم Homebrew:
```bash
brew tap dart-lang/dart
brew install dart
```

### Linux

```bash
sudo apt-get update
sudo apt-get install apt-transport-https
wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo gpg --dearmor -o /usr/share/keyrings/dart.gpg
echo 'deb [signed-by=/usr/share/keyrings/dart.gpg arch=amd64] https://storage.googleapis.com/download.dartlang.org/linux/debian stable main' | sudo tee /etc/apt/sources.list.d/dart_stable.list
sudo apt-get update
sudo apt-get install dart
```

## التحقق من التثبيت

```bash
dart --version
```

## إعداد محرر النصوص

### VS Code (موصى به)

1. قم بتحميل [VS Code](https://code.visualstudio.com/)
2. ثبّت إضافة Dart:
   - افتح VS Code
   - اضغط `Ctrl+Shift+X`
   - ابحث عن "Dart"
   - ثبّت الإضافة الرسمية

### Android Studio / IntelliJ IDEA

1. افتح Settings/Preferences
2. انتقل إلى Plugins
3. ابحث عن "Dart" وقم بتثبيته

## أول برنامج - Hello World

### 1. إنشاء ملف جديد

أنشئ ملف باسم `hello.dart`

### 2. كتابة الكود

```dart
void main() {
  print('Hello, World!');
}
```

### 3. تشغيل البرنامج

في الـ Terminal:
```bash
dart run hello.dart
```

أو في VS Code: اضغط `F5` أو استخدم زر Run

## هيكل مشروع Dart

```
my_project/
├── bin/
│   └── main.dart          # نقطة بداية التطبيق
├── lib/
│   └── my_library.dart    # الكود القابل لإعادة الاستخدام
├── test/
│   └── my_test.dart       # ملفات الاختبار
└── pubspec.yaml           # ملف التبعيات
```

## إنشاء مشروع جديد

```bash
# إنشاء مشروع console application
dart create my_app

# الانتقال إلى المشروع
cd my_app

# تشغيل المشروع
dart run
```

## أدوات مفيدة

### DartPad
محرر أونلاين لتجربة Dart بدون تثبيت: [dartpad.dev](https://dartpad.dev)

### Dart DevTools
أدوات تطوير متقدمة للتحليل والتصحيح:
```bash
dart devtools
```

## نصائح للمبتدئين

- استخدم VS Code مع إضافة Dart للحصول على أفضل تجربة تطوير
- جرّب الأكواد في DartPad قبل كتابتها في مشروعك
- فعّل خاصية Auto Save في محررك
- استخدم الاختصارات: `Ctrl+Space` للإكمال التلقائي

---

[⬅️ الموضوع السابق: مقدمة إلى Dart](01_introduction.md) 
 [العودة للفهرس](README.md) 
 [الموضوع التالي: المتغيرات وأنواع البيانات ➡️](03_variables.md)
