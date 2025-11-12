# تثبيت وإعداد بيئة التطوير

## 📋 المتطلبات الأساسية

قبل البدء بتثبيت Flutter، تأكد من توفر:

### الأجهزة

- 💻 **نظام التشغيل**: Windows 10/11، macOS، أو Linux
- 💾 **مساحة القرص**: 2.5 GB على الأقل (بدون IDE)
- 🧠 **الذاكرة**: 4 GB RAM على الأقل (يُفضل 8 GB)
- 📶 **الإنترنت**: لتحميل Flutter SDK والحزم

### البرامج

- Git (لإدارة الإصدارات)
- محرر نصوص (VS Code أو Android Studio)

---

## 🪟 التثبيت على Windows

### 1. تحميل Flutter SDK

```powershell
# انتقل إلى https://flutter.dev/docs/get-started/install/windows
# حمّل ملف flutter_windows_X.X.X-stable.zip
```

**أو باستخدام Git:**

```powershell
git clone https://github.com/flutter/flutter.git -b stable
```

### 2. استخراج الملفات

- استخرج الملف المضغوط في مجلد (مثل `C:\src\flutter`)
- ⚠️ **لا تضعه في مجلد يتطلب صلاحيات مثل Program Files**

### 3. إضافة Flutter إلى PATH

**الطريقة 1: عبر واجهة Windows**:

1. ابحث عن "Environment Variables"
2. اختر "Edit the system environment variables"
3. اضغط "Environment Variables"
4. تحت "User variables"، اختر "Path" واضغط "Edit"
5. أضف المسار: `C:\src\flutter\bin`

**الطريقة 2: عبر PowerShell (Admin)**:

```powershell
$env:Path += ";C:\src\flutter\bin"
[Environment]::SetEnvironmentVariable("Path", $env:Path, "User")
```

### 4. التحقق من التثبيت

```powershell
flutter --version
flutter doctor
```

---

## 🍎 التثبيت على macOS

### 1. تحميل Flutter SDK

```bash
# باستخدام Git
cd ~/development
git clone https://github.com/flutter/flutter.git -b stable
```

### 2. إضافة Flutter إلى PATH

**لـ Zsh (الافتراضي في macOS Catalina+):**

```bash
nano ~/.zshrc

# أضف هذا السطر:
export PATH="$PATH:$HOME/development/flutter/bin"

# احفظ واخرج، ثم:
source ~/.zshrc
```

**لـ Bash:**

```bash
nano ~/.bash_profile

# أضف هذا السطر:
export PATH="$PATH:$HOME/development/flutter/bin"

source ~/.bash_profile
```

### 3. التحقق من التثبيت

```bash
flutter --version
flutter doctor
```

---

## 🐧 التثبيت على Linux (Ubuntu/Debian)

### 1. تثبيت المتطلبات

```bash
sudo apt-get update
sudo apt-get install git curl unzip xz-utils zip libglu1-mesa
```

### 2. تحميل Flutter

```bash
cd ~/development
git clone https://github.com/flutter/flutter.git -b stable
```

### 3. إضافة إلى PATH

```bash
nano ~/.bashrc

# أضف:
export PATH="$PATH:$HOME/development/flutter/bin"

source ~/.bashrc
```

---

## 🔍 فهم Flutter Doctor

بعد تشغيل `flutter doctor`، ستحصل على تقرير مثل:

```
Doctor summary (to see all details, run flutter doctor -v):
[✓] Flutter (Channel stable, 3.16.0)
[✗] Android toolchain - develop for Android devices
    ✗ Unable to locate Android SDK.
[✓] Chrome - develop for the web
[✗] Android Studio (not installed)
[✓] VS Code (version 1.85.0)
[✓] Connected device (1 available)
```

### الرموز

- ✅ `[✓]` = مثبت وجاهز
- ❌ `[✗]` = غير مثبت أو يحتاج إعداد
- ⚠️ `[!]` = مثبت لكن به مشكلة

---

## 📱 إعداد Android Development

### 1. تثبيت Android Studio

1. حمّل من: <https://developer.android.com/studio>
2. قم بتثبيت البرنامج
3. افتح Android Studio
4. اتبع معالج الإعداد الأولي

### 2. تثبيت Android SDK

في Android Studio:

1. اذهب إلى **Settings/Preferences**
2. **Appearance & Behavior** → **System Settings** → **Android SDK**
3. تأكد من تثبيت:
   - Android SDK Platform (أحدث إصدار)
   - Android SDK Command-line Tools
   - Android SDK Build-Tools
   - Android Emulator

### 3. تثبيت Flutter Plugin

1. في Android Studio: **Settings** → **Plugins**
2. ابحث عن "Flutter"
3. اضغط **Install**
4. أعد تشغيل Android Studio

### 4. قبول Android Licenses

```bash
flutter doctor --android-licenses
# اضغط 'y' لقبول جميع التراخيص
```

---

## 🍎 إعداد iOS Development (macOS فقط)

### 1. تثبيت Xcode

```bash
# من App Store أو:
xcode-select --install
```

### 2. تثبيت Simulators

1. افتح Xcode
2. **Xcode** → **Preferences** → **Components**
3. حمّل iOS Simulators

### 3. تثبيت CocoaPods

```bash
sudo gem install cocoapods
pod setup
```

---

## 💻 إعداد VS Code

### 1. تثبيت VS Code

حمّل من: <https://code.visualstudio.com/>

### 2. تثبيت Extensions

افتح VS Code واضغط `Ctrl+Shift+X` (أو `Cmd+Shift+X` على Mac):

**الإضافات المطلوبة:**

- Flutter (تتضمن Dart)

**إضافات مفيدة:**

- Awesome Flutter Snippets
- Flutter Widget Snippets
- Pubspec Assist
- Bracket Pair Colorizer
- Error Lens

### 3. إعداد Flutter في VS Code

1. اضغط `Ctrl+Shift+P`
2. اكتب "Flutter: New Project"
3. اتبع التعليمات

---

## 📱 إعداد المحاكي (Emulator)

### Android Emulator

**من Android Studio:**

1. **Tools** → **Device Manager**
2. **Create Virtual Device**
3. اختر جهاز (مثل Pixel 5)
4. اختر System Image (مثل API 33)
5. اضغط **Finish**

**من الـ Terminal:**

```bash
# عرض المحاكيات المتاحة
flutter emulators

# تشغيل محاكي
flutter emulators --launch <emulator_id>
```

### iOS Simulator (macOS فقط)

```bash
open -a Simulator
```

---

## 📲 ربط جهاز حقيقي

### Android

1. **تفعيل وضع المطور:**
   - الإعدادات → حول الهاتف
   - اضغط على "رقم الإصدار" 7 مرات

2. **تفعيل USB Debugging:**
   - الإعدادات → خيارات المطورين
   - فعّل "USB debugging"

3. **توصيل الجهاز:**

   ```bash
   flutter devices
   ```

### iOS (macOS فقط)

1. وصّل iPhone بالكمبيوتر
2. افتح Xcode
3. ثق بالكمبيوتر على الجهاز

4. ```bash
   flutter devices
   ```

---

## 🚀 إنشاء أول مشروع Flutter

### من Terminal

```bash
# إنشاء مشروع جديد
flutter create my_first_app

# الدخول للمشروع
cd my_first_app

# تشغيل التطبيق
flutter run
```

### من VS Code

1. `Ctrl+Shift+P`
2. "Flutter: New Project"
3. اختر "Application"
4. اختر المجلد
5. أدخل اسم المشروع: `my_first_app`

### من Android Studio

1. **File** → **New** → **New Flutter Project**
2. اختر **Flutter Application**
3. أدخل اسم المشروع
4. اضغط **Finish**

---

## 🗂️ بنية المشروع

```text
my_first_app/
├── android/          # كود Android Native
├── ios/              # كود iOS Native
├── lib/              # كود Dart الرئيسي
│   └── main.dart     # نقطة البداية
├── test/             # ملفات الاختبار
├── web/              # كود Web
├── pubspec.yaml      # إدارة الحزم والموارد
└── README.md         # وصف المشروع
```

---

## ✅ التحقق من نجاح الإعداد

### 1. تشغيل Flutter Doctor

```bash
flutter doctor -v
```

يجب أن ترى ✅ أمام:

- Flutter
- Android toolchain
- VS Code أو Android Studio
- Connected device

### 2. تشغيل تطبيق تجريبي

```bash
flutter create test_app
cd test_app
flutter run
```

إذا ظهر التطبيق على المحاكي أو الجهاز، فالإعداد ناجح! 🎉

---

## 🔧 حل المشاكل الشائعة

### ❌ مشكلة: لا يتعرف على flutter command

**الحل:**

- تأكد من إضافة Flutter للـ PATH
- أعد تشغيل Terminal
- تحقق: `echo $PATH` (Mac/Linux) أو `echo %PATH%` (Windows)

### ❌ مشكلة: Android licenses لم يتم قبولها

**الحل:**

```bash
flutter doctor --android-licenses
```

### ❌ مشكلة: لا يظهر المحاكي

**الحل:**

```bash
# تأكد من تثبيت المحاكيات
flutter emulators

# تشغيل محاكي
flutter emulators --launch <emulator_id>
```

### ❌ مشكلة: Hot Reload لا يعمل

**الحل:**

- استخدم `r` في Terminal لـ Hot Reload
- استخدم `R` لـ Hot Restart
- تأكد من حفظ الملفات

---

## 📚 الأوامر المفيدة

```bash
# معلومات الإصدار
flutter --version

# تحديث Flutter
flutter upgrade

# تنظيف المشروع
flutter clean

# عرض الأجهزة المتصلة
flutter devices

# تشغيل على جهاز محدد
flutter run -d <device_id>

# بناء APK
flutter build apk

# بناء للـ Web
flutter build web

# تحليل الكود
flutter analyze

# تنسيق الكود
flutter format .
```

---

## 🎯 الخطوات التالية

الآن بعد إعداد البيئة، أنت جاهز لتعلم Dart و Flutter:

1. **راجع**: [أساسيات Dart](../Dart%20basic/README.md) إذا لم تكن تعرف اللغة
2. **التالي**: [أساسيات لغة Dart](03_dart_basics.md)

---

## 💡 نصائح

- ✅ **احفظ المشاريع في مجلد منظم** (مثل `~/FlutterProjects`)
- ✅ **استخدم Git** من اليوم الأول
- ✅ **شغّل `flutter doctor`** بشكل دوري
- ✅ **حدّث Flutter** شهرياً على الأقل
- ✅ **استخدم Hot Reload** لتسريع التطوير

---

## 📖 المراجع والمصادر

المعلومات في هذا الدرس مستقاة من المصادر الرسمية التالية:

### مصادر التثبيت الرسمية

1. **Flutter Installation Guides**
   - [Windows Installation](https://docs.flutter.dev/get-started/install/windows)
   - [macOS Installation](https://docs.flutter.dev/get-started/install/macos)
   - [Linux Installation](https://docs.flutter.dev/get-started/install/linux)

2. **Platform Setup**
   - [Android Setup](https://docs.flutter.dev/get-started/install/windows#android-setup)
   - [iOS Setup](https://docs.flutter.dev/get-started/install/macos#ios-setup)
   - [Web Setup](https://docs.flutter.dev/get-started/web)

3. **IDE Setup**
   - [VS Code Setup](https://docs.flutter.dev/get-started/editor?tab=vscode)
   - [Android Studio Setup](https://docs.flutter.dev/get-started/editor?tab=androidstudio)

4. **Flutter Doctor**
   - [Flutter Doctor Documentation](https://docs.flutter.dev/reference/flutter-cli#flutter-doctor)

### مصادر الأدوات المطلوبة

5. **Android Studio**
   - [Download Android Studio](https://developer.android.com/studio)
   - [Android SDK Documentation](https://developer.android.com/studio/intro)

6. **Xcode (للـ iOS)**
   - [Xcode on App Store](https://apps.apple.com/us/app/xcode/id497799835)
   - [Xcode Documentation](https://developer.apple.com/xcode/)

7. **VS Code**
   - [Download VS Code](https://code.visualstudio.com/)
   - [VS Code Flutter Extension](https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter)

8. **Git**
   - [Download Git](https://git-scm.com/downloads)
   - [Git Documentation](https://git-scm.com/doc)

### مصادر حل المشاكل

9. **Flutter Troubleshooting**
   - [Common Issues and Solutions](https://docs.flutter.dev/get-started/install/windows#troubleshooting)
   - [Flutter GitHub Issues](https://github.com/flutter/flutter/issues)

10. **Community Resources**
    - [Flutter Discord Community](https://discord.gg/flutter)
    - [Flutter Reddit](https://www.reddit.com/r/FlutterDev/)
    - [Stack Overflow - Flutter Tag](https://stackoverflow.com/questions/tagged/flutter)

### مراجع إضافية

11. **Flutter CLI Commands**
    - [Flutter Command-Line Reference](https://docs.flutter.dev/reference/flutter-cli)

12. **Flutter Best Practices**
    - [Flutter Development Best Practices](https://docs.flutter.dev/perf/best-practices)

13. **Dart Installation**
    - [Dart SDK Installation](https://dart.dev/get-dart)
    - راجع أيضاً: [إعداد بيئة Dart](../Dart%20basic/02_setup.md)

---

## 🔗 روابط مفيدة

- [Flutter YouTube Channel](https://www.youtube.com/c/flutterdev)
- [Flutter Weekly Newsletter](https://flutterweekly.net/)
- [Pub.dev - Flutter Packages](https://pub.dev/)
- [Flutter Awesome - Curated List](https://flutterawesome.com/)

---

[⬅️ السابق: مقدمة إلى Flutter](01_introduction.md)
[🏠 العودة للفهرس](../README.md)
[التالي: أساسيات Dart ➡️](03_dart_basics.md)
