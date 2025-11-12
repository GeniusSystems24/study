# 17 - Navigation والتنقل بين الشاشات

## 📋 المحتويات

- [المقدمة](#المقدمة)
- [Navigator الأساسي](#navigator-الأساسي)
- [Named Routes](#named-routes)
- [تمرير البيانات](#تمرير-البيانات)
- [Navigation 2.0](#navigation-20)
- [أمثلة عملية](#أمثلة-عملية)

---

## 🎯 المقدمة

Navigation في Flutter يدير التنقل بين الشاشات (Routes) باستخدام نظام Stack.

---

## 🧭 Navigator الأساسي

### الانتقال إلى شاشة جديدة

```dart
// الانتقال إلى شاشة جديدة
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const SecondScreen()),
);

// العودة للشاشة السابقة
Navigator.pop(context);
```

### مثال كامل

```dart
// الشاشة الأولى
class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الشاشة الأولى')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SecondScreen(),
              ),
            );
          },
          child: const Text('انتقل إلى الشاشة الثانية'),
        ),
      ),
    );
  }
}

// الشاشة الثانية
class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الشاشة الثانية')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('العودة'),
        ),
      ),
    );
  }
}
```

---

## 🏷️ Named Routes

تعريف المسارات في التطبيق:

```dart
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navigation Demo',
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/second': (context) => const SecondScreen(),
        '/third': (context) => const ThirdScreen(),
      },
    );
  }
}

// استخدام Named Routes
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الرئيسية')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/second');
          },
          child: const Text('انتقل إلى الشاشة الثانية'),
        ),
      ),
    );
  }
}
```

### مسارات ديناميكية

```dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: (settings) {
        if (settings.name == '/user') {
          final userId = settings.arguments as int;
          return MaterialPageRoute(
            builder: (context) => UserScreen(userId: userId),
          );
        }
        return null;
      },
    );
  }
}

// الاستخدام
Navigator.pushNamed(
  context,
  '/user',
  arguments: 123,
);
```

---

## 📦 تمرير البيانات

### تمرير البيانات عند الانتقال

```dart
class User {
  final String name;
  final int age;
  
  User({required this.name, required this.age});
}

// الشاشة الأولى - إرسال البيانات
class SendDataScreen extends StatelessWidget {
  const SendDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إرسال البيانات')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            final user = User(name: 'أحمد', age: 25);
            
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ReceiveDataScreen(user: user),
              ),
            );
          },
          child: const Text('إرسال البيانات'),
        ),
      ),
    );
  }
}

// الشاشة الثانية - استقبال البيانات
class ReceiveDataScreen extends StatelessWidget {
  final User user;
  
  const ReceiveDataScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('استقبال البيانات')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('الاسم: ${user.name}', style: const TextStyle(fontSize: 20)),
            Text('العمر: ${user.age}', style: const TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
```

### إرجاع البيانات

```dart
// الشاشة الأولى - انتظار النتيجة
class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الشاشة الأولى')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final result = await Navigator.push<String>(
              context,
              MaterialPageRoute(
                builder: (context) => const SelectionScreen(),
              ),
            );
            
            if (result != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('اخترت: $result')),
              );
            }
          },
          child: const Text('اختر خياراً'),
        ),
      ),
    );
  }
}

// شاشة الاختيار - إرجاع النتيجة
class SelectionScreen extends StatelessWidget {
  const SelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('اختر')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, 'الخيار الأول');
              },
              child: const Text('الخيار الأول'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, 'الخيار الثاني');
              },
              child: const Text('الخيار الثاني'),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 🚀 Navigation 2.0

### Router مع Go Router

```dart
import 'package:go_router/go_router.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/details/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return DetailsScreen(id: id);
      },
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
    );
  }
}

// الاستخدام
context.go('/details/123');
```

---

## 💼 أمثلة عملية

### نظام تنقل متقدم

```dart
class NavigationExample extends StatelessWidget {
  const NavigationExample({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navigation Demo',
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/products': (context) => const ProductsPage(),
        '/cart': (context) => const CartPage(),
        '/profile': (context) => const ProfilePage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/product-details') {
          final product = settings.arguments as Product;
          return MaterialPageRoute(
            builder: (context) => ProductDetailsPage(product: product),
          );
        }
        return null;
      },
    );
  }
}

class Product {
  final int id;
  final String name;
  final double price;

  Product({required this.id, required this.name, required this.price});
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الرئيسية')),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        children: [
          _buildNavigationCard(
            context,
            'المنتجات',
            Icons.shopping_bag,
            Colors.blue,
            '/products',
          ),
          _buildNavigationCard(
            context,
            'السلة',
            Icons.shopping_cart,
            Colors.green,
            '/cart',
          ),
          _buildNavigationCard(
            context,
            'الملف الشخصي',
            Icons.person,
            Colors.orange,
            '/profile',
          ),
          _buildNavigationCard(
            context,
            'الإعدادات',
            Icons.settings,
            Colors.purple,
            '/settings',
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    String route,
  ) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, route),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: color),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final products = [
      Product(id: 1, name: 'منتج 1', price: 99.99),
      Product(id: 2, name: 'منتج 2', price: 149.99),
      Product(id: 3, name: 'منتج 3', price: 199.99),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('المنتجات')),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ListTile(
            title: Text(product.name),
            subtitle: Text('${product.price} ريال'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/product-details',
                arguments: product,
              );
            },
          );
        },
      ),
    );
  }
}

class ProductDetailsPage extends StatelessWidget {
  final Product product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              color: Colors.grey.shade300,
              child: const Center(
                child: Icon(Icons.image, size: 100),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              product.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${product.price} ريال',
              style: const TextStyle(
                fontSize: 20,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'وصف المنتج هنا...',
              style: TextStyle(fontSize: 16),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () async {
                final result = await Navigator.pushNamed(context, '/cart');
                if (result != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تمت الإضافة للسلة')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text('أضف إلى السلة'),
            ),
          ],
        ),
      ),
    );
  }
}

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('السلة')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('السلة فارغة'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/products');
              },
              child: const Text('تصفح المنتجات'),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الملف الشخصي')),
      body: ListView(
        children: [
          const UserAccountsDrawerHeader(
            accountName: Text('أحمد محمد'),
            accountEmail: Text('ahmed@example.com'),
            currentAccountPicture: CircleAvatar(
              child: Icon(Icons.person, size: 50),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.shopping_bag),
            title: const Text('طلباتي'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text('المفضلة'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('الإعدادات'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('تسجيل الخروج'),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('تأكيد'),
                  content: const Text('هل تريد تسجيل الخروج؟'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('إلغاء'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/',
                          (route) => false,
                        );
                      },
                      child: const Text('تسجيل الخروج'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
```

---

## 📚 المراجع والمصادر

1. **Navigator**
   - [Navigator](https://api.flutter.dev/flutter/widgets/Navigator-class.html)
   - [Navigation Basics](https://docs.flutter.dev/cookbook/navigation/navigation-basics)

2. **Named Routes**
   - [Named Routes](https://docs.flutter.dev/cookbook/navigation/named-routes)
   - [Routes and Navigation](https://docs.flutter.dev/development/ui/navigation)

3. **Data Passing**
   - [Pass Arguments](https://docs.flutter.dev/cookbook/navigation/navigate-with-arguments)
   - [Return Data](https://docs.flutter.dev/cookbook/navigation/returning-data)

4. **Navigation 2.0**
   - [Go Router](https://pub.dev/packages/go_router)
   - [Navigation 2.0](https://docs.flutter.dev/development/ui/navigation/deep-linking)

---

## 💡 نصائح

- ✅ استخدم Named Routes للتطبيقات الكبيرة
- ✅ `pushReplacement` لتجنب العودة للشاشة السابقة
- ✅ `pushAndRemoveUntil` لإعادة تعيين Stack التنقل
- ✅ استخدم `WillPopScope` للتحكم في زر الرجوع
- ✅ Go Router ممتاز للتطبيقات المعقدة

---

[⬅️ السابق: Dialog و SnackBar](16_dialog_snackbar.md)
[🏠 العودة للفهرس](../README.md)
[التالي: Animation ➡️](18_animation.md)
