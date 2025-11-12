# 40 - النشر - Deployment & Publishing

## 📋 المحتويات

- [المقدمة](#المقدمة)
- [الاستعداد للنشر](#الاستعداد-للنشر)
- [نشر Android](#نشر-android)
- [نشر iOS](#نشر-ios)
- [CI/CD](#cicd)

---

## 🎯 المقدمة

نشر التطبيق هو المرحلة الأخيرة لإيصال تطبيقك للمستخدمين.

---

## 📋 الاستعداد للنشر

### 1. تنظيف الكود

```dart
// إزالة print statements
// ❌ 
print('Debug: User logged in');

// ✅
// استخدم logging package
import 'package:logger/logger.dart';

final logger = Logger();
logger.d('Debug: User logged in');
```

---

### 2. Obfuscation

```bash
flutter build apk --obfuscate --split-debug-info=/<project-name>/<directory>
```

---

### 3. تحديث الإصدار

`pubspec.yaml`:

```yaml
version: 1.0.0+1
# version: <major>.<minor>.<patch>+<build-number>
```

---

## 🤖 نشر Android

### 1. إنشاء Keystore

```bash
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

---

### 2. تكوين Gradle

`android/key.properties`:

```properties
storePassword=<كلمة مرور المخزن>
keyPassword=<كلمة مرور المفتاح>
keyAlias=upload
storeFile=<مسار الـ keystore>
```

`android/app/build.gradle`:

```gradle
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    ...
    
    defaultConfig {
        applicationId "com.example.yourapp"
        minSdkVersion 21
        targetSdkVersion 33
        versionCode flutterVersionCode.toInteger()
        versionName flutterVersionName
    }

    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }

    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            shrinkResources true
        }
    }
}
```

---

### 3. بناء APK/AAB

```bash
# APK
flutter build apk --release

# AAB (مطلوب لـ Google Play)
flutter build appbundle --release
```

الملف في:
- APK: `build/app/outputs/flutter-apk/app-release.apk`
- AAB: `build/app/outputs/bundle/release/app-release.aab`

---

### 4. Google Play Console

1. اذهب إلى [Google Play Console](https://play.google.com/console)
2. أنشئ تطبيق جديد
3. املأ معلومات التطبيق:
   - الاسم
   - الوصف القصير والطويل
   - الأيقونة (512x512 px)
   - لقطات الشاشة
   - فيديو (اختياري)
4. املأ سياسة الخصوصية
5. حدد التصنيف المحتوى
6. ارفع AAB

---

## 🍎 نشر iOS

### 1. تكوين Xcode

افتح `ios/Runner.xcworkspace` في Xcode:

1. اختر Target → Runner
2. General → Identity:
   - Display Name
   - Bundle Identifier
   - Version
   - Build
3. Signing & Capabilities:
   - اختر Team
   - تفعيل Automatically manage signing

---

### 2. الأيقونة

ضع أيقونة التطبيق في `ios/Runner/Assets.xcassets/AppIcon.appiconset/`

أحجام مطلوبة:
- 1024x1024 (App Store)
- 180x180, 120x120, 87x87, 80x80, 60x60, 58x58, 40x40, 29x29, 20x20

---

### 3. بناء IPA

```bash
flutter build ios --release
```

أو من Xcode:
1. Product → Archive
2. اختر Archive → Distribute App
3. اختر App Store Connect
4. Upload

---

### 4. App Store Connect

1. اذهب إلى [App Store Connect](https://appstoreconnect.apple.com)
2. أنشئ تطبيق جديد
3. املأ المعلومات:
   - الاسم
   - اللغة الأساسية
   - Bundle ID
   - SKU
4. أضف لقطات الشاشة:
   - iPhone: 6.5", 5.5"
   - iPad: 12.9", 11"
5. املأ الوصف والكلمات المفتاحية
6. حدد الفئة
7. ارفع Build
8. Submit للمراجعة

---

## 🔄 CI/CD

### GitHub Actions

`.github/workflows/deploy.yml`:

```yaml
name: Deploy

on:
  push:
    branches: [ main ]

jobs:
  build-android:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - uses: actions/setup-java@v3
        with:
          distribution: 'zulu'
          java-version: '11'
      
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.16.0'
          channel: 'stable'
      
      - name: Get dependencies
        run: flutter pub get
      
      - name: Run tests
        run: flutter test
      
      - name: Build APK
        run: flutter build apk --release
      
      - name: Upload APK
        uses: actions/upload-artifact@v3
        with:
          name: app-release
          path: build/app/outputs/flutter-apk/app-release.apk

  build-ios:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v3
      
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.16.0'
          channel: 'stable'
      
      - name: Get dependencies
        run: flutter pub get
      
      - name: Build iOS
        run: flutter build ios --release --no-codesign
```

---

### Codemagic

`codemagic.yaml`:

```yaml
workflows:
  android-workflow:
    name: Android Workflow
    max_build_duration: 60
    environment:
      flutter: stable
    scripts:
      - name: Get dependencies
        script: flutter pub get
      - name: Run tests
        script: flutter test
      - name: Build AAB
        script: flutter build appbundle --release
    artifacts:
      - build/**/outputs/**/*.aab
    publishing:
      google_play:
        credentials: $GCLOUD_SERVICE_ACCOUNT_CREDENTIALS
        track: internal

  ios-workflow:
    name: iOS Workflow
    max_build_duration: 60
    environment:
      flutter: stable
      xcode: latest
      cocoapods: default
    scripts:
      - name: Get dependencies
        script: flutter pub get
      - name: Build IPA
        script: flutter build ipa --release
    artifacts:
      - build/ios/ipa/*.ipa
    publishing:
      app_store_connect:
        api_key: $APP_STORE_CONNECT_PRIVATE_KEY
```

---

## 📊 ما بعد النشر

### 1. Analytics

```yaml
dependencies:
  firebase_analytics: ^10.7.4
```

```dart
import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  static final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  static Future<void> logEvent(String name, Map<String, dynamic> parameters) async {
    await analytics.logEvent(name: name, parameters: parameters);
  }

  static Future<void> logScreen(String screenName) async {
    await analytics.logScreenView(screenName: screenName);
  }
}
```

---

### 2. Crashlytics

```yaml
dependencies:
  firebase_crashlytics: ^3.4.8
```

```dart
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  runApp(MyApp());
}
```

---

### 3. Remote Config

```yaml
dependencies:
  firebase_remote_config: ^4.3.8
```

```dart
import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigService {
  static final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;

  static Future<void> initialize() async {
    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(hours: 1),
      ),
    );

    await remoteConfig.setDefaults({
      'welcome_message': 'مرحباً',
      'show_banner': true,
    });

    await remoteConfig.fetchAndActivate();
  }

  static String getString(String key) {
    return remoteConfig.getString(key);
  }

  static bool getBool(String key) {
    return remoteConfig.getBool(key);
  }
}
```

---

## 📚 المراجع والمصادر

1. **Documentation**
   - [Flutter Deployment](https://flutter.dev/docs/deployment)
   - [Android Publishing](https://developer.android.com/studio/publish)
   - [iOS Publishing](https://developer.apple.com/app-store/submissions/)

2. **Tools**
   - [Google Play Console](https://play.google.com/console)
   - [App Store Connect](https://appstoreconnect.apple.com)
   - [Codemagic](https://codemagic.io)

---

## 💡 نصائح

- ✅ اختبر التطبيق جيداً قبل النشر
- ✅ استخدم Obfuscation للحماية
- ✅ اكتب وصف جذاب
- ✅ استخدم لقطات شاشة احترافية
- ✅ راقب التقييمات والمراجعات
- ✅ حدّث التطبيق بانتظام
- ✅ استخدم Analytics لفهم سلوك المستخدمين

---

## 🎉 تهانينا!

أنهيت دراسة Flutter Basic! الآن أنت جاهز لبناء ونشر تطبيقات احترافية.

**الخطوات القادمة:**
- ابنِ مشاريع حقيقية
- ساهم في مشاريع Open Source
- تابع آخر تحديثات Flutter
- انضم لمجتمع Flutter

---

[⬅️ السابق: الاختبارات](39_testing.md)
[🏠 العودة للفهرس](../README.md)
