# 21 - State Management - إدارة الحالة

## 📋 المحتويات

- [المقدمة](#المقدمة)
- [Stateless vs Stateful](#stateless-vs-stateful)
- [setState](#setstate)
- [State Lifecycle](#state-lifecycle)
- [أمثلة عملية](#أمثلة-عملية)

---

## 🎯 المقدمة

State Management هي إدارة البيانات والحالات في التطبيق وكيفية تحديثها.

---

## 🔄 Stateless vs Stateful

### StatelessWidget

Widget لا تتغير حالته:

```dart
class WelcomeScreen extends StatelessWidget {
  final String userName;
  
  const WelcomeScreen({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('مرحباً')),
      body: Center(
        child: Text(
          'مرحباً $userName',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
```

### StatefulWidget

Widget قابل لتغيير الحالة:

```dart
class Counter extends StatefulWidget {
  const Counter({super.key});

  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int _count = 0;

  void _increment() {
    setState(() {
      _count++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('العداد')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'عدد النقرات:',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              '$_count',
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _increment,
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

---

## 🔧 setState

تحديث الحالة وإعادة البناء:

```dart
class TodoApp extends StatefulWidget {
  const TodoApp({super.key});

  @override
  State<TodoApp> createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  final List<String> _todos = [];
  final TextEditingController _controller = TextEditingController();

  void _addTodo() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _todos.add(_controller.text);
        _controller.clear();
      });
    }
  }

  void _removeTodo(int index) {
    setState(() {
      _todos.removeAt(index);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('المهام')),
      body: Column(
        children: [
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
                    onSubmitted: (_) => _addTodo(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addTodo,
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _todos.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_todos[index]),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _removeTodo(index),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
```

---

## 🔄 State Lifecycle

دورة حياة StatefulWidget:

```dart
class LifecycleDemo extends StatefulWidget {
  const LifecycleDemo({super.key});

  @override
  State<LifecycleDemo> createState() => _LifecycleDemoState();
}

class _LifecycleDemoState extends State<LifecycleDemo> {
  String _status = 'لم يتم التهيئة';

  @override
  void initState() {
    super.initState();
    print('1. initState - يتم استدعاؤها مرة واحدة عند إنشاء State');
    setState(() {
      _status = 'تم التهيئة';
    });
    
    // تحميل البيانات
    _loadData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('2. didChangeDependencies - عند تغيير التبعيات');
  }

  @override
  void didUpdateWidget(LifecycleDemo oldWidget) {
    super.didUpdateWidget(oldWidget);
    print('3. didUpdateWidget - عند تحديث Widget من الأعلى');
  }

  @override
  void deactivate() {
    print('4. deactivate - قبل إزالة Widget من الشجرة');
    super.deactivate();
  }

  @override
  void dispose() {
    print('5. dispose - تنظيف الموارد');
    super.dispose();
  }

  Future<void> _loadData() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() {
        _status = 'تم تحميل البيانات';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print('build - يتم استدعاؤها عند كل تحديث');
    return Scaffold(
      appBar: AppBar(title: const Text('دورة الحياة')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'الحالة: $_status',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _status = 'تم النقر على الزر';
                });
              },
              child: const Text('تحديث الحالة'),
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

### تطبيق عداد متقدم

```dart
class AdvancedCounter extends StatefulWidget {
  const AdvancedCounter({super.key});

  @override
  State<AdvancedCounter> createState() => _AdvancedCounterState();
}

class _AdvancedCounterState extends State<AdvancedCounter> {
  int _count = 0;
  int _step = 1;
  List<int> _history = [];

  void _increment() {
    setState(() {
      _count += _step;
      _history.add(_count);
    });
  }

  void _decrement() {
    setState(() {
      _count -= _step;
      _history.add(_count);
    });
  }

  void _reset() {
    setState(() {
      _count = 0;
      _history.clear();
    });
  }

  void _changeStep(int newStep) {
    setState(() {
      _step = newStep;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('عداد متقدم'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => _showHistory(context),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'العداد',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 16),
            Text(
              '$_count',
              style: TextStyle(
                fontSize: 72,
                fontWeight: FontWeight.bold,
                color: _count >= 0 ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 32),
            const Text('الخطوة:', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i in [1, 5, 10])
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Text('$i'),
                      selected: _step == i,
                      onSelected: (selected) {
                        if (selected) _changeStep(i);
                      },
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  heroTag: 'decrement',
                  onPressed: _decrement,
                  child: const Icon(Icons.remove),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _reset,
                  child: const Text('إعادة تعيين'),
                ),
                const SizedBox(width: 16),
                FloatingActionButton(
                  heroTag: 'increment',
                  onPressed: _increment,
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showHistory(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'السجل',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _history.isEmpty
                    ? const Center(child: Text('لا يوجد سجل'))
                    : ListView.builder(
                        itemCount: _history.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: CircleAvatar(
                              child: Text('${index + 1}'),
                            ),
                            title: Text('${_history[index]}'),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
```

### نموذج تسجيل دخول

```dart
class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // محاكاة طلب تسجيل الدخول
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم تسجيل الدخول بنجاح!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تسجيل الدخول')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              const Icon(
                Icons.lock_outline,
                size: 100,
                color: Colors.blue,
              ),
              const SizedBox(height: 40),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'البريد الإلكتروني',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال البريد الإلكتروني';
                  }
                  if (!value.contains('@')) {
                    return 'البريد الإلكتروني غير صحيح';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'كلمة المرور',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال كلمة المرور';
                  }
                  if (value.length < 6) {
                    return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                title: const Text('تذكرني'),
                value: _rememberMe,
                onChanged: (value) {
                  setState(() {
                    _rememberMe = value!;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _login,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text(
                        'تسجيل الدخول',
                        style: TextStyle(fontSize: 18),
                      ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {},
                child: const Text('نسيت كلمة المرور؟'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

### تطبيق قائمة تسوق

```dart
class ShoppingItem {
  final String name;
  bool isChecked;

  ShoppingItem({required this.name, this.isChecked = false});
}

class ShoppingList extends StatefulWidget {
  const ShoppingList({super.key});

  @override
  State<ShoppingList> createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  final List<ShoppingItem> _items = [];
  final TextEditingController _controller = TextEditingController();

  void _addItem() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _items.add(ShoppingItem(name: _controller.text));
        _controller.clear();
      });
    }
  }

  void _toggleItem(int index) {
    setState(() {
      _items[index].isChecked = !_items[index].isChecked;
    });
  }

  void _removeItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
  }

  void _clearCompleted() {
    setState(() {
      _items.removeWhere((item) => item.isChecked);
    });
  }

  int get _completedCount => _items.where((item) => item.isChecked).length;
  int get _totalCount => _items.length;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('قائمة التسوق'),
        actions: [
          if (_completedCount > 0)
            IconButton(
              icon: const Icon(Icons.clear_all),
              tooltip: 'مسح المنجزة',
              onPressed: _clearCompleted,
            ),
        ],
      ),
      body: Column(
        children: [
          if (_totalCount > 0)
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.blue.shade50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'الإجمالي: $_totalCount',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    'منجز: $_completedCount',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'أضف عنصراً',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.shopping_cart),
                    ),
                    onSubmitted: (_) => _addItem(),
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton(
                  onPressed: _addItem,
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ),
          Expanded(
            child: _items.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_basket, size: 100, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'القائمة فارغة',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _items.length,
                    itemBuilder: (context, index) {
                      final item = _items[index];
                      return Dismissible(
                        key: Key(item.name + index.toString()),
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
                        onDismissed: (_) => _removeItem(index),
                        child: CheckboxListTile(
                          title: Text(
                            item.name,
                            style: TextStyle(
                              decoration: item.isChecked
                                  ? TextDecoration.lineThrough
                                  : null,
                              color: item.isChecked
                                  ? Colors.grey
                                  : null,
                            ),
                          ),
                          value: item.isChecked,
                          onChanged: (_) => _toggleItem(index),
                          secondary: Icon(
                            item.isChecked
                                ? Icons.check_circle
                                : Icons.circle_outlined,
                            color: item.isChecked
                                ? Colors.green
                                : Colors.grey,
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
```

---

## 📚 المراجع والمصادر

1. **State Management Basics**
   - [StatefulWidget](https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html)
   - [State](https://api.flutter.dev/flutter/widgets/State-class.html)
   - [setState](https://api.flutter.dev/flutter/widgets/State/setState.html)

2. **State Lifecycle**
   - [State Lifecycle](https://docs.flutter.dev/development/ui/interactive#stateful-and-stateless-widgets)
   - [Widget Lifecycle](https://medium.com/flutter-community/flutter-widget-lifecycle-a-complete-overview-45aad5f74306)

3. **Best Practices**
   - [State Management Introduction](https://docs.flutter.dev/data-and-backend/state-mgmt/intro)

---

## 💡 نصائح

- ✅ استخدم StatelessWidget عندما لا تحتاج لتحديث الواجهة
- ✅ setState لتحديثات الحالة المحلية البسيطة
- ✅ تحقق من `mounted` قبل setState في async functions
- ✅ استخدم `dispose()` لتنظيف Controllers والموارد
- ✅ تجنب setState في `build()` لمنع الحلقات اللانهائية

---

[⬅️ السابق: Card و ListTile](../Level%202%20-%20Widgets/20_card_listtile.md)
[🏠 العودة للفهرس](../README.md)
[التالي: InheritedWidget ➡️](22_inherited_widget.md)
