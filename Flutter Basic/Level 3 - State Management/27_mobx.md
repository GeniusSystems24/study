# 27 - MobX - إدارة الحالة التفاعلية

## 📋 المحتويات

- [المقدمة](#المقدمة)
- [تثبيت MobX](#تثبيت-mobx)
- [Observable](#observable)
- [Actions](#actions)
- [Computed Values](#computed-values)
- [أمثلة عملية](#أمثلة-عملية)

---

## 🎯 المقدمة

MobX نمط لإدارة الحالة التفاعلية باستخدام Observable، Actions، و Reactions.

---

## 📦 تثبيت MobX

أضف في `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  mobx: ^2.2.0
  flutter_mobx: ^2.1.1

dev_dependencies:
  build_runner: ^2.4.6
  mobx_codegen: ^2.4.0
```

ثم نفذ:

```bash
flutter pub get
flutter packages pub run build_runner build
```

---

## 👁️ Observable

إنشاء Store:

```dart
import 'package:mobx/mobx.dart';

// يجب تضمين هذا الملف المُولّد
part 'counter_store.g.dart';

// هذا الاسم يربط بين الكلاس والكود المُولّد
class CounterStore = _CounterStore with _$CounterStore;

abstract class _CounterStore with Store {
  @observable
  int count = 0;

  @action
  void increment() {
    count++;
  }

  @action
  void decrement() {
    count--;
  }

  @action
  void reset() {
    count = 0;
  }
}
```

لتوليد الكود:

```bash
flutter packages pub run build_runner build
# أو للمراقبة التلقائية:
flutter packages pub run build_runner watch
```

---

## ⚡ Actions

الإجراءات التي تغير الحالة:

```dart
import 'package:mobx/mobx.dart';

part 'todo_store.g.dart';

class TodoStore = _TodoStore with _$TodoStore;

abstract class _TodoStore with Store {
  @observable
  ObservableList<String> todos = ObservableList<String>();

  @action
  void addTodo(String todo) {
    todos.add(todo);
  }

  @action
  void removeTodo(int index) {
    todos.removeAt(index);
  }

  @action
  void clearCompleted() {
    // منطق مخصص
  }
}
```

---

## 🧮 Computed Values

قيم محسوبة تلقائياً:

```dart
import 'package:mobx/mobx.dart';

part 'task_store.g.dart';

class Task {
  final String title;
  bool isCompleted;

  Task(this.title, {this.isCompleted = false});
}

class TaskStore = _TaskStore with _$TaskStore;

abstract class _TaskStore with Store {
  @observable
  ObservableList<Task> tasks = ObservableList<Task>();

  @computed
  int get totalCount => tasks.length;

  @computed
  int get completedCount =>
      tasks.where((task) => task.isCompleted).length;

  @computed
  int get activeCount =>
      tasks.where((task) => !task.isCompleted).length;

  @computed
  List<Task> get activeTasks =>
      tasks.where((task) => !task.isCompleted).toList();

  @computed
  List<Task> get completedTasks =>
      tasks.where((task) => task.isCompleted).toList();

  @action
  void addTask(String title) {
    tasks.add(Task(title));
  }

  @action
  void toggleTask(int index) {
    tasks[index].isCompleted = !tasks[index].isCompleted;
  }

  @action
  void removeTask(int index) {
    tasks.removeAt(index);
  }
}
```

---

## 💼 أمثلة عملية

### تطبيق عداد بسيط

```dart
// counter_store.dart
import 'package:mobx/mobx.dart';

part 'counter_store.g.dart';

class CounterStore = _CounterStore with _$CounterStore;

abstract class _CounterStore with Store {
  @observable
  int count = 0;

  @action
  void increment() {
    count++;
  }

  @action
  void decrement() {
    count--;
  }
}

// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MobX Counter',
      home: const CounterPage(),
    );
  }
}

class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final counter = CounterStore();

    return Scaffold(
      appBar: AppBar(title: const Text('MobX Counter')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('العدد:', style: TextStyle(fontSize: 24)),
            // Observer لإعادة البناء التلقائي
            Observer(
              builder: (_) => Text(
                '${counter.count}',
                style: const TextStyle(
                  fontSize: 72,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'increment',
            onPressed: counter.increment,
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: 'decrement',
            onPressed: counter.decrement,
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}
```

### تطبيق قائمة مهام

```dart
// task.dart
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

// task_store.dart
import 'package:mobx/mobx.dart';

part 'task_store.g.dart';

class TaskStore = _TaskStore with _$TaskStore;

abstract class _TaskStore with Store {
  @observable
  ObservableList<Task> tasks = ObservableList<Task>();

  @computed
  int get totalCount => tasks.length;

  @computed
  int get completedCount =>
      tasks.where((task) => task.isCompleted).length;

  @computed
  int get activeCount =>
      tasks.where((task) => !task.isCompleted).length;

  @action
  void addTask(String title) {
    tasks.add(Task(
      id: DateTime.now().toString(),
      title: title,
    ));
  }

  @action
  void toggleTask(String id) {
    final task = tasks.firstWhere((t) => t.id == id);
    task.isCompleted = !task.isCompleted;
  }

  @action
  void removeTask(String id) {
    tasks.removeWhere((task) => task.id == id);
  }

  @action
  void clearCompleted() {
    tasks.removeWhere((task) => task.isCompleted);
  }
}

// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MobX Todo',
      home: const TodoScreen(),
    );
  }
}

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final TaskStore taskStore = TaskStore();
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _addTask() {
    if (controller.text.isNotEmpty) {
      taskStore.addTask(controller.text);
      controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('قائمة المهام - MobX')),
      body: Column(
        children: [
          // Stats
          Observer(
            builder: (_) => Container(
              padding: const EdgeInsets.all(16),
              color: Colors.blue.shade50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStat('الإجمالي', taskStore.totalCount),
                  _buildStat('نشطة', taskStore.activeCount),
                  _buildStat('مكتملة', taskStore.completedCount),
                ],
              ),
            ),
          ),

          // Input
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: 'أضف مهمة جديدة',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _addTask(),
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton(
                  onPressed: _addTask,
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ),

          // Tasks List
          Expanded(
            child: Observer(
              builder: (_) {
                if (taskStore.tasks.isEmpty) {
                  return const Center(child: Text('لا توجد مهام'));
                }

                return ListView.builder(
                  itemCount: taskStore.tasks.length,
                  itemBuilder: (context, index) {
                    final task = taskStore.tasks[index];
                    return Dismissible(
                      key: Key(task.id),
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                      direction: DismissDirection.endToStart,
                      onDismissed: (_) => taskStore.removeTask(task.id),
                      child: Observer(
                        builder: (_) => CheckboxListTile(
                          title: Text(
                            task.title,
                            style: TextStyle(
                              decoration: task.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          value: task.isCompleted,
                          onChanged: (_) => taskStore.toggleTask(task.id),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // Clear Completed
          Observer(
            builder: (_) {
              if (taskStore.completedCount == 0) {
                return const SizedBox.shrink();
              }

              return Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: taskStore.clearCompleted,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: Text('مسح المكتملة (${taskStore.completedCount})'),
                ),
              );
            },
          ),
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

### متجر إلكتروني

```dart
// product.dart
class Product {
  final String id;
  final String name;
  final double price;

  Product({
    required this.id,
    required this.name,
    required this.price,
  });
}

// cart_item.dart
class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  double get totalPrice => product.price * quantity;
}

// shop_store.dart
import 'package:mobx/mobx.dart';

part 'shop_store.g.dart';

class ShopStore = _ShopStore with _$ShopStore;

abstract class _ShopStore with Store {
  @observable
  ObservableList<Product> products = ObservableList.of([
    Product(id: '1', name: 'هاتف ذكي', price: 2999),
    Product(id: '2', name: 'حقيبة', price: 299),
    Product(id: '3', name: 'ساعة ذكية', price: 899),
  ]);

  @observable
  ObservableMap<String, CartItem> cartItems = ObservableMap();

  @computed
  int get cartItemCount => cartItems.length;

  @computed
  double get totalAmount {
    return cartItems.values.fold(
      0,
      (sum, item) => sum + item.totalPrice,
    );
  }

  @action
  void addToCart(Product product) {
    if (cartItems.containsKey(product.id)) {
      cartItems[product.id]!.quantity++;
    } else {
      cartItems[product.id] = CartItem(product: product);
    }
  }

  @action
  void removeFromCart(String productId) {
    cartItems.remove(productId);
  }

  @action
  void updateQuantity(String productId, int quantity) {
    if (cartItems.containsKey(productId)) {
      if (quantity <= 0) {
        cartItems.remove(productId);
      } else {
        cartItems[productId]!.quantity = quantity;
      }
    }
  }

  @action
  void clearCart() {
    cartItems.clear();
  }
}
```

---

## 📚 المراجع والمصادر

1. **MobX Package**
   - [mobx](https://pub.dev/packages/mobx)
   - [flutter_mobx](https://pub.dev/packages/flutter_mobx)

2. **Documentation**
   - [MobX Documentation](https://mobx.netlify.app/)
   - [Flutter MobX](https://mobx.netlify.app/getting-started/)

3. **Code Generation**
   - [build_runner](https://pub.dev/packages/build_runner)
   - [mobx_codegen](https://pub.dev/packages/mobx_codegen)

---

## 💡 نصائح

- ✅ استخدم `@observable` للمتغيرات التفاعلية
- ✅ استخدم `@action` للإجراءات التي تغير الحالة
- ✅ استخدم `@computed` للقيم المحسوبة
- ✅ `Observer` widget لإعادة البناء التلقائي
- ✅ لا تنسَ تشغيل `build_runner` لتوليد الكود

---

[⬅️ السابق: GetX](26_getx.md)
[🏠 العودة للفهرس](../README.md)
[التالي: Redux ➡️](28_redux.md)
