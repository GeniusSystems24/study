# أساسيات لغة Dart

## 📚 نظرة عامة

Dart هي لغة البرمجة التي يستخدمها Flutter. في هذا الدرس، سنتعلم الأساسيات الضرورية لبدء تطوير تطبيقات Flutter.

> **💡 ملاحظة**: هذا ملخص سريع للأساسيات. للتعمق أكثر، راجع [خطة تعلم Dart الشاملة](../Dart%20basic/README.md)

---

## 🎯 Hello World في Dart

```dart
void main() {
  print('مرحباً بك في عالم Dart!');
}
```

---

## 📦 المتغيرات (Variables)

### أنواع المتغيرات

```dart
// var - يستنتج النوع تلقائياً
var name = 'أحمد';
var age = 25;

// final - قيمة ثابتة تحدد وقت التشغيل
final city = 'الرياض';
final currentDate = DateTime.now();

// const - قيمة ثابتة تحدد وقت الترجمة
const pi = 3.14159;
const appName = 'تطبيقي';

// نوع محدد
String email = 'ahmed@email.com';
int score = 100;
double price = 99.99;
bool isActive = true;
```

### الفرق بين final و const

```dart
// final - تحدد القيمة مرة واحدة في وقت التشغيل
final time = DateTime.now(); // ✅ صحيح

// const - تحدد القيمة في وقت الترجمة
const time2 = DateTime.now(); // ❌ خطأ!

// أمثلة عملية
final List<int> numbers = [1, 2, 3];
numbers.add(4); // ✅ يمكن تعديل محتوى القائمة

const List<int> fixedNumbers = [1, 2, 3];
fixedNumbers.add(4); // ❌ خطأ!
```

---

## 🔢 أنواع البيانات (Data Types)

### الأنواع الأساسية

```dart
// Numbers
int age = 30;
double height = 1.75;
num score = 95.5; // يقبل int أو double

// Strings
String name = 'محمد';
String multiLine = '''
هذا نص
متعدد الأسطر
''';

// String Interpolation
String greeting = 'مرحباً $name';
String info = 'العمر: ${age + 1}';

// Booleans
bool isLoggedIn = true;
bool hasPermission = false;

// Null
String? nullableName = null; // يمكن أن يكون null
String nonNullName = 'أحمد'; // لا يمكن أن يكون null
```

### Lists (القوائم)

```dart
// قائمة بسيطة
List<String> fruits = ['تفاح', 'موز', 'برتقال'];

// الوصول للعناصر
print(fruits[0]); // تفاح
print(fruits.length); // 3

// إضافة عناصر
fruits.add('عنب');
fruits.addAll(['مانجو', 'فراولة']);

// حذف عناصر
fruits.remove('موز');
fruits.removeAt(0);

// التكرار على القائمة
for (var fruit in fruits) {
  print(fruit);
}

// دوال مفيدة
fruits.first;
fruits.last;
fruits.isEmpty;
fruits.contains('تفاح');
```

### Maps (الخرائط)

```dart
// Map بسيط
Map<String, dynamic> user = {
  'name': 'أحمد',
  'age': 30,
  'email': 'ahmed@email.com',
  'isActive': true
};

// الوصول للقيم
print(user['name']); // أحمد

// إضافة/تعديل قيم
user['phone'] = '0501234567';
user['age'] = 31;

// حذف
user.remove('isActive');

// التكرار
user.forEach((key, value) {
  print('$key: $value');
});

// دوال مفيدة
user.keys;
user.values;
user.containsKey('name');
user.isEmpty;
```

### Sets (المجموعات)

```dart
// Set - لا يسمح بتكرار العناصر
Set<String> cities = {'الرياض', 'جدة', 'الدمام'};

cities.add('مكة');
cities.add('الرياض'); // لن تضاف لأنها موجودة

print(cities.length); // 4
```

---

## 🎭 العمليات (Operators)

### العمليات الحسابية

```dart
int a = 10;
int b = 3;

print(a + b); // 13 - الجمع
print(a - b); // 7  - الطرح
print(a * b); // 30 - الضرب
print(a / b); // 3.333 - القسمة
print(a ~/ b); // 3 - القسمة الصحيحة
print(a % b); // 1 - الباقي

// زيادة ونقصان
int x = 5;
x++; // 6
x--; // 5
++x; // 6
--x; // 5

x += 3; // x = x + 3
x -= 2; // x = x - 2
x *= 2; // x = x * 2
```

### عمليات المقارنة

```dart
int a = 10;
int b = 5;

print(a == b); // false - يساوي
print(a != b); // true - لا يساوي
print(a > b);  // true - أكبر من
print(a < b);  // false - أصغر من
print(a >= b); // true - أكبر أو يساوي
print(a <= b); // false - أصغر أو يساوي
```

### العمليات المنطقية

```dart
bool isLoggedIn = true;
bool hasPermission = false;

print(isLoggedIn && hasPermission); // false - AND
print(isLoggedIn || hasPermission); // true - OR
print(!isLoggedIn); // false - NOT

// مثال عملي
if (isLoggedIn && hasPermission) {
  print('يمكنك الوصول');
} else {
  print('ممنوع الوصول');
}
```

### عمليات خاصة

```dart
// ?? - إذا كانت null أعطني القيمة البديلة
String? name;
String displayName = name ?? 'ضيف';
print(displayName); // ضيف

// ??= - أسند القيمة فقط إذا كانت null
String? username;
username ??= 'default_user';
print(username); // default_user

// ?. - استدعاء آمن
String? email;
print(email?.length); // null بدلاً من خطأ

// ! - تأكيد أن القيمة ليست null
String? city = 'الرياض';
print(city!.length); // 7 (استخدمه بحذر!)
```

---

## 💬 التعليقات (Comments)

```dart
// تعليق سطر واحد

/*
تعليق
متعدد
الأسطر
*/

/// تعليق توثيقي للدوال والفئات
/// يظهر في IntelliSense
void myFunction() {
  // ...
}
```

---

## 🔄 التحويل بين الأنواع

```dart
// String إلى int
String numberStr = '42';
int number = int.parse(numberStr);

// String إلى double
String priceStr = '99.99';
double price = double.parse(priceStr);

// int إلى String
int age = 25;
String ageStr = age.toString();

// double إلى String
double height = 1.75;
String heightStr = height.toString();
String formatted = height.toStringAsFixed(2); // 1.75

// int إلى double
int score = 95;
double scoreDouble = score.toDouble();

// double إلى int
double pi = 3.14;
int piInt = pi.toInt(); // 3 (يحذف الكسور)
```

---

## 🎓 أمثلة عملية

### مثال 1: معلومات المستخدم

```dart
void main() {
  // بيانات المستخدم
  String name = 'أحمد محمد';
  int age = 28;
  double height = 1.75;
  bool isStudent = false;
  
  // عرض المعلومات
  print('الاسم: $name');
  print('العمر: $age سنة');
  print('الطول: ${height}م');
  print('طالب: ${isStudent ? "نعم" : "لا"}');
  
  // حساب العمر بعد 10 سنوات
  int futureAge = age + 10;
  print('العمر بعد 10 سنوات: $futureAge');
}
```

### مثال 2: قائمة المشتريات

```dart
void main() {
  // قائمة المنتجات
  List<Map<String, dynamic>> cart = [
    {'name': 'لابتوب', 'price': 3500.0, 'quantity': 1},
    {'name': 'ماوس', 'price': 80.0, 'quantity': 2},
    {'name': 'لوحة مفاتيح', 'price': 150.0, 'quantity': 1},
  ];
  
  // حساب المجموع
  double total = 0;
  for (var item in cart) {
    double itemTotal = item['price'] * item['quantity'];
    total += itemTotal;
    print('${item['name']}: ${itemTotal} ريال');
  }
  
  print('المجموع الكلي: $total ريال');
}
```

### مثال 3: درجات الطلاب

```dart
void main() {
  Map<String, int> grades = {
    'أحمد': 95,
    'فاطمة': 88,
    'محمد': 92,
    'نورة': 78,
    'خالد': 85,
  };
  
  // حساب المتوسط
  int sum = 0;
  grades.forEach((name, grade) {
    sum += grade;
  });
  double average = sum / grades.length;
  
  print('متوسط الدرجات: ${average.toStringAsFixed(2)}');
  
  // عرض الطلاب المتفوقين (أكثر من 90)
  print('\nالطلاب المتفوقون:');
  grades.forEach((name, grade) {
    if (grade >= 90) {
      print('$name: $grade');
    }
  });
}
```

---

## 🎯 تمارين عملية

### تمرين 1: حساب مؤشر كتلة الجسم (BMI)

```dart
void main() {
  // بياناتك هنا
  double weight = 75.0; // كجم
  double height = 1.75;  // متر
  
  // احسب BMI
  // BMI = الوزن / (الطول * الطول)
  
  // TODO: أكمل الكود
}
```

### تمرين 2: إدارة قائمة مهام

```dart
void main() {
  List<String> tasks = [];
  
  // أضف 3 مهام
  // احذف مهمة واحدة
  // اطبع عدد المهام المتبقية
  // اطبع جميع المهام
  
  // TODO: أكمل الكود
}
```

### تمرين 3: معلومات الكتاب

```dart
void main() {
  // أنشئ Map يحتوي على معلومات كتاب:
  // - العنوان
  // - المؤلف
  // - عدد الصفحات
  // - السعر
  // - متوفر (true/false)
  
  // TODO: أكمل الكود
}
```

---

## 📚 للتعمق أكثر

لمزيد من التفاصيل حول لغة Dart، راجع:

- [المتغيرات وأنواع البيانات](../Dart%20basic/03_variables.md)
- [العمليات والمعاملات](../Dart%20basic/04_operators.md)
- [المجموعات في Dart](../Dart%20basic/07_collections.md)

---

## 📖 المراجع والمصادر

المعلومات في هذا الدرس مستقاة من المصادر الرسمية التالية:

### مصادر Dart الرسمية

1. **Dart Language Tour**
   - [Language Tour Overview](https://dart.dev/guides/language/language-tour)
   - [Variables in Dart](https://dart.dev/guides/language/language-tour#variables)
   - [Built-in Types](https://dart.dev/guides/language/language-tour#built-in-types)

2. **Dart Effective Documentation**
   - [Effective Dart: Style](https://dart.dev/guides/language/effective-dart/style)
   - [Effective Dart: Usage](https://dart.dev/guides/language/effective-dart/usage)

3. **Collections in Dart**
   - [Lists](https://dart.dev/guides/language/language-tour#lists)
   - [Sets](https://dart.dev/guides/language/language-tour#sets)
   - [Maps](https://dart.dev/guides/language/language-tour#maps)

4. **Operators**
   - [Operators in Dart](https://dart.dev/guides/language/language-tour#operators)
   - [Null Safety Operators](https://dart.dev/null-safety/understanding-null-safety#null-aware-operators)

### مصادر داخل المستودع

5. **خطة تعلم Dart الشاملة**
   - [فهرس Dart الكامل](../Dart%20basic/README.md)
   - [أساسيات المتغيرات](../Dart%20basic/03_variables.md)
   - [العمليات](../Dart%20basic/04_operators.md)
   - [المجموعات](../Dart%20basic/07_collections.md)

### مصادر تفاعلية

6. **DartPad - محرر Dart التفاعلي**
   - [DartPad Online Editor](https://dartpad.dev/)
   - [DartPad Tutorials](https://dart.dev/tools/dartpad)

7. **Dart Samples**
   - [Dart Code Samples](https://dart.dev/samples)
   - [Cookbook Examples](https://dart.dev/guides/language/language-tour#code-samples)

### كتب ومراجع إضافية

8. **Dart Documentation**
   - [Dart API Reference](https://api.dart.dev/stable/)
   - [Core Libraries](https://dart.dev/guides/libraries)

9. **Community Resources**
   - [Dart Reddit Community](https://www.reddit.com/r/dartlang/)
   - [Dart on Stack Overflow](https://stackoverflow.com/questions/tagged/dart)

10. **Video Tutorials**
    - [Flutter & Dart - The Complete Guide (Udemy)](https://www.udemy.com/course/learn-flutter-dart-to-build-ios-android-apps/)

---

## 🎯 الخطوات التالية

الآن بعد أن تعلمت الأساسيات، حان الوقت لتعلم التحكم في التدفق:

**التالي**: [التحكم في التدفق (Control Flow)](04_control_flow.md)

---

## 💡 نصائح

- ✅ مارس كتابة الكود في [DartPad](https://dartpad.dev)
- ✅ جرب الأمثلة بنفسك
- ✅ اكتب ملاحظاتك الخاصة
- ✅ لا تنتقل للدرس التالي قبل فهم هذا الدرس جيداً
- ✅ راجع [خطة تعلم Dart الشاملة](../Dart%20basic/README.md) للتعمق أكثر

---

[⬅️ السابق: إعداد البيئة](02_setup.md)
[🏠 العودة للفهرس](../README.md)
[التالي: Control Flow ➡️](04_control_flow.md)
