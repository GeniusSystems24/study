# 39 - الاختبارات - Testing

## 📋 المحتويات

- [المقدمة](#المقدمة)
- [Unit Testing](#unit-testing)
- [Widget Testing](#widget-testing)
- [Integration Testing](#integration-testing)
- [أفضل الممارسات](#أفضل-الممارسات)

---

## 🎯 المقدمة

الاختبارات تضمن جودة الكود وتكتشف الأخطاء مبكراً.

**أنواع الاختبارات:**
- **Unit Tests**: اختبار وحدات الكود (Functions, Classes)
- **Widget Tests**: اختبار الواجهات
- **Integration Tests**: اختبار التطبيق الكامل

---

## 🧪 Unit Testing

### الإعداد

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  mockito: ^5.4.4
  build_runner: ^2.4.6
```

---

### اختبار Functions

```dart
// lib/utils/calculator.dart
class Calculator {
  int add(int a, int b) => a + b;
  int subtract(int a, int b) => a - b;
  int multiply(int a, int b) => a * b;
  double divide(int a, int b) {
    if (b == 0) throw ArgumentError('Cannot divide by zero');
    return a / b;
  }
}

// test/utils/calculator_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:your_app/utils/calculator.dart';

void main() {
  group('Calculator Tests', () {
    late Calculator calculator;

    setUp(() {
      calculator = Calculator();
    });

    test('adds two numbers correctly', () {
      expect(calculator.add(2, 3), 5);
      expect(calculator.add(-1, 1), 0);
    });

    test('subtracts two numbers correctly', () {
      expect(calculator.subtract(5, 3), 2);
      expect(calculator.subtract(1, 5), -4);
    });

    test('multiplies two numbers correctly', () {
      expect(calculator.multiply(2, 3), 6);
      expect(calculator.multiply(-2, 3), -6);
    });

    test('divides two numbers correctly', () {
      expect(calculator.divide(6, 2), 3.0);
      expect(calculator.divide(5, 2), 2.5);
    });

    test('throws error when dividing by zero', () {
      expect(
        () => calculator.divide(5, 0),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
```

---

### اختبار Models

```dart
// lib/models/user.dart
class User {
  final String id;
  final String name;
  final String email;

  User({required this.id, required this.name, required this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }
}

// test/models/user_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:your_app/models/user.dart';

void main() {
  group('User Model Tests', () {
    test('creates User from JSON', () {
      final json = {
        'id': '1',
        'name': 'محمد',
        'email': 'mohamed@test.com',
      };

      final user = User.fromJson(json);

      expect(user.id, '1');
      expect(user.name, 'محمد');
      expect(user.email, 'mohamed@test.com');
    });

    test('converts User to JSON', () {
      final user = User(
        id: '1',
        name: 'محمد',
        email: 'mohamed@test.com',
      );

      final json = user.toJson();

      expect(json['id'], '1');
      expect(json['name'], 'محمد');
      expect(json['email'], 'mohamed@test.com');
    });
  });
}
```

---

### اختبار مع Mocking

```dart
// lib/services/api_service.dart
abstract class ApiService {
  Future<List<User>> getUsers();
}

class RealApiService implements ApiService {
  @override
  Future<List<User>> getUsers() async {
    // API call
  }
}

// lib/repositories/user_repository.dart
class UserRepository {
  final ApiService apiService;

  UserRepository(this.apiService);

  Future<List<User>> fetchUsers() async {
    return await apiService.getUsers();
  }
}

// test/repositories/user_repository_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([ApiService])
import 'user_repository_test.mocks.dart';

void main() {
  group('UserRepository Tests', () {
    late MockApiService mockApiService;
    late UserRepository repository;

    setUp(() {
      mockApiService = MockApiService();
      repository = UserRepository(mockApiService);
    });

    test('fetchUsers returns list of users', () async {
      final users = [
        User(id: '1', name: 'محمد', email: 'mohamed@test.com'),
        User(id: '2', name: 'أحمد', email: 'ahmed@test.com'),
      ];

      when(mockApiService.getUsers()).thenAnswer((_) async => users);

      final result = await repository.fetchUsers();

      expect(result.length, 2);
      expect(result[0].name, 'محمد');
      verify(mockApiService.getUsers()).called(1);
    });

    test('fetchUsers throws error', () async {
      when(mockApiService.getUsers()).thenThrow(Exception('Network error'));

      expect(
        () => repository.fetchUsers(),
        throwsException,
      );
    });
  });
}
```

---

## 🎨 Widget Testing

### اختبار Widget بسيط

```dart
// lib/widgets/counter_widget.dart
class CounterWidget extends StatefulWidget {
  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int counter = 0;

  void increment() {
    setState(() => counter++);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Count: $counter', key: Key('counter_text')),
        ElevatedButton(
          key: Key('increment_button'),
          onPressed: increment,
          child: Text('Increment'),
        ),
      ],
    );
  }
}

// test/widgets/counter_widget_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:your_app/widgets/counter_widget.dart';

void main() {
  testWidgets('Counter increments when button is pressed', (tester) async {
    // Build widget
    await tester.pumpWidget(
      MaterialApp(home: Scaffold(body: CounterWidget())),
    );

    // Verify initial state
    expect(find.text('Count: 0'), findsOneWidget);
    expect(find.text('Count: 1'), findsNothing);

    // Tap button
    await tester.tap(find.byKey(Key('increment_button')));
    await tester.pump();

    // Verify updated state
    expect(find.text('Count: 0'), findsNothing);
    expect(find.text('Count: 1'), findsOneWidget);
  });
}
```

---

### اختبار Form

```dart
// test/widgets/login_form_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Login form validation', (tester) async {
    await tester.pumpWidget(
      MaterialApp(home: Scaffold(body: LoginForm())),
    );

    // Find widgets
    final emailField = find.byKey(Key('email_field'));
    final passwordField = find.byKey(Key('password_field'));
    final loginButton = find.byKey(Key('login_button'));

    // Test empty fields
    await tester.tap(loginButton);
    await tester.pump();

    expect(find.text('الرجاء إدخال البريد الإلكتروني'), findsOneWidget);
    expect(find.text('الرجاء إدخال كلمة المرور'), findsOneWidget);

    // Enter email
    await tester.enterText(emailField, 'test@test.com');
    await tester.pump();

    // Enter password
    await tester.enterText(passwordField, '123456');
    await tester.pump();

    // Tap login
    await tester.tap(loginButton);
    await tester.pump();

    // Verify no errors
    expect(find.text('الرجاء إدخال البريد الإلكتروني'), findsNothing);
  });
}
```

---

### اختبار Navigation

```dart
testWidgets('Navigation to detail screen', (tester) async {
  await tester.pumpWidget(MaterialApp(
    home: HomeScreen(),
    routes: {
      '/detail': (context) => DetailScreen(),
    },
  ));

  // Tap item
  await tester.tap(find.byKey(Key('item_1')));
  await tester.pumpAndSettle();

  // Verify navigation
  expect(find.byType(DetailScreen), findsOneWidget);
});
```

---

## 🔗 Integration Testing

### الإعداد

```yaml
dev_dependencies:
  integration_test:
    sdk: flutter
```

---

### اختبار Integration

```dart
// integration_test/app_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:your_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('complete user flow', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Login
      await tester.enterText(
        find.byKey(Key('email_field')),
        'test@test.com',
      );
      await tester.enterText(
        find.byKey(Key('password_field')),
        '123456',
      );
      await tester.tap(find.byKey(Key('login_button')));
      await tester.pumpAndSettle();

      // Verify home screen
      expect(find.text('الرئيسية'), findsOneWidget);

      // Add item
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(Key('item_title')),
        'عنصر جديد',
      );
      await tester.tap(find.byKey(Key('save_button')));
      await tester.pumpAndSettle();

      // Verify item added
      expect(find.text('عنصر جديد'), findsOneWidget);
    });
  });
}
```

تشغيل الاختبار:

```bash
flutter test integration_test/app_test.dart
```

---

## ✅ أفضل الممارسات

### 1. تنظيم الاختبارات

```
test/
├── unit/
│   ├── models/
│   │   └── user_test.dart
│   ├── services/
│   │   └── api_service_test.dart
│   └── utils/
│       └── calculator_test.dart
├── widget/
│   ├── screens/
│   │   └── home_screen_test.dart
│   └── widgets/
│       └── counter_widget_test.dart
└── integration/
    └── app_test.dart
```

---

### 2. استخدام setUp و tearDown

```dart
void main() {
  group('Feature Tests', () {
    late Database db;

    setUp(() async {
      // تهيئة قبل كل اختبار
      db = await openDatabase();
    });

    tearDown(() async {
      // تنظيف بعد كل اختبار
      await db.close();
    });

    test('test 1', () {
      // الاختبار
    });

    test('test 2', () {
      // الاختبار
    });
  });
}
```

---

### 3. Matchers مفيدة

```dart
test('various matchers', () {
  expect(5, equals(5));
  expect(5, isNot(equals(3)));
  expect('hello', contains('ell'));
  expect([1, 2, 3], hasLength(3));
  expect([1, 2, 3], contains(2));
  expect({'name': 'محمد'}, containsPair('name', 'محمد'));
  expect(() => throw Exception(), throwsException);
  expect(Future.value(5), completion(equals(5)));
});
```

---

### 4. Code Coverage

```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

---

## 📚 المراجع والمصادر

1. **Documentation**
   - [Flutter Testing](https://flutter.dev/docs/testing)
   - [Mockito](https://pub.dev/packages/mockito)

2. **Tools**
   - [flutter_test](https://api.flutter.dev/flutter/flutter_test/flutter_test-library.html)
   - [integration_test](https://pub.dev/packages/integration_test)

---

## 💡 نصائح

- ✅ اكتب الاختبارات أثناء تطوير الميزة
- ✅ اختبر الحالات الحدية (Edge Cases)
- ✅ استخدم Mocking للاعتماديات الخارجية
- ✅ اجعل الاختبارات مستقلة عن بعضها
- ✅ استخدم أسماء واضحة للاختبارات
- ✅ اهدف لـ Code Coverage عالي
- ✅ اختبر الأخطاء والاستثناءات

---

[⬅️ السابق: الأمان](38_security.md)
[🏠 العودة للفهرس](../README.md)
[التالي: النشر ➡️](40_deployment.md)
