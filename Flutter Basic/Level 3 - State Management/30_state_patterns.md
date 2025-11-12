# 30 - أنماط وأفضل الممارسات في إدارة الحالة

## 📋 المحتويات

- [المقدمة](#المقدمة)
- [الأنماط العامة](#الأنماط-العامة)
- [أفضل الممارسات](#أفضل-الممارسات)
- [الأخطاء الشائعة](#الأخطاء-الشائعة)
- [نصائح الأداء](#نصائح-الأداء)

---

## 🎯 المقدمة

هذا الملف يجمع أفضل الممارسات والأنماط الشائعة في إدارة الحالة بغض النظر عن الحل المستخدم.

---

## 🏛️ الأنماط العامة

### 1. فصل UI عن Business Logic

**❌ سيء:**

```dart
class ProductScreen extends StatefulWidget {
  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  List<Product> products = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    setState(() => isLoading = true);
    try {
      final response = await http.get(Uri.parse('api/products'));
      final data = json.decode(response.body);
      setState(() {
        products = data.map((e) => Product.fromJson(e)).toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // UI code...
  }
}
```

**✅ جيد:**

```dart
// Business Logic
class ProductRepository {
  Future<List<Product>> getProducts() async {
    final response = await http.get(Uri.parse('api/products'));
    final data = json.decode(response.body);
    return data.map((e) => Product.fromJson(e)).toList();
  }
}

class ProductNotifier extends ChangeNotifier {
  final ProductRepository repository;
  
  List<Product> products = [];
  bool isLoading = false;
  String? error;

  ProductNotifier(this.repository);

  Future<void> loadProducts() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      products = await repository.getProducts();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}

// UI
class ProductScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProductNotifier>(
      builder: (context, notifier, child) {
        if (notifier.isLoading) {
          return CircularProgressIndicator();
        }
        // UI code...
      },
    );
  }
}
```

---

### 2. نمط Repository

**الفوائد:**

- فصل منطق البيانات
- سهولة Testing
- إمكانية تبديل مصدر البيانات

```dart
// Domain Model
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

// Repository Interface
abstract class ProductRepository {
  Future<List<Product>> getProducts();
  Future<Product> getProductById(String id);
  Future<void> addProduct(Product product);
}

// API Implementation
class ApiProductRepository implements ProductRepository {
  final http.Client client;

  ApiProductRepository(this.client);

  @override
  Future<List<Product>> getProducts() async {
    final response = await client.get(Uri.parse('api/products'));
    // Parse and return
  }

  // Other methods...
}

// Local Implementation (for testing or offline)
class LocalProductRepository implements ProductRepository {
  final List<Product> _products = [];

  @override
  Future<List<Product>> getProducts() async {
    return _products;
  }

  // Other methods...
}
```

---

### 3. نمط MVVM (Model-View-ViewModel)

```dart
// Model
class User {
  final String id;
  final String name;
  final String email;

  User({required this.id, required this.name, required this.email});
}

// ViewModel
class UserViewModel extends ChangeNotifier {
  final UserRepository repository;

  User? _user;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;

  UserViewModel(this.repository);

  Future<void> loadUser(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _user = await repository.getUserById(id);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateUser(User user) async {
    try {
      await repository.updateUser(user);
      _user = user;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}

// View
class UserProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserViewModel(UserRepository()),
      child: Consumer<UserViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return CircularProgressIndicator();
          }

          if (viewModel.error != null) {
            return Text('Error: ${viewModel.error}');
          }

          return UserProfile(user: viewModel.user);
        },
      ),
    );
  }
}
```

---

### 4. نمط Service Locator

```dart
// باستخدام get_it
final getIt = GetIt.instance;

void setupLocator() {
  // Services
  getIt.registerLazySingleton(() => AuthService());
  getIt.registerLazySingleton(() => ApiService());
  
  // Repositories
  getIt.registerLazySingleton<ProductRepository>(
    () => ApiProductRepository(getIt<ApiService>()),
  );
  
  // ViewModels
  getIt.registerFactory(
    () => ProductViewModel(getIt<ProductRepository>()),
  );
}

// في main.dart
void main() {
  setupLocator();
  runApp(MyApp());
}

// في الـ UI
class ProductScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<ProductViewModel>(),
      child: ProductView(),
    );
  }
}
```

---

## ✅ أفضل الممارسات

### 1. استخدم Immutable State

**❌ سيء:**

```dart
class AppState {
  List<String> items = [];
  
  void addItem(String item) {
    items.add(item); // تعديل مباشر
  }
}
```

**✅ جيد:**

```dart
class AppState {
  final List<String> items;

  AppState({required this.items});

  AppState copyWith({List<String>? items}) {
    return AppState(items: items ?? this.items);
  }

  AppState addItem(String item) {
    return copyWith(items: [...items, item]);
  }
}
```

---

### 2. تجنب الحالة العالمية الزائدة

**❌ سيء:**

```dart
class GlobalState {
  String userName = '';
  int counter = 0;
  bool isDarkMode = false;
  String currentScreen = '';
  int selectedTab = 0;
  // كل شيء في مكان واحد!
}
```

**✅ جيد:**

```dart
// فصل الحالات حسب الوظيفة
class AuthState {
  final String? userName;
  AuthState({this.userName});
}

class ThemeState {
  final bool isDarkMode;
  ThemeState({required this.isDarkMode});
}

class NavigationState {
  final int selectedTab;
  NavigationState({required this.selectedTab});
}
```

---

### 3. استخدم const حيثما أمكن

**✅ جيد:**

```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CounterModel>(
      builder: (context, counter, child) {
        return Column(
          children: [
            // هذا الـ widget لا يتغير
            const Text('العدد الحالي:'),
            // هذا يتغير
            Text('${counter.value}'),
            // هذا ثابت
            child!,
          ],
        );
      },
      child: const Text('This never changes'),
    );
  }
}
```

---

### 4. استخدم Selector للتحديثات الدقيقة

**❌ سيء:**

```dart
Consumer<ShopModel>(
  builder: (context, shop, child) {
    return Text('${shop.totalItems}'); // يعيد البناء لأي تغيير
  },
)
```

**✅ جيد:**

```dart
Selector<ShopModel, int>(
  selector: (context, shop) => shop.totalItems,
  builder: (context, totalItems, child) {
    return Text('$totalItems'); // يعيد البناء فقط عند تغيير totalItems
  },
)
```

---

### 5. معالجة الأخطاء بشكل صحيح

```dart
class ProductViewModel extends ChangeNotifier {
  ProductState _state = ProductState.initial();
  ProductState get state => _state;

  Future<void> loadProducts() async {
    _state = ProductState.loading();
    notifyListeners();

    try {
      final products = await repository.getProducts();
      _state = ProductState.loaded(products);
    } on NetworkException catch (e) {
      _state = ProductState.error('خطأ في الاتصال: ${e.message}');
    } on ServerException catch (e) {
      _state = ProductState.error('خطأ في الخادم: ${e.message}');
    } catch (e) {
      _state = ProductState.error('خطأ غير متوقع');
    } finally {
      notifyListeners();
    }
  }
}

// في الـ UI
if (state is ProductLoading) {
  return CircularProgressIndicator();
} else if (state is ProductError) {
  return ErrorWidget(message: state.message);
} else if (state is ProductLoaded) {
  return ProductList(products: state.products);
}
```

---

### 6. استخدم State Classes

```dart
// بدلاً من متغيرات متعددة
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final User user;
  AuthAuthenticated(this.user);
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

// في الـ ViewModel
class AuthViewModel extends ChangeNotifier {
  AuthState _state = AuthInitial();
  AuthState get state => _state;

  Future<void> login(String email, String password) async {
    _state = AuthLoading();
    notifyListeners();

    try {
      final user = await authService.login(email, password);
      _state = AuthAuthenticated(user);
    } catch (e) {
      _state = AuthError(e.toString());
    }
    notifyListeners();
  }
}
```

---

## ❌ الأخطاء الشائعة

### 1. نسيان dispose

**❌ سيء:**

```dart
class MyController extends ChangeNotifier {
  final StreamController<int> _controller = StreamController<int>();
  
  Stream<int> get stream => _controller.stream;
}
```

**✅ جيد:**

```dart
class MyController extends ChangeNotifier {
  final StreamController<int> _controller = StreamController<int>();
  
  Stream<int> get stream => _controller.stream;

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }
}
```

---

### 2. Rebuild غير ضروري

**❌ سيء:**

```dart
class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartModel>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart (${cart.itemCount})'), // rebuild كل Cart
      ),
      body: ListView(/* items */),
    );
  }
}
```

**✅ جيد:**

```dart
class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<CartModel>(
          builder: (context, cart, child) {
            return Text('Cart (${cart.itemCount})'); // rebuild العنوان فقط
          },
        ),
      ),
      body: ListView(/* items */),
    );
  }
}
```

---

### 3. استخدام context.read في build

**❌ سيء:**

```dart
@override
Widget build(BuildContext context) {
  final counter = context.read<CounterModel>().value; // لن يعيد البناء!
  return Text('$counter');
}
```

**✅ جيد:**

```dart
@override
Widget build(BuildContext context) {
  final counter = context.watch<CounterModel>().value; // يعيد البناء
  return Text('$counter');
}
```

---

### 4. تعقيد الحالة غير الضروري

**❌ سيء:**

```dart
// لعداد بسيط!
class CounterBloc extends Bloc<CounterEvent, CounterState> {
  // الكثير من الكود لمجرد عداد
}
```

**✅ جيد:**

```dart
// لعداد بسيط
class CounterNotifier extends ChangeNotifier {
  int _count = 0;
  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }
}
```

---

## ⚡ نصائح الأداء

### 1. استخدم const Widgets

```dart
const Card(
  child: const Padding(
    padding: const EdgeInsets.all(8.0),
    child: const Text('مرحباً'),
  ),
)
```

---

### 2. تجنب إنشاء Widgets جديدة في build

**❌ سيء:**

```dart
@override
Widget build(BuildContext context) {
  return ListView.builder(
    itemBuilder: (context, index) {
      return ProductCard(
        product: products[index],
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => DetailScreen()),
          );
        },
      );
    },
  );
}
```

**✅ جيد:**

```dart
void _navigateToDetail() {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => DetailScreen()),
  );
}

@override
Widget build(BuildContext context) {
  return ListView.builder(
    itemBuilder: (context, index) {
      return ProductCard(
        product: products[index],
        onTap: _navigateToDetail,
      );
    },
  );
}
```

---

### 3. استخدم ListView.builder للقوائم الطويلة

**❌ سيء:**

```dart
ListView(
  children: products.map((p) => ProductCard(p)).toList(),
)
```

**✅ جيد:**

```dart
ListView.builder(
  itemCount: products.length,
  itemBuilder: (context, index) => ProductCard(products[index]),
)
```

---

### 4. Lazy Loading للبيانات

```dart
class ProductViewModel extends ChangeNotifier {
  final List<Product> _products = [];
  bool _isLoadingMore = false;
  int _page = 1;

  List<Product> get products => _products;
  bool get isLoadingMore => _isLoadingMore;

  Future<void> loadMore() async {
    if (_isLoadingMore) return;

    _isLoadingMore = true;
    notifyListeners();

    final newProducts = await repository.getProducts(page: _page);
    _products.addAll(newProducts);
    _page++;

    _isLoadingMore = false;
    notifyListeners();
  }
}

// في الـ UI
ListView.builder(
  controller: scrollController,
  itemCount: products.length + 1,
  itemBuilder: (context, index) {
    if (index == products.length) {
      if (viewModel.isLoadingMore) {
        return CircularProgressIndicator();
      }
      return SizedBox.shrink();
    }
    return ProductCard(products[index]);
  },
)
```

---

### 5. Debounce للبحث

```dart
class SearchViewModel extends ChangeNotifier {
  Timer? _debounce;
  List<Product> _results = [];

  List<Product> get results => _results;

  void search(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      _results = await repository.search(query);
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
```

---

## 📚 المراجع والمصادر

1. **Flutter Documentation**
   - [State Management](https://flutter.dev/docs/development/data-and-backend/state-mgmt)
   - [Performance Best Practices](https://flutter.dev/docs/perf/rendering/best-practices)

2. **Design Patterns**
   - Clean Architecture
   - MVVM Pattern
   - Repository Pattern

---

## 💡 نصائح ختامية

- ✅ **ابدأ بسيط**: لا تعقد الأمور من البداية
- ✅ **فصل المسؤوليات**: UI منفصل عن Business Logic
- ✅ **اختبر كودك**: State Management يسهل الاختبار
- ✅ **استخدم const**: تحسين الأداء
- ✅ **نظف الموارد**: dispose دائماً
- ✅ **تعامل مع الأخطاء**: لا تتجاهلها
- ✅ **وثق كودك**: اشرح القرارات المعقدة
- ✅ **راجع الأداء**: استخدم DevTools

---

[⬅️ السابق: مقارنة حلول State](29_state_comparison.md)
[🏠 العودة للفهرس](../README.md)
[التالي: HTTP و API ➡️](../Level%204%20-%20Advanced%20Topics/31_http_api.md)
