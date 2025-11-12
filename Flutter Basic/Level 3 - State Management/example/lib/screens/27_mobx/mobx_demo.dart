import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

// ملاحظة: في مشروع حقيقي نحتاج build_runner
// part 'mobx_demo.g.dart';

// ═══════════════════════════════════════════════════════════════════
// 1. COUNTER STORE - مثال بسيط على Observable & Action
// ═══════════════════════════════════════════════════════════════════

class CounterStore {
  // @observable
  var counter = Observable(0);

  // @action
  void increment() {
    counter.value++;
  }

  void decrement() {
    counter.value--;
  }

  void reset() {
    counter.value = 0;
  }
}

// ═══════════════════════════════════════════════════════════════════
// 2. TODO STORE - مثال على ObservableList & Computed
// ═══════════════════════════════════════════════════════════════════

class TodoItem {
  final String id;
  final Observable<String> title;
  final Observable<bool> completed;

  TodoItem({
    required this.id,
    required String title,
    bool completed = false,
  })  : title = Observable(title),
        completed = Observable(completed);
}

class TodoStore {
  var todos = ObservableList<TodoItem>();
  var filter = Observable<String>('all');

  // @computed - قيمة محسوبة تلقائياً
  List<TodoItem> get filteredTodos {
    switch (filter.value) {
      case 'completed':
        return todos.where((todo) => todo.completed.value).toList();
      case 'pending':
        return todos.where((todo) => !todo.completed.value).toList();
      default:
        return todos.toList();
    }
  }

  int get totalTodos => todos.length;
  int get completedCount => todos.where((t) => t.completed.value).length;
  int get pendingCount => todos.where((t) => !t.completed.value).length;

  // @action
  void addTodo(String title) {
    if (title.trim().isEmpty) return;
    todos.add(TodoItem(
      id: DateTime.now().toString(),
      title: title,
    ));
  }

  void toggleTodo(String id) {
    final todo = todos.firstWhere((t) => t.id == id);
    todo.completed.value = !todo.completed.value;
  }

  void removeTodo(String id) {
    todos.removeWhere((t) => t.id == id);
  }

  void setFilter(String newFilter) {
    filter.value = newFilter;
  }

  void clearCompleted() {
    todos.removeWhere((t) => t.completed.value);
  }
}

// ═══════════════════════════════════════════════════════════════════
// 3. SHOPPING STORE - مثال على Computed مع حسابات معقدة
// ═══════════════════════════════════════════════════════════════════

class Product {
  final String id;
  final String name;
  final double price;
  final String emoji;

  Product(this.id, this.name, this.price, this.emoji);
}

class ShoppingStore {
  final products = [
    Product('1', 'كمبيوتر محمول', 3500.0, '💻'),
    Product('2', 'سماعات', 150.0, '🎧'),
    Product('3', 'ماوس لاسلكي', 50.0, '🖱️'),
    Product('4', 'لوحة مفاتيح', 100.0, '⌨️'),
  ];

  var cart = ObservableMap<String, int>();

  // @computed - إجمالي السعر
  double get totalPrice {
    return cart.entries.fold(0.0, (sum, entry) {
      final product = products.firstWhere((p) => p.id == entry.key);
      return sum + (product.price * entry.value);
    });
  }

  int get itemCount {
    return cart.values.fold(0, (sum, qty) => sum + qty);
  }

  // @action
  void addToCart(String productId) {
    cart[productId] = (cart[productId] ?? 0) + 1;
  }

  void removeFromCart(String productId) {
    if (cart.containsKey(productId)) {
      if (cart[productId]! > 1) {
        cart[productId] = cart[productId]! - 1;
      } else {
        cart.remove(productId);
      }
    }
  }

  void clearCart() {
    cart.clear();
  }
}

// ═══════════════════════════════════════════════════════════════════
// 4. USER STORE - مثال على Async Actions مع Reactions
// ═══════════════════════════════════════════════════════════════════

class User {
  final String name;
  final String email;

  User(this.name, this.email);
}

class UserStore {
  var isLoading = Observable(false);
  var user = Observable<User?>(null);
  var errorMessage = Observable<String?>(null);

  late final ReactionDisposer _userReaction;

  UserStore() {
    // Reaction - رد فعل تلقائي عند تغيير user
    _userReaction = reaction(
      (_) => user.value,
      (User? newUser) {
        if (newUser != null) {
          print('User logged in: ${newUser.name}');
        } else {
          print('User logged out');
        }
      },
    );
  }

  // @action
  Future<void> login(String email, String password) async {
    isLoading.value = true;
    errorMessage.value = null;

    await Future.delayed(const Duration(seconds: 2));

    if (password == '123456') {
      user.value = User('أحمد محمد', email);
    } else {
      errorMessage.value = 'كلمة مرور خاطئة';
    }

    isLoading.value = false;
  }

  void logout() {
    user.value = null;
    errorMessage.value = null;
  }

  void dispose() {
    _userReaction();
  }
}

// ═══════════════════════════════════════════════════════════════════
// 5. FORM STORE - مثال على Validation مع Computed
// ═══════════════════════════════════════════════════════════════════

class FormStore {
  var name = Observable('');
  var email = Observable('');
  var password = Observable('');
  var agreeToTerms = Observable(false);

  // @computed - تحقق من الصحة
  String? get nameError {
    if (name.value.isEmpty) return null;
    if (name.value.length < 3) return 'الاسم قصير جداً';
    return null;
  }

  String? get emailError {
    if (email.value.isEmpty) return null;
    if (!email.value.contains('@')) return 'البريد غير صحيح';
    return null;
  }

  String? get passwordError {
    if (password.value.isEmpty) return null;
    if (password.value.length < 6) return 'كلمة المرور قصيرة';
    return null;
  }

  bool get isValid {
    return name.value.isNotEmpty &&
        email.value.isNotEmpty &&
        password.value.isNotEmpty &&
        nameError == null &&
        emailError == null &&
        passwordError == null &&
        agreeToTerms.value;
  }

  void reset() {
    name.value = '';
    email.value = '';
    password.value = '';
    agreeToTerms.value = false;
  }
}

// ═══════════════════════════════════════════════════════════════════
// MAIN WIDGET
// ═══════════════════════════════════════════════════════════════════

/// شاشة عرض MobX - الموضوع 27
class MobXDemo extends StatelessWidget {
  const MobXDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 7,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('MobX - Reactive State Management'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(icon: Icon(Icons.info), text: 'مقدمة'),
              Tab(icon: Icon(Icons.add_circle), text: 'Observable & Action'),
              Tab(icon: Icon(Icons.calculate), text: 'Computed'),
              Tab(icon: Icon(Icons.list), text: 'Todo List'),
              Tab(icon: Icon(Icons.shopping_cart), text: 'Shopping'),
              Tab(icon: Icon(Icons.person), text: 'Async & Reactions'),
              Tab(icon: Icon(Icons.compare), text: 'مقارنة'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _IntroTab(),
            _ObservableActionTab(),
            _ComputedTab(),
            _TodoTab(),
            _ShoppingTab(),
            _AsyncReactionTab(),
            _ComparisonTab(),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// TAB 1: INTRODUCTION
// ═══════════════════════════════════════════════════════════════════

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
                  '🎭 MobX - Reactive State Management',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                const Text(
                  'MobX هو library لإدارة الحالة بطريقة reactive مستوحاة من '
                  'MobX في JavaScript.\n\n'
                  'يعتمد على ثلاثة مفاهيم أساسية:\n'
                  '• Observable - البيانات القابلة للمراقبة\n'
                  '• Action - الإجراءات التي تعدل البيانات\n'
                  '• Reaction - ردود الفعل على التغييرات',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          color: Colors.teal.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.teal),
                    const SizedBox(width: 8),
                    Text(
                      'المفاهيم الأساسية',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildConcept('Observable', 'البيانات القابلة للمراقبة',
                    'أي متغير يمكن مراقبة تغييراته تلقائياً'),
                const SizedBox(height: 8),
                _buildConcept('Action', 'الإجراءات',
                    'الدوال التي تعدل Observable بطريقة منظمة'),
                const SizedBox(height: 8),
                _buildConcept('Computed', 'القيم المحسوبة',
                    'قيم تحسب تلقائياً عند تغيير Observable'),
                const SizedBox(height: 8),
                _buildConcept('Reaction', 'ردود الفعل',
                    'كود يُنفذ تلقائياً عند تغيير Observable'),
                const SizedBox(height: 8),
                _buildConcept('Observer', 'المراقب',
                    'Widget يعيد بناء نفسه عند تغيير Observable'),
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
                    const Icon(Icons.star, color: Colors.blue),
                    const SizedBox(width: 8),
                    Text(
                      'المزايا',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text('✓ Reactive Programming - برمجة تفاعلية'),
                const Text('✓ Code Generation - توليد الكود تلقائياً'),
                const Text('✓ كود نظيف ومنظم جداً'),
                const Text('✓ Observable Graph - رسم بياني للتبعيات'),
                const Text('✓ Performance - أداء ممتاز'),
                const Text('✓ Reactions - ردود فعل تلقائية'),
                const Text('✓ مثالي للتطبيقات المعقدة'),
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
                      'كود المثال',
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
                      '// 1. تعريف Store\n'
                      'class CounterStore {\n'
                      '  var counter = Observable(0);\n\n'
                      '  void increment() {\n'
                      '    counter.value++;\n'
                      '  }\n'
                      '}\n\n'
                      '// 2. استخدام في UI\n'
                      'Observer(\n'
                      '  builder: (_) => Text("\${store.counter.value}"),\n'
                      ')\n\n'
                      '// 3. Code Generation (اختياري)\n'
                      '// @observable\n'
                      '// int counter = 0;\n'
                      '//\n'
                      '// @action\n'
                      '// void increment() => counter++;',
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

  Widget _buildConcept(String title, String subtitle, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.teal,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              subtitle,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(description, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// TAB 2: OBSERVABLE & ACTION
// ═══════════════════════════════════════════════════════════════════

class _ObservableActionTab extends StatefulWidget {
  @override
  State<_ObservableActionTab> createState() => _ObservableActionTabState();
}

class _ObservableActionTabState extends State<_ObservableActionTab> {
  final store = CounterStore();

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
                  'Counter مع Observable & Action',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 20),
                // Observer - يعيد البناء تلقائياً
                Observer(
                  builder: (_) {
                    return Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'العدد الحالي',
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${store.counter.value}',
                            style: const TextStyle(
                              fontSize: 64,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: store.decrement,
                      icon: const Icon(Icons.remove),
                      label: const Text('تقليل'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: store.reset,
                      icon: const Icon(Icons.refresh),
                      label: const Text('إعادة'),
                    ),
                    ElevatedButton.icon(
                      onPressed: store.increment,
                      icon: const Icon(Icons.add),
                      label: const Text('زيادة'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
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
          color: Colors.purple.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.code, color: Colors.purple),
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
                      '// CounterStore\n'
                      'class CounterStore {\n'
                      '  var counter = Observable(0);\n\n'
                      '  void increment() {\n'
                      '    counter.value++;\n'
                      '  }\n\n'
                      '  void decrement() {\n'
                      '    counter.value--;\n'
                      '  }\n\n'
                      '  void reset() {\n'
                      '    counter.value = 0;\n'
                      '  }\n'
                      '}\n\n'
                      '// في Widget:\n'
                      'Observer(\n'
                      '  builder: (_) {\n'
                      '    return Text("\${store.counter.value}");\n'
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

// ═══════════════════════════════════════════════════════════════════
// TAB 3: COMPUTED VALUES
// ═══════════════════════════════════════════════════════════════════

class _ComputedTab extends StatefulWidget {
  @override
  State<_ComputedTab> createState() => _ComputedTabState();
}

class _ComputedTabState extends State<_ComputedTab> {
  final formStore = FormStore();

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
                  'Form Validation مع Computed',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Computed Values تحسب تلقائياً عند تغيير Observable',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 20),
                Observer(
                  builder: (_) => TextField(
                    decoration: InputDecoration(
                      labelText: 'الاسم',
                      errorText: formStore.nameError,
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (value) => formStore.name.value = value,
                  ),
                ),
                const SizedBox(height: 16),
                Observer(
                  builder: (_) => TextField(
                    decoration: InputDecoration(
                      labelText: 'البريد الإلكتروني',
                      errorText: formStore.emailError,
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (value) => formStore.email.value = value,
                  ),
                ),
                const SizedBox(height: 16),
                Observer(
                  builder: (_) => TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'كلمة المرور',
                      errorText: formStore.passwordError,
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (value) => formStore.password.value = value,
                  ),
                ),
                const SizedBox(height: 16),
                Observer(
                  builder: (_) => CheckboxListTile(
                    title: const Text('أوافق على الشروط والأحكام'),
                    value: formStore.agreeToTerms.value,
                    onChanged: (value) =>
                        formStore.agreeToTerms.value = value ?? false,
                  ),
                ),
                const SizedBox(height: 20),
                Observer(
                  builder: (_) => SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: formStore.isValid
                          ? () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('تم التسجيل بنجاح! ✓'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              formStore.reset();
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text(
                        'تسجيل',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
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
                Row(
                  children: [
                    const Icon(Icons.code, color: Colors.purple),
                    const SizedBox(width: 8),
                    Text(
                      'الكود - Computed Values',
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
                      'class FormStore {\n'
                      '  var name = Observable(\'\');\n'
                      '  var email = Observable(\'\');\n'
                      '  var password = Observable(\'\');\n\n'
                      '  // Computed - تحسب تلقائياً\n'
                      '  String? get nameError {\n'
                      '    if (name.value.isEmpty) return null;\n'
                      '    if (name.value.length < 3) return \'قصير\';\n'
                      '    return null;\n'
                      '  }\n\n'
                      '  String? get emailError {\n'
                      '    if (email.value.isEmpty) return null;\n'
                      '    if (!email.value.contains(\'@\'))\n'
                      '      return \'غير صحيح\';\n'
                      '    return null;\n'
                      '  }\n\n'
                      '  // Computed - تعتمد على عدة Observables\n'
                      '  bool get isValid {\n'
                      '    return name.value.isNotEmpty &&\n'
                      '           email.value.isNotEmpty &&\n'
                      '           nameError == null &&\n'
                      '           emailError == null;\n'
                      '  }\n'
                      '}',
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

// ═══════════════════════════════════════════════════════════════════
// TAB 4: TODO LIST
// ═══════════════════════════════════════════════════════════════════

class _TodoTab extends StatefulWidget {
  @override
  State<_TodoTab> createState() => _TodoTabState();
}

class _TodoTabState extends State<_TodoTab> {
  final store = TodoStore();
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header with Statistics
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.blue.withOpacity(0.1),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                        labelText: 'مهمة جديدة',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.add_task),
                      ),
                      onSubmitted: (value) {
                        store.addTodo(value);
                        controller.clear();
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      store.addTodo(controller.text);
                      controller.clear();
                    },
                    child: const Text('إضافة'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Observer(
                builder: (_) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStat('الكل', store.totalTodos, Colors.blue),
                    _buildStat('مكتملة', store.completedCount, Colors.green),
                    _buildStat('معلقة', store.pendingCount, Colors.orange),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Filters
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Observer(
            builder: (_) => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildFilterChip('الكل', 'all'),
                const SizedBox(width: 8),
                _buildFilterChip('مكتملة', 'completed'),
                const SizedBox(width: 8),
                _buildFilterChip('معلقة', 'pending'),
                const SizedBox(width: 16),
                TextButton.icon(
                  onPressed: store.completedCount > 0
                      ? store.clearCompleted
                      : null,
                  icon: const Icon(Icons.delete_sweep),
                  label: const Text('حذف المكتملة'),
                ),
              ],
            ),
          ),
        ),
        // Todo List
        Expanded(
          child: Observer(
            builder: (_) {
              if (store.filteredTodos.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inbox, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'لا توجد مهام',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                itemCount: store.filteredTodos.length,
                itemBuilder: (context, index) {
                  final todo = store.filteredTodos[index];
                  return Observer(
                    builder: (_) => Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      child: ListTile(
                        leading: Checkbox(
                          value: todo.completed.value,
                          onChanged: (_) => store.toggleTodo(todo.id),
                        ),
                        title: Text(
                          todo.title.value,
                          style: TextStyle(
                            decoration: todo.completed.value
                                ? TextDecoration.lineThrough
                                : null,
                            color: todo.completed.value
                                ? Colors.grey
                                : null,
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => store.removeTodo(todo.id),
                        ),
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

  Widget _buildStat(String label, int count, Color color) {
    return Column(
      children: [
        Text(
          '$count',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = store.filter.value == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => store.setFilter(value),
      selectedColor: Colors.blue,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : null,
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// TAB 5: SHOPPING CART
// ═══════════════════════════════════════════════════════════════════

class _ShoppingTab extends StatefulWidget {
  @override
  State<_ShoppingTab> createState() => _ShoppingTabState();
}

class _ShoppingTabState extends State<_ShoppingTab> {
  final store = ShoppingStore();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header - Total Price
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.green.withOpacity(0.1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.shopping_cart, size: 32, color: Colors.green),
                  SizedBox(width: 12),
                  Text(
                    'سلة التسوق',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Observer(
                builder: (_) => Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'الإجمالي: ${store.totalPrice.toStringAsFixed(2)} ر.س',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    Text(
                      '${store.itemCount} عنصر',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Product List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: store.products.length,
            itemBuilder: (context, index) {
              final product = store.products[index];
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Text(
                        product.emoji,
                        style: const TextStyle(fontSize: 48),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${product.price.toStringAsFixed(2)} ر.س',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Observer(
                        builder: (_) {
                          final quantity = store.cart[product.id] ?? 0;
                          return Row(
                            children: [
                              IconButton(
                                onPressed: quantity > 0
                                    ? () => store.removeFromCart(product.id)
                                    : null,
                                icon: const Icon(Icons.remove_circle),
                                color: Colors.red,
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: quantity > 0
                                      ? Colors.blue
                                      : Colors.grey.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '$quantity',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        quantity > 0 ? Colors.white : Colors.grey,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () => store.addToCart(product.id),
                                icon: const Icon(Icons.add_circle),
                                color: Colors.green,
                              ),
                            ],
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
        // Clear Button
        Observer(
          builder: (_) => store.itemCount > 0
              ? Container(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: store.clearCart,
                      icon: const Icon(Icons.delete_sweep),
                      label: const Text('إفراغ السلة'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// TAB 6: ASYNC & REACTIONS
// ═══════════════════════════════════════════════════════════════════

class _AsyncReactionTab extends StatefulWidget {
  @override
  State<_AsyncReactionTab> createState() => _AsyncReactionTabState();
}

class _AsyncReactionTabState extends State<_AsyncReactionTab> {
  final store = UserStore();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    store.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

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
                  'Async Actions & Reactions',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Reactions تنفذ تلقائياً عند تغيير Observable',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Observer(
          builder: (_) {
            if (store.user.value != null) {
              final user = store.user.value!;
              return Card(
                color: Colors.green.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.green,
                        child: Icon(Icons.person, size: 48, color: Colors.white),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        user.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        user.email,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: store.logout,
                        icon: const Icon(Icons.logout),
                        label: const Text('تسجيل الخروج'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: 'البريد الإلكتروني',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'كلمة المرور',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock),
                        helperText: 'استخدم 123456 للدخول',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Observer(
                      builder: (_) {
                        if (store.errorMessage.value != null) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              store.errorMessage.value!,
                              style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    const SizedBox(height: 20),
                    Observer(
                      builder: (_) => SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: store.isLoading.value
                              ? null
                              : () {
                                  store.login(
                                    emailController.text,
                                    passwordController.text,
                                  );
                                },
                          icon: store.isLoading.value
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.login),
                          label: Text(
                            store.isLoading.value ? 'جاري التحميل...' : 'تسجيل الدخول',
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(16),
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
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
        Card(
          color: Colors.purple.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.code, color: Colors.purple),
                    const SizedBox(width: 8),
                    Text(
                      'الكود - Reaction',
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
                      'class UserStore {\n'
                      '  var user = Observable<User?>(null);\n\n'
                      '  UserStore() {\n'
                      '    // Reaction - ينفذ عند تغيير user\n'
                      '    _userReaction = reaction(\n'
                      '      (_) => user.value,\n'
                      '      (User? newUser) {\n'
                      '        if (newUser != null) {\n'
                      '          print(\'Logged in: \${newUser.name}\');\n'
                      '        } else {\n'
                      '          print(\'Logged out\');\n'
                      '        }\n'
                      '      },\n'
                      '    );\n'
                      '  }\n\n'
                      '  Future<void> login(String email, String pw) async {\n'
                      '    isLoading.value = true;\n'
                      '    await Future.delayed(Duration(seconds: 2));\n'
                      '    user.value = User(\'أحمد\', email);\n'
                      '    isLoading.value = false;\n'
                      '  }\n'
                      '}',
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

// ═══════════════════════════════════════════════════════════════════
// TAB 7: COMPARISON
// ═══════════════════════════════════════════════════════════════════

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
                  '⚖️ MobX vs حلول أخرى',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                _buildComparison(
                  'MobX vs Provider',
                  'MobX',
                  '• Reactive تلقائي\n'
                      '• Code Generation\n'
                      '• Computed values\n'
                      '• Reactions تلقائية',
                  'Provider',
                  '• أبسط في الاستخدام\n'
                      '• لا يحتاج code generation\n'
                      '• مدمج مع Flutter\n'
                      '• أقل من MobX في الميزات',
                ),
                const Divider(height: 32),
                _buildComparison(
                  'MobX vs BLoC',
                  'MobX',
                  '• أسهل في الكتابة\n'
                      '• Boilerplate أقل\n'
                      '• Reactive بطريقة سهلة\n'
                      '• Code generation',
                  'BLoC',
                  '• Stream-based\n'
                      '• تنظيم أوضح\n'
                      '• Unit testing أسهل\n'
                      '• مثالي للتطبيقات الكبيرة',
                ),
                const Divider(height: 32),
                _buildComparison(
                  'MobX vs GetX',
                  'MobX',
                  '• Code generation\n'
                      '• Computed values قوية\n'
                      '• Reactions متقدمة\n'
                      '• تنظيم أفضل',
                  'GetX',
                  '• أبسط في الاستخدام\n'
                      '• لا يحتاج build_runner\n'
                      '• Routing مدمج\n'
                      '• Reactive بدون code generation',
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
                Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green),
                    const SizedBox(width: 8),
                    Text(
                      'متى تستخدم MobX؟',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text('✓ عندما تريد Reactive Programming قوي'),
                const Text('✓ عندما تحتاج Computed Values كثيرة'),
                const Text('✓ عندما تريد Reactions تلقائية'),
                const Text('✓ عندما تحتاج Observable Graph'),
                const Text('✓ عندما لا تمانع استخدام build_runner'),
                const Text('✓ للتطبيقات المتوسطة والكبيرة'),
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
                    const Icon(Icons.info_outline, color: Colors.orange),
                    const SizedBox(width: 8),
                    Text(
                      'ملاحظات',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text('• يحتاج build_runner لـ code generation'),
                const Text('• Boilerplate أكثر من GetX'),
                const Text('• أقل شعبية من Provider و BLoC'),
                const Text('• لكنه قوي جداً للتطبيقات المعقدة'),
                const Text('• Code النهائي نظيف ومنظم'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildComparison(
    String title,
    String label1,
    String points1,
    String label2,
    String points2,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label1,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(points1, style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.purple.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label2,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(points2, style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
