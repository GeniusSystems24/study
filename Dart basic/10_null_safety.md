# 10. Null Safety

## مقدمة

Null Safety هي ميزة في Dart تساعد على تجنب أخطاء null reference في وقت التشغيل. تم إدخالها في Dart 2.12.

## الأنواع Nullable و Non-nullable

### Non-nullable بشكل افتراضي

```dart
// لا يمكن أن تكون null
String name = 'أحمد';
int age = 25;
bool isActive = true;

// name = null;  // خطأ!
// age = null;   // خطأ!
```

### Nullable Types

```dart
// يمكن أن تكون null باستخدام ?
String? nullableName;
int? nullableAge;
bool? nullableFlag;

nullableName = 'محمد';
nullableName = null;  // مسموح

print(nullableName);  // null
```

## معاملات Null Safety

### ! - معامل التأكيد (Null Assertion Operator)

```dart
String? name = 'أحمد';

// استخدام ! عندما تكون متأكداً أن القيمة ليست null
int length = name!.length;
print(length);  // 4

// خطر: سيسبب runtime error إذا كانت null
String? emptyName;
// int len = emptyName!.length;  // خطأ في وقت التشغيل!
```

### ?. - معامل الوصول الآمن (Null-aware Access)

```dart
String? name;

// يعيد null إذا كان المتغير null
int? length = name?.length;
print(length);  // null

name = 'محمد';
length = name?.length;
print(length);  // 4

// استخدام متسلسل
String? email = 'test@example.com';
String? domain = email?.split('@')?.last;
```

### ?? - معامل القيمة الافتراضية (Null Coalescing)

```dart
String? username;

// إذا كانت username null، استخدم 'ضيف'
String displayName = username ?? 'ضيف';
print(displayName);  // ضيف

username = 'ahmed123';
displayName = username ?? 'ضيف';
print(displayName);  // ahmed123

// سلسلة من القيم الاحتياطية
String? name1;
String? name2;
String? name3 = 'القيمة الثالثة';
String result = name1 ?? name2 ?? name3 ?? 'افتراضي';
```

### ??= - الإسناد إذا كانت null

```dart
int? score;

// تعيين القيمة فقط إذا كانت null
score ??= 0;
print(score);  // 0

score ??= 100;  // لن يتغير لأنها ليست null
print(score);  // 0

// مثال عملي
class Config {
  String? host;
  int? port;
  
  void setDefaults() {
    host ??= 'localhost';
    port ??= 8080;
  }
}
```

## late - المتغيرات المتأخرة

```dart
// للمتغيرات التي ستُهيأ لاحقاً لكن قبل الاستخدام
late String description;
late int userId;

void initialize() {
  description = 'وصف معين';
  userId = 123;
}

void display() {
  // يجب استدعاء initialize() قبل استخدام المتغيرات
  print(description);
  print(userId);
}

// late مع lazy initialization
late String heavyData = loadHeavyData();

String loadHeavyData() {
  print('تحميل البيانات الثقيلة...');
  return 'بيانات ضخمة';
}

void main() {
  print('البرنامج بدأ');
  // لم يتم استدعاء loadHeavyData() بعد
  print(heavyData);  // الآن يتم التحميل
}
```

## required - المعاملات المطلوبة

```dart
class User {
  final String name;
  final String email;
  final int? age;  // اختياري
  
  User({
    required this.name,    // إلزامي
    required this.email,   // إلزامي
    this.age,              // اختياري
  });
}

void main() {
  // يجب تمرير name و email
  var user = User(
    name: 'أحمد',
    email: 'ahmed@example.com',
  );
  
  // var user2 = User(name: 'محمد');  // خطأ! email مطلوب
}
```

## التعامل مع Collections

```dart
// قائمة nullable vs قائمة من عناصر nullable
List<String>? nullableList;    // القائمة نفسها قد تكون null
List<String?> listOfNullables; // القائمة موجودة لكن العناصر قد تكون null

// أمثلة
List<String>? names1;
// names1.add('أحمد');  // خطأ! القائمة null

List<String?> names2 = [null, 'محمد', null, 'علي'];
print(names2.length);  // 4

// قائمة غير nullable من عناصر غير nullable
List<String> names3 = ['أحمد', 'محمد'];
// names3.add(null);  // خطأ!
```

## Type Promotion

```dart
String? name = 'أحمد';

// التحقق من null يرقي النوع
if (name != null) {
  // داخل هذا النطاق، name هو String (غير nullable)
  print(name.length);  // لا حاجة لـ ! أو ?.
  print(name.toUpperCase());
}

// مع المتغيرات المحلية فقط
String? local = getName();
if (local != null) {
  print(local.length);  // OK
}

String? getName() => 'اسم';
```

## أنماط شائعة

### التحقق والاستخدام

```dart
String? getUserName() {
  // قد تعيد null
  return null;
}

void greetUser() {
  String? name = getUserName();
  
  // الطريقة 1: التحقق
  if (name != null) {
    print('مرحباً $name');
  }
  
  // الطريقة 2: القيمة الافتراضية
  print('مرحباً ${name ?? "ضيف"}');
  
  // الطريقة 3: الوصول الآمن
  print('طول الاسم: ${name?.length ?? 0}');
}
```

### القيم الافتراضية في الدوال

```dart
String formatName(String? name) {
  // استخدام ?? مباشرة
  return (name ?? 'غير معروف').toUpperCase();
}

void main() {
  print(formatName('أحمد'));   // أحمد
  print(formatName(null));     // غير معروف
}
```

### Pattern مع Collections

```dart
List<String?> names = ['أحمد', null, 'محمد', null, 'علي'];

// تصفية القيم null
List<String> validNames = names
    .where((name) => name != null)
    .map((name) => name!)  // آمن هنا لأننا رشحنا null
    .toList();

print(validNames);  // [أحمد, محمد, علي]

// أو باستخدام whereType
List<String> validNames2 = names.whereType<String>().toList();
```

## أمثلة عملية

### مثال 1: نظام التكوين (Configuration)

```dart
class AppConfig {
  String? apiUrl;
  int? timeout;
  bool? debugMode;
  
  late final String finalApiUrl;
  late final int finalTimeout;
  late final bool finalDebugMode;
  
  void initialize({
    String? url,
    int? timeoutSeconds,
    bool? debug,
  }) {
    apiUrl = url;
    timeout = timeoutSeconds;
    debugMode = debug;
    
    // تعيين القيم النهائية مع defaults
    finalApiUrl = apiUrl ?? 'https://api.default.com';
    finalTimeout = timeout ?? 30;
    finalDebugMode = debugMode ?? false;
  }
  
  void displayConfig() {
    print('API URL: $finalApiUrl');
    print('Timeout: $finalTimeout seconds');
    print('Debug Mode: $finalDebugMode');
  }
}

void main() {
  var config = AppConfig();
  config.initialize(url: 'https://myapi.com', debug: true);
  config.displayConfig();
}
```

### مثال 2: معالجة بيانات المستخدم

```dart
class UserProfile {
  final String id;
  final String username;
  String? email;
  String? phone;
  String? bio;
  DateTime? birthDate;
  
  UserProfile({
    required this.id,
    required this.username,
    this.email,
    this.phone,
    this.bio,
    this.birthDate,
  });
  
  int? get age {
    if (birthDate == null) return null;
    
    final now = DateTime.now();
    int age = now.year - birthDate!.year;
    
    if (now.month < birthDate!.month ||
        (now.month == birthDate!.month && now.day < birthDate!.day)) {
      age--;
    }
    
    return age;
  }
  
  String get displayName => username;
  
  String get contactInfo {
    List<String> info = [];
    
    if (email != null) info.add('Email: $email');
    if (phone != null) info.add('Phone: $phone');
    
    return info.isEmpty ? 'لا توجد معلومات اتصال' : info.join(', ');
  }
  
  void displayProfile() {
    print('\n--- الملف الشخصي ---');
    print('المعرف: $id');
    print('اسم المستخدم: $username');
    print(contactInfo);
    print('النبذة: ${bio ?? "غير متوفرة"}');
    print('العمر: ${age?.toString() ?? "غير محدد"}');
  }
}

void main() {
  var user1 = UserProfile(
    id: 'U001',
    username: 'ahmed123',
    email: 'ahmed@example.com',
    birthDate: DateTime(1998, 5, 15),
  );
  
  var user2 = UserProfile(
    id: 'U002',
    username: 'guest_user',
  );
  
  user1.displayProfile();
  user2.displayProfile();
}
```

### مثال 3: معالجة استجابة API

```dart
class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? errorMessage;
  final int? errorCode;
  
  ApiResponse.success(this.data)
      : success = true,
        errorMessage = null,
        errorCode = null;
  
  ApiResponse.error({
    required String message,
    int? code,
  })  : success = false,
        data = null,
        errorMessage = message,
        errorCode = code;
  
  void handle({
    required Function(T data) onSuccess,
    required Function(String error) onError,
  }) {
    if (success && data != null) {
      onSuccess(data as T);
    } else {
      onError(errorMessage ?? 'خطأ غير معروف');
    }
  }
}

void main() {
  // استجابة ناجحة
  var response1 = ApiResponse<Map<String, dynamic>>.success({
    'name': 'أحمد',
    'age': 25,
  });
  
  response1.handle(
    onSuccess: (data) => print('البيانات: $data'),
    onError: (error) => print('خطأ: $error'),
  );
  
  // استجابة فاشلة
  var response2 = ApiResponse<Map<String, dynamic>>.error(
    message: 'فشل الاتصال بالخادم',
    code: 500,
  );
  
  response2.handle(
    onSuccess: (data) => print('البيانات: $data'),
    onError: (error) => print('خطأ: $error'),
  );
}
```

## أفضل الممارسات

1. **تجنب استخدام `!` بكثرة**: استخدمه فقط عندما تكون متأكداً 100%
2. **استخدم `?.` للأمان**: أفضل من التحقق اليدوي في كثير من الحالات
3. **القيم الافتراضية مع `??`**: أوضح من الشروط
4. **`required` للمعاملات الإلزامية**: يجعل الكود أكثر وضوحاً
5. **`late` بحذر**: فقط عندما تضمن التهيئة قبل الاستخدام
6. **Type promotion**: اعتمد عليه بدلاً من الـ casting
7. **وثّق nullable parameters**: اشرح متى يمكن أن تكون null

## الأخطاء الشائعة

```dart
// ❌ استخدام ! بدون تحقق
String? name;
// print(name!.length);  // خطر!

// ✅ الطريقة الصحيحة
print(name?.length ?? 0);

// ❌ late بدون تهيئة
late String value;
// print(value);  // خطأ في وقت التشغيل!

// ✅ تأكد من التهيئة
late String value;
value = 'تمت التهيئة';
print(value);

// ❌ نسيان التعامل مع null
void process(String? input) {
  // print(input.length);  // خطأ!
}

// ✅ التعامل الصحيح
void process(String? input) {
  if (input != null) {
    print(input.length);
  }
}
```

---

[⬅️ الموضوع السابق: البرمجة الكائنية - الجزء الثاني](09_oop_part2.md) 
 [العودة للفهرس](README.md) 
 [الموضوع التالي: معالجة الأخطاء ➡️](11_exceptions.md)
