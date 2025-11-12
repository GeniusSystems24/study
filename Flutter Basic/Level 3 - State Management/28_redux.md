# 28 - Redux - إدارة حالة يمكن التنبؤ بها

## 📋 المحتويات

- [28 - Redux - إدارة حالة يمكن التنبؤ بها](#28---redux---إدارة-حالة-يمكن-التنبؤ-بها)
  - [📋 المحتويات](#-المحتويات)
  - [🎯 المقدمة](#-المقدمة)
  - [📦 تثبيت Redux](#-تثبيت-redux)
  - [🏪 Store و State](#-store-و-state)
  - [⚡ Actions](#-actions)
  - [🔄 Reducers](#-reducers)
  - [🔌 Middleware](#-middleware)
  - [💼 أمثلة عملية](#-أمثلة-عملية)
    - [عداد بسيط](#عداد-بسيط)
    - [تطبيق قائمة مهام](#تطبيق-قائمة-مهام)
    - [تطبيق تسجيل دخول](#تطبيق-تسجيل-دخول)
  - [📚 المراجع والمصادر](#-المراجع-والمصادر)
  - [💡 نصائح](#-نصائح)

---

## 🎯 المقدمة

Redux نمط لإدارة الحالة يجعلها قابلة للتنبؤ باستخدام Store واحد مع Reducers نقية.

**المبادئ الأساسية:**

- **Single Source of Truth**: مخزن واحد للحالة
- **State is Read-Only**: لا يمكن تعديل الحالة مباشرة
- **Changes via Pure Functions**: التغييرات عبر Reducers نقية

---

## 📦 تثبيت Redux

أضف في `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_redux: ^0.10.0
  redux: ^5.0.0
```

ثم نفذ:

```bash
flutter pub get
```

---

## 🏪 Store و State

إنشاء State:

```dart
// app_state.dart
class AppState {
  final int counter;

  AppState({required this.counter});

  factory AppState.initial() {
    return AppState(counter: 0);
  }

  AppState copyWith({int? counter}) {
    return AppState(counter: counter ?? this.counter);
  }
}
```

---

## ⚡ Actions

تعريف الإجراءات:

```dart
// actions.dart
class IncrementAction {}

class DecrementAction {}

class ResetAction {}

class SetCounterAction {
  final int value;
  SetCounterAction(this.value);
}
```

---

## 🔄 Reducers

إنشاء Reducers:

```dart
// reducers.dart
import 'package:redux/redux.dart';

AppState appReducer(AppState state, dynamic action) {
  if (action is IncrementAction) {
    return state.copyWith(counter: state.counter + 1);
  } else if (action is DecrementAction) {
    return state.copyWith(counter: state.counter - 1);
  } else if (action is ResetAction) {
    return state.copyWith(counter: 0);
  } else if (action is SetCounterAction) {
    return state.copyWith(counter: action.value);
  }
  return state;
}

// أو باستخدام combineReducers
final counterReducer = TypedReducer<AppState, dynamic>(_counterReducer);

AppState _counterReducer(AppState state, dynamic action) {
  return state.copyWith(
    counter: counterValueReducer(state.counter, action),
  );
}

final Reducer<int> counterValueReducer = combineReducers<int>([
  TypedReducer<int, IncrementAction>(_increment),
  TypedReducer<int, DecrementAction>(_decrement),
  TypedReducer<int, ResetAction>(_reset),
]);

int _increment(int count, IncrementAction action) => count + 1;
int _decrement(int count, DecrementAction action) => count - 1;
int _reset(int count, ResetAction action) => 0;
```

---

## 🔌 Middleware

إنشاء Middleware:

```dart
// middleware.dart
import 'package:redux/redux.dart';

// Logging Middleware
void loggingMiddleware(
  Store<AppState> store,
  dynamic action,
  NextDispatcher next,
) {
  print('Action: $action');
  print('State Before: ${store.state.counter}');
  
  next(action);
  
  print('State After: ${store.state.counter}');
  print('---');
}

// Async Middleware
List<Middleware<AppState>> createMiddleware() {
  return [
    TypedMiddleware<AppState, dynamic>(loggingMiddleware),
  ];
}
```

---

## 💼 أمثلة عملية

### عداد بسيط

```dart
// app_state.dart
class AppState {
  final int counter;

  AppState({required this.counter});

  factory AppState.initial() => AppState(counter: 0);

  AppState copyWith({int? counter}) {
    return AppState(counter: counter ?? this.counter);
  }
}

// actions.dart
class IncrementAction {}
class DecrementAction {}

// reducer.dart
import 'package:redux/redux.dart';

AppState appReducer(AppState state, dynamic action) {
  return AppState(
    counter: counterReducer(state.counter, action),
  );
}

final Reducer<int> counterReducer = combineReducers<int>([
  TypedReducer<int, IncrementAction>((count, _) => count + 1),
  TypedReducer<int, DecrementAction>((count, _) => count - 1),
]);

// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

void main() {
  final store = Store<AppState>(
    appReducer,
    initialState: AppState.initial(),
  );

  runApp(MyApp(store: store));
}

class MyApp extends StatelessWidget {
  final Store<AppState> store;

  const MyApp({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        title: 'Redux Counter',
        home: const CounterPage(),
      ),
    );
  }
}

class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Redux Counter')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('العدد:', style: TextStyle(fontSize: 24)),
            StoreConnector<AppState, int>(
              converter: (store) => store.state.counter,
              builder: (context, count) {
                return Text(
                  '$count',
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
              StoreProvider.of<AppState>(context).dispatch(IncrementAction());
            },
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: 'decrement',
            onPressed: () {
              StoreProvider.of<AppState>(context).dispatch(DecrementAction());
            },
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}
```

### تطبيق قائمة مهام

```dart
// models/task.dart
class Task {
  final String id;
  final String title;
  final bool isCompleted;

  Task({
    required this.id,
    required this.title,
    this.isCompleted = false,
  });

  Task copyWith({String? id, String? title, bool? isCompleted}) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

// app_state.dart
class AppState {
  final List<Task> tasks;

  AppState({required this.tasks});

  factory AppState.initial() => AppState(tasks: []);

  AppState copyWith({List<Task>? tasks}) {
    return AppState(tasks: tasks ?? this.tasks);
  }

  int get totalCount => tasks.length;
  int get completedCount => tasks.where((t) => t.isCompleted).length;
  int get activeCount => tasks.where((t) => !t.isCompleted).length;
}

// actions.dart
class AddTaskAction {
  final String title;
  AddTaskAction(this.title);
}

class ToggleTaskAction {
  final String id;
  ToggleTaskAction(this.id);
}

class RemoveTaskAction {
  final String id;
  RemoveTaskAction(this.id);
}

class ClearCompletedAction {}

// reducer.dart
import 'package:redux/redux.dart';

AppState appReducer(AppState state, dynamic action) {
  return AppState(
    tasks: tasksReducer(state.tasks, action),
  );
}

final Reducer<List<Task>> tasksReducer = combineReducers<List<Task>>([
  TypedReducer<List<Task>, AddTaskAction>(_addTask),
  TypedReducer<List<Task>, ToggleTaskAction>(_toggleTask),
  TypedReducer<List<Task>, RemoveTaskAction>(_removeTask),
  TypedReducer<List<Task>, ClearCompletedAction>(_clearCompleted),
]);

List<Task> _addTask(List<Task> tasks, AddTaskAction action) {
  return [
    ...tasks,
    Task(
      id: DateTime.now().toString(),
      title: action.title,
    ),
  ];
}

List<Task> _toggleTask(List<Task> tasks, ToggleTaskAction action) {
  return tasks.map((task) {
    if (task.id == action.id) {
      return task.copyWith(isCompleted: !task.isCompleted);
    }
    return task;
  }).toList();
}

List<Task> _removeTask(List<Task> tasks, RemoveTaskAction action) {
  return tasks.where((task) => task.id != action.id).toList();
}

List<Task> _clearCompleted(List<Task> tasks, ClearCompletedAction action) {
  return tasks.where((task) => !task.isCompleted).toList();
}

// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

void main() {
  final store = Store<AppState>(
    appReducer,
    initialState: AppState.initial(),
  );

  runApp(MyApp(store: store));
}

class MyApp extends StatelessWidget {
  final Store<AppState> store;

  const MyApp({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        title: 'Redux Todo',
        home: const TodoScreen(),
      ),
    );
  }
}

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('قائمة المهام - Redux')),
      body: Column(
        children: [
          // Stats
          StoreConnector<AppState, AppState>(
            converter: (store) => store.state,
            builder: (context, state) {
              return Container(
                padding: const EdgeInsets.all(16),
                color: Colors.blue.shade50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStat('الإجمالي', state.totalCount),
                    _buildStat('نشطة', state.activeCount),
                    _buildStat('مكتملة', state.completedCount),
                  ],
                ),
              );
            },
          ),

          // Input
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: 'أضف مهمة جديدة',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        StoreProvider.of<AppState>(context)
                            .dispatch(AddTaskAction(value));
                        controller.clear();
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton(
                  onPressed: () {
                    if (controller.text.isNotEmpty) {
                      StoreProvider.of<AppState>(context)
                          .dispatch(AddTaskAction(controller.text));
                      controller.clear();
                    }
                  },
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ),

          // Tasks List
          Expanded(
            child: StoreConnector<AppState, List<Task>>(
              converter: (store) => store.state.tasks,
              builder: (context, tasks) {
                if (tasks.isEmpty) {
                  return const Center(child: Text('لا توجد مهام'));
                }

                return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
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
                        StoreProvider.of<AppState>(context)
                            .dispatch(RemoveTaskAction(task.id));
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
                          StoreProvider.of<AppState>(context)
                              .dispatch(ToggleTaskAction(task.id));
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // Clear Completed
          StoreConnector<AppState, int>(
            converter: (store) => store.state.completedCount,
            builder: (context, completedCount) {
              if (completedCount == 0) return const SizedBox.shrink();

              return Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: () {
                    StoreProvider.of<AppState>(context)
                        .dispatch(ClearCompletedAction());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: Text('مسح المكتملة ($completedCount)'),
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
          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
        Text(label),
      ],
    );
  }
}
```

### تطبيق تسجيل دخول

```dart
// models/user.dart
class User {
  final String id;
  final String name;
  final String email;

  User({required this.id, required this.name, required this.email});
}

// app_state.dart
class AuthState {
  final User? user;
  final bool isLoading;
  final String? error;

  AuthState({
    this.user,
    this.isLoading = false,
    this.error,
  });

  factory AuthState.initial() => AuthState();

  AuthState copyWith({
    User? user,
    bool? isLoading,
    String? error,
    bool clearUser = false,
    bool clearError = false,
  }) {
    return AuthState(
      user: clearUser ? null : (user ?? this.user),
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }

  bool get isAuthenticated => user != null;
}

// actions.dart
class LoginRequestAction {
  final String email;
  final String password;
  LoginRequestAction(this.email, this.password);
}

class LoginSuccessAction {
  final User user;
  LoginSuccessAction(this.user);
}

class LoginFailureAction {
  final String error;
  LoginFailureAction(this.error);
}

class LogoutAction {}

// reducer.dart
import 'package:redux/redux.dart';

AuthState authReducer(AuthState state, dynamic action) {
  if (action is LoginRequestAction) {
    return state.copyWith(isLoading: true, clearError: true);
  } else if (action is LoginSuccessAction) {
    return state.copyWith(
      user: action.user,
      isLoading: false,
      clearError: true,
    );
  } else if (action is LoginFailureAction) {
    return state.copyWith(
      isLoading: false,
      error: action.error,
      clearUser: true,
    );
  } else if (action is LogoutAction) {
    return AuthState.initial();
  }
  return state;
}

// middleware.dart
void authMiddleware(
  Store<AuthState> store,
  dynamic action,
  NextDispatcher next,
) {
  if (action is LoginRequestAction) {
    next(action);

    // محاكاة استدعاء API
    Future.delayed(const Duration(seconds: 2)).then((_) {
      if (action.email == 'test@test.com' && action.password == '123456') {
        store.dispatch(LoginSuccessAction(
          User(
            id: '1',
            name: 'محمد أحمد',
            email: action.email,
          ),
        ));
      } else {
        store.dispatch(LoginFailureAction('البريد أو كلمة المرور خاطئة'));
      }
    });
  } else {
    next(action);
  }
}

// main.dart
void main() {
  final store = Store<AuthState>(
    authReducer,
    initialState: AuthState.initial(),
    middleware: [authMiddleware],
  );

  runApp(MyApp(store: store));
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController(text: 'test@test.com');
  final passwordController = TextEditingController(text: '123456');

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تسجيل الدخول')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: StoreConnector<AuthState, AuthState>(
          converter: (store) => store.state,
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                if (state.error != null)
                  Text(
                    state.error!,
                    style: const TextStyle(color: Colors.red),
                  ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: state.isLoading
                      ? null
                      : () {
                          StoreProvider.of<AuthState>(context).dispatch(
                            LoginRequestAction(
                              emailController.text,
                              passwordController.text,
                            ),
                          );
                        },
                  child: state.isLoading
                      ? const CircularProgressIndicator()
                      : const Text('تسجيل الدخول'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
```

---

## 📚 المراجع والمصادر

1. **Redux Packages**
   - [redux](https://pub.dev/packages/redux)
   - [flutter_redux](https://pub.dev/packages/flutter_redux)

2. **Documentation**
   - [Redux Documentation](https://redux.js.org/)
   - [Flutter Redux](https://pub.dev/documentation/flutter_redux/latest/)

3. **Patterns**
   - [Redux Pattern](https://redux.js.org/understanding/thinking-in-redux/three-principles)

---

## 💡 نصائح

- ✅ Store واحد لكل التطبيق
- ✅ Reducers يجب أن تكون Pure Functions
- ✅ استخدم `StoreConnector` لربط الويدجت بالـ Store
- ✅ Middleware للإجراءات غير المتزامنة
- ✅ استخدم `copyWith` لإنشاء حالات جديدة
- ✅ Actions كـ Classes بدلاً من Strings

---

[⬅️ السابق: MobX](27_mobx.md)
[🏠 العودة للفهرس](../README.md)
[التالي: مقارنة حلول State ➡️](29_state_comparison.md)
