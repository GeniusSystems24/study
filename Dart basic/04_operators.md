# 4. العمليات والمعاملات (Operators)

## العمليات الحسابية (Arithmetic Operators)

### العمليات الأساسية

```dart
int a = 10;
int b = 3;

print(a + b);   // 13 - الجمع
print(a - b);   // 7  - الطرح
print(a * b);   // 30 - الضرب
print(a / b);   // 3.333... - القسمة (نتيجة double)
print(a ~/ b);  // 3  - القسمة الصحيحة
print(a % b);   // 1  - باقي القسمة
```

### عمليات الزيادة والنقصان

```dart
int counter = 5;

counter++;      // زيادة بعد الاستخدام
++counter;      // زيادة قبل الاستخدام
counter--;      // نقصان بعد الاستخدام
--counter;      // نقصان قبل الاستخدام

print(counter++);  // يطبع 5، ثم يصبح 6
print(++counter);  // يصبح 7، ثم يطبع 7
```

## معاملات المقارنة (Relational Operators)

```dart
int x = 10;
int y = 20;

print(x == y);   // false - يساوي
print(x != y);   // true  - لا يساوي
print(x > y);    // false - أكبر من
print(x < y);    // true  - أصغر من
print(x >= y);   // false - أكبر من أو يساوي
print(x <= y);   // true  - أصغر من أو يساوي
```

## المعاملات المنطقية (Logical Operators)

```dart
bool isStudent = true;
bool hasID = false;

// AND - و
print(isStudent && hasID);  // false

// OR - أو
print(isStudent || hasID);  // true

// NOT - نفي
print(!isStudent);          // false
print(!hasID);              // true
```

### أمثلة عملية

```dart
int age = 25;
bool hasLicense = true;

// يمكنه القيادة إذا كان عمره 18 أو أكثر ولديه رخصة
bool canDrive = age >= 18 && hasLicense;

// خصم للطلاب أو كبار السن
bool getDiscount = age < 18 || age >= 60;
```

## معاملات الإسناد (Assignment Operators)

```dart
int a = 10;

a += 5;    // a = a + 5  -> 15
a -= 3;    // a = a - 3  -> 12
a *= 2;    // a = a * 2  -> 24
a ~/= 4;   // a = a ~/ 4 -> 6
a %= 4;    // a = a % 4  -> 2
```

## معاملات خاصة بـ Dart

### ?? - معامل الدمج الفارغ (Null Coalescing)

```dart
String? username;
String display = username ?? 'ضيف';
print(display);  // ضيف

username = 'أحمد';
display = username ?? 'ضيف';
print(display);  // أحمد
```

### ??= - الإسناد إذا كان فارغاً

```dart
int? score;
score ??= 50;    // score = 50 (لأنها كانت null)
print(score);    // 50

score ??= 100;   // لا يتغير (لأنها ليست null)
print(score);    // 50
```

### ?. - الوصول الآمن (Safe Navigation)

```dart
String? name;
print(name?.length);  // null (بدلاً من خطأ)

name = 'أحمد';
print(name?.length);  // 4
```

### ! - تأكيد عدم الفراغ (Null Assertion)

```dart
String? name = 'أحمد';
int length = name!.length;  // نؤكد أن name ليست null
```

### .. - معامل التسلسل (Cascade Operator)

```dart
class Person {
  String? name;
  int? age;
  
  void display() {
    print('$name - $age');
  }
}

// بدون cascade
Person person = Person();
person.name = 'أحمد';
person.age = 25;
person.display();

// مع cascade
Person person2 = Person()
  ..name = 'محمد'
  ..age = 30
  ..display();
```

### ... و ...? - معامل الانتشار (Spread Operator)

```dart
List<int> numbers1 = [1, 2, 3];
List<int> numbers2 = [4, 5, 6];

// دمج القوائم
List<int> all = [...numbers1, ...numbers2];
print(all);  // [1, 2, 3, 4, 5, 6]

// مع null safety
List<int>? nullableList;
List<int> safe = [...?nullableList, 7, 8, 9];
print(safe);  // [7, 8, 9]
```

## معاملات النوع (Type Test Operators)

```dart
var value = 42;

// is - التحقق من النوع
if (value is int) {
  print('قيمة صحيحة');
}

// is! - عكس is
if (value is! String) {
  print('ليست نصاً');
}

// as - التحويل الصريح
dynamic obj = 'نص';
String str = obj as String;
```

## معاملات البت (Bitwise Operators)

```dart
int a = 5;   // 0101 في النظام الثنائي
int b = 3;   // 0011 في النظام الثنائي

print(a & b);   // 1  - AND
print(a | b);   // 7  - OR
print(a ^ b);   // 6  - XOR
print(~a);      // -6 - NOT
print(a << 1);  // 10 - الإزاحة لليسار
print(a >> 1);  // 2  - الإزاحة لليمين
```

## معامل الشرط الثلاثي (Ternary Operator)

```dart
int age = 20;
String status = age >= 18 ? 'بالغ' : 'قاصر';
print(status);  // بالغ

// متداخل (لا يُنصح به)
String category = age < 13 ? 'طفل' : age < 18 ? 'مراهق' : 'بالغ';
```

## الأسبقية (Precedence)

```dart
int result = 2 + 3 * 4;      // 14 (الضرب أولاً)
int result2 = (2 + 3) * 4;   // 20 (الأقواس أولاً)

// الأسبقية من الأعلى للأدنى:
// 1. معاملات الأقواس ()
// 2. !, -, ++, --
// 3. *, /, ~/, %
// 4. +, -
// 5. <<, >>
// 6. &
// 7. ^
// 8. |
// 9. >=, >, <=, <, as, is, is!
// 10. ==, !=
// 11. &&
// 12. ||
// 13. ??
// 14. ? :
// 15. =, +=, -=, إلخ
```

## أمثلة عملية شاملة

```dart
void main() {
  // مثال 1: حساب السعر بعد الخصم
  double price = 100.0;
  double discount = 0.15;
  double finalPrice = price - (price * discount);
  print('السعر النهائي: $finalPrice');
  
  // مثال 2: التحقق من صلاحية العمر
  int? userAge;
  int age = userAge ?? 0;
  String message = age >= 18 ? 'مسموح' : 'غير مسموح';
  print(message);
  
  // مثال 3: دمج قوائم
  List<String> fruits = ['تفاح', 'موز'];
  List<String>? moreFruits = ['برتقال', 'عنب'];
  List<String> allFruits = [...fruits, ...?moreFruits, 'فراولة'];
  print(allFruits);
  
  // مثال 4: cascade للتهيئة
  var numbers = <int>[]
    ..add(1)
    ..add(2)
    ..add(3);
  print(numbers);
}
```

## نصائح مهمة

1. استخدم `??` بدلاً من الشروط للقيم الافتراضية
2. `?.` يحميك من أخطاء null
3. تجنب الاستخدام المفرط لـ `!` 
4. استخدم `..` لتسلسل العمليات على نفس الكائن
5. انتبه لأسبقية العمليات، استخدم الأقواس عند الشك

---

[⬅️ الموضوع السابق: المتغيرات وأنواع البيانات](03_variables.md) 
 [العودة للفهرس](README.md) 
 [الموضوع التالي: التحكم في التدفق ➡️](05_control_flow.md)
