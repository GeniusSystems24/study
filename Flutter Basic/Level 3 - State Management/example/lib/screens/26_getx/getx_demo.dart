import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ========== Controllers ==========

// 1. Simple Counter Controller (Reactive)
class CounterController extends GetxController {
  var count = 0.obs;

  void increment() => count++;
  void decrement() => count--;
  void reset() => count.value = 0;
}

// 2. Todo Controller (Reactive with List)
class TodoController extends GetxController {
  var todos = <TodoItem>[].obs;
  var filter = 'all'.obs;

  List<TodoItem> get filteredTodos {
    switch (filter.value) {
      case 'completed':
        return todos.where((t) => t.isCompleted.value).toList();
      case 'pending':
        return todos.where((t) => !t.isCompleted.value).toList();
      default:
        return todos;
    }
  }

  int get totalCount => todos.length;
  int get completedCount => todos.where((t) => t.isCompleted.value).length;
  int get pendingCount => todos.where((t) => !t.isCompleted.value).length;

  void addTodo(String title) {
    todos.add(TodoItem(
      id: DateTime.now().toString(),
      title: title,
    ));
  }

  void toggleTodo(String id) {
    final todo = todos.firstWhere((t) => t.id == id);
    todo.isCompleted.value = !todo.isCompleted.value;
  }

  void removeTodo(String id) {
    todos.removeWhere((t) => t.id == id);
  }

  void setFilter(String newFilter) {
    filter.value = newFilter;
  }

  void clearCompleted() {
    todos.removeWhere((t) => t.isCompleted.value);
  }
}

class TodoItem {
  final String id;
  final String title;
  var isCompleted = false.obs;

  TodoItem({required this.id, required this.title});
}

// 3. Shopping Cart Controller (GetBuilder - non-reactive)
class ShoppingController extends GetxController {
  final List<Product> products = [
    Product(id: '1', name: 'لابتوب', price: 3000, emoji: '💻'),
    Product(id: '2', name: 'هاتف', price: 2000, emoji: '📱'),
    Product(id: '3', name: 'سماعات', price: 500, emoji: '🎧'),
    Product(id: '4', name: 'ساعة', price: 800, emoji: '⌚'),
  ];

  final Map<String, int> _cart = {};

  Map<String, int> get cart => _cart;

  int get itemCount => _cart.values.fold(0, (sum, qty) => sum + qty);

  double get totalAmount {
    double total = 0;
    _cart.forEach((id, qty) {
      final product = products.firstWhere((p) => p.id == id);
      total += product.price * qty;
    });
    return total;
  }

  void addToCart(String productId) {
    if (_cart.containsKey(productId)) {
      _cart[productId] = _cart[productId]! + 1;
    } else {
      _cart[productId] = 1;
    }
    update(); // للـ GetBuilder
  }

  void removeFromCart(String productId) {
    if (_cart.containsKey(productId)) {
      if (_cart[productId]! > 1) {
        _cart[productId] = _cart[productId]! - 1;
      } else {
        _cart.remove(productId);
      }
      update();
    }
  }

  void clearCart() {
    _cart.clear();
    update();
  }
}

class Product {
  final String id;
  final String name;
  final double price;
  final String emoji;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.emoji,
  });
}

// 4. User Controller (Async with Workers)
class UserController extends GetxController {
  var isLoading = false.obs;
  var user = Rxn<User>();

  @override
  void onInit() {
    super.onInit();
    // Worker - يستمع للتغييرات
    ever(user, (_) => print('User changed'));
  }

  Future<void> login(String email, String password) async {
    isLoading.value = true;

    await Future.delayed(const Duration(seconds: 2));

    user.value = User(
      name: 'أحمد محمد',
      email: email,
      avatar: '👤',
    );

    isLoading.value = false;

    Get.snackbar(
      'نجح',
      'تم تسجيل الدخول بنجاح',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void logout() {
    user.value = null;
    Get.snackbar(
      'تسجيل الخروج',
      'تم تسجيل الخروج بنجاح',
      backgroundColor: Colors.orange,
      colorText: Colors.white,
    );
  }
}

class User {
  final String name;
  final String email;
  final String avatar;

  User({required this.name, required this.email, required this.avatar});
}

// 5. Theme Controller (GetX Storage example)
class ThemeController extends GetxController {
  var isDark = false.obs;

  void toggleTheme() {
    isDark.value = !isDark.value;
    Get.changeThemeMode(isDark.value ? ThemeMode.dark : ThemeMode.light);
  }
}

/// شاشة عرض GetX - الموضوع 26
class GetXDemo extends StatelessWidget {
  const GetXDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 8,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('GetX - All Features'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'مقدمة'),
              Tab(text: 'Obx (Reactive)'),
              Tab(text: 'GetBuilder'),
              Tab(text: 'Todo (Reactive)'),
              Tab(text: 'Shopping Cart'),
              Tab(text: 'User & Workers'),
              Tab(text: 'Navigation & Dialogs'),
              Tab(text: 'مقارنة'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _IntroTab(),
            _ObxTab(),
            _GetBuilderTab(),
            _TodoTab(),
            _ShoppingTab(),
            _UserTab(),
            _NavigationTab(),
            _ComparisonTab(),
          ],
        ),
      ),
    );
  }
}

// ========== Tabs ==========

// Tab 1: Introduction
class _IntroTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '⚡ GetX - All-in-One Solution',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                const Text(
                  'GetX هو micro-framework قوي وخفيف يوفر:\n\n'
                  '• State Management (Reactive & Simple)\n'
                  '• Route Management (Navigation)\n'
                  '• Dependency Injection\n'
                  '• Dialogs & SnackBars\n'
                  '• Internationalization\n\n'
                  'كل ذلك بكود أقل وأداء أعلى!',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          color: Colors.green.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '✨ المزايا الرئيسية',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                const Text('✓ سهل جداً - منحنى تعلم منخفض'),
                const Text('✓ أداء عالي - يعيد بناء أجزاء صغيرة فقط'),
                const Text('✓ كود أقل - بدون Boilerplate'),
                const Text('✓ All-in-One - كل ما تحتاجه في مكان واحد'),
                const Text('✓ Reactive Programming - مع .obs'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          color: Colors.blue.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.code, color: Colors.blue),
                    const SizedBox(width: 8),
                    Text(
                      'أنواع State Management في GetX',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text('1️⃣ Obx - Reactive (يتحدث تلقائياً)'),
                const Text('2️⃣ GetBuilder - Simple (يحتاج update())'),
                const Text('3️⃣ GetX Widget - Reactive + Dependency'),
                const Text('4️⃣ Workers - للاستماع للتغييرات'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// Tab 2: Obx (Reactive)
class _ObxTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CounterController());

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  '🔄 Obx - Reactive State',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Obx يستمع تلقائياً للمتغيرات Observable (.obs)\n'
                  'ويعيد بناء الـ Widget عند التغيير',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Obx(() => Text(
                      '${controller.count}',
                      style: const TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    )),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: controller.decrement,
                      icon: const Icon(Icons.remove),
                      label: const Text('تقليل'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: controller.reset,
                      icon: const Icon(Icons.refresh),
                      label: const Text('إعادة'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: controller.increment,
                      icon: const Icon(Icons.add),
                      label: const Text('زيادة'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          color: Colors.orange.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.code, color: Colors.orange),
                    const SizedBox(width: 8),
                    Text(
                      'الكود',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      '// 1. Controller\n'
                      'class CounterController extends GetxController {\n'
                      '  var count = 0.obs; // Observable\n'
                      '  void increment() => count++;\n'
                      '}\n\n'
                      '// 2. Initialize\n'
                      'final controller = Get.put(CounterController());\n\n'
                      '// 3. UI with Obx\n'
                      'Obx(() => Text("\${controller.count}"))\n\n'
                      '// 4. Update\n'
                      'ElevatedButton(\n'
                      '  onPressed: controller.increment,\n'
                      '  child: Text("زيادة"),\n'
                      ')',
                      style: TextStyle(
                        color: Colors.greenAccent,
                        fontFamily: 'monospace',
                        fontSize: 11,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// Tab 3: GetBuilder
class _GetBuilderTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ShoppingController());

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '🏗️ GetBuilder - Simple State',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                const Text(
                  'GetBuilder أخف من Obx، لكن يحتاج استدعاء update() يدوياً.\n'
                  'مناسب للحالات البسيطة التي لا تحتاج Reactive.',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        GetBuilder<ShoppingController>(
          builder: (ctrl) {
            return Card(
              color: Colors.blue.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.shopping_cart),
                            const SizedBox(width: 8),
                            Text('عدد المنتجات: ${ctrl.itemCount}'),
                          ],
                        ),
                        Text(
                          'الإجمالي: ${ctrl.totalAmount.toStringAsFixed(0)} ر.س',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        ...controller.products.map((product) {
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading:
                  Text(product.emoji, style: const TextStyle(fontSize: 32)),
              title: Text(product.name),
              subtitle: Text('${product.price} ر.س'),
              trailing: GetBuilder<ShoppingController>(
                builder: (ctrl) {
                  final qty = ctrl.cart[product.id] ?? 0;

                  if (qty == 0) {
                    return ElevatedButton.icon(
                      onPressed: () => ctrl.addToCart(product.id),
                      icon: const Icon(Icons.add_shopping_cart),
                      label: const Text('إضافة'),
                    );
                  }

                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle),
                        onPressed: () => ctrl.removeFromCart(product.id),
                      ),
                      Text('$qty', style: const TextStyle(fontSize: 18)),
                      IconButton(
                        icon: const Icon(Icons.add_circle),
                        onPressed: () => ctrl.addToCart(product.id),
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        }).toList(),
        const SizedBox(height: 16),
        GetBuilder<ShoppingController>(
          builder: (ctrl) {
            if (ctrl.itemCount == 0) return const SizedBox();

            return ElevatedButton.icon(
              onPressed: ctrl.clearCart,
              icon: const Icon(Icons.delete),
              label: const Text('مسح السلة'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.all(16),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        Card(
          color: Colors.orange.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'الفرق بين Obx و GetBuilder',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                const Text('Obx → Reactive، تحديث تلقائي، يحتاج .obs'),
                const Text('GetBuilder → Simple، يحتاج update()، أسرع قليلاً'),
                const SizedBox(height: 8),
                const Text(
                  '💡 استخدم Obx للحالات المتغيرة كثيراً\n'
                  '💡 استخدم GetBuilder للحالات البسيطة',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// Tab 4: Todo (Reactive List)
class _TodoTab extends StatefulWidget {
  @override
  State<_TodoTab> createState() => _TodoTabState();
}

class _TodoTabState extends State<_TodoTab> {
  final controller = Get.put(TodoController());
  final textController = TextEditingController();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() => Container(
              padding: const EdgeInsets.all(16),
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _StatChip(
                          'الكل', '${controller.totalCount}', Colors.blue),
                      _StatChip('منجزة', '${controller.completedCount}',
                          Colors.green),
                      _StatChip(
                          'معلقة', '${controller.pendingCount}', Colors.orange),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FilterChip(
                        label: const Text('الكل'),
                        selected: controller.filter.value == 'all',
                        onSelected: (_) => controller.setFilter('all'),
                      ),
                      const SizedBox(width: 8),
                      FilterChip(
                        label: const Text('منجزة'),
                        selected: controller.filter.value == 'completed',
                        onSelected: (_) => controller.setFilter('completed'),
                      ),
                      const SizedBox(width: 8),
                      FilterChip(
                        label: const Text('معلقة'),
                        selected: controller.filter.value == 'pending',
                        onSelected: (_) => controller.setFilter('pending'),
                      ),
                    ],
                  ),
                ],
              ),
            )),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: textController,
                  decoration: const InputDecoration(
                    labelText: 'مهمة جديدة',
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      controller.addTodo(value);
                      textController.clear();
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: () {
                  if (textController.text.isNotEmpty) {
                    controller.addTodo(textController.text);
                    textController.clear();
                  }
                },
                icon: const Icon(Icons.add),
                label: const Text('إضافة'),
              ),
            ],
          ),
        ),
        Expanded(
          child: Obx(() {
            final todos = controller.filteredTodos;

            if (todos.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.inbox, size: 80, color: Colors.grey),
                    SizedBox(height: 16),
                    Text('لا توجد مهام'),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                final todo = todos[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: ListTile(
                    leading: Obx(() => Checkbox(
                          value: todo.isCompleted.value,
                          onChanged: (_) => controller.toggleTodo(todo.id),
                        )),
                    title: Obx(() => Text(
                          todo.title,
                          style: TextStyle(
                            decoration: todo.isCompleted.value
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        )),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => controller.removeTodo(todo.id),
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatChip(this.label, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: color)),
        Text(label),
      ],
    );
  }
}

// Tab 5: Shopping Cart
class _ShoppingTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Get.put(ShoppingController());
    return _GetBuilderTab();
  }
}

// Tab 6: User & Workers
class _UserTab extends StatefulWidget {
  @override
  State<_UserTab> createState() => _UserTabState();
}

class _UserTabState extends State<_UserTab> {
  final controller = Get.put(UserController());
  final emailController = TextEditingController(text: 'user@example.com');
  final passwordController = TextEditingController(text: 'password');

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      if (controller.user.value != null) {
        final user = controller.user.value!;
        return Center(
          child: Card(
            margin: const EdgeInsets.all(32),
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(user.avatar, style: const TextStyle(fontSize: 80)),
                  const SizedBox(height: 16),
                  Text(user.name,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold)),
                  Text(user.email, style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: controller.logout,
                    icon: const Icon(Icons.logout),
                    label: const Text('تسجيل الخروج'),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  ),
                ],
              ),
            ),
          ),
        );
      }

      return ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Icon(Icons.account_circle, size: 100, color: Colors.blue),
          const SizedBox(height: 24),
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
          ElevatedButton.icon(
            onPressed: () {
              controller.login(emailController.text, passwordController.text);
            },
            icon: const Icon(Icons.login),
            label: const Text('تسجيل الدخول'),
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
          ),
        ],
      );
    });
  }
}

// Tab 7: Navigation & Dialogs
class _NavigationTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '🧭 Navigation & Dialogs',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                const Text(
                    'GetX يوفر طرق سهلة للتنقل والـ Dialogs بدون BuildContext'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        ListTile(
          leading: const Icon(Icons.message, color: Colors.green),
          title: const Text('SnackBar'),
          subtitle: const Text('رسالة سريعة في الأسفل'),
          trailing: ElevatedButton(
            onPressed: () {
              Get.snackbar(
                'عنوان',
                'هذه رسالة SnackBar من GetX',
                backgroundColor: Colors.green,
                colorText: Colors.white,
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            child: const Text('عرض'),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.info, color: Colors.blue),
          title: const Text('Dialog'),
          subtitle: const Text('نافذة منبثقة'),
          trailing: ElevatedButton(
            onPressed: () {
              Get.defaultDialog(
                title: 'تنبيه',
                middleText: 'هل أنت متأكد؟',
                textConfirm: 'نعم',
                textCancel: 'لا',
                confirmTextColor: Colors.white,
                onConfirm: () => Get.back(),
              );
            },
            child: const Text('عرض'),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.table_chart, color: Colors.orange),
          title: const Text('BottomSheet'),
          subtitle: const Text('ورقة من الأسفل'),
          trailing: ElevatedButton(
            onPressed: () {
              Get.bottomSheet(
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Bottom Sheet',
                          style: TextStyle(fontSize: 24)),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => Get.back(),
                        child: const Text('إغلاق'),
                      ),
                    ],
                  ),
                ),
              );
            },
            child: const Text('عرض'),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          color: Colors.purple.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'مزايا GetX Navigation',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                const Text('✓ بدون BuildContext'),
                const Text('✓ Get.to(), Get.off(), Get.offAll()'),
                const Text('✓ Named Routes مع Get.toNamed()'),
                const Text('✓ إرسال البيانات والاستقبال'),
                const Text('✓ Transitions جاهزة'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// Tab 8: Comparison
class _ComparisonTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '📊 مقارنة GetX',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                _buildComparison(
                  'Obx vs GetBuilder',
                  'Obx: Reactive, تحديث تلقائي\nGetBuilder: Simple, يحتاج update()',
                  'استخدم Obx للـ Reactive\nاستخدم GetBuilder للأداء',
                  Colors.blue,
                ),
                _buildComparison(
                  'GetX vs Provider',
                  'GetX: All-in-one, أسهل\nProvider: State فقط, أكثر مرونة',
                  'GetX أسرع في التطوير\nProvider أفضل للمشاريع الكبيرة',
                  Colors.green,
                ),
                _buildComparison(
                  'GetX vs BLoC',
                  'GetX: بسيط جداً\nBLoC: معقد لكن منظم',
                  'GetX للمشاريع المتوسطة\nBLoC للمشاريع المعقدة',
                  Colors.orange,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          color: Colors.green.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'متى تستخدم GetX؟',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                const Text('✓ مشاريع صغيرة ومتوسطة'),
                const Text('✓ عندما تريد سرعة في التطوير'),
                const Text('✓ عندما تحتاج Navigation سهل'),
                const Text('✓ عندما تريد All-in-One solution'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildComparison(
      String title, String comparison, String recommendation, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 8),
          Text(comparison),
          const Divider(),
          Text('💡 $recommendation',
              style: const TextStyle(fontStyle: FontStyle.italic)),
        ],
      ),
    );
  }
}
