# 36 - الإشعارات - Local & Push Notifications

## 📋 المحتويات

- [المقدمة](#المقدمة)
- [الإشعارات المحلية](#الإشعارات-المحلية)
- [إشعارات Firebase](#إشعارات-firebase)
- [أمثلة عملية](#أمثلة-عملية)

---

## 🎯 المقدمة

الإشعارات وسيلة مهمة للتواصل مع المستخدمين وإبقائهم على اطلاع.

**أنواع الإشعارات:**
- **Local Notifications**: من التطبيق نفسه
- **Push Notifications**: من الخادم عبر Firebase

---

## 🔔 الإشعارات المحلية

### التثبيت

```yaml
dependencies:
  flutter_local_notifications: ^16.2.0
  timezone: ^0.9.2
```

---

### الإعداد الأولي

```dart
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    // Initialize timezone
    tz.initializeTimeZones();

    // Android settings
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS settings
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Request permissions (iOS)
    await _notifications
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  static void _onNotificationTapped(NotificationResponse response) {
    print('Notification tapped: ${response.payload}');
    // Handle navigation based on payload
  }
}
```

---

### إرسال إشعار فوري

```dart
class NotificationService {
  // ... الكود السابق

  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      channelDescription: 'channel_description',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      id,
      title,
      body,
      details,
      payload: payload,
    );
  }
}
```

---

### إشعار مجدول

```dart
class NotificationService {
  // ... الكود السابق

  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? payload,
  }) async {
    await _notifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'scheduled_channel',
          'Scheduled Notifications',
          channelDescription: 'Scheduled notification channel',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
  }

  // Daily notification
  static Future<void> scheduleDailyNotification({
    required int id,
    required String title,
    required String body,
    required Time time,
  }) async {
    await _notifications.zonedSchedule(
      id,
      title,
      body,
      _nextInstanceOfTime(time),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_channel',
          'Daily Notifications',
          channelDescription: 'Daily notification channel',
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static tz.TZDateTime _nextInstanceOfTime(Time time) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
      time.second,
    );
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  // Cancel notification
  static Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  // Cancel all
  static Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }
}
```

---

### مثال: شاشة الإشعارات

```dart
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    NotificationService.initialize();
  }

  void _showImmediateNotification() {
    NotificationService.showNotification(
      id: 0,
      title: 'إشعار فوري',
      body: 'هذا إشعار يظهر فوراً',
      payload: 'immediate',
    );
  }

  void _scheduleNotification() {
    final scheduledTime = DateTime.now().add(const Duration(seconds: 10));
    NotificationService.scheduleNotification(
      id: 1,
      title: 'إشعار مجدول',
      body: 'هذا الإشعار سيظهر بعد 10 ثواني',
      scheduledTime: scheduledTime,
      payload: 'scheduled',
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم جدولة الإشعار لـ 10 ثواني')),
    );
  }

  void _scheduleDailyNotification() {
    NotificationService.scheduleDailyNotification(
      id: 2,
      title: 'تذكير يومي',
      body: 'لا تنسَ مراجعة مهامك اليومية',
      time: const Time(9, 0, 0), // 9:00 AM
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم جدولة إشعار يومي الساعة 9 صباحاً')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الإشعارات المحلية')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ElevatedButton(
            onPressed: _showImmediateNotification,
            child: const Text('إشعار فوري'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _scheduleNotification,
            child: const Text('إشعار بعد 10 ثواني'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _scheduleDailyNotification,
            child: const Text('إشعار يومي (9 صباحاً)'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => NotificationService.cancelAllNotifications(),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('إلغاء جميع الإشعارات'),
          ),
        ],
      ),
    );
  }
}
```

---

## 🔥 إشعارات Firebase

### التثبيت

```yaml
dependencies:
  firebase_core: ^2.24.2
  firebase_messaging: ^14.7.9
```

---

### الإعداد

```dart
import 'package:firebase_messaging/firebase_messaging.dart';

// Background message handler
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Background message: ${message.notification?.title}');
}

class FCMService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static Future<void> initialize() async {
    // Request permission (iOS)
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    }

    // Get FCM token
    String? token = await _messaging.getToken();
    print('FCM Token: $token');

    // Listen to token refresh
    _messaging.onTokenRefresh.listen((newToken) {
      print('New FCM Token: $newToken');
      // Send to your server
    });

    // Setup background handler
    FirebaseMessaging.onBackgroundMessage(
      _firebaseMessagingBackgroundHandler,
    );

    // Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Foreground message: ${message.notification?.title}');

      if (message.notification != null) {
        NotificationService.showNotification(
          id: message.hashCode,
          title: message.notification!.title ?? '',
          body: message.notification!.body ?? '',
          payload: message.data.toString(),
        );
      }
    });

    // Message opened app
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Message opened app: ${message.notification?.title}');
      // Handle navigation
    });

    // Check if app opened from notification
    RemoteMessage? initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      print('App opened from notification');
      // Handle navigation
    }
  }

  static Future<void> subscribeToTopic(String topic) async {
    await _messaging.subscribeToTopic(topic);
  }

  static Future<void> unsubscribeFromTopic(String topic) async {
    await _messaging.unsubscribeFromTopic(topic);
  }
}
```

---

### في main.dart

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationService.initialize();
  await FCMService.initialize();
  runApp(const MyApp());
}
```

---

## 💼 أمثلة عملية

### تطبيق تذكير المهام

```dart
class Task {
  final int id;
  final String title;
  final String description;
  final DateTime dueDate;
  bool notificationScheduled;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    this.notificationScheduled = false,
  });
}

class TaskReminderScreen extends StatefulWidget {
  const TaskReminderScreen({super.key});

  @override
  State<TaskReminderScreen> createState() => _TaskReminderScreenState();
}

class _TaskReminderScreenState extends State<TaskReminderScreen> {
  final List<Task> _tasks = [];

  void _addTask() async {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    DateTime selectedDate = DateTime.now().add(const Duration(hours: 1));

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('مهمة جديدة'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'العنوان'),
            ),
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: 'الوصف'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (picked != null) {
                  final TimeOfDay? time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(selectedDate),
                  );
                  if (time != null) {
                    selectedDate = DateTime(
                      picked.year,
                      picked.month,
                      picked.day,
                      time.hour,
                      time.minute,
                    );
                  }
                }
              },
              child: const Text('اختر التاريخ والوقت'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty) {
                final task = Task(
                  id: DateTime.now().millisecondsSinceEpoch,
                  title: titleController.text,
                  description: descController.text,
                  dueDate: selectedDate,
                );

                // Schedule notification
                NotificationService.scheduleNotification(
                  id: task.id,
                  title: 'تذكير: ${task.title}',
                  body: task.description,
                  scheduledTime: task.dueDate,
                );

                setState(() {
                  task.notificationScheduled = true;
                  _tasks.add(task);
                });

                Navigator.pop(context);
              }
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }

  void _deleteTask(Task task) {
    NotificationService.cancelNotification(task.id);
    setState(() => _tasks.remove(task));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تذكير المهام')),
      body: _tasks.isEmpty
          ? const Center(child: Text('لا توجد مهام'))
          : ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(task.title),
                    subtitle: Text(
                      '${task.description}\n${task.dueDate.toString().substring(0, 16)}',
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteTask(task),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

---

## 📚 المراجع والمصادر

1. **Packages**
   - [flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications)
   - [firebase_messaging](https://pub.dev/packages/firebase_messaging)
   - [timezone](https://pub.dev/packages/timezone)

2. **Documentation**
   - [Flutter Local Notifications](https://pub.dev/documentation/flutter_local_notifications/latest/)
   - [Firebase Cloud Messaging](https://firebase.google.com/docs/cloud-messaging)

---

## 💡 نصائح

- ✅ اطلب الأذونات قبل إرسال الإشعارات
- ✅ استخدم channels مختلفة لأنواع الإشعارات
- ✅ اختبر الإشعارات على Android و iOS
- ✅ عالج حالات فتح التطبيق من الإشعار
- ✅ لا ترسل إشعارات كثيرة للمستخدم
- ✅ اجعل الإشعارات واضحة ومفيدة

---

[⬅️ السابق: الخرائط والموقع](35_maps_location.md)
[🏠 العودة للفهرس](../README.md)
[التالي: التدويل ➡️](37_internationalization.md)
