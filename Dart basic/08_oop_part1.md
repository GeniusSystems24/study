# 8. البرمجة الكائنية - الجزء الأول

## المفاهيم الأساسية

البرمجة الكائنية (OOP) هي نموذج برمجي يعتمد على مفهوم "الكائنات" التي تحتوي على بيانات (خصائص) وسلوكيات (طرق).

## الأصناف (Classes)

### تعريف صنف بسيط

```dart
class Person {
  // الخصائص (Properties)
  String name = '';
  int age = 0;
  
  // الطرق (Methods)
  void introduce() {
    print('مرحباً، اسمي $name وعمري $age سنة');
  }
}

void main() {
  // إنشاء كائن
  var person = Person();
  person.name = 'أحمد';
  person.age = 25;
  person.introduce();
}
```

### خصائص الصنف

```dart
class Student {
  // خصائص instance
  String name;
  int age;
  double grade;
  
  // خاصية ثابتة (static)
  static String university = 'جامعة القاهرة';
  
  // خاصية محسوبة (getter)
  String get status {
    return grade >= 60 ? 'ناجح' : 'راسب';
  }
  
  // setter
  set studentGrade(double value) {
    if (value >= 0 && value <= 100) {
      grade = value;
    }
  }
}
```

## المنشئات (Constructors)

### المنشئ الافتراضي

```dart
class Person {
  String name;
  int age;
  
  // منشئ افتراضي
  Person(this.name, this.age);
}

void main() {
  var person = Person('أحمد', 25);
  print(person.name);
}
```

### منشئ مسمى (Named Constructor)

```dart
class Person {
  String name;
  int age;
  String? email;
  
  // المنشئ الافتراضي
  Person(this.name, this.age);
  
  // منشئ مسمى
  Person.withEmail(this.name, this.age, this.email);
  
  // منشئ مسمى آخر
  Person.guest() : name = 'ضيف', age = 0;
}

void main() {
  var person1 = Person('أحمد', 25);
  var person2 = Person.withEmail('محمد', 30, 'mohamed@example.com');
  var person3 = Person.guest();
}
```

### معاملات المنشئ

```dart
class User {
  String username;
  String email;
  int age;
  bool isActive;
  
  // معاملات إلزامية ومسماة
  User({
    required this.username,
    required this.email,
    this.age = 0,
    this.isActive = true,
  });
}

void main() {
  var user = User(
    username: 'ahmed123',
    email: 'ahmed@example.com',
    age: 25,
  );
}
```

### قائمة التهيئة (Initializer List)

```dart
class Rectangle {
  final double width;
  final double height;
  final double area;
  
  // استخدام initializer list
  Rectangle(this.width, this.height) : area = width * height;
  
  void display() {
    print('العرض: $width، الطول: $height، المساحة: $area');
  }
}
```

### المنشئ الثابت (Constant Constructor)

```dart
class Point {
  final double x;
  final double y;
  
  const Point(this.x, this.y);
}

void main() {
  const point1 = Point(1, 2);
  const point2 = Point(1, 2);
  
  print(point1 == point2);  // true (نفس الكائن)
}
```

### المنشئ المصنعي (Factory Constructor)

```dart
class Database {
  static final Database _instance = Database._internal();
  
  // منشئ خاص
  Database._internal();
  
  // منشئ مصنعي
  factory Database() {
    return _instance;
  }
  
  void query(String sql) {
    print('تنفيذ الاستعلام: $sql');
  }
}

void main() {
  var db1 = Database();
  var db2 = Database();
  
  print(db1 == db2);  // true (نفس الكائن - Singleton)
}
```

## الطرق (Methods)

### طرق الكائن (Instance Methods)

```dart
class Calculator {
  int add(int a, int b) => a + b;
  int subtract(int a, int b) => a - b;
  int multiply(int a, int b) => a * b;
  
  double divide(int a, int b) {
    if (b == 0) throw Exception('لا يمكن القسمة على صفر');
    return a / b;
  }
}

void main() {
  var calc = Calculator();
  print(calc.add(5, 3));      // 8
  print(calc.multiply(4, 6)); // 24
}
```

### الطرق الثابتة (Static Methods)

```dart
class MathUtils {
  static double pi = 3.14159;
  
  static double circleArea(double radius) {
    return pi * radius * radius;
  }
  
  static int factorial(int n) {
    if (n <= 1) return 1;
    return n * factorial(n - 1);
  }
}

void main() {
  print(MathUtils.circleArea(5));
  print(MathUtils.factorial(5));
  // لا حاجة لإنشاء كائن
}
```

## Getters و Setters

```dart
class BankAccount {
  String _accountNumber;  // خاصية خاصة
  double _balance = 0.0;
  
  BankAccount(this._accountNumber);
  
  // Getter
  double get balance => _balance;
  
  String get accountNumber => _accountNumber;
  
  // Setter مع تحقق
  set deposit(double amount) {
    if (amount > 0) {
      _balance += amount;
      print('تم إيداع $amount. الرصيد الجديد: $_balance');
    }
  }
  
  // طريقة عادية
  bool withdraw(double amount) {
    if (amount > 0 && amount <= _balance) {
      _balance -= amount;
      print('تم سحب $amount. الرصيد المتبقي: $_balance');
      return true;
    }
    print('رصيد غير كافٍ');
    return false;
  }
}

void main() {
  var account = BankAccount('123456');
  account.deposit = 1000;
  account.withdraw(300);
  print('الرصيد الحالي: ${account.balance}');
}
```

## التغليف (Encapsulation)

```dart
class Employee {
  String _name;           // خاصة
  String _id;             // خاصة
  double _salary;         // خاصة
  
  Employee(this._name, this._id, this._salary);
  
  // getters عامة
  String get name => _name;
  String get id => _id;
  
  // لا يمكن الوصول للراتب مباشرة
  String get salaryInfo => 'الراتب سري';
  
  // طريقة عامة لزيادة الراتب
  void increaseSalary(double percentage) {
    if (percentage > 0 && percentage <= 100) {
      _salary += _salary * (percentage / 100);
      print('تمت زيادة الراتب بنسبة $percentage%');
    }
  }
  
  void displayInfo() {
    print('الاسم: $_name');
    print('الرقم: $_id');
    print('الراتب: $_salary');
  }
}

void main() {
  var emp = Employee('أحمد', 'E001', 5000);
  print(emp.name);
  emp.increaseSalary(10);
  // print(emp._salary);  // خطأ! لا يمكن الوصول
}
```

## أمثلة عملية شاملة

### مثال 1: نظام مكتبة

```dart
class Book {
  String title;
  String author;
  String isbn;
  bool _isAvailable = true;
  
  Book({
    required this.title,
    required this.author,
    required this.isbn,
  });
  
  bool get isAvailable => _isAvailable;
  
  void borrow() {
    if (_isAvailable) {
      _isAvailable = false;
      print('تم استعارة الكتاب: $title');
    } else {
      print('الكتاب غير متاح حالياً');
    }
  }
  
  void returnBook() {
    _isAvailable = true;
    print('تم إرجاع الكتاب: $title');
  }
  
  void displayInfo() {
    print('\n--- معلومات الكتاب ---');
    print('العنوان: $title');
    print('المؤلف: $author');
    print('ISBN: $isbn');
    print('الحالة: ${_isAvailable ? "متاح" : "مستعار"}');
  }
}

void main() {
  var book = Book(
    title: 'البرمجة بلغة Dart',
    author: 'أحمد محمد',
    isbn: '978-1234567890',
  );
  
  book.displayInfo();
  book.borrow();
  book.borrow();  // سيظهر أنه غير متاح
  book.returnBook();
  book.displayInfo();
}
```

### مثال 2: حساب مصرفي متقدم

```dart
class Transaction {
  final DateTime date;
  final String type;
  final double amount;
  
  Transaction(this.type, this.amount) : date = DateTime.now();
  
  @override
  String toString() {
    return '${date.toString().substring(0, 19)} - $type: $amount';
  }
}

class BankAccount {
  final String accountNumber;
  String _holderName;
  double _balance;
  List<Transaction> _transactions = [];
  
  BankAccount({
    required this.accountNumber,
    required String holderName,
    double initialBalance = 0,
  }) : _holderName = holderName,
       _balance = initialBalance {
    if (initialBalance > 0) {
      _transactions.add(Transaction('إيداع أولي', initialBalance));
    }
  }
  
  double get balance => _balance;
  String get holderName => _holderName;
  
  void deposit(double amount) {
    if (amount <= 0) {
      print('المبلغ يجب أن يكون موجباً');
      return;
    }
    
    _balance += amount;
    _transactions.add(Transaction('إيداع', amount));
    print('تم إيداع $amount. الرصيد: $_balance');
  }
  
  bool withdraw(double amount) {
    if (amount <= 0) {
      print('المبلغ يجب أن يكون موجباً');
      return false;
    }
    
    if (amount > _balance) {
      print('رصيد غير كافٍ');
      return false;
    }
    
    _balance -= amount;
    _transactions.add(Transaction('سحب', amount));
    print('تم سحب $amount. الرصيد: $_balance');
    return true;
  }
  
  void printStatement() {
    print('\n--- كشف حساب ---');
    print('رقم الحساب: $accountNumber');
    print('اسم صاحب الحساب: $_holderName');
    print('الرصيد الحالي: $_balance');
    print('\nالمعاملات:');
    for (var transaction in _transactions) {
      print(transaction);
    }
  }
}

void main() {
  var account = BankAccount(
    accountNumber: 'ACC-001',
    holderName: 'أحمد محمد',
    initialBalance: 1000,
  );
  
  account.deposit(500);
  account.withdraw(200);
  account.withdraw(2000);  // سيفشل
  account.printStatement();
}
```

### مثال 3: نظام المنتجات

```dart
class Product {
  static int _nextId = 1;
  
  final int id;
  String name;
  double price;
  int stock;
  
  Product({
    required this.name,
    required this.price,
    this.stock = 0,
  }) : id = _nextId++;
  
  double get totalValue => price * stock;
  
  bool get isInStock => stock > 0;
  
  void addStock(int quantity) {
    if (quantity > 0) {
      stock += quantity;
      print('تمت إضافة $quantity من $name');
    }
  }
  
  bool sell(int quantity) {
    if (quantity <= 0) {
      print('الكمية يجب أن تكون موجبة');
      return false;
    }
    
    if (quantity > stock) {
      print('المخزون غير كافٍ');
      return false;
    }
    
    stock -= quantity;
    print('تم بيع $quantity من $name');
    return true;
  }
  
  void displayInfo() {
    print('\n--- $name ---');
    print('الرقم: $id');
    print('السعر: $price');
    print('المخزون: $stock');
    print('القيمة الإجمالية: ${totalValue.toStringAsFixed(2)}');
  }
}

void main() {
  var product1 = Product(name: 'لابتوب', price: 5000);
  var product2 = Product(name: 'ماوس', price: 50, stock: 100);
  
  product1.addStock(10);
  product1.sell(3);
  product1.displayInfo();
  
  product2.displayInfo();
}
```

## نصائح مهمة

1. استخدم أسماء واضحة للأصناف (PascalCase)
2. اجعل الخصائص خاصة (_) واستخدم getters/setters عند الحاجة
3. استخدم `final` للخصائص التي لا تتغير بعد الإنشاء
4. استخدم `const` للكائنات الثابتة تماماً
5. المنشئ المسمى يساعد في إنشاء كائنات بطرق مختلفة
6. Factory Constructor مفيد لـ Singleton Pattern
7. لا تجعل كل شيء عاماً - مبدأ التغليف مهم

---

[⬅️ الموضوع السابق: المجموعات](07_collections.md) | [العودة للفهرس](README.md) | [الموضوع التالي: البرمجة الكائنية - الجزء الثاني ➡️](09_oop_part2.md)
