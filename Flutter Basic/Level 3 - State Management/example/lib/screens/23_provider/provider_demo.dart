import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ========== Models ==========

// Counter Provider
class CounterProvider with ChangeNotifier {
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

// Discount Calculator - يعتمد على Counter (مثال ProxyProvider)
class DiscountCalculator {
  final int itemCount;
  
  DiscountCalculator(this.itemCount);
  
  double calculateDiscount(double totalPrice) {
    if (itemCount >= 10) {
      return totalPrice * 0.20; // خصم 20%
    } else if (itemCount >= 5) {
      return totalPrice * 0.10; // خصم 10%
    } else if (itemCount >= 3) {
      return totalPrice * 0.05; // خصم 5%
    }
    return 0;
  }
  
  String getDiscountMessage() {
    if (itemCount >= 10) return '🎉 خصم 20% - شكراً لك!';
    if (itemCount >= 5) return '✨ خصم 10% - عميل مميز!';
    if (itemCount >= 3) return '💫 خصم 5%';
    return 'اشتري ${3 - itemCount} للحصول على خصم!';
  }
}

// App Configuration - مثال Provider العادي
class AppConfig {
  final String appName;
  final String version;
  
  AppConfig({required this.appName, required this.version});
}

// App Settings - مثال FutureProvider
class AppSettings {
  final String language;
  final bool notifications;
  final String currency;
  
  AppSettings({
    required this.language,
    required this.notifications,
    required this.currency,
  });
  
  factory AppSettings.initial() {
    return AppSettings(
      language: 'ar',
      notifications: true,
      currency: 'SAR',
    );
  }
}

// Settings Service - لجلب الإعدادات
class SettingsService {
  static Future<AppSettings> fetchSettings() async {
    // محاكاة تحميل الإعدادات من API أو Database
    await Future.delayed(const Duration(seconds: 2));
    
    return AppSettings(
      language: 'ar',
      notifications: true,
      currency: 'SAR',
    );
  }
}

/// شاشة عرض Provider - الموضوع 23
class ProviderDemo extends StatelessWidget {
  const ProviderDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ChangeNotifierProvider - الأساسي
        ChangeNotifierProvider(create: (_) => CounterProvider()),
        ChangeNotifierProvider(create: (_) => TodoProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        
        // ProxyProvider - يعتمد على CounterProvider
        ProxyProvider<CounterProvider, DiscountCalculator>(
          update: (_, counter, __) => DiscountCalculator(counter.count),
        ),
        
        // ChangeNotifierProxyProvider - ShoppingCart يعتمد على User
        ChangeNotifierProxyProvider<UserProvider, ShoppingCartProvider>(
          create: (_) => ShoppingCartProvider(),
          update: (_, user, cart) => cart!..updateUser(user.user),
        ),
        
        // FutureProvider - جلب بيانات غير متزامنة
        FutureProvider<AppSettings>(
          create: (_) => SettingsService.fetchSettings(),
          initialData: AppSettings.initial(),
        ),
        
        // StreamProvider - بيانات متدفقة
        StreamProvider<DateTime>(
          create: (_) => Stream.periodic(
            const Duration(seconds: 1),
            (_) => DateTime.now(),
          ),
          initialData: DateTime.now(),
        ),
        
        // Provider - قيمة ثابتة
        Provider<AppConfig>(
          create: (_) => AppConfig(appName: 'Provider Demo', version: '1.0.0'),
        ),
      ],
      child: DefaultTabController(
        length: 10,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Provider - جميع الأنواع'),
            bottom: const TabBar(
              isScrollable: true,
              tabs: [
                Tab(text: 'مقدمة'),
                Tab(text: 'ChangeNotifier'),
                Tab(text: 'ProxyProvider'),
                Tab(text: 'FutureProvider'),
                Tab(text: 'StreamProvider'),
                Tab(text: 'Todo List'),
                Tab(text: 'Shopping Cart'),
                Tab(text: 'Theme'),
                Tab(text: 'User Profile'),
                Tab(text: 'مقارنة الأنواع'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              _IntroTab(),
              _CounterTab(),
              _ProxyProviderTab(),
              _FutureProviderTab(),
              _StreamProviderTab(),
              _TodoTab(),
              _ShoppingCartTab(),
              _ThemeSwitcherTab(),
              _UserProfileTab(),
              _ComparisonTab(),
            ],
          ),
        ),
      ),
    );
  }
}

// Todo Model
class Todo {
  final String id;
  final String title;
  bool isCompleted;
  
  Todo({
    required this.id,
    required this.title,
    this.isCompleted = false,
  });
}

// Todo Provider
class TodoProvider with ChangeNotifier {
  final List<Todo> _todos = [];
  String _filter = 'all'; // all, completed, pending
  
  List<Todo> get todos {
    if (_filter == 'completed') {
      return _todos.where((t) => t.isCompleted).toList();
    } else if (_filter == 'pending') {
      return _todos.where((t) => !t.isCompleted).toList();
    }
    return _todos;
  }
  
  List<Todo> get allTodos => _todos;
  String get currentFilter => _filter;
  int get totalTodos => _todos.length;
  int get completedTodos => _todos.where((t) => t.isCompleted).length;
  int get pendingTodos => _todos.where((t) => !t.isCompleted).length;
  
  void addTodo(String title) {
    _todos.add(Todo(
      id: DateTime.now().toString(),
      title: title,
    ));
    notifyListeners();
  }
  
  void toggleTodo(String id) {
    final todo = _todos.firstWhere((t) => t.id == id);
    todo.isCompleted = !todo.isCompleted;
    notifyListeners();
  }
  
  void removeTodo(String id) {
    _todos.removeWhere((t) => t.id == id);
    notifyListeners();
  }
  
  void setFilter(String filter) {
    _filter = filter;
    notifyListeners();
  }
  
  void clearCompleted() {
    _todos.removeWhere((t) => t.isCompleted);
    notifyListeners();
  }
  
  void toggleAll() {
    final allCompleted = _todos.every((t) => t.isCompleted);
    for (var todo in _todos) {
      todo.isCompleted = !allCompleted;
    }
    notifyListeners();
  }
}

// Product Model
class Product {
  final String id;
  final String name;
  final double price;
  final String image;
  
  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
  });
}

// Cart Item Model
class CartItem {
  final Product product;
  int quantity;
  
  CartItem({required this.product, this.quantity = 1});
  
  double get totalPrice => product.price * quantity;
}

// Shopping Cart Provider
class ShoppingCartProvider with ChangeNotifier {
  final Map<String, CartItem> _items = {};
  User? _currentUser;
  
  Map<String, CartItem> get items => _items;
  User? get currentUser => _currentUser;
  
  int get itemCount => _items.values.fold(0, (sum, item) => sum + item.quantity);
  
  double get totalAmount {
    return _items.values.fold(0.0, (sum, item) => sum + item.totalPrice);
  }
  
  // لـ ChangeNotifierProxyProvider
  void updateUser(User? user) {
    _currentUser = user;
    // يمكن إضافة منطق إضافي هنا مثل تحميل سلة المستخدم من قاعدة البيانات
    notifyListeners();
  }
  
  void addItem(Product product) {
    if (_items.containsKey(product.id)) {
      _items[product.id]!.quantity++;
    } else {
      _items[product.id] = CartItem(product: product);
    }
    notifyListeners();
  }
  
  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }
  
  void increaseQuantity(String productId) {
    if (_items.containsKey(productId)) {
      _items[productId]!.quantity++;
      notifyListeners();
    }
  }
  
  void decreaseQuantity(String productId) {
    if (_items.containsKey(productId)) {
      if (_items[productId]!.quantity > 1) {
        _items[productId]!.quantity--;
      } else {
        _items.remove(productId);
      }
      notifyListeners();
    }
  }
  
  void clear() {
    _items.clear();
    notifyListeners();
  }
}

// Theme Provider
class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;
  Color _primaryColor = Colors.blue;
  
  bool get isDarkMode => _isDarkMode;
  Color get primaryColor => _primaryColor;
  
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
  
  void setPrimaryColor(Color color) {
    _primaryColor = color;
    notifyListeners();
  }
}

// User Model
class User {
  final String name;
  final String email;
  final String avatar;
  
  User({required this.name, required this.email, required this.avatar});
}

// User Provider
class UserProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  
  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _user != null;
  
  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    
    _user = User(
      name: 'محمد أحمد',
      email: email,
      avatar: '👤',
    );
    _isLoading = false;
    notifyListeners();
  }
  
  void logout() {
    _user = null;
    notifyListeners();
  }
  
  Future<void> updateProfile(String name) async {
    if (_user != null) {
      _isLoading = true;
      notifyListeners();
      
      await Future.delayed(const Duration(seconds: 1));
      
      _user = User(
        name: name,
        email: _user!.email,
        avatar: _user!.avatar,
      );
      _isLoading = false;
      notifyListeners();
    }
  }
}

// التاب الأول: مقدمة
class _IntroTab extends StatelessWidget {
  const _IntroTab();

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
                  '🔥 Provider - الحل الأكثر شعبية',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Provider هو wrapper حول InheritedWidget يجعل State Management '
                  'أسهل وأكثر قابلية لإعادة الاستخدام.\n\n'
                  'تم تطويره من قبل Remi Rousselet وموصى به رسمياً من فريق Flutter.',
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
                  '✨ المزايا',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                const Text('✓ سهل التعلم والاستخدام'),
                const Text('✓ موصى به من Google'),
                const Text('✓ أداء ممتاز'),
                const Text('✓ مجتمع كبير'),
                const Text('✓ دعم ممتاز للتطبيقات الكبيرة'),
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
                      'المفاهيم الأساسية',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text('1️⃣ ChangeNotifier - للـ state class'),
                const Text('2️⃣ ChangeNotifierProvider - للتزويد'),
                const Text('3️⃣ Consumer - للاستماع والبناء'),
                const Text('4️⃣ Provider.of - للوصول المباشر'),
                const Text('5️⃣ context.watch - للاستماع'),
                const Text('6️⃣ context.read - للقراءة بدون استماع'),
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
                    const Icon(Icons.install_desktop, color: Colors.orange),
                    const SizedBox(width: 8),
                    Text(
                      'التثبيت',
                      style: Theme.of(context).textTheme.titleLarge,
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
                  child: const Text(
                    'dependencies:\n'
                    '  provider: ^6.1.1',
                    style: TextStyle(
                      color: Colors.greenAccent,
                      fontFamily: 'monospace',
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

// التاب الثاني: Counter Example
class _CounterTab extends StatelessWidget {
  const _CounterTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  'مثال: Counter مع Provider',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 24),
                
                // Display counter using Consumer
                Consumer<CounterProvider>(
                  builder: (context, counter, child) {
                    return Column(
                      children: [
                        Text(
                          '${counter.count}',
                          style: const TextStyle(
                            fontSize: 64,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'باستخدام Consumer<CounterProvider>',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    );
                  },
                ),
                
                const SizedBox(height: 24),
                
                // Buttons using context.read
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<CounterProvider>().decrement();
                      },
                      icon: const Icon(Icons.remove),
                      label: const Text('تقليل'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<CounterProvider>().reset();
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('إعادة تعيين'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<CounterProvider>().increment();
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('زيادة'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                    ),
                  ],
                ),
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
                      'الكود',
                      style: Theme.of(context).textTheme.titleLarge,
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
                      '// 1. إنشاء Provider Class\n'
                      'class CounterProvider with ChangeNotifier {\n'
                      '  int _count = 0;\n'
                      '  int get count => _count;\n\n'
                      '  void increment() {\n'
                      '    _count++;\n'
                      '    notifyListeners(); // مهم!\n'
                      '  }\n'
                      '}\n\n'
                      '// 2. تزويد Provider\n'
                      'ChangeNotifierProvider(\n'
                      '  create: (_) => CounterProvider(),\n'
                      '  child: MyApp(),\n'
                      ')\n\n'
                      '// 3. الاستخدام\n'
                      '// للعرض:\n'
                      'Consumer<CounterProvider>(\n'
                      '  builder: (context, counter, child) {\n'
                      '    return Text("\${counter.count}");\n'
                      '  },\n'
                      ')\n\n'
                      '// للتعديل:\n'
                      'context.read<CounterProvider>().increment();',
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

// التاب الثالث: Todo List Example
class _TodoTab extends StatefulWidget {
  const _TodoTab();

  @override
  State<_TodoTab> createState() => _TodoTabState();
}

class _TodoTabState extends State<_TodoTab> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Statistics
        Consumer<TodoProvider>(
          builder: (context, todoProvider, child) {
            return Container(
              padding: const EdgeInsets.all(16),
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _StatCard(
                        title: 'الإجمالي',
                        value: '${todoProvider.totalTodos}',
                        icon: Icons.list,
                        color: Colors.blue,
                      ),
                      _StatCard(
                        title: 'منجزة',
                        value: '${todoProvider.completedTodos}',
                        icon: Icons.check_circle,
                        color: Colors.green,
                      ),
                      _StatCard(
                        title: 'معلقة',
                        value: '${todoProvider.pendingTodos}',
                        icon: Icons.pending,
                        color: Colors.orange,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Filter Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        FilterChip(
                          label: const Text('الكل'),
                          selected: todoProvider.currentFilter == 'all',
                          onSelected: (_) => todoProvider.setFilter('all'),
                        ),
                        const SizedBox(width: 8),
                        FilterChip(
                          label: const Text('منجزة'),
                          selected: todoProvider.currentFilter == 'completed',
                          onSelected: (_) => todoProvider.setFilter('completed'),
                        ),
                        const SizedBox(width: 8),
                        FilterChip(
                          label: const Text('معلقة'),
                          selected: todoProvider.currentFilter == 'pending',
                          onSelected: (_) => todoProvider.setFilter('pending'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        
        // Add Todo
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    labelText: 'مهمة جديدة',
                    hintText: 'اكتب مهمة...',
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      context.read<TodoProvider>().addTodo(value);
                      _controller.clear();
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: () {
                  if (_controller.text.isNotEmpty) {
                    context.read<TodoProvider>().addTodo(_controller.text);
                    _controller.clear();
                  }
                },
                icon: const Icon(Icons.add),
                label: const Text('إضافة'),
              ),
            ],
          ),
        ),
        
        // Action Buttons
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    context.read<TodoProvider>().toggleAll();
                  },
                  icon: const Icon(Icons.done_all),
                  label: const Text('تحديد/إلغاء الكل'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    context.read<TodoProvider>().clearCompleted();
                  },
                  icon: const Icon(Icons.delete_sweep),
                  label: const Text('مسح المنجزة'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Todo List
        Expanded(
          child: Consumer<TodoProvider>(
            builder: (context, todoProvider, child) {
              final todos = todoProvider.todos;
              
              if (todos.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.inbox_outlined,
                        size: 80,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        todoProvider.currentFilter == 'all'
                            ? 'لا توجد مهام'
                            : todoProvider.currentFilter == 'completed'
                                ? 'لا توجد مهام منجزة'
                                : 'لا توجد مهام معلقة',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                );
              }
              
              return ListView.builder(
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  final todo = todos[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    child: ListTile(
                      leading: Checkbox(
                        value: todo.isCompleted,
                        onChanged: (_) {
                          context.read<TodoProvider>().toggleTodo(todo.id);
                        },
                      ),
                      title: Text(
                        todo.title,
                        style: TextStyle(
                          decoration: todo.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                          color: todo.isCompleted
                              ? Colors.grey
                              : null,
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          context.read<TodoProvider>().removeTodo(todo.id);
                        },
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

// Statistics Card Widget
class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 32, color: color),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(title, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

// التاب الرابع: Shopping Cart
class _ShoppingCartTab extends StatelessWidget {
  const _ShoppingCartTab();
  
  static final List<Product> _products = [
    Product(id: '1', name: 'لابتوب', price: 3000, image: '💻'),
    Product(id: '2', name: 'هاتف', price: 2000, image: '📱'),
    Product(id: '3', name: 'سماعات', price: 500, image: '🎧'),
    Product(id: '4', name: 'ساعة ذكية', price: 800, image: '⌚'),
    Product(id: '5', name: 'كاميرا', price: 2500, image: '📷'),
    Product(id: '6', name: 'تابلت', price: 1500, image: '📱'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Cart Summary
        Consumer<ShoppingCartProvider>(
          builder: (context, cart, child) {
            return Container(
              padding: const EdgeInsets.all(16),
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.shopping_cart),
                      const SizedBox(width: 8),
                      Text(
                        'عدد المنتجات: ${cart.itemCount}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Text(
                    'الإجمالي: ${cart.totalAmount.toStringAsFixed(2)} ر.س',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        
        // Products Grid
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: _products.length,
            itemBuilder: (context, index) {
              final product = _products[index];
              return Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(product.image, style: const TextStyle(fontSize: 48)),
                    const SizedBox(height: 8),
                    Text(
                      product.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('${product.price} ر.س'),
                    const SizedBox(height: 8),
                    Consumer<ShoppingCartProvider>(
                      builder: (context, cart, child) {
                        final inCart = cart.items.containsKey(product.id);
                        return inCart
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove),
                                    onPressed: () {
                                      cart.decreaseQuantity(product.id);
                                    },
                                  ),
                                  Text(
                                    '${cart.items[product.id]!.quantity}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add),
                                    onPressed: () {
                                      cart.increaseQuantity(product.id);
                                    },
                                  ),
                                ],
                              )
                            : ElevatedButton.icon(
                                onPressed: () {
                                  cart.addItem(product);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('تمت إضافة ${product.name}'),
                                      duration: const Duration(seconds: 1),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.add_shopping_cart),
                                label: const Text('إضافة'),
                              );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        
        // Checkout Button
        Consumer<ShoppingCartProvider>(
          builder: (context, cart, child) {
            if (cart.itemCount == 0) return const SizedBox.shrink();
            
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('تأكيد الشراء'),
                            content: Text(
                              'هل تريد إتمام الشراء بمبلغ ${cart.totalAmount.toStringAsFixed(2)} ر.س؟',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('إلغاء'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  cart.clear();
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('تم الشراء بنجاح! 🎉'),
                                    ),
                                  );
                                },
                                child: const Text('تأكيد'),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: const Icon(Icons.payment),
                      label: const Text('إتمام الشراء'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton.icon(
                    onPressed: () => cart.clear(),
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('مسح الكل'),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

// التاب الخامس: Theme Switcher
class _ThemeSwitcherTab extends StatelessWidget {
  const _ThemeSwitcherTab();

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
                  'إدارة الثيم مع Provider',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                
                // Dark Mode Toggle
                Consumer<ThemeProvider>(
                  builder: (context, theme, child) {
                    return SwitchListTile(
                      title: const Text('الوضع الليلي'),
                      subtitle: Text(
                        theme.isDarkMode ? 'مفعّل' : 'معطّل',
                      ),
                      value: theme.isDarkMode,
                      onChanged: (_) => theme.toggleTheme(),
                      secondary: Icon(
                        theme.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Color Picker
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'اختيار اللون الأساسي',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                Consumer<ThemeProvider>(
                  builder: (context, theme, child) {
                    return Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _ColorOption(Colors.blue, theme),
                        _ColorOption(Colors.red, theme),
                        _ColorOption(Colors.green, theme),
                        _ColorOption(Colors.purple, theme),
                        _ColorOption(Colors.orange, theme),
                        _ColorOption(Colors.teal, theme),
                        _ColorOption(Colors.pink, theme),
                        _ColorOption(Colors.indigo, theme),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Preview
        Consumer<ThemeProvider>(
          builder: (context, theme, child) {
            return Card(
              color: theme.primaryColor.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'معاينة الثيم',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.primaryColor,
                      ),
                      child: const Text('زر بالّلون الأساسي'),
                    ),
                    const SizedBox(height: 8),
                    Text('الوضع: ${theme.isDarkMode ? "ليلي" : "نهاري"}'),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _ColorOption extends StatelessWidget {
  final Color color;
  final ThemeProvider theme;
  
  const _ColorOption(this.color, this.theme);

  @override
  Widget build(BuildContext context) {
    final isSelected = theme.primaryColor == color;
    return GestureDetector(
      onTap: () => theme.setPrimaryColor(color),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: isSelected
              ? Border.all(color: Colors.white, width: 4)
              : null,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.5),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: isSelected
            ? const Icon(Icons.check, color: Colors.white, size: 32)
            : null,
      ),
    );
  }
}

// التاب السادس: User Profile
class _UserProfileTab extends StatefulWidget {
  const _UserProfileTab();

  @override
  State<_UserProfileTab> createState() => _UserProfileTabState();
}

class _UserProfileTabState extends State<_UserProfileTab> {
  final _emailController = TextEditingController(text: 'user@example.com');
  final _passwordController = TextEditingController(text: 'password');
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        if (userProvider.isLoading) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('جاري التحميل...'),
              ],
            ),
          );
        }
        
        if (!userProvider.isLoggedIn) {
          return _buildLoginForm(context, userProvider);
        }
        
        return _buildProfile(context, userProvider);
      },
    );
  }
  
  Widget _buildLoginForm(BuildContext context, UserProvider userProvider) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Icon(Icons.account_circle, size: 100, color: Colors.blue),
        const SizedBox(height: 24),
        
        Text(
          'تسجيل الدخول',
          style: Theme.of(context).textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 32),
        
        TextField(
          controller: _emailController,
          decoration: const InputDecoration(
            labelText: 'البريد الإلكتروني',
            prefixIcon: Icon(Icons.email),
            border: OutlineInputBorder(),
          ),
        ),
        
        const SizedBox(height: 16),
        
        TextField(
          controller: _passwordController,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'كلمة المرور',
            prefixIcon: Icon(Icons.lock),
            border: OutlineInputBorder(),
          ),
        ),
        
        const SizedBox(height: 24),
        
        ElevatedButton.icon(
          onPressed: () {
            userProvider.login(
              _emailController.text,
              _passwordController.text,
            );
          },
          icon: const Icon(Icons.login),
          label: const Text('تسجيل الدخول'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }
  
  Widget _buildProfile(BuildContext context, UserProvider userProvider) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Text(
                  userProvider.user!.avatar,
                  style: const TextStyle(fontSize: 80),
                ),
                const SizedBox(height: 16),
                Text(
                  userProvider.user!.name,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  userProvider.user!.email,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'تحديث الملف الشخصي',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'الاسم الجديد',
                    border: OutlineInputBorder(),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                ElevatedButton.icon(
                  onPressed: () {
                    if (_nameController.text.isNotEmpty) {
                      userProvider.updateProfile(_nameController.text);
                      _nameController.clear();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('تم تحديث الملف الشخصي'),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.save),
                  label: const Text('حفظ التغييرات'),
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        ElevatedButton.icon(
          onPressed: () {
            userProvider.logout();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تم تسجيل الخروج بنجاح'),
              ),
            );
          },
          icon: const Icon(Icons.logout),
          label: const Text('تسجيل الخروج'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            padding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }
}

// ========== تابات جديدة ==========

// ProxyProvider Tab
class _ProxyProviderTab extends StatelessWidget {
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
                  '🔗 ProxyProvider',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                const Text(
                  'ProxyProvider يستخدم لإنشاء provider يعتمد على قيمة provider آخر.\n\n'
                  'في هذا المثال، DiscountCalculator يعتمد على CounterProvider.',
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Counter Display
        Card(
          color: Colors.blue.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  'عدد المنتجات في السلة',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                
                Consumer<CounterProvider>(
                  builder: (context, counter, _) {
                    return Column(
                      children: [
                        Text(
                          '${counter.count}',
                          style: const TextStyle(
                            fontSize: 64,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              onPressed: counter.count > 0 ? counter.decrement : null,
                              icon: const Icon(Icons.remove),
                              label: const Text('تقليل'),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton.icon(
                              onPressed: counter.increment,
                              icon: const Icon(Icons.add),
                              label: const Text('زيادة'),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Discount Display (uses ProxyProvider)
        Card(
          color: Colors.green.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  'الخصم المتاح',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                
                Consumer<DiscountCalculator>(
                  builder: (context, calculator, _) {
                    final totalPrice = 100.0; // سعر افتراضي للمنتج
                    final discount = calculator.calculateDiscount(totalPrice);
                    
                    return Column(
                      children: [
                        Text(
                          calculator.getDiscountMessage(),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        
                        if (discount > 0) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  const Text('السعر الأصلي'),
                                  Text(
                                    '${totalPrice.toStringAsFixed(2)} ر.س',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  const Text('الخصم'),
                                  Text(
                                    '-${discount.toStringAsFixed(2)} ر.س',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  const Text('السعر النهائي'),
                                  Text(
                                    '${(totalPrice - discount).toStringAsFixed(2)} ر.س',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Code Example
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
                      '// ProxyProvider يعتمد على CounterProvider\n'
                      'ProxyProvider<CounterProvider, DiscountCalculator>(\n'
                      '  update: (_, counter, __) => \n'
                      '    DiscountCalculator(counter.count),\n'
                      ')\n\n'
                      '// الاستخدام:\n'
                      'Consumer<DiscountCalculator>(\n'
                      '  builder: (context, calculator, _) {\n'
                      '    return Text(calculator.getDiscountMessage());\n'
                      '  },\n'
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

// FutureProvider Tab
class _FutureProviderTab extends StatelessWidget {
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
                  '⏳ FutureProvider',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                const Text(
                  'FutureProvider يستخدم لجلب بيانات غير متزامنة (Async Data) '
                  'مثل تحميل الإعدادات من API أو قاعدة بيانات.\n\n'
                  'يدير تلقائياً حالات: Loading, Success, Error',
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Settings Display
        Consumer<AppSettings>(
          builder: (context, settings, _) {
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'إعدادات التطبيق',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 24),
                    
                    ListTile(
                      leading: const Icon(Icons.language, color: Colors.blue),
                      title: const Text('اللغة'),
                      trailing: Text(
                        settings.language == 'ar' ? 'العربية' : 'English',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    
                    ListTile(
                      leading: Icon(
                        Icons.notifications,
                        color: settings.notifications ? Colors.green : Colors.grey,
                      ),
                      title: const Text('الإشعارات'),
                      trailing: Icon(
                        settings.notifications ? Icons.check_circle : Icons.cancel,
                        color: settings.notifications ? Colors.green : Colors.red,
                      ),
                    ),
                    
                    ListTile(
                      leading: const Icon(Icons.attach_money, color: Colors.orange),
                      title: const Text('العملة'),
                      trailing: Text(
                        settings.currency,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        
        const SizedBox(height: 16),
        
        // App Config (Provider)
        Consumer<AppConfig>(
          builder: (context, config, _) {
            return Card(
              color: Colors.purple.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'معلومات التطبيق (Provider)',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    ListTile(
                      leading: const Icon(Icons.app_settings_alt),
                      title: Text(config.appName),
                      trailing: Text('v${config.version}'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        
        const SizedBox(height: 16),
        
        // Code Example
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
                      '// FutureProvider للبيانات غير المتزامنة\n'
                      'FutureProvider<AppSettings>(\n'
                      '  create: (_) => SettingsService.fetchSettings(),\n'
                      '  initialData: AppSettings.initial(),\n'
                      ')\n\n'
                      '// Service Class\n'
                      'class SettingsService {\n'
                      '  static Future<AppSettings> fetchSettings() async {\n'
                      '    await Future.delayed(Duration(seconds: 2));\n'
                      '    return AppSettings(...);\n'
                      '  }\n'
                      '}\n\n'
                      '// الاستخدام:\n'
                      'Consumer<AppSettings>(\n'
                      '  builder: (context, settings, _) {\n'
                      '    return Text(settings.language);\n'
                      '  },\n'
                      ')',
                      style: TextStyle(
                        color: Colors.greenAccent,
                        fontFamily: 'monospace',
                        fontSize: 10,
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

// StreamProvider Tab
class _StreamProviderTab extends StatelessWidget {
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
                  '📡 StreamProvider',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                const Text(
                  'StreamProvider يستخدم للبيانات المتدفقة (Real-time Data) '
                  'مثل الساعة، الرسائل الفورية، تحديثات مباشرة.\n\n'
                  'يستمع تلقائياً للـ Stream ويحدث UI عند كل تغيير.',
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Live Clock
        Consumer<DateTime>(
          builder: (context, currentTime, _) {
            return Card(
              color: Colors.blue.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    const Icon(Icons.access_time, size: 64, color: Colors.blue),
                    const SizedBox(height: 16),
                    Text(
                      'الساعة الحية',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 24),
                    
                    Text(
                      '${currentTime.hour.toString().padLeft(2, '0')}:'
                      '${currentTime.minute.toString().padLeft(2, '0')}:'
                      '${currentTime.second.toString().padLeft(2, '0')}',
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'monospace',
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    Text(
                      '${currentTime.day}/${currentTime.month}/${currentTime.year}',
                      style: const TextStyle(fontSize: 20, color: Colors.grey),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.update, color: Colors.green),
                          SizedBox(width: 8),
                          Text('يتم التحديث كل ثانية'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        
        const SizedBox(height: 16),
        
        // Code Example
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
                      '// StreamProvider للبيانات المتدفقة\n'
                      'StreamProvider<DateTime>(\n'
                      '  create: (_) => Stream.periodic(\n'
                      '    Duration(seconds: 1),\n'
                      '    (_) => DateTime.now(),\n'
                      '  ),\n'
                      '  initialData: DateTime.now(),\n'
                      ')\n\n'
                      '// الاستخدام:\n'
                      'Consumer<DateTime>(\n'
                      '  builder: (context, currentTime, _) {\n'
                      '    return Text("\${currentTime.hour}:\${currentTime.minute}");\n'
                      '  },\n'
                      ')\n\n'
                      '// مثال آخر - Stream من قاعدة بيانات:\n'
                      'StreamProvider<List<Message>>(\n'
                      '  create: (_) => FirebaseFirestore\n'
                      '    .collection("messages")\n'
                      '    .snapshots()\n'
                      '    .map((snapshot) => snapshot.docs),\n'
                      '  initialData: [],\n'
                      ')',
                      style: TextStyle(
                        color: Colors.greenAccent,
                        fontFamily: 'monospace',
                        fontSize: 10,
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

// Comparison Tab
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
                  '📊 مقارنة أنواع Provider',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                
                _buildProviderType(
                  '1. Provider',
                  'للقيم الثابتة',
                  '• لا يتغير\n• مثل: Configuration, Services',
                  Colors.blue,
                  'Provider<AppConfig>(\n  create: (_) => AppConfig(),\n)',
                ),
                
                _buildProviderType(
                  '2. ChangeNotifierProvider',
                  'للحالات المتغيرة',
                  '• الأكثر استخداماً\n• يدعم notifyListeners()\n• مثل: Counter, Cart, Theme',
                  Colors.green,
                  'ChangeNotifierProvider(\n  create: (_) => CounterProvider(),\n)',
                ),
                
                _buildProviderType(
                  '3. FutureProvider',
                  'للبيانات غير المتزامنة',
                  '• تحميل لمرة واحدة\n• مثل: API calls, Database queries',
                  Colors.purple,
                  'FutureProvider<Settings>(\n  create: (_) => fetchSettings(),\n  initialData: Settings.initial(),\n)',
                ),
                
                _buildProviderType(
                  '4. StreamProvider',
                  'للبيانات المتدفقة',
                  '• تحديثات مستمرة\n• مثل: Real-time chat, Live data',
                  Colors.orange,
                  'StreamProvider<DateTime>(\n  create: (_) => Stream.periodic(...),\n  initialData: DateTime.now(),\n)',
                ),
                
                _buildProviderType(
                  '5. ProxyProvider',
                  'Provider يعتمد على آخر',
                  '• يقرأ من provider آخر\n• يعيد بناء عند تغيير المصدر',
                  Colors.red,
                  'ProxyProvider<A, B>(\n  update: (_, a, __) => B(a),\n)',
                ),
                
                _buildProviderType(
                  '6. ChangeNotifierProxyProvider',
                  'ChangeNotifier يعتمد على آخر',
                  '• مزيج من ChangeNotifier + Proxy\n• مثل: Cart يعتمد على User',
                  Colors.teal,
                  'ChangeNotifierProxyProvider<User, Cart>(\n  create: (_) => Cart(),\n  update: (_, user, cart) => cart!..updateUser(user),\n)',
                ),
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
                    const Icon(Icons.lightbulb, color: Colors.blue),
                    const SizedBox(width: 8),
                    Text(
                      'متى تستخدم كل نوع؟',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text('Provider → للقيم الثابتة التي لا تتغير'),
                const Text('ChangeNotifierProvider → للحالات التي تتغير (الأشهر)'),
                const Text('FutureProvider → لجلب بيانات من API لمرة واحدة'),
                const Text('StreamProvider → للبيانات التي تتغير باستمرار'),
                const Text('ProxyProvider → عندما يعتمد provider على آخر'),
                const Text('ChangeNotifierProxyProvider → نفس ProxyProvider لكن مع ChangeNotifier'),
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
                Row(
                  children: [
                    const Icon(Icons.tips_and_updates, color: Colors.green),
                    const SizedBox(width: 8),
                    Text(
                      'نصائح مهمة',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text('✓ استخدم Consumer للاستماع في جزء محدد من UI'),
                const Text('✓ استخدم context.watch للاستماع في build method'),
                const Text('✓ استخدم context.read للقراءة بدون استماع (مثل: في onPressed)'),
                const Text('✓ استخدم Selector لتحسين الأداء (استمع لجزء محدد فقط)'),
                const Text('✓ MultiProvider لتنظيم عدة providers'),
              ],
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildProviderType(
    String title,
    String subtitle,
    String details,
    Color color,
    String code,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            details,
            style: TextStyle(
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              code,
              style: const TextStyle(
                color: Colors.greenAccent,
                fontFamily: 'monospace',
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
