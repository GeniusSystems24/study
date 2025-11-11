# 14. المكتبات والحزم (Libraries & Packages)

## المكتبات في Dart

### استيراد المكتبات المدمجة

```dart
// مكتبة dart:core (مستوردة تلقائياً)
// تحتوي على: print, List, Map, etc.

// مكتبة الرياضيات
import 'dart:math';

void main() {
  var random = Random();
  print(random.nextInt(100));
  print(sqrt(16));  // 4.0
  print(pi);        // 3.141592653589793
}
```

### المكتبات الشائعة المدمجة

```dart
import 'dart:convert';  // JSON, Base64, etc.
import 'dart:io';       // ملفات، شبكات (لا يعمل على الويب)
import 'dart:async';    // Future, Stream
import 'dart:collection'; // مجموعات متقدمة

void main() {
  // dart:convert
  var json = '{"name": "أحمد", "age": 25}';
  var decoded = jsonDecode(json);
  print(decoded['name']);
  
  var encoded = jsonEncode({'city': 'القاهرة'});
  print(encoded);
}
```

## إنشاء مكتباتك الخاصة

### ملف مكتبة بسيط

```dart
// lib/math_utils.dart
library math_utils;

int add(int a, int b) => a + b;
int multiply(int a, int b) => a * b;

class Calculator {
  double divide(double a, double b) {
    if (b == 0) throw Exception('لا يمكن القسمة على صفر');
    return a / b;
  }
}
```

### استيراد المكتبة

```dart
// main.dart
import 'lib/math_utils.dart';

void main() {
  print(add(5, 3));
  
  var calc = Calculator();
  print(calc.divide(10, 2));
}
```

### استيراد جزئي

```dart
// استيراد فقط ما تحتاجه
import 'dart:math' show Random, sqrt;

// استبعاد أجزاء معينة
import 'dart:math' hide pow;

void main() {
  print(sqrt(16));
  var random = Random();
  // pow(2, 3);  // خطأ! تم استبعاده
}
```

### as - الأسماء المستعارة

```dart
import 'dart:math' as math;
import 'package:my_package/math.dart' as myMath;

void main() {
  print(math.sqrt(16));
  print(math.pi);
}
```

## pub.dev - مدير الحزم

### pubspec.yaml

```yaml
name: my_app
description: تطبيق Dart بسيط
version: 1.0.0

environment:
  sdk: '>=2.19.0 <3.0.0'

dependencies:
  # حزمة HTTP للطلبات
  http: ^1.1.0
  
  # حزمة للتاريخ والوقت
  intl: ^0.18.0

dev_dependencies:
  # للاختبارات
  test: ^1.24.0
  
  # للتحليل
  lints: ^2.1.0
```

### تثبيت الحزم

```bash
# تثبيت جميع التبعيات
dart pub get

# تحديث الحزم
dart pub upgrade

# إضافة حزمة جديدة
dart pub add http

# إضافة حزمة تطوير
dart pub add --dev test
```

## استخدام الحزم

### مثال: حزمة http

```dart
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> fetchData() async {
  var url = Uri.parse('https://jsonplaceholder.typicode.com/users/1');
  
  try {
    var response = await http.get(url);
    
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print('الاسم: ${data['name']}');
      print('البريد: ${data['email']}');
    } else {
      print('فشل الطلب: ${response.statusCode}');
    }
  } catch (e) {
    print('خطأ: $e');
  }
}

void main() async {
  await fetchData();
}
```

### مثال: حزمة intl للتاريخ

```dart
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  await initializeDateFormatting('ar');
  
  var now = DateTime.now();
  
  // تنسيق التاريخ
  var formatter = DateFormat.yMMMMd('ar');
  print(formatter.format(now));
  
  // تنسيق الوقت
  var timeFormatter = DateFormat.Hms('ar');
  print(timeFormatter.format(now));
  
  // تنسيق مخصص
  var customFormatter = DateFormat('EEEE، d MMMM yyyy', 'ar');
  print(customFormatter.format(now));
}
```

## إنشاء مكتبة كاملة

### هيكل المشروع

```
my_library/
├── lib/
│   ├── my_library.dart        # الملف الرئيسي
│   ├── src/
│   │   ├── models.dart        # النماذج
│   │   ├── services.dart      # الخدمات
│   │   └── utils.dart         # الأدوات
│   └── constants.dart         # الثوابت
├── test/
│   └── my_library_test.dart
├── pubspec.yaml
└── README.md
```

### lib/my_library.dart

```dart
library my_library;

// تصدير الملفات العامة
export 'src/models.dart';
export 'src/services.dart';
export 'constants.dart';

// إخفاء الأدوات الداخلية
// لا نصدر src/utils.dart
```

### lib/src/models.dart

```dart
class User {
  final String id;
  final String name;
  final String email;
  
  User({
    required this.id,
    required this.name,
    required this.email,
  });
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
  };
  
  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'],
    name: json['name'],
    email: json['email'],
  );
}
```

### lib/src/services.dart

```dart
import 'models.dart';

class UserService {
  final List<User> _users = [];
  
  void addUser(User user) {
    _users.add(user);
  }
  
  List<User> getAllUsers() {
    return List.unmodifiable(_users);
  }
  
  User? findById(String id) {
    try {
      return _users.firstWhere((user) => user.id == id);
    } catch (e) {
      return null;
    }
  }
}
```

### lib/constants.dart

```dart
const String APP_NAME = 'مكتبتي';
const String VERSION = '1.0.0';
const int MAX_USERS = 100;
```

## part و part of

### تقسيم ملف كبير

```dart
// lib/big_library.dart
library big_library;

part 'src/part1.dart';
part 'src/part2.dart';

void mainFunction() {
  functionFromPart1();
  functionFromPart2();
}
```

```dart
// lib/src/part1.dart
part of '../big_library.dart';

void functionFromPart1() {
  print('من الجزء 1');
}
```

```dart
// lib/src/part2.dart
part of '../big_library.dart';

void functionFromPart2() {
  print('من الجزء 2');
}
```

## أمثلة عملية

### مثال 1: مكتبة للتحقق من البيانات

```dart
// lib/validators.dart
library validators;

class Validators {
  static bool isEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
    );
    return emailRegex.hasMatch(email);
  }
  
  static bool isPhone(String phone) {
    final phoneRegex = RegExp(r'^(010|011|012|015)\d{8}$');
    return phoneRegex.hasMatch(phone);
  }
  
  static bool isStrongPassword(String password) {
    // على الأقل 8 أحرف، حرف كبير، حرف صغير، رقم، رمز خاص
    if (password.length < 8) return false;
    
    bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
    bool hasLowercase = password.contains(RegExp(r'[a-z]'));
    bool hasDigit = password.contains(RegExp(r'[0-9]'));
    bool hasSpecial = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    
    return hasUppercase && hasLowercase && hasDigit && hasSpecial;
  }
  
  static bool isInRange(num value, num min, num max) {
    return value >= min && value <= max;
  }
  
  static bool isNotEmpty(String? text) {
    return text != null && text.trim().isNotEmpty;
  }
}

// استخدام المكتبة
void main() {
  print(Validators.isEmail('test@example.com'));  // true
  print(Validators.isEmail('invalid'));           // false
  
  print(Validators.isPhone('01012345678'));       // true
  print(Validators.isPhone('12345'));             // false
  
  print(Validators.isStrongPassword('Pass123!'));  // true
  print(Validators.isStrongPassword('weak'));      // false
}
```

### مثال 2: مكتبة للعمليات الحسابية

```dart
// lib/math_ext.dart
library math_ext;

import 'dart:math' as math;

extension NumberExtensions on num {
  /// تقريب لعدد معين من المنازل العشرية
  double roundToDecimal(int places) {
    num mod = math.pow(10.0, places);
    return ((this * mod).round().toDouble() / mod);
  }
  
  /// التحويل إلى نسبة مئوية
  String toPercentage({int decimals = 2}) {
    return '${(this * 100).roundToDecimal(decimals)}%';
  }
  
  /// هل الرقم زوجي
  bool get isEven => this % 2 == 0;
  
  /// هل الرقم فردي
  bool get isOdd => !isEven;
  
  /// القيمة المطلقة
  num get absolute => this.abs();
}

class MathUtils {
  /// حساب المعدل
  static double average(List<num> numbers) {
    if (numbers.isEmpty) return 0;
    return numbers.reduce((a, b) => a + b) / numbers.length;
  }
  
  /// إيجاد الوسيط
  static double median(List<num> numbers) {
    if (numbers.isEmpty) return 0;
    
    var sorted = List<num>.from(numbers)..sort();
    int middle = sorted.length ~/ 2;
    
    if (sorted.length.isOdd) {
      return sorted[middle].toDouble();
    } else {
      return (sorted[middle - 1] + sorted[middle]) / 2;
    }
  }
  
  /// أكبر قيمة
  static num max(List<num> numbers) {
    if (numbers.isEmpty) throw Exception('القائمة فارغة');
    return numbers.reduce((a, b) => a > b ? a : b);
  }
  
  /// أصغر قيمة
  static num min(List<num> numbers) {
    if (numbers.isEmpty) throw Exception('القائمة فارغة');
    return numbers.reduce((a, b) => a < b ? a : b);
  }
  
  /// المدى
  static num range(List<num> numbers) {
    return max(numbers) - min(numbers);
  }
}

// استخدام المكتبة
void main() {
  // استخدام Extensions
  print(3.14159.roundToDecimal(2));      // 3.14
  print(0.75.toPercentage());            // 75.0%
  print(5.isEven);                       // false
  print((-10).absolute);                 // 10
  
  // استخدام MathUtils
  var numbers = [10, 20, 30, 40, 50];
  print('المعدل: ${MathUtils.average(numbers)}');     // 30.0
  print('الوسيط: ${MathUtils.median(numbers)}');      // 30.0
  print('الأكبر: ${MathUtils.max(numbers)}');         // 50
  print('الأصغر: ${MathUtils.min(numbers)}');         // 10
  print('المدى: ${MathUtils.range(numbers)}');        // 40
}
```

### مثال 3: مكتبة للتعامل مع JSON

```dart
// lib/json_helper.dart
library json_helper;

import 'dart:convert';

class JsonHelper {
  /// تحويل JSON string إلى Map
  static Map<String, dynamic>? parseJson(String jsonString) {
    try {
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      print('خطأ في تحليل JSON: $e');
      return null;
    }
  }
  
  /// تحويل Map إلى JSON string
  static String toJsonString(Map<String, dynamic> data, {bool pretty = false}) {
    try {
      if (pretty) {
        var encoder = JsonEncoder.withIndent('  ');
        return encoder.convert(data);
      }
      return jsonEncode(data);
    } catch (e) {
      print('خطأ في تحويل JSON: $e');
      return '{}';
    }
  }
  
  /// قراءة قيمة من JSON بأمان
  static T? getValue<T>(Map<String, dynamic> json, String key) {
    if (json.containsKey(key)) {
      return json[key] as T?;
    }
    return null;
  }
  
  /// دمج JSON objects
  static Map<String, dynamic> merge(
    Map<String, dynamic> target,
    Map<String, dynamic> source,
  ) {
    var result = Map<String, dynamic>.from(target);
    source.forEach((key, value) {
      result[key] = value;
    });
    return result;
  }
}

// استخدام المكتبة
void main() {
  // تحليل JSON
  var jsonString = '{"name": "أحمد", "age": 25, "city": "القاهرة"}';
  var data = JsonHelper.parseJson(jsonString);
  print(data);
  
  // تحويل إلى JSON
  var userData = {
    'name': 'محمد',
    'age': 30,
    'hobbies': ['قراءة', 'سباحة'],
  };
  
  print(JsonHelper.toJsonString(userData));
  print('\nJSON منسق:');
  print(JsonHelper.toJsonString(userData, pretty: true));
  
  // قراءة آمنة
  String? name = JsonHelper.getValue<String>(userData, 'name');
  int? age = JsonHelper.getValue<int>(userData, 'age');
  print('\nالاسم: $name، العمر: $age');
  
  // دمج
  var base = {'a': 1, 'b': 2};
  var extra = {'c': 3, 'b': 20};  // b سيُستبدل
  var merged = JsonHelper.merge(base, extra);
  print('\nالدمج: $merged');
}
```

## نشر حزمة على pub.dev

### 1. تحضير الحزمة

```yaml
# pubspec.yaml
name: my_awesome_package
description: حزمة رائعة تفعل أشياء مذهلة
version: 1.0.0
homepage: https://github.com/username/my_awesome_package

environment:
  sdk: '>=2.19.0 <3.0.0'

# اختياري
dependencies:
  # التبعيات

dev_dependencies:
  test: ^1.24.0
```

### 2. إنشاء README.md و CHANGELOG.md

### 3. التحقق والنشر

```bash
# التحقق من الحزمة
dart pub publish --dry-run

# النشر الفعلي
dart pub publish
```

## أفضل الممارسات

1. **استخدم imports محددة**: `show` و `hide` لتحسين الأداء
2. **نظّم المكتبات**: ضع الكود في `lib/src/` وصدّر ما تحتاج
3. **وثّق الكود**: استخدم `///` للتوثيق
4. **اتبع معايير التسمية**: snake_case للملفات
5. **استخدم semantic versioning**: للحزم المنشورة
6. **اختبر المكتبات**: قبل النشر
7. **اقرأ التوثيق**: للحزم التي تستخدمها

---

[⬅️ الموضوع السابق: Generics](13_generics.md) | [العودة للفهرس](README.md) | [الموضوع التالي: مفاهيم متقدمة ➡️](15_advanced.md)
