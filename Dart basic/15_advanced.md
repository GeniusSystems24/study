# 15. مفاهيم متقدمة

## Typedef

تعريف اسم مستعار لنوع دالة.

```dart
// تعريف نوع دالة
typedef IntOperation = int Function(int a, int b);
typedef StringProcessor = String Function(String input);
typedef Predicate<T> = bool Function(T value);

int add(int a, int b) => a + b;
int multiply(int a, int b) => a * b;

String toUpperCase(String input) => input.toUpperCase();
String reverse(String input) => input.split('').reversed.join('');

void executeOperation(int x, int y, IntOperation operation) {
  print('النتيجة: ${operation(x, y)}');
}

void main() {
  executeOperation(5, 3, add);       // 8
  executeOperation(5, 3, multiply);  // 15
  
  // استخدام مع List
  List<Predicate<int>> tests = [
    (n) => n > 0,
    (n) => n % 2 == 0,
    (n) => n < 100,
  ];
  
  int number = 42;
  for (var test in tests) {
    print(test(number));
  }
}
```

## Enums (التعدادات)

### Enum بسيط

```dart
enum UserRole {
  admin,
  moderator,
  user,
  guest
}

void main() {
  UserRole role = UserRole.admin;
  
  print(role);                // UserRole.admin
  print(role.name);           // admin
  print(role.index);          // 0
  
  // جميع القيم
  print(UserRole.values);
  
  // switch
  switch (role) {
    case UserRole.admin:
      print('لديه صلاحيات كاملة');
      break;
    case UserRole.moderator:
      print('لديه صلاحيات متوسطة');
      break;
    case UserRole.user:
      print('مستخدم عادي');
      break;
    case UserRole.guest:
      print('ضيف');
      break;
  }
}
```

### Enhanced Enums (Dart 2.17+)

```dart
enum OrderStatus {
  pending('قيد الانتظار', '⏳'),
  processing('قيد المعالجة', '⚙️'),
  shipped('تم الشحن', '🚚'),
  delivered('تم التوصيل', '✅'),
  cancelled('ملغي', '❌');
  
  final String arabicName;
  final String emoji;
  
  const OrderStatus(this.arabicName, this.emoji);
  
  bool get isActive => this != OrderStatus.cancelled;
  
  bool get isCompleted => this == OrderStatus.delivered;
  
  String get displayText => '$emoji $arabicName';
}

void main() {
  var status = OrderStatus.shipped;
  
  print(status.displayText);      // 🚚 تم الشحن
  print('نشط: ${status.isActive}'); // true
  
  // التكرار
  for (var s in OrderStatus.values) {
    print(s.displayText);
  }
}
```

## Extension Methods المتقدمة

### Extensions متعددة

```dart
// Extension للنصوص
extension StringUtilities on String {
  bool get isNumeric => double.tryParse(this) != null;
  
  String get reversed => split('').reversed.join('');
  
  String truncate(int maxLength) {
    return length > maxLength 
        ? '${substring(0, maxLength)}...' 
        : this;
  }
  
  int get wordCount => trim().split(RegExp(r'\s+')).length;
}

// Extension للقوائم
extension ListUtilities<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;
  
  T? get lastOrNull => isEmpty ? null : last;
  
  List<T> get unique => toSet().toList();
  
  T? elementAtOrNull(int index) {
    return index >= 0 && index < length ? this[index] : null;
  }
}

// Extension للتاريخ
extension DateTimeExtension on DateTime {
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }
  
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(Duration(days: 1));
    return year == tomorrow.year && 
           month == tomorrow.month && 
           day == tomorrow.day;
  }
  
  String get formatted => '$day/$month/$year';
}

void main() {
  // String extensions
  print('123'.isNumeric);              // true
  print('hello'.reversed);             // olleh
  print('long text'.truncate(5));      // long...
  print('مرحبا بكم في Dart'.wordCount);  // 4
  
  // List extensions
  var numbers = [1, 2, 2, 3, 3, 4];
  print(numbers.unique);               // [1, 2, 3, 4]
  print(numbers.elementAtOrNull(10));  // null
  
  // DateTime extensions
  print(DateTime.now().isToday);       // true
  print(DateTime.now().formatted);
}
```

## Callable Classes

صنف يمكن استدعاؤه كدالة.

```dart
class Multiplier {
  final int factor;
  
  Multiplier(this.factor);
  
  // جعل الصنف قابلاً للاستدعاء
  int call(int value) => value * factor;
}

class Logger {
  final String prefix;
  
  Logger(this.prefix);
  
  void call(String message) {
    print('[$prefix] $message');
  }
}

void main() {
  var multiplyBy3 = Multiplier(3);
  print(multiplyBy3(10));  // 30
  print(multiplyBy3(5));   // 15
  
  var logger = Logger('INFO');
  logger('بدء التطبيق');     // [INFO] بدء التطبيق
  logger('تمت العملية');    // [INFO] تمت العملية
}
```

## Metadata Annotations

```dart
// تعريف annotation
class Todo {
  final String task;
  final String assignee;
  
  const Todo(this.task, {this.assignee = 'غير محدد'});
}

// annotation مدمجة
@deprecated
void oldFunction() {
  print('دالة قديمة');
}

@override
class MyClass {
  @override
  String toString() => 'MyClass';
}

// استخدام custom annotation
class TaskManager {
  @Todo('تحسين الأداء', assignee: 'أحمد')
  void processData() {
    // كود
  }
  
  @Todo('إضافة التوثيق')
  void calculate() {
    // كود
  }
}
```

## Symbols

```dart
void main() {
  // Symbol يمثل identifier
  Symbol sym = #myFunction;
  
  print(sym);  // Symbol("myFunction")
  
  // استخدام في reflection (محدود في Dart)
  var symbols = {
    #name: 'أحمد',
    #age: 25,
  };
  
  print(symbols[#name]);
}
```

## التعبيرات المنتظمة (Regular Expressions)

### Regex الأساسي

```dart
void main() {
  String text = 'البريد: test@example.com, الهاتف: 0123456789';
  
  // البحث عن بريد إلكتروني
  RegExp emailRegex = RegExp(r'\b[\w.-]+@[\w.-]+\.\w+\b');
  var emailMatch = emailRegex.firstMatch(text);
  print('البريد: ${emailMatch?.group(0)}');
  
  // البحث عن أرقام
  RegExp numberRegex = RegExp(r'\d+');
  var numbers = numberRegex.allMatches(text);
  for (var match in numbers) {
    print('رقم: ${match.group(0)}');
  }
  
  // استبدال
  String result = text.replaceAll(RegExp(r'\d'), '*');
  print('مخفي: $result');
}
```

### أمثلة Regex متقدمة

```dart
class RegexValidator {
  // بريد إلكتروني
  static final emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
  );
  
  // رقم هاتف مصري
  static final egyptPhoneRegex = RegExp(
    r'^(010|011|012|015)\d{8}$'
  );
  
  // كلمة مرور قوية
  static final strongPasswordRegex = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$'
  );
  
  // URL
  static final urlRegex = RegExp(
    r'^https?://[\w.-]+(?:\.[\w\.-]+)+[\w\-\._~:/?#[\]@!\$&\(\)\*\+,;=.]+$'
  );
  
  // رقم بطاقة ائتمان (تنسيق بسيط)
  static final creditCardRegex = RegExp(
    r'^\d{4}[\s-]?\d{4}[\s-]?\d{4}[\s-]?\d{4}$'
  );
  
  static bool isValidEmail(String email) => emailRegex.hasMatch(email);
  static bool isValidPhone(String phone) => egyptPhoneRegex.hasMatch(phone);
  static bool isStrongPassword(String pwd) => strongPasswordRegex.hasMatch(pwd);
  static bool isValidUrl(String url) => urlRegex.hasMatch(url);
}

void main() {
  print(RegexValidator.isValidEmail('test@example.com'));   // true
  print(RegexValidator.isValidPhone('01012345678'));        // true
  print(RegexValidator.isStrongPassword('Pass123!'));       // true
  print(RegexValidator.isValidUrl('https://dart.dev'));     // true
}
```

### استخراج البيانات من النصوص

```dart
class TextParser {
  // استخراج جميع الإيميلات
  static List<String> extractEmails(String text) {
    final regex = RegExp(r'\b[\w.-]+@[\w.-]+\.\w+\b');
    return regex.allMatches(text)
        .map((m) => m.group(0)!)
        .toList();
  }
  
  // استخراج أرقام الهواتف
  static List<String> extractPhones(String text) {
    final regex = RegExp(r'\b(010|011|012|015)\d{8}\b');
    return regex.allMatches(text)
        .map((m) => m.group(0)!)
        .toList();
  }
  
  // استخراج URLs
  static List<String> extractUrls(String text) {
    final regex = RegExp(
      r'https?://[^\s]+',
      caseSensitive: false,
    );
    return regex.allMatches(text)
        .map((m) => m.group(0)!)
        .toList();
  }
  
  // استخراج الهاشتاجات
  static List<String> extractHashtags(String text) {
    final regex = RegExp(r'#\w+');
    return regex.allMatches(text)
        .map((m) => m.group(0)!)
        .toList();
  }
}

void main() {
  String text = '''
  تواصل معنا على:
  البريد: info@company.com و support@company.com
  الهاتف: 01012345678 أو 01587654321
  الموقع: https://example.com
  تابعنا: #dart #flutter #programming
  ''';
  
  print('الإيميلات: ${TextParser.extractEmails(text)}');
  print('الهواتف: ${TextParser.extractPhones(text)}');
  print('URLs: ${TextParser.extractUrls(text)}');
  print('الهاشتاجات: ${TextParser.extractHashtags(text)}');
}
```

## Generators المتقدمة

### Sync Generator

```dart
// دالة مولد متزامن
Iterable<int> countUpTo(int max) sync* {
  for (int i = 1; i <= max; i++) {
    yield i;
  }
}

// فيبوناتشي
Iterable<int> fibonacci(int n) sync* {
  int a = 0, b = 1;
  
  for (int i = 0; i < n; i++) {
    yield a;
    int temp = a;
    a = b;
    b = temp + b;
  }
}

void main() {
  print(countUpTo(5).toList());        // [1, 2, 3, 4, 5]
  print(fibonacci(10).toList());       // [0, 1, 1, 2, 3, 5, 8, 13, 21, 34]
}
```

### Async Generator

```dart
// دالة مولد غير متزامن
Stream<int> countStream(int max) async* {
  for (int i = 1; i <= max; i++) {
    await Future.delayed(Duration(seconds: 1));
    yield i;
  }
}

// مولد متداخل
Stream<int> getAllNumbers(int max) async* {
  yield* Stream.fromIterable([1, 2, 3]);  // yield*
  await Future.delayed(Duration(seconds: 1));
  yield* countStream(max);
}

void main() async {
  await for (int number in countStream(5)) {
    print('العدد: $number');
  }
}
```

## Isolates (معالجة متوازية)

```dart
import 'dart:isolate';

// دالة ستعمل في isolate منفصل
void heavyComputation(SendPort sendPort) {
  // عملية حسابية ثقيلة
  int sum = 0;
  for (int i = 0; i < 1000000000; i++) {
    sum += i;
  }
  
  // إرسال النتيجة
  sendPort.send(sum);
}

Future<void> main() async {
  print('بدء العملية الحسابية الثقيلة...');
  
  // إنشاء receive port
  final receivePort = ReceivePort();
  
  // إنشاء isolate
  await Isolate.spawn(heavyComputation, receivePort.sendPort);
  
  // استقبال النتيجة
  final result = await receivePort.first;
  print('النتيجة: $result');
  
  print('البرنامج الرئيسي لم يتوقف!');
}
```

## أمثلة عملية متقدمة

### مثال: نظام Validation متقدم

```dart
enum ValidationType { email, phone, password, url, required, minLength, maxLength, numeric }

class ValidationRule {
  final ValidationType type;
  final dynamic value;
  final String message;
  
  const ValidationRule(this.type, {this.value, required this.message});
}

class Validator {
  final List<ValidationRule> rules;
  
  Validator(this.rules);
  
  List<String> validate(String? input) {
    List<String> errors = [];
    
    for (var rule in rules) {
      String? error = _validateRule(input, rule);
      if (error != null) {
        errors.add(error);
      }
    }
    
    return errors;
  }
  
  String? _validateRule(String? input, ValidationRule rule) {
    switch (rule.type) {
      case ValidationType.required:
        return (input == null || input.trim().isEmpty) ? rule.message : null;
      
      case ValidationType.email:
        if (input == null) return null;
        return RegExp(r'^[\w.-]+@[\w.-]+\.\w+$').hasMatch(input) 
            ? null : rule.message;
      
      case ValidationType.phone:
        if (input == null) return null;
        return RegExp(r'^(010|011|012|015)\d{8}$').hasMatch(input)
            ? null : rule.message;
      
      case ValidationType.password:
        if (input == null) return null;
        return RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$').hasMatch(input)
            ? null : rule.message;
      
      case ValidationType.minLength:
        if (input == null) return null;
        return input.length >= (rule.value as int) ? null : rule.message;
      
      case ValidationType.maxLength:
        if (input == null) return null;
        return input.length <= (rule.value as int) ? null : rule.message;
      
      case ValidationType.numeric:
        if (input == null) return null;
        return double.tryParse(input) != null ? null : rule.message;
      
      default:
        return null;
    }
  }
}

void main() {
  var emailValidator = Validator([
    ValidationRule(ValidationType.required, message: 'البريد مطلوب'),
    ValidationRule(ValidationType.email, message: 'بريد إلكتروني غير صحيح'),
  ]);
  
  var passwordValidator = Validator([
    ValidationRule(ValidationType.required, message: 'كلمة المرور مطلوبة'),
    ValidationRule(ValidationType.minLength, value: 8, 
        message: 'يجب أن تكون 8 أحرف على الأقل'),
    ValidationRule(ValidationType.password, 
        message: 'يجب أن تحتوي على حرف كبير وصغير ورقم'),
  ]);
  
  // اختبار
  print('--- اختبار البريد ---');
  print(emailValidator.validate(''));           // [البريد مطلوب]
  print(emailValidator.validate('invalid'));    // [بريد إلكتروني غير صحيح]
  print(emailValidator.validate('test@example.com'));  // []
  
  print('\n--- اختبار كلمة المرور ---');
  print(passwordValidator.validate('weak'));
  print(passwordValidator.validate('StrongPass123'));  // []
}
```

## أفضل الممارسات

1. **Typedef**: استخدمها لجعل أنواع الدوال أوضح
2. **Enums**: للقيم المحدودة والثابتة
3. **Extensions**: لإضافة وظائف بدون تعديل الأصناف
4. **Regex**: اختبرها جيداً، يمكن أن تكون معقدة
5. **Generators**: للبيانات الكبيرة أو المتدفقة
6. **Isolates**: للعمليات الثقيلة جداً فقط
7. **Validation**: اجعلها قابلة لإعادة الاستخدام

---

[⬅️ الموضوع السابق: المكتبات والحزم](14_libraries.md) | [العودة للفهرس](README.md) | [الموضوع التالي: أفضل الممارسات ➡️](16_best_practices.md)
