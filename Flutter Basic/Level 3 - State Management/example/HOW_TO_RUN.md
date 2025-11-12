# 🛠️ كيفية تشغيل المشروع - How to Run

## 📋 المتطلبات الأساسية

### 1. Flutter SDK
```bash
# تحقق من التثبيت
flutter --version

# يجب أن يكون الإصدار 3.0 أو أحدث
```

إذا لم يكن Flutter مثبتاً:
- [تحميل Flutter SDK](https://docs.flutter.dev/get-started/install)

### 2. محرر نصوص
- VS Code (موصى به)
- Android Studio
- IntelliJ IDEA

### 3. Emulator أو Device
- Android Emulator
- iOS Simulator (Mac فقط)
- جهاز فعلي

---

## ⚙️ خطوات التشغيل

### الخطوة 1: الانتقال لمجلد المشروع

#### Windows (PowerShell)
```powershell
cd "f:\genius_systems_development\study\Flutter Basic\level_3_state_management_project"
```

#### Mac/Linux (Terminal)
```bash
cd "/path/to/Flutter Basic/level_3_state_management_project"
```

---

### الخطوة 2: تثبيت التبعيات

```bash
flutter pub get
```

**ماذا يفعل هذا الأمر؟**
- يقوم بتحميل جميع الـ packages المطلوبة
- Provider, Riverpod, BLoC, GetX, وغيرها

**الوقت المتوقع:** 1-3 دقائق

---

### الخطوة 3: التحقق من عدم وجود مشاكل

```bash
flutter doctor
```

**يجب أن ترى:**
- ✓ Flutter SDK
- ✓ Android Toolchain (لـ Android)
- ✓ Xcode (لـ iOS على Mac)
- ✓ Connected Device

---

### الخطوة 4: التحقق من الأجهزة المتاحة

```bash
flutter devices
```

**سترى قائمة بالأجهزة:**
```
Chrome (web)        • chrome     • web-javascript
Android SDK (mobile) • emulator-5554 • android
iPhone 14 (mobile)   • ... • ios
```

---

### الخطوة 5: تشغيل التطبيق

#### تشغيل على الجهاز الافتراضي
```bash
flutter run
```

#### تشغيل على جهاز محدد
```bash
# للاندرويد
flutter run -d emulator-5554

# للـ iOS
flutter run -d "iPhone 14"

# للمتصفح
flutter run -d chrome
```

#### تشغيل في Debug Mode
```bash
flutter run --debug
```

#### تشغيل في Release Mode (أداء أفضل)
```bash
flutter run --release
```

---

## 🔥 Hot Reload

بعد تشغيل التطبيق، يمكنك استخدام Hot Reload:

- **r** - Hot Reload (إعادة تحميل سريعة)
- **R** - Hot Restart (إعادة تشغيل كاملة)
- **q** - إيقاف التطبيق

---

## 🚨 حل المشاكل الشائعة

### مشكلة: "No devices available"

**الحل:**
1. تأكد من تشغيل Emulator
2. أو وصل جهازك الفعلي
3. فعّل USB Debugging على Android

---

### مشكلة: "Pub get failed"

**الحل:**
```bash
# امسح الكاش
flutter clean

# ثم أعد المحاولة
flutter pub get
```

---

### مشكلة: "Build failed"

**الحل:**
```bash
# امسح الـ build
flutter clean

# أعد بناء المشروع
flutter pub get
flutter run
```

---

### مشكلة: "Package not found"

**الحل:**
1. تحقق من `pubspec.yaml`
2. تأكد من وجود الـ package
3. نفّذ:
```bash
flutter pub get
```

---

### مشكلة: "Code Generation" (للـ MobX)

**الحل:**
```bash
flutter pub run build_runner build
```

إذا كانت هناك مشاكل:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## 📱 تشغيل على أجهزة مختلفة

### Android

1. **فتح Android Emulator:**
```bash
# قائمة الـ Emulators
emulator -list-avds

# تشغيل emulator
emulator -avd Pixel_4_API_30
```

2. **تشغيل التطبيق:**
```bash
flutter run
```

---

### iOS (Mac فقط)

1. **فتح iOS Simulator:**
```bash
open -a Simulator
```

2. **تشغيل التطبيق:**
```bash
flutter run
```

---

### Web

```bash
# تشغيل على Chrome
flutter run -d chrome

# تشغيل على Edge
flutter run -d edge
```

---

## 🔧 أوامر إضافية مفيدة

### تحليل الكود
```bash
flutter analyze
```

### تشغيل الـ Tests
```bash
flutter test
```

### بناء APK (Android)
```bash
flutter build apk --release
```

### بناء IPA (iOS)
```bash
flutter build ios --release
```

### بناء للويب
```bash
flutter build web
```

---

## 📊 معلومات الأداء

### Debug Mode
- تطوير سريع
- Hot Reload
- DevTools
- أداء أبطأ قليلاً

### Release Mode
- أداء محسّن
- حجم أصغر
- لا Hot Reload
- للنشر النهائي

---

## 🎯 الخطوات التالية

بعد تشغيل التطبيق بنجاح:

1. ✅ جرّب Dark Mode
2. ✅ استكشف كل قسم
3. ✅ جرّب الأمثلة التفاعلية
4. ✅ اقرأ الكود المصدري
5. ✅ عدّل وجرّب Hot Reload

---

## 💡 نصائح للتطوير

### استخدم DevTools
```bash
flutter run
# ثم افتح DevTools من الرابط المعروض
```

### استخدم Logging
```dart
print('Debug: $variable');
debugPrint('Debug message');
```

### استخدم Hot Reload بذكاء
- **r** للتغييرات الصغيرة في UI
- **R** للتغييرات في State
- أعد التشغيل للتغييرات في `main()`

---

## 📞 الدعم

إذا واجهت مشاكل:

1. راجع [التوثيق الرسمي](https://docs.flutter.dev/)
2. ابحث في [StackOverflow](https://stackoverflow.com/questions/tagged/flutter)
3. انضم لـ [Flutter Community](https://flutter.dev/community)

---

## ✅ Checklist قبل البدء

- [ ] Flutter SDK مثبت
- [ ] `flutter doctor` يعمل بدون مشاكل
- [ ] Emulator/Device متاح
- [ ] `flutter pub get` نفّذ بنجاح
- [ ] التطبيق يعمل

---

**الآن أنت جاهز للبدء! 🚀**

[العودة للـ README](README.md) | [دليل البدء السريع](QUICKSTART.md)
