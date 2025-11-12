# 06 - البرمجة الكائنية في Dart

## 📋 المحتويات

- [المقدمة](#المقدمة)
- [الفئات](#الفئات)
- [الكائنات](#الكائنات)
- [الباني](#الباني)
- [الخصائص](#الخصائص)
- [الدوال](#الدوال)
- [الوراثة](#الوراثة)
- [التغليف](#التغليف)
- [أمثلة عملية](#أمثلة-عملية)

---

## 🎯 المقدمة

البرمجة الكائنية (OOP) هي نمط برمجي يعتمد على الكائنات (Objects) التي تحتوي على بيانات (Properties) وسلوكيات (Methods).

### مبادئ OOP الأساسية

- 🔹 **التغليف (Encapsulation)**: إخفاء التفاصيل الداخلية
- 🔹 **الوراثة (Inheritance)**: وراثة الخصائص من فئة أخرى
- 🔹 **تعدد الأشكال (Polymorphism)**: نفس الواجهة، سلوك مختلف
- 🔹 **التجريد (Abstraction)**: إخفاء التعقيد

---

## 📦 الفئات (Classes)

### تعريف فئة بسيطة

```dart
class Person {
  // الخصائص
  String name;
  int age;
  
  // الباني (Constructor)
  Person(this.name, this.age);
  
  // دالة
  void introduce() {
    print('مرحباً، أنا $name وعمري $age سنة');
  }
}

void main() {
  // إنشاء كائن
  Person person = Person('أحمد', 25);
  person.introduce(); // مرحباً، أنا أحمد وعمري 25 سنة
}
```

### فئة مع خصائص خاصة

```dart
class BankAccount {
  String _accountNumber;  // خاصية خاصة (تبدأ بـ _)
  double _balance;
  
  BankAccount(this._accountNumber, this._balance);
  
  // Getter
  double get balance => _balance;
  
  // Setter
  set balance(double value) {
    if (value >= 0) {
      _balance = value;
    }
  }
  
  // دوال
  void deposit(double amount) {
    if (amount > 0) {
      _balance += amount;
      print('تم إيداع $amount. الرصيد الجديد: $_balance');
    }
  }
  
  void withdraw(double amount) {
    if (amount > 0 && amount <= _balance) {
      _balance -= amount;
      print('تم سحب $amount. الرصيد المتبقي: $_balance');
    } else {
      print('رصيد غير كافٍ');
    }
  }
}

void main() {
  var account = BankAccount('123456', 1000);
  print('الرصيد الحالي: ${account.balance}');
  account.deposit(500);
  account.withdraw(300);
}
```

---

## 🔨 الباني (Constructor)

### أنواع البواني

```dart
class Car {
  String brand;
  String model;
  int year;
  String? color;
  
  // 1. الباني الافتراضي
  Car(this.brand, this.model, this.year);
  
  // 2. باني مسمى (Named Constructor)
  Car.withColor(this.brand, this.model, this.year, this.color);
  
  // 3. باني ثابت (Factory Constructor)
  factory Car.toyota(String model, int year) {
    return Car('Toyota', model, year);
  }
  
  void displayInfo() {
    print('$year $brand $model ${color ?? ''}');
  }
}

void main() {
  var car1 = Car('Honda', 'Civic', 2023);
  car1.displayInfo();
  
  var car2 = Car.withColor('BMW', 'X5', 2024, 'أسود');
  car2.displayInfo();
  
  var car3 = Car.toyota('Camry', 2023);
  car3.displayInfo();
}
```

### باني ثابت (Const Constructor)

```dart
class Point {
  final double x;
  final double y;
  
  const Point(this.x, this.y);
}

void main() {
  const point1 = Point(2, 3);
  const point2 = Point(2, 3);
  
  print(identical(point1, point2)); // true - نفس الكائن
}
```

---

## 🔄 الوراثة (Inheritance)

```dart
// الفئة الأساسية
class Animal {
  String name;
  int age;
  
  Animal(this.name, this.age);
  
  void eat() {
    print('$name يأكل');
  }
  
  void sleep() {
    print('$name ينام');
  }
}

// فئة مشتقة
class Dog extends Animal {
  String breed;
  
  Dog(String name, int age, this.breed) : super(name, age);
  
  void bark() {
    print('$name ينبح: نباح نباح!');
  }
  
  // تجاوز دالة من الفئة الأساسية
  @override
  void eat() {
    print('$name (كلب) يأكل طعام الكلاب');
  }
}

class Cat extends Animal {
  bool isIndoor;
  
  Cat(String name, int age, this.isIndoor) : super(name, age);
  
  void meow() {
    print('$name يموء: مواء!');
  }
  
  @override
  void eat() {
    print('$name (قطة) يأكل طعام القطط');
  }
}

void main() {
  var dog = Dog('ريكس', 3, 'جيرمن شيبرد');
  dog.eat();
  dog.bark();
  dog.sleep();
  
  print('');
  
  var cat = Cat('مشمش', 2, true);
  cat.eat();
  cat.meow();
  cat.sleep();
}
```

---

## 🔒 التغليف (Encapsulation)

```dart
class Student {
  String _name;           // خاص
  int _age;               // خاص
  List<double> _grades;   // خاص
  
  Student(this._name, this._age) : _grades = [];
  
  // Getters
  String get name => _name;
  int get age => _age;
  double get average {
    if (_grades.isEmpty) return 0;
    return _grades.reduce((a, b) => a + b) / _grades.length;
  }
  
  // Setters مع التحقق
  set name(String value) {
    if (value.isNotEmpty) {
      _name = value;
    }
  }
  
  set age(int value) {
    if (value > 0 && value < 100) {
      _age = value;
    }
  }
  
  // دوال عامة
  void addGrade(double grade) {
    if (grade >= 0 && grade <= 100) {
      _grades.add(grade);
    }
  }
  
  void displayInfo() {
    print('الطالب: $_name');
    print('العمر: $_age');
    print('الدرجات: $_grades');
    print('المتوسط: ${average.toStringAsFixed(2)}');
  }
}

void main() {
  var student = Student('أحمد', 20);
  student.addGrade(85);
  student.addGrade(90);
  student.addGrade(88);
  student.displayInfo();
}
```

---

## 🎨 الفئات المجردة (Abstract Classes)

```dart
// فئة مجردة
abstract class Shape {
  String name;
  
  Shape(this.name);
  
  // دالة مجردة - يجب تطبيقها في الفئات المشتقة
  double calculateArea();
  double calculatePerimeter();
  
  // دالة عادية
  void display() {
    print('الشكل: $name');
    print('المساحة: ${calculateArea()}');
    print('المحيط: ${calculatePerimeter()}');
  }
}

class Rectangle extends Shape {
  double width;
  double height;
  
  Rectangle(this.width, this.height) : super('مستطيل');
  
  @override
  double calculateArea() => width * height;
  
  @override
  double calculatePerimeter() => 2 * (width + height);
}

class Circle extends Shape {
  double radius;
  
  Circle(this.radius) : super('دائرة');
  
  @override
  double calculateArea() => 3.14159 * radius * radius;
  
  @override
  double calculatePerimeter() => 2 * 3.14159 * radius;
}

void main() {
  var rectangle = Rectangle(5, 10);
  rectangle.display();
  
  print('');
  
  var circle = Circle(7);
  circle.display();
}
```

---

## 🔌 الواجهات (Interfaces)

```dart
// في Dart، كل فئة هي واجهة ضمنياً
class Flyable {
  void fly() {
    print('يطير');
  }
}

class Swimmable {
  void swim() {
    print('يسبح');
  }
}

// تطبيق واجهات متعددة
class Duck implements Flyable, Swimmable {
  @override
  void fly() {
    print('البطة تطير');
  }
  
  @override
  void swim() {
    print('البطة تسبح');
  }
}

class Fish implements Swimmable {
  @override
  void swim() {
    print('السمكة تسبح');
  }
}

void main() {
  var duck = Duck();
  duck.fly();
  duck.swim();
  
  var fish = Fish();
  fish.swim();
}
```

---

## 💼 أمثلة عملية

### مثال: نظام إدارة مكتبة

```dart
class Book {
  String title;
  String author;
  String isbn;
  bool _isAvailable;
  
  Book(this.title, this.author, this.isbn) : _isAvailable = true;
  
  bool get isAvailable => _isAvailable;
  
  void borrow() {
    if (_isAvailable) {
      _isAvailable = false;
      print('تم استعارة الكتاب: $title');
    } else {
      print('الكتاب غير متاح');
    }
  }
  
  void returnBook() {
    _isAvailable = true;
    print('تم إرجاع الكتاب: $title');
  }
  
  @override
  String toString() => '$title بواسطة $author';
}

class Member {
  String name;
  String memberId;
  List<Book> _borrowedBooks;
  
  Member(this.name, this.memberId) : _borrowedBooks = [];
  
  void borrowBook(Book book) {
    if (book.isAvailable) {
      book.borrow();
      _borrowedBooks.add(book);
    }
  }
  
  void returnBook(Book book) {
    if (_borrowedBooks.contains(book)) {
      book.returnBook();
      _borrowedBooks.remove(book);
    }
  }
  
  void displayBorrowedBooks() {
    print('الكتب المستعارة من قبل $name:');
    if (_borrowedBooks.isEmpty) {
      print('لا توجد كتب مستعارة');
    } else {
      _borrowedBooks.forEach(print);
    }
  }
}

class Library {
  String name;
  List<Book> _books;
  List<Member> _members;
  
  Library(this.name) : _books = [], _members = [];
  
  void addBook(Book book) {
    _books.add(book);
    print('تم إضافة الكتاب: ${book.title}');
  }
  
  void registerMember(Member member) {
    _members.add(member);
    print('تم تسجيل العضو: ${member.name}');
  }
  
  void displayAvailableBooks() {
    print('\nالكتب المتاحة في $name:');
    var available = _books.where((book) => book.isAvailable);
    if (available.isEmpty) {
      print('لا توجد كتب متاحة');
    } else {
      available.forEach(print);
    }
  }
}

void main() {
  var library = Library('مكتبة المدينة');
  
  // إضافة كتب
  var book1 = Book('البؤساء', 'فيكتور هوجو', '12345');
  var book2 = Book('مئة عام من العزلة', 'غابرييل ماركيز', '23456');
  var book3 = Book('1984', 'جورج أورويل', '34567');
  
  library.addBook(book1);
  library.addBook(book2);
  library.addBook(book3);
  
  // تسجيل أعضاء
  var member1 = Member('أحمد', 'M001');
  var member2 = Member('فاطمة', 'M002');
  
  library.registerMember(member1);
  library.registerMember(member2);
  
  // عمليات الاستعارة
  print('');
  member1.borrowBook(book1);
  member2.borrowBook(book2);
  member1.borrowBook(book3);
  
  // عرض الكتب المستعارة
  print('');
  member1.displayBorrowedBooks();
  
  // عرض الكتب المتاحة
  library.displayAvailableBooks();
  
  // إرجاع كتاب
  print('');
  member1.returnBook(book1);
  
  library.displayAvailableBooks();
}
```

---

## 📚 للتعمق أكثر

لمزيد من التفاصيل، راجع:

- [البرمجة الكائنية - الجزء الأول](../Dart%20basic/08_oop_part1.md)
- [البرمجة الكائنية - الجزء الثاني](../Dart%20basic/09_oop_part2.md)

---

## 📖 المراجع والمصادر

### مصادر Dart الرسمية

1. **Dart Language Tour - Classes**
   - [Classes Overview](https://dart.dev/guides/language/language-tour#classes)
   - [Constructors](https://dart.dev/guides/language/language-tour#constructors)
   - [Methods](https://dart.dev/guides/language/language-tour#instance-methods)
   - [Getters and Setters](https://dart.dev/guides/language/language-tour#getters-and-setters)
   - [Inheritance](https://dart.dev/guides/language/language-tour#extending-a-class)
   - [Abstract Classes](https://dart.dev/guides/language/language-tour#abstract-classes)

2. **Effective Dart - Design**
   - [Class Design Guidelines](https://dart.dev/guides/language/effective-dart/design#classes)
   - [Encapsulation Best Practices](https://dart.dev/guides/language/effective-dart/design#do-use-getters-for-operations-that-conceptually-access-properties)
   - [Inheritance Guidelines](https://dart.dev/guides/language/effective-dart/design#avoid-defining-a-class-that-contains-only-static-members)

3. **Object-Oriented Programming**
   - [OOP Concepts in Dart](https://dart.dev/guides/language/language-tour#classes)
   - [Mixins](https://dart.dev/guides/language/language-tour#adding-features-to-a-class-mixins)
   - [Extension Methods](https://dart.dev/guides/language/extension-methods)

### مصادر تفاعلية

4. **DartPad Examples**
   - [OOP Examples in DartPad](https://dartpad.dev/)
   - [Classes Tutorial](https://dart.dev/tutorials)

5. **Dart Codelabs**
   - [Dart OOP Codelab](https://dart.dev/codelabs)

### مصادر داخل المستودع

6. **خطة تعلم Dart الشاملة**
   - [فهرس Dart الكامل](../Dart%20basic/README.md)
   - [البرمجة الكائنية - الجزء الأول](../Dart%20basic/08_oop_part1.md)
   - [البرمجة الكائنية - الجزء الثاني](../Dart%20basic/09_oop_part2.md)

### مراجع API

7. **Dart Core Library**
   - [Object Class](https://api.dart.dev/stable/dart-core/Object-class.html)
   - [Class Modifiers](https://dart.dev/language/class-modifiers)

### مصادر إضافية

8. **Community Resources**
   - [Dart OOP on Stack Overflow](https://stackoverflow.com/questions/tagged/dart+oop)
   - [Dart Reddit Community](https://www.reddit.com/r/dartlang/)

9. **Video Tutorials**
   - [Dart OOP - Official YouTube](https://www.youtube.com/dartlang)
   - [Object-Oriented Programming in Dart](https://www.youtube.com/results?search_query=dart+oop)

10. **Books and References**
    - [Dart Apprentice - OOP Chapter](https://www.raywenderlich.com/books/dart-apprentice)
    - [Design Patterns in Dart](https://refactoring.guru/design-patterns/dart)

---

## 💡 نصائح

- ✅ استخدم الفئات لتنظيم الكود
- ✅ طبّق مبدأ التغليف لإخفاء التفاصيل
- ✅ استخدم الوراثة بحذر (composition over inheritance)
- ✅ استخدم الفئات المجردة للعقود المشتركة
- ✅ اجعل الخصائص خاصة واستخدم Getters/Setters
- ✅ اختر أسماء واضحة للفئات والدوال
- ✅ مارس على [DartPad](https://dartpad.dev/)

---

[⬅️ السابق: الدوال](05_functions.md)
[🏠 العودة للفهرس](../README.md)
[التالي: المجموعات ➡️](07_collections.md)
