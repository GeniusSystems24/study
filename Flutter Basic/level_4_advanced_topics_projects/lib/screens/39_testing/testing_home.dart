import 'package:flutter/material.dart';

class TestingHome extends StatelessWidget {
  const TestingHome({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 7,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Testing'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'المقدمة'),
              Tab(text: 'Unit Tests'),
              Tab(text: 'Widget Tests'),
              Tab(text: 'Integration Tests'),
              Tab(text: 'Mocking'),
              Tab(text: 'TDD'),
              Tab(text: 'Best Practices'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            IntroductionTab(),
            UnitTestsTab(),
            WidgetTestsTab(),
            IntegrationTestsTab(),
            MockingTab(),
            TddTab(),
            BestPracticesTab(),
          ],
        ),
      ),
    );
  }
}

// ==================== Tab 1: Introduction ====================
class IntroductionTab extends StatelessWidget {
  const IntroductionTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildInfoCard(
          context,
          '🧪 Testing in Flutter',
          'اختبار التطبيقات لضمان الجودة والاستقرار',
        ),
        const SizedBox(height: 16),
        _buildContentCard(
          context,
          'لماذا الاختبار مهم؟',
          '''
✅ اكتشاف الأخطاء مبكراً
✅ منع regression bugs
✅ تحسين جودة الكود
✅ توثيق سلوك التطبيق
✅ ثقة أكبر في التعديلات
✅ تقليل وقت التطوير على المدى الطويل
''',
        ),
        _buildContentCard(
          context,
          'أنواع الاختبارات في Flutter',
          '''
1. Unit Tests (اختبارات الوحدة)
   • اختبار functions و classes منفردة
   • سريعة جداً
   • لا تحتاج UI
   • مثال: اختبار حسابات، validations

2. Widget Tests (اختبارات الويدجت)
   • اختبار UI components
   • تفاعل مع الويدجت
   • سريعة نسبياً
   • مثال: اختبار Buttons، Forms

3. Integration Tests (اختبارات التكامل)
   • اختبار التطبيق كاملاً
   • على جهاز حقيقي أو محاكي
   • بطيئة
   • مثال: اختبار user flows كاملة
''',
        ),
        _buildContentCard(
          context,
          'Test Pyramid',
          '''
           /\\
          /  \\     Integration Tests (قليلة)
         /    \\    
        /------\\   Widget Tests (متوسطة)
       /        \\  
      /----------\\ Unit Tests (كثيرة)
     
• 70% Unit Tests
• 20% Widget Tests  
• 10% Integration Tests
''',
        ),
        _buildCodeCard(
          context,
          'Test Structure',
          '''
void main() {
  // Group: تجميع الاختبارات المتشابهة
  group('Calculator Tests', () {
    
    // Test: اختبار واحد
    test('addition should return sum of two numbers', () {
      // Arrange: التحضير
      final calculator = Calculator();
      
      // Act: التنفيذ
      final result = calculator.add(2, 3);
      
      // Assert: التحقق
      expect(result, 5);
    });
    
    test('division by zero should throw exception', () {
      final calculator = Calculator();
      
      expect(
        () => calculator.divide(10, 0),
        throwsException,
      );
    });
  });
}
''',
        ),
        _buildContentCard(
          context,
          'Common Matchers',
          '''
expect(actual, expected)           // قيمة متساوية
expect(actual, equals(expected))   // مساواة صريحة
expect(actual, isTrue)            // true
expect(actual, isFalse)           // false
expect(actual, isNull)            // null
expect(actual, isNotNull)         // ليس null
expect(actual, greaterThan(5))    // أكبر من
expect(actual, lessThan(10))      // أصغر من
expect(actual, contains('text'))  // يحتوي على
expect(() => fn(), throwsException) // يرمي استثناء
''',
        ),
      ],
    );
  }
}

// ==================== Tab 2: Unit Tests ====================
class UnitTestsTab extends StatelessWidget {
  const UnitTestsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildInfoCard(
          context,
          '🔧 Unit Tests',
          'اختبار الدوال والكلاسات المنفردة',
        ),
        const SizedBox(height: 16),
        _buildCodeCard(
          context,
          'Example: Calculator Class',
          '''
// lib/calculator.dart
class Calculator {
  int add(int a, int b) => a + b;
  int subtract(int a, int b) => a - b;
  int multiply(int a, int b) => a * b;
  
  double divide(int a, int b) {
    if (b == 0) throw Exception('Cannot divide by zero');
    return a / b;
  }
  
  bool isEven(int number) => number % 2 == 0;
}
''',
        ),
        _buildCodeCard(
          context,
          'Test File: calculator_test.dart',
          '''
// test/calculator_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:your_app/calculator.dart';

void main() {
  group('Calculator Tests', () {
    late Calculator calculator;
    
    // يتم تنفيذها قبل كل test
    setUp(() {
      calculator = Calculator();
    });
    
    // يتم تنفيذها بعد كل test
    tearDown(() {
      // cleanup
    });
    
    test('add returns sum of two numbers', () {
      expect(calculator.add(2, 3), 5);
      expect(calculator.add(-1, 1), 0);
      expect(calculator.add(0, 0), 0);
    });
    
    test('subtract returns difference', () {
      expect(calculator.subtract(5, 3), 2);
      expect(calculator.subtract(0, 5), -5);
    });
    
    test('multiply returns product', () {
      expect(calculator.multiply(3, 4), 12);
      expect(calculator.multiply(0, 100), 0);
    });
    
    test('divide returns quotient', () {
      expect(calculator.divide(10, 2), 5);
      expect(calculator.divide(7, 2), 3.5);
    });
    
    test('divide by zero throws exception', () {
      expect(
        () => calculator.divide(10, 0),
        throwsException,
      );
    });
    
    test('isEven returns true for even numbers', () {
      expect(calculator.isEven(2), isTrue);
      expect(calculator.isEven(4), isTrue);
      expect(calculator.isEven(3), isFalse);
      expect(calculator.isEven(0), isTrue);
    });
  });
}
''',
        ),
        _buildCodeCard(
          context,
          'Testing Async Functions',
          '''
// lib/user_repository.dart
class UserRepository {
  Future<User> fetchUser(int id) async {
    await Future.delayed(Duration(seconds: 1));
    if (id < 0) throw Exception('Invalid ID');
    return User(id: id, name: 'User \$id');
  }
  
  Stream<int> countStream() async* {
    for (int i = 1; i <= 5; i++) {
      await Future.delayed(Duration(milliseconds: 100));
      yield i;
    }
  }
}

// test/user_repository_test.dart
void main() {
  group('UserRepository Tests', () {
    late UserRepository repository;
    
    setUp(() {
      repository = UserRepository();
    });
    
    test('fetchUser returns user', () async {
      final user = await repository.fetchUser(1);
      
      expect(user.id, 1);
      expect(user.name, 'User 1');
    });
    
    test('fetchUser throws exception for invalid ID', () {
      expect(
        repository.fetchUser(-1),
        throwsException,
      );
    });
    
    test('countStream emits correct values', () {
      expect(
        repository.countStream(),
        emitsInOrder([1, 2, 3, 4, 5]),
      );
    });
  });
}
''',
        ),
        _buildCodeCard(
          context,
          'Running Tests',
          '''
# تشغيل جميع الاختبارات
flutter test

# تشغيل ملف محدد
flutter test test/calculator_test.dart

# تشغيل اختبار محدد بالاسم
flutter test --name "add returns sum"

# عرض تغطية الكود
flutter test --coverage

# عرض التقرير
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
''',
        ),
        _buildContentCard(
          context,
          'Best Practices لـ Unit Tests',
          '''
✅ اختبر حالة واحدة في كل test
✅ استخدم أسماء وصفية واضحة
✅ اتبع نمط Arrange-Act-Assert
✅ اختبر edge cases
✅ استخدم setUp و tearDown
✅ اجعل الاختبارات مستقلة
✅ لا تختبر implementation details
''',
        ),
      ],
    );
  }
}

// ==================== Tab 3: Widget Tests ====================
class WidgetTestsTab extends StatelessWidget {
  const WidgetTestsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildInfoCard(
          context,
          '🎨 Widget Tests',
          'اختبار واجهة المستخدم والتفاعل',
        ),
        const SizedBox(height: 16),
        _buildCodeCard(
          context,
          'Example: Counter Widget',
          '''
// lib/counter_widget.dart
class CounterWidget extends StatefulWidget {
  const CounterWidget({super.key});
  
  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int _counter = 0;
  
  void _increment() {
    setState(() {
      _counter++;
    });
  }
  
  void _decrement() {
    setState(() {
      _counter--;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '\$_counter',
          key: Key('counter_text'),
          style: TextStyle(fontSize: 48),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              key: Key('decrement_button'),
              onPressed: _decrement,
              child: Text('-'),
            ),
            SizedBox(width: 16),
            ElevatedButton(
              key: Key('increment_button'),
              onPressed: _increment,
              child: Text('+'),
            ),
          ],
        ),
      ],
    );
  }
}
''',
        ),
        _buildCodeCard(
          context,
          'Widget Test',
          '''
// test/counter_widget_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:your_app/counter_widget.dart';

void main() {
  group('CounterWidget Tests', () {
    
    testWidgets('initial counter is 0', (tester) async {
      // Build the widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CounterWidget(),
          ),
        ),
      );
      
      // Verify
      expect(find.text('0'), findsOneWidget);
      expect(find.text('1'), findsNothing);
    });
    
    testWidgets('increment button increases counter', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: CounterWidget())),
      );
      
      // Find and tap the increment button
      final incrementButton = find.byKey(Key('increment_button'));
      await tester.tap(incrementButton);
      
      // Rebuild the widget after state change
      await tester.pump();
      
      // Verify counter increased
      expect(find.text('1'), findsOneWidget);
      expect(find.text('0'), findsNothing);
    });
    
    testWidgets('decrement button decreases counter', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: CounterWidget())),
      );
      
      final decrementButton = find.byKey(Key('decrement_button'));
      await tester.tap(decrementButton);
      await tester.pump();
      
      expect(find.text('-1'), findsOneWidget);
    });
    
    testWidgets('multiple taps work correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: CounterWidget())),
      );
      
      final incrementButton = find.byKey(Key('increment_button'));
      
      // Tap 3 times
      await tester.tap(incrementButton);
      await tester.pump();
      await tester.tap(incrementButton);
      await tester.pump();
      await tester.tap(incrementButton);
      await tester.pump();
      
      expect(find.text('3'), findsOneWidget);
    });
  });
}
''',
        ),
        _buildCodeCard(
          context,
          'Testing Forms',
          '''
// test/login_form_test.dart
testWidgets('login form validation', (tester) async {
  await tester.pumpWidget(
    MaterialApp(home: LoginForm()),
  );
  
  // Find widgets
  final emailField = find.byKey(Key('email_field'));
  final passwordField = find.byKey(Key('password_field'));
  final submitButton = find.byKey(Key('submit_button'));
  
  // Enter invalid email
  await tester.enterText(emailField, 'invalid-email');
  await tester.tap(submitButton);
  await tester.pump();
  
  // Verify error message appears
  expect(find.text('Invalid email'), findsOneWidget);
  
  // Enter valid email
  await tester.enterText(emailField, 'test@example.com');
  await tester.enterText(passwordField, 'password123');
  await tester.tap(submitButton);
  await tester.pump();
  
  // Verify no error
  expect(find.text('Invalid email'), findsNothing);
});
''',
        ),
        _buildCodeCard(
          context,
          'Common Finders',
          '''
// Find by text
find.text('Hello')

// Find by key
find.byKey(Key('my_key'))

// Find by type
find.byType(ElevatedButton)

// Find by icon
find.byIcon(Icons.add)

// Find by widget instance
find.byWidget(myWidget)

// Combine finders
find.descendant(
  of: find.byType(Container),
  matching: find.text('Child'),
)

// Check results
expect(find.text('Hello'), findsOneWidget)
expect(find.text('Hello'), findsNothing)
expect(find.text('Hello'), findsNWidgets(3))
expect(find.text('Hello'), findsWidgets)
''',
        ),
        _buildCodeCard(
          context,
          'Common Actions',
          '''
// Tap
await tester.tap(find.byKey(Key('button')));

// Long press
await tester.longPress(find.text('Item'));

// Enter text
await tester.enterText(find.byType(TextField), 'Hello');

// Drag
await tester.drag(
  find.byType(ListView),
  Offset(0, -300),
);

// Scroll
await tester.scrollUntilVisible(
  find.text('Item 50'),
  500,
);

// Pump (rebuild once)
await tester.pump();

// Pump and settle (wait for animations)
await tester.pumpAndSettle();

// Pump with duration
await tester.pump(Duration(seconds: 1));
''',
        ),
      ],
    );
  }
}

// ==================== Tab 4: Integration Tests ====================
class IntegrationTestsTab extends StatelessWidget {
  const IntegrationTestsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildInfoCard(
          context,
          '🔗 Integration Tests',
          'اختبار التطبيق الكامل على جهاز حقيقي',
        ),
        const SizedBox(height: 16),
        _buildCodeCard(
          context,
          'Setup',
          '''
# في pubspec.yaml
dev_dependencies:
  integration_test:
    sdk: flutter
  flutter_test:
    sdk: flutter

# إنشاء مجلد
mkdir integration_test
''',
        ),
        _buildCodeCard(
          context,
          'Integration Test Example',
          '''
// integration_test/app_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:your_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  group('App Test', () {
    testWidgets('complete user flow', (tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();
      
      // 1. Check home screen
      expect(find.text('Welcome'), findsOneWidget);
      
      // 2. Navigate to login
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();
      
      // 3. Fill login form
      await tester.enterText(
        find.byKey(Key('email')),
        'test@example.com',
      );
      await tester.enterText(
        find.byKey(Key('password')),
        'password123',
      );
      
      // 4. Submit
      await tester.tap(find.text('Submit'));
      await tester.pumpAndSettle(Duration(seconds: 2));
      
      // 5. Verify dashboard appears
      expect(find.text('Dashboard'), findsOneWidget);
      
      // 6. Test navigation
      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();
      
      expect(find.text('Settings'), findsOneWidget);
    });
  });
}
''',
        ),
        _buildCodeCard(
          context,
          'Running Integration Tests',
          '''
# على جهاز متصل
flutter test integration_test/app_test.dart

# على محاكي محدد
flutter test integration_test/app_test.dart -d emulator-5554

# مع تقرير
flutter test integration_test --coverage
''',
        ),
        _buildCodeCard(
          context,
          'Performance Testing',
          '''
// integration_test/performance_test.dart
import 'package:integration_test/integration_test.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  testWidgets('scroll performance', (tester) async {
    app.main();
    await tester.pumpAndSettle();
    
    // Record timeline
    await binding.traceAction(
      () async {
        // Perform scroll
        await tester.fling(
          find.byType(ListView),
          Offset(0, -300),
          10000,
        );
        await tester.pumpAndSettle();
      },
      reportKey: 'scrolling_timeline',
    );
  });
}
''',
        ),
        _buildContentCard(
          context,
          'Integration vs Widget Tests',
          '''
Widget Tests:
• تعمل على محاكي Flutter
• سريعة (ثواني)
• لا تحتاج platform channels
• مناسبة لاختبار UI

Integration Tests:
• تعمل على جهاز حقيقي/محاكي
• بطيئة (دقائق)
• تختبر platform integration
• تختبر التطبيق الكامل
• مناسبة لـ E2E testing
''',
        ),
      ],
    );
  }
}

// ==================== Tab 5: Mocking ====================
class MockingTab extends StatelessWidget {
  const MockingTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildInfoCard(
          context,
          '🎭 Mocking',
          'محاكاة الاعتماديات في الاختبارات',
        ),
        const SizedBox(height: 16),
        _buildCodeCard(
          context,
          'Why Mocking?',
          '''
• عزل الكود المختبر
• تجنب الاعتماد على خدمات خارجية
• اختبار edge cases
• سرعة الاختبارات
• تحكم كامل في النتائج
''',
        ),
        _buildCodeCard(
          context,
          'Setup Mockito',
          '''
# pubspec.yaml
dev_dependencies:
  mockito: ^5.4.4
  build_runner: ^2.4.7

# Generate mocks
flutter pub run build_runner build
''',
        ),
        _buildCodeCard(
          context,
          'Example: API Service',
          '''
// lib/api_service.dart
abstract class ApiService {
  Future<User> getUser(int id);
  Future<void> deleteUser(int id);
}

class ApiServiceImpl implements ApiService {
  final http.Client client;
  
  ApiServiceImpl(this.client);
  
  @override
  Future<User> getUser(int id) async {
    final response = await client.get(
      Uri.parse('https://api.example.com/users/\$id'),
    );
    
    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load user');
    }
  }
  
  @override
  Future<void> deleteUser(int id) async {
    await client.delete(
      Uri.parse('https://api.example.com/users/\$id'),
    );
  }
}
''',
        ),
        _buildCodeCard(
          context,
          'Mock Test',
          '''
// test/api_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

// Generate mock
@GenerateMocks([http.Client])
import 'api_service_test.mocks.dart';

void main() {
  group('ApiService Tests', () {
    late MockClient mockClient;
    late ApiService apiService;
    
    setUp(() {
      mockClient = MockClient();
      apiService = ApiServiceImpl(mockClient);
    });
    
    test('getUser returns User on success', () async {
      // Arrange
      when(mockClient.get(any)).thenAnswer(
        (_) async => http.Response(
          '{"id": 1, "name": "Ahmed"}',
          200,
        ),
      );
      
      // Act
      final user = await apiService.getUser(1);
      
      // Assert
      expect(user.id, 1);
      expect(user.name, 'Ahmed');
      
      // Verify the method was called
      verify(mockClient.get(any)).called(1);
    });
    
    test('getUser throws exception on error', () async {
      // Arrange
      when(mockClient.get(any)).thenAnswer(
        (_) async => http.Response('Not Found', 404),
      );
      
      // Act & Assert
      expect(
        () => apiService.getUser(1),
        throwsException,
      );
    });
    
    test('deleteUser calls delete', () async {
      // Arrange
      when(mockClient.delete(any)).thenAnswer(
        (_) async => http.Response('', 200),
      );
      
      // Act
      await apiService.deleteUser(1);
      
      // Assert
      verify(mockClient.delete(
        Uri.parse('https://api.example.com/users/1'),
      )).called(1);
    });
  });
}
''',
        ),
        _buildCodeCard(
          context,
          'Mockito Features',
          '''
// Basic stubbing
when(mock.method()).thenReturn(value);
when(mock.method()).thenAnswer((_) async => value);

// Argument matchers
when(mock.method(any)).thenReturn(value);
when(mock.method(argThat(isPositive))).thenReturn(value);

// Verification
verify(mock.method()).called(1);
verify(mock.method()).called(greaterThan(2));
verifyNever(mock.method());
verifyInOrder([
  mock.method1(),
  mock.method2(),
]);

// Throwing exceptions
when(mock.method()).thenThrow(Exception('Error'));

// Capturing arguments
verify(mock.method(captureAny));
final captured = verify(mock.method(captureAny)).captured;
''',
        ),
        _buildCodeCard(
          context,
          'Manual Mocks',
          '''
// Alternative: Manual mock
class MockApiService implements ApiService {
  bool getCalled = false;
  User? userToReturn;
  Exception? exceptionToThrow;
  
  @override
  Future<User> getUser(int id) async {
    getCalled = true;
    
    if (exceptionToThrow != null) {
      throw exceptionToThrow!;
    }
    
    return userToReturn ?? User(id: id, name: 'Mock User');
  }
  
  @override
  Future<void> deleteUser(int id) async {
    // Mock implementation
  }
}

// Usage in test
test('using manual mock', () async {
  final mock = MockApiService();
  mock.userToReturn = User(id: 1, name: 'Test');
  
  final user = await mock.getUser(1);
  
  expect(user.name, 'Test');
  expect(mock.getCalled, isTrue);
});
''',
        ),
      ],
    );
  }
}

// ==================== Tab 6: TDD ====================
class TddTab extends StatelessWidget {
  const TddTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildInfoCard(
          context,
          '🔴🟢🔵 Test-Driven Development',
          'كتابة الاختبارات قبل الكود',
        ),
        const SizedBox(height: 16),
        _buildContentCard(
          context,
          'TDD Cycle',
          '''
1. 🔴 Red: اكتب اختبار فاشل
2. 🟢 Green: اكتب أقل كود لتمرير الاختبار
3. 🔵 Refactor: حسّن الكود
4. كرر العملية

الفوائد:
• كود قابل للاختبار من البداية
• تصميم أفضل
• تغطية اختبار عالية
• ثقة في التعديلات
• توثيق واضح
''',
        ),
        _buildCodeCard(
          context,
          'TDD Example: Email Validator',
          '''
// 1. RED - Write failing test
test('valid email returns true', () {
  final validator = EmailValidator();
  expect(validator.isValid('test@example.com'), isTrue);
});

// سيفشل لأن EmailValidator غير موجود

// 2. GREEN - Write minimal code
class EmailValidator {
  bool isValid(String email) {
    return email.contains('@');  // أبسط حل
  }
}

// الاختبار سينجح الآن

// 3. REFACTOR - Improve code
class EmailValidator {
  bool isValid(String email) {
    final regex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}\$',
    );
    return regex.hasMatch(email);
  }
}

// 4. Add more tests
test('invalid email returns false', () {
  final validator = EmailValidator();
  expect(validator.isValid('invalid'), isFalse);
  expect(validator.isValid('test@'), isFalse);
  expect(validator.isValid('@example.com'), isFalse);
});
''',
        ),
        _buildCodeCard(
          context,
          'TDD Example: Shopping Cart',
          '''
// Step 1: Write test for empty cart
test('new cart is empty', () {
  final cart = ShoppingCart();
  expect(cart.items, isEmpty);
  expect(cart.total, 0);
});

// Step 2: Implement
class ShoppingCart {
  final List<CartItem> items = [];
  double get total => 0;
}

// Step 3: Add item test
test('can add item to cart', () {
  final cart = ShoppingCart();
  final item = CartItem(name: 'Book', price: 10);
  
  cart.addItem(item);
  
  expect(cart.items.length, 1);
  expect(cart.items.first, item);
});

// Step 4: Implement
class ShoppingCart {
  final List<CartItem> items = [];
  
  void addItem(CartItem item) {
    items.add(item);
  }
  
  double get total => items.fold(0, (sum, item) => sum + item.price);
}

// Step 5: Test total calculation
test('total calculates correctly', () {
  final cart = ShoppingCart();
  cart.addItem(CartItem(name: 'Book', price: 10));
  cart.addItem(CartItem(name: 'Pen', price: 5));
  
  expect(cart.total, 15);
});

// Step 6: Test remove item
test('can remove item from cart', () {
  final cart = ShoppingCart();
  final item = CartItem(name: 'Book', price: 10);
  cart.addItem(item);
  
  cart.removeItem(item);
  
  expect(cart.items, isEmpty);
  expect(cart.total, 0);
});
''',
        ),
        _buildContentCard(
          context,
          'TDD Best Practices',
          '''
✅ اكتب اختباراً واحداً في كل مرة
✅ اجعل الاختبارات صغيرة ومحددة
✅ لا تكتب كود إضافي بدون اختبار
✅ Refactor بعد نجاح الاختبار
✅ اجعل الاختبارات سريعة
✅ استخدم أسماء واضحة
✅ اختبر السلوك وليس التطبيق
''',
        ),
        _buildContentCard(
          context,
          'When to Use TDD',
          '''
مناسب لـ:
• Business logic معقدة
• Algorithms
• Utility functions
• Validations
• Data transformations

قد لا يكون مناسباً لـ:
• UI prototyping
• Proof of concept
• Simple CRUD operations
• Experimental features
''',
        ),
      ],
    );
  }
}

// ==================== Tab 7: Best Practices ====================
class BestPracticesTab extends StatelessWidget {
  const BestPracticesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildInfoCard(
          context,
          '✨ Testing Best Practices',
          'أفضل الممارسات في الاختبارات',
        ),
        const SizedBox(height: 16),
        _buildContentCard(
          context,
          'Test Organization',
          '''
project/
├── lib/
│   ├── models/
│   ├── services/
│   └── widgets/
├── test/
│   ├── models/
│   │   └── user_test.dart
│   ├── services/
│   │   └── api_service_test.dart
│   └── widgets/
│       └── counter_widget_test.dart
└── integration_test/
    └── app_test.dart

• نفس هيكل lib/
• ملف لكل كلاس
• تسمية واضحة مع _test.dart
''',
        ),
        _buildContentCard(
          context,
          'Test Naming Conventions',
          '''
✅ Good:
test('add returns sum of two numbers', () {})
test('login fails with invalid credentials', () {})
test('cart total updates after adding item', () {})

❌ Bad:
test('test1', () {})
test('addition', () {})
test('works', () {})

القاعدة:
• استخدم جمل وصفية كاملة
• وضح ما يتم اختباره
• وضح النتيجة المتوقعة
''',
        ),
        _buildCodeCard(
          context,
          'Arrange-Act-Assert Pattern',
          '''
test('user can update profile', () {
  // Arrange: التحضير
  final user = User(name: 'Ahmed', email: 'old@example.com');
  final newEmail = 'new@example.com';
  
  // Act: التنفيذ
  user.updateEmail(newEmail);
  
  // Assert: التحقق
  expect(user.email, newEmail);
});

// يمكن استخدام تعليقات للوضوح
test('shopping cart total', () {
  // Arrange
  final cart = ShoppingCart();
  final item1 = CartItem(price: 10);
  final item2 = CartItem(price: 20);
  
  // Act
  cart.addItem(item1);
  cart.addItem(item2);
  
  // Assert
  expect(cart.total, 30);
});
''',
        ),
        _buildCodeCard(
          context,
          'Test Independence',
          '''
// ❌ Bad: Tests depend on each other
int counter = 0;

test('increment', () {
  counter++;
  expect(counter, 1);
});

test('increment again', () {
  counter++;
  expect(counter, 2);  // يفشل إذا تم تشغيله منفرداً
});

// ✅ Good: Independent tests
test('increment from 0', () {
  int counter = 0;
  counter++;
  expect(counter, 1);
});

test('increment from 5', () {
  int counter = 5;
  counter++;
  expect(counter, 6);
});

// ✅ Better: Use setUp
group('Counter Tests', () {
  late int counter;
  
  setUp(() {
    counter = 0;
  });
  
  test('increment', () {
    counter++;
    expect(counter, 1);
  });
  
  test('decrement', () {
    counter--;
    expect(counter, -1);
  });
});
''',
        ),
        _buildContentCard(
          context,
          'Code Coverage Goals',
          '''
Coverage Targets:
• 80-90% للمشاريع الكبيرة
• 100% للـ business logic
• 60-70% للـ UI code

Important:
• Coverage ≠ Quality
• 100% coverage لا تعني لا bugs
• ركز على اختبار السلوك المهم
• لا تختبر فقط لزيادة النسبة
''',
        ),
        _buildCodeCard(
          context,
          'Testing Checklist',
          '''
✅ Unit Tests:
  • Business logic
  • Utility functions
  • Data models
  • Validators
  • Calculations

✅ Widget Tests:
  • UI components
  • User interactions
  • Form validation
  • Navigation
  • State changes

✅ Integration Tests:
  • Critical user flows
  • E2E scenarios
  • Platform integration

✅ Edge Cases:
  • Null values
  • Empty lists
  • Boundary values
  • Error conditions

✅ Documentation:
  • Clear test names
  • Comments for complex tests
  • README for test setup
''',
        ),
        _buildCodeCard(
          context,
          'CI/CD Integration',
          '''
# .github/workflows/test.yml
name: Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v2
      
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.16.0'
      
      - name: Install dependencies
        run: flutter pub get
      
      - name: Run tests
        run: flutter test --coverage
      
      - name: Upload coverage
        uses: codecov/codecov-action@v3
        with:
          files: ./coverage/lcov.info
''',
        ),
        _buildContentCard(
          context,
          'Common Testing Mistakes',
          '''
❌ اختبار implementation details
❌ اختبارات بطيئة
❌ اختبارات متداخلة
❌ عدم اختبار edge cases
❌ أسماء غير واضحة
❌ اختبارات معقدة جداً
❌ عدم استخدام mocks
❌ تجاهل الاختبارات الفاشلة
''',
        ),
        _buildContentCard(
          context,
          'Testing Tools & Resources',
          '''
📚 Packages:
• flutter_test
• mockito
• integration_test
• flutter_driver
• golden_toolkit

🔧 Tools:
• Coverage reports (lcov)
• CI/CD (GitHub Actions)
• Test runners (IDE plugins)

📖 Resources:
• flutter.dev/docs/testing
• Testing best practices guides
• Community examples
''',
        ),
      ],
    );
  }
}

// ==================== Helper Widgets ====================
Widget _buildInfoCard(BuildContext context, String title, String subtitle) {
  return Card(
    color: Theme.of(context).colorScheme.primaryContainer,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}

Widget _buildContentCard(BuildContext context, String title, String content) {
  return Card(
    margin: const EdgeInsets.only(bottom: 16),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    ),
  );
}

Widget _buildCodeCard(BuildContext context, String title, String code) {
  return Card(
    margin: const EdgeInsets.only(bottom: 16),
    color: Colors.grey[900],
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(8),
            ),
            child: SelectableText(
              code,
              style: const TextStyle(
                fontFamily: 'monospace',
                color: Colors.greenAccent,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

