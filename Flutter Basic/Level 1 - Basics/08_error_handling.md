# 08 - معالجة الأخطاء (Error Handling)

## 📋 المحتويات

- [المقدمة](#المقدمة)
- [أنواع الأخطاء](#أنواع-الأخطاء)
- [try-catch](#try-catch)
- [throw](#throw)
- [finally](#finally)
- [أنواع الاستثناءات](#أنواع-الاستثناءات)
- [استثناءات مخصصة](#استثناءات-مخصصة)
- [أمثلة عملية](#أمثلة-عملية)

---

## 🎯 المقدمة

معالجة الأخطاء (Error Handling) هي طريقة للتعامل مع الأخطاء والاستثناءات التي قد تحدث أثناء تنفيذ البرنامج.

### لماذا نحتاج معالجة الأخطاء؟

- ✅ منع تعطل التطبيق
- ✅ توفير تجربة مستخدم أفضل
- ✅ تسجيل الأخطاء وتتبعها
- ✅ التعافي من الأخطاء المتوقعة

---

## ⚠️ أنواع الأخطاء

### 1. Compile-time Errors

أخطاء في بناء الكود (syntax errors):

```dart
// خطأ: فاصلة منقوطة مفقودة
// int x = 5

// خطأ: نوع خاطئ
// String name = 123;
```

### 2. Runtime Errors

أخطاء تحدث أثناء التنفيذ:

```dart
void main() {
  // خطأ: القسمة على صفر
  // print(10 / 0);  // Infinity في Dart
  
  // خطأ: الوصول لفهرس خارج النطاق
  List<int> numbers = [1, 2, 3];
  // print(numbers[10]);  // RangeError
  
  // خطأ: null reference
  String? name;
  // print(name.length);  // Null check operator error
}
```

---

## 🛡️ try-catch

### الاستخدام الأساسي

```dart
void main() {
  try {
    int result = 10 ~/ 0;  // القسمة الصحيحة على صفر
    print(result);
  } catch (e) {
    print('حدث خطأ: $e');
  }
}
```

### معرفة نوع الاستثناء

```dart
void main() {
  try {
    List<int> numbers = [1, 2, 3];
    print(numbers[10]);
  } on RangeError catch (e) {
    print('خطأ في النطاق: $e');
  } catch (e) {
    print('خطأ آخر: $e');
  }
}
```

### الحصول على Stack Trace

```dart
void main() {
  try {
    dangerousOperation();
  } catch (e, stackTrace) {
    print('الخطأ: $e');
    print('تتبع المكدس:\n$stackTrace');
  }
}

void dangerousOperation() {
  throw Exception('عملية خطرة فشلت!');
}
```

---

## 💥 throw

### رمي استثناء

```dart
void checkAge(int age) {
  if (age < 0) {
    throw ArgumentError('العمر لا يمكن أن يكون سالباً');
  }
  if (age < 18) {
    throw Exception('يجب أن يكون العمر 18 أو أكثر');
  }
  print('العمر صحيح: $age');
}

void main() {
  try {
    checkAge(-5);
  } catch (e) {
    print('خطأ: $e');
  }
  
  try {
    checkAge(15);
  } catch (e) {
    print('خطأ: $e');
  }
  
  try {
    checkAge(25);
  } catch (e) {
    print('خطأ: $e');
  }
}
```

### إعادة رمي الاستثناء

```dart
void processData(String data) {
  try {
    if (data.isEmpty) {
      throw Exception('البيانات فارغة');
    }
    print('معالجة: $data');
  } catch (e) {
    print('خطأ في processData: $e');
    rethrow;  // إعادة رمي الاستثناء للمستوى الأعلى
  }
}

void main() {
  try {
    processData('');
  } catch (e) {
    print('تم اصطياد الخطأ في main: $e');
  }
}
```

---

## 🔒 finally

يُنفذ دائماً بغض النظر عن حدوث خطأ أم لا:

```dart
void readFile(String filename) {
  print('فتح الملف: $filename');
  
  try {
    if (filename.isEmpty) {
      throw Exception('اسم الملف فارغ');
    }
    print('قراءة البيانات من $filename');
  } catch (e) {
    print('خطأ: $e');
  } finally {
    print('إغلاق الملف: $filename');
    // يُنفذ دائماً حتى لو حدث خطأ
  }
}

void main() {
  readFile('data.txt');
  print('---');
  readFile('');
}
```

---

## 📚 أنواع الاستثناءات

### الاستثناءات المدمجة

```dart
void main() {
  // FormatException
  try {
    int number = int.parse('abc');
  } on FormatException catch (e) {
    print('خطأ في التنسيق: $e');
  }
  
  // RangeError
  try {
    List<int> numbers = [1, 2, 3];
    print(numbers[10]);
  } on RangeError catch (e) {
    print('خطأ في النطاق: $e');
  }
  
  // ArgumentError
  try {
    checkPositive(-5);
  } on ArgumentError catch (e) {
    print('خطأ في المعامل: $e');
  }
  
  // StateError
  try {
    List<int> empty = [];
    print(empty.first);
  } on StateError catch (e) {
    print('خطأ في الحالة: $e');
  }
}

void checkPositive(int value) {
  if (value < 0) {
    throw ArgumentError('القيمة يجب أن تكون موجبة');
  }
}
```

---

## 🎨 استثناءات مخصصة

### إنشاء استثناء مخصص

```dart
class InvalidEmailException implements Exception {
  final String message;
  
  InvalidEmailException(this.message);
  
  @override
  String toString() => 'InvalidEmailException: $message';
}

class InvalidPasswordException implements Exception {
  final String message;
  
  InvalidPasswordException(this.message);
  
  @override
  String toString() => 'InvalidPasswordException: $message';
}

void validateEmail(String email) {
  if (email.isEmpty) {
    throw InvalidEmailException('البريد الإلكتروني مطلوب');
  }
  if (!email.contains('@')) {
    throw InvalidEmailException('البريد الإلكتروني غير صحيح');
  }
}

void validatePassword(String password) {
  if (password.isEmpty) {
    throw InvalidPasswordException('كلمة المرور مطلوبة');
  }
  if (password.length < 6) {
    throw InvalidPasswordException('كلمة المرور قصيرة جداً (على الأقل 6 أحرف)');
  }
}

void main() {
  // اختبار البريد الإلكتروني
  try {
    validateEmail('test');
  } on InvalidEmailException catch (e) {
    print(e);
  }
  
  // اختبار كلمة المرور
  try {
    validatePassword('123');
  } on InvalidPasswordException catch (e) {
    print(e);
  }
  
  // نجاح التحقق
  try {
    validateEmail('test@example.com');
    validatePassword('password123');
    print('تم التحقق بنجاح!');
  } catch (e) {
    print(e);
  }
}
```

---

## 💼 أمثلة عملية

### مثال 1: نظام تسجيل المستخدم

```dart
class User {
  String email;
  String password;
  
  User(this.email, this.password);
}

class UserRegistrationError implements Exception {
  final String message;
  UserRegistrationError(this.message);
  
  @override
  String toString() => 'UserRegistrationError: $message';
}

class UserService {
  List<User> _users = [];
  
  void register(String email, String password, String confirmPassword) {
    // التحقق من البريد الإلكتروني
    if (email.isEmpty) {
      throw UserRegistrationError('البريد الإلكتروني مطلوب');
    }
    if (!email.contains('@') || !email.contains('.')) {
      throw UserRegistrationError('البريد الإلكتروني غير صحيح');
    }
    
    // التحقق من وجود المستخدم
    if (_users.any((user) => user.email == email)) {
      throw UserRegistrationError('البريد الإلكتروني مستخدم بالفعل');
    }
    
    // التحقق من كلمة المرور
    if (password.isEmpty) {
      throw UserRegistrationError('كلمة المرور مطلوبة');
    }
    if (password.length < 8) {
      throw UserRegistrationError('كلمة المرور يجب أن تكون 8 أحرف على الأقل');
    }
    if (!password.contains(RegExp(r'[0-9]'))) {
      throw UserRegistrationError('كلمة المرور يجب أن تحتوي على رقم واحد على الأقل');
    }
    if (password != confirmPassword) {
      throw UserRegistrationError('كلمات المرور غير متطابقة');
    }
    
    // التسجيل
    _users.add(User(email, password));
    print('✅ تم تسجيل المستخدم بنجاح: $email');
  }
  
  User? login(String email, String password) {
    try {
      var user = _users.firstWhere(
        (u) => u.email == email && u.password == password
      );
      print('✅ تم تسجيل الدخول: $email');
      return user;
    } catch (e) {
      print('❌ بيانات الدخول غير صحيحة');
      return null;
    }
  }
}

void main() {
  var service = UserService();
  
  // محاولات تسجيل فاشلة
  try {
    service.register('', 'password', 'password');
  } on UserRegistrationError catch (e) {
    print('❌ $e');
  }
  
  try {
    service.register('invalid-email', 'password', 'password');
  } on UserRegistrationError catch (e) {
    print('❌ $e');
  }
  
  try {
    service.register('test@example.com', '123', '123');
  } on UserRegistrationError catch (e) {
    print('❌ $e');
  }
  
  try {
    service.register('test@example.com', 'password', 'different');
  } on UserRegistrationError catch (e) {
    print('❌ $e');
  }
  
  // تسجيل ناجح
  try {
    service.register('test@example.com', 'password123', 'password123');
  } on UserRegistrationError catch (e) {
    print('❌ $e');
  }
  
  // محاولة تسجيل نفس البريد
  try {
    service.register('test@example.com', 'password456', 'password456');
  } on UserRegistrationError catch (e) {
    print('❌ $e');
  }
  
  // تسجيل الدخول
  print('\n--- تسجيل الدخول ---');
  service.login('test@example.com', 'wrongpassword');
  service.login('test@example.com', 'password123');
}
```

### مثال 2: معالجة البيانات من API

```dart
class ApiException implements Exception {
  final int statusCode;
  final String message;
  
  ApiException(this.statusCode, this.message);
  
  @override
  String toString() => 'API Error ($statusCode): $message';
}

class ApiService {
  Future<Map<String, dynamic>> fetchData(String endpoint) async {
    try {
      // محاكاة استدعاء API
      await Future.delayed(Duration(seconds: 1));
      
      // محاكاة أخطاء مختلفة
      if (endpoint.isEmpty) {
        throw ApiException(400, 'Bad Request: Endpoint is required');
      }
      
      if (endpoint == 'unauthorized') {
        throw ApiException(401, 'Unauthorized: Invalid credentials');
      }
      
      if (endpoint == 'not-found') {
        throw ApiException(404, 'Not Found: Resource does not exist');
      }
      
      if (endpoint == 'server-error') {
        throw ApiException(500, 'Internal Server Error');
      }
      
      // نجاح
      return {'data': 'Success from $endpoint', 'status': 200};
      
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(0, 'Network Error: $e');
    }
  }
}

void main() async {
  var api = ApiService();
  
  // محاولات مختلفة
  List<String> endpoints = [
    '',
    'unauthorized',
    'not-found',
    'server-error',
    'users'
  ];
  
  for (var endpoint in endpoints) {
    print('\nجلب البيانات من: "$endpoint"');
    try {
      var data = await api.fetchData(endpoint);
      print('✅ نجاح: $data');
    } on ApiException catch (e) {
      print('❌ $e');
      
      // معالجة خاصة بناءً على نوع الخطأ
      switch (e.statusCode) {
        case 401:
          print('   → يرجى تسجيل الدخول مرة أخرى');
          break;
        case 404:
          print('   → المورد المطلوب غير موجود');
          break;
        case 500:
          print('   → يرجى المحاولة لاحقاً');
          break;
        default:
          print('   → حدث خطأ غير متوقع');
      }
    }
  }
}
```

---

## 📚 للتعمق أكثر

لمزيد من التفاصيل، راجع:

- [معالجة الاستثناءات في Dart](../Dart%20basic/11_exceptions.md)
- [البرمجة التفاعلية](09_async_programming.md)

---

## 📖 المراجع والمصادر

### مصادر Dart الرسمية

1. **Dart Error Handling**
   - [Exceptions](https://dart.dev/guides/language/language-tour#exceptions)
   - [Throw](https://dart.dev/guides/language/language-tour#throw)
   - [Catch](https://dart.dev/guides/language/language-tour#catch)
   - [Finally](https://dart.dev/guides/language/language-tour#finally)

2. **Exception Classes**
   - [Exception Class](https://api.dart.dev/stable/dart-core/Exception-class.html)
   - [Error Class](https://api.dart.dev/stable/dart-core/Error-class.html)
   - [Common Exceptions](https://dart.dev/guides/libraries/library-tour#exceptions)

3. **Effective Dart - Error Handling**
   - [Error Handling Best Practices](https://dart.dev/guides/language/effective-dart/usage#error-handling)
   - [When to Use Exceptions](https://dart.dev/guides/language/effective-dart/usage#do-throw-exceptions-rather-than-returning-null-or-false)

### مصادر داخل المستودع

4. **خطة تعلم Dart الشاملة**
   - [فهرس Dart الكامل](../Dart%20basic/README.md)
   - [معالجة الاستثناءات](../Dart%20basic/11_exceptions.md)

### مراجع API

5. **Dart Core Library**
   - [dart:core Exceptions](https://api.dart.dev/stable/dart-core/dart-core-library.html#exceptions)
   - [ArgumentError](https://api.dart.dev/stable/dart-core/ArgumentError-class.html)
   - [FormatException](https://api.dart.dev/stable/dart-core/FormatException-class.html)
   - [RangeError](https://api.dart.dev/stable/dart-core/RangeError-class.html)

### مصادر إضافية

6. **Community Resources**
   - [Dart Error Handling on Stack Overflow](https://stackoverflow.com/questions/tagged/dart+exception)

7. **Video Tutorials**
   - [Dart Error Handling - YouTube](https://www.youtube.com/dartlang)

---

## 💡 نصائح

- ✅ استخدم try-catch للأخطاء المتوقعة
- ✅ استخدم finally لتنظيف الموارد
- ✅ أنشئ استثناءات مخصصة للأخطاء الخاصة بتطبيقك
- ✅ لا تترك catch فارغاً - سجّل الأخطاء على الأقل
- ✅ استخدم on للتعامل مع أنواع محددة من الاستثناءات
- ✅ استخدم rethrow لإعادة رمي الاستثناء بعد معالجته
- ✅ وفّر رسائل خطأ واضحة للمستخدم
- ✅ مارس على [DartPad](https://dartpad.dev/)

---

[⬅️ السابق: المجموعات المتقدمة](07_collections.md)
[🏠 العودة للفهرس](../README.md)
[التالي: البرمجة التفاعلية ➡️](09_async_programming.md)
