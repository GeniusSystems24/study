# 🚀 كيفية تشغيل مشروع Level 2 Widgets

## المتطلبات

- ✅ Flutter SDK 3.0 أو أحدث
- ✅ Dart SDK 3.0 أو أحدث
- ✅ محرر نصوص (VS Code أو Android Studio)
- ✅ محاكي Android/iOS أو جهاز حقيقي

---

## خطوات التشغيل

### 1. التحقق من تثبيت Flutter

```bash
flutter doctor
```

يجب أن ترى علامات صح ✓ بجانب Flutter و Dart.

### 2. الانتقال إلى مجلد المشروع

```bash
cd "Flutter Basic/level_2_widgets_project"
```

### 3. تثبيت التبعيات

```bash
flutter pub get
```

### 4. تشغيل المشروع

#### الطريقة الأولى: من سطر الأوامر

```bash
flutter run
```

إذا كان لديك أكثر من جهاز/محاكي متصل:

```bash
# عرض الأجهزة المتاحة
flutter devices

# اختيار جهاز معين
flutter run -d <device_id>
```

#### الطريقة الثانية: من VS Code

1. افتح المشروع في VS Code
2. اضغط `F5` أو اختر `Run > Start Debugging`
3. أو اضغط `Ctrl+F5` للتشغيل بدون Debugging

#### الطريقة الثالثة: من Android Studio

1. افتح المشروع
2. اختر الجهاز من القائمة العلوية
3. اضغط على زر Run ▶️

---

## استخدام Hot Reload

أثناء التشغيل، يمكنك:

- اضغط `r` في Terminal لعمل **Hot Reload** (إعادة تحميل سريعة)
- اضغط `R` لعمل **Hot Restart** (إعادة تشغيل كاملة)
- اضغط `q` للخروج

---

## حل المشاكل الشائعة

### المشكلة: Packages لم تثبت بشكل صحيح

```bash
flutter clean
flutter pub get
```

### المشكلة: لا يوجد أجهزة متصلة

- **Android**: تأكد من تشغيل محاكي Android
- **iOS**: تأكد من تشغيل محاكي iOS (macOS فقط)
- **Chrome**: قم بتفعيل web support:
  ```bash
  flutter config --enable-web
  ```

### المشكلة: أخطاء في البناء

```bash
flutter clean
flutter pub get
flutter run
```

---

## تشغيل على منصات مختلفة

### Android

```bash
flutter run -d android
```

### iOS (macOS فقط)

```bash
flutter run -d ios
```

### Web

```bash
flutter run -d chrome
```

### Windows (على Windows فقط)

```bash
flutter run -d windows
```

---

## نصائح مفيدة

1. **استخدام DevTools**: قم بفتح DevTools لتصحيح الأخطاء
   ```bash
   flutter pub global activate devtools
   flutter pub global run devtools
   ```

2. **تحسين الأداء**: قم بالبناء في وضع Release للاختبار النهائي
   ```bash
   flutter run --release
   ```

3. **تصدير APK (Android)**:
   ```bash
   flutter build apk
   ```

4. **تصدير IPA (iOS)**:
   ```bash
   flutter build ios
   ```

---

## دعم

إذا واجهت أي مشاكل:

1. راجع [Flutter Documentation](https://docs.flutter.dev/)
2. تحقق من [Flutter GitHub Issues](https://github.com/flutter/flutter/issues)
3. اطلب المساعدة في [Flutter Community](https://flutter.dev/community)

---

**حظاً موفقاً في التعلم! 🎉**
