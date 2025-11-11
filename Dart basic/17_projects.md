# 17. التطبيقات العملية

## مشروع 1: آلة حاسبة متقدمة

### الهيكل والتنفيذ الكامل

```dart
enum Operation { add, subtract, multiply, divide, power, sqrt, percentage }

class Calculator {
  double memory = 0;
  List<String> history = [];
  
  double calculate(double a, double b, Operation operation) {
    double result;
    String operationSymbol;
    
    switch (operation) {
      case Operation.add:
        result = a + b;
        operationSymbol = '+';
        break;
      case Operation.subtract:
        result = a - b;
        operationSymbol = '-';
        break;
      case Operation.multiply:
        result = a * b;
        operationSymbol = '×';
        break;
      case Operation.divide:
        if (b == 0) throw Exception('لا يمكن القسمة على صفر');
        result = a / b;
        operationSymbol = '÷';
        break;
      case Operation.power:
        result = _power(a, b.toInt());
        operationSymbol = '^';
        break;
      case Operation.percentage:
        result = (a * b) / 100;
        operationSymbol = '% من';
        break;
      default:
        throw Exception('عملية غير مدعومة');
    }
    
    _addToHistory('$a $operationSymbol $b = $result');
    return result;
  }
  
  double sqrt(double value) {
    if (value < 0) throw Exception('لا يمكن حساب جذر عدد سالب');
    
    double result = _calculateSqrt(value);
    _addToHistory('√$value = $result');
    return result;
  }
  
  void memorySave(double value) {
    memory = value;
    print('تم حفظ $value في الذاكرة');
  }
  
  double memoryRecall() {
    return memory;
  }
  
  void memoryClear() {
    memory = 0;
    print('تم مسح الذاكرة');
  }
  
  void clearHistory() {
    history.clear();
    print('تم مسح السجل');
  }
  
  void showHistory() {
    if (history.isEmpty) {
      print('السجل فارغ');
      return;
    }
    
    print('\n=== سجل العمليات ===');
    for (int i = 0; i < history.length; i++) {
      print('${i + 1}. ${history[i]}');
    }
    print('==================\n');
  }
  
  double _power(double base, int exponent) {
    if (exponent == 0) return 1;
    
    double result = 1;
    bool negative = exponent < 0;
    exponent = exponent.abs();
    
    for (int i = 0; i < exponent; i++) {
      result *= base;
    }
    
    return negative ? 1 / result : result;
  }
  
  double _calculateSqrt(double value) {
    if (value == 0) return 0;
    
    double x = value;
    double y = 1;
    double precision = 0.00001;
    
    while (x - y > precision) {
      x = (x + y) / 2;
      y = value / x;
    }
    
    return x;
  }
  
  void _addToHistory(String operation) {
    history.add(operation);
    if (history.length > 50) {  // حد أقصى 50 عملية
      history.removeAt(0);
    }
  }
}

void main() {
  var calc = Calculator();
  
  print('=== آلة حاسبة متقدمة ===\n');
  
  // عمليات أساسية
  print('5 + 3 = ${calc.calculate(5, 3, Operation.add)}');
  print('10 - 4 = ${calc.calculate(10, 4, Operation.subtract)}');
  print('6 × 7 = ${calc.calculate(6, 7, Operation.multiply)}');
  print('20 ÷ 4 = ${calc.calculate(20, 4, Operation.divide)}');
  
  // عمليات متقدمة
  print('2 ^ 8 = ${calc.calculate(2, 8, Operation.power)}');
  print('√16 = ${calc.sqrt(16)}');
  print('25% من 200 = ${calc.calculate(200, 25, Operation.percentage)}');
  
  // الذاكرة
  calc.memorySave(42);
  print('قيمة الذاكرة: ${calc.memoryRecall()}');
  
  // السجل
  calc.showHistory();
}
```

## مشروع 2: نظام إدارة المهام

```dart
enum Priority { low, medium, high, urgent }
enum TaskStatus { pending, inProgress, completed, cancelled }

class Task {
  final String id;
  String title;
  String description;
  Priority priority;
  TaskStatus status;
  DateTime createdAt;
  DateTime? dueDate;
  List<String> tags;
  
  Task({
    required this.id,
    required this.title,
    this.description = '',
    this.priority = Priority.medium,
    this.status = TaskStatus.pending,
    DateTime? createdAt,
    this.dueDate,
    this.tags = const [],
  }) : createdAt = createdAt ?? DateTime.now();
  
  bool get isOverdue {
    if (dueDate == null || status == TaskStatus.completed) return false;
    return DateTime.now().isAfter(dueDate!);
  }
  
  String get priorityEmoji {
    switch (priority) {
      case Priority.low:
        return '🟢';
      case Priority.medium:
        return '🟡';
      case Priority.high:
        return '🟠';
      case Priority.urgent:
        return '🔴';
    }
  }
  
  String get statusEmoji {
    switch (status) {
      case TaskStatus.pending:
        return '⏳';
      case TaskStatus.inProgress:
        return '⚙️';
      case TaskStatus.completed:
        return '✅';
      case TaskStatus.cancelled:
        return '❌';
    }
  }
  
  @override
  String toString() {
    String dueDateStr = dueDate != null 
        ? ' | موعد: ${dueDate!.toString().substring(0, 10)}'
        : '';
    String overdue = isOverdue ? ' ⚠️ متأخر' : '';
    return '$statusEmoji $priorityEmoji $title$dueDateStr$overdue';
  }
}

class TodoList {
  final Map<String, Task> _tasks = {};
  int _nextId = 1;
  
  String addTask({
    required String title,
    String description = '',
    Priority priority = Priority.medium,
    DateTime? dueDate,
    List<String> tags = const [],
  }) {
    String id = 'TASK-${_nextId.toString().padLeft(3, '0')}';
    _nextId++;
    
    var task = Task(
      id: id,
      title: title,
      description: description,
      priority: priority,
      dueDate: dueDate,
      tags: List.from(tags),
    );
    
    _tasks[id] = task;
    print('✓ تمت إضافة المهمة: $id - $title');
    return id;
  }
  
  bool updateTask(String id, {
    String? title,
    String? description,
    Priority? priority,
    TaskStatus? status,
    DateTime? dueDate,
  }) {
    if (!_tasks.containsKey(id)) {
      print('✗ المهمة غير موجودة: $id');
      return false;
    }
    
    var task = _tasks[id]!;
    if (title != null) task.title = title;
    if (description != null) task.description = description;
    if (priority != null) task.priority = priority;
    if (status != null) task.status = status;
    if (dueDate != null) task.dueDate = dueDate;
    
    print('✓ تم تحديث المهمة: $id');
    return true;
  }
  
  bool deleteTask(String id) {
    if (_tasks.remove(id) != null) {
      print('✓ تم حذف المهمة: $id');
      return true;
    }
    print('✗ المهمة غير موجودة: $id');
    return false;
  }
  
  void completeTask(String id) {
    updateTask(id, status: TaskStatus.completed);
  }
  
  void displayAll() {
    if (_tasks.isEmpty) {
      print('لا توجد مهام');
      return;
    }
    
    print('\n=== جميع المهام (${_tasks.length}) ===');
    for (var task in _tasks.values) {
      print(task);
    }
    print('');
  }
  
  void displayByStatus(TaskStatus status) {
    var filtered = _tasks.values.where((t) => t.status == status).toList();
    
    if (filtered.isEmpty) {
      print('لا توجد مهام بحالة: $status');
      return;
    }
    
    print('\n=== مهام بحالة $status (${filtered.length}) ===');
    for (var task in filtered) {
      print(task);
    }
    print('');
  }
  
  void displayOverdue() {
    var overdue = _tasks.values.where((t) => t.isOverdue).toList();
    
    if (overdue.isEmpty) {
      print('✓ لا توجد مهام متأخرة');
      return;
    }
    
    print('\n⚠️ === مهام متأخرة (${overdue.length}) ===');
    for (var task in overdue) {
      print(task);
    }
    print('');
  }
  
  Map<String, int> getStatistics() {
    return {
      'الإجمالي': _tasks.length,
      'قيد الانتظار': _tasks.values.where((t) => t.status == TaskStatus.pending).length,
      'قيد التنفيذ': _tasks.values.where((t) => t.status == TaskStatus.inProgress).length,
      'مكتملة': _tasks.values.where((t) => t.status == TaskStatus.completed).length,
      'متأخرة': _tasks.values.where((t) => t.isOverdue).length,
    };
  }
  
  void displayStatistics() {
    var stats = getStatistics();
    
    print('\n=== إحصائيات المهام ===');
    stats.forEach((key, value) {
      print('$key: $value');
    });
    print('');
  }
}

void main() {
  var todoList = TodoList();
  
  // إضافة مهام
  todoList.addTask(
    title: 'إنهاء المشروع',
    description: 'استكمال جميع الميزات',
    priority: Priority.high,
    dueDate: DateTime.now().add(Duration(days: 7)),
  );
  
  todoList.addTask(
    title: 'مراجعة الكود',
    priority: Priority.medium,
    dueDate: DateTime.now().add(Duration(days: 3)),
  );
  
  todoList.addTask(
    title: 'كتابة التوثيق',
    priority: Priority.low,
    dueDate: DateTime.now().subtract(Duration(days: 1)),  // متأخر
  );
  
  todoList.addTask(
    title: 'اجتماع الفريق',
    priority: Priority.urgent,
    dueDate: DateTime.now().add(Duration(hours: 2)),
  );
  
  // عرض جميع المهام
  todoList.displayAll();
  
  // تحديث حالة
  todoList.updateTask('TASK-001', status: TaskStatus.inProgress);
  todoList.completeTask('TASK-002');
  
  // عرض المهام المتأخرة
  todoList.displayOverdue();
  
  // عرض الإحصائيات
  todoList.displayStatistics();
}
```

## مشروع 3: نظام بنكي بسيط

```dart
enum TransactionType { deposit, withdrawal, transfer }

class Transaction {
  final String id;
  final TransactionType type;
  final double amount;
  final DateTime timestamp;
  final String? description;
  
  Transaction({
    required this.id,
    required this.type,
    required this.amount,
    DateTime? timestamp,
    this.description,
  }) : timestamp = timestamp ?? DateTime.now();
  
  @override
  String toString() {
    String typeEmoji = {
      TransactionType.deposit: '💰',
      TransactionType.withdrawal: '💸',
      TransactionType.transfer: '↔️',
    }[type]!;
    
    String dateStr = timestamp.toString().substring(0, 19);
    return '$typeEmoji $dateStr | ${type.name} | $amount ج.م'
           '${description != null ? " - $description" : ""}';
  }
}

class BankAccount {
  final String accountNumber;
  String holderName;
  double _balance;
  final List<Transaction> _transactions = [];
  bool isActive;
  
  static int _transactionCounter = 1;
  
  BankAccount({
    required this.accountNumber,
    required this.holderName,
    double initialBalance = 0,
    this.isActive = true,
  }) : _balance = initialBalance {
    if (initialBalance > 0) {
      _addTransaction(
        TransactionType.deposit,
        initialBalance,
        'رصيد افتتاحي',
      );
    }
  }
  
  double get balance => _balance;
  
  List<Transaction> get transactions => List.unmodifiable(_transactions);
  
  bool deposit(double amount, {String? description}) {
    if (!isActive) {
      print('✗ الحساب غير نشط');
      return false;
    }
    
    if (amount <= 0) {
      print('✗ المبلغ يجب أن يكون موجباً');
      return false;
    }
    
    _balance += amount;
    _addTransaction(TransactionType.deposit, amount, description);
    print('✓ تم إيداع $amount ج.م. الرصيد الجديد: $_balance ج.م');
    return true;
  }
  
  bool withdraw(double amount, {String? description}) {
    if (!isActive) {
      print('✗ الحساب غير نشط');
      return false;
    }
    
    if (amount <= 0) {
      print('✗ المبلغ يجب أن يكون موجباً');
      return false;
    }
    
    if (amount > _balance) {
      print('✗ رصيد غير كافٍ. الرصيد الحالي: $_balance ج.م');
      return false;
    }
    
    _balance -= amount;
    _addTransaction(TransactionType.withdrawal, amount, description);
    print('✓ تم سحب $amount ج.م. الرصيد المتبقي: $_balance ج.م');
    return true;
  }
  
  void _addTransaction(TransactionType type, double amount, String? description) {
    var transaction = Transaction(
      id: 'TXN-${_transactionCounter.toString().padLeft(6, '0')}',
      type: type,
      amount: amount,
      description: description,
    );
    
    _transactions.add(transaction);
    _transactionCounter++;
  }
  
  void printStatement({int? lastN}) {
    print('\n========== كشف حساب ==========');
    print('رقم الحساب: $accountNumber');
    print('اسم صاحب الحساب: $holderName');
    print('الرصيد الحالي: $_balance ج.م');
    print('الحالة: ${isActive ? "نشط" : "غير نشط"}');
    print('\n--- المعاملات ---');
    
    var txnToShow = lastN != null 
        ? _transactions.skip(_transactions.length - lastN)
        : _transactions;
    
    if (txnToShow.isEmpty) {
      print('لا توجد معاملات');
    } else {
      for (var txn in txnToShow) {
        print(txn);
      }
    }
    
    print('==============================\n');
  }
}

class Bank {
  final String name;
  final Map<String, BankAccount> _accounts = {};
  int _accountCounter = 1001;
  
  Bank(this.name);
  
  String createAccount({
    required String holderName,
    double initialDeposit = 0,
  }) {
    String accountNumber = 'ACC-${_accountCounter.toString()}';
    _accountCounter++;
    
    var account = BankAccount(
      accountNumber: accountNumber,
      holderName: holderName,
      initialBalance: initialDeposit,
    );
    
    _accounts[accountNumber] = account;
    print('✓ تم إنشاء حساب: $accountNumber لـ $holderName');
    return accountNumber;
  }
  
  BankAccount? getAccount(String accountNumber) {
    return _accounts[accountNumber];
  }
  
  bool transfer({
    required String fromAccount,
    required String toAccount,
    required double amount,
    String? description,
  }) {
    var from = _accounts[fromAccount];
    var to = _accounts[toAccount];
    
    if (from == null || to == null) {
      print('✗ حساب غير موجود');
      return false;
    }
    
    if (from.withdraw(amount, description: 'تحويل إلى $toAccount')) {
      to.deposit(amount, description: 'تحويل من $fromAccount');
      print('✓ تم التحويل بنجاح');
      return true;
    }
    
    return false;
  }
  
  void printBankSummary() {
    print('\n========== $name ==========');
    print('عدد الحسابات: ${_accounts.length}');
    
    double totalBalance = _accounts.values
        .map((acc) => acc.balance)
        .fold(0, (sum, balance) => sum + balance);
    
    print('إجمالي الأرصدة: $totalBalance ج.م');
    print('\n--- الحسابات ---');
    
    for (var account in _accounts.values) {
      print('${account.accountNumber}: ${account.holderName} - ${account.balance} ج.م');
    }
    
    print('=============================\n');
  }
}

void main() {
  var bank = Bank('بنك الوطني');
  
  // إنشاء حسابات
  var acc1 = bank.createAccount(holderName: 'أحمد محمد', initialDeposit: 10000);
  var acc2 = bank.createAccount(holderName: 'فاطمة علي', initialDeposit: 5000);
  
  // عمليات بنكية
  bank.getAccount(acc1)?.deposit(2000, description: 'راتب');
  bank.getAccount(acc1)?.withdraw(500, description: 'سحب نقدي');
  
  // تحويل
  bank.transfer(
    fromAccount: acc1,
    toAccount: acc2,
    amount: 1000,
    description: 'تحويل عائلي',
  );
  
  // كشف حساب
  bank.getAccount(acc1)?.printStatement();
  bank.getAccount(acc2)?.printStatement();
  
  // ملخص البنك
  bank.printBankSummary();
}
```

## مشروع 4: تطبيق اتصال بـ API بسيط

```dart
import 'dart:convert';

// نموذج البيانات
class Post {
  final int id;
  final String title;
  final String body;
  final int userId;
  
  Post({
    required this.id,
    required this.title,
    required this.body,
    required this.userId,
  });
  
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      userId: json['userId'],
    );
  }
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'body': body,
    'userId': userId,
  };
  
  @override
  String toString() => 'Post #$id: $title';
}

// محاكاة API Service
class ApiService {
  // محاكاة البيانات (في الواقع ستكون HTTP requests)
  final List<Map<String, dynamic>> _mockData = [
    {'id': 1, 'title': 'مقال 1', 'body': 'محتوى المقال 1', 'userId': 1},
    {'id': 2, 'title': 'مقال 2', 'body': 'محتوى المقال 2', 'userId': 1},
    {'id': 3, 'title': 'مقال 3', 'body': 'محتوى المقال 3', 'userId': 2},
  ];
  
  Future<List<Post>> fetchPosts() async {
    // محاكاة تأخير الشبكة
    await Future.delayed(Duration(seconds: 1));
    
    return _mockData.map((json) => Post.fromJson(json)).toList();
  }
  
  Future<Post?> fetchPostById(int id) async {
    await Future.delayed(Duration(milliseconds: 500));
    
    try {
      var json = _mockData.firstWhere((post) => post['id'] == id);
      return Post.fromJson(json);
    } catch (e) {
      return null;
    }
  }
  
  Future<Post> createPost(String title, String body, int userId) async {
    await Future.delayed(Duration(milliseconds: 800));
    
    var newPost = {
      'id': _mockData.length + 1,
      'title': title,
      'body': body,
      'userId': userId,
    };
    
    _mockData.add(newPost);
    return Post.fromJson(newPost);
  }
}

void main() async {
  var api = ApiService();
  
  print('=== جلب جميع المقالات ===');
  var posts = await api.fetchPosts();
  posts.forEach(print);
  
  print('\n=== جلب مقال محدد ===');
  var post = await api.fetchPostById(2);
  if (post != null) {
    print('العنوان: ${post.title}');
    print('المحتوى: ${post.body}');
  }
  
  print('\n=== إنشاء مقال جديد ===');
  var newPost = await api.createPost(
    'مقال جديد',
    'هذا محتوى المقال الجديد',
    1,
  );
  print('تم الإنشاء: $newPost');
}
```

## الخلاصة

هذه المشاريع تغطي:
- **الحاسبة**: العمليات الحسابية والتعامل مع البيانات
- **إدارة المهام**: الأصناف، Enums، معالجة التواريخ
- **النظام البنكي**: OOP، معالجة المعاملات
- **API Client**: البرمجة غير المتزامنة، JSON

## نصائح للمشاريع

1. **ابدأ بسيط**: ثم أضف الميزات تدريجياً
2. **خطط قبل الكتابة**: ارسم الهيكل أولاً
3. **اختبر باستمرار**: بعد كل إضافة
4. **استخدم Git**: لحفظ التقدم
5. **وثّق الكود**: اشرح الأجزاء المعقدة
6. **تعلم من الأخطاء**: كل خطأ فرصة للتعلم

---

[⬅️ الموضوع السابق: أفضل الممارسات](16_best_practices.md) 
 [العودة للفهرس](README.md)
