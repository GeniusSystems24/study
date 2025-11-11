# 16. أفضل الممارسات والأنماط

## اتفاقيات التسمية

### الأسماء في Dart

```dart
// الأصناف: UpperCamelCase
class UserProfile {}
class DataManager {}

// الدوال والمتغيرات: lowerCamelCase
void calculateTotal() {}
int userAge = 25;
String firstName = 'أحمد';

// الثوابت: lowerCamelCase
const int maxRetries = 3;
const String apiUrl = 'https://api.example.com';

// الملفات: snake_case
// user_profile.dart
// data_manager.dart

// المكتبات: snake_case
library my_awesome_library;

// Private: بادئة _
class _InternalClass {}
void _privateMethod() {}
int _privateVariable = 0;
```

## تنظيم الكود

### هيكل الصنف

```dart
class WellOrganizedClass {
  // 1. الثوابت الثابتة
  static const int MAX_SIZE = 100;
  static const String DEFAULT_NAME = 'افتراضي';
  
  // 2. الخصائص الثابتة
  static int instanceCount = 0;
  
  // 3. الخصائص الخاصة
  final String _id;
  String _name;
  int _value;
  
  // 4. الخصائص العامة
  bool isActive;
  
  // 5. المنشئات
  WellOrganizedClass(this._id, this._name, this._value, {this.isActive = true}) {
    instanceCount++;
  }
  
  WellOrganizedClass.withDefaults()
      : _id = 'default',
        _name = DEFAULT_NAME,
        _value = 0,
        isActive = true;
  
  // 6. Getters
  String get id => _id;
  String get name => _name;
  int get value => _value;
  
  // 7. Setters
  set name(String newName) {
    if (newName.isNotEmpty) {
      _name = newName;
    }
  }
  
  // 8. الطرق العامة
  void incrementValue() {
    _value++;
  }
  
  void displayInfo() {
    print('ID: $_id, Name: $_name, Value: $_value');
  }
  
  // 9. الطرق الخاصة
  void _validateValue() {
    if (_value < 0) _value = 0;
  }
  
  // 10. Override methods
  @override
  String toString() => 'WellOrganizedClass($_id: $_name)';
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WellOrganizedClass && _id == other._id;
  
  @override
  int get hashCode => _id.hashCode;
}
```

## التعليقات والتوثيق

### أنواع التعليقات

```dart
// تعليق سطر واحد
// هذا تعليق بسيط

/* تعليق
   متعدد
   الأسطر */

/// تعليق توثيق - يظهر في IDE
/// 
/// هذه دالة تحسب مجموع رقمين.
/// 
/// Parameters:
/// - [a]: الرقم الأول
/// - [b]: الرقم الثاني
/// 
/// Returns: مجموع الرقمين
/// 
/// Example:
/// ```dart
/// int result = add(5, 3); // 8
/// ```
int add(int a, int b) => a + b;

/// يمثل معلومات المستخدم في النظام.
/// 
/// يحتوي على البيانات الأساسية للمستخدم مثل:
/// - معرف فريد
/// - الاسم الكامل
/// - البريد الإلكتروني
class User {
  /// المعرف الفريد للمستخدم
  final String id;
  
  /// الاسم الكامل
  String name;
  
  /// البريد الإلكتروني
  String email;
  
  /// ينشئ مستخدماً جديداً.
  /// 
  /// يتطلب [id] فريد و[name] و[email] صحيح.
  User({
    required this.id,
    required this.name,
    required this.email,
  });
}
```

## Null Safety Best Practices

```dart
// ✅ جيد - استخدم non-nullable عندما تكون متأكداً
String getName() {
  return 'أحمد';
}

// ✅ جيد - استخدم nullable فقط عند الحاجة
String? findUserName(int id) {
  // قد يعيد null
  return null;
}

// ✅ جيد - استخدم ?? للقيم الافتراضية
String displayName(String? name) {
  return name ?? 'ضيف';
}

// ✅ جيد - استخدم ?. للوصول الآمن
void printLength(String? text) {
  print(text?.length ?? 0);
}

// ❌ سيء - استخدام ! بدون تحقق
void badExample(String? text) {
  print(text!.length);  // خطر!
}

// ✅ جيد - تحقق قبل الاستخدام
void goodExample(String? text) {
  if (text != null) {
    print(text.length);
  }
}
```

## معالجة الأخطاء

```dart
// ✅ جيد - استثناءات محددة
class ValidationException implements Exception {
  final String message;
  ValidationException(this.message);
  
  @override
  String toString() => 'ValidationException: $message';
}

// ✅ جيد - معالجة أخطاء محددة
Future<User?> fetchUser(String id) async {
  try {
    // جلب البيانات
    return User(id: id, name: 'أحمد', email: 'ahmed@example.com');
  } on NetworkException catch (e) {
    print('خطأ في الشبكة: $e');
    return null;
  } on ValidationException catch (e) {
    print('خطأ في التحقق: $e');
    rethrow;
  } catch (e) {
    print('خطأ غير متوقع: $e');
    return null;
  } finally {
    // تنظيف
  }
}

class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
}

// ❌ سيء - ابتلاع الأخطاء
void badErrorHandling() {
  try {
    // كود
  } catch (e) {
    // لا شيء - سيء!
  }
}
```

## الأداء

### تجنب العمليات المكلفة

```dart
// ❌ سيء - إنشاء كائنات في حلقة
void inefficientLoop() {
  for (int i = 0; i < 1000; i++) {
    var regex = RegExp(r'\d+');  // يُنشأ في كل تكرار!
    // استخدام regex
  }
}

// ✅ جيد - إنشاء مرة واحدة
void efficientLoop() {
  var regex = RegExp(r'\d+');  // مرة واحدة فقط
  for (int i = 0; i < 1000; i++) {
    // استخدام regex
  }
}

// ✅ جيد - استخدم const للثوابت
class Configuration {
  // ✅ const - ينشأ مرة واحدة
  static const List<String> COLORS = ['أحمر', 'أخضر', 'أزرق'];
  
  // ❌ سيء - ينشأ في كل مرة
  static List<String> getColors() => ['أحمر', 'أخضر', 'أزرق'];
}

// ✅ جيد - استخدم final للقيم غير المتغيرة
class User {
  final String id;        // ✅ لن يتغير
  String name;            // ✅ قد يتغير
  
  User(this.id, this.name);
}
```

### استخدام Collections بكفاءة

```dart
// ✅ جيد - Set للتفرد
bool hasDuplicates(List<int> numbers) {
  return numbers.length != numbers.toSet().length;
}

// ✅ جيد - Map للبحث السريع
class UserRepository {
  final Map<String, User> _users = {};  // O(1) للبحث
  
  User? findById(String id) => _users[id];
  
  void add(User user) => _users[user.id] = user;
}

// ❌ سيء - List للبحث (O(n))
class SlowUserRepository {
  final List<User> _users = [];
  
  User? findById(String id) {
    // بطيء للقوائم الكبيرة
    try {
      return _users.firstWhere((user) => user.id == id);
    } catch (e) {
      return null;
    }
  }
}
```

## أنماط التصميم (Design Patterns)

### Singleton

```dart
class Database {
  // Instance وحيدة
  static final Database _instance = Database._internal();
  
  // منشئ خاص
  Database._internal();
  
  // Factory constructor يعيد نفس الـ instance
  factory Database() => _instance;
  
  void query(String sql) {
    print('تنفيذ: $sql');
  }
}

void main() {
  var db1 = Database();
  var db2 = Database();
  
  print(identical(db1, db2));  // true - نفس الكائن
}
```

### Factory Pattern

```dart
abstract class Shape {
  void draw();
  
  factory Shape(String type) {
    switch (type) {
      case 'circle':
        return Circle();
      case 'square':
        return Square();
      default:
        throw Exception('نوع غير معروف');
    }
  }
}

class Circle implements Shape {
  @override
  void draw() => print('رسم دائرة');
}

class Square implements Shape {
  @override
  void draw() => print('رسم مربع');
}

void main() {
  var shape1 = Shape('circle');
  var shape2 = Shape('square');
  
  shape1.draw();
  shape2.draw();
}
```

### Builder Pattern

```dart
class Pizza {
  final String size;
  final bool cheese;
  final bool pepperoni;
  final bool vegetables;
  
  Pizza._({
    required this.size,
    this.cheese = false,
    this.pepperoni = false,
    this.vegetables = false,
  });
  
  @override
  String toString() {
    return 'Pizza(size: $size, cheese: $cheese, '
           'pepperoni: $pepperoni, vegetables: $vegetables)';
  }
}

class PizzaBuilder {
  String _size = 'medium';
  bool _cheese = false;
  bool _pepperoni = false;
  bool _vegetables = false;
  
  PizzaBuilder setSize(String size) {
    _size = size;
    return this;
  }
  
  PizzaBuilder addCheese() {
    _cheese = true;
    return this;
  }
  
  PizzaBuilder addPepperoni() {
    _pepperoni = true;
    return this;
  }
  
  PizzaBuilder addVegetables() {
    _vegetables = true;
    return this;
  }
  
  Pizza build() {
    return Pizza._(
      size: _size,
      cheese: _cheese,
      pepperoni: _pepperoni,
      vegetables: _vegetables,
    );
  }
}

void main() {
  var pizza = PizzaBuilder()
      .setSize('large')
      .addCheese()
      .addPepperoni()
      .build();
  
  print(pizza);
}
```

### Observer Pattern

```dart
abstract class Observer {
  void update(String message);
}

class Subject {
  final List<Observer> _observers = [];
  
  void attach(Observer observer) {
    _observers.add(observer);
  }
  
  void detach(Observer observer) {
    _observers.remove(observer);
  }
  
  void notify(String message) {
    for (var observer in _observers) {
      observer.update(message);
    }
  }
}

class EmailNotifier implements Observer {
  final String email;
  
  EmailNotifier(this.email);
  
  @override
  void update(String message) {
    print('إرسال بريد إلى $email: $message');
  }
}

class SMSNotifier implements Observer {
  final String phone;
  
  SMSNotifier(this.phone);
  
  @override
  void update(String message) {
    print('إرسال SMS إلى $phone: $message');
  }
}

void main() {
  var newsChannel = Subject();
  
  newsChannel.attach(EmailNotifier('user@example.com'));
  newsChannel.attach(SMSNotifier('0123456789'));
  
  newsChannel.notify('خبر عاجل!');
}
```

## الكود النظيف

### DRY (Don't Repeat Yourself)

```dart
// ❌ سيء - تكرار
double calculateTotalPrice(double price, double tax) {
  return price + (price * tax);
}

double calculateDiscountedPrice(double price, double discount) {
  return price - (price * discount);
}

// ✅ جيد - دالة عامة
double applyPercentage(double value, double percentage, {bool add = true}) {
  double change = value * percentage;
  return add ? value + change : value - change;
}

double calculateTotalPrice2(double price, double tax) {
  return applyPercentage(price, tax, add: true);
}

double calculateDiscountedPrice2(double price, double discount) {
  return applyPercentage(price, discount, add: false);
}
```

### Single Responsibility

```dart
// ❌ سيء - مسؤوليات متعددة
class UserManager {
  void createUser() {}
  void deleteUser() {}
  void sendEmail() {}      // ليس من مسؤولياته!
  void saveToDatabase() {} // ليس من مسؤولياته!
}

// ✅ جيد - مسؤولية واحدة لكل صنف
class UserService {
  void createUser() {}
  void deleteUser() {}
}

class EmailService {
  void sendEmail() {}
}

class UserRepository {
  void save() {}
  void delete() {}
}
```

### استخدام الأسماء الواضحة

```dart
// ❌ سيء
int calc(int x, int y) => x + y;
var dt = DateTime.now();
List<int> arr = [1, 2, 3];

// ✅ جيد
int calculateSum(int firstNumber, int secondNumber) {
  return firstNumber + secondNumber;
}

DateTime currentDateTime = DateTime.now();
List<int> userAges = [25, 30, 22];

// ✅ جيد - أسماء للـ booleans
bool isUserActive = true;
bool hasPermission = false;
bool canEdit = true;
```

## الاختبار

### كتابة كود قابل للاختبار

```dart
// ❌ سيء - صعب الاختبار
class PaymentProcessor {
  void processPayment(double amount) {
    // اتصال مباشر بـ API
    // صعب الاختبار!
  }
}

// ✅ جيد - قابل للاختبار
abstract class PaymentGateway {
  Future<bool> charge(double amount);
}

class PaymentProcessor {
  final PaymentGateway gateway;
  
  PaymentProcessor(this.gateway);
  
  Future<bool> processPayment(double amount) {
    return gateway.charge(amount);
  }
}

// يمكن استخدام Mock في الاختبار
class MockPaymentGateway implements PaymentGateway {
  @override
  Future<bool> charge(double amount) async {
    return true;  // محاكاة نجاح الدفع
  }
}
```

## نصائح عامة

```dart
// ✅ استخدم final عندما لا تحتاج تغيير المتغير
final String username = 'ahmed';

// ✅ استخدم const للثوابت المعروفة وقت الترجمة
const int maxAttempts = 3;

// ✅ استخدم cascade operator (..) للتهيئة
var user = User()
  ..name = 'أحمد'
  ..age = 25
  ..email = 'ahmed@example.com';

// ✅ استخدم collection if
var items = [
  'عنصر 1',
  'عنصر 2',
  if (isAdmin) 'لوحة التحكم',
];

// ✅ استخدم spread operator
var list1 = [1, 2, 3];
var list2 = [4, 5, 6];
var combined = [...list1, ...list2];

// ✅ استخدم arrow functions للدوال البسيطة
bool isEven(int n) => n % 2 == 0;

// ✅ استخدم named parameters للوضوح
void createUser({
  required String name,
  required String email,
  int age = 0,
}) {
  // implementation
}
```

## الملخص

1. **اتبع اتفاقيات التسمية**: PascalCase للأصناف، camelCase للدوال
2. **نظّم الكود**: رتب الأصناف والدوال بشكل منطقي
3. **وثّق الكود**: استخدم `///` للتوثيق
4. **Null Safety**: استخدم non-nullable افتراضياً
5. **معالجة الأخطاء**: عالج الأخطاء بشكل صحيح
6. **الأداء**: تجنب العمليات المكلفة في الحلقات
7. **أنماط التصميم**: استخدم الأنماط المناسبة
8. **DRY**: لا تكرر نفسك
9. **Single Responsibility**: مسؤولية واحدة للصنف
10. **كود قابل للاختبار**: سهّل الاختبار

---

[⬅️ الموضوع السابق: مفاهيم متقدمة](15_advanced.md) 
 [العودة للفهرس](README.md) 
 [الموضوع التالي: التطبيقات العملية ➡️](17_projects.md)
