# 11. معالجة الأخطاء (Exception Handling)

## أنواع الأخطاء

### Errors vs Exceptions

- **Error**: أخطاء برمجية خطيرة (مثل: Out of Memory)
- **Exception**: أخطاء يمكن معالجتها (مثل: File Not Found)

## try-catch-finally

### الاستخدام الأساسي

```dart
void main() {
  try {
    int result = 10 ~/ 0;  // قسمة على صفر
    print(result);
  } catch (e) {
    print('حدث خطأ: $e');
  }
  
  print('البرنامج يعمل بشكل طبيعي');
}
```

### catch مع نوع محدد

```dart
void divideNumbers(int a, int b) {
  try {
    double result = a / b;
    print('النتيجة: $result');
  } on IntegerDivisionByZeroException {
    print('لا يمكن القسمة على صفر!');
  } on FormatException {
    print('خطأ في التنسيق');
  } catch (e) {
    print('خطأ غير متوقع: $e');
  }
}

void main() {
  divideNumbers(10, 0);
}
```

### الحصول على Stack Trace

```dart
void processData(String data) {
  try {
    int number = int.parse(data);
    print('الرقم: $number');
  } catch (e, stackTrace) {
    print('خطأ: $e');
    print('Stack Trace:\n$stackTrace');
  }
}

void main() {
  processData('ليس رقماً');
}
```

### finally - ينفذ دائماً

```dart
import 'dart:io';

void readFile(String path) {
  File? file;
  
  try {
    file = File(path);
    String content = file.readAsStringSync();
    print('المحتوى: $content');
  } catch (e) {
    print('فشل قراءة الملف: $e');
  } finally {
    // ينفذ سواء حدث خطأ أم لا
    print('تنظيف الموارد...');
    // إغلاق الملف إن وُجد
  }
}
```

## رمي الاستثناءات (Throwing Exceptions)

### throw

```dart
void validateAge(int age) {
  if (age < 0) {
    throw FormatException('العمر لا يمكن أن يكون سالباً');
  }
  
  if (age > 150) {
    throw RangeError('العمر غير واقعي');
  }
  
  print('العمر صحيح: $age');
}

void main() {
  try {
    validateAge(-5);
  } catch (e) {
    print('خطأ: $e');
  }
}
```

### rethrow - إعادة رمي الاستثناء

```dart
void processUserData(Map<String, dynamic> data) {
  try {
    // معالجة البيانات
    if (!data.containsKey('name')) {
      throw Exception('الاسم مطلوب');
    }
  } catch (e) {
    print('تسجيل الخطأ: $e');
    rethrow;  // إعادة رمي نفس الاستثناء
  }
}

void main() {
  try {
    processUserData({'age': 25});
  } catch (e) {
    print('معالجة الخطأ في main: $e');
  }
}
```

## الاستثناءات المدمجة

```dart
void demonstrateExceptions() {
  // FormatException
  try {
    int.parse('abc');
  } on FormatException {
    print('خطأ في التنسيق');
  }
  
  // RangeError
  try {
    var list = [1, 2, 3];
    print(list[10]);
  } on RangeError {
    print('الفهرس خارج النطاق');
  }
  
  // ArgumentError
  try {
    throw ArgumentError('معامل غير صحيح');
  } on ArgumentError catch (e) {
    print('خطأ في المعامل: ${e.message}');
  }
  
  // StateError
  try {
    var emptyList = <int>[];
    emptyList.first;
  } on StateError {
    print('القائمة فارغة');
  }
}
```

## إنشاء استثناءات مخصصة

### استثناء بسيط

```dart
class InvalidEmailException implements Exception {
  final String message;
  
  InvalidEmailException(this.message);
  
  @override
  String toString() => 'InvalidEmailException: $message';
}

void validateEmail(String email) {
  if (!email.contains('@')) {
    throw InvalidEmailException('البريد الإلكتروني يجب أن يحتوي على @');
  }
  
  if (!email.contains('.')) {
    throw InvalidEmailException('البريد الإلكتروني يجب أن يحتوي على نطاق');
  }
  
  print('البريد صحيح: $email');
}

void main() {
  try {
    validateEmail('testexample.com');
  } on InvalidEmailException catch (e) {
    print(e);
  }
}
```

### استثناء متقدم

```dart
class ValidationException implements Exception {
  final String field;
  final String message;
  final dynamic value;
  
  ValidationException({
    required this.field,
    required this.message,
    this.value,
  });
  
  @override
  String toString() {
    return 'ValidationException: الحقل "$field" - $message'
           '${value != null ? " (القيمة: $value)" : ""}';
  }
}

class User {
  final String username;
  final String email;
  final int age;
  
  User({
    required this.username,
    required this.email,
    required this.age,
  }) {
    _validate();
  }
  
  void _validate() {
    if (username.length < 3) {
      throw ValidationException(
        field: 'username',
        message: 'يجب أن يكون 3 أحرف على الأقل',
        value: username,
      );
    }
    
    if (!email.contains('@')) {
      throw ValidationException(
        field: 'email',
        message: 'بريد إلكتروني غير صحيح',
        value: email,
      );
    }
    
    if (age < 0 || age > 150) {
      throw ValidationException(
        field: 'age',
        message: 'عمر غير صحيح',
        value: age,
      );
    }
  }
}

void main() {
  try {
    var user = User(
      username: 'ab',  // قصير جداً
      email: 'test@example.com',
      age: 25,
    );
  } on ValidationException catch (e) {
    print(e);
  }
}
```

## أنماط معالجة الأخطاء

### Pattern 1: Return null على الخطأ

```dart
int? tryParse(String value) {
  try {
    return int.parse(value);
  } catch (e) {
    return null;
  }
}

void main() {
  int? number = tryParse('abc');
  
  if (number != null) {
    print('الرقم: $number');
  } else {
    print('فشل التحويل');
  }
}
```

### Pattern 2: Result Type

```dart
class Result<T> {
  final T? data;
  final String? error;
  final bool isSuccess;
  
  Result.success(this.data)
      : error = null,
        isSuccess = true;
  
  Result.failure(this.error)
      : data = null,
        isSuccess = false;
}

Result<int> divide(int a, int b) {
  try {
    if (b == 0) {
      return Result.failure('لا يمكن القسمة على صفر');
    }
    return Result.success(a ~/ b);
  } catch (e) {
    return Result.failure('خطأ: $e');
  }
}

void main() {
  var result = divide(10, 0);
  
  if (result.isSuccess) {
    print('النتيجة: ${result.data}');
  } else {
    print('خطأ: ${result.error}');
  }
}
```

### Pattern 3: Callback للأخطاء

```dart
typedef ErrorCallback = void Function(String error);

class DataProcessor {
  final ErrorCallback? onError;
  
  DataProcessor({this.onError});
  
  void processData(String data) {
    try {
      int number = int.parse(data);
      print('تمت معالجة: $number');
    } catch (e) {
      if (onError != null) {
        onError!('فشلت المعالجة: $e');
      } else {
        print('خطأ: $e');
      }
    }
  }
}

void main() {
  var processor = DataProcessor(
    onError: (error) => print('⚠️ $error'),
  );
  
  processor.processData('123');   // نجح
  processor.processData('abc');   // فشل
}
```

## أمثلة عملية شاملة

### مثال 1: نظام تسجيل الدخول

```dart
class AuthenticationException implements Exception {
  final String message;
  final String code;
  
  AuthenticationException(this.message, this.code);
  
  @override
  String toString() => '[$code] $message';
}

class AuthService {
  final Map<String, String> _users = {
    'admin': 'admin123',
    'user1': 'pass123',
  };
  
  bool login(String username, String password) {
    // التحقق من اسم المستخدم
    if (username.isEmpty) {
      throw AuthenticationException(
        'اسم المستخدم مطلوب',
        'EMPTY_USERNAME',
      );
    }
    
    // التحقق من كلمة المرور
    if (password.isEmpty) {
      throw AuthenticationException(
        'كلمة المرور مطلوبة',
        'EMPTY_PASSWORD',
      );
    }
    
    // التحقق من وجود المستخدم
    if (!_users.containsKey(username)) {
      throw AuthenticationException(
        'المستخدم غير موجود',
        'USER_NOT_FOUND',
      );
    }
    
    // التحقق من صحة كلمة المرور
    if (_users[username] != password) {
      throw AuthenticationException(
        'كلمة مرور خاطئة',
        'INVALID_PASSWORD',
      );
    }
    
    return true;
  }
}

void main() {
  var auth = AuthService();
  
  void attemptLogin(String username, String password) {
    try {
      print('\n--- محاولة تسجيل الدخول ---');
      print('المستخدم: $username');
      
      bool success = auth.login(username, password);
      
      if (success) {
        print('✓ تم تسجيل الدخول بنجاح!');
      }
    } on AuthenticationException catch (e) {
      print('✗ فشل تسجيل الدخول: $e');
    } catch (e) {
      print('✗ خطأ غير متوقع: $e');
    } finally {
      print('--- انتهت المحاولة ---');
    }
  }
  
  attemptLogin('', 'pass');           // اسم مستخدم فارغ
  attemptLogin('user1', '');          // كلمة مرور فارغة
  attemptLogin('unknown', 'pass');    // مستخدم غير موجود
  attemptLogin('user1', 'wrong');     // كلمة مرور خاطئة
  attemptLogin('user1', 'pass123');   // نجح
}
```

### مثال 2: معالج ملفات آمن

```dart
class FileException implements Exception {
  final String message;
  final String? path;
  
  FileException(this.message, {this.path});
  
  @override
  String toString() => path != null
      ? 'FileException: $message (الملف: $path)'
      : 'FileException: $message';
}

class FileProcessor {
  String? readFile(String path) {
    try {
      // محاكاة قراءة ملف
      if (!path.endsWith('.txt')) {
        throw FileException(
          'نوع الملف غير مدعوم',
          path: path,
        );
      }
      
      if (path.contains('missing')) {
        throw FileException(
          'الملف غير موجود',
          path: path,
        );
      }
      
      return 'محتوى الملف من $path';
    } on FileException {
      rethrow;  // إعادة رمي FileException
    } catch (e) {
      throw FileException(
        'خطأ غير متوقع: $e',
        path: path,
      );
    }
  }
  
  List<String> processMultipleFiles(List<String> paths) {
    List<String> results = [];
    List<String> errors = [];
    
    for (var path in paths) {
      try {
        String? content = readFile(path);
        if (content != null) {
          results.add(content);
        }
      } on FileException catch (e) {
        errors.add('خطأ في $path: ${e.message}');
      }
    }
    
    if (errors.isNotEmpty) {
      print('\n⚠️ حدثت أخطاء:');
      errors.forEach(print);
    }
    
    return results;
  }
}

void main() {
  var processor = FileProcessor();
  
  var files = [
    'document.txt',
    'image.jpg',       // نوع غير مدعوم
    'missing.txt',     // ملف غير موجود
    'report.txt',
  ];
  
  print('معالجة الملفات...');
  var results = processor.processMultipleFiles(files);
  
  print('\n✓ الملفات المعالجة بنجاح: ${results.length}');
  results.forEach(print);
}
```

### مثال 3: حاسبة متقدمة مع معالجة شاملة للأخطاء

```dart
class CalculatorException implements Exception {
  final String operation;
  final String message;
  final List<num>? operands;
  
  CalculatorException({
    required this.operation,
    required this.message,
    this.operands,
  });
  
  @override
  String toString() {
    String opStr = operands != null ? ' ${operands!.join(", ")}' : '';
    return 'CalculatorException [$operation]$opStr: $message';
  }
}

class Calculator {
  num add(num a, num b) => a + b;
  
  num subtract(num a, num b) => a - b;
  
  num multiply(num a, num b) => a * b;
  
  num divide(num a, num b) {
    if (b == 0) {
      throw CalculatorException(
        operation: 'القسمة',
        message: 'لا يمكن القسمة على صفر',
        operands: [a, b],
      );
    }
    return a / b;
  }
  
  num power(num base, num exponent) {
    if (base == 0 && exponent < 0) {
      throw CalculatorException(
        operation: 'الأس',
        message: 'لا يمكن رفع صفر لأس سالب',
        operands: [base, exponent],
      );
    }
    
    num result = 1;
    for (int i = 0; i < exponent.abs(); i++) {
      result *= base;
    }
    
    return exponent < 0 ? 1 / result : result;
  }
  
  num sqrt(num value) {
    if (value < 0) {
      throw CalculatorException(
        operation: 'الجذر التربيعي',
        message: 'لا يمكن حساب جذر عدد سالب',
        operands: [value],
      );
    }
    
    // حساب تقريبي للجذر التربيعي
    if (value == 0) return 0;
    
    num x = value;
    num y = 1;
    num precision = 0.000001;
    
    while (x - y > precision) {
      x = (x + y) / 2;
      y = value / x;
    }
    
    return x;
  }
  
  num calculate(String operation, List<num> operands) {
    try {
      switch (operation.toLowerCase()) {
        case 'add':
        case '+':
          if (operands.length != 2) {
            throw CalculatorException(
              operation: 'الجمع',
              message: 'يتطلب رقمين بالضبط',
              operands: operands,
            );
          }
          return add(operands[0], operands[1]);
        
        case 'divide':
        case '/':
          if (operands.length != 2) {
            throw CalculatorException(
              operation: 'القسمة',
              message: 'يتطلب رقمين بالضبط',
              operands: operands,
            );
          }
          return divide(operands[0], operands[1]);
        
        case 'sqrt':
          if (operands.length != 1) {
            throw CalculatorException(
              operation: 'الجذر التربيعي',
              message: 'يتطلب رقماً واحداً فقط',
              operands: operands,
            );
          }
          return sqrt(operands[0]);
        
        default:
          throw CalculatorException(
            operation: operation,
            message: 'عملية غير مدعومة',
          );
      }
    } on CalculatorException {
      rethrow;
    } catch (e) {
      throw CalculatorException(
        operation: operation,
        message: 'خطأ غير متوقع: $e',
        operands: operands,
      );
    }
  }
}

void main() {
  var calc = Calculator();
  
  void performCalculation(String op, List<num> operands) {
    try {
      num result = calc.calculate(op, operands);
      print('✓ $op ${operands.join(" ")} = $result');
    } on CalculatorException catch (e) {
      print('✗ $e');
    } catch (e, stack) {
      print('✗ خطأ فادح: $e');
      print('Stack: $stack');
    }
  }
  
  print('=== اختبار الحاسبة ===\n');
  
  performCalculation('+', [5, 3]);           // نجح
  performCalculation('/', [10, 2]);          // نجح
  performCalculation('/', [10, 0]);          // فشل: قسمة على صفر
  performCalculation('sqrt', [16]);          // نجح
  performCalculation('sqrt', [-4]);          // فشل: جذر عدد سالب
  performCalculation('+', [1, 2, 3]);        // فشل: عدد خاطئ من المعاملات
  performCalculation('unknown', [5, 3]);     // فشل: عملية غير مدعومة
}
```

## أفضل الممارسات

1. **استخدم استثناءات محددة**: لا تستخدم `Exception` العامة دائماً
2. **أنشئ استثناءات مخصصة**: للمنطق الخاص بتطبيقك
3. **لا تبتلع الاستثناءات**: عالجها أو أعد رميها
4. **استخدم finally للتنظيف**: لإغلاق الموارد
5. **وثّق الاستثناءات**: اذكر ما قد ترميه الدالة
6. **تجنب استخدام try-catch لمنطق البرنامج**: استخدمها للأخطاء فقط
7. **سجّل الأخطاء**: احتفظ بسجل للأخطاء للتتبع

---

[⬅️ الموضوع السابق: Null Safety](10_null_safety.md) | [العودة للفهرس](README.md) | [الموضوع التالي: البرمجة غير المتزامنة ➡️](12_async.md)
