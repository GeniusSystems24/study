import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// شاشة عرض Riverpod - الموضوع 24
class RiverpodDemo extends ConsumerWidget {
  const RiverpodDemo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riverpod'),
      ),
      body: DefaultTabController(
        length: 7,
        child: Column(
          children: [
            const TabBar(
              isScrollable: true,
              tabs: [
                Tab(text: 'مقدمة'),
                Tab(text: 'StateProvider'),
                Tab(text: 'StateNotifier'),
                Tab(text: 'FutureProvider'),
                Tab(text: 'StreamProvider'),
                Tab(text: 'Family & AutoDispose'),
                Tab(text: 'مقارنة الأنواع'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _IntroTab(),
                  _StateProviderTab(),
                  _StateNotifierTab(),
                  _FutureProviderTab(),
                  _StreamProviderTab(),
                  _FamilyAutoDisposeTab(),
                  _ComparisonTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Riverpod Providers

// 1. StateProvider - للحالات البسيطة
final counterProvider = StateProvider<int>((ref) => 0);

final doubledCounterProvider = Provider<int>((ref) {
  final count = ref.watch(counterProvider);
  return count * 2;
});

// 2. StateNotifier - للحالات المعقدة
class TodoState {
  final List<TodoItem> todos;
  final String filter;
  
  TodoState({
    this.todos = const [],
    this.filter = 'all',
  });
  
  TodoState copyWith({
    List<TodoItem>? todos,
    String? filter,
  }) {
    return TodoState(
      todos: todos ?? this.todos,
      filter: filter ?? this.filter,
    );
  }
  
  List<TodoItem> get filteredTodos {
    switch (filter) {
      case 'completed':
        return todos.where((t) => t.isCompleted).toList();
      case 'pending':
        return todos.where((t) => !t.isCompleted).toList();
      default:
        return todos;
    }
  }
  
  int get completedCount => todos.where((t) => t.isCompleted).length;
  int get pendingCount => todos.where((t) => !t.isCompleted).length;
}

class TodoItem {
  final String id;
  final String title;
  final bool isCompleted;
  
  TodoItem({
    required this.id,
    required this.title,
    this.isCompleted = false,
  });
  
  TodoItem copyWith({
    String? id,
    String? title,
    bool? isCompleted,
  }) {
    return TodoItem(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class TodoNotifier extends StateNotifier<TodoState> {
  TodoNotifier() : super(TodoState());
  
  void addTodo(String title) {
    final newTodo = TodoItem(
      id: DateTime.now().toString(),
      title: title,
    );
    state = state.copyWith(
      todos: [...state.todos, newTodo],
    );
  }
  
  void toggleTodo(String id) {
    state = state.copyWith(
      todos: state.todos.map((todo) {
        if (todo.id == id) {
          return todo.copyWith(isCompleted: !todo.isCompleted);
        }
        return todo;
      }).toList(),
    );
  }
  
  void removeTodo(String id) {
    state = state.copyWith(
      todos: state.todos.where((t) => t.id != id).toList(),
    );
  }
  
  void setFilter(String filter) {
    state = state.copyWith(filter: filter);
  }
  
  void clearCompleted() {
    state = state.copyWith(
      todos: state.todos.where((t) => !t.isCompleted).toList(),
    );
  }
}

final todoProvider = StateNotifierProvider<TodoNotifier, TodoState>((ref) {
  return TodoNotifier();
});

// 3. FutureProvider - للبيانات الغير متزامنة
class User {
  final String name;
  final String email;
  final String avatar;
  
  User({required this.name, required this.email, required this.avatar});
}

final userProvider = FutureProvider<User>((ref) async {
  // محاكاة استدعاء API
  await Future.delayed(const Duration(seconds: 2));
  return User(
    name: 'أحمد محمد',
    email: 'ahmed@example.com',
    avatar: '👤',
  );
});

// Provider with parameter using family
final userByIdProvider = FutureProvider.family<User, int>((ref, userId) async {
  await Future.delayed(const Duration(seconds: 1));
  return User(
    name: 'مستخدم $userId',
    email: 'user$userId@example.com',
    avatar: userId % 2 == 0 ? '👨' : '👩',
  );
});

// 4. StreamProvider - للبيانات المتدفقة
final timeProvider = StreamProvider<DateTime>((ref) {
  return Stream.periodic(
    const Duration(seconds: 1),
    (_) => DateTime.now(),
  );
});

final countdownProvider = StreamProvider.family<int, int>((ref, from) {
  return Stream.periodic(
    const Duration(seconds: 1),
    (count) => from - count - 1,
  ).take(from);
});

// 5. AutoDispose - تنظيف تلقائي
final autoDisposeCounterProvider = StateProvider.autoDispose<int>((ref) {
  // سيتم التخلص منه تلقائياً عند عدم الاستخدام
  ref.onDispose(() {
    print('Counter disposed');
  });
  return 0;
});

// التاب الأول: مقدمة
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
                  '🚀 Riverpod - النسخة المحسنة من Provider',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Riverpod هو إعادة كتابة كاملة لـ Provider مع تحسينات كبيرة:\n\n'
                  '• لا يعتمد على BuildContext\n'
                  '• Compile-time safety\n'
                  '• أفضل للتطبيقات الكبيرة',
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
                Text(
                  '✨ المزايا على Provider',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                const Text('✓ لا حاجة لـ BuildContext'),
                const Text('✓ Compile-time safety'),
                const Text('✓ أفضل للتطبيقات الكبيرة'),
                const Text('✓ Testing أسهل'),
                const Text('✓ Provider Scoping محسّن'),
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
                Text(
                  'أنواع Providers',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                const Text('1️⃣ Provider - بيانات ثابتة'),
                const Text('2️⃣ StateProvider - state بسيط'),
                const Text('3️⃣ StateNotifierProvider - state معقد'),
                const Text('4️⃣ FutureProvider - async data'),
                const Text('5️⃣ StreamProvider - stream data'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// التاب الثاني: StateProvider - العداد البسيط
class _StateProviderTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);
    final doubled = ref.watch(doubledCounterProvider);
    
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  'Counter مع Riverpod',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 24),
                
                Text(
                  '$count',
                  style: const TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                Text(
                  'مضاعف: $doubled',
                  style: const TextStyle(fontSize: 24),
                ),
                
                const SizedBox(height: 24),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        ref.read(counterProvider.notifier).state--;
                      },
                      icon: const Icon(Icons.remove),
                      label: const Text('تقليل'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: () {
                        ref.read(counterProvider.notifier).state = 0;
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('إعادة تعيين'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: () {
                        ref.read(counterProvider.notifier).state++;
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('زيادة'),
                    ),
                  ],
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
                    const Icon(Icons.code, color: Colors.blue),
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
                      '// 1. تعريف Provider\n'
                      'final counterProvider = StateProvider<int>((ref) => 0);\n\n'
                      '// 2. القراءة\n'
                      'final count = ref.watch(counterProvider);\n\n'
                      '// 3. التعديل\n'
                      'ref.read(counterProvider.notifier).state++;',
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

// التاب الثالث: StateNotifier - Todo List
class _StateNotifierTab extends ConsumerStatefulWidget {
  const _StateNotifierTab();
  
  @override
  ConsumerState<_StateNotifierTab> createState() => _StateNotifierTabState();
}

class _StateNotifierTabState extends ConsumerState<_StateNotifierTab> {
  final _controller = TextEditingController();
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final todoState = ref.watch(todoProvider);
    
    return Column(
      children: [
        // Statistics Header
        Container(
          padding: const EdgeInsets.all(16),
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _StatCard(
                    title: 'الكل',
                    value: '${todoState.todos.length}',
                    icon: Icons.list,
                    color: Colors.blue,
                  ),
                  _StatCard(
                    title: 'منجزة',
                    value: '${todoState.completedCount}',
                    icon: Icons.check_circle,
                    color: Colors.green,
                  ),
                  _StatCard(
                    title: 'معلقة',
                    value: '${todoState.pendingCount}',
                    icon: Icons.pending,
                    color: Colors.orange,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Filters
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilterChip(
                    label: const Text('الكل'),
                    selected: todoState.filter == 'all',
                    onSelected: (_) => ref.read(todoProvider.notifier).setFilter('all'),
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: const Text('منجزة'),
                    selected: todoState.filter == 'completed',
                    onSelected: (_) => ref.read(todoProvider.notifier).setFilter('completed'),
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: const Text('معلقة'),
                    selected: todoState.filter == 'pending',
                    onSelected: (_) => ref.read(todoProvider.notifier).setFilter('pending'),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        // Add Todo
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    labelText: 'مهمة جديدة',
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      ref.read(todoProvider.notifier).addTodo(value);
                      _controller.clear();
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: () {
                  if (_controller.text.isNotEmpty) {
                    ref.read(todoProvider.notifier).addTodo(_controller.text);
                    _controller.clear();
                  }
                },
                icon: const Icon(Icons.add),
                label: const Text('إضافة'),
              ),
            ],
          ),
        ),
        
        // Action Buttons
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: OutlinedButton.icon(
            onPressed: () {
              ref.read(todoProvider.notifier).clearCompleted();
            },
            icon: const Icon(Icons.delete_sweep),
            label: const Text('مسح المنجزة'),
            style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Todo List
        Expanded(
          child: todoState.filteredTodos.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inbox_outlined, size: 80, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        todoState.filter == 'all'
                            ? 'لا توجد مهام'
                            : todoState.filter == 'completed'
                                ? 'لا توجد مهام منجزة'
                                : 'لا توجد مهام معلقة',
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: todoState.filteredTodos.length,
                  itemBuilder: (context, index) {
                    final todo = todoState.filteredTodos[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: ListTile(
                        leading: Checkbox(
                          value: todo.isCompleted,
                          onChanged: (_) {
                            ref.read(todoProvider.notifier).toggleTodo(todo.id);
                          },
                        ),
                        title: Text(
                          todo.title,
                          style: TextStyle(
                            decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
                            color: todo.isCompleted ? Colors.grey : null,
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            ref.read(todoProvider.notifier).removeTodo(todo.id);
                          },
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

// التاب الرابع: FutureProvider - جلب بيانات المستخدم
class _FutureProviderTab extends ConsumerWidget {
  const _FutureProviderTab();
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);
    
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
                  '📡 FutureProvider',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                const Text(
                  'يُستخدم لجلب البيانات غير المتزامنة (API calls)',
                ),
                const SizedBox(height: 24),
                
                userAsync.when(
                  data: (user) => Card(
                    color: Colors.green.withOpacity(0.1),
                    child: ListTile(
                      leading: Text(user.avatar, style: const TextStyle(fontSize: 40)),
                      title: Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(user.email),
                      trailing: IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: () {
                          ref.invalidate(userProvider);
                        },
                      ),
                    ),
                  ),
                  loading: () => const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Column(
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text('جاري تحميل بيانات المستخدم...'),
                        ],
                      ),
                    ),
                  ),
                  error: (error, stack) => Card(
                    color: Colors.red.withOpacity(0.1),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Icon(Icons.error, color: Colors.red, size: 48),
                          const SizedBox(height: 8),
                          Text('خطأ: $error'),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Family Example
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '👥 FutureProvider.family',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                const Text('يمكنك تمرير معاملات للـ Provider'),
                const SizedBox(height: 16),
                
                ...List.generate(3, (index) {
                  final userId = index + 1;
                  final userAsync = ref.watch(userByIdProvider(userId));
                  
                  return userAsync.when(
                    data: (user) => Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        dense: true,
                        leading: Text(user.avatar, style: const TextStyle(fontSize: 24)),
                        title: Text(user.name),
                        subtitle: Text(user.email),
                      ),
                    ),
                    loading: () => const LinearProgressIndicator(),
                    error: (_, __) => const Icon(Icons.error),
                  );
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// التاب الخامس: StreamProvider - الساعة والعد التنازلي
class _StreamProviderTab extends ConsumerWidget {
  const _StreamProviderTab();
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timeAsync = ref.watch(timeProvider);
    final countdownAsync = ref.watch(countdownProvider(10));
    
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  '⏰ الساعة الحية',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 24),
                
                timeAsync.when(
                  data: (time) => Column(
                    children: [
                      Text(
                        '${time.hour.toString().padLeft(2, '0')}:'
                        '${time.minute.toString().padLeft(2, '0')}:'
                        '${time.second.toString().padLeft(2, '0')}',
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'monospace',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${time.day}/${time.month}/${time.year}',
                        style: const TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                  loading: () => const CircularProgressIndicator(),
                  error: (_, __) => const Icon(Icons.error),
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
              children: [
                Text(
                  '⏳ العد التنازلي',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 24),
                
                countdownAsync.when(
                  data: (count) => Column(
                    children: [
                      Text(
                        count >= 0 ? '$count' : '🎉 انتهى!',
                        style: TextStyle(
                          fontSize: 64,
                          fontWeight: FontWeight.bold,
                          color: count >= 0 ? Colors.blue : Colors.green,
                        ),
                      ),
                      if (count >= 0)
                        LinearProgressIndicator(
                          value: (10 - count) / 10,
                        ),
                    ],
                  ),
                  loading: () => const CircularProgressIndicator(),
                  error: (_, __) => const Icon(Icons.error),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// التاب السادس: Family & AutoDispose
class _FamilyAutoDisposeTab extends ConsumerStatefulWidget {
  const _FamilyAutoDisposeTab();
  
  @override
  ConsumerState<_FamilyAutoDisposeTab> createState() => _FamilyAutoDisposeTabState();
}

class _FamilyAutoDisposeTabState extends ConsumerState<_FamilyAutoDisposeTab> {
  bool _showCounter = true;
  
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
                  '🗑️ AutoDispose',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                const Text(
                  'AutoDispose يتخلص تلقائياً من الـ Provider عندما لا يكون مستخدماً',
                ),
                const SizedBox(height: 24),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('عرض العداد', style: Theme.of(context).textTheme.titleMedium),
                    Switch(
                      value: _showCounter,
                      onChanged: (value) {
                        setState(() => _showCounter = value);
                      },
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                if (_showCounter)
                  Consumer(
                    builder: (context, ref, child) {
                      final count = ref.watch(autoDisposeCounterProvider);
                      
                      return Card(
                        color: Colors.blue.withOpacity(0.1),
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            children: [
                              Text(
                                '$count',
                                style: const TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      ref.read(autoDisposeCounterProvider.notifier).state--;
                                    },
                                    child: const Icon(Icons.remove),
                                  ),
                                  const SizedBox(width: 12),
                                  ElevatedButton(
                                    onPressed: () {
                                      ref.read(autoDisposeCounterProvider.notifier).state++;
                                    },
                                    child: const Icon(Icons.add),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                else
                  Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Column(
                        children: [
                          Icon(Icons.delete_outline, size: 48, color: Colors.orange),
                          SizedBox(height: 8),
                          Text(
                            'تم التخلص من العداد! 🗑️',
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'عند إخفائه، يتم استدعاء onDispose',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
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
                      'فائدة AutoDispose',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text('✓ تحرير الذاكرة تلقائياً'),
                const Text('✓ إلغاء subscriptions للـ Streams'),
                const Text('✓ تنظيف الموارد غير المستخدمة'),
                const Text('✓ منع memory leaks'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// التاب السابع: مقارنة الأنواع
class _ComparisonTab extends StatelessWidget {
  const _ComparisonTab();
  
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
                  '📊 مقارنة أنواع Providers',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                
                _buildProviderComparison(
                  '1. Provider',
                  'للقيم الثابتة أو المحسوبة',
                  '• لا يمكن تعديله\n• للحسابات\n• مثل: doubled counter',
                  Colors.blue,
                ),
                
                _buildProviderComparison(
                  '2. StateProvider',
                  'للحالات البسيطة',
                  '• يمكن تعديله\n• للقيم البسيطة\n• مثل: counter, theme mode',
                  Colors.green,
                ),
                
                _buildProviderComparison(
                  '3. StateNotifierProvider',
                  'للحالات المعقدة',
                  '• Immutable state\n• Business logic منفصلة\n• مثل: Todo list, shopping cart',
                  Colors.orange,
                ),
                
                _buildProviderComparison(
                  '4. FutureProvider',
                  'للبيانات غير المتزامنة',
                  '• API calls\n• Database queries\n• مثل: user profile, products',
                  Colors.purple,
                ),
                
                _buildProviderComparison(
                  '5. StreamProvider',
                  'للبيانات المتدفقة',
                  '• Real-time data\n• WebSocket\n• مثل: chat messages, notifications',
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
                    const Icon(Icons.tips_and_updates, color: Colors.blue),
                    const SizedBox(width: 8),
                    Text(
                      'متى تستخدم كل نوع؟',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text('Provider → القيم المحسوبة فقط'),
                const Text('StateProvider → القيم البسيطة (int, bool, String)'),
                const Text('StateNotifierProvider → الحالات المعقدة (Objects, Lists)'),
                const Text('FutureProvider → جلب بيانات لمرة واحدة'),
                const Text('StreamProvider → بيانات متغيرة باستمرار'),
                const SizedBox(height: 12),
                const Text('💡 استخدم .family لتمرير parameters'),
                const Text('💡 استخدم .autoDispose لتنظيف الذاكرة'),
              ],
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildProviderComparison(
    String title,
    String subtitle,
    String details,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            details,
            style: TextStyle(color: Colors.grey[700], height: 1.5),
          ),
        ],
      ),
    );
  }
}

// Helper Widget للإحصائيات
class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  
  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          title,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}
