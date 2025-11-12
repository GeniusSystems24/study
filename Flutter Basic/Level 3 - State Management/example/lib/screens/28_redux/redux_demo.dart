import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

// ═══════════════════════════════════════════════════════════════════
// 1. APP STATE - Single Source of Truth
// ═══════════════════════════════════════════════════════════════════

class AppState {
  final int counter;
  final List<TodoItem> todos;
  final Map<String, int> cart;
  final User? user;
  final bool isLoading;

  AppState({
    this.counter = 0,
    this.todos = const [],
    this.cart = const {},
    this.user,
    this.isLoading = false,
  });

  AppState copyWith({
    int? counter,
    List<TodoItem>? todos,
    Map<String, int>? cart,
    User? user,
    bool? isLoading,
  }) {
    return AppState(
      counter: counter ?? this.counter,
      todos: todos ?? this.todos,
      cart: cart ?? this.cart,
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// Models
class TodoItem {
  final String id;
  final String title;
  final bool completed;

  TodoItem({
    required this.id,
    required this.title,
    this.completed = false,
  });

  TodoItem copyWith({String? title, bool? completed}) {
    return TodoItem(
      id: id,
      title: title ?? this.title,
      completed: completed ?? this.completed,
    );
  }
}

class User {
  final String name;
  final String email;

  User(this.name, this.email);
}

// ═══════════════════════════════════════════════════════════════════
// 2. ACTIONS - Events
// ═══════════════════════════════════════════════════════════════════

// Counter Actions
class IncrementAction {}

class DecrementAction {}

class ResetAction {}

// Todo Actions
class AddTodoAction {
  final String title;
  AddTodoAction(this.title);
}

class ToggleTodoAction {
  final String id;
  ToggleTodoAction(this.id);
}

class RemoveTodoAction {
  final String id;
  RemoveTodoAction(this.id);
}

// Cart Actions
class AddToCartAction {
  final String productId;
  AddToCartAction(this.productId);
}

class RemoveFromCartAction {
  final String productId;
  RemoveFromCartAction(this.productId);
}

class ClearCartAction {}

// User Actions
class LoginRequestAction {
  final String email;
  final String password;
  LoginRequestAction(this.email, this.password);
}

class LoginSuccessAction {
  final User user;
  LoginSuccessAction(this.user);
}

class LoginFailureAction {}

class LogoutAction {}

class SetLoadingAction {
  final bool isLoading;
  SetLoadingAction(this.isLoading);
}

// ═══════════════════════════════════════════════════════════════════
// 3. REDUCERS - Pure Functions
// ═══════════════════════════════════════════════════════════════════

AppState appReducer(AppState state, dynamic action) {
  return AppState(
    counter: counterReducer(state.counter, action),
    todos: todosReducer(state.todos, action),
    cart: cartReducer(state.cart, action),
    user: userReducer(state.user, action),
    isLoading: loadingReducer(state.isLoading, action),
  );
}

// Counter Reducer
int counterReducer(int state, dynamic action) {
  if (action is IncrementAction) {
    return state + 1;
  } else if (action is DecrementAction) {
    return state - 1;
  } else if (action is ResetAction) {
    return 0;
  }
  return state;
}

// Todos Reducer
List<TodoItem> todosReducer(List<TodoItem> state, dynamic action) {
  if (action is AddTodoAction) {
    return [
      ...state,
      TodoItem(
        id: DateTime.now().toString(),
        title: action.title,
      ),
    ];
  } else if (action is ToggleTodoAction) {
    return state.map((todo) {
      if (todo.id == action.id) {
        return todo.copyWith(completed: !todo.completed);
      }
      return todo;
    }).toList();
  } else if (action is RemoveTodoAction) {
    return state.where((todo) => todo.id != action.id).toList();
  }
  return state;
}

// Cart Reducer
Map<String, int> cartReducer(Map<String, int> state, dynamic action) {
  if (action is AddToCartAction) {
    final newCart = Map<String, int>.from(state);
    newCart[action.productId] = (newCart[action.productId] ?? 0) + 1;
    return newCart;
  } else if (action is RemoveFromCartAction) {
    final newCart = Map<String, int>.from(state);
    if (newCart.containsKey(action.productId)) {
      if (newCart[action.productId]! > 1) {
        newCart[action.productId] = newCart[action.productId]! - 1;
      } else {
        newCart.remove(action.productId);
      }
    }
    return newCart;
  } else if (action is ClearCartAction) {
    return {};
  }
  return state;
}

// User Reducer
User? userReducer(User? state, dynamic action) {
  if (action is LoginSuccessAction) {
    return action.user;
  } else if (action is LogoutAction) {
    return null;
  }
  return state;
}

// Loading Reducer
bool loadingReducer(bool state, dynamic action) {
  if (action is SetLoadingAction) {
    return action.isLoading;
  }
  return state;
}

// ═══════════════════════════════════════════════════════════════════
// 4. MIDDLEWARE - Async Logic
// ═══════════════════════════════════════════════════════════════════

void loginMiddleware(
  Store<AppState> store,
  dynamic action,
  NextDispatcher next,
) {
  if (action is LoginRequestAction) {
    // Set loading
    store.dispatch(SetLoadingAction(true));

    // Simulate async login
    Future.delayed(const Duration(seconds: 2), () {
      if (action.password == '123456') {
        store.dispatch(LoginSuccessAction(User('أحمد محمد', action.email)));
      } else {
        store.dispatch(LoginFailureAction());
      }
      store.dispatch(SetLoadingAction(false));
    });
  }

  next(action);
}

// ═══════════════════════════════════════════════════════════════════
// 5. STORE CREATION
// ═══════════════════════════════════════════════════════════════════

final store = Store<AppState>(
  appReducer,
  initialState: AppState(),
  middleware: [loginMiddleware],
);

// ═══════════════════════════════════════════════════════════════════
// MAIN WIDGET
// ═══════════════════════════════════════════════════════════════════

/// شاشة عرض Redux - الموضوع 28
class ReduxDemo extends StatelessWidget {
  const ReduxDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: DefaultTabController(
        length: 7,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Redux - Predictable State'),
            bottom: const TabBar(
              isScrollable: true,
              tabs: [
                Tab(icon: Icon(Icons.info), text: 'مقدمة'),
                Tab(icon: Icon(Icons.add_circle), text: 'Actions & Reducers'),
                Tab(icon: Icon(Icons.list), text: 'Todo List'),
                Tab(icon: Icon(Icons.shopping_cart), text: 'Shopping'),
                Tab(icon: Icon(Icons.person), text: 'Middleware'),
                Tab(icon: Icon(Icons.history), text: 'Time Travel'),
                Tab(icon: Icon(Icons.compare), text: 'مقارنة'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              _IntroTab(),
              _ActionsReducersTab(),
              _TodoTab(),
              _ShoppingTab(),
              _MiddlewareTab(),
              _TimeTravelTab(),
              _ComparisonTab(),
            ],
          ),
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
                  '🏗️ Redux - Predictable State Container',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Redux هو pattern لإدارة الحالة بطريقة predictable '
                  'مستوحى من Redux في JavaScript.\n\n'
                  'يعتمد على مبادئ:\n'
                  '• Single Source of Truth - مخزن واحد للحالة\n'
                  '• State is Read-Only - الحالة للقراءة فقط\n'
                  '• Changes Made with Pure Functions - التغييرات بدوال نقية',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          color: Colors.indigo.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.architecture, color: Colors.indigo),
                    const SizedBox(width: 8),
                    Text(
                      'المكونات الأساسية',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildComponent(
                  'Store',
                  'المخزن الوحيد للحالة',
                  'يحتوي على كل state التطبيق في مكان واحد',
                  Colors.blue,
                ),
                const SizedBox(height: 8),
                _buildComponent(
                  'State',
                  'الحالة',
                  'كائن immutable يمثل حالة التطبيق الحالية',
                  Colors.green,
                ),
                const SizedBox(height: 8),
                _buildComponent(
                  'Actions',
                  'الأحداث',
                  'كائنات تصف ماذا حدث في التطبيق',
                  Colors.orange,
                ),
                const SizedBox(height: 8),
                _buildComponent(
                  'Reducers',
                  'المخفضات',
                  'دوال pure تأخذ state قديم و action وترجع state جديد',
                  Colors.purple,
                ),
                const SizedBox(height: 8),
                _buildComponent(
                  'Middleware',
                  'الوسيط',
                  'يعترض Actions قبل وصولها للـ Reducer (للـ async)',
                  Colors.red,
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
                    const Icon(Icons.timeline, color: Colors.blue),
                    const SizedBox(width: 8),
                    Text(
                      'دورة الحياة',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  '1. UI dispatches Action\n'
                  '2. Middleware intercepts (optional)\n'
                  '3. Reducer processes Action\n'
                  '4. Store updates State\n'
                  '5. UI rebuilds with new State',
                  style: TextStyle(fontFamily: 'monospace'),
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
                    const Icon(Icons.star, color: Colors.green),
                    const SizedBox(width: 8),
                    Text(
                      'المزايا',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text('✓ Predictable State - حالة يمكن التنبؤ بها'),
                const Text('✓ Single Source of Truth - مصدر واحد للحقيقة'),
                const Text('✓ Time-Travel Debugging - تصحيح عبر الزمن'),
                const Text('✓ Pure Functions - دوال نقية سهلة الاختبار'),
                const Text('✓ مثالي للتطبيقات الكبيرة والمعقدة'),
                const Text('✓ State Persistence - حفظ الحالة بسهولة'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildComponent(
      String title, String subtitle, String description, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: color.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color,
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
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// TAB 2: ACTIONS & REDUCERS
// ═══════════════════════════════════════════════════════════════════

class _ActionsReducersTab extends StatelessWidget {
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
                  'Counter مع Actions & Reducers',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 20),
                StoreConnector<AppState, int>(
                  converter: (store) => store.state.counter,
                  builder: (context, counter) {
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
                            '$counter',
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
                StoreConnector<AppState, VoidCallback>(
                  converter: (store) {
                    return () => store.dispatch(IncrementAction());
                  },
                  builder: (context, callback) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        StoreConnector<AppState, VoidCallback>(
                          converter: (store) =>
                              () => store.dispatch(DecrementAction()),
                          builder: (_, cb) => ElevatedButton.icon(
                            onPressed: cb,
                            icon: const Icon(Icons.remove),
                            label: const Text('تقليل'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                        StoreConnector<AppState, VoidCallback>(
                          converter: (store) =>
                              () => store.dispatch(ResetAction()),
                          builder: (_, cb) => ElevatedButton.icon(
                            onPressed: cb,
                            icon: const Icon(Icons.refresh),
                            label: const Text('إعادة'),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: callback,
                          icon: const Icon(Icons.add),
                          label: const Text('زيادة'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
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
                      '// 1. Actions\n'
                      'class IncrementAction {}\n'
                      'class DecrementAction {}\n\n'
                      '// 2. Reducer (Pure Function)\n'
                      'int counterReducer(int state, action) {\n'
                      '  if (action is IncrementAction) {\n'
                      '    return state + 1;\n'
                      '  } else if (action is DecrementAction) {\n'
                      '    return state - 1;\n'
                      '  }\n'
                      '  return state; // لا تغيير\n'
                      '}\n\n'
                      '// 3. Dispatch Action\n'
                      'store.dispatch(IncrementAction());\n\n'
                      '// 4. Connect to UI\n'
                      'StoreConnector<AppState, int>(\n'
                      '  converter: (store) => store.state.counter,\n'
                      '  builder: (context, counter) {\n'
                      '    return Text("\$counter");\n'
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

// ═══════════════════════════════════════════════════════════════════
// TAB 3: TODO LIST
// ═══════════════════════════════════════════════════════════════════

class _TodoTab extends StatefulWidget {
  @override
  State<_TodoTab> createState() => _TodoTabState();
}

class _TodoTabState extends State<_TodoTab> {
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
        // Header with Add Todo
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
                        if (value.trim().isNotEmpty) {
                          StoreProvider.of<AppState>(context)
                              .dispatch(AddTodoAction(value));
                          controller.clear();
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      if (controller.text.trim().isNotEmpty) {
                        StoreProvider.of<AppState>(context)
                            .dispatch(AddTodoAction(controller.text));
                        controller.clear();
                      }
                    },
                    child: const Text('إضافة'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              StoreConnector<AppState, List<TodoItem>>(
                converter: (store) => store.state.todos,
                builder: (context, todos) {
                  final completed = todos.where((t) => t.completed).length;
                  final pending = todos.length - completed;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStat('الكل', todos.length, Colors.blue),
                      _buildStat('مكتملة', completed, Colors.green),
                      _buildStat('معلقة', pending, Colors.orange),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
        // Todo List
        Expanded(
          child: StoreConnector<AppState, List<TodoItem>>(
            converter: (store) => store.state.todos,
            builder: (context, todos) {
              if (todos.isEmpty) {
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
                        value: todo.completed,
                        onChanged: (_) {
                          StoreProvider.of<AppState>(context)
                              .dispatch(ToggleTodoAction(todo.id));
                        },
                      ),
                      title: Text(
                        todo.title,
                        style: TextStyle(
                          decoration: todo.completed
                              ? TextDecoration.lineThrough
                              : null,
                          color: todo.completed ? Colors.grey : null,
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          StoreProvider.of<AppState>(context)
                              .dispatch(RemoveTodoAction(todo.id));
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
}

// ═══════════════════════════════════════════════════════════════════
// TAB 4: SHOPPING CART
// ═══════════════════════════════════════════════════════════════════

class _ShoppingTab extends StatelessWidget {
  final products = [
    {'id': '1', 'name': 'كمبيوتر محمول', 'price': 3500.0, 'emoji': '💻'},
    {'id': '2', 'name': 'سماعات', 'price': 150.0, 'emoji': '🎧'},
    {'id': '3', 'name': 'ماوس لاسلكي', 'price': 50.0, 'emoji': '🖱️'},
    {'id': '4', 'name': 'لوحة مفاتيح', 'price': 100.0, 'emoji': '⌨️'},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header - Total Price
        StoreConnector<AppState, Map<String, int>>(
          converter: (store) => store.state.cart,
          builder: (context, cart) {
            final totalPrice = cart.entries.fold(0.0, (sum, entry) {
              final product =
                  products.firstWhere((p) => p['id'] == entry.key);
              return sum + ((product['price'] as double) * entry.value);
            });
            final itemCount = cart.values.fold(0, (sum, qty) => sum + qty);

            return Container(
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
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'الإجمالي: ${totalPrice.toStringAsFixed(2)} ر.س',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      Text(
                        '$itemCount عنصر',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
        // Product List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Text(
                        product['emoji'] as String,
                        style: const TextStyle(fontSize: 48),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product['name'] as String,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${(product['price'] as double).toStringAsFixed(2)} ر.س',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                      StoreConnector<AppState, Map<String, int>>(
                        converter: (store) => store.state.cart,
                        builder: (context, cart) {
                          final quantity = cart[product['id']] ?? 0;
                          return Row(
                            children: [
                              IconButton(
                                onPressed: quantity > 0
                                    ? () {
                                        StoreProvider.of<AppState>(context)
                                            .dispatch(RemoveFromCartAction(
                                                product['id'] as String));
                                      }
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
                                    color: quantity > 0
                                        ? Colors.white
                                        : Colors.grey,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  StoreProvider.of<AppState>(context).dispatch(
                                      AddToCartAction(product['id'] as String));
                                },
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
        StoreConnector<AppState, Map<String, int>>(
          converter: (store) => store.state.cart,
          builder: (context, cart) {
            if (cart.isEmpty) return const SizedBox.shrink();
            return Container(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    StoreProvider.of<AppState>(context)
                        .dispatch(ClearCartAction());
                  },
                  icon: const Icon(Icons.delete_sweep),
                  label: const Text('إفراغ السلة'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// TAB 5: MIDDLEWARE (Async Actions)
// ═══════════════════════════════════════════════════════════════════

class _MiddlewareTab extends StatefulWidget {
  @override
  State<_MiddlewareTab> createState() => _MiddlewareTabState();
}

class _MiddlewareTabState extends State<_MiddlewareTab> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
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
                  'Middleware - Async Actions',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Middleware يعترض Actions قبل وصولها للـ Reducer',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        StoreConnector<AppState, User?>(
          converter: (store) => store.state.user,
          builder: (context, user) {
            if (user != null) {
              return Card(
                color: Colors.green.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.green,
                        child:
                            Icon(Icons.person, size: 48, color: Colors.white),
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
                        onPressed: () {
                          StoreProvider.of<AppState>(context)
                              .dispatch(LogoutAction());
                        },
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
                    const SizedBox(height: 20),
                    StoreConnector<AppState, bool>(
                      converter: (store) => store.state.isLoading,
                      builder: (context, isLoading) {
                        return SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: isLoading
                                ? null
                                : () {
                                    StoreProvider.of<AppState>(context)
                                        .dispatch(LoginRequestAction(
                                      emailController.text,
                                      passwordController.text,
                                    ));
                                  },
                            icon: isLoading
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
                              isLoading ? 'جاري التحميل...' : 'تسجيل الدخول',
                            ),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(16),
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        );
                      },
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
                      'الكود - Middleware',
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
                      'void loginMiddleware(\n'
                      '  Store<AppState> store,\n'
                      '  dynamic action,\n'
                      '  NextDispatcher next,\n'
                      ') {\n'
                      '  if (action is LoginRequestAction) {\n'
                      '    store.dispatch(SetLoadingAction(true));\n\n'
                      '    // Async operation\n'
                      '    Future.delayed(Duration(seconds: 2), () {\n'
                      '      if (action.password == \'123456\') {\n'
                      '        store.dispatch(LoginSuccessAction(\n'
                      '          User(\'أحمد\', action.email)\n'
                      '        ));\n'
                      '      } else {\n'
                      '        store.dispatch(LoginFailureAction());\n'
                      '      }\n'
                      '      store.dispatch(SetLoadingAction(false));\n'
                      '    });\n'
                      '  }\n\n'
                      '  next(action); // مرر للـ Reducer\n'
                      '}',
                      style: TextStyle(
                        color: Colors.greenAccent,
                        fontFamily: 'monospace',
                        fontSize: 9,
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
// TAB 6: TIME TRAVEL DEBUGGING
// ═══════════════════════════════════════════════════════════════════

class _TimeTravelTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          color: Colors.blue.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.history, size: 32, color: Colors.blue),
                    const SizedBox(width: 12),
                    Text(
                      'Time-Travel Debugging',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'من أهم مزايا Redux هي القدرة على "السفر عبر الزمن" '
                  'في تاريخ الحالة.\n\n'
                  'كيف يعمل؟\n'
                  '1. كل Action يتم تسجيله\n'
                  '2. كل State يتم حفظه\n'
                  '3. يمكنك الرجوع لأي نقطة في الماضي\n'
                  '4. يمكنك إعادة تشغيل Actions',
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
                  'الحالة الحالية للتطبيق',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                StoreConnector<AppState, AppState>(
                  converter: (store) => store.state,
                  builder: (context, state) {
                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          'AppState {\n'
                          '  counter: ${state.counter},\n'
                          '  todos: ${state.todos.length} items,\n'
                          '  cart: ${state.cart.length} products,\n'
                          '  user: ${state.user?.name ?? "null"},\n'
                          '  isLoading: ${state.isLoading},\n'
                          '}',
                          style: const TextStyle(
                            color: Colors.greenAccent,
                            fontFamily: 'monospace',
                            fontSize: 12,
                          ),
                        ),
                      ),
                    );
                  },
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
                    const Icon(Icons.lightbulb, color: Colors.green),
                    const SizedBox(width: 8),
                    Text(
                      'فوائد Time-Travel',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text('✓ تصحيح الأخطاء بسهولة'),
                const Text('✓ فهم تدفق البيانات'),
                const Text('✓ إعادة تشغيل سيناريوهات محددة'),
                const Text('✓ اختبار الحالات النادرة'),
                const Text('✓ تسجيل تفاعلات المستخدم'),
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
                      'أدوات التطوير',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'استخدم Redux DevTools للحصول على:\n'
                  '• عرض جميع Actions\n'
                  '• عرض State Tree\n'
                  '• Time Travel Interface\n'
                  '• Hot Reload Support\n'
                  '• Action Replay',
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
                  '⚖️ Redux vs حلول أخرى',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                _buildComparison(
                  'Redux vs Provider',
                  'Redux',
                  '• Single Source of Truth\n'
                      '• Time-Travel Debugging\n'
                      '• Pure Functions\n'
                      '• Middleware للـ async',
                  'Provider',
                  '• أبسط بكثير\n'
                      '• Boilerplate أقل\n'
                      '• مدمج مع Flutter\n'
                      '• مثالي للتطبيقات الصغيرة',
                ),
                const Divider(height: 32),
                _buildComparison(
                  'Redux vs BLoC',
                  'Redux',
                  '• Single Store\n'
                      '• Actions واضحة\n'
                      '• Time-Travel\n'
                      '• مجتمع كبير',
                  'BLoC',
                  '• Multiple BLoCs\n'
                      '• Stream-based\n'
                      '• أفضل لـ Flutter\n'
                      '• Testability أعلى',
                ),
                const Divider(height: 32),
                _buildComparison(
                  'Redux vs MobX',
                  'Redux',
                  '• Predictable\n'
                      '• Pure Functions\n'
                      '• Explicit Updates\n'
                      '• Time-Travel',
                  'MobX',
                  '• Reactive تلقائي\n'
                      '• Boilerplate أقل\n'
                      '• Code Generation\n'
                      '• أسهل في الكتابة',
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
                      'متى تستخدم Redux؟',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text('✓ تطبيقات كبيرة ومعقدة'),
                const Text('✓ تحتاج Time-Travel Debugging'),
                const Text('✓ State مشترك بين أجزاء كثيرة'),
                const Text('✓ فريق كبير يحتاج قواعد واضحة'),
                const Text('✓ لديك خبرة مع Redux في الويب'),
                const Text('✓ تحتاج State Persistence'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          color: Colors.red.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.warning, color: Colors.red),
                    const SizedBox(width: 8),
                    Text(
                      'العيوب',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text('• Boilerplate كثير جداً'),
                const Text('• منحنى تعلم steep'),
                const Text('• قد يكون overkill للتطبيقات الصغيرة'),
                const Text('• Actions و Reducers كثيرة'),
                const Text('• أبطأ في التطوير مقارنة بـ GetX/MobX'),
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
