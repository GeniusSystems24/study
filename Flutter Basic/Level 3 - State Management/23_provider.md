# 23 - Provider Package - إدارة الحالة المتقدمة

## 📋 المحتويات

- [المقدمة](#المقدمة)
- [تثبيت Provider](#تثبيت-provider)
- [ChangeNotifierProvider](#changenotifierprovider)
- [MultiProvider](#multiprovider)
- [Consumer](#consumer)
- [أمثلة عملية](#أمثلة-عملية)

---

## 🎯 المقدمة

Provider هو الحل الرسمي الموصى به من فريق Flutter لإدارة الحالة.

---

## 📦 تثبيت Provider

أضف في `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.1
```

ثم نفذ:

```bash
flutter pub get
```

---

## 🔔 ChangeNotifierProvider

استخدام ChangeNotifier مع Provider:

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// 1. إنشاء Model
class Counter extends ChangeNotifier {
  int _count = 0;

  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }

  void decrement() {
    _count--;
    notifyListeners();
  }

  void reset() {
    _count = 0;
    notifyListeners();
  }
}

// 2. توفير الـ Provider
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => Counter(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const CounterPage(),
    );
  }
}

// 3. استخدام الـ Provider
class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Provider Counter')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('العدد:', style: TextStyle(fontSize: 24)),
            // استخدام Consumer
            Consumer<Counter>(
              builder: (context, counter, child) {
                return Text(
                  '${counter.count}',
                  style: const TextStyle(
                    fontSize: 72,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'increment',
            onPressed: () {
              // استخدام context.read للأحداث
              context.read<Counter>().increment();
            },
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: 'decrement',
            onPressed: () {
              context.read<Counter>().decrement();
            },
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}
```

---

## 🎭 MultiProvider

استخدام أكثر من Provider:

```dart
class ThemeNotifier extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;
  bool get isDark => _themeMode == ThemeMode.dark;

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light 
        ? ThemeMode.dark 
        : ThemeMode.light;
    notifyListeners();
  }
}

class LanguageNotifier extends ChangeNotifier {
  String _language = 'ar';

  String get language => _language;

  void changeLanguage(String newLanguage) {
    _language = newLanguage;
    notifyListeners();
  }
}

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Counter()),
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
        ChangeNotifierProvider(create: (_) => LanguageNotifier()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return MaterialApp(
          themeMode: themeNotifier.themeMode,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          home: const HomePage(),
        );
      },
    );
  }
}
```

---

## 👁️ Consumer

أنواع استخدام Provider:

```dart
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Provider Demo')),
      body: Column(
        children: [
          // 1. Consumer - يعيد البناء عند التحديث
          Consumer<Counter>(
            builder: (context, counter, child) {
              return Text('العدد: ${counter.count}');
            },
          ),

          // 2. context.watch - يعيد البناء عند التحديث
          Text('العدد: ${context.watch<Counter>().count}'),

          // 3. context.read - لا يعيد البناء (للأحداث فقط)
          ElevatedButton(
            onPressed: () => context.read<Counter>().increment(),
            child: const Text('زيادة'),
          ),

          // 4. Provider.of مع listen: false
          ElevatedButton(
            onPressed: () {
              Provider.of<Counter>(context, listen: false).increment();
            },
            child: const Text('زيادة'),
          ),

          // 5. Selector - يعيد البناء عند تغيير قيمة محددة فقط
          Selector<Counter, int>(
            selector: (context, counter) => counter.count,
            builder: (context, count, child) {
              return Text('العدد المختار: $count');
            },
          ),
        ],
      ),
    );
  }
}
```

---

## 💼 أمثلة عملية

### تطبيق قائمة مهام كامل

```dart
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

class TodoProvider extends ChangeNotifier {
  final List<Task> _tasks = [];

  List<Task> get tasks => [..._tasks];
  
  List<Task> get activeTasks => 
      _tasks.where((task) => !task.isCompleted).toList();
  
  List<Task> get completedTasks => 
      _tasks.where((task) => task.isCompleted).toList();

  int get totalCount => _tasks.length;
  int get activeCount => activeTasks.length;
  int get completedCount => completedTasks.length;

  void addTask(String title) {
    final task = Task(
      id: DateTime.now().toString(),
      title: title,
    );
    _tasks.add(task);
    notifyListeners();
  }

  void toggleTask(String id) {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index != -1) {
      _tasks[index].isCompleted = !_tasks[index].isCompleted;
      notifyListeners();
    }
  }

  void deleteTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
    notifyListeners();
  }

  void clearCompleted() {
    _tasks.removeWhere((task) => task.isCompleted);
    notifyListeners();
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => TodoProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const TodoListScreen(),
    );
  }
}

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final _controller = TextEditingController();
  String _filter = 'all'; // all, active, completed

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addTask() {
    if (_controller.text.isNotEmpty) {
      context.read<TodoProvider>().addTask(_controller.text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('قائمة المهام'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                _filter = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'all', child: Text('الكل')),
              const PopupMenuItem(value: 'active', child: Text('النشطة')),
              const PopupMenuItem(value: 'completed', child: Text('المكتملة')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // إحصائيات
          Consumer<TodoProvider>(
            builder: (context, todoProvider, child) {
              return Container(
                padding: const EdgeInsets.all(16),
                color: Colors.blue.shade50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStat('الإجمالي', todoProvider.totalCount),
                    _buildStat('نشطة', todoProvider.activeCount),
                    _buildStat('مكتملة', todoProvider.completedCount),
                  ],
                ),
              );
            },
          ),

          // إدخال مهمة جديدة
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
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

          // قائمة المهام
          Expanded(
            child: Consumer<TodoProvider>(
              builder: (context, todoProvider, child) {
                List<Task> tasksToShow;
                switch (_filter) {
                  case 'active':
                    tasksToShow = todoProvider.activeTasks;
                    break;
                  case 'completed':
                    tasksToShow = todoProvider.completedTasks;
                    break;
                  default:
                    tasksToShow = todoProvider.tasks;
                }

                if (tasksToShow.isEmpty) {
                  return const Center(
                    child: Text('لا توجد مهام'),
                  );
                }

                return ListView.builder(
                  itemCount: tasksToShow.length,
                  itemBuilder: (context, index) {
                    final task = tasksToShow[index];
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
                      onDismissed: (_) {
                        todoProvider.deleteTask(task.id);
                      },
                      child: CheckboxListTile(
                        title: Text(
                          task.title,
                          style: TextStyle(
                            decoration: task.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        value: task.isCompleted,
                        onChanged: (_) {
                          todoProvider.toggleTask(task.id);
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // زر مسح المكتملة
          Selector<TodoProvider, int>(
            selector: (context, todoProvider) => todoProvider.completedCount,
            builder: (context, completedCount, child) {
              if (completedCount == 0) return const SizedBox.shrink();
              
              return Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: () {
                    context.read<TodoProvider>().clearCompleted();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: Text('مسح المهام المكتملة ($completedCount)'),
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
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(label),
      ],
    );
  }
}
```

### متجر إلكتروني

```dart
class Product {
  final String id;
  final String name;
  final double price;
  final String imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
  });
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  double get totalPrice => product.price * quantity;
}

class ShopProvider extends ChangeNotifier {
  final List<Product> _products = [
    Product(
      id: '1',
      name: 'هاتف ذكي',
      price: 2999,
      imageUrl: 'https://via.placeholder.com/150',
    ),
    Product(
      id: '2',
      name: 'حقيبة',
      price: 299,
      imageUrl: 'https://via.placeholder.com/150',
    ),
    Product(
      id: '3',
      name: 'ساعة ذكية',
      price: 899,
      imageUrl: 'https://via.placeholder.com/150',
    ),
  ];

  final Map<String, CartItem> _cartItems = {};

  List<Product> get products => [..._products];
  
  Map<String, CartItem> get cartItems => {..._cartItems};

  int get cartItemCount => _cartItems.length;

  double get totalAmount {
    return _cartItems.values.fold(
      0,
      (sum, item) => sum + item.totalPrice,
    );
  }

  void addToCart(Product product) {
    if (_cartItems.containsKey(product.id)) {
      _cartItems[product.id]!.quantity++;
    } else {
      _cartItems[product.id] = CartItem(product: product);
    }
    notifyListeners();
  }

  void removeFromCart(String productId) {
    _cartItems.remove(productId);
    notifyListeners();
  }

  void updateQuantity(String productId, int quantity) {
    if (_cartItems.containsKey(productId)) {
      if (quantity <= 0) {
        _cartItems.remove(productId);
      } else {
        _cartItems[productId]!.quantity = quantity;
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ShopProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shop App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ProductsScreen(),
    );
  }
}

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final products = context.watch<ShopProvider>().products;

    return Scaffold(
      appBar: AppBar(
        title: const Text('المنتجات'),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CartScreen(),
                    ),
                  );
                },
              ),
              Selector<ShopProvider, int>(
                selector: (context, shop) => shop.cartItemCount,
                builder: (context, itemCount, child) {
                  if (itemCount == 0) return const SizedBox.shrink();
                  
                  return Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$itemCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    color: Colors.grey.shade200,
                    child: const Center(
                      child: Icon(Icons.image, size: 60),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${product.price} ريال',
                        style: const TextStyle(color: Colors.green),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          context.read<ShopProvider>().addToCart(product);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('تمت إضافة ${product.name}'),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                        icon: const Icon(Icons.add_shopping_cart, size: 16),
                        label: const Text('إضافة'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(36),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('السلة'),
        actions: [
          Selector<ShopProvider, int>(
            selector: (context, shop) => shop.cartItemCount,
            builder: (context, itemCount, child) {
              if (itemCount == 0) return const SizedBox.shrink();
              
              return IconButton(
                icon: const Icon(Icons.delete_sweep),
                onPressed: () {
                  context.read<ShopProvider>().clearCart();
                },
              );
            },
          ),
        ],
      ),
      body: Consumer<ShopProvider>(
        builder: (context, shop, child) {
          if (shop.cartItemCount == 0) {
            return const Center(child: Text('السلة فارغة'));
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: shop.cartItems.length,
                  itemBuilder: (context, index) {
                    final item = shop.cartItems.values.toList()[index];
                    return Card(
                      margin: const EdgeInsets.all(8),
                      child: ListTile(
                        leading: Container(
                          width: 60,
                          height: 60,
                          color: Colors.grey.shade200,
                          child: const Icon(Icons.image),
                        ),
                        title: Text(item.product.name),
                        subtitle: Text('${item.product.price} ريال'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                shop.updateQuantity(
                                  item.product.id,
                                  item.quantity - 1,
                                );
                              },
                            ),
                            Text('${item.quantity}'),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                shop.updateQuantity(
                                  item.product.id,
                                  item.quantity + 1,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade400,
                      blurRadius: 4,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'الإجمالي: ${shop.totalAmount.toStringAsFixed(2)} ريال',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('إتمام الطلب'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
```

---

## 📚 المراجع والمصادر

1. **Provider Package**
   - [Provider Package](https://pub.dev/packages/provider)
   - [Provider Documentation](https://docs.flutter.dev/data-and-backend/state-mgmt/simple)

2. **Tutorials**
   - [Simple App State Management](https://docs.flutter.dev/data-and-backend/state-mgmt/simple)
   - [Provider Architecture](https://pub.dev/documentation/provider/latest/)

---

## 💡 نصائح

- ✅ استخدم `context.read` للأحداث فقط (لا يعيد البناء)
- ✅ استخدم `context.watch` أو `Consumer` للقراءة والتحديث
- ✅ `Selector` لتحسين الأداء (يعيد البناء عند تغيير قيمة معينة فقط)
- ✅ `MultiProvider` لإدارة عدة Providers
- ✅ Provider هو الخيار الأفضل للتطبيقات متوسطة الحجم

---

[⬅️ السابق: InheritedWidget](22_inherited_widget.md)
[🏠 العودة للفهرس](../README.md)
[التالي: Riverpod ➡️](24_riverpod.md)
