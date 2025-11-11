# 13. Generics (البرمجة العامة)

## ما هي Generics؟

Generics تسمح بكتابة كود قابل لإعادة الاستخدام مع أنواع مختلفة مع الحفاظ على Type Safety.

## لماذا نستخدم Generics؟

```dart
// بدون Generics - كود مكرر
class IntBox {
  int value;
  IntBox(this.value);
}

class StringBox {
  String value;
  StringBox(this.value);
}

// مع Generics - كود واحد لأنواع متعددة
class Box<T> {
  T value;
  Box(this.value);
}

void main() {
  var intBox = Box<int>(42);
  var stringBox = Box<String>('مرحباً');
  var doubleBox = Box<double>(3.14);
  
  print(intBox.value);     // 42
  print(stringBox.value);  // مرحباً
}
```

## Generic Classes

### صنف عام بسيط

```dart
class Pair<K, V> {
  final K key;
  final V value;
  
  Pair(this.key, this.value);
  
  @override
  String toString() => 'Pair($key: $value)';
}

void main() {
  var pair1 = Pair<String, int>('العمر', 25);
  var pair2 = Pair<int, String>(1, 'الأول');
  
  // استنتاج تلقائي للنوع
  var pair3 = Pair('اسم', 'أحمد');  // Pair<String, String>
  
  print(pair1);
  print(pair2);
  print(pair3);
}
```

### صنف Stack عام

```dart
class Stack<T> {
  final List<T> _items = [];
  
  void push(T item) {
    _items.add(item);
  }
  
  T? pop() {
    if (_items.isEmpty) return null;
    return _items.removeLast();
  }
  
  T? peek() {
    if (_items.isEmpty) return null;
    return _items.last;
  }
  
  bool get isEmpty => _items.isEmpty;
  int get size => _items.length;
  
  @override
  String toString() => 'Stack: $_items';
}

void main() {
  var intStack = Stack<int>();
  intStack.push(1);
  intStack.push(2);
  intStack.push(3);
  
  print(intStack);           // Stack: [1, 2, 3]
  print(intStack.pop());     // 3
  print(intStack.peek());    // 2
  
  var stringStack = Stack<String>();
  stringStack.push('مرحباً');
  stringStack.push('العالم');
  print(stringStack);
}
```

## Generic Methods

### دوال عامة

```dart
// دالة عامة تعيد آخر عنصر
T? getLast<T>(List<T> list) {
  if (list.isEmpty) return null;
  return list.last;
}

// دالة عامة تعكس القائمة
List<T> reverse<T>(List<T> list) {
  return list.reversed.toList();
}

// دالة عامة للبحث
int? findIndex<T>(List<T> list, T item) {
  for (int i = 0; i < list.length; i++) {
    if (list[i] == item) return i;
  }
  return null;
}

void main() {
  print(getLast<int>([1, 2, 3]));          // 3
  print(getLast<String>(['أ', 'ب', 'ج']));  // ج
  
  print(reverse([1, 2, 3]));                // [3, 2, 1]
  print(reverse(['أحمد', 'محمد', 'علي'])); // [علي, محمد, أحمد]
  
  print(findIndex([10, 20, 30], 20));       // 1
}
```

### دالة swap عامة

```dart
class Swapper {
  static Pair<B, A> swap<A, B>(Pair<A, B> pair) {
    return Pair(pair.value, pair.key);
  }
}

class Pair<T, U> {
  final T key;
  final U value;
  
  Pair(this.key, this.value);
  
  @override
  String toString() => '($key, $value)';
}

void main() {
  var original = Pair<String, int>('عمر', 25);
  var swapped = Swapper.swap(original);
  
  print('الأصلي: $original');      // (عمر, 25)
  print('المبدل: $swapped');       // (25, عمر)
}
```

## Generic Constraints (القيود)

### extends للقيود

```dart
// T يجب أن يكون Comparable
T findMax<T extends Comparable<T>>(List<T> list) {
  if (list.isEmpty) throw Exception('القائمة فارغة');
  
  T max = list.first;
  for (var item in list) {
    if (item.compareTo(max) > 0) {
      max = item;
    }
  }
  return max;
}

void main() {
  print(findMax([1, 5, 3, 9, 2]));           // 9
  print(findMax(['أحمد', 'محمد', 'علي']));   // محمد
  print(findMax([3.14, 2.71, 1.41]));        // 3.14
  
  // findMax([true, false]);  // خطأ! bool ليس Comparable
}
```

### قيود متعددة

```dart
abstract class Printable {
  void printInfo();
}

abstract class Comparable<T> {
  int compareTo(T other);
}

class Person implements Printable {
  String name;
  int age;
  
  Person(this.name, this.age);
  
  @override
  void printInfo() {
    print('$name - $age سنة');
  }
}

// T يجب أن يكون Printable
void printAll<T extends Printable>(List<T> items) {
  for (var item in items) {
    item.printInfo();
  }
}

void main() {
  var people = [
    Person('أحمد', 25),
    Person('محمد', 30),
    Person('علي', 22),
  ];
  
  printAll(people);
}
```

## Generic Collections

### List, Set, Map مع Generics

```dart
void main() {
  // List
  List<int> numbers = [1, 2, 3];
  List<String> names = ['أحمد', 'محمد'];
  
  // Set
  Set<String> uniqueNames = {'أحمد', 'محمد', 'أحمد'};
  print(uniqueNames);  // {أحمد, محمد}
  
  // Map
  Map<String, int> ages = {
    'أحمد': 25,
    'محمد': 30,
  };
  
  // Nested Generics
  List<Map<String, dynamic>> users = [
    {'name': 'أحمد', 'age': 25},
    {'name': 'محمد', 'age': 30},
  ];
}
```

## أمثلة عملية شاملة

### مثال 1: نظام Cache عام

```dart
class Cache<K, V> {
  final Map<K, V> _storage = {};
  final int maxSize;
  final List<K> _accessOrder = [];
  
  Cache({this.maxSize = 100});
  
  void put(K key, V value) {
    // إذا وصلنا للحد الأقصى، احذف الأقدم
    if (_storage.length >= maxSize && !_storage.containsKey(key)) {
      K oldestKey = _accessOrder.removeAt(0);
      _storage.remove(oldestKey);
    }
    
    _storage[key] = value;
    
    // تحديث ترتيب الوصول
    _accessOrder.remove(key);
    _accessOrder.add(key);
  }
  
  V? get(K key) {
    if (!_storage.containsKey(key)) return null;
    
    // تحديث ترتيب الوصول
    _accessOrder.remove(key);
    _accessOrder.add(key);
    
    return _storage[key];
  }
  
  bool containsKey(K key) => _storage.containsKey(key);
  
  void clear() {
    _storage.clear();
    _accessOrder.clear();
  }
  
  int get size => _storage.length;
  
  void printStats() {
    print('\n--- إحصائيات Cache ---');
    print('الحجم الحالي: $size/$maxSize');
    print('المفاتيح: ${_storage.keys.toList()}');
  }
}

void main() {
  // Cache للنصوص
  var stringCache = Cache<String, String>(maxSize: 3);
  stringCache.put('user1', 'أحمد');
  stringCache.put('user2', 'محمد');
  stringCache.put('user3', 'علي');
  
  print(stringCache.get('user1'));  // أحمد
  
  stringCache.put('user4', 'فاطمة');  // سيحذف user2 (الأقدم)
  stringCache.printStats();
  
  // Cache للأرقام
  var numberCache = Cache<int, double>(maxSize: 5);
  numberCache.put(1, 3.14);
  numberCache.put(2, 2.71);
  numberCache.printStats();
}
```

### مثال 2: Repository Pattern عام

```dart
abstract class Entity {
  int get id;
}

class User implements Entity {
  @override
  final int id;
  final String name;
  final String email;
  
  User(this.id, this.name, this.email);
  
  @override
  String toString() => 'User($id): $name';
}

class Product implements Entity {
  @override
  final int id;
  final String name;
  final double price;
  
  Product(this.id, this.name, this.price);
  
  @override
  String toString() => 'Product($id): $name - $price';
}

class Repository<T extends Entity> {
  final Map<int, T> _storage = {};
  
  void add(T entity) {
    _storage[entity.id] = entity;
    print('تمت إضافة: $entity');
  }
  
  T? getById(int id) {
    return _storage[id];
  }
  
  List<T> getAll() {
    return _storage.values.toList();
  }
  
  bool delete(int id) {
    if (_storage.containsKey(id)) {
      var entity = _storage.remove(id);
      print('تم حذف: $entity');
      return true;
    }
    return false;
  }
  
  void update(T entity) {
    if (_storage.containsKey(entity.id)) {
      _storage[entity.id] = entity;
      print('تم تحديث: $entity');
    }
  }
  
  int get count => _storage.length;
}

void main() {
  // Repository للمستخدمين
  var userRepo = Repository<User>();
  userRepo.add(User(1, 'أحمد', 'ahmed@example.com'));
  userRepo.add(User(2, 'محمد', 'mohamed@example.com'));
  
  print('\nجميع المستخدمين:');
  userRepo.getAll().forEach(print);
  
  // Repository للمنتجات
  var productRepo = Repository<Product>();
  productRepo.add(Product(1, 'لابتوب', 5000));
  productRepo.add(Product(2, 'ماوس', 50));
  
  print('\nجميع المنتجات:');
  productRepo.getAll().forEach(print);
  
  print('\nعدد المستخدمين: ${userRepo.count}');
  print('عدد المنتجات: ${productRepo.count}');
}
```

### مثال 3: Result Type Pattern

```dart
class Result<T, E> {
  final T? _value;
  final E? _error;
  final bool isSuccess;
  
  Result.success(T value)
      : _value = value,
        _error = null,
        isSuccess = true;
  
  Result.failure(E error)
      : _value = null,
        _error = error,
        isSuccess = false;
  
  T get value {
    if (!isSuccess) throw Exception('Result has no value');
    return _value as T;
  }
  
  E get error {
    if (isSuccess) throw Exception('Result has no error');
    return _error as E;
  }
  
  R when<R>({
    required R Function(T value) success,
    required R Function(E error) failure,
  }) {
    return isSuccess ? success(value) : failure(error);
  }
  
  Result<U, E> map<U>(U Function(T value) transform) {
    return isSuccess
        ? Result.success(transform(value))
        : Result.failure(error);
  }
}

// استخدام في عمليات قد تفشل
Result<int, String> divide(int a, int b) {
  if (b == 0) {
    return Result.failure('لا يمكن القسمة على صفر');
  }
  return Result.success(a ~/ b);
}

Result<User, String> findUser(int id) {
  // محاكاة قاعدة بيانات
  var users = {
    1: User(1, 'أحمد', 'ahmed@example.com'),
    2: User(2, 'محمد', 'mohamed@example.com'),
  };
  
  if (users.containsKey(id)) {
    return Result.success(users[id]!);
  }
  return Result.failure('المستخدم غير موجود');
}

void main() {
  // مثال 1: القسمة
  var result1 = divide(10, 2);
  result1.when(
    success: (value) => print('النتيجة: $value'),
    failure: (error) => print('خطأ: $error'),
  );
  
  var result2 = divide(10, 0);
  result2.when(
    success: (value) => print('النتيجة: $value'),
    failure: (error) => print('خطأ: $error'),
  );
  
  // مثال 2: البحث عن مستخدم
  var userResult = findUser(1);
  if (userResult.isSuccess) {
    print('\nتم العثور على: ${userResult.value}');
  } else {
    print('\nخطأ: ${userResult.error}');
  }
  
  // استخدام map للتحويل
  var emailResult = findUser(1).map((user) => user.email);
  emailResult.when(
    success: (email) => print('البريد: $email'),
    failure: (error) => print('خطأ: $error'),
  );
}
```

### مثال 4: Observable Pattern

```dart
class Observable<T> {
  T _value;
  final List<void Function(T)> _listeners = [];
  
  Observable(this._value);
  
  T get value => _value;
  
  set value(T newValue) {
    if (_value != newValue) {
      _value = newValue;
      _notifyListeners();
    }
  }
  
  void addListener(void Function(T) listener) {
    _listeners.add(listener);
  }
  
  void removeListener(void Function(T) listener) {
    _listeners.remove(listener);
  }
  
  void _notifyListeners() {
    for (var listener in _listeners) {
      listener(_value);
    }
  }
  
  void dispose() {
    _listeners.clear();
  }
}

void main() {
  // Observable للعداد
  var counter = Observable<int>(0);
  
  // إضافة مستمعين
  counter.addListener((value) {
    print('المستمع 1: العداد الآن = $value');
  });
  
  counter.addListener((value) {
    if (value % 2 == 0) {
      print('المستمع 2: العدد زوجي!');
    }
  });
  
  // تغيير القيمة
  print('تغيير القيمة إلى 1:');
  counter.value = 1;
  
  print('\nتغيير القيمة إلى 2:');
  counter.value = 2;
  
  print('\nتغيير القيمة إلى 5:');
  counter.value = 5;
  
  // Observable للنصوص
  var username = Observable<String>('guest');
  username.addListener((name) {
    print('اسم المستخدم تغير إلى: $name');
  });
  
  print('\nتسجيل دخول:');
  username.value = 'أحمد';
}
```

## أفضل الممارسات

1. **استخدم Generics لتجنب التكرار**: بدلاً من إنشاء أصناف مشابهة
2. **سمّ معاملات النوع بوضوح**: استخدم `T`, `K`, `V` أو أسماء واضحة
3. **أضف قيوداً عند الحاجة**: للحصول على وظائف محددة
4. **استنتاج تلقائي للنوع**: اترك Dart يستنتج عندما يكون واضحاً
5. **استخدم Generics مع Collections**: للأمان من الأخطاء
6. **وثّق معاملات النوع**: اشرح ما هو المتوقع
7. **تجنب الإفراط في التعقيد**: لا تستخدم generics إذا لم تحتجها

## الأخطاء الشائعة

```dart
// ❌ نسيان تحديد النوع
var list = [];  // List<dynamic>
list.add(1);
list.add('text');  // مسموح لكن خطر

// ✅ تحديد النوع
var list = <int>[];
// list.add('text');  // خطأ!

// ❌ استخدام dynamic بدون داعٍ
class Box {
  dynamic value;
  Box(this.value);
}

// ✅ استخدام Generics
class Box<T> {
  T value;
  Box(this.value);
}
```

---

[⬅️ الموضوع السابق: البرمجة غير المتزامنة](12_async.md) | [العودة للفهرس](README.md) | [الموضوع التالي: المكتبات والحزم ➡️](14_libraries.md)
