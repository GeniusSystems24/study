# 3. المتغيرات وأنواع البيانات

## المتغيرات في Dart

### var - استنتاج تلقائي للنوع

```dart
var name = 'Ahmed';        // String
var age = 25;              // int
var height = 175.5;        // double
var isStudent = true;      // bool
```

### التصريح الصريح بالنوع

```dart
String name = 'Ahmed';
int age = 25;
double height = 175.5;
bool isStudent = true;
```

### final - قيمة ثابتة وقت التشغيل

```dart
final String city = 'Cairo';
final currentDate = DateTime.now();  // يتم تحديدها وقت التشغيل
// city = 'Alexandria';  // خطأ! لا يمكن تغيير القيمة
```

### const - قيمة ثابتة وقت الترجمة

```dart
const double pi = 3.14159;
const int maxUsers = 100;
// const currentTime = DateTime.now();  // خطأ! يجب أن تكون معروفة وقت الترجمة
```

## أنواع البيانات الأساسية

### Numbers (الأرقام)

#### int - الأعداد الصحيحة

```dart
int score = 95;
int negative = -10;
int hexValue = 0xDEADBEEF;
```

#### double - الأعداد العشرية

```dart
double price = 99.99;
double temperature = -5.5;
double scientific = 1.42e5;  // 142000.0
```

#### num - نوع عام للأرقام

```dart
num value = 10;      // يمكن أن يكون int
value = 10.5;        // أو double
```

### String (النصوص)

```dart
String greeting = 'مرحباً';
String name = "أحمد";

// نص متعدد الأسطر
String multiLine = '''
هذا نص
متعدد
الأسطر
''';

// String interpolation
String fullName = 'أحمد محمد';
int age = 25;
String message = 'اسمي $fullName وعمري $age سنة';
String calc = 'ضعف عمري: ${age * 2}';
```

### bool (القيم المنطقية)

```dart
bool isActive = true;
bool isDeleted = false;

// استخدام في الشروط
bool isAdult = age >= 18;
bool hasPermission = isActive && !isDeleted;
```

### List (القوائم)

```dart
// قائمة بنوع محدد
List<int> numbers = [1, 2, 3, 4, 5];
List<String> names = ['أحمد', 'محمد', 'فاطمة'];

// قائمة متغيرة النوع
var mixedList = [1, 'نص', true, 3.14];

// الوصول للعناصر
print(numbers[0]);  // 1
numbers.add(6);
numbers.remove(3);
```

### Set (المجموعات)

```dart
// مجموعة بدون تكرار
Set<String> countries = {'مصر', 'السعودية', 'الإمارات'};
countries.add('مصر');  // لن تضاف لأنها موجودة
```

### Map (الخرائط)

```dart
// مفتاح: قيمة
Map<String, int> ages = {
  'أحمد': 25,
  'محمد': 30,
  'فاطمة': 22
};

// الوصول للقيم
print(ages['أحمد']);  // 25
ages['علي'] = 28;
```

## التحويل بين الأنواع

### String إلى Number

```dart
String strNumber = '42';
int number = int.parse(strNumber);
double decimal = double.parse('3.14');
```

### Number إلى String

```dart
int age = 25;
String strAge = age.toString();
double price = 99.99;
String strPrice = price.toStringAsFixed(2);  // "99.99"
```

### التحقق من النوع

```dart
var value = 42;
print(value is int);        // true
print(value is! String);    // true
```

## المتغيرات المتأخرة (Late)

```dart
late String description;

void initialize() {
  description = 'تم التهيئة';
}

// استخدام المتغير بعد التهيئة
initialize();
print(description);
```

## القيم الافتراضية

```dart
int? nullableNumber;        // null
String? nullableString;     // null
bool? nullableBool;         // null

// قيم افتراضية
int counter = 0;
String name = 'غير معروف';
```

## أمثلة عملية

```dart
void main() {
  // بيانات طالب
  final String studentName = 'أحمد محمد';
  var studentAge = 20;
  const String university = 'جامعة القاهرة';
  
  // درجات الطالب
  List<double> grades = [85.5, 90.0, 88.5, 92.0];
  
  // حساب المعدل
  double sum = 0;
  for (var grade in grades) {
    sum += grade;
  }
  double average = sum / grades.length;
  
  // عرض المعلومات
  print('الطالب: $studentName');
  print('العمر: $studentAge');
  print('الجامعة: $university');
  print('المعدل: ${average.toStringAsFixed(2)}');
  print('ناجح: ${average >= 60}');
}
```

## نصائح مهمة

1. استخدم `var` عندما يكون النوع واضحاً
2. استخدم `final` للقيم التي لا تتغير بعد التهيئة
3. استخدم `const` للثوابت المعروفة وقت الترجمة
4. حدد نوع البيانات صراحةً في الدوال والمعاملات
5. استخدم `late` فقط عند الضرورة

---

[⬅️ الموضوع السابق: إعداد بيئة التطوير](02_setup.md) | [العودة للفهرس](README.md) | [الموضوع التالي: العمليات والمعاملات ➡️](04_operators.md)
