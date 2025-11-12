# 11 - Widgets الأساسية

## 📋 المحتويات

- [المقدمة](#المقدمة)
- [ما هو Widget](#ما-هو-widget)
- [أنواع Widgets](#أنواع-widgets)
- [Text Widget](#text-widget)
- [Container Widget](#container-widget)
- [Row و Column](#row-و-column)
- [Image Widget](#image-widget)
- [Icon Widget](#icon-widget)
- [أمثلة عملية](#أمثلة-عملية)

---

## 🎯 المقدمة

الـ Widgets هي اللبنات الأساسية لبناء واجهات المستخدم في Flutter. كل شيء في Flutter هو Widget!

### مفاهيم أساسية

- 🧱 كل عنصر في الشاشة هو Widget
- 🔗 Widgets تتداخل لتشكيل شجرة
- 🎨 تتحكم في المظهر والسلوك
- ⚡ خفيفة الوزن وقابلة لإعادة الاستخدام

---

## 🧩 ما هو Widget

Widget هو وصف لجزء من واجهة المستخدم.

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
      home: Scaffold(
        appBar: AppBar(
          title: const Text('مرحباً بك'),
        ),
        body: const Center(
          child: Text('أول Widget'),
        ),
      ),
    );
  }
}
```

---

## 📦 أنواع Widgets

### 1. StatelessWidget

Widget لا يتغير حالته:

```dart
class GreetingWidget extends StatelessWidget {
  final String name;
  
  const GreetingWidget({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Text('مرحباً $name');
  }
}

// الاستخدام
const GreetingWidget(name: 'أحمد')
```

### 2. StatefulWidget

Widget يمكن أن يتغير:

```dart
class CounterWidget extends StatefulWidget {
  const CounterWidget({super.key});

  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int _count = 0;

  void _increment() {
    setState(() {
      _count++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('العدد: $_count'),
        ElevatedButton(
          onPressed: _increment,
          child: const Text('زيادة'),
        ),
      ],
    );
  }
}
```

---

## 📝 Text Widget

### الاستخدام الأساسي

```dart
// نص بسيط
const Text('مرحباً بك في Flutter')

// نص مع تنسيق
Text(
  'نص منسّق',
  style: TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.blue,
    fontFamily: 'Cairo',
  ),
)

// نص مع محاذاة
Text(
  'نص طويل يحتاج إلى عدة أسطر لعرضه بشكل صحيح',
  textAlign: TextAlign.center,
  maxLines: 2,
  overflow: TextOverflow.ellipsis,
)
```

### TextStyle المتقدم

```dart
Text(
  'نص متقدم',
  style: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: Colors.blue.shade700,
    letterSpacing: 1.5,
    wordSpacing: 2.0,
    decoration: TextDecoration.underline,
    decorationColor: Colors.red,
    decorationStyle: TextDecorationStyle.wavy,
    shadows: [
      Shadow(
        color: Colors.grey,
        offset: Offset(2, 2),
        blurRadius: 3,
      ),
    ],
  ),
)
```

### RichText

```dart
RichText(
  text: TextSpan(
    style: DefaultTextStyle.of(context).style,
    children: [
      const TextSpan(
        text: 'مرحباً ',
        style: TextStyle(fontSize: 18),
      ),
      TextSpan(
        text: 'أحمد',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
      const TextSpan(
        text: '!',
        style: TextStyle(fontSize: 18),
      ),
    ],
  ),
)
```

---

## 📦 Container Widget

Container هو widget متعدد الاستخدامات للتخطيط والتزيين.

### خصائص Container

```dart
Container(
  // الأبعاد
  width: 200,
  height: 100,
  
  // الهوامش الخارجية
  margin: const EdgeInsets.all(16),
  
  // الهوامش الداخلية
  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  
  // التزيين
  decoration: BoxDecoration(
    color: Colors.blue,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.5),
        spreadRadius: 2,
        blurRadius: 5,
        offset: const Offset(0, 3),
      ),
    ],
  ),
  
  // المحتوى
  child: const Text(
    'محتوى',
    style: TextStyle(color: Colors.white),
  ),
)
```

### أمثلة Container متنوعة

```dart
// 1. بطاقة بسيطة
Container(
  width: 300,
  padding: const EdgeInsets.all(20),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(10),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 10,
      ),
    ],
  ),
  child: const Text('بطاقة'),
)

// 2. دائرة ملونة
Container(
  width: 100,
  height: 100,
  decoration: const BoxDecoration(
    color: Colors.blue,
    shape: BoxShape.circle,
  ),
)

// 3. حاوية بحدود
Container(
  padding: const EdgeInsets.all(15),
  decoration: BoxDecoration(
    border: Border.all(color: Colors.blue, width: 2),
    borderRadius: BorderRadius.circular(8),
  ),
  child: const Text('نص بحدود'),
)

// 4. تدرج لوني
Container(
  width: 200,
  height: 100,
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [Colors.blue, Colors.purple],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(12),
  ),
)
```

---

## 📐 Row و Column

### Row - صف أفقي

```dart
Row(
  mainAxisAlignment: MainAxisAlignment.spaceAround,
  crossAxisAlignment: CrossAxisAlignment.center,
  children: [
    Icon(Icons.star, color: Colors.yellow),
    Text('تقييم'),
    Text('4.5'),
  ],
)

// مع Expanded
Row(
  children: [
    Expanded(
      flex: 2,
      child: Container(color: Colors.red, height: 50),
    ),
    Expanded(
      flex: 1,
      child: Container(color: Colors.blue, height: 50),
    ),
  ],
)
```

### Column - عمود رأسي

```dart
Column(
  mainAxisAlignment: MainAxisAlignment.center,
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text('العنوان', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
    SizedBox(height: 10),
    Text('الوصف'),
    SizedBox(height: 20),
    ElevatedButton(
      onPressed: () {},
      child: Text('إجراء'),
    ),
  ],
)
```

### MainAxisAlignment و CrossAxisAlignment

```dart
// MainAxisAlignment
Column(
  mainAxisAlignment: MainAxisAlignment.start,      // البداية
  mainAxisAlignment: MainAxisAlignment.end,        // النهاية
  mainAxisAlignment: MainAxisAlignment.center,     // المنتصف
  mainAxisAlignment: MainAxisAlignment.spaceBetween, // توزيع متساوٍ
  mainAxisAlignment: MainAxisAlignment.spaceAround,  // مسافات حول العناصر
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,  // مسافات متساوية
)

// CrossAxisAlignment
Column(
  crossAxisAlignment: CrossAxisAlignment.start,   // البداية
  crossAxisAlignment: CrossAxisAlignment.end,     // النهاية
  crossAxisAlignment: CrossAxisAlignment.center,  // المنتصف
  crossAxisAlignment: CrossAxisAlignment.stretch, // ملء العرض
)
```

---

## 🖼️ Image Widget

### صورة من الأصول

```dart
Image.asset(
  'assets/images/logo.png',
  width: 100,
  height: 100,
  fit: BoxFit.cover,
)
```

### صورة من الإنترنت

```dart
Image.network(
  'https://example.com/image.jpg',
  width: 200,
  height: 200,
  fit: BoxFit.contain,
  loadingBuilder: (context, child, loadingProgress) {
    if (loadingProgress == null) return child;
    return Center(
      child: CircularProgressIndicator(
        value: loadingProgress.expectedTotalBytes != null
            ? loadingProgress.cumulativeBytesLoaded /
                loadingProgress.expectedTotalBytes!
            : null,
      ),
    );
  },
  errorBuilder: (context, error, stackTrace) {
    return Icon(Icons.error);
  },
)
```

### BoxFit أنواع

```dart
Image.asset('path', fit: BoxFit.contain)   // احتواء كامل
Image.asset('path', fit: BoxFit.cover)     // تغطية كاملة
Image.asset('path', fit: BoxFit.fill)      // ملء مع تمدد
Image.asset('path', fit: BoxFit.fitWidth)  // ملء العرض
Image.asset('path', fit: BoxFit.fitHeight) // ملء الارتفاع
Image.asset('path', fit: BoxFit.none)      // بدون تعديل
Image.asset('path', fit: BoxFit.scaleDown) // تصغير فقط
```

---

## 🎨 Icon Widget

### الأيقونات المدمجة

```dart
Icon(
  Icons.home,
  size: 30,
  color: Colors.blue,
)

Icon(Icons.favorite, color: Colors.red, size: 40)
Icon(Icons.star, color: Colors.yellow)
Icon(Icons.shopping_cart, color: Colors.green)
Icon(Icons.person, color: Colors.grey)
```

### أيقونات شائعة

```dart
// التنقل
Icons.home
Icons.search
Icons.settings
Icons.menu
Icons.arrow_back
Icons.arrow_forward

// الإجراءات
Icons.add
Icons.delete
Icons.edit
Icons.save
Icons.share
Icons.download

// التواصل
Icons.email
Icons.phone
Icons.message
Icons.notifications

// الوسائط
Icons.play_arrow
Icons.pause
Icons.stop
Icons.volume_up
Icons.camera
```

---

## 💼 أمثلة عملية

### مثال 1: بطاقة منتج

```dart
class ProductCard extends StatelessWidget {
  final String title;
  final String price;
  final String imageUrl;

  const ProductCard({
    super.key,
    required this.title,
    required this.price,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // الصورة
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(12),
            ),
            child: Image.network(
              imageUrl,
              width: double.infinity,
              height: 150,
              fit: BoxFit.cover,
            ),
          ),
          
          // المحتوى
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$price ريال',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(
                      Icons.shopping_cart,
                      color: Colors.blue.shade700,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// الاستخدام
ProductCard(
  title: 'ساعة ذكية',
  price: '299',
  imageUrl: 'https://example.com/watch.jpg',
)
```

### مثال 2: صف بيانات المستخدم

```dart
class UserInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const UserInfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// الاستخدام
Column(
  children: [
    UserInfoRow(
      icon: Icons.person,
      label: 'الاسم',
      value: 'أحمد محمد',
    ),
    UserInfoRow(
      icon: Icons.email,
      label: 'البريد الإلكتروني',
      value: 'ahmed@example.com',
    ),
    UserInfoRow(
      icon: Icons.phone,
      label: 'الهاتف',
      value: '+966 50 123 4567',
    ),
  ],
)
```

### مثال 3: صفحة ترحيب

```dart
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade400, Colors.blue.shade800],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // الشعار
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.flutter_dash,
                  size: 60,
                  color: Colors.blue,
                ),
              ),
              
              const SizedBox(height: 40),
              
              // العنوان
              const Text(
                'مرحباً بك!',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              
              const SizedBox(height: 16),
              
              // الوصف
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  'ابدأ رحلتك في تعلم Flutter وبناء تطبيقات رائعة',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
              ),
              
              const SizedBox(height: 60),
              
              // الأزرار
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'تسجيل الدخول',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white, width: 2),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'إنشاء حساب',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

---

## 📚 للتعمق أكثر

**التالي**: [Layout Widgets](12_layout_widgets.md)

---

## 📖 المراجع والمصادر

### مصادر Flutter الرسمية

1. **Flutter Widgets**
   - [Widget Catalog](https://docs.flutter.dev/development/ui/widgets)
   - [Widget of the Week](https://www.youtube.com/playlist?list=PLjxrf2q8roU23XGwz3Km7sQZFTdB996iG)
   - [Introduction to Widgets](https://docs.flutter.dev/development/ui/widgets-intro)

2. **Basic Widgets**
   - [Text Widget](https://api.flutter.dev/flutter/widgets/Text-class.html)
   - [Container Widget](https://api.flutter.dev/flutter/widgets/Container-class.html)
   - [Row Widget](https://api.flutter.dev/flutter/widgets/Row-class.html)
   - [Column Widget](https://api.flutter.dev/flutter/widgets/Column-class.html)
   - [Image Widget](https://api.flutter.dev/flutter/widgets/Image-class.html)
   - [Icon Widget](https://api.flutter.dev/flutter/widgets/Icon-class.html)

3. **Widget Types**
   - [StatelessWidget](https://api.flutter.dev/flutter/widgets/StatelessWidget-class.html)
   - [StatefulWidget](https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html)

### التصميم والتخطيط

4. **Layout Guide**
   - [Building Layouts](https://docs.flutter.dev/development/ui/layout)
   - [Layout Widgets](https://docs.flutter.dev/development/ui/widgets/layout)

5. **Styling**
   - [TextStyle](https://api.flutter.dev/flutter/painting/TextStyle-class.html)
   - [BoxDecoration](https://api.flutter.dev/flutter/painting/BoxDecoration-class.html)

### مصادر تفاعلية

6. **Flutter Samples**
   - [Flutter Gallery](https://gallery.flutter.dev/)
   - [Widget Examples](https://flutter.github.io/samples/)

7. **Community Resources**
   - [Flutter Awesome Widgets](https://flutterawesome.com/tags/widget/)
   - [Flutter Widget Guide](https://www.didierboelens.com/)

---

## 💡 نصائح

- ✅ استخدم `const` للـ widgets الثابتة لتحسين الأداء
- ✅ افصل الـ widgets المعقدة إلى widgets أصغر
- ✅ استخدم `SizedBox` للمسافات بدلاً من `Padding` فارغ
- ✅ استخدم `Column` و `Row` مع `MainAxisAlignment` و `CrossAxisAlignment`
- ✅ استخدم `Expanded` و `Flexible` لتوزيع المساحة
- ✅ جرّب `Container` decoration للحصول على تصاميم جميلة
- ✅ استخدم Hot Reload لرؤية التغييرات فوراً

---

[⬅️ السابق: بنية Flutter](../Level%201%20-%20Basics/10_flutter_structure.md)
[🏠 العودة للفهرس](../README.md)
[التالي: Layout Widgets ➡️](12_layout_widgets.md)
