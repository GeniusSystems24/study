# 04 - التحكم في التدفق (Control Flow)

## 📋 المحتويات

- [المقدمة](#المقدمة)
- [الجمل الشرطية](#الجمل-الشرطية)
  - [if و else](#if-و-else)
  - [else if](#else-if)
  - [العامل الشرطي الثلاثي](#العامل-الشرطي-الثلاثي)
  - [switch و case](#switch-و-case)
- [الحلقات التكرارية](#الحلقات-التكرارية)
  - [for loop](#for-loop)
  - [while loop](#while-loop)
  - [do-while loop](#do-while-loop)
  - [for-in loop](#for-in-loop)
  - [forEach](#foreach)
- [أوامر التحكم](#أوامر-التحكم)
  - [break](#break)
  - [continue](#continue)
  - [return](#return)
- [أمثلة عملية](#أمثلة-عملية)
- [تمارين](#تمارين)

---

## 🎯 المقدمة

التحكم في التدفق (Control Flow) هو آلية توجيه مسار تنفيذ البرنامج بناءً على شروط معينة أو تكرار عمليات محددة.

### لماذا نحتاج Control Flow؟

- ✅ اتخاذ قرارات برمجية
- ✅ تنفيذ كود معين عند تحقق شرط
- ✅ تكرار عمليات متعددة
- ✅ التحكم في سير البرنامج

---

## 🔀 الجمل الشرطية

### if و else

```dart
void main() {
  int age = 18;
  
  // شرط بسيط
  if (age >= 18) {
    print('بالغ');
  }
  
  // if-else
  if (age >= 18) {
    print('بالغ');
  } else {
    print('قاصر');
  }
}
```

### else if

```dart
void main() {
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
}
```

### العامل الشرطي الثلاثي

```dart
void main() {
  int age = 20;
  
  // الطريقة التقليدية
  String status;
  if (age >= 18) {
    status = 'بالغ';
  } else {
    status = 'قاصر';
  }
  
  // باستخدام العامل الثلاثي
  String status2 = age >= 18 ? 'بالغ' : 'قاصر';
  
  print(status2); // بالغ
}
```

### switch و case

```dart
void main() {
  String day = 'Monday';
  
  switch (day) {
    case 'Monday':
      print('الإثنين - بداية الأسبوع');
      break;
    case 'Tuesday':
      print('الثلاثاء');
      break;
    case 'Wednesday':
      print('الأربعاء');
      break;
    case 'Thursday':
      print('الخميس');
      break;
    case 'Friday':
      print('الجمعة');
      break;
    case 'Saturday':
    case 'Sunday':
      print('عطلة نهاية الأسبوع');
      break;
    default:
      print('يوم غير معروف');
  }
}
```

**مثال عملي - آلة حاسبة:**

```dart
void calculator(double num1, double num2, String operator) {
  double result;
  
  switch (operator) {
    case '+':
      result = num1 + num2;
      break;
    case '-':
      result = num1 - num2;
      break;
    case '*':
      result = num1 * num2;
      break;
    case '/':
      if (num2 != 0) {
        result = num1 / num2;
      } else {
        print('خطأ: لا يمكن القسمة على صفر');
        return;
      }
      break;
    default:
      print('عملية غير معروفة');
      return;
  }
  
  print('$num1 $operator $num2 = $result');
}

void main() {
  calculator(10, 5, '+');  // 10 + 5 = 15
  calculator(10, 5, '-');  // 10 - 5 = 5
  calculator(10, 5, '*');  // 10 * 5 = 50
  calculator(10, 5, '/');  // 10 / 5 = 2
}
```

---

## 🔁 الحلقات التكرارية

### for loop

```dart
void main() {
  // حلقة for بسيطة
  for (int i = 0; i < 5; i++) {
    print('العدد: $i');
  }
  
  // الناتج:
  // العدد: 0
  // العدد: 1
  // العدد: 2
  // العدد: 3
  // العدد: 4
  
  // طباعة الأعداد الزوجية
  for (int i = 0; i <= 10; i += 2) {
    print(i);
  }
  
  // العد التنازلي
  for (int i = 5; i > 0; i--) {
    print(i);
  }
}
```

### while loop

```dart
void main() {
  int count = 0;
  
  while (count < 5) {
    print('Count: $count');
    count++;
  }
  
  // مثال: إيجاد مجموع الأعداد من 1 إلى 10
  int sum = 0;
  int num = 1;
  
  while (num <= 10) {
    sum += num;
    num++;
  }
  
  print('المجموع: $sum'); // المجموع: 55
}
```

### do-while loop

```dart
void main() {
  int count = 0;
  
  // تنفذ مرة واحدة على الأقل حتى لو كان الشرط خاطئاً
  do {
    print('Count: $count');
    count++;
  } while (count < 5);
  
  // مثال: التنفيذ مرة واحدة على الأقل
  int num = 10;
  do {
    print('هذا سيطبع مرة واحدة');
  } while (num < 5); // الشرط خاطئ لكن الكود يُنفذ
}
```

### for-in loop

```dart
void main() {
  // التكرار على قائمة
  List<String> fruits = ['تفاح', 'موز', 'برتقال'];
  
  for (String fruit in fruits) {
    print(fruit);
  }
  
  // التكرار على Set
  Set<int> numbers = {1, 2, 3, 4, 5};
  
  for (int num in numbers) {
    print(num);
  }
  
  // التكرار على مفاتيح Map
  Map<String, int> ages = {'أحمد': 25, 'فاطمة': 30};
  
  for (String name in ages.keys) {
    print('$name: ${ages[name]}');
  }
}
```

### forEach

```dart
void main() {
  List<int> numbers = [1, 2, 3, 4, 5];
  
  // باستخدام forEach
  numbers.forEach((number) {
    print(number * 2);
  });
  
  // نسخة مختصرة
  numbers.forEach((n) => print(n * 2));
  
  // مع Map
  Map<String, String> capitals = {
    'مصر': 'القاهرة',
    'السعودية': 'الرياض',
    'الإمارات': 'أبوظبي'
  };
  
  capitals.forEach((country, capital) {
    print('عاصمة $country هي $capital');
  });
}
```

---

## ⚡ أوامر التحكم

### break

يستخدم لإيقاف الحلقة فوراً:

```dart
void main() {
  // البحث عن عدد معين
  List<int> numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  int target = 5;
  
  for (int num in numbers) {
    if (num == target) {
      print('وجدت العدد: $num');
      break; // إيقاف الحلقة
    }
  }
  
  // مثال: إيجاد أول عدد زوجي
  for (int i = 1; i <= 10; i++) {
    if (i % 2 == 0) {
      print('أول عدد زوجي: $i');
      break;
    }
  }
}
```

### continue

يستخدم لتخطي التكرار الحالي والانتقال للتالي:

```dart
void main() {
  // طباعة الأعداد الفردية فقط
  for (int i = 1; i <= 10; i++) {
    if (i % 2 == 0) {
      continue; // تخطي الأعداد الزوجية
    }
    print(i);
  }
  
  // تخطي قيمة معينة
  List<String> names = ['أحمد', 'محمد', 'فاطمة', 'علي'];
  
  for (String name in names) {
    if (name == 'محمد') {
      continue; // تخطي "محمد"
    }
    print(name);
  }
}
```

### return

يستخدم للخروج من دالة وإرجاع قيمة:

```dart
bool isEven(int number) {
  if (number % 2 == 0) {
    return true;
  }
  return false;
}

String getGrade(int score) {
  if (score >= 90) return 'A';
  if (score >= 80) return 'B';
  if (score >= 70) return 'C';
  if (score >= 60) return 'D';
  return 'F';
}

void main() {
  print(isEven(4));        // true
  print(isEven(7));        // false
  print(getGrade(95));     // A
  print(getGrade(75));     // C
}
```

---

## 💼 أمثلة عملية

### مثال 1: جدول الضرب

```dart
void multiplicationTable(int number) {
  print('جدول الضرب للعدد $number:');
  print('=' * 25);
  
  for (int i = 1; i <= 10; i++) {
    print('$number × $i = ${number * i}');
  }
}

void main() {
  multiplicationTable(5);
}
```

### مثال 2: التحقق من الأعداد الأولية

```dart
bool isPrime(int number) {
  if (number <= 1) return false;
  if (number == 2) return true;
  
  for (int i = 2; i <= number ~/ 2; i++) {
    if (number % i == 0) {
      return false;
    }
  }
  
  return true;
}

void main() {
  print('الأعداد الأولية من 1 إلى 20:');
  
  for (int i = 1; i <= 20; i++) {
    if (isPrime(i)) {
      print(i);
    }
  }
}
```

### مثال 3: حساب متوسط الدرجات

```dart
void main() {
  List<double> grades = [85.5, 90.0, 78.5, 92.0, 88.5];
  double sum = 0;
  
  // حساب المجموع
  for (double grade in grades) {
    sum += grade;
  }
  
  // حساب المتوسط
  double average = sum / grades.length;
  
  print('الدرجات: $grades');
  print('المتوسط: ${average.toStringAsFixed(2)}');
  
  // تحديد التقدير
  String gradeLevel;
  if (average >= 90) {
    gradeLevel = 'ممتاز';
  } else if (average >= 80) {
    gradeLevel = 'جيد جداً';
  } else if (average >= 70) {
    gradeLevel = 'جيد';
  } else if (average >= 60) {
    gradeLevel = 'مقبول';
  } else {
    gradeLevel = 'راسب';
  }
  
  print('التقدير: $gradeLevel');
}
```

---

## 🎯 تمارين

### تمرين 1: الآلة الحاسبة المتقدمة

أنشئ برنامج آلة حاسبة يدعم العمليات الأساسية ويستمر في العمل حتى يختار المستخدم الخروج.

```dart
// املأ الكود هنا
void advancedCalculator() {
  // استخدم while loop
  // استخدم switch للعمليات
  // استخدم break للخروج
}
```

### تمرين 2: إيجاد الأعداد المثالية

اكتب برنامجاً يجد جميع الأعداد المثالية (العدد الذي يساوي مجموع قواسمه) بين 1 و 1000.

```dart
bool isPerfectNumber(int n) {
  // املأ الكود هنا
}

void main() {
  // اطبع جميع الأعداد المثالية
}
```

### تمرين 3: نمط النجوم

اطبع النمط التالي:

```
*
**
***
****
*****
```

```dart
void printStarPattern(int rows) {
  // املأ الكود هنا
}
```

---

## 📚 للتعمق أكثر

لمزيد من التفاصيل، راجع:

- [التحكم في التدفق - Dart Basic](../Dart%20basic/05_control_flow.md)
- [الدوال في Dart](../Dart%20basic/06_functions.md)

---

## 📖 المراجع والمصادر

### مصادر Dart الرسمية

1. **Dart Language Tour - Control Flow**
   - [Control Flow Statements](https://dart.dev/guides/language/language-tour#control-flow-statements)
   - [If and Else](https://dart.dev/guides/language/language-tour#if-and-else)
   - [For Loops](https://dart.dev/guides/language/language-tour#for-loops)
   - [While and Do-While](https://dart.dev/guides/language/language-tour#while-and-do-while)
   - [Break and Continue](https://dart.dev/guides/language/language-tour#break-and-continue)
   - [Switch and Case](https://dart.dev/guides/language/language-tour#switch-and-case)

2. **Effective Dart**
   - [Control Flow Best Practices](https://dart.dev/guides/language/effective-dart/usage#control-flow)
   - [Avoid Using break in Switch Cases](https://dart.dev/guides/language/effective-dart/usage#dont-use-break-when-a-case-body-is-empty)

3. **Dart Collections**
   - [Iterating Over Collections](https://dart.dev/guides/libraries/library-tour#collections)
   - [forEach Method](https://api.dart.dev/stable/dart-core/Iterable/forEach.html)

### مصادر تفاعلية

4. **DartPad Examples**
   - [Control Flow Examples in DartPad](https://dartpad.dev/)
   - [Interactive Dart Tutorials](https://dart.dev/tutorials)

5. **Dart Samples**
   - [Control Flow Samples](https://dart.dev/samples)
   - [Iteration Examples](https://dart.dev/guides/language/language-tour#iteration)

### مصادر داخل المستودع

6. **خطة تعلم Dart الشاملة**
   - [فهرس Dart الكامل](../Dart%20basic/README.md)
   - [التحكم في التدفق](../Dart%20basic/05_control_flow.md)
   - [الدوال](../Dart%20basic/06_functions.md)

### مراجع API

7. **Dart Core Library**
   - [Iterable Class](https://api.dart.dev/stable/dart-core/Iterable-class.html)
   - [List Class](https://api.dart.dev/stable/dart-core/List-class.html)
   - [Map Class](https://api.dart.dev/stable/dart-core/Map-class.html)

### مصادر إضافية

8. **Community Resources**
   - [Dart Control Flow on Stack Overflow](https://stackoverflow.com/questions/tagged/dart+control-flow)
   - [Dart Reddit Community](https://www.reddit.com/r/dartlang/)

9. **Video Tutorials**
   - [Dart Programming Tutorial - Control Flow](https://www.youtube.com/dartlang)
   - [Flutter & Dart Complete Guide](https://www.udemy.com/topic/dart-programming-language/)

10. **Books and References**
    - [Dart Apprentice - Chapter on Control Flow](https://www.raywenderlich.com/books/dart-apprentice)
    - [Programming Dart - Control Structures](https://www.oreilly.com/library/view/dart-up-and/9781449330880/)

---

## 💡 نصائح

- ✅ استخدم `for-in` للتكرار على المجموعات
- ✅ استخدم `while` عندما لا تعرف عدد التكرارات مسبقاً
- ✅ استخدم `switch` بدلاً من `if-else` المتعددة عندما يكون ممكناً
- ✅ لا تنسَ `break` في نهاية كل `case`
- ✅ استخدم العامل الثلاثي للشروط البسيطة
- ✅ تجنب الحلقات اللانهائية
- ✅ مارس على [DartPad](https://dartpad.dev/)

---

[⬅️ السابق: أساسيات Dart](03_dart_basics.md)
[🏠 العودة للفهرس](../README.md)
[التالي: الدوال ➡️](05_functions.md)
