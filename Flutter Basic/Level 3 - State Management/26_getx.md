# 26 - GetX - إدارة شاملة للتطبيق

## 📋 المحتويات

- [المقدمة](#المقدمة)
- [تثبيت GetX](#تثبيت-getx)
- [State Management](#state-management)
- [Route Management](#route-management)
- [Dependency Injection](#dependency-injection)
- [أمثلة عملية](#أمثلة-عملية)

---

## 🎯 المقدمة

GetX مكتبة شاملة توفر إدارة الحالة، التنقل، وإدارة التبعيات بطريقة بسيطة وفعالة.

---

## 📦 تثبيت GetX

أضف في `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  get: ^4.6.6
```

ثم نفذ:

```bash
flutter pub get
```

---

## 🎲 State Management

### 1. Simple State Management

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// 1. إنشاء Controller
class CounterController extends GetxController {
  var count = 0.obs; // .obs تجعل المتغير observable

  void increment() => count++;
  void decrement() => count--;
  void reset() => count.value = 0;
}

// 2. استخدام GetMaterialApp بدلاً من MaterialApp
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'GetX Demo',
      home: const CounterPage(),
    );
  }
}

// 3. استخدام Controller
class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    // إنشاء Controller
    final CounterController controller = Get.put(CounterController());

    return Scaffold(
      appBar: AppBar(title: const Text('GetX Counter')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('العدد:', style: TextStyle(fontSize: 24)),
            // Obx لإعادة البناء التلقائي
            Obx(() => Text(
                  '${controller.count}',
                  style: const TextStyle(
                    fontSize: 72,
                    fontWeight: FontWeight.bold,
                  ),
                )),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'increment',
            onPressed: controller.increment,
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: 'decrement',
            onPressed: controller.decrement,
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}
```

### 2. GetBuilder (بدون .obs)

```dart
class CounterController extends GetxController {
  int count = 0;

  void increment() {
    count++;
    update(); // تحديث يدوي
  }
}

class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GetBuilder<CounterController>(
          init: CounterController(),
          builder: (controller) {
            return Text('${controller.count}');
          },
        ),
      ),
    );
  }
}
```

---

## 🧭 Route Management

التنقل بدون BuildContext:

```dart
// 1. تعريف المسارات
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const HomePage()),
        GetPage(name: '/second', page: () => const SecondPage()),
        GetPage(name: '/details', page: () => const DetailsPage()),
      ],
    );
  }
}

// 2. التنقل
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // الانتقال إلى صفحة
                Get.to(() => const SecondPage());
              },
              child: const Text('Go to Second'),
            ),
            ElevatedButton(
              onPressed: () {
                // الانتقال مع اسم المسار
                Get.toNamed('/second');
              },
              child: const Text('Go to Second (Named)'),
            ),
            ElevatedButton(
              onPressed: () {
                // الانتقال مع تمرير بيانات
                Get.to(() => const DetailsPage(), arguments: {
                  'id': 123,
                  'name': 'منتج رائع',
                });
              },
              child: const Text('Go to Details'),
            ),
          ],
        ),
      ),
    );
  }
}

// 3. استقبال البيانات
class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(title: const Text('Details')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('ID: ${args['id']}'),
            Text('Name: ${args['name']}'),
            ElevatedButton(
              onPressed: () {
                Get.back(); // العودة
              },
              child: const Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}
```

### SnackBar و Dialog بدون Context

```dart
// SnackBar
ElevatedButton(
  onPressed: () {
    Get.snackbar(
      'نجح',
      'تمت العملية بنجاح',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  },
  child: const Text('Show Snackbar'),
),

// Dialog
ElevatedButton(
  onPressed: () {
    Get.defaultDialog(
      title: 'تأكيد',
      middleText: 'هل أنت متأكد؟',
      textConfirm: 'نعم',
      textCancel: 'لا',
      onConfirm: () {
        Get.back();
      },
    );
  },
  child: const Text('Show Dialog'),
),

// BottomSheet
ElevatedButton(
  onPressed: () {
    Get.bottomSheet(
      Container(
        color: Colors.white,
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('مشاركة'),
              onTap: () => Get.back(),
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('حذف'),
              onTap: () => Get.back(),
            ),
          ],
        ),
      ),
    );
  },
  child: const Text('Show BottomSheet'),
),
```

---

## 💉 Dependency Injection

إدارة التبعيات:

```dart
// 1. إنشاء Service
class ApiService extends GetxService {
  Future<String> fetchData() async {
    await Future.delayed(const Duration(seconds: 2));
    return 'Data from API';
  }
}

// 2. تسجيل Service
void main() {
  Get.put(ApiService());
  runApp(const MyApp());
}

// 3. استخدام Service
class DataController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  
  var data = ''.obs;
  var isLoading = false.obs;

  Future<void> loadData() async {
    isLoading.value = true;
    data.value = await _apiService.fetchData();
    isLoading.value = false;
  }
}

// أنواع Dependency Injection
void examples() {
  // Put - يبقى في الذاكرة
  Get.put(CounterController());

  // Lazy Put - يتم إنشاؤه عند الاستخدام
  Get.lazyPut(() => CounterController());

  // Put Async - للعمليات غير المتزامنة
  Get.putAsync(() async {
    await Future.delayed(const Duration(seconds: 2));
    return ApiService();
  });

  // Create - ينشئ نسخة جديدة كل مرة
  Get.create(() => CounterController());

  // Find - للحصول على Controller موجود
  final controller = Get.find<CounterController>();
}
```

---

## 💼 أمثلة عملية

### تطبيق قائمة مهام كامل

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Model
class Task {
  final String id;
  final String title;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    this.isCompleted = false,
  });
}

// Controller
class TodoController extends GetxController {
  var tasks = <Task>[].obs;

  var completedCount = 0.obs;
  var activeCount = 0.obs;

  void addTask(String title) {
    tasks.add(Task(
      id: DateTime.now().toString(),
      title: title,
    ));
    _updateCounts();
  }

  void toggleTask(String id) {
    final index = tasks.indexWhere((task) => task.id == id);
    if (index != -1) {
      tasks[index].isCompleted = !tasks[index].isCompleted;
      tasks.refresh();
      _updateCounts();
    }
  }

  void deleteTask(String id) {
    tasks.removeWhere((task) => task.id == id);
    _updateCounts();
  }

  void clearCompleted() {
    tasks.removeWhere((task) => task.isCompleted);
    _updateCounts();
  }

  void _updateCounts() {
    completedCount.value = tasks.where((t) => t.isCompleted).length;
    activeCount.value = tasks.where((t) => !t.isCompleted).length;
  }
}

// UI
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'GetX Todo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const TodoScreen(),
    );
  }
}

class TodoScreen extends StatelessWidget {
  const TodoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TodoController controller = Get.put(TodoController());
    final TextEditingController textController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('قائمة المهام - GetX')),
      body: Column(
        children: [
          // Stats
          Obx(() => Container(
                padding: const EdgeInsets.all(16),
                color: Colors.blue.shade50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStat('الإجمالي', controller.tasks.length),
                    _buildStat('نشطة', controller.activeCount.value),
                    _buildStat('مكتملة', controller.completedCount.value),
                  ],
                ),
              )),

          // Input
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: textController,
                    decoration: const InputDecoration(
                      hintText: 'أضف مهمة جديدة',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        controller.addTask(value);
                        textController.clear();
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton(
                  onPressed: () {
                    if (textController.text.isNotEmpty) {
                      controller.addTask(textController.text);
                      textController.clear();
                    }
                  },
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ),

          // Tasks List
          Expanded(
            child: Obx(() {
              if (controller.tasks.isEmpty) {
                return const Center(child: Text('لا توجد مهام'));
              }

              return ListView.builder(
                itemCount: controller.tasks.length,
                itemBuilder: (context, index) {
                  final task = controller.tasks[index];
                  return Dismissible(
                    key: Key(task.id),
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    direction: DismissDirection.endToStart,
                    onDismissed: (_) => controller.deleteTask(task.id),
                    child: Obx(() => CheckboxListTile(
                          title: Text(
                            task.title,
                            style: TextStyle(
                              decoration: task.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          value: task.isCompleted,
                          onChanged: (_) => controller.toggleTask(task.id),
                        )),
                  );
                },
              );
            }),
          ),

          // Clear Completed
          Obx(() {
            if (controller.completedCount.value == 0) {
              return const SizedBox.shrink();
            }

            return Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: controller.clearCompleted,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: Text('مسح المكتملة (${controller.completedCount})'),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildStat(String label, int count) {
    return Column(
      children: [
        Text(
          '$count',
          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
        Text(label),
      ],
    );
  }
}
```

### تطبيق مصادقة كامل

```dart
// Auth Controller
class AuthController extends GetxController {
  var isAuthenticated = false.obs;
  var isLoading = false.obs;
  var userName = ''.obs;
  var userEmail = ''.obs;

  Future<void> login(String email, String password) async {
    isLoading.value = true;

    try {
      await Future.delayed(const Duration(seconds: 2));

      if (email.isEmpty || password.isEmpty) {
        Get.snackbar(
          'خطأ',
          'الرجاء إدخال البريد وكلمة المرور',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      userName.value = 'أحمد محمد';
      userEmail.value = email;
      isAuthenticated.value = true;

      Get.offAll(() => const HomeScreen());

      Get.snackbar(
        'نجح',
        'تم تسجيل الدخول بنجاح',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'حدث خطأ في تسجيل الدخول',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void logout() {
    isAuthenticated.value = false;
    userName.value = '';
    userEmail.value = '';
    Get.offAll(() => const LoginScreen());
  }
}

// Login Screen
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.put(AuthController());
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('تسجيل الدخول')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'البريد الإلكتروني',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'كلمة المرور',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            Obx(() => ElevatedButton(
                  onPressed: authController.isLoading.value
                      ? null
                      : () {
                          authController.login(
                            emailController.text,
                            passwordController.text,
                          );
                        },
                  child: authController.isLoading.value
                      ? const CircularProgressIndicator()
                      : const Text('تسجيل الدخول'),
                )),
          ],
        ),
      ),
    );
  }
}

// Home Screen
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('الرئيسية'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: authController.logout,
          ),
        ],
      ),
      body: Center(
        child: Obx(() => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'مرحباً ${authController.userName}',
                  style: const TextStyle(fontSize: 24),
                ),
                Text(authController.userEmail.value),
              ],
            )),
      ),
    );
  }
}

// Main App
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'GetX Auth',
      initialRoute: '/login',
      getPages: [
        GetPage(name: '/login', page: () => const LoginScreen()),
        GetPage(name: '/home', page: () => const HomeScreen()),
      ],
    );
  }
}
```

---

## 📚 المراجع والمصادر

1. **GetX Package**
   - [Get Package](https://pub.dev/packages/get)
   - [GetX Documentation](https://github.com/jonataslaw/getx)

2. **Tutorials**
   - [GetX Quick Start](https://github.com/jonataslaw/getx/blob/master/README.md)

---

## 💡 نصائح

- ✅ GetX سهل ومباشر للمبتدئين
- ✅ `.obs` للمتغيرات التفاعلية
- ✅ `Obx()` أو `GetBuilder()` لإعادة البناء
- ✅ لا يحتاج BuildContext للتنقل والحوارات
- ✅ `Get.put()` و `Get.find()` لإدارة التبعيات

---

[⬅️ السابق: BLoC](25_bloc.md)
[🏠 العودة للفهرس](../README.md)
[التالي: MobX ➡️](27_mobx.md)
