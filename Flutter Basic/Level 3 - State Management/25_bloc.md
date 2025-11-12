# 25 - BLoC Pattern - إدارة الحالة بالأحداث

## 📋 المحتويات

- [المقدمة](#المقدمة)
- [تثبيت BLoC](#تثبيت-bloc)
- [Cubit - الأساسي](#cubit---الأساسي)
- [BLoC - متقدم](#bloc---متقدم)
- [أمثلة عملية](#أمثلة-عملية)

---

## 🎯 المقدمة

BLoC (Business Logic Component) نمط لفصل منطق العمل عن واجهة المستخدم باستخدام Streams والأحداث.

---

## 📦 تثبيت BLoC

أضف في `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_bloc: ^8.1.3
  equatable: ^2.0.5
```

ثم نفذ:

```bash
flutter pub get
```

---

## 🎲 Cubit - الأساسي

Cubit نسخة مبسطة من BLoC بدون أحداث:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// 1. إنشاء Cubit
class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);

  void increment() => emit(state + 1);
  void decrement() => emit(state - 1);
  void reset() => emit(0);
}

// 2. توفير Cubit
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (context) => CounterCubit(),
        child: const CounterPage(),
      ),
    );
  }
}

// 3. استخدام Cubit
class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cubit Counter')),
      body: Center(
        child: BlocBuilder<CounterCubit, int>(
          builder: (context, count) {
            return Text(
              '$count',
              style: const TextStyle(fontSize: 72),
            );
          },
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'increment',
            onPressed: () => context.read<CounterCubit>().increment(),
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: 'decrement',
            onPressed: () => context.read<CounterCubit>().decrement(),
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}
```

---

## 🎯 BLoC - متقدم

BLoC كامل مع الأحداث والحالات:

```dart
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// 1. تعريف الأحداث
abstract class CounterEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class IncrementPressed extends CounterEvent {}

class DecrementPressed extends CounterEvent {}

class ResetPressed extends CounterEvent {}

// 2. تعريف الحالات
class CounterState extends Equatable {
  final int count;

  const CounterState(this.count);

  @override
  List<Object> get props => [count];
}

// 3. إنشاء BLoC
class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(const CounterState(0)) {
    on<IncrementPressed>((event, emit) {
      emit(CounterState(state.count + 1));
    });

    on<DecrementPressed>((event, emit) {
      emit(CounterState(state.count - 1));
    });

    on<ResetPressed>((event, emit) {
      emit(const CounterState(0));
    });
  }
}

// 4. الاستخدام
class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CounterBloc(),
      child: Scaffold(
        appBar: AppBar(title: const Text('BLoC Counter')),
        body: Center(
          child: BlocBuilder<CounterBloc, CounterState>(
            builder: (context, state) {
              return Text(
                '${state.count}',
                style: const TextStyle(fontSize: 72),
              );
            },
          ),
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: 'increment',
              onPressed: () {
                context.read<CounterBloc>().add(IncrementPressed());
              },
              child: const Icon(Icons.add),
            ),
            const SizedBox(height: 8),
            FloatingActionButton(
              heroTag: 'decrement',
              onPressed: () {
                context.read<CounterBloc>().add(DecrementPressed());
              },
              child: const Icon(Icons.remove),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 💼 أمثلة عملية

### تطبيق قائمة مهام

```dart
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Models
class Task extends Equatable {
  final String id;
  final String title;
  final bool isCompleted;

  const Task({
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

  @override
  List<Object?> get props => [id, title, isCompleted];
}

// Events
abstract class TodoEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddTodo extends TodoEvent {
  final String title;

  AddTodo(this.title);

  @override
  List<Object?> get props => [title];
}

class ToggleTodo extends TodoEvent {
  final String id;

  ToggleTodo(this.id);

  @override
  List<Object?> get props => [id];
}

class DeleteTodo extends TodoEvent {
  final String id;

  DeleteTodo(this.id);

  @override
  List<Object?> get props => [id];
}

class ClearCompleted extends TodoEvent {}

// State
class TodoState extends Equatable {
  final List<Task> tasks;

  const TodoState(this.tasks);

  List<Task> get activeTasks =>
      tasks.where((task) => !task.isCompleted).toList();

  List<Task> get completedTasks =>
      tasks.where((task) => task.isCompleted).toList();

  int get totalCount => tasks.length;
  int get activeCount => activeTasks.length;
  int get completedCount => completedTasks.length;

  @override
  List<Object?> get props => [tasks];
}

// BLoC
class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc() : super(const TodoState([])) {
    on<AddTodo>((event, emit) {
      final task = Task(
        id: DateTime.now().toString(),
        title: event.title,
      );
      emit(TodoState([...state.tasks, task]));
    });

    on<ToggleTodo>((event, emit) {
      final updatedTasks = state.tasks.map((task) {
        if (task.id == event.id) {
          return task.copyWith(isCompleted: !task.isCompleted);
        }
        return task;
      }).toList();
      emit(TodoState(updatedTasks));
    });

    on<DeleteTodo>((event, emit) {
      final updatedTasks =
          state.tasks.where((task) => task.id != event.id).toList();
      emit(TodoState(updatedTasks));
    });

    on<ClearCompleted>((event, emit) {
      final updatedTasks =
          state.tasks.where((task) => !task.isCompleted).toList();
      emit(TodoState(updatedTasks));
    });
  }
}

// UI
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BLoC Todo',
      home: BlocProvider(
        create: (context) => TodoBloc(),
        child: const TodoScreen(),
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
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addTask(BuildContext context) {
    if (_controller.text.isNotEmpty) {
      context.read<TodoBloc>().add(AddTodo(_controller.text));
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('قائمة المهام - BLoC')),
      body: Column(
        children: [
          // Stats
          BlocBuilder<TodoBloc, TodoState>(
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
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'أضف مهمة جديدة',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _addTask(context),
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton(
                  onPressed: () => _addTask(context),
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ),

          // Tasks List
          Expanded(
            child: BlocBuilder<TodoBloc, TodoState>(
              builder: (context, state) {
                if (state.tasks.isEmpty) {
                  return const Center(child: Text('لا توجد مهام'));
                }

                return ListView.builder(
                  itemCount: state.tasks.length,
                  itemBuilder: (context, index) {
                    final task = state.tasks[index];
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
                        context.read<TodoBloc>().add(DeleteTodo(task.id));
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
                          context.read<TodoBloc>().add(ToggleTodo(task.id));
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // Clear Completed
          BlocBuilder<TodoBloc, TodoState>(
            builder: (context, state) {
              if (state.completedCount == 0) {
                return const SizedBox.shrink();
              }

              return Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: () {
                    context.read<TodoBloc>().add(ClearCompleted());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: Text('مسح المكتملة (${state.completedCount})'),
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

### نظام مصادقة مع حالات متعددة

```dart
// States
abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final String userName;
  final String email;

  AuthAuthenticated({required this.userName, required this.email});

  @override
  List<Object?> get props => [userName, email];
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

// Events
abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  LoginRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class LogoutRequested extends AuthEvent {}

// BLoC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());

      try {
        // محاكاة طلب تسجيل الدخول
        await Future.delayed(const Duration(seconds: 2));

        if (event.email.isEmpty || event.password.isEmpty) {
          emit(AuthError('الرجاء إدخال البريد وكلمة المرور'));
          return;
        }

        emit(AuthAuthenticated(
          userName: 'أحمد محمد',
          email: event.email,
        ));
      } catch (e) {
        emit(AuthError('حدث خطأ في تسجيل الدخول'));
      }
    });

    on<LogoutRequested>((event, emit) {
      emit(AuthUnauthenticated());
    });
  }
}

// Login Screen
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
    return Scaffold(
      appBar: AppBar(title: const Text('تسجيل الدخول')),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          return Padding(
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
                  onPressed: state is AuthLoading
                      ? null
                      : () {
                          context.read<AuthBloc>().add(
                                LoginRequested(
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                ),
                              );
                        },
                  child: state is AuthLoading
                      ? const CircularProgressIndicator()
                      : const Text('تسجيل الدخول'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('الرئيسية'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () {
                    context.read<AuthBloc>().add(LogoutRequested());
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'مرحباً ${state.userName}',
                    style: const TextStyle(fontSize: 24),
                  ),
                  Text(state.email),
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
```

---

## 📚 المراجع والمصادر

1. **BLoC Package**
   - [flutter_bloc](https://pub.dev/packages/flutter_bloc)
   - [bloc](https://pub.dev/packages/bloc)

2. **Documentation**
   - [BLoC Library](https://bloclibrary.dev/)
   - [Core Concepts](https://bloclibrary.dev/#/coreconcepts)

3. **Tutorials**
   - [Flutter BLoC Tutorial](https://bloclibrary.dev/#/flutterbloccoreconcepts)

---

## 💡 نصائح

- ✅ استخدم Cubit للحالات البسيطة
- ✅ استخدم BLoC للمنطق المعقد مع الأحداث
- ✅ `BlocBuilder` لإعادة بناء الواجهة
- ✅ `BlocListener` للـ Side Effects (Navigation, SnackBar)
- ✅ `BlocConsumer` للجمع بين Builder و Listener

---

[⬅️ السابق: Riverpod](24_riverpod.md)
[🏠 العودة للفهرس](../README.md)
[التالي: GetX ➡️](26_getx.md)
