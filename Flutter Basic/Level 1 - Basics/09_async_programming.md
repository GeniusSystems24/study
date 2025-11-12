# 09 - البرمجة التفاعلية (Async Programming)

## 📋 المحتويات

- [المقدمة](#المقدمة)
- [Future](#future)
- [async و await](#async-و-await)
- [معالجة الأخطاء](#معالجة-الأخطاء)
- [Stream](#stream)
- [أمثلة عملية](#أمثلة-عملية)

---

## 🎯 المقدمة

البرمجة التفاعلية (Asynchronous Programming) تسمح بتنفيذ عمليات طويلة دون تجميد التطبيق.

### متى نستخدم Async؟

- 🌐 استدعاءات الشبكة (API calls)
- 💾 قراءة/كتابة الملفات
- 🗄️ عمليات قاعدة البيانات
- ⏱️ عمليات تستغرق وقتاً طويلاً

---

## ⏳ Future

Future يمثل قيمة ستكون متاحة في المستقبل.

### Future الأساسي

```dart
Future<String> fetchUserName() {
  return Future.delayed(
    Duration(seconds: 2),
    () => 'أحمد محمد'
  );
}

void main() {
  print('بدء جلب الاسم...');
  
  fetchUserName().then((name) {
    print('الاسم: $name');
  });
  
  print('استمرار التنفيذ...');
}
```

### then و catchError

```dart
Future<int> divide(int a, int b) {
  return Future.delayed(Duration(seconds: 1), () {
    if (b == 0) {
      throw Exception('لا يمكن القسمة على صفر');
    }
    return a ~/ b;
  });
}

void main() {
  print('حساب: 10 ÷ 2');
  divide(10, 2)
    .then((result) => print('النتيجة: $result'))
    .catchError((error) => print('خطأ: $error'));
  
  print('حساب: 10 ÷ 0');
  divide(10, 0)
    .then((result) => print('النتيجة: $result'))
    .catchError((error) => print('خطأ: $error'));
}
```

### Future.wait - تنفيذ متوازي

```dart
Future<String> fetchUser() {
  return Future.delayed(Duration(seconds: 2), () => 'المستخدم');
}

Future<List<String>> fetchPosts() {
  return Future.delayed(Duration(seconds: 3), () => ['منشور 1', 'منشور 2']);
}

Future<int> fetchNotifications() {
  return Future.delayed(Duration(seconds: 1), () => 5);
}

void main() async {
  print('جلب البيانات...');
  
  var results = await Future.wait([
    fetchUser(),
    fetchPosts(),
    fetchNotifications(),
  ]);
  
  print('المستخدم: ${results[0]}');
  print('المنشورات: ${results[1]}');
  print('الإشعارات: ${results[2]}');
}
```

---

## 🔄 async و await

### الاستخدام الأساسي

```dart
Future<String> login(String email, String password) async {
  print('جاري تسجيل الدخول...');
  
  // محاكاة استدعاء API
  await Future.delayed(Duration(seconds: 2));
  
  if (email == 'test@example.com' && password == 'password123') {
    return 'تم تسجيل الدخول بنجاح!';
  } else {
    throw Exception('بيانات الدخول غير صحيحة');
  }
}

void main() async {
  try {
    var message = await login('test@example.com', 'password123');
    print(message);
  } catch (e) {
    print('خطأ: $e');
  }
}
```

### تسلسل العمليات

```dart
Future<Map<String, dynamic>> getUserProfile(String userId) async {
  print('1. جلب بيانات المستخدم...');
  await Future.delayed(Duration(seconds: 1));
  
  return {
    'id': userId,
    'name': 'أحمد',
    'email': 'ahmed@example.com'
  };
}

Future<List<String>> getUserPosts(String userId) async {
  print('2. جلب منشورات المستخدم...');
  await Future.delayed(Duration(seconds: 1));
  
  return ['منشور 1', 'منشور 2', 'منشور 3'];
}

Future<List<String>> getUserFriends(String userId) async {
  print('3. جلب أصدقاء المستخدم...');
  await Future.delayed(Duration(seconds: 1));
  
  return ['فاطمة', 'علي', 'سارة'];
}

void main() async {
  var userId = 'user123';
  
  // تنفيذ تسلسلي
  print('--- تنفيذ تسلسلي ---');
  var profile = await getUserProfile(userId);
  var posts = await getUserPosts(userId);
  var friends = await getUserFriends(userId);
  
  print('الملف الشخصي: $profile');
  print('المنشورات: $posts');
  print('الأصدقاء: $friends');
  
  // تنفيذ متوازي (أسرع)
  print('\n--- تنفيذ متوازي ---');
  var results = await Future.wait([
    getUserProfile(userId),
    getUserPosts(userId),
    getUserFriends(userId),
  ]);
  
  print('الملف الشخصي: ${results[0]}');
  print('المنشورات: ${results[1]}');
  print('الأصدقاء: ${results[2]}');
}
```

---

## ⚠️ معالجة الأخطاء

### try-catch مع async

```dart
Future<double> calculateDiscount(double price, String coupon) async {
  await Future.delayed(Duration(seconds: 1));
  
  Map<String, double> coupons = {
    'SAVE10': 0.10,
    'SAVE20': 0.20,
    'SAVE30': 0.30,
  };
  
  if (!coupons.containsKey(coupon)) {
    throw Exception('كود الخصم غير صحيح');
  }
  
  return price * (1 - coupons[coupon]!);
}

void main() async {
  try {
    var finalPrice = await calculateDiscount(100, 'SAVE20');
    print('السعر بعد الخصم: $finalPrice ريال');
  } catch (e) {
    print('خطأ: $e');
  }
  
  try {
    var finalPrice = await calculateDiscount(100, 'INVALID');
    print('السعر بعد الخصم: $finalPrice ريال');
  } catch (e) {
    print('خطأ: $e');
  }
}
```

### Future.timeout

```dart
Future<String> slowOperation() async {
  await Future.delayed(Duration(seconds: 5));
  return 'اكتملت العملية';
}

void main() async {
  try {
    var result = await slowOperation().timeout(
      Duration(seconds: 3),
      onTimeout: () => throw TimeoutException('انتهت مهلة الانتظار'),
    );
    print(result);
  } on TimeoutException catch (e) {
    print('خطأ: $e');
  }
}

class TimeoutException implements Exception {
  final String message;
  TimeoutException(this.message);
  
  @override
  String toString() => message;
}
```

---

## 🌊 Stream

Stream يمثل تدفقاً من البيانات عبر الزمن.

### Stream الأساسي

```dart
Stream<int> countStream(int max) async* {
  for (int i = 1; i <= max; i++) {
    await Future.delayed(Duration(seconds: 1));
    yield i;  // إرسال قيمة
  }
}

void main() async {
  print('بدء العد...');
  
  await for (int count in countStream(5)) {
    print('العدد: $count');
  }
  
  print('انتهى العد!');
}
```

### Stream.fromIterable

```dart
void main() async {
  var numbers = Stream.fromIterable([1, 2, 3, 4, 5]);
  
  await for (var number in numbers) {
    print(number);
  }
}
```

### Stream.periodic

```dart
void main() async {
  var stream = Stream.periodic(
    Duration(seconds: 1),
    (count) => count + 1
  ).take(5);
  
  await for (var value in stream) {
    print('القيمة: $value');
  }
}
```

### معالجة Stream

```dart
void main() async {
  var numbers = Stream.fromIterable([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
  
  // where - تصفية
  var evens = numbers.where((n) => n % 2 == 0);
  
  // map - تحويل
  var doubled = evens.map((n) => n * 2);
  
  print('الأعداد الزوجية المضاعفة:');
  await for (var value in doubled) {
    print(value);
  }
}
```

### StreamController

```dart
import 'dart:async';

void main() async {
  var controller = StreamController<String>();
  
  // الاستماع للـ Stream
  controller.stream.listen(
    (data) => print('تم استلام: $data'),
    onDone: () => print('انتهى Stream'),
    onError: (error) => print('خطأ: $error'),
  );
  
  // إرسال بيانات
  controller.add('مرحباً');
  await Future.delayed(Duration(seconds: 1));
  
  controller.add('كيف حالك؟');
  await Future.delayed(Duration(seconds: 1));
  
  controller.add('وداعاً');
  await Future.delayed(Duration(seconds: 1));
  
  // إنهاء Stream
  await controller.close();
}
```

---

## 💼 أمثلة عملية

### مثال 1: جلب البيانات من API

```dart
class User {
  final int id;
  final String name;
  final String email;
  
  User(this.id, this.name, this.email);
  
  @override
  String toString() => 'User(id: $id, name: $name, email: $email)';
}

class ApiService {
  Future<List<User>> fetchUsers() async {
    print('جلب المستخدمين...');
    
    // محاكاة استدعاء API
    await Future.delayed(Duration(seconds: 2));
    
    // محاكاة استجابة API
    return [
      User(1, 'أحمد', 'ahmed@example.com'),
      User(2, 'فاطمة', 'fatima@example.com'),
      User(3, 'علي', 'ali@example.com'),
    ];
  }
  
  Future<User> fetchUserById(int id) async {
    print('جلب المستخدم $id...');
    
    await Future.delayed(Duration(seconds: 1));
    
    var users = await fetchUsers();
    return users.firstWhere(
      (user) => user.id == id,
      orElse: () => throw Exception('المستخدم غير موجود'),
    );
  }
}

void main() async {
  var api = ApiService();
  
  try {
    // جلب جميع المستخدمين
    var users = await api.fetchUsers();
    print('المستخدمون:');
    users.forEach(print);
    
    // جلب مستخدم محدد
    print('\nجلب مستخدم محدد:');
    var user = await api.fetchUserById(2);
    print(user);
    
  } catch (e) {
    print('خطأ: $e');
  }
}
```

### مثال 2: نظام الإشعارات

```dart
import 'dart:async';

class Notification {
  final String title;
  final String message;
  final DateTime timestamp;
  
  Notification(this.title, this.message) : timestamp = DateTime.now();
  
  @override
  String toString() => '[$timestamp] $title: $message';
}

class NotificationService {
  final _controller = StreamController<Notification>.broadcast();
  
  Stream<Notification> get notifications => _controller.stream;
  
  void sendNotification(String title, String message) {
    _controller.add(Notification(title, message));
  }
  
  void dispose() {
    _controller.close();
  }
}

void main() async {
  var service = NotificationService();
  
  // المستمع الأول
  service.notifications.listen((notification) {
    print('📱 المستمع 1: $notification');
  });
  
  // المستمع الثاني
  service.notifications.listen((notification) {
    print('💻 المستمع 2: $notification');
  });
  
  // إرسال إشعارات
  service.sendNotification('رسالة جديدة', 'لديك رسالة من أحمد');
  await Future.delayed(Duration(seconds: 1));
  
  service.sendNotification('تحديث', 'تم تحديث التطبيق');
  await Future.delayed(Duration(seconds: 1));
  
  service.sendNotification('تذكير', 'لديك اجتماع في الساعة 3');
  await Future.delayed(Duration(seconds: 1));
  
  service.dispose();
}
```

### مثال 3: تحميل الملفات

```dart
class DownloadProgress {
  final String filename;
  final int bytesDownloaded;
  final int totalBytes;
  
  DownloadProgress(this.filename, this.bytesDownloaded, this.totalBytes);
  
  double get percentage => (bytesDownloaded / totalBytes) * 100;
  
  @override
  String toString() => 
    '$filename: ${percentage.toStringAsFixed(1)}% (${bytesDownloaded}/${totalBytes} bytes)';
}

class FileDownloader {
  Stream<DownloadProgress> downloadFile(String filename, int totalBytes) async* {
    print('بدء تحميل: $filename');
    
    for (int downloaded = 0; downloaded <= totalBytes; downloaded += totalBytes ~/ 10) {
      await Future.delayed(Duration(milliseconds: 500));
      yield DownloadProgress(filename, downloaded, totalBytes);
    }
    
    print('✅ اكتمل تحميل: $filename');
  }
}

void main() async {
  var downloader = FileDownloader();
  
  print('تحميل ملف...\n');
  
  await for (var progress in downloader.downloadFile('document.pdf', 10000)) {
    var bar = '█' * (progress.percentage ~/ 10);
    var empty = '░' * (10 - (progress.percentage ~/ 10));
    print('[${bar}${empty}] ${progress.percentage.toStringAsFixed(1)}%');
  }
}
```

---

## 📚 للتعمق أكثر

لمزيد من التفاصيل، راجع:

- [البرمجة التفاعلية في Dart](../Dart%20basic/12_async.md)
- [معالجة الأخطاء](08_error_handling.md)

---

## 📖 المراجع والمصادر

### مصادر Dart الرسمية

1. **Asynchronous Programming**
   - [Asynchrony Support](https://dart.dev/guides/language/language-tour#asynchrony-support)
   - [Async and Await](https://dart.dev/codelabs/async-await)
   - [Futures](https://dart.dev/guides/libraries/library-tour#future)
   - [Streams](https://dart.dev/guides/libraries/library-tour#stream)

2. **Future API**
   - [Future Class](https://api.dart.dev/stable/dart-async/Future-class.html)
   - [Future.wait](https://api.dart.dev/stable/dart-async/Future/wait.html)
   - [Future.timeout](https://api.dart.dev/stable/dart-async/Future/timeout.html)

3. **Stream API**
   - [Stream Class](https://api.dart.dev/stable/dart-async/Stream-class.html)
   - [StreamController](https://api.dart.dev/stable/dart-async/StreamController-class.html)
   - [Stream Methods](https://api.dart.dev/stable/dart-async/Stream-class.html#instance-methods)

### Codelabs والتدريب

4. **Dart Codelabs**
   - [Asynchronous Programming Codelab](https://dart.dev/codelabs/async-await)
   - [Streams Tutorial](https://dart.dev/tutorials/language/streams)

### مصادر داخل المستودع

5. **خطة تعلم Dart الشاملة**
   - [فهرس Dart الكامل](../Dart%20basic/README.md)
   - [البرمجة التفاعلية](../Dart%20basic/12_async.md)

### مراجع API

6. **dart:async Library**
   - [dart:async Overview](https://api.dart.dev/stable/dart-async/dart-async-library.html)
   - [Completer](https://api.dart.dev/stable/dart-async/Completer-class.html)
   - [Zone](https://api.dart.dev/stable/dart-async/Zone-class.html)

### مصادر إضافية

7. **Community Resources**
   - [Dart Async on Stack Overflow](https://stackoverflow.com/questions/tagged/dart+async)

8. **Video Tutorials**
   - [Dart Futures and Streams](https://www.youtube.com/dartlang)

9. **Articles**
   - [Understanding Dart Futures](https://dart.dev/guides/libraries/library-tour#handling-errors)

---

## 💡 نصائح

- ✅ استخدم `async`/`await` بدلاً من `then` للوضوح
- ✅ استخدم `Future.wait` للعمليات المتوازية
- ✅ لا تنسَ معالجة الأخطاء في async functions
- ✅ استخدم `Stream` للبيانات المتدفقة
- ✅ استخدم `timeout` لتجنب الانتظار اللانهائي
- ✅ أغلق `StreamController` عند الانتهاء
- ✅ استخدم `broadcast` للـ Streams متعددة المستمعين
- ✅ مارس على [DartPad](https://dartpad.dev/)

---

[⬅️ السابق: معالجة الأخطاء](08_error_handling.md)
[🏠 العودة للفهرس](../README.md)
[التالي: بنية Flutter ➡️](10_flutter_structure.md)
