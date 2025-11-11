# 7. المجموعات (Collections)

## List (القوائم)

القوائم هي مجموعات مرتبة من العناصر يمكن أن تحتوي على عناصر مكررة.

### إنشاء القوائم

```dart
// قائمة فارغة
List<int> numbers = [];
var names = <String>[];

// قائمة بقيم ابتدائية
List<int> scores = [85, 90, 78, 92];
var fruits = ['تفاح', 'موز', 'برتقال'];

// قائمة بطول ثابت
var fixedList = List<int>.filled(5, 0);  // [0, 0, 0, 0, 0]

// قائمة قابلة للنمو
var growableList = List<int>.empty(growable: true);
```

### العمليات الأساسية

```dart
var fruits = ['تفاح', 'موز'];

// إضافة عنصر
fruits.add('برتقال');           // ['تفاح', 'موز', 'برتقال']
fruits.addAll(['عنب', 'فراولة']); // إضافة عدة عناصر

// إدراج في موضع محدد
fruits.insert(1, 'مانجو');       // ['تفاح', 'مانجو', 'موز', ...]

// الوصول للعناصر
print(fruits[0]);                // تفاح
print(fruits.first);             // أول عنصر
print(fruits.last);              // آخر عنصر

// الحذف
fruits.remove('موز');            // حذف بالقيمة
fruits.removeAt(0);              // حذف بالفهرس
fruits.removeLast();             // حذف آخر عنصر
fruits.clear();                  // حذف كل العناصر

// التحديث
fruits[0] = 'كيوي';

// الطول
print(fruits.length);

// التحقق
print(fruits.isEmpty);
print(fruits.isNotEmpty);
print(fruits.contains('تفاح'));
```

### طرق مفيدة للقوائم

```dart
var numbers = [1, 2, 3, 4, 5];

// forEach - التكرار
numbers.forEach((n) => print(n));

// map - التحويل
var doubled = numbers.map((n) => n * 2).toList();
print(doubled);  // [2, 4, 6, 8, 10]

// where - التصفية
var even = numbers.where((n) => n % 2 == 0).toList();
print(even);  // [2, 4]

// reduce - الدمج
var sum = numbers.reduce((a, b) => a + b);
print(sum);  // 15

// any - هل يوجد عنصر يحقق الشرط
print(numbers.any((n) => n > 3));  // true

// every - هل كل العناصر تحقق الشرط
print(numbers.every((n) => n > 0));  // true

// sort - الترتيب
numbers.sort();                    // تصاعدي
numbers.sort((a, b) => b.compareTo(a));  // تنازلي

// reversed - العكس
var reversed = numbers.reversed.toList();

// take - أخذ عدد معين
var first3 = numbers.take(3).toList();

// skip - تخطي عدد معين
var skip2 = numbers.skip(2).toList();
```

## Set (المجموعات)

المجموعات هي مجموعات غير مرتبة لا تحتوي على عناصر مكررة.

### إنشاء المجموعات

```dart
// مجموعة فارغة
Set<String> names = {};
var numbers = <int>{};

// مجموعة بقيم
var fruits = {'تفاح', 'موز', 'برتقال'};
Set<int> primes = {2, 3, 5, 7, 11};

// من قائمة (يزيل المكرر)
var list = [1, 2, 2, 3, 3, 4];
var uniqueNumbers = Set<int>.from(list);  // {1, 2, 3, 4}
```

### العمليات الأساسية

```dart
var countries = {'مصر', 'السعودية'};

// الإضافة
countries.add('الإمارات');
countries.addAll({'الأردن', 'العراق'});

// الحذف
countries.remove('مصر');
countries.clear();

// التحقق
print(countries.contains('السعودية'));
print(countries.length);
```

### عمليات المجموعات الرياضية

```dart
var set1 = {1, 2, 3, 4};
var set2 = {3, 4, 5, 6};

// الاتحاد (Union)
var union = set1.union(set2);
print(union);  // {1, 2, 3, 4, 5, 6}

// التقاطع (Intersection)
var intersection = set1.intersection(set2);
print(intersection);  // {3, 4}

// الفرق (Difference)
var difference = set1.difference(set2);
print(difference);  // {1, 2}
```

## Map (الخرائط)

الخرائط هي مجموعات من أزواج المفتاح-القيمة.

### إنشاء الخرائط

```dart
// خريطة فارغة
Map<String, int> ages = {};
var scores = <String, double>{};

// خريطة بقيم
var capitals = {
  'مصر': 'القاهرة',
  'السعودية': 'الرياض',
  'الإمارات': 'أبوظبي',
};

Map<String, int> studentGrades = {
  'أحمد': 85,
  'محمد': 90,
  'فاطمة': 88,
};
```

### العمليات الأساسية

```dart
var user = {
  'name': 'أحمد',
  'age': 25,
  'city': 'القاهرة',
};

// الوصول
print(user['name']);             // أحمد
print(user['email'] ?? 'لا يوجد'); // قيمة افتراضية

// الإضافة/التحديث
user['email'] = 'ahmed@example.com';
user['age'] = 26;

// الحذف
user.remove('city');
user.clear();

// التحقق
print(user.containsKey('name'));
print(user.containsValue('أحمد'));
print(user.isEmpty);
print(user.length);

// المفاتيح والقيم
print(user.keys);      // جميع المفاتيح
print(user.values);    // جميع القيم
```

### التكرار على الخرائط

```dart
var grades = {
  'أحمد': 85,
  'محمد': 90,
  'فاطمة': 88,
};

// التكرار على الأزواج
grades.forEach((name, grade) {
  print('$name: $grade');
});

// التكرار على entries
for (var entry in grades.entries) {
  print('${entry.key}: ${entry.value}');
}

// التكرار على المفاتيح
for (var name in grades.keys) {
  print('$name حصل على ${grades[name]}');
}

// التكرار على القيم
for (var grade in grades.values) {
  print('درجة: $grade');
}
```

## Collection If و Collection For

### Collection If

```dart
var isLoggedIn = true;
var items = [
  'الصفحة الرئيسية',
  'حول',
  if (isLoggedIn) 'الملف الشخصي',
  if (isLoggedIn) 'الإعدادات',
];

print(items);
```

### Collection For

```dart
var numbers = [1, 2, 3];
var doubled = [
  for (var n in numbers) n * 2
];
print(doubled);  // [2, 4, 6]

// مع شرط
var evenDoubled = [
  for (var n in numbers)
    if (n % 2 == 0) n * 2
];
```

## Spread Operator (...)

```dart
var list1 = [1, 2, 3];
var list2 = [4, 5, 6];

// دمج القوائم
var combined = [...list1, ...list2];
print(combined);  // [1, 2, 3, 4, 5, 6]

// مع null safety
List<int>? nullableList;
var safe = [...?nullableList, 7, 8];
```

## أمثلة عملية شاملة

### مثال 1: إدارة قائمة مهام

```dart
class TodoList {
  List<String> tasks = [];
  
  void addTask(String task) {
    tasks.add(task);
    print('تمت إضافة: $task');
  }
  
  void removeTask(int index) {
    if (index >= 0 && index < tasks.length) {
      var removed = tasks.removeAt(index);
      print('تم حذف: $removed');
    }
  }
  
  void displayTasks() {
    if (tasks.isEmpty) {
      print('لا توجد مهام');
      return;
    }
    
    print('\n--- قائمة المهام ---');
    for (var i = 0; i < tasks.length; i++) {
      print('${i + 1}. ${tasks[i]}');
    }
  }
}

void main() {
  var todo = TodoList();
  todo.addTask('شراء البقالة');
  todo.addTask('الدراسة');
  todo.addTask('التمرين');
  todo.displayTasks();
  todo.removeTask(1);
  todo.displayTasks();
}
```

### مثال 2: سجل الطلاب

```dart
class StudentRegistry {
  Map<String, Map<String, dynamic>> students = {};
  
  void addStudent(String id, String name, int age) {
    students[id] = {
      'name': name,
      'age': age,
      'grades': <double>[],
    };
    print('تمت إضافة الطالب: $name');
  }
  
  void addGrade(String id, double grade) {
    if (students.containsKey(id)) {
      (students[id]!['grades'] as List<double>).add(grade);
    }
  }
  
  double getAverage(String id) {
    if (!students.containsKey(id)) return 0.0;
    
    var grades = students[id]!['grades'] as List<double>;
    if (grades.isEmpty) return 0.0;
    
    return grades.reduce((a, b) => a + b) / grades.length;
  }
  
  void displayStudent(String id) {
    if (!students.containsKey(id)) {
      print('الطالب غير موجود');
      return;
    }
    
    var student = students[id]!;
    print('\nالطالب: ${student['name']}');
    print('العمر: ${student['age']}');
    print('المعدل: ${getAverage(id).toStringAsFixed(2)}');
  }
}

void main() {
  var registry = StudentRegistry();
  registry.addStudent('001', 'أحمد', 20);
  registry.addGrade('001', 85.5);
  registry.addGrade('001', 90.0);
  registry.addGrade('001', 88.5);
  registry.displayStudent('001');
}
```

### مثال 3: تحليل النصوص

```dart
Map<String, int> countWords(String text) {
  var words = text.toLowerCase().split(' ');
  Map<String, int> wordCount = {};
  
  for (var word in words) {
    wordCount[word] = (wordCount[word] ?? 0) + 1;
  }
  
  return wordCount;
}

void main() {
  var text = 'مرحبا مرحبا كيف الحال كيف الأحوال';
  var counts = countWords(text);
  
  print('عدد تكرار الكلمات:');
  counts.forEach((word, count) {
    print('$word: $count');
  });
}
```

### مثال 4: إزالة التكرار

```dart
List<T> removeDuplicates<T>(List<T> list) {
  return Set<T>.from(list).toList();
}

void main() {
  var numbers = [1, 2, 2, 3, 4, 4, 5];
  var unique = removeDuplicates(numbers);
  print('الأصلية: $numbers');
  print('بدون تكرار: $unique');
}
```

## نصائح مهمة

1. **List**: استخدمها للبيانات المرتبة التي قد تتكرر
2. **Set**: استخدمها للبيانات الفريدة أو للعمليات الرياضية
3. **Map**: استخدمها لتخزين أزواج المفتاح-القيمة
4. استخدم `final` للمجموعات التي لن تُعاد تهيئتها
5. استخدم `const` للمجموعات الثابتة تماماً
6. احذر من تعديل المجموعة أثناء التكرار عليها
7. استخدم `?.` للوصول الآمن للعناصر

---

[⬅️ الموضوع السابق: الدوال](06_functions.md) | [العودة للفهرس](README.md) | [الموضوع التالي: البرمجة الكائنية - الجزء الأول ➡️](08_oop_part1.md)
