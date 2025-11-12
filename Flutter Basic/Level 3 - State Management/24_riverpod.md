# 24 - Riverpod - إدارة حالة حديثة

## 📋 المحتويات

- [المقدمة](#المقدمة)
- [تثبيت Riverpod](#تثبيت-riverpod)
- [Provider Types](#provider-types)
- [ConsumerWidget](#consumerwidget)
- [أمثلة عملية](#أمثلة-عملية)

---

## 🎯 المقدمة

Riverpod هو تطوير محسّن لـ Provider مع ميزات إضافية وأمان أكثر في الأنواع.

---

## 📦 تثبيت Riverpod

أضف في `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.4.9
```

ثم نفذ:

```bash
flutter pub get
```

---

## 🔧 Provider Types

### 1. Provider (للقيم الثابتة)

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider بسيط
final greetingProvider = Provider<String>((ref) {
  return 'مرحباً بك في Riverpod';
});

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomePage(),
    );
  }
}

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final greeting = ref.watch(greetingProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Riverpod Demo')),
      body: Center(
        child: Text(greeting),
      ),
    );
  }
}
```

### 2. StateProvider (للحالات البسيطة)

```dart
final counterProvider = StateProvider<int>((ref) => 0);

class CounterPage extends ConsumerWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Counter')),
      body: Center(
        child: Text(
          '$count',
          style: const TextStyle(fontSize: 72),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(counterProvider.notifier).state++;
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

### 3. StateNotifierProvider (للحالات المعقدة)

```dart
class Todo {
  final String id;
  final String title;
  final bool isCompleted;

  Todo({
    required this.id,
    required this.title,
    this.isCompleted = false,
  });

  Todo copyWith({String? title, bool? isCompleted}) {
    return Todo(
      id: id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class TodosNotifier extends StateNotifier<List<Todo>> {
  TodosNotifier() : super([]);

  void addTodo(String title) {
    final todo = Todo(
      id: DateTime.now().toString(),
      title: title,
    );
    state = [...state, todo];
  }

  void toggleTodo(String id) {
    state = [
      for (final todo in state)
        if (todo.id == id)
          todo.copyWith(isCompleted: !todo.isCompleted)
        else
          todo,
    ];
  }

  void removeTodo(String id) {
    state = state.where((todo) => todo.id != id).toList();
  }
}

final todosProvider = StateNotifierProvider<TodosNotifier, List<Todo>>((ref) {
  return TodosNotifier();
});

// Derived providers (Computed)
final completedTodosProvider = Provider<List<Todo>>((ref) {
  final todos = ref.watch(todosProvider);
  return todos.where((todo) => todo.isCompleted).toList();
});

final activeTodosProvider = Provider<List<Todo>>((ref) {
  final todos = ref.watch(todosProvider);
  return todos.where((todo) => !todo.isCompleted).toList();
});
```

### 4. FutureProvider (للعمليات غير المتزامنة)

```dart
final userProvider = FutureProvider<User>((ref) async {
  await Future.delayed(const Duration(seconds: 2));
  return User(id: '1', name: 'أحمد محمد');
});

class UserProfile extends ConsumerWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);

    return userAsync.when(
      data: (user) => Text('مرحباً ${user.name}'),
      loading: () => const CircularProgressIndicator(),
      error: (error, stack) => Text('خطأ: $error'),
    );
  }
}

class User {
  final String id;
  final String name;

  User({required this.id, required this.name});
}
```

---

## 👁️ ConsumerWidget

استخدام ConsumerWidget بدلاً من StatelessWidget:

```dart
// بدلاً من StatelessWidget
class MyWidget extends ConsumerWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // استخدم ref للوصول للـ providers
    final value = ref.watch(myProvider);
    
    return Text('$value');
  }
}

// أو استخدم Consumer داخل Widget عادي
class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final value = ref.watch(myProvider);
        return Text('$value');
      },
    );
  }
}

final myProvider = Provider<String>((ref) => 'Hello');
```

---

## 💼 أمثلة عملية

### تطبيق قائمة مهام كامل

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Models
class Task {
  final String id;
  final String title;
  final bool isCompleted;

  Task({
    required this.id,
    required this.title,
    this.isCompleted = false,
  });

  Task copyWith({String? title, bool? isCompleted}) {
    return Task(
      id: id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

// State Notifier
class TasksNotifier extends StateNotifier<List<Task>> {
  TasksNotifier() : super([]);

  void addTask(String title) {
    state = [
      ...state,
      Task(id: DateTime.now().toString(), title: title),
    ];
  }

  void toggleTask(String id) {
    state = [
      for (final task in state)
        if (task.id == id)
          task.copyWith(isCompleted: !task.isCompleted)
        else
          task,
    ];
  }

  void removeTask(String id) {
    state = state.where((task) => task.id != id).toList();
  }

  void clearCompleted() {
    state = state.where((task) => !task.isCompleted).toList();
  }
}

// Providers
final tasksProvider = StateNotifierProvider<TasksNotifier, List<Task>>((ref) {
  return TasksNotifier();
});

final completedTasksProvider = Provider<List<Task>>((ref) {
  final tasks = ref.watch(tasksProvider);
  return tasks.where((task) => task.isCompleted).toList();
});

final activeTasksProvider = Provider<List<Task>>((ref) {
  final tasks = ref.watch(tasksProvider);
  return tasks.where((task) => !task.isCompleted).toList();
});

final taskStatsProvider = Provider<Map<String, int>>((ref) {
  final tasks = ref.watch(tasksProvider);
  final completed = ref.watch(completedTasksProvider);
  final active = ref.watch(activeTasksProvider);

  return {
    'total': tasks.length,
    'completed': completed.length,
    'active': active.length,
  };
});

// Filter Provider
enum TaskFilter { all, active, completed }

final taskFilterProvider = StateProvider<TaskFilter>((ref) {
  return TaskFilter.all;
});

final filteredTasksProvider = Provider<List<Task>>((ref) {
  final filter = ref.watch(taskFilterProvider);
  final tasks = ref.watch(tasksProvider);

  switch (filter) {
    case TaskFilter.active:
      return ref.watch(activeTasksProvider);
    case TaskFilter.completed:
      return ref.watch(completedTasksProvider);
    case TaskFilter.all:
    default:
      return tasks;
  }
});

// App
void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Riverpod Todo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const TodoScreen(),
    );
  }
}

class TodoScreen extends ConsumerStatefulWidget {
  const TodoScreen({super.key});

  @override
  ConsumerState<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends ConsumerState<TodoScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addTask() {
    if (_controller.text.isNotEmpty) {
      ref.read(tasksProvider.notifier).addTask(_controller.text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final stats = ref.watch(taskStatsProvider);
    final filter = ref.watch(taskFilterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('قائمة المهام'),
        actions: [
          PopupMenuButton<TaskFilter>(
            initialValue: filter,
            onSelected: (value) {
              ref.read(taskFilterProvider.notifier).state = value;
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: TaskFilter.all,
                child: Text('الكل'),
              ),
              PopupMenuItem(
                value: TaskFilter.active,
                child: Text('النشطة'),
              ),
              PopupMenuItem(
                value: TaskFilter.completed,
                child: Text('المكتملة'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Stats
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.blue.shade50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStat('الإجمالي', stats['total']!),
                _buildStat('نشطة', stats['active']!),
                _buildStat('مكتملة', stats['completed']!),
              ],
            ),
          ),

          // Input
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'أضف مهمة جديدة',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _addTask(),
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton(
                  onPressed: _addTask,
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ),

          // Task List
          Expanded(
            child: Consumer(
              builder: (context, ref, child) {
                final tasks = ref.watch(filteredTasksProvider);

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
                        ref.read(tasksProvider.notifier).removeTask(task.id);
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
                          ref.read(tasksProvider.notifier).toggleTask(task.id);
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // Clear Completed
          Consumer(
            builder: (context, ref, child) {
              final completedCount = ref.watch(
                taskStatsProvider.select((stats) => stats['completed']),
              );

              if (completedCount == 0) return const SizedBox.shrink();

              return Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: () {
                    ref.read(tasksProvider.notifier).clearCompleted();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: Text('مسح المهام المكتملة ($completedCount)'),
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
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(label),
      ],
    );
  }
}
```

### نظام مصادقة

```dart
class AuthUser {
  final String id;
  final String name;
  final String email;

  AuthUser({
    required this.id,
    required this.name,
    required this.email,
  });
}

class AuthNotifier extends StateNotifier<AsyncValue<AuthUser?>> {
  AuthNotifier() : super(const AsyncValue.data(null));

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();

    try {
      await Future.delayed(const Duration(seconds: 2));

      final user = AuthUser(
        id: '123',
        name: 'أحمد محمد',
        email: email,
      );

      state = AsyncValue.data(user);
    } catch (error, stack) {
      state = AsyncValue.error(error, stack);
    }
  }

  Future<void> logout() async {
    state = const AsyncValue.data(null);
  }
}

final authProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<AuthUser?>>((ref) {
  return AuthNotifier();
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authProvider);
  return authState.value != null;
});

class AuthApp extends ConsumerWidget {
  const AuthApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAuthenticated = ref.watch(isAuthenticatedProvider);

    return MaterialApp(
      home: isAuthenticated ? const HomeScreen() : const LoginScreen(),
    );
  }
}

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
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
    final authState = ref.watch(authProvider);

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
              onPressed: authState.isLoading
                  ? null
                  : () {
                      ref.read(authProvider.notifier).login(
                            _emailController.text,
                            _passwordController.text,
                          );
                    },
              child: authState.isLoading
                  ? const CircularProgressIndicator()
                  : const Text('تسجيل الدخول'),
            ),
            if (authState.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  'خطأ: ${authState.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.value;

    return Scaffold(
      appBar: AppBar(
        title: const Text('الرئيسية'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authProvider.notifier).logout();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'مرحباً ${user?.name}',
              style: const TextStyle(fontSize: 24),
            ),
            Text(user?.email ?? ''),
          ],
        ),
      ),
    );
  }
}
```

---

## 📚 المراجع والمصادر

1. **Riverpod Package**
   - [Riverpod](https://pub.dev/packages/riverpod)
   - [Flutter Riverpod](https://pub.dev/packages/flutter_riverpod)

2. **Documentation**
   - [Riverpod Documentation](https://riverpod.dev/)
   - [Getting Started](https://riverpod.dev/docs/getting_started)

3. **Migration**
   - [From Provider to Riverpod](https://riverpod.dev/docs/from_provider/motivation)

---

## 💡 نصائح

- ✅ Riverpod أكثر أماناً وقوة من Provider
- ✅ لا يحتاج BuildContext للوصول للـ Providers
- ✅ استخدم `ref.watch` للقراءة والتحديث التلقائي
- ✅ استخدم `ref.read` للقراءة مرة واحدة (في الأحداث)
- ✅ `ref.listen` للاستماع للتغييرات وتنفيذ Side Effects

---

[⬅️ السابق: Provider](23_provider.md)
[🏠 العودة للفهرس](../README.md)
[التالي: BLoC ➡️](25_bloc.md)
