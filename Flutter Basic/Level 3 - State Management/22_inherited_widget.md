# 22 - InheritedWidget - مشاركة البيانات

## 📋 المحتويات

- [22 - InheritedWidget - مشاركة البيانات](#22---inheritedwidget---مشاركة-البيانات)
  - [📋 المحتويات](#-المحتويات)
  - [🎯 المقدمة](#-المقدمة)
  - [🔗 InheritedWidget الأساسي](#-inheritedwidget-الأساسي)
  - [🔔 InheritedNotifier](#-inheritednotifier)
  - [📦 Provider Pattern](#-provider-pattern)
  - [💼 أمثلة عملية](#-أمثلة-عملية)
    - [نظام المصادقة](#نظام-المصادقة)
    - [نظام السلة](#نظام-السلة)
  - [📚 المراجع والمصادر](#-المراجع-والمصادر)
  - [💡 نصائح](#-نصائح)

---

## 🎯 المقدمة

InheritedWidget يسمح بمشاركة البيانات عبر الـ Widget tree دون تمريرها يدوياً.

---

## 🔗 InheritedWidget الأساسي

إنشاء InheritedWidget:

```dart
class UserData extends InheritedWidget {
  final String userName;
  final String email;

  const UserData({
    super.key,
    required this.userName,
    required this.email,
    required super.child,
  });

  static UserData? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<UserData>();
  }

  @override
  bool updateShouldNotify(UserData oldWidget) {
    return userName != oldWidget.userName || email != oldWidget.email;
  }
}

// الاستخدام
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return UserData(
      userName: 'أحمد محمد',
      email: 'ahmed@example.com',
      child: MaterialApp(
        home: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userData = UserData.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('الرئيسية')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('اسم المستخدم: ${userData?.userName}'),
            Text('البريد: ${userData?.email}'),
          ],
        ),
      ),
    );
  }
}
```

---

## 🔔 InheritedNotifier

InheritedWidget مع ChangeNotifier:

```dart
class CounterNotifier extends ChangeNotifier {
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

class CounterProvider extends InheritedNotifier<CounterNotifier> {
  const CounterProvider({
    super.key,
    required CounterNotifier counter,
    required super.child,
  }) : super(notifier: counter);

  static CounterNotifier of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<CounterProvider>()!
        .notifier!;
  }
}

// الاستخدام
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final CounterNotifier _counter = CounterNotifier();

  @override
  void dispose() {
    _counter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CounterProvider(
      counter: _counter,
      child: MaterialApp(
        home: const CounterPage(),
      ),
    );
  }
}

class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final counter = CounterProvider.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('العداد')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('العدد:', style: TextStyle(fontSize: 24)),
            Text(
              '${counter.count}',
              style: const TextStyle(fontSize: 72, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: counter.increment,
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            onPressed: counter.decrement,
            child: const Icon(Icons.remove),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            onPressed: counter.reset,
            child: const Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }
}
```

---

## 📦 Provider Pattern

نمط Provider مخصص:

```dart
class AppState extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  String _language = 'ar';

  ThemeMode get themeMode => _themeMode;
  String get language => _language;

  void toggleTheme() {
    _themeMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void changeLanguage(String newLanguage) {
    _language = newLanguage;
    notifyListeners();
  }
}

class AppStateProvider extends InheritedNotifier<AppState> {
  const AppStateProvider({
    super.key,
    required AppState appState,
    required super.child,
  }) : super(notifier: appState);

  static AppState of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<AppStateProvider>()!
        .notifier!;
  }
}

// الاستخدام
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppState _appState = AppState();

  @override
  void dispose() {
    _appState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppStateProvider(
      appState: _appState,
      child: Builder(
        builder: (context) {
          final appState = AppStateProvider.of(context);
          
          return MaterialApp(
            themeMode: appState.themeMode,
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            home: const SettingsPage(),
          );
        },
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppStateProvider.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('الإعدادات')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('الوضع الداكن'),
            value: appState.themeMode == ThemeMode.dark,
            onChanged: (_) => appState.toggleTheme(),
          ),
          ListTile(
            title: const Text('اللغة'),
            subtitle: Text(appState.language == 'ar' ? 'العربية' : 'English'),
            trailing: DropdownButton<String>(
              value: appState.language,
              items: const [
                DropdownMenuItem(value: 'ar', child: Text('العربية')),
                DropdownMenuItem(value: 'en', child: Text('English')),
              ],
              onChanged: (value) {
                if (value != null) {
                  appState.changeLanguage(value);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
```

---

## 💼 أمثلة عملية

### نظام المصادقة

```dart
class AuthUser {
  final String id;
  final String name;
  final String email;

  AuthUser({required this.id, required this.name, required this.email});
}

class AuthState extends ChangeNotifier {
  AuthUser? _user;
  bool _isLoading = false;

  AuthUser? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isLoading => _isLoading;

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    _user = AuthUser(
      id: '123',
      name: 'أحمد محمد',
      email: email,
    );
    _isLoading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    _user = null;
    notifyListeners();
  }
}

class AuthProvider extends InheritedNotifier<AuthState> {
  const AuthProvider({
    super.key,
    required AuthState auth,
    required super.child,
  }) : super(notifier: auth);

  static AuthState of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<AuthProvider>()!
        .notifier!;
  }
}

// شاشة تسجيل الدخول
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = AuthProvider.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('تسجيل الدخول')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'البريد الإلكتروني',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'كلمة المرور',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: auth.isLoading
                  ? null
                  : () async {
                      await auth.login(
                        _emailController.text,
                        _passwordController.text,
                      );
                      if (auth.isAuthenticated && mounted) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(),
                          ),
                        );
                      }
                    },
              child: auth.isLoading
                  ? const CircularProgressIndicator()
                  : const Text('تسجيل الدخول'),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthProvider.of(context);
    final user = auth.user!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('الرئيسية'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await auth.logout();
              if (context.mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              child: Text(
                user.name[0],
                style: const TextStyle(fontSize: 40),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'مرحباً ${user.name}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              user.email,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
```

### نظام السلة

```dart
class CartItem {
  final String id;
  final String name;
  final double price;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    this.quantity = 1,
  });

  double get total => price * quantity;
}

class CartState extends ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};

  int get itemCount => _items.length;

  double get totalAmount {
    return _items.values.fold(0, (sum, item) => sum + item.total);
  }

  void addItem(String productId, String name, double price) {
    if (_items.containsKey(productId)) {
      _items[productId]!.quantity++;
    } else {
      _items[productId] = CartItem(
        id: productId,
        name: name,
        price: price,
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void updateQuantity(String productId, int quantity) {
    if (_items.containsKey(productId)) {
      if (quantity <= 0) {
        _items.remove(productId);
      } else {
        _items[productId]!.quantity = quantity;
      }
      notifyListeners();
    }
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}

class CartProvider extends InheritedNotifier<CartState> {
  const CartProvider({
    super.key,
    required CartState cart,
    required super.child,
  }) : super(notifier: cart);

  static CartState of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<CartProvider>()!
        .notifier!;
  }
}

// شاشة المنتجات
class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = CartProvider.of(context);

    final products = [
      {'id': '1', 'name': 'هاتف ذكي', 'price': 2999.0},
      {'id': '2', 'name': 'حقيبة', 'price': 299.0},
      {'id': '3', 'name': 'ساعة ذكية', 'price': 899.0},
    ];

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
              if (cart.itemCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${cart.itemCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text(product['name'] as String),
              subtitle: Text('${product['price']} ريال'),
              trailing: ElevatedButton(
                onPressed: () {
                  cart.addItem(
                    product['id'] as String,
                    product['name'] as String,
                    product['price'] as double,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('تمت إضافة ${product['name']} للسلة'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
                child: const Text('إضافة'),
              ),
            ),
          );
        },
      ),
    );
  }
}

// شاشة السلة
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = CartProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('السلة'),
        actions: [
          if (cart.itemCount > 0)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: () {
                cart.clear();
              },
            ),
        ],
      ),
      body: cart.itemCount == 0
          ? const Center(child: Text('السلة فارغة'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      final item = cart.items.values.toList()[index];
                      return Card(
                        margin: const EdgeInsets.all(8),
                        child: ListTile(
                          title: Text(item.name),
                          subtitle: Text('${item.price} ريال × ${item.quantity}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () {
                                  cart.updateQuantity(
                                    item.id,
                                    item.quantity - 1,
                                  );
                                },
                              ),
                              Text('${item.quantity}'),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  cart.updateQuantity(
                                    item.id,
                                    item.quantity + 1,
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => cart.removeItem(item.id),
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('الإجمالي:'),
                          Text(
                            '${cart.totalAmount.toStringAsFixed(2)} ريال',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                        ),
                        child: const Text('إتمام الطلب'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
```

---

## 📚 المراجع والمصادر

1. **InheritedWidget**
   - [InheritedWidget](https://api.flutter.dev/flutter/widgets/InheritedWidget-class.html)
   - [InheritedNotifier](https://api.flutter.dev/flutter/widgets/InheritedNotifier-class.html)

2. **State Management**
   - [State Management Approaches](https://docs.flutter.dev/data-and-backend/state-mgmt/options)
   - [Simple App State](https://docs.flutter.dev/data-and-backend/state-mgmt/simple)

3. **ChangeNotifier**
   - [ChangeNotifier](https://api.flutter.dev/flutter/foundation/ChangeNotifier-class.html)

---

## 💡 نصائح

- ✅ InheritedWidget لمشاركة البيانات الثابتة
- ✅ InheritedNotifier للبيانات المتغيرة
- ✅ استخدم `dependOnInheritedWidgetOfExactType` للتحديثات التلقائية
- ✅ `updateShouldNotify` للتحكم في التحديثات
- ✅ في التطبيقات الكبيرة، استخدم Provider package

---

[⬅️ السابق: State Management](21_state_management.md)
[🏠 العودة للفهرس](../README.md)
[التالي: Provider ➡️](23_provider.md)
