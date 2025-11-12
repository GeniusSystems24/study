# 12 - Layout Widgets

## 📋 المحتويات

- [المقدمة](#المقدمة)
- [Padding](#padding)
- [Center](#center)
- [Align](#align)
- [SizedBox](#sizedbox)
- [Expanded و Flexible](#expanded-و-flexible)
- [Stack](#stack)
- [Wrap](#wrap)
- [أمثلة عملية](#أمثلة-عملية)

---

## 🎯 المقدمة

Layout Widgets تتحكم في كيفية ترتيب وعرض العناصر على الشاشة.

---

## 📏 Padding

إضافة مسافات حول widget.

```dart
// مسافة متساوية من جميع الجوانب
Padding(
  padding: const EdgeInsets.all(16),
  child: Text('نص مع مسافة'),
)

// مسافة أفقية ورأسية
Padding(
  padding: const EdgeInsets.symmetric(
    horizontal: 20,
    vertical: 10,
  ),
  child: Text('نص'),
)

// مسافة مخصصة لكل جانب
Padding(
  padding: const EdgeInsets.only(
    left: 10,
    right: 10,
    top: 20,
    bottom: 5,
  ),
  child: Text('نص'),
)

// مسافة من التوجيه (LTR/RTL)
Padding(
  padding: const EdgeInsets.fromLTRB(10, 20, 10, 5),
  child: Text('نص'),
)
```

---

## 🎯 Center

وضع widget في المنتصف.

```dart
Center(
  child: Text('في المنتصف'),
)

// مع عرض وارتفاع محدد
Center(
  widthFactor: 2.0,  // ضعف عرض الطفل
  heightFactor: 1.5, // 1.5 مرة ارتفاع الطفل
  child: Container(
    width: 100,
    height: 100,
    color: Colors.blue,
  ),
)
```

---

## 📍 Align

محاذاة widget في موضع معين.

```dart
// محاذاة لليسار العلوي
Align(
  alignment: Alignment.topLeft,
  child: Text('أعلى اليسار'),
)

// محاذاة لليمين السفلي
Align(
  alignment: Alignment.bottomRight,
  child: Icon(Icons.star),
)

// محاذاة مخصصة
Align(
  alignment: Alignment(0.5, -0.5), // x: 0.5, y: -0.5
  child: Text('موضع مخصص'),
)

// جميع المحاذاات المتاحة
Alignment.topLeft
Alignment.topCenter
Alignment.topRight
Alignment.centerLeft
Alignment.center
Alignment.centerRight
Alignment.bottomLeft
Alignment.bottomCenter
Alignment.bottomRight
```

---

## 📐 SizedBox

صندوق بحجم محدد.

```dart
// مسافة عمودية
SizedBox(height: 20)

// مسافة أفقية
SizedBox(width: 20)

// صندوق بحجم محدد
SizedBox(
  width: 200,
  height: 100,
  child: Container(color: Colors.blue),
)

// صندوق يملأ العرض
SizedBox(
  width: double.infinity,
  child: ElevatedButton(
    onPressed: () {},
    child: Text('زر عريض'),
  ),
)

// صندوق مربع
SizedBox.square(
  dimension: 100,
  child: Container(color: Colors.red),
)

// صندوق بحجم الطفل
SizedBox.shrink()
```

---

## 📊 Expanded و Flexible

### Expanded

يملأ المساحة المتاحة:

```dart
Row(
  children: [
    Container(
      width: 50,
      height: 50,
      color: Colors.red,
    ),
    Expanded(
      child: Container(
        height: 50,
        color: Colors.blue,
      ),
    ),
    Container(
      width: 50,
      height: 50,
      color: Colors.green,
    ),
  ],
)

// مع flex للتحكم في النسبة
Row(
  children: [
    Expanded(
      flex: 1,
      child: Container(color: Colors.red, height: 50),
    ),
    Expanded(
      flex: 2,
      child: Container(color: Colors.blue, height: 50),
    ),
    Expanded(
      flex: 1,
      child: Container(color: Colors.green, height: 50),
    ),
  ],
)
```

### Flexible

مرن في استخدام المساحة:

```dart
Row(
  children: [
    Flexible(
      flex: 1,
      fit: FlexFit.tight, // مثل Expanded
      child: Container(color: Colors.red, height: 50),
    ),
    Flexible(
      flex: 2,
      fit: FlexFit.loose, // يأخذ فقط ما يحتاجه
      child: Container(color: Colors.blue, height: 50),
    ),
  ],
)
```

---

## 📚 Stack

تكديس widgets فوق بعضها:

```dart
Stack(
  children: [
    // الخلفية
    Container(
      width: 200,
      height: 200,
      color: Colors.blue,
    ),
    // في المنتصف
    Center(
      child: Text(
        'في المنتصف',
        style: TextStyle(color: Colors.white, fontSize: 24),
      ),
    ),
    // في الزاوية
    Positioned(
      top: 10,
      right: 10,
      child: Icon(Icons.star, color: Colors.yellow),
    ),
  ],
)
```

### Positioned

تحديد موقع دقيق داخل Stack:

```dart
Stack(
  children: [
    Container(width: 300, height: 300, color: Colors.grey),
    
    // أعلى اليسار
    Positioned(
      top: 10,
      left: 10,
      child: Container(width: 50, height: 50, color: Colors.red),
    ),
    
    // أسفل اليمين
    Positioned(
      bottom: 10,
      right: 10,
      child: Container(width: 50, height: 50, color: Colors.blue),
    ),
    
    // ملء العرض في الأسفل
    Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        height: 50,
        color: Colors.green.withOpacity(0.7),
        child: Center(child: Text('شريط سفلي')),
      ),
    ),
  ],
)
```

### Stack مع Alignment

```dart
Stack(
  alignment: Alignment.center,
  children: [
    Container(width: 200, height: 200, color: Colors.blue),
    Text(
      'نص',
      style: TextStyle(color: Colors.white, fontSize: 24),
    ),
  ],
)
```

---

## 🔄 Wrap

ترتيب widgets مع الانتقال لسطر جديد عند الحاجة:

```dart
Wrap(
  spacing: 8,      // المسافة الأفقية
  runSpacing: 8,   // المسافة الرأسية
  children: [
    Chip(label: Text('Flutter')),
    Chip(label: Text('Dart')),
    Chip(label: Text('Mobile')),
    Chip(label: Text('iOS')),
    Chip(label: Text('Android')),
    Chip(label: Text('Web')),
    Chip(label: Text('Desktop')),
  ],
)

// مع محاذاة
Wrap(
  alignment: WrapAlignment.center,
  spacing: 10,
  children: List.generate(
    10,
    (index) => Container(
      width: 80,
      height: 80,
      color: Colors.primaries[index % Colors.primaries.length],
      child: Center(child: Text('$index')),
    ),
  ),
)
```

---

## 💼 أمثلة عملية

### مثال 1: بطاقة ملف شخصي

```dart
class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // الصورة الشخصية
          Stack(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage('https://via.placeholder.com/150'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // الاسم
          const Text(
            'أحمد محمد',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 8),
          
          // الوصف
          Text(
            'مطور تطبيقات Flutter',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
          
          const SizedBox(height: 20),
          
          // الإحصائيات
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStat('120', 'متابِع'),
              Container(
                width: 1,
                height: 40,
                color: Colors.grey.shade300,
              ),
              _buildStat('89', 'متابَع'),
              Container(
                width: 1,
                height: 40,
                color: Colors.grey.shade300,
              ),
              _buildStat('45', 'منشور'),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // الأزرار
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('متابعة'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('رسالة'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}
```

### مثال 2: شبكة منتجات مع Wrap

```dart
class ProductGrid extends StatelessWidget {
  final List<String> products = [
    'هاتف',
    'لابتوب',
    'ساعة ذكية',
    'سماعات',
    'كاميرا',
    'تلفاز',
    'جهاز لوحي',
    'طابعة',
  ];

  ProductGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: products.map((product) {
          return Container(
            width: (MediaQuery.of(context).size.width - 48) / 2,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.devices,
                  size: 40,
                  color: Colors.blue.shade700,
                ),
                const SizedBox(height: 8),
                Text(
                  product,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
```

### مثال 3: شاشة تفاصيل مع Stack

```dart
class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // الصورة الكبيرة في الأعلى
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 300,
            child: Image.network(
              'https://via.placeholder.com/400x300',
              fit: BoxFit.cover,
            ),
          ),
          
          // زر الرجوع
          Positioned(
            top: 40,
            left: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
          
          // المحتوى
          Positioned(
            top: 270,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'اسم المنتج',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.favorite_border),
                          onPressed: () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 20),
                        const SizedBox(width: 4),
                        const Text('4.5 (120 تقييم)'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'الوصف',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'هذا نص وصفي طويل للمنتج يشرح تفاصيله ومميزاته والفوائد التي يقدمها للمستخدم.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      '299 ريال',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // زر الشراء
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'أضف إلى السلة',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

---

## 📚 للتعمق أكثر

**التالي**: [Button Widgets](13_button_widgets.md)

---

## 📖 المراجع والمصادر

### مصادر Flutter الرسمية

1. **Layout Widgets**
   - [Layout Widgets Overview](https://docs.flutter.dev/development/ui/widgets/layout)
   - [Building Layouts Tutorial](https://docs.flutter.dev/development/ui/layout/tutorial)
   - [Understanding Constraints](https://docs.flutter.dev/development/ui/layout/constraints)

2. **Widget Documentation**
   - [Padding](https://api.flutter.dev/flutter/widgets/Padding-class.html)
   - [Center](https://api.flutter.dev/flutter/widgets/Center-class.html)
   - [Align](https://api.flutter.dev/flutter/widgets/Align-class.html)
   - [SizedBox](https://api.flutter.dev/flutter/widgets/SizedBox-class.html)
   - [Expanded](https://api.flutter.dev/flutter/widgets/Expanded-class.html)
   - [Flexible](https://api.flutter.dev/flutter/widgets/Flexible-class.html)
   - [Stack](https://api.flutter.dev/flutter/widgets/Stack-class.html)
   - [Positioned](https://api.flutter.dev/flutter/widgets/Positioned-class.html)
   - [Wrap](https://api.flutter.dev/flutter/widgets/Wrap-class.html)

3. **Layout Patterns**
   - [Common Layout Patterns](https://docs.flutter.dev/cookbook/layout)
   - [Responsive Design](https://docs.flutter.dev/development/ui/layout/responsive)

### مصادر تفاعلية

4. **Flutter Gallery**
   - [Layout Examples](https://gallery.flutter.dev/)

---

## 💡 نصائح

- ✅ استخدم `SizedBox` للمسافات بدلاً من `Container` فارغ
- ✅ `Expanded` يأخذ كل المساحة المتاحة
- ✅ `Flexible` يأخذ فقط ما يحتاجه (إلا إذا كان `FlexFit.tight`)
- ✅ استخدم `Stack` لتكديس العناصر
- ✅ `Positioned` يعمل فقط داخل `Stack`
- ✅ `Wrap` مفيد للعناصر التي تحتاج للانتقال لسطر جديد
- ✅ استخدم `Align` للمحاذاة المخصصة

---

[⬅️ السابق: Widgets الأساسية](11_basic_widgets.md)
[🏠 العودة للفهرس](../README.md)
[التالي: Button Widgets ➡️](13_button_widgets.md)
