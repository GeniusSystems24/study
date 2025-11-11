# Accessibility - إمكانية الوصول

[← العودة للفهرس الرئيسي](README.md)

## 📋 المحتويات

- [نظرة عامة](#نظرة-عامة)
- [لماذا إمكانية الوصول مهمة](#لماذا-إمكانية-الوصول-مهمة)
- [الويدجت الأساسية](#الويدجت-الأساسية)
- [أفضل الممارسات](#أفضل-الممارسات)
- [الاختبار](#الاختبار)
- [المراجع](#المراجع)

---

## نظرة عامة

**إمكانية الوصول (Accessibility)** تعني جعل تطبيقك قابلاً للاستخدام من قبل أكبر عدد ممكن من المستخدمين، بما في ذلك ذوي الاحتياجات الخاصة. يدعم Flutter إمكانية الوصول من خلال ويدجت متخصصة وAPI قوي.

### الفئات المستهدفة

- 🦯 **ضعاف البصر**: قراء الشاشة، تكبير النص
- 🦻 **ضعاف السمع**: ترجمات، تنبيهات بصرية
- ♿ **محدودي الحركة**: التنقل بلوحة المفاتيح، أهداف لمس كبيرة
- 🧠 **صعوبات التعلم**: واجهات بسيطة، تعليمات واضحة

---

## لماذا إمكانية الوصول مهمة

### الأسباب الأخلاقية

- **المساواة**: الجميع يستحق الوصول للمعلومات والخدمات
- **الشمولية**: بناء منتجات تخدم الجميع

### الأسباب القانونية

- **ADA (Americans with Disabilities Act)**
- **Section 508** في الولايات المتحدة
- **EN 301 549** في الاتحاد الأوروبي

### الأسباب التجارية

- 🌍 **سوق أكبر**: 15% من سكان العالم لديهم إعاقة ما
- 💡 **تجربة أفضل للجميع**: التحسينات تفيد كل المستخدمين
- 🎯 **SEO أفضل**: محركات البحث تفضل المحتوى القابل للوصول

---

## الويدجت الأساسية

### 1. Semantics - الدلالات

الويدجت الأساسية لإضافة معلومات دلالية للعناصر.

```dart
// مثال بسيط
Semantics(
  label: 'زر الإعجاب',
  hint: 'اضغط للإعجاب بالمنشور',
  child: IconButton(
    icon: Icon(Icons.favorite_border),
    onPressed: () {},
  ),
)

// مثال متقدم مع جميع الخصائص
Semantics(
  // النص الوصفي
  label: 'زر تشغيل الموسيقى',
  
  // التلميح
  hint: 'اضغط للتشغيل أو الإيقاف',
  
  // القيمة الحالية
  value: isPlaying ? 'قيد التشغيل' : 'متوقف',
  
  // زر قابل للنقر
  button: true,
  
  // حالة التمكين
  enabled: true,
  
  // حالة مختارة
  selected: isPlaying,
  
  // تعطيل العناصر الفرعية
  excludeSemantics: false,
  
  // زيادة/تقليل
  onIncrease: () {
    setState(() => volume += 10);
  },
  onDecrease: () {
    setState(() => volume -= 10);
  },
  
  child: IconButton(
    icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
    onPressed: () {
      setState(() => isPlaying = !isPlaying);
    },
  ),
)
```

### 2. MergeSemantics - دمج الدلالات

دمج معلومات الوصول من عدة ويدجت فرعية.

```dart
MergeSemantics(
  child: Row(
    children: [
      Icon(Icons.star),
      Text('4.5'),
      Text(' من 5'),
    ],
  ),
)
// قارئ الشاشة سيقرأ: "4.5 من 5" بدلاً من قراءة كل عنصر منفصلاً
```

### 3. ExcludeSemantics - استبعاد الدلالات

استبعاد ويدجت من قراء الشاشة.

```dart
ExcludeSemantics(
  child: Icon(
    Icons.star,
    color: Colors.grey, // أيقونة زخرفية فقط
  ),
)
```

### 4. BlockSemantics - حجب الدلالات

منع العناصر الفرعية من الظهور في شجرة الدلالات.

```dart
BlockSemantics(
  child: Container(
    // محتوى زخرفي لا يحتاج للوصول
  ),
)
```

---

## أفضل الممارسات

### 1. النصوص والتسميات

```dart
// ❌ سيئ: بدون وصف
IconButton(
  icon: Icon(Icons.delete),
  onPressed: () {},
)

// ✅ جيد: مع tooltip
IconButton(
  icon: Icon(Icons.delete),
  tooltip: 'حذف العنصر',
  onPressed: () {},
)

// ✅ أفضل: مع semantics
Semantics(
  label: 'حذف العنصر',
  hint: 'اضغط لحذف العنصر بشكل دائم',
  button: true,
  child: IconButton(
    icon: Icon(Icons.delete),
    onPressed: () {},
  ),
)
```

### 2. حجم الأهداف القابلة للنقر

```dart
// ✅ الحد الأدنى الموصى به: 48x48 pixels
Material(
  child: InkWell(
    onTap: () {},
    child: Container(
      width: 48,
      height: 48,
      alignment: Alignment.center,
      child: Icon(Icons.favorite),
    ),
  ),
)

// ✅ استخدام padding لزيادة منطقة اللمس
IconButton(
  padding: EdgeInsets.all(16), // زيادة المساحة القابلة للنقر
  icon: Icon(Icons.favorite),
  onPressed: () {},
)
```

### 3. التباين اللوني

```dart
// ✅ التباين الكافي بين النص والخلفية
// نسبة التباين يجب أن تكون 4.5:1 على الأقل للنص العادي
Container(
  color: Colors.black,
  child: Text(
    'نص واضح',
    style: TextStyle(
      color: Colors.white,
      fontSize: 16,
    ),
  ),
)

// استخدام أدوات التحقق من التباين:
// https://contrast-ratio.com/
```

### 4. ترتيب التركيز

```dart
// التحكم في ترتيب التنقل
FocusTraversalGroup(
  policy: OrderedTraversalPolicy(),
  child: Column(
    children: [
      FocusTraversalOrder(
        order: NumericFocusOrder(1.0),
        child: TextField(decoration: InputDecoration(labelText: 'الاسم')),
      ),
      FocusTraversalOrder(
        order: NumericFocusOrder(2.0),
        child: TextField(decoration: InputDecoration(labelText: 'البريد')),
      ),
      FocusTraversalOrder(
        order: NumericFocusOrder(3.0),
        child: ElevatedButton(
          onPressed: () {},
          child: Text('إرسال'),
        ),
      ),
    ],
  ),
)
```

### 5. النماذج القابلة للوصول

```dart
class AccessibleForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          // حقل مع تسمية واضحة
          Semantics(
            label: 'حقل الاسم الكامل',
            hint: 'أدخل اسمك الكامل',
            textField: true,
            child: TextFormField(
              decoration: InputDecoration(
                labelText: 'الاسم الكامل',
                helperText: 'الاسم الأول والأخير',
                // إخفاء النص المساعد من قراء الشاشة (موجود في hint)
                semanticCounterText: '',
              ),
            ),
          ),
          
          SizedBox(height: 16),
          
          // مربع اختيار مع وصف
          Semantics(
            label: 'قبول الشروط والأحكام',
            hint: 'يجب الموافقة للمتابعة',
            checked: agreedToTerms,
            child: CheckboxListTile(
              title: Text('أوافق على الشروط والأحكام'),
              value: agreedToTerms,
              onChanged: (value) {},
            ),
          ),
        ],
      ),
    );
  }
}
```

### 6. الإعلانات الحية (Live Regions)

```dart
// إعلام المستخدم بالتغييرات الديناميكية
Semantics(
  liveRegion: true, // إعلان التغييرات فوراً
  child: Text('تم حفظ $itemCount عنصر'),
)

// مثال: عداد
class LiveCounter extends StatefulWidget {
  @override
  _LiveCounterState createState() => _LiveCounterState();
}

class _LiveCounterState extends State<LiveCounter> {
  int count = 0;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Semantics(
          liveRegion: true,
          child: Text('العدد الحالي: $count'),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() => count++);
          },
          child: Text('زيادة'),
        ),
      ],
    );
  }
}
```

---

## الاختبار

### 1. اختبار قارئ الشاشة

```dart
// على Android: TalkBack
// على iOS: VoiceOver
// على الويب: NVDA, JAWS

// تفعيل قارئ الشاشة واختبار:
// - التنقل بين العناصر
// - قراءة المحتوى بشكل صحيح
// - الإجراءات المتاحة
```

### 2. اختبار التباين

```dart
testWidgets('Text has sufficient contrast', (WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: Container(
          color: Colors.white,
          child: Text(
            'Test',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
    ),
  );
  
  // التحقق من التباين الكافي
  // يدوياً أو باستخدام أدوات مثل:
  // https://www.w3.org/TR/WCAG21/#contrast-minimum
});
```

### 3. اختبار حجم الأهداف

```dart
testWidgets('Tap targets are large enough', (WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: IconButton(
          icon: Icon(Icons.add),
          onPressed: () {},
        ),
      ),
    ),
  );
  
  // التحقق من الحجم الأدنى
  final size = tester.getSize(find.byType(IconButton));
  expect(size.width, greaterThanOrEqualTo(48));
  expect(size.height, greaterThanOrEqualTo(48));
});
```

### 4. اختبار Semantics

```dart
testWidgets('Button has correct semantics', (WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Semantics(
        label: 'زر الإرسال',
        button: true,
        enabled: true,
        child: ElevatedButton(
          onPressed: () {},
          child: Text('إرسال'),
        ),
      ),
    ),
  );
  
  // التحقق من الدلالات
  final semantics = tester.getSemantics(find.byType(Semantics));
  expect(
    semantics,
    matchesSemantics(
      label: 'زر الإرسال',
      isButton: true,
      isEnabled: true,
    ),
  );
});
```

---

## المراجع

### التوثيق الرسمي

1. **Flutter Accessibility**  
   [https://docs.flutter.dev/development/accessibility-and-localization/accessibility](https://docs.flutter.dev/development/accessibility-and-localization/accessibility)

2. **Semantics Class**  
   [https://api.flutter.dev/flutter/widgets/Semantics-class.html](https://api.flutter.dev/flutter/widgets/Semantics-class.html)

3. **Accessibility Testing**  
   [https://docs.flutter.dev/testing/accessibility](https://docs.flutter.dev/testing/accessibility)

### معايير الوصول

4. **Web Content Accessibility Guidelines (WCAG) 2.1**  
   [https://www.w3.org/TR/WCAG21/](https://www.w3.org/TR/WCAG21/)

5. **Material Design Accessibility**  
   [https://m3.material.io/foundations/accessible-design/overview](https://m3.material.io/foundations/accessible-design/overview)

6. **Apple Human Interface Guidelines - Accessibility**  
   [https://developer.apple.com/design/human-interface-guidelines/accessibility](https://developer.apple.com/design/human-interface-guidelines/accessibility)

### أدوات

7. **Contrast Checker**  
   [https://contrast-ratio.com/](https://contrast-ratio.com/)

8. **Color Blindness Simulator**  
   [https://www.color-blindness.com/coblis-color-blindness-simulator/](https://www.color-blindness.com/coblis-color-blindness-simulator/)

9. **Accessibility Scanner (Android)**  
   [https://support.google.com/accessibility/android/answer/6376570](https://support.google.com/accessibility/android/answer/6376570)

### مقالات ودروس

10. **A11y Coffee - Accessibility Resources**  
    [https://a11y.coffee/](https://a11y.coffee/)

11. **The A11Y Project**  
    [https://www.a11yproject.com/](https://www.a11yproject.com/)

12. **Google Accessibility**  
    [https://www.google.com/accessibility/](https://www.google.com/accessibility/)

---

[← العودة للفهرس الرئيسي](README.md)
[السابق: Cupertino Widgets](02_cupertino_widgets.md)
[التالي: Animation and Motion →](04_animation_motion.md)

---

**آخر تحديث:** نوفمبر 2025  
**مستوى:** متقدم - احترافي
