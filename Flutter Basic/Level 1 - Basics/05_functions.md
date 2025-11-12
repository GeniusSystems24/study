# 05 - الدوال (Functions)

## 📋 المحتويات

- [المقدمة](#المقدمة)
- [أنواع الدوال](#أنواع-الدوال)
- [المعاملات](#المعاملات)
- [القيم المرجعة](#القيم-المرجعة)
- [الدوال المجهولة](#الدوال-المجهولة)
- [الدوال عالية المستوى](#الدوال-عالية-المستوى)
- [أمثلة عملية](#أمثلة-عملية)
- [تمارين](#تمارين)

---

## 🎯 المقدمة

الدوال (Functions) هي كتل برمجية قابلة لإعادة الاستخدام تنفذ مهمة محددة.

### لماذا نستخدم الدوال؟

- ✅ إعادة استخدام الكود
- ✅ تنظيم البرنامج
- ✅ سهولة الصيانة
- ✅ تقسيم المهام المعقدة

---

## 📦 أنواع الدوال

### 1. دالة بسيطة بدون قيمة مرجعة

```dart
void sayHello() {
  print('مرحباً بك!');
}

void main() {
  sayHello(); // مرحباً بك!
}
```

### 2. دالة مع قيمة مرجعة

```dart
int add(int a, int b) {
  return a + b;
}

double multiply(double x, double y) {
  return x * y;
}

void main() {
  print(add(5, 3));           // 8
  print(multiply(4.5, 2.0));  // 9.0
}
```

### 3. دالة مختصرة (Arrow Function)

```dart
// الطريقة التقليدية
int square(int n) {
  return n * n;
}

// الطريقة المختصرة
int squareShort(int n) => n * n;

bool isEven(int n) => n % 2 == 0;

String greet(String name) => 'مرحباً يا $name';

void main() {
  print(square(5));        // 25
  print(squareShort(5));   // 25
  print(isEven(4));        // true
  print(greet('أحمد'));    // مرحباً يا أحمد
}
```

---

## 🔧 المعاملات

### 1. معاملات مطلوبة (Required Parameters)

```dart
String fullName(String firstName, String lastName) {
  return '$firstName $lastName';
}

void main() {
  print(fullName('محمد', 'أحمد')); // محمد أحمد
}
```

### 2. معاملات اختيارية (Optional Parameters)

#### أ. معاملات موضعية اختيارية

```dart
String greeting(String name, [String? title]) {
  if (title != null) {
    return 'مرحباً $title $name';
  }
  return 'مرحباً $name';
}

void main() {
  print(greeting('أحمد'));           // مرحباً أحمد
  print(greeting('أحمد', 'دكتور'));  // مرحباً دكتور أحمد
}
```

#### ب. معاملات مسماة (Named Parameters)

```dart
void printInfo({
  required String name,
  int? age,
  String? city
}) {
  print('الاسم: $name');
  if (age != null) print('العمر: $age');
  if (city != null) print('المدينة: $city');
}

void main() {
  printInfo(name: 'فاطمة');
  printInfo(name: 'علي', age: 25);
  printInfo(name: 'سارة', age: 30, city: 'القاهرة');
}
```

### 3. قيم افتراضية (Default Values)

```dart
String createMessage(String text, {String prefix = 'رسالة', int priority = 1}) {
  return '[$prefix - المستوى $priority] $text';
}

void main() {
  print(createMessage('مرحباً'));
  // [رسالة - المستوى 1] مرحباً
  
  print(createMessage('تحذير', prefix: 'تنبيه', priority: 3));
  // [تنبيه - المستوى 3] تحذير
}
```

### 4. معاملات متغيرة العدد

```dart
int sum(List<int> numbers) {
  int total = 0;
  for (int num in numbers) {
    total += num;
  }
  return total;
}

void main() {
  print(sum([1, 2, 3]));           // 6
  print(sum([10, 20, 30, 40]));    // 100
}
```

---

## 🔄 القيم المرجعة

### إرجاع أنواع مختلفة

```dart
// إرجاع String
String getDay(int day) {
  switch (day) {
    case 1: return 'الإثنين';
    case 2: return 'الثلاثاء';
    case 3: return 'الأربعاء';
    default: return 'غير معروف';
  }
}

// إرجاع List
List<int> getEvenNumbers(int max) {
  List<int> evens = [];
  for (int i = 0; i <= max; i++) {
    if (i % 2 == 0) evens.add(i);
  }
  return evens;
}

// إرجاع Map
Map<String, dynamic> getUserInfo(String name, int age) {
  return {
    'name': name,
    'age': age,
    'isAdult': age >= 18
  };
}

void main() {
  print(getDay(1));                    // الإثنين
  print(getEvenNumbers(10));           // [0, 2, 4, 6, 8, 10]
  print(getUserInfo('أحمد', 25));     // {name: أحمد, age: 25, isAdult: true}
}
```

---

## 🎭 الدوال المجهولة (Anonymous Functions)

### دالة مجهولة بسيطة

```dart
void main() {
  // دالة عادية
  var add = (int a, int b) {
    return a + b;
  };
  
  // دالة مجهولة مختصرة
  var multiply = (int a, int b) => a * b;
  
  print(add(5, 3));       // 8
  print(multiply(4, 2));  // 8
}
```

### استخدام الدوال المجهولة مع forEach

```dart
void main() {
  List<int> numbers = [1, 2, 3, 4, 5];
  
  // دالة مجهولة
  numbers.forEach((number) {
    print(number * 2);
  });
  
  // نسخة مختصرة
  numbers.forEach((n) => print(n * 2));
}
```

---

## 🚀 الدوال عالية المستوى (Higher-Order Functions)

### دالة تأخذ دالة كمعامل

```dart
void executeOperation(int a, int b, Function operation) {
  print(operation(a, b));
}

void main() {
  executeOperation(10, 5, (a, b) => a + b);  // 15
  executeOperation(10, 5, (a, b) => a - b);  // 5
  executeOperation(10, 5, (a, b) => a * b);  // 50
}
```

### دالة ترجع دالة

```dart
Function makeMultiplier(int multiplier) {
  return (int value) => value * multiplier;
}

void main() {
  var multiplyBy2 = makeMultiplier(2);
  var multiplyBy5 = makeMultiplier(5);
  
  print(multiplyBy2(10));  // 20
  print(multiplyBy5(10));  // 50
}
```

### دوال List الشائعة

```dart
void main() {
  List<int> numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  
  // map - تحويل كل عنصر
  var doubled = numbers.map((n) => n * 2);
  print(doubled.toList()); // [2, 4, 6, 8, 10, 12, 14, 16, 18, 20]
  
  // where - تصفية العناصر
  var evens = numbers.where((n) => n % 2 == 0);
  print(evens.toList()); // [2, 4, 6, 8, 10]
  
  // reduce - دمج العناصر
  var sum = numbers.reduce((a, b) => a + b);
  print(sum); // 55
  
  // any - هل يوجد عنصر يحقق الشرط؟
  var hasEven = numbers.any((n) => n % 2 == 0);
  print(hasEven); // true
  
  // every - هل كل العناصر تحقق الشرط؟
  var allPositive = numbers.every((n) => n > 0);
  print(allPositive); // true
}
```

---

## 💼 أمثلة عملية

### مثال 1: حاسبة متقدمة

```dart
double calculate(double a, double b, String operation) {
  switch (operation) {
    case '+': return a + b;
    case '-': return a - b;
    case '*': return a * b;
    case '/': 
      if (b == 0) throw Exception('لا يمكن القسمة على صفر');
      return a / b;
    case '%': return a % b;
    default: throw Exception('عملية غير معروفة');
  }
}

void main() {
  try {
    print(calculate(10, 5, '+'));  // 15.0
    print(calculate(10, 5, '-'));  // 5.0
    print(calculate(10, 5, '*'));  // 50.0
    print(calculate(10, 5, '/'));  // 2.0
  } catch (e) {
    print('خطأ: $e');
  }
}
```

### مثال 2: معالجة قائمة الطلاب

```dart
class Student {
  String name;
  double grade;
  
  Student(this.name, this.grade);
  
  @override
  String toString() => '$name: $grade';
}

List<Student> filterByGrade(List<Student> students, double minGrade) {
  return students.where((s) => s.grade >= minGrade).toList();
}

double calculateAverage(List<Student> students) {
  if (students.isEmpty) return 0;
  double sum = students.map((s) => s.grade).reduce((a, b) => a + b);
  return sum / students.length;
}

Student? findTopStudent(List<Student> students) {
  if (students.isEmpty) return null;
  return students.reduce((a, b) => a.grade > b.grade ? a : b);
}

void main() {
  List<Student> students = [
    Student('أحمد', 85),
    Student('فاطمة', 92),
    Student('علي', 78),
    Student('سارة', 95),
    Student('محمد', 88),
  ];
  
  print('جميع الطلاب:');
  students.forEach(print);
  
  print('\nالطلاب الممتازون (>= 90):');
  var excellent = filterByGrade(students, 90);
  excellent.forEach(print);
  
  print('\nالمتوسط العام: ${calculateAverage(students).toStringAsFixed(2)}');
  
  var topStudent = findTopStudent(students);
  print('الطالب المتفوق: $topStudent');
}
```

### مثال 3: نظام تسجيل الدخول

```dart
typedef ValidationResult = ({bool isValid, String? error});

ValidationResult validateEmail(String email) {
  if (email.isEmpty) {
    return (isValid: false, error: 'البريد الإلكتروني مطلوب');
  }
  if (!email.contains('@')) {
    return (isValid: false, error: 'البريد الإلكتروني غير صحيح');
  }
  return (isValid: true, error: null);
}

ValidationResult validatePassword(String password) {
  if (password.isEmpty) {
    return (isValid: false, error: 'كلمة المرور مطلوبة');
  }
  if (password.length < 6) {
    return (isValid: false, error: 'كلمة المرور قصيرة جداً');
  }
  return (isValid: true, error: null);
}

bool login(String email, String password) {
  var emailValidation = validateEmail(email);
  if (!emailValidation.isValid) {
    print('خطأ: ${emailValidation.error}');
    return false;
  }
  
  var passwordValidation = validatePassword(password);
  if (!passwordValidation.isValid) {
    print('خطأ: ${passwordValidation.error}');
    return false;
  }
  
  print('تم تسجيل الدخول بنجاح!');
  return true;
}

void main() {
  login('', 'password123');              // خطأ: البريد الإلكتروني مطلوب
  login('test', 'password123');          // خطأ: البريد الإلكتروني غير صحيح
  login('test@example.com', '123');      // خطأ: كلمة المرور قصيرة جداً
  login('test@example.com', 'password123'); // تم تسجيل الدخول بنجاح!
}
```

---

## 🎯 تمارين

### تمرين 1: دالة لحساب الخصم

```dart
double calculateDiscount(double price, {double discountPercent = 0}) {
  // احسب السعر بعد الخصم
  // املأ الكود هنا
}

void main() {
  print(calculateDiscount(100));           // 100
  print(calculateDiscount(100, discountPercent: 10)); // 90
  print(calculateDiscount(100, discountPercent: 25)); // 75
}
```

### تمرين 2: دالة للبحث في قائمة

```dart
List<String> searchNames(List<String> names, String query) {
  // ابحث عن الأسماء التي تحتوي على query
  // املأ الكود هنا
}

void main() {
  List<String> names = ['أحمد', 'محمد', 'فاطمة', 'محمود', 'علي'];
  print(searchNames(names, 'محم')); // [محمد, محمود]
}
```

### تمرين 3: دالة لترتيب الأعداد

```dart
List<int> sortNumbers(List<int> numbers, {bool ascending = true}) {
  // رتب الأعداد تصاعدياً أو تنازلياً
  // املأ الكود هنا
}

void main() {
  List<int> nums = [5, 2, 8, 1, 9, 3];
  print(sortNumbers(nums));                    // [1, 2, 3, 5, 8, 9]
  print(sortNumbers(nums, ascending: false));  // [9, 8, 5, 3, 2, 1]
}
```

---

## 📚 للتعمق أكثر

لمزيد من التفاصيل، راجع:

- [الدوال في Dart](../Dart%20basic/06_functions.md)
- [البرمجة الكائنية](../Dart%20basic/08_oop_part1.md)

---

## 📖 المراجع والمصادر

### مصادر Dart الرسمية

1. **Dart Language Tour - Functions**
   - [Functions Overview](https://dart.dev/guides/language/language-tour#functions)
   - [Parameters](https://dart.dev/guides/language/language-tour#parameters)
   - [Optional Parameters](https://dart.dev/guides/language/language-tour#optional-parameters)
   - [Named Parameters](https://dart.dev/guides/language/language-tour#named-parameters)
   - [Anonymous Functions](https://dart.dev/guides/language/language-tour#anonymous-functions)
   - [Lexical Scope](https://dart.dev/guides/language/language-tour#lexical-scope)

2. **Effective Dart - Functions**
   - [Function Design Guidelines](https://dart.dev/guides/language/effective-dart/design#functions)
   - [Prefer Using Arrow Syntax](https://dart.dev/guides/language/effective-dart/usage#do-use--to-separate-a-named-parameter-from-its-default-value)
   - [Named Parameters Best Practices](https://dart.dev/guides/language/effective-dart/design#avoid-positional-boolean-parameters)

3. **Higher-Order Functions**
   - [First-Class Functions](https://dart.dev/guides/language/language-tour#functions-as-first-class-objects)
   - [Closures](https://dart.dev/guides/language/language-tour#lexical-closures)
   - [Returning Functions](https://dart.dev/guides/language/language-tour#returning-functions)

4. **Collection Methods**
   - [Iterable Collections](https://dart.dev/codelabs/iterables)
   - [map() Method](https://api.dart.dev/stable/dart-core/Iterable/map.html)
   - [where() Method](https://api.dart.dev/stable/dart-core/Iterable/where.html)
   - [reduce() Method](https://api.dart.dev/stable/dart-core/Iterable/reduce.html)
   - [forEach() Method](https://api.dart.dev/stable/dart-core/Iterable/forEach.html)

### مصادر تفاعلية

5. **DartPad Examples**
   - [Functions in DartPad](https://dartpad.dev/)
   - [Interactive Function Examples](https://dart.dev/tutorials)

6. **Dart Codelabs**
   - [Dart Functions Codelab](https://dart.dev/codelabs/dart-cheatsheet)
   - [Iterables Codelab](https://dart.dev/codelabs/iterables)

### مصادر داخل المستودع

7. **خطة تعلم Dart الشاملة**
   - [فهرس Dart الكامل](../Dart%20basic/README.md)
   - [الدوال في Dart](../Dart%20basic/06_functions.md)
   - [المجموعات](../Dart%20basic/07_collections.md)

### مراجع API

8. **Dart Core Library**
   - [Function Class](https://api.dart.dev/stable/dart-core/Function-class.html)
   - [Iterable API](https://api.dart.dev/stable/dart-core/Iterable-class.html)
   - [List API](https://api.dart.dev/stable/dart-core/List-class.html)

### مصادر إضافية

9. **Community Resources**
   - [Dart Functions on Stack Overflow](https://stackoverflow.com/questions/tagged/dart+function)
   - [Dart Reddit Community](https://www.reddit.com/r/dartlang/)

10. **Video Tutorials**
    - [Dart Functions - Official YouTube](https://www.youtube.com/dartlang)
    - [Flutter & Dart Functions Tutorial](https://www.youtube.com/results?search_query=dart+functions+tutorial)

11. **Books and References**
    - [Dart Apprentice - Functions Chapter](https://www.raywenderlich.com/books/dart-apprentice)
    - [Programming Dart - Functions](https://www.oreilly.com/library/view/dart-up-and/9781449330880/)

---

## 💡 نصائح

- ✅ استخدم أسماء واضحة للدوال
- ✅ دالة واحدة = مهمة واحدة
- ✅ استخدم Arrow Functions للدوال البسيطة
- ✅ استخدم Named Parameters للوضوح
- ✅ وفّر قيماً افتراضية عندما يكون ممكناً
- ✅ استخدم Higher-Order Functions لكود أكثر مرونة
- ✅ مارس على [DartPad](https://dartpad.dev/)

---

[⬅️ السابق: التحكم في التدفق](04_control_flow.md)
[🏠 العودة للفهرس](../README.md)
[التالي: البرمجة الكائنية ➡️](06_oop_dart.md)
