# 07 - المجموعات المتقدمة (Advanced Collections)

## 📋 المحتويات

- [المقدمة](#المقدمة)
- [List المتقدمة](#list-المتقدمة)
- [Set المتقدمة](#set-المتقدمة)
- [Map المتقدمة](#map-المتقدمة)
- [دوال المجموعات](#دوال-المجموعات)
- [Spread Operator](#spread-operator)
- [Collection If](#collection-if)
- [Collection For](#collection-for)
- [أمثلة عملية](#أمثلة-عملية)

---

## 🎯 المقدمة

المجموعات في Dart توفر دوال قوية لمعالجة البيانات بطريقة فعالة وموجزة.

### أنواع المجموعات الأساسية

- 📝 **List**: مجموعة مرتبة تسمح بالتكرار
- 🔢 **Set**: مجموعة غير مرتبة بدون تكرار
- 🗺️ **Map**: مجموعة مفتاح-قيمة

---

## 📝 List المتقدمة

### إنشاء وتعديل القوائم

```dart
void main() {
  // قائمة قابلة للتعديل
  List<int> numbers = [1, 2, 3, 4, 5];
  
  // قائمة غير قابلة للتعديل
  List<int> immutable = const [1, 2, 3];
  
  // قائمة بحجم ثابت
  List<int> fixed = List.filled(5, 0); // [0, 0, 0, 0, 0]
  
  // قائمة قابلة للنمو
  List<String> names = List.empty(growable: true);
  names.add('أحمد');
  names.add('فاطمة');
  
  // إنشاء قائمة من Iterable
  List<int> doubled = List.generate(5, (i) => i * 2);
  print(doubled); // [0, 2, 4, 6, 8]
}
```

### دوال List المفيدة

```dart
void main() {
  List<int> numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  
  // first و last
  print(numbers.first);  // 1
  print(numbers.last);   // 10
  
  // indexOf و lastIndexOf
  print(numbers.indexOf(5));      // 4
  print(numbers.lastIndexOf(5));  // 4
  
  // contains
  print(numbers.contains(5));  // true
  
  // sublist
  print(numbers.sublist(2, 5));  // [3, 4, 5]
  
  // reversed
  print(numbers.reversed.toList());  // [10, 9, 8, 7, 6, 5, 4, 3, 2, 1]
  
  // asMap
  var mapped = numbers.asMap();
  print(mapped);  // {0: 1, 1: 2, 2: 3, ...}
}
```

---

## 🔢 Set المتقدمة

### عمليات على Sets

```dart
void main() {
  Set<int> set1 = {1, 2, 3, 4, 5};
  Set<int> set2 = {4, 5, 6, 7, 8};
  
  // الاتحاد (Union)
  print(set1.union(set2));  // {1, 2, 3, 4, 5, 6, 7, 8}
  
  // التقاطع (Intersection)
  print(set1.intersection(set2));  // {4, 5}
  
  // الفرق (Difference)
  print(set1.difference(set2));  // {1, 2, 3}
  
  // التحقق من مجموعة فرعية
  Set<int> subset = {1, 2};
  print(subset.difference(set1).isEmpty);  // true - subset هي مجموعة فرعية من set1
  
  // إزالة التكرارات
  List<int> withDuplicates = [1, 2, 2, 3, 3, 3, 4];
  Set<int> unique = withDuplicates.toSet();
  print(unique);  // {1, 2, 3, 4}
}
```

---

## 🗺️ Map المتقدمة

### دوال Map المفيدة

```dart
void main() {
  Map<String, int> ages = {
    'أحمد': 25,
    'فاطمة': 30,
    'علي': 22,
    'سارة': 28
  };
  
  // putIfAbsent - إضافة إذا لم يكن موجوداً
  ages.putIfAbsent('محمد', () => 27);
  print(ages);
  
  // update - تحديث قيمة
  ages.update('أحمد', (value) => value + 1);
  print(ages['أحمد']);  // 26
  
  // updateAll - تحديث جميع القيم
  ages.updateAll((key, value) => value + 1);
  print(ages);
  
  // removeWhere - إزالة بشرط
  ages.removeWhere((key, value) => value < 25);
  print(ages);
  
  // map - تحويل Map
  var doubled = ages.map((key, value) => MapEntry(key, value * 2));
  print(doubled);
}
```

---

## 🔧 دوال المجموعات

### map - تحويل العناصر

```dart
void main() {
  List<int> numbers = [1, 2, 3, 4, 5];
  
  // تضعيف كل عدد
  var doubled = numbers.map((n) => n * 2).toList();
  print(doubled);  // [2, 4, 6, 8, 10]
  
  // تحويل إلى String
  var strings = numbers.map((n) => 'رقم $n').toList();
  print(strings);  // [رقم 1, رقم 2, ...]
}
```

### where - تصفية العناصر

```dart
void main() {
  List<int> numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  
  // الأعداد الزوجية
  var evens = numbers.where((n) => n % 2 == 0).toList();
  print(evens);  // [2, 4, 6, 8, 10]
  
  // الأعداد الأكبر من 5
  var greaterThan5 = numbers.where((n) => n > 5).toList();
  print(greaterThan5);  // [6, 7, 8, 9, 10]
}
```

### reduce و fold

```dart
void main() {
  List<int> numbers = [1, 2, 3, 4, 5];
  
  // reduce - دمج العناصر
  var sum = numbers.reduce((a, b) => a + b);
  print('المجموع: $sum');  // 15
  
  var product = numbers.reduce((a, b) => a * b);
  print('الحاصل الضرب: $product');  // 120
  
  // fold - مع قيمة ابتدائية
  var sumWithInitial = numbers.fold(10, (prev, element) => prev + element);
  print('المجموع مع 10: $sumWithInitial');  // 25
  
  // دمج قوائم
  List<List<int>> lists = [[1, 2], [3, 4], [5]];
  var flattened = lists.fold<List<int>>([], (prev, element) => prev..addAll(element));
  print(flattened);  // [1, 2, 3, 4, 5]
}
```

### any و every

```dart
void main() {
  List<int> numbers = [1, 2, 3, 4, 5];
  
  // any - هل يوجد عنصر يحقق الشرط؟
  print(numbers.any((n) => n > 3));     // true
  print(numbers.any((n) => n > 10));    // false
  
  // every - هل كل العناصر تحقق الشرط؟
  print(numbers.every((n) => n > 0));   // true
  print(numbers.every((n) => n > 3));   // false
}
```

### firstWhere و lastWhere

```dart
void main() {
  List<String> names = ['أحمد', 'محمد', 'فاطمة', 'محمود'];
  
  // firstWhere - أول عنصر يحقق الشرط
  var first = names.firstWhere(
    (name) => name.startsWith('م'),
    orElse: () => 'غير موجود'
  );
  print(first);  // محمد
  
  // lastWhere - آخر عنصر يحقق الشرط
  var last = names.lastWhere(
    (name) => name.startsWith('م'),
    orElse: () => 'غير موجود'
  );
  print(last);  // محمود
}
```

### skip و take

```dart
void main() {
  List<int> numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  
  // skip - تخطي أول n عنصر
  var skipped = numbers.skip(3).toList();
  print(skipped);  // [4, 5, 6, 7, 8, 9, 10]
  
  // take - أخذ أول n عنصر
  var taken = numbers.take(5).toList();
  print(taken);  // [1, 2, 3, 4, 5]
  
  // دمجهما - pagination
  var page2 = numbers.skip(5).take(5).toList();
  print(page2);  // [6, 7, 8, 9, 10]
}
```

---

## 🌟 Spread Operator

```dart
void main() {
  List<int> list1 = [1, 2, 3];
  List<int> list2 = [4, 5, 6];
  
  // دمج القوائم
  List<int> combined = [...list1, ...list2];
  print(combined);  // [1, 2, 3, 4, 5, 6]
  
  // إضافة عناصر
  List<int> extended = [0, ...list1, 10, ...list2, 20];
  print(extended);  // [0, 1, 2, 3, 10, 4, 5, 6, 20]
  
  // Null-aware spread
  List<int>? nullableList;
  List<int> safe = [1, 2, ...?nullableList, 3];
  print(safe);  // [1, 2, 3]
}
```

---

## ❓ Collection If

```dart
void main() {
  bool includeZero = true;
  bool includeTen = false;
  
  List<int> numbers = [
    if (includeZero) 0,
    1, 2, 3, 4, 5,
    if (includeTen) 10
  ];
  
  print(numbers);  // [0, 1, 2, 3, 4, 5]
  
  // مثال: قائمة أزرار مشروطة
  bool isAdmin = true;
  List<String> buttons = [
    'الرئيسية',
    'الملف الشخصي',
    if (isAdmin) 'لوحة التحكم',
    if (isAdmin) 'إعدادات النظام',
  ];
  
  print(buttons);
}
```

---

## 🔁 Collection For

```dart
void main() {
  // إنشاء قائمة باستخدام for
  List<int> squares = [
    for (int i = 1; i <= 5; i++) i * i
  ];
  print(squares);  // [1, 4, 9, 16, 25]
  
  // دمج قوائم متعددة
  List<List<int>> matrix = [
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9]
  ];
  
  List<int> flattened = [
    for (var row in matrix)
      for (var item in row)
        item
  ];
  print(flattened);  // [1, 2, 3, 4, 5, 6, 7, 8, 9]
}
```

---

## 💼 أمثلة عملية

### مثال 1: معالجة بيانات الطلاب

```dart
class Student {
  String name;
  int age;
  double grade;
  
  Student(this.name, this.age, this.grade);
  
  @override
  String toString() => '$name (العمر: $age، الدرجة: $grade)';
}

void main() {
  List<Student> students = [
    Student('أحمد', 20, 85.5),
    Student('فاطمة', 22, 92.0),
    Student('علي', 19, 78.5),
    Student('سارة', 21, 95.0),
    Student('محمد', 20, 88.5),
  ];
  
  // الطلاب الناجحون (>= 80)
  var passed = students.where((s) => s.grade >= 80).toList();
  print('الطلاب الناجحون:');
  passed.forEach(print);
  
  // المتوسط العام
  var average = students.map((s) => s.grade).reduce((a, b) => a + b) / students.length;
  print('\nالمتوسط العام: ${average.toStringAsFixed(2)}');
  
  // أعلى درجة
  var topStudent = students.reduce((a, b) => a.grade > b.grade ? a : b);
  print('الطالب المتفوق: $topStudent');
  
  // ترتيب تنازلي
  students.sort((a, b) => b.grade.compareTo(a.grade));
  print('\nالترتيب التنازلي:');
  students.forEach(print);
  
  // تجميع حسب العمر
  Map<int, List<Student>> byAge = {};
  for (var student in students) {
    byAge.putIfAbsent(student.age, () => []).add(student);
  }
  print('\nتجميع حسب العمر:');
  byAge.forEach((age, students) {
    print('العمر $age: ${students.map((s) => s.name).join(', ')}');
  });
}
```

### مثال 2: معالجة سلة التسوق

```dart
class Product {
  String name;
  double price;
  int quantity;
  
  Product(this.name, this.price, this.quantity);
  
  double get total => price * quantity;
  
  @override
  String toString() => '$name × $quantity = ${total.toStringAsFixed(2)} ريال';
}

class ShoppingCart {
  List<Product> _items = [];
  
  void addProduct(Product product) {
    var existing = _items.firstWhere(
      (p) => p.name == product.name,
      orElse: () => Product('', 0, 0)
    );
    
    if (existing.name.isNotEmpty) {
      existing.quantity += product.quantity;
    } else {
      _items.add(product);
    }
  }
  
  void removeProduct(String name) {
    _items.removeWhere((p) => p.name == name);
  }
  
  double get totalPrice => _items.map((p) => p.total).fold(0, (a, b) => a + b);
  
  int get totalItems => _items.map((p) => p.quantity).fold(0, (a, b) => a + b);
  
  void displayCart() {
    print('محتويات السلة:');
    print('=' * 50);
    _items.forEach(print);
    print('=' * 50);
    print('عدد المنتجات: $totalItems');
    print('الإجمالي: ${totalPrice.toStringAsFixed(2)} ريال');
  }
  
  List<Product> getExpensiveItems(double minPrice) {
    return _items.where((p) => p.price >= minPrice).toList();
  }
}

void main() {
  var cart = ShoppingCart();
  
  cart.addProduct(Product('تفاح', 5.0, 3));
  cart.addProduct(Product('برتقال', 4.0, 2));
  cart.addProduct(Product('موز', 3.0, 5));
  cart.addProduct(Product('تفاح', 5.0, 2)); // سيُضاف للتفاح الموجود
  
  cart.displayCart();
  
  print('\nالمنتجات الغالية (>= 4 ريال):');
  cart.getExpensiveItems(4.0).forEach(print);
}
```

---

## 📚 للتعمق أكثر

لمزيد من التفاصيل، راجع:

- [المجموعات في Dart](../Dart%20basic/07_collections.md)
- [البرمجة التفاعلية](09_async_programming.md)

---

## 📖 المراجع والمصادر

### مصادر Dart الرسمية

1. **Dart Collections**
   - [Collections Overview](https://dart.dev/guides/libraries/library-tour#collections)
   - [List Class](https://api.dart.dev/stable/dart-core/List-class.html)
   - [Set Class](https://api.dart.dev/stable/dart-core/Set-class.html)
   - [Map Class](https://api.dart.dev/stable/dart-core/Map-class.html)

2. **Iterable Collections**
   - [Iterables Codelab](https://dart.dev/codelabs/iterables)
   - [Iterable Class](https://api.dart.dev/stable/dart-core/Iterable-class.html)
   - [Common Collection Methods](https://dart.dev/guides/libraries/library-tour#collections)

3. **Collection Operators**
   - [Spread Operator](https://dart.dev/guides/language/language-tour#spread-operator)
   - [Collection If](https://dart.dev/guides/language/language-tour#collection-operators)
   - [Collection For](https://dart.dev/guides/language/language-tour#collection-operators)

### مصادر تفاعلية

4. **DartPad Examples**
   - [Collections in DartPad](https://dartpad.dev/)
   - [Iterables Tutorial](https://dart.dev/codelabs/iterables)

### مصادر داخل المستودع

5. **خطة تعلم Dart الشاملة**
   - [فهرس Dart الكامل](../Dart%20basic/README.md)
   - [المجموعات](../Dart%20basic/07_collections.md)

### مراجع API

6. **Dart Core Library**
   - [dart:core Collections](https://api.dart.dev/stable/dart-core/dart-core-library.html)
   - [dart:collection](https://api.dart.dev/stable/dart-collection/dart-collection-library.html)

### مصادر إضافية

7. **Community Resources**
   - [Dart Collections on Stack Overflow](https://stackoverflow.com/questions/tagged/dart+collections)

8. **Video Tutorials**
   - [Dart Collections - YouTube](https://www.youtube.com/dartlang)

---

## 💡 نصائح

- ✅ استخدم `where` للتصفية و `map` للتحويل
- ✅ استخدم `reduce` و `fold` لدمج القيم
- ✅ استخدم `any` و `every` للتحقق من الشروط
- ✅ استخدم Spread Operator لدمج المجموعات
- ✅ استخدم Collection If و For لإنشاء مجموعات ديناميكية
- ✅ فضّل `toSet()` لإزالة التكرارات
- ✅ مارس على [DartPad](https://dartpad.dev/)

---

[⬅️ السابق: البرمجة الكائنية](06_oop_dart.md)
[🏠 العودة للفهرس](../README.md)
[التالي: معالجة الأخطاء ➡️](08_error_handling.md)
