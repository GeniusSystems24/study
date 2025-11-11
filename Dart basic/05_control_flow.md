# 5. التحكم في التدفق (Control Flow)

## جمل الشرط (Conditional Statements)

### if و else

```dart
int age = 18;

if (age >= 18) {
  print('بالغ');
} else {
  print('قاصر');
}
```

### if-else if-else

```dart
int score = 85;

if (score >= 90) {
  print('ممتاز');
} else if (score >= 80) {
  print('جيد جداً');
} else if (score >= 70) {
  print('جيد');
} else if (score >= 60) {
  print('مقبول');
} else {
  print('راسب');
}
```

### شروط متداخلة

```dart
int age = 25;
bool hasLicense = true;

if (age >= 18) {
  if (hasLicense) {
    print('يمكنه القيادة');
  } else {
    print('يحتاج رخصة قيادة');
  }
} else {
  print('صغير على القيادة');
}
```

### الشرط المختصر

```dart
int age = 20;
String status = age >= 18 ? 'بالغ' : 'قاصر';

// للقيم الافتراضية
String? username;
print(username ?? 'ضيف');
```

## switch و case

### الاستخدام الأساسي

```dart
String day = 'الاثنين';

switch (day) {
  case 'السبت':
  case 'الأحد':
    print('عطلة نهاية الأسبوع');
    break;
  case 'الاثنين':
  case 'الثلاثاء':
  case 'الأربعاء':
  case 'الخميس':
    print('يوم عمل');
    break;
  case 'الجمعة':
    print('يوم صلاة');
    break;
  default:
    print('يوم غير معروف');
}
```

### switch مع الأرقام

```dart
int month = 3;

switch (month) {
  case 1:
    print('يناير');
    break;
  case 2:
    print('فبراير');
    break;
  case 3:
    print('مارس');
    break;
  default:
    print('شهر آخر');
}
```

### switch بدون break (Fall-through)

```dart
int number = 2;

switch (number) {
  case 1:
    print('واحد');
    continue label2;  // الانتقال للحالة المسماة
  label2:
  case 2:
    print('اثنان');
    break;
  case 3:
    print('ثلاثة');
    break;
}
```

## الحلقات التكرارية (Loops)

### for Loop

```dart
// الصيغة القياسية
for (int i = 1; i <= 5; i++) {
  print('العدد: $i');
}

// التكرار على قائمة
List<String> names = ['أحمد', 'محمد', 'فاطمة'];
for (int i = 0; i < names.length; i++) {
  print('${i + 1}. ${names[i]}');
}

// حلقة متداخلة - جدول الضرب
for (int i = 1; i <= 3; i++) {
  for (int j = 1; j <= 3; j++) {
    print('$i × $j = ${i * j}');
  }
}
```

### for-in Loop

```dart
List<String> fruits = ['تفاح', 'موز', 'برتقال'];

for (var fruit in fruits) {
  print(fruit);
}

// مع Map
Map<String, int> ages = {
  'أحمد': 25,
  'محمد': 30,
  'فاطمة': 22
};

for (var entry in ages.entries) {
  print('${entry.key}: ${entry.value} سنة');
}
```

### forEach

```dart
List<int> numbers = [1, 2, 3, 4, 5];

numbers.forEach((number) {
  print(number * 2);
});

// صيغة مختصرة
numbers.forEach(print);
```

### while Loop

```dart
int counter = 1;

while (counter <= 5) {
  print('العداد: $counter');
  counter++;
}

// مثال: إدخال المستخدم
String password = '';
while (password != '1234') {
  print('أدخل كلمة المرور:');
  // password = stdin.readLineSync() ?? '';
}
```

### do-while Loop

```dart
int i = 1;

do {
  print('القيمة: $i');
  i++;
} while (i <= 5);

// الفرق: يُنفذ مرة واحدة على الأقل
int j = 10;
do {
  print('سينفذ مرة واحدة: $j');
} while (j < 5);  // الشرط false لكنه نُفذ مرة
```

## التحكم في الحلقات

### break - إيقاف الحلقة

```dart
// إيقاف عند شرط معين
for (int i = 1; i <= 10; i++) {
  if (i == 6) {
    break;  // يوقف الحلقة عند 6
  }
  print(i);
}

// البحث في قائمة
List<String> names = ['أحمد', 'محمد', 'علي', 'فاطمة'];
String searchName = 'علي';

for (var name in names) {
  if (name == searchName) {
    print('تم العثور على $name');
    break;
  }
}
```

### continue - تخطي التكرار الحالي

```dart
// طباعة الأرقام الفردية فقط
for (int i = 1; i <= 10; i++) {
  if (i % 2 == 0) {
    continue;  // يتخطى الأرقام الزوجية
  }
  print(i);
}

// تخطي عناصر معينة
List<String> items = ['تفاح', 'ممنوع', 'موز', 'ممنوع', 'برتقال'];
for (var item in items) {
  if (item == 'ممنوع') {
    continue;
  }
  print(item);
}
```

### Labels - التسميات

```dart
// للخروج من حلقات متداخلة
outerLoop:
for (int i = 1; i <= 3; i++) {
  for (int j = 1; j <= 3; j++) {
    if (i == 2 && j == 2) {
      break outerLoop;  // يوقف الحلقة الخارجية
    }
    print('i=$i, j=$j');
  }
}

// continue مع التسميات
outerLoop:
for (int i = 1; i <= 3; i++) {
  for (int j = 1; j <= 3; j++) {
    if (j == 2) {
      continue outerLoop;  // ينتقل للتكرار التالي للحلقة الخارجية
    }
    print('i=$i, j=$j');
  }
}
```

## أمثلة عملية شاملة

### مثال 1: حساب المعدل والتقدير

```dart
void main() {
  List<double> grades = [85.5, 90.0, 78.5, 92.0, 88.0];
  double sum = 0;
  
  // حساب المجموع
  for (var grade in grades) {
    sum += grade;
  }
  
  double average = sum / grades.length;
  
  // تحديد التقدير
  String grade;
  if (average >= 90) {
    grade = 'A';
  } else if (average >= 80) {
    grade = 'B';
  } else if (average >= 70) {
    grade = 'C';
  } else if (average >= 60) {
    grade = 'D';
  } else {
    grade = 'F';
  }
  
  print('المعدل: ${average.toStringAsFixed(2)}');
  print('التقدير: $grade');
}
```

### مثال 2: جدول الضرب

```dart
void printMultiplicationTable(int number) {
  print('جدول الضرب للعدد $number:');
  print('-------------------');
  
  for (int i = 1; i <= 10; i++) {
    print('$number × $i = ${number * i}');
  }
}

void main() {
  printMultiplicationTable(5);
}
```

### مثال 3: عكس نص

```dart
String reverseString(String text) {
  String reversed = '';
  
  for (int i = text.length - 1; i >= 0; i--) {
    reversed += text[i];
  }
  
  return reversed;
}

void main() {
  String original = 'مرحبا';
  String reversed = reverseString(original);
  print('الأصلي: $original');
  print('المعكوس: $reversed');
}
```

### مثال 4: البحث عن الأعداد الأولية

```dart
bool isPrime(int number) {
  if (number < 2) return false;
  
  for (int i = 2; i <= number ~/ 2; i++) {
    if (number % i == 0) {
      return false;
    }
  }
  
  return true;
}

void main() {
  print('الأعداد الأولية من 1 إلى 50:');
  
  for (int i = 1; i <= 50; i++) {
    if (isPrime(i)) {
      print(i);
    }
  }
}
```

### مثال 5: نظام قائمة بسيط

```dart
void main() {
  bool exit = false;
  
  while (!exit) {
    print('\n--- القائمة الرئيسية ---');
    print('1. عرض المعلومات');
    print('2. إضافة عنصر');
    print('3. حذف عنصر');
    print('4. خروج');
    print('اختر رقم (1-4):');
    
    int choice = 2; // محاكاة الإدخال
    
    switch (choice) {
      case 1:
        print('عرض المعلومات...');
        break;
      case 2:
        print('إضافة عنصر...');
        break;
      case 3:
        print('حذف عنصر...');
        break;
      case 4:
        exit = true;
        print('وداعاً!');
        break;
      default:
        print('اختيار غير صحيح');
    }
  }
}
```

## نصائح مهمة

1. استخدم `for-in` للتكرار على المجموعات عندما لا تحتاج للفهرس
2. `while` مناسبة عندما لا تعرف عدد التكرارات مسبقاً
3. `do-while` تضمن التنفيذ مرة واحدة على الأقل
4. استخدم `break` للخروج المبكر من الحلقة
5. `continue` لتخطي التكرار الحالي فقط
6. تجنب الحلقات اللانهائية (تأكد من تحديث الشرط)
7. استخدم Labels فقط عند الحاجة للتحكم في حلقات متداخلة

---

[⬅️ الموضوع السابق: العمليات والمعاملات](04_operators.md) | [العودة للفهرس](README.md) | [الموضوع التالي: الدوال ➡️](06_functions.md)
