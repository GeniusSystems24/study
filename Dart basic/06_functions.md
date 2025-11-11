# 6. الدوال (Functions)

## تعريف الدالة الأساسية

```dart
// دالة بسيطة بدون معاملات أو قيمة إرجاع
void sayHello() {
  print('مرحباً!');
}

// دالة مع معامل واحد
void greet(String name) {
  print('مرحباً $name');
}

// دالة تُرجع قيمة
int add(int a, int b) {
  return a + b;
}

// استدعاء الدوال
void main() {
  sayHello();           // مرحباً!
  greet('أحمد');        // مرحباً أحمد
  int sum = add(5, 3);  // 8
  print(sum);
}
```

## أنواع المعاملات (Parameters)

### المعاملات الإلزامية (Required Positional)

```dart
String createFullName(String firstName, String lastName) {
  return '$firstName $lastName';
}

void main() {
  print(createFullName('أحمد', 'محمد'));
}
```

### المعاملات الاختيارية بالموضع (Optional Positional)

```dart
// يجب وضعها بين []
String greetUser(String name, [String? title]) {
  if (title != null) {
    return 'مرحباً $title $name';
  }
  return 'مرحباً $name';
}

void main() {
  print(greetUser('أحمد'));           // مرحباً أحمد
  print(greetUser('فاطمة', 'دكتورة')); // مرحباً دكتورة فاطمة
}
```

### المعاملات الاختيارية بالاسم (Named Parameters)

```dart
// يجب وضعها بين {}
void printInfo({String? name, int? age, String? city}) {
  print('الاسم: ${name ?? "غير محدد"}');
  print('العمر: ${age ?? "غير محدد"}');
  print('المدينة: ${city ?? "غير محدد"}');
}

void main() {
  printInfo(name: 'أحمد', age: 25);
  printInfo(city: 'القاهرة', name: 'محمد');
}
```

### المعاملات المسماة الإلزامية (Required Named)

```dart
// استخدام required
void registerUser({
  required String username,
  required String email,
  String? phone,
}) {
  print('المستخدم: $username');
  print('البريد: $email');
  if (phone != null) print('الهاتف: $phone');
}

void main() {
  registerUser(
    username: 'ahmed123',
    email: 'ahmed@example.com',
  );
}
```

### القيم الافتراضية (Default Values)

```dart
// للمعاملات الاختيارية بالموضع
int multiply(int a, [int b = 1]) {
  return a * b;
}

// للمعاملات المسماة
void setConfig({
  String host = 'localhost',
  int port = 8080,
  bool ssl = false,
}) {
  print('Host: $host:$port, SSL: $ssl');
}

void main() {
  print(multiply(5));        // 5 (5 * 1)
  print(multiply(5, 3));     // 15
  
  setConfig();
  setConfig(port: 3000, ssl: true);
}
```

## Arrow Functions (دوال السهم)

```dart
// للدوال ذات السطر الواحد
int square(int x) => x * x;

bool isEven(int n) => n % 2 == 0;

String getGreeting(String name) => 'مرحباً $name';

void printMessage(String msg) => print(msg);

void main() {
  print(square(5));           // 25
  print(isEven(4));           // true
  print(getGreeting('أحمد')); // مرحباً أحمد
  printMessage('Hello');      // Hello
}
```

## الدوال المجهولة (Anonymous Functions)

```dart
void main() {
  // دالة مجهولة
  var list = ['تفاح', 'موز', 'برتقال'];
  
  list.forEach((item) {
    print('الفاكهة: $item');
  });
  
  // دالة سهم مجهولة
  var numbers = [1, 2, 3, 4, 5];
  var doubled = numbers.map((n) => n * 2).toList();
  print(doubled);  // [2, 4, 6, 8, 10]
}
```

## الدوال كمتغيرات (Functions as Variables)

```dart
// تخزين دالة في متغير
void main() {
  // النوع Function
  Function add = (int a, int b) => a + b;
  print(add(3, 4));  // 7
  
  // نوع محدد
  int Function(int, int) multiply = (a, b) => a * b;
  print(multiply(3, 4));  // 12
  
  // تمرير دالة كمعامل
  void executeOperation(int a, int b, int Function(int, int) operation) {
    print('النتيجة: ${operation(a, b)}');
  }
  
  executeOperation(10, 5, add);
  executeOperation(10, 5, multiply);
}
```

## الدوال ذات الترتيب الأعلى (Higher-Order Functions)

```dart
// دالة تُرجع دالة أخرى
Function makeMultiplier(int factor) {
  return (int value) => value * factor;
}

// دالة تستقبل دالة كمعامل
List<int> filterList(List<int> list, bool Function(int) test) {
  List<int> result = [];
  for (var item in list) {
    if (test(item)) {
      result.add(item);
    }
  }
  return result;
}

void main() {
  var multiplyBy3 = makeMultiplier(3);
  print(multiplyBy3(10));  // 30
  
  var numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  var evenNumbers = filterList(numbers, (n) => n % 2 == 0);
  print(evenNumbers);  // [2, 4, 6, 8, 10]
}
```

## الدوال العودية (Recursive Functions)

```dart
// حساب المضروب (Factorial)
int factorial(int n) {
  if (n <= 1) return 1;
  return n * factorial(n - 1);
}

// متسلسلة فيبوناتشي
int fibonacci(int n) {
  if (n <= 1) return n;
  return fibonacci(n - 1) + fibonacci(n - 2);
}

// حساب مجموع الأرقام
int sumNumbers(int n) {
  if (n <= 0) return 0;
  return n + sumNumbers(n - 1);
}

void main() {
  print('5! = ${factorial(5)}');        // 120
  print('Fib(7) = ${fibonacci(7)}');    // 13
  print('Sum(10) = ${sumNumbers(10)}'); // 55
}
```

## Closures (الإغلاقات)

```dart
// دالة تحتفظ بحالة المتغيرات
Function makeCounter() {
  int count = 0;
  
  return () {
    count++;
    return count;
  };
}

void main() {
  var counter1 = makeCounter();
  var counter2 = makeCounter();
  
  print(counter1());  // 1
  print(counter1());  // 2
  print(counter1());  // 3
  
  print(counter2());  // 1 (عداد منفصل)
  print(counter2());  // 2
}
```

## معاملات الدوال (Function Parameters)

```dart
// typedef لتعريف نوع دالة
typedef MathOperation = int Function(int a, int b);

int calculate(int a, int b, MathOperation operation) {
  return operation(a, b);
}

void main() {
  int add(int a, int b) => a + b;
  int subtract(int a, int b) => a - b;
  int multiply(int a, int b) => a * b;
  
  print(calculate(10, 5, add));       // 15
  print(calculate(10, 5, subtract));  // 5
  print(calculate(10, 5, multiply));  // 50
}
```

## أمثلة عملية شاملة

### مثال 1: حاسبة متقدمة

```dart
double calculator({
  required double num1,
  required double num2,
  required String operation,
}) {
  switch (operation) {
    case '+':
      return num1 + num2;
    case '-':
      return num1 - num2;
    case '*':
      return num1 * num2;
    case '/':
      if (num2 == 0) throw Exception('لا يمكن القسمة على صفر');
      return num1 / num2;
    default:
      throw Exception('عملية غير صحيحة');
  }
}

void main() {
  print(calculator(num1: 10, num2: 5, operation: '+'));  // 15.0
  print(calculator(num1: 10, num2: 5, operation: '*'));  // 50.0
}
```

### مثال 2: معالجة قائمة

```dart
List<T> filter<T>(List<T> list, bool Function(T) predicate) {
  return list.where(predicate).toList();
}

List<T> map<T, R>(List<T> list, R Function(T) transform) {
  return list.map(transform).toList();
}

void main() {
  var numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  
  // الأرقام الزوجية
  var even = filter(numbers, (n) => n % 2 == 0);
  print('الأرقام الزوجية: $even');
  
  // تربيع الأرقام
  var squared = numbers.map((n) => n * n).toList();
  print('الأرقام المربعة: $squared');
}
```

### مثال 3: نظام مصادقة بسيط

```dart
class User {
  final String username;
  final String password;
  
  User(this.username, this.password);
}

bool authenticate({
  required String username,
  required String password,
  required List<User> users,
}) {
  for (var user in users) {
    if (user.username == username && user.password == password) {
      return true;
    }
  }
  return false;
}

void performAction(String action, bool Function() checkPermission) {
  if (checkPermission()) {
    print('تنفيذ: $action');
  } else {
    print('غير مسموح بـ: $action');
  }
}

void main() {
  var users = [
    User('admin', '1234'),
    User('user1', 'pass123'),
  ];
  
  bool isLoggedIn = authenticate(
    username: 'admin',
    password: '1234',
    users: users,
  );
  
  performAction('حذف المستخدم', () => isLoggedIn);
}
```

## نصائح مهمة

1. استخدم أسماء واضحة ومعبرة للدوال
2. اجعل الدوال صغيرة ومركزة على مهمة واحدة
3. استخدم المعاملات المسماة للدوال ذات المعاملات الكثيرة
4. استخدم Arrow Functions للدوال البسيطة ذات السطر الواحد
5. تجنب الإفراط في استخدام الدوال العودية (قد تسبب Stack Overflow)
6. استخدم `required` للمعاملات الإلزامية المسماة
7. وثّق الدوال المعقدة بتعليقات واضحة

---

[⬅️ الموضوع السابق: التحكم في التدفق](05_control_flow.md) 
 [العودة للفهرس](README.md) 
 [الموضوع التالي: المجموعات ➡️](07_collections.md)
