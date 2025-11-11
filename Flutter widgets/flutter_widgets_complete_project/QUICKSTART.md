# دليل البدء السريع ⚡

## خطوات التشغيل السريع

### 1. تثبيت Flutter

تأكد من تثبيت Flutter SDK:

```bash
flutter --version
```

يجب أن يكون الإصدار 3.0.0 أو أحدث.

### 2. فتح المشروع

```bash
cd flutter_widgets_complete_project
```

### 3. تحميل الحزم

```bash
flutter pub get
```

### 4. التشغيل

```bash
flutter run
```

## اختيار الجهاز

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

### Windows

```bash
flutter run -d windows
```

### عرض الأجهزة المتاحة

```bash
flutter devices
```

## حل المشاكل الشائعة

### مشكلة: لا توجد أجهزة متصلة

**الحل:**

- للأندرويد: قم بتشغيل المحاكي
- للويب: سيتم فتح Chrome تلقائياً
- للنوافذ: التشغيل مباشر على Windows

### مشكلة: خطأ في pub get

**الحل:**

```bash
flutter clean
flutter pub get
```

### مشكلة: خطأ في Google Fonts

**الحل:**
تأكد من اتصالك بالإنترنت عند أول تشغيل لتحميل الخطوط.

## البناء للإنتاج

### Android APK

```bash
flutter build apk --release
```

### Android App Bundle

```bash
flutter build appbundle --release
```

### iOS

```bash
flutter build ios --release
```

### Web

```bash
flutter build web --release
```

### Windows

```bash
flutter build windows --release
```

## نصائح

1. **Hot Reload**: اضغط `r` في Terminal أثناء التشغيل
2. **Hot Restart**: اضغط `R` في Terminal
3. **فتح DevTools**: اضغط `d` في Terminal
4. **إيقاف التطبيق**: اضغط `q` في Terminal

## التعديل والتخصيص

1. **تغيير اللون الرئيسي**: عدل في `lib/main.dart` السطر 18
2. **إضافة أمثلة**: عدل ملفات `lib/screens/`
3. **تغيير الخط**: عدل في `lib/main.dart` السطر 21

---

**ملاحظة**: جميع الأمثلة تعمل مباشرة دون حاجة لإعدادات إضافية!
