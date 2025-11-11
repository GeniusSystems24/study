# 12. البرمجة غير المتزامنة (Asynchronous Programming)

## لماذا البرمجة غير المتزامنة؟

العمليات التي تستغرق وقتاً (مثل: قراءة ملفات، طلبات الشبكة، استعلامات قواعد البيانات) لا يجب أن توقف تنفيذ البرنامج.

## Future

Future يمثل قيمة قد تكون متاحة في المستقبل.

### Future الأساسي

```dart
// Future يعيد قيمة بعد وقت
Future<String> fetchUserData() {
  return Future.delayed(
    Duration(seconds: 2),
    () => 'بيانات المستخدم',
  );
}

void main() {
  print('بدء البرنامج');
  
  fetchUserData().then((data) {
    print('البيانات: $data');
  });
  
  print('نهاية main (لكن Future لم ينتهِ بعد)');
}
```

### معالجة الأخطاء مع then

```dart
Future<int> divideAsync(int a, int b) {
  return Future.delayed(Duration(seconds: 1), () {
    if (b == 0) {
      throw Exception('لا يمكن القسمة على صفر');
    }
    return a ~/ b;
  });
}

void main() {
  divideAsync(10, 2)
      .then((result) => print('النتيجة: $result'))
      .catchError((error) => print('خطأ: $error'))
      .whenComplete(() => print('انتهت العملية'));
}
```

## async و await

### الاستخدام الأساسي

```dart
Future<String> getUserName() async {
  // محاكاة استدعاء API
  await Future.delayed(Duration(seconds: 1));
  return 'أحمد';
}

Future<int> getUserAge() async {
  await Future.delayed(Duration(seconds: 1));
  return 25;
}

Future<void> displayUserInfo() async {
  print('جلب بيانات المستخدم...');
  
  String name = await getUserName();
  int age = await getUserAge();
  
  print('الاسم: $name');
  print('العمر: $age');
}

void main() async {
  await displayUserInfo();
  print('تم');
}
```

### معالجة الأخطاء مع async/await

```dart
Future<int> fetchData(bool shouldFail) async {
  await Future.delayed(Duration(seconds: 1));
  
  if (shouldFail) {
    throw Exception('فشل جلب البيانات');
  }
  
  return 42;
}

Future<void> processData() async {
  try {
    int data = await fetchData(true);
    print('البيانات: $data');
  } catch (e) {
    print('خطأ: $e');
  } finally {
    print('تنظيف الموارد');
  }
}

void main() async {
  await processData();
}
```

### Future المتوازية

```dart
Future<String> fetchProduct(int id) async {
  await Future.delayed(Duration(seconds: 1));
  return 'منتج $id';
}

// تنفيذ متتابع (بطيء)
Future<void> fetchSequentially() async {
  print('تنفيذ متتابع...');
  var start = DateTime.now();
  
  String product1 = await fetchProduct(1);
  String product2 = await fetchProduct(2);
  String product3 = await fetchProduct(3);
  
  var duration = DateTime.now().difference(start);
  print('$product1, $product2, $product3');
  print('الوقت: ${duration.inSeconds} ثانية');
}

// تنفيذ متوازي (أسرع)
Future<void> fetchInParallel() async {
  print('\nتنفيذ متوازي...');
  var start = DateTime.now();
  
  // تبدأ جميعها في نفس الوقت
  var results = await Future.wait([
    fetchProduct(1),
    fetchProduct(2),
    fetchProduct(3),
  ]);
  
  var duration = DateTime.now().difference(start);
  print(results.join(', '));
  print('الوقت: ${duration.inSeconds} ثانية');
}

void main() async {
  await fetchSequentially();  // ~3 ثواني
  await fetchInParallel();    // ~1 ثانية
}
```

### Future مع timeout

```dart
Future<String> slowOperation() async {
  await Future.delayed(Duration(seconds: 5));
  return 'اكتمل';
}

Future<void> operationWithTimeout() async {
  try {
    String result = await slowOperation().timeout(
      Duration(seconds: 2),
      onTimeout: () => 'انتهى الوقت!',
    );
    print(result);
  } catch (e) {
    print('خطأ: $e');
  }
}

void main() async {
  await operationWithTimeout();
}
```

## Stream

Stream يمثل سلسلة من القيم المتدفقة عبر الزمن.

### إنشاء Stream

```dart
// Stream بسيط
Stream<int> countStream(int max) async* {
  for (int i = 1; i <= max; i++) {
    await Future.delayed(Duration(seconds: 1));
    yield i;  // إرسال قيمة
  }
}

void main() async {
  print('بدء العد...');
  
  await for (int number in countStream(5)) {
    print('العدد: $number');
  }
  
  print('انتهى');
}
```

### Stream Controller

```dart
import 'dart:async';

class ChatRoom {
  final StreamController<String> _messageController = 
      StreamController<String>.broadcast();
  
  Stream<String> get messages => _messageController.stream;
  
  void sendMessage(String message) {
    _messageController.add(message);
  }
  
  void close() {
    _messageController.close();
  }
}

void main() async {
  var chatRoom = ChatRoom();
  
  // مستمع 1
  chatRoom.messages.listen((message) {
    print('المستخدم 1 استلم: $message');
  });
  
  // مستمع 2
  chatRoom.messages.listen((message) {
    print('المستخدم 2 استلم: $message');
  });
  
  chatRoom.sendMessage('مرحباً!');
  chatRoom.sendMessage('كيف حالكم؟');
  
  await Future.delayed(Duration(seconds: 1));
  chatRoom.close();
}
```

### Stream Transformations

```dart
Stream<int> numberStream() async* {
  for (int i = 1; i <= 10; i++) {
    await Future.delayed(Duration(milliseconds: 500));
    yield i;
  }
}

void main() async {
  // map - تحويل القيم
  await numberStream()
      .map((n) => n * 2)
      .listen((n) => print('مضاعف: $n'))
      .asFuture();
  
  // where - تصفية
  print('\nالأرقام الزوجية فقط:');
  await numberStream()
      .where((n) => n % 2 == 0)
      .listen((n) => print(n))
      .asFuture();
  
  // take - أخذ عدد محدد
  print('\nأول 3 أرقام:');
  await numberStream()
      .take(3)
      .listen((n) => print(n))
      .asFuture();
}
```

### معالجة أخطاء Stream

```dart
Stream<int> dataStream() async* {
  yield 1;
  yield 2;
  throw Exception('خطأ في البيانات!');
  yield 3;  // لن يُنفذ
}

void main() async {
  dataStream().listen(
    (data) => print('البيانات: $data'),
    onError: (error) => print('خطأ: $error'),
    onDone: () => print('انتهى Stream'),
  );
  
  await Future.delayed(Duration(seconds: 2));
}
```

## أمثلة عملية شاملة

### مثال 1: جلب بيانات من API

```dart
class User {
  final int id;
  final String name;
  final String email;
  
  User({required this.id, required this.name, required this.email});
  
  @override
  String toString() => 'User($id): $name - $email';
}

class ApiService {
  // محاكاة API call
  Future<User> fetchUser(int id) async {
    print('جاري جلب المستخدم $id...');
    await Future.delayed(Duration(seconds: 2));
    
    // محاكاة بيانات
    return User(
      id: id,
      name: 'مستخدم $id',
      email: 'user$id@example.com',
    );
  }
  
  Future<List<String>> fetchUserPosts(int userId) async {
    print('جاري جلب منشورات المستخدم $userId...');
    await Future.delayed(Duration(seconds: 1));
    
    return [
      'منشور 1 للمستخدم $userId',
      'منشور 2 للمستخدم $userId',
      'منشور 3 للمستخدم $userId',
    ];
  }
  
  Future<Map<String, dynamic>> fetchUserProfile(int userId) async {
    try {
      // جلب المستخدم والمنشورات بالتوازي
      var results = await Future.wait([
        fetchUser(userId),
        fetchUserPosts(userId),
      ]);
      
      User user = results[0] as User;
      List<String> posts = results[1] as List<String>;
      
      return {
        'user': user,
        'posts': posts,
        'timestamp': DateTime.now(),
      };
    } catch (e) {
      throw Exception('فشل جلب الملف الشخصي: $e');
    }
  }
}

void main() async {
  var api = ApiService();
  
  try {
    var profile = await api.fetchUserProfile(1);
    
    print('\n=== الملف الشخصي ===');
    print('المستخدم: ${profile['user']}');
    print('\nالمنشورات:');
    (profile['posts'] as List).forEach(print);
    print('\nالوقت: ${profile['timestamp']}');
  } catch (e) {
    print('خطأ: $e');
  }
}
```

### مثال 2: نظام إشعارات مع Stream

```dart
import 'dart:async';

enum NotificationType { info, warning, error }

class Notification {
  final String message;
  final NotificationType type;
  final DateTime timestamp;
  
  Notification({
    required this.message,
    required this.type,
  }) : timestamp = DateTime.now();
  
  String get icon {
    switch (type) {
      case NotificationType.info:
        return 'ℹ️';
      case NotificationType.warning:
        return '⚠️';
      case NotificationType.error:
        return '❌';
    }
  }
  
  @override
  String toString() =>
      '$icon [${timestamp.toString().substring(11, 19)}] $message';
}

class NotificationService {
  final StreamController<Notification> _controller =
      StreamController<Notification>.broadcast();
  
  Stream<Notification> get notifications => _controller.stream;
  
  Stream<Notification> get errors =>
      _controller.stream.where((n) => n.type == NotificationType.error);
  
  Stream<Notification> get warnings =>
      _controller.stream.where((n) => n.type == NotificationType.warning);
  
  void sendInfo(String message) {
    _controller.add(Notification(
      message: message,
      type: NotificationType.info,
    ));
  }
  
  void sendWarning(String message) {
    _controller.add(Notification(
      message: message,
      type: NotificationType.warning,
    ));
  }
  
  void sendError(String message) {
    _controller.add(Notification(
      message: message,
      type: NotificationType.error,
    ));
  }
  
  void dispose() {
    _controller.close();
  }
}

void main() async {
  var notificationService = NotificationService();
  
  // مستمع لكل الإشعارات
  notificationService.notifications.listen((notification) {
    print('الكل: $notification');
  });
  
  // مستمع للأخطاء فقط
  notificationService.errors.listen((notification) {
    print('خطأ فقط: $notification');
  });
  
  // إرسال إشعارات
  notificationService.sendInfo('بدأ التطبيق');
  await Future.delayed(Duration(seconds: 1));
  
  notificationService.sendWarning('ذاكرة منخفضة');
  await Future.delayed(Duration(seconds: 1));
  
  notificationService.sendError('فشل الاتصال بالخادم');
  await Future.delayed(Duration(seconds: 1));
  
  notificationService.sendInfo('تم الاتصال بالخادم');
  
  await Future.delayed(Duration(seconds: 1));
  notificationService.dispose();
}
```

### مثال 3: تحميل ملفات مع تتبع التقدم

```dart
import 'dart:async';

class DownloadProgress {
  final int totalBytes;
  final int downloadedBytes;
  
  DownloadProgress(this.totalBytes, this.downloadedBytes);
  
  double get percentage => 
      (downloadedBytes / totalBytes * 100).clamp(0, 100);
  
  bool get isComplete => downloadedBytes >= totalBytes;
  
  @override
  String toString() =>
      'تقدم: ${downloadedBytes}/${totalBytes} (${percentage.toStringAsFixed(1)}%)';
}

class FileDownloader {
  Stream<DownloadProgress> downloadFile(String url, int fileSize) async* {
    int downloaded = 0;
    int chunkSize = fileSize ~/ 10;  // 10 أجزاء
    
    print('بدء تحميل: $url');
    print('الحجم: $fileSize bytes\n');
    
    while (downloaded < fileSize) {
      await Future.delayed(Duration(milliseconds: 500));
      
      downloaded += chunkSize;
      if (downloaded > fileSize) downloaded = fileSize;
      
      yield DownloadProgress(fileSize, downloaded);
    }
  }
  
  Future<bool> downloadMultipleFiles(List<String> urls) async {
    int completed = 0;
    
    for (var url in urls) {
      print('\n=== تحميل الملف ${completed + 1}/${urls.length} ===');
      
      await for (var progress in downloadFile(url, 1000000)) {
        // عرض شريط التقدم
        int bars = (progress.percentage / 10).round();
        String progressBar = '█' * bars + '░' * (10 - bars);
        print('\r$progressBar ${progress.percentage.toStringAsFixed(0)}%');
        
        if (progress.isComplete) {
          print('\n✓ اكتمل التحميل: $url');
          completed++;
        }
      }
    }
    
    return completed == urls.length;
  }
}

void main() async {
  var downloader = FileDownloader();
  
  var urls = [
    'file1.zip',
    'file2.pdf',
    'file3.mp4',
  ];
  
  bool success = await downloader.downloadMultipleFiles(urls);
  
  print('\n=== النتيجة ===');
  print(success ? '✓ تم تحميل جميع الملفات بنجاح' : '✗ فشل التحميل');
}
```

### مثال 4: نظام طلبات متقدم

```dart
import 'dart:async';

class Order {
  final String id;
  final String product;
  final int quantity;
  OrderStatus status;
  
  Order({
    required this.id,
    required this.product,
    required this.quantity,
    this.status = OrderStatus.pending,
  });
  
  @override
  String toString() => 'طلب $id: $product (×$quantity) - $status';
}

enum OrderStatus { pending, processing, shipped, delivered, cancelled }

class OrderService {
  final StreamController<Order> _orderUpdates =
      StreamController<Order>.broadcast();
  
  Stream<Order> get orderUpdates => _orderUpdates.stream;
  
  Future<void> processOrder(Order order) async {
    print('\n📦 بدء معالجة ${order.id}');
    
    // حالة: قيد المعالجة
    order.status = OrderStatus.processing;
    _orderUpdates.add(order);
    await Future.delayed(Duration(seconds: 2));
    
    // حالة: تم الشحن
    order.status = OrderStatus.shipped;
    _orderUpdates.add(order);
    await Future.delayed(Duration(seconds: 2));
    
    // حالة: تم التوصيل
    order.status = OrderStatus.delivered;
    _orderUpdates.add(order);
    
    print('✓ اكتمل ${order.id}');
  }
  
  Future<void> processMultipleOrders(List<Order> orders) async {
    // معالجة جميع الطلبات بالتوازي
    await Future.wait(
      orders.map((order) => processOrder(order))
    );
  }
  
  void dispose() {
    _orderUpdates.close();
  }
}

void main() async {
  var orderService = OrderService();
  
  // الاستماع لتحديثات الطلبات
  orderService.orderUpdates.listen((order) {
    String statusEmoji = {
      OrderStatus.pending: '⏳',
      OrderStatus.processing: '⚙️',
      OrderStatus.shipped: '🚚',
      OrderStatus.delivered: '✅',
      OrderStatus.cancelled: '❌',
    }[order.status]!;
    
    print('$statusEmoji تحديث: $order');
  });
  
  // إنشاء طلبات
  var orders = [
    Order(id: 'ORD-001', product: 'كتاب', quantity: 2),
    Order(id: 'ORD-002', product: 'لابتوب', quantity: 1),
    Order(id: 'ORD-003', product: 'سماعات', quantity: 3),
  ];
  
  print('=== بدء معالجة ${orders.length} طلبات ===');
  await orderService.processMultipleOrders(orders);
  
  print('\n=== اكتملت جميع الطلبات ===');
  orderService.dispose();
}
```

## أفضل الممارسات

1. **استخدم async/await**: أوضح من then/catchError
2. **Future.wait للتوازي**: عندما لا تعتمد العمليات على بعضها
3. **أغلق StreamController**: لتجنب تسرب الذاكرة
4. **استخدم timeout**: للعمليات التي قد تستغرق وقتاً طويلاً
5. **عالج الأخطاء**: دائماً استخدم try-catch مع async
6. **تجنب async في الحلقات**: قد يسبب مشاكل في الأداء
7. **broadcast للـ Streams**: عندما تحتاج مستمعين متعددين

---

[⬅️ الموضوع السابق: معالجة الأخطاء](11_exceptions.md) 
 [العودة للفهرس](README.md) 
 [الموضوع التالي: Generics ➡️](13_generics.md)
