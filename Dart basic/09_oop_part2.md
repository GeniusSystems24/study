# 9. البرمجة الكائنية - الجزء الثاني

## الوراثة (Inheritance)

الوراثة تسمح لصنف بأن يرث الخصائص والطرق من صنف آخر.

### الوراثة الأساسية

```dart
// الصنف الأب (Base Class / Parent Class)
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

// الصنف الابن (Derived Class / Child Class)
class Dog extends Animal {
  String breed;
  
  Dog(String name, int age, this.breed) : super(name, age);
  
  void bark() {
    print('$name ينبح');
  }
}

void main() {
  var dog = Dog('ماكس', 3, 'جيرمن شيبرد');
  dog.eat();    // موروثة من Animal
  dog.sleep();  // موروثة من Animal
  dog.bark();   // خاصة بـ Dog
}
```

### تجاوز الطرق (Method Overriding)

```dart
class Vehicle {
  String brand;
  
  Vehicle(this.brand);
  
  void start() {
    print('المركبة تعمل');
  }
  
  void displayInfo() {
    print('المركبة: $brand');
  }
}

class Car extends Vehicle {
  int numberOfDoors;
  
  Car(String brand, this.numberOfDoors) : super(brand);
  
  @override
  void start() {
    print('السيارة $brand تعمل بالمحرك');
  }
  
  @override
  void displayInfo() {
    super.displayInfo();  // استدعاء طريقة الأب
    print('عدد الأبواب: $numberOfDoors');
  }
}

void main() {
  var car = Car('تويوتا', 4);
  car.start();        // السيارة تويوتا تعمل بالمحرك
  car.displayInfo();
}
```

### استخدام super

```dart
class Person {
  String name;
  int age;
  
  Person(this.name, this.age);
  
  void introduce() {
    print('اسمي $name وعمري $age');
  }
}

class Student extends Person {
  String studentId;
  double gpa;
  
  Student({
    required String name,
    required int age,
    required this.studentId,
    required this.gpa,
  }) : super(name, age);
  
  @override
  void introduce() {
    super.introduce();  // استدعاء طريقة الأب
    print('رقم الطالب: $studentId');
    print('المعدل: $gpa');
  }
}
```

## الأصناف المجردة (Abstract Classes)

الأصناف المجردة لا يمكن إنشاء كائنات منها مباشرة، وتستخدم كقوالب للأصناف الأخرى.

```dart
abstract class Shape {
  String name;
  
  Shape(this.name);
  
  // طريقة مجردة (يجب تنفيذها في الأصناف الفرعية)
  double calculateArea();
  
  // طريقة عادية
  void display() {
    print('الشكل: $name');
    print('المساحة: ${calculateArea()}');
  }
}

class Circle extends Shape {
  double radius;
  
  Circle(this.radius) : super('دائرة');
  
  @override
  double calculateArea() {
    return 3.14159 * radius * radius;
  }
}

class Rectangle extends Shape {
  double width;
  double height;
  
  Rectangle(this.width, this.height) : super('مستطيل');
  
  @override
  double calculateArea() {
    return width * height;
  }
}

void main() {
  // var shape = Shape('شكل');  // خطأ! لا يمكن إنشاء كائن من صنف مجرد
  
  Shape circle = Circle(5);
  Shape rectangle = Rectangle(4, 6);
  
  circle.display();
  rectangle.display();
}
```

## الواجهات (Interfaces)

في Dart، كل صنف يمكن استخدامه كواجهة.

```dart
// تعريف واجهة (أي صنف)
class Printable {
  void printDocument() {}
}

class Scannable {
  void scanDocument() {}
}

// تطبيق عدة واجهات
class Printer implements Printable {
  @override
  void printDocument() {
    print('جاري الطباعة...');
  }
}

class Scanner implements Scannable {
  @override
  void scanDocument() {
    print('جاري المسح...');
  }
}

class AllInOnePrinter implements Printable, Scannable {
  @override
  void printDocument() {
    print('الطباعة من الجهاز المتعدد الوظائف');
  }
  
  @override
  void scanDocument() {
    print('المسح من الجهاز المتعدد الوظائف');
  }
}

void main() {
  var printer = AllInOnePrinter();
  printer.printDocument();
  printer.scanDocument();
}
```

## التعددية الشكلية (Polymorphism)

```dart
abstract class Employee {
  String name;
  String id;
  
  Employee(this.name, this.id);
  
  double calculateSalary();
  
  void displayInfo() {
    print('الاسم: $name');
    print('الرقم: $id');
    print('الراتب: ${calculateSalary()}');
  }
}

class FullTimeEmployee extends Employee {
  double monthlySalary;
  
  FullTimeEmployee({
    required String name,
    required String id,
    required this.monthlySalary,
  }) : super(name, id);
  
  @override
  double calculateSalary() => monthlySalary;
}

class PartTimeEmployee extends Employee {
  double hourlyRate;
  int hoursWorked;
  
  PartTimeEmployee({
    required String name,
    required String id,
    required this.hourlyRate,
    required this.hoursWorked,
  }) : super(name, id);
  
  @override
  double calculateSalary() => hourlyRate * hoursWorked;
}

class Contractor extends Employee {
  double projectFee;
  
  Contractor({
    required String name,
    required String id,
    required this.projectFee,
  }) : super(name, id);
  
  @override
  double calculateSalary() => projectFee;
}

void main() {
  // التعددية الشكلية - قائمة من أنواع مختلفة
  List<Employee> employees = [
    FullTimeEmployee(name: 'أحمد', id: 'E001', monthlySalary: 5000),
    PartTimeEmployee(name: 'محمد', id: 'E002', hourlyRate: 50, hoursWorked: 80),
    Contractor(name: 'فاطمة', id: 'C001', projectFee: 10000),
  ];
  
  // معاملة موحدة لأنواع مختلفة
  for (var employee in employees) {
    employee.displayInfo();
    print('---');
  }
  
  // حساب إجمالي الرواتب
  double totalSalaries = employees
      .map((e) => e.calculateSalary())
      .reduce((a, b) => a + b);
  print('إجمالي الرواتب: $totalSalaries');
}
```

## Mixins

Mixins تسمح بإعادة استخدام الكود في عدة أصناف بدون وراثة.

```dart
// تعريف mixin
mixin Swimming {
  void swim() {
    print('يسبح في الماء');
  }
}

mixin Flying {
  void fly() {
    print('يطير في السماء');
  }
}

mixin Walking {
  void walk() {
    print('يمشي على الأرض');
  }
}

// استخدام mixins
class Duck with Swimming, Flying, Walking {
  String name;
  
  Duck(this.name);
}

class Fish with Swimming {
  String species;
  
  Fish(this.species);
}

class Bird with Flying, Walking {
  String type;
  
  Bird(this.type);
}

void main() {
  var duck = Duck('بطة');
  duck.swim();
  duck.fly();
  duck.walk();
  
  var fish = Fish('سمكة ذهبية');
  fish.swim();
  // fish.fly();  // خطأ! Fish ليس لديها Flying
}
```

### Mixin مع قيود

```dart
class Animal {
  void breathe() => print('يتنفس');
}

// mixin يمكن استخدامه فقط مع Animal أو أصناف فرعية منها
mixin Carnivore on Animal {
  void eatMeat() {
    print('يأكل اللحم');
  }
}

class Dog extends Animal with Carnivore {
  String breed;
  
  Dog(this.breed);
}

// class Car with Carnivore {}  // خطأ! Car ليست Animal

void main() {
  var dog = Dog('جيرمن شيبرد');
  dog.breathe();
  dog.eatMeat();
}
```

## Extension Methods

إضافة طرق جديدة لأصناف موجودة بدون تعديلها.

```dart
// إضافة طرق لـ String
extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
  
  bool isEmail() {
    return contains('@') && contains('.');
  }
  
  String reverse() {
    return split('').reversed.join('');
  }
}

// إضافة طرق لـ int
extension IntExtension on int {
  bool get isEven => this % 2 == 0;
  bool get isOdd => !isEven;
  
  int factorial() {
    if (this <= 1) return 1;
    return this * (this - 1).factorial();
  }
}

void main() {
  // استخدام String extensions
  String name = 'ahmed';
  print(name.capitalize());  // Ahmed
  
  String email = 'test@example.com';
  print(email.isEmail());    // true
  
  print('hello'.reverse());  // olleh
  
  // استخدام int extensions
  print(4.isEven);          // true
  print(5.isOdd);           // true
  print(5.factorial());     // 120
}
```

## أمثلة عملية شاملة

### مثال 1: نظام الموظفين المتقدم

```dart
abstract class Person {
  String name;
  String id;
  
  Person(this.name, this.id);
  
  void displayBasicInfo() {
    print('الاسم: $name');
    print('الرقم: $id');
  }
}

mixin Contactable {
  String? email;
  String? phone;
  
  void displayContactInfo() {
    if (email != null) print('البريد: $email');
    if (phone != null) print('الهاتف: $phone');
  }
}

abstract class Employee extends Person {
  DateTime hireDate;
  
  Employee({
    required String name,
    required String id,
    required this.hireDate,
  }) : super(name, id);
  
  double calculateSalary();
  
  int get yearsOfService {
    return DateTime.now().year - hireDate.year;
  }
}

class Manager extends Employee with Contactable {
  double baseSalary;
  double bonus;
  List<String> teamMembers;
  
  Manager({
    required String name,
    required String id,
    required DateTime hireDate,
    required this.baseSalary,
    this.bonus = 0,
    this.teamMembers = const [],
  }) : super(name: name, id: id, hireDate: hireDate);
  
  @override
  double calculateSalary() => baseSalary + bonus;
  
  void addTeamMember(String memberId) {
    teamMembers = [...teamMembers, memberId];
    print('تمت إضافة عضو للفريق');
  }
  
  void displayInfo() {
    displayBasicInfo();
    displayContactInfo();
    print('المنصب: مدير');
    print('حجم الفريق: ${teamMembers.length}');
    print('الراتب: ${calculateSalary()}');
    print('سنوات الخدمة: $yearsOfService');
  }
}

class Developer extends Employee with Contactable {
  double hourlyRate;
  int hoursWorked;
  List<String> skills;
  
  Developer({
    required String name,
    required String id,
    required DateTime hireDate,
    required this.hourlyRate,
    this.hoursWorked = 0,
    this.skills = const [],
  }) : super(name: name, id: id, hireDate: hireDate);
  
  @override
  double calculateSalary() => hourlyRate * hoursWorked;
  
  void addSkill(String skill) {
    skills = [...skills, skill];
  }
  
  void displayInfo() {
    displayBasicInfo();
    displayContactInfo();
    print('المنصب: مطور');
    print('المهارات: ${skills.join(", ")}');
    print('الراتب: ${calculateSalary()}');
  }
}

void main() {
  var manager = Manager(
    name: 'أحمد محمد',
    id: 'M001',
    hireDate: DateTime(2020, 1, 15),
    baseSalary: 10000,
    bonus: 2000,
  )
    ..email = 'ahmed@company.com'
    ..phone = '0123456789';
  
  var developer = Developer(
    name: 'فاطمة علي',
    id: 'D001',
    hireDate: DateTime(2021, 6, 1),
    hourlyRate: 100,
    hoursWorked: 160,
    skills: ['Dart', 'Flutter', 'Firebase'],
  )
    ..email = 'fatima@company.com';
  
  print('=== معلومات المدير ===');
  manager.displayInfo();
  
  print('\n=== معلومات المطور ===');
  developer.displayInfo();
}
```

### مثال 2: نظام المكتبة المتقدم

```dart
abstract class LibraryItem {
  String id;
  String title;
  bool isCheckedOut = false;
  
  LibraryItem(this.id, this.title);
  
  void checkOut();
  void checkIn();
  void displayInfo();
}

class Book extends LibraryItem {
  String author;
  String isbn;
  int pages;
  
  Book({
    required String id,
    required String title,
    required this.author,
    required this.isbn,
    required this.pages,
  }) : super(id, title);
  
  @override
  void checkOut() {
    if (!isCheckedOut) {
      isCheckedOut = true;
      print('تم استعارة الكتاب: $title');
    } else {
      print('الكتاب مستعار بالفعل');
    }
  }
  
  @override
  void checkIn() {
    isCheckedOut = false;
    print('تم إرجاع الكتاب: $title');
  }
  
  @override
  void displayInfo() {
    print('\n--- كتاب ---');
    print('العنوان: $title');
    print('المؤلف: $author');
    print('ISBN: $isbn');
    print('الصفحات: $pages');
    print('الحالة: ${isCheckedOut ? "مستعار" : "متاح"}');
  }
}

class Magazine extends LibraryItem {
  String publisher;
  int issueNumber;
  DateTime publishDate;
  
  Magazine({
    required String id,
    required String title,
    required this.publisher,
    required this.issueNumber,
    required this.publishDate,
  }) : super(id, title);
  
  @override
  void checkOut() {
    if (!isCheckedOut) {
      isCheckedOut = true;
      print('تم استعارة المجلة: $title');
    } else {
      print('المجلة مستعارة بالفعل');
    }
  }
  
  @override
  void checkIn() {
    isCheckedOut = false;
    print('تم إرجاع المجلة: $title');
  }
  
  @override
  void displayInfo() {
    print('\n--- مجلة ---');
    print('العنوان: $title');
    print('الناشر: $publisher');
    print('العدد: $issueNumber');
    print('تاريخ النشر: ${publishDate.toString().substring(0, 10)}');
    print('الحالة: ${isCheckedOut ? "مستعارة" : "متاحة"}');
  }
}

class Library {
  List<LibraryItem> items = [];
  
  void addItem(LibraryItem item) {
    items.add(item);
    print('تمت إضافة: ${item.title}');
  }
  
  void listAvailableItems() {
    print('\n=== العناصر المتاحة ===');
    var available = items.where((item) => !item.isCheckedOut);
    
    if (available.isEmpty) {
      print('لا توجد عناصر متاحة');
      return;
    }
    
    for (var item in available) {
      print('${item.id}: ${item.title}');
    }
  }
}

void main() {
  var library = Library();
  
  library.addItem(Book(
    id: 'B001',
    title: 'تعلم Dart',
    author: 'أحمد محمد',
    isbn: '978-1234567890',
    pages: 350,
  ));
  
  library.addItem(Magazine(
    id: 'M001',
    title: 'مجلة التقنية',
    publisher: 'دار النشر',
    issueNumber: 42,
    publishDate: DateTime(2025, 10, 1),
  ));
  
  library.listAvailableItems();
  
  library.items[0].checkOut();
  library.listAvailableItems();
  
  library.items.forEach((item) => item.displayInfo());
}
```

## نصائح مهمة

1. استخدم الوراثة عندما تكون العلاقة "is-a" (هو نوع من)
2. استخدم Composition عندما تكون العلاقة "has-a" (يملك)
3. الأصناف المجردة مثالية للقوالب المشتركة
4. Interfaces تفرض عقد معين على الأصناف
5. Mixins رائعة لإعادة استخدام السلوكيات
6. Extension Methods تضيف وظائف بدون تعديل الأصناف الأصلية
7. تجنب سلاسل الوراثة العميقة (أكثر من 3-4 مستويات)

---

[⬅️ الموضوع السابق: البرمجة الكائنية - الجزء الأول](08_oop_part1.md) 
 [العودة للفهرس](README.md) 
 [الموضوع التالي: Null Safety ➡️](10_null_safety.md)
