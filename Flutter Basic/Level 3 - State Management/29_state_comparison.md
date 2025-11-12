# 29 - مقارنة طرق إدارة الحالة

## 📋 المحتويات

- [المقدمة](#المقدمة)
- [جدول المقارنة](#جدول-المقارنة)
- [متى تستخدم كل طريقة](#متى-تستخدم-كل-طريقة)
- [معايير الاختيار](#معايير-الاختيار)
- [أمثلة واقعية](#أمثلة-واقعية)

---

## 🎯 المقدمة

اختيار طريقة إدارة الحالة المناسبة يعتمد على حجم المشروع، تعقيده، وخبرة الفريق.

---

## 📊 جدول المقارنة

| الطريقة | الصعوبة | الأداء | حجم الكود | منحنى التعلم | مناسب لـ |
|---------|---------|--------|-----------|--------------|----------|
| **setState** | ⭐ | ⭐⭐⭐⭐⭐ | قليل | سهل جداً | تطبيقات صغيرة |
| **InheritedWidget** | ⭐⭐ | ⭐⭐⭐⭐ | متوسط | متوسط | مشاركة بيانات بسيطة |
| **Provider** | ⭐⭐ | ⭐⭐⭐⭐ | متوسط | سهل | معظم التطبيقات |
| **Riverpod** | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ | متوسط | متوسط | تطبيقات متوسطة-كبيرة |
| **BLoC** | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | كبير | صعب | تطبيقات كبيرة ومعقدة |
| **GetX** | ⭐⭐ | ⭐⭐⭐⭐ | قليل | سهل | تطبيقات سريعة |
| **MobX** | ⭐⭐⭐ | ⭐⭐⭐⭐ | متوسط | متوسط | برمجة تفاعلية |
| **Redux** | ⭐⭐⭐⭐ | ⭐⭐⭐ | كبير | صعب | تطبيقات معقدة جداً |

---

## 🎯 متى تستخدم كل طريقة

### setState

**استخدمه عندما:**

- ✅ حالة محلية بسيطة داخل Widget واحد
- ✅ تطبيق صغير أو نموذج أولي
- ✅ تفاعلات UI بسيطة (counter, toggle)

**لا تستخدمه عندما:**

- ❌ تحتاج مشاركة حالة بين Widgets متعددة
- ❌ منطق معقد للحالة
- ❌ عمليات غير متزامنة متعددة

**مثال:**

```dart
class SimpleCounter extends StatefulWidget {
  @override
  State<SimpleCounter> createState() => _SimpleCounterState();
}

class _SimpleCounterState extends State<SimpleCounter> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('$count'),
        ElevatedButton(
          onPressed: () => setState(() => count++),
          child: Text('زيادة'),
        ),
      ],
    );
  }
}
```

---

### InheritedWidget

**استخدمه عندما:**

- ✅ تحتاج مشاركة بيانات في شجرة Widget
- ✅ فهم عميق لآلية عمل Flutter
- ✅ بناء حلول مخصصة

**لا تستخدمه عندما:**

- ❌ تحتاج حل سريع وجاهز
- ❌ فريق مبتدئ
- ❌ تريد أدوات إضافية (DevTools)

**مثال:**

```dart
class ThemeProvider extends InheritedWidget {
  final ThemeData theme;

  const ThemeProvider({
    required this.theme,
    required super.child,
  });

  static ThemeProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ThemeProvider>();
  }

  @override
  bool updateShouldNotify(ThemeProvider oldWidget) {
    return theme != oldWidget.theme;
  }
}
```

---

### Provider

**استخدمه عندما:**

- ✅ توصية Google الرسمية
- ✅ تطبيق متوسط الحجم
- ✅ فريق مبتدئ-متوسط
- ✅ تحتاج DevTools support

**لا تستخدمه عندما:**

- ❌ تحتاج type safety كامل
- ❌ تطبيق معقد جداً
- ❌ BuildContext يسبب مشاكل

**مثال:**

```dart
class CartModel extends ChangeNotifier {
  final List<Item> _items = [];

  List<Item> get items => _items;

  void add(Item item) {
    _items.add(item);
    notifyListeners();
  }
}

// في الـ UI
Consumer<CartModel>(
  builder: (context, cart, child) {
    return Text('${cart.items.length}');
  },
)
```

---

### Riverpod

**استخدمه عندما:**

- ✅ تريد تحسين Provider
- ✅ type safety مهم
- ✅ لا تريد الاعتماد على BuildContext
- ✅ testing سهل

**لا تستخدمه عندما:**

- ❌ فريق مبتدئ تماماً
- ❌ تطبيق بسيط جداً
- ❌ وقت محدود للتعلم

**مثال:**

```dart
final counterProvider = StateProvider<int>((ref) => 0);

// في الـ UI
Consumer(
  builder: (context, ref, child) {
    final count = ref.watch(counterProvider);
    return Text('$count');
  },
)
```

---

### BLoC

**استخدمه عندما:**

- ✅ تطبيق كبير ومعقد
- ✅ فريق كبير
- ✅ فصل كامل بين UI و Business Logic
- ✅ testing شامل مطلوب
- ✅ patterns واضحة مطلوبة

**لا تستخدمه عندما:**

- ❌ تطبيق صغير
- ❌ فريق مبتدئ
- ❌ تطوير سريع مطلوب
- ❌ الكثير من Boilerplate غير مقبول

**مثال:**

```dart
class CounterBloc extends Bloc<CounterEvent, int> {
  CounterBloc() : super(0) {
    on<IncrementPressed>((event, emit) => emit(state + 1));
    on<DecrementPressed>((event, emit) => emit(state - 1));
  }
}

// في الـ UI
BlocBuilder<CounterBloc, int>(
  builder: (context, count) {
    return Text('$count');
  },
)
```

---

### GetX

**استخدمه عندما:**

- ✅ تطوير سريع
- ✅ حل شامل (State + Routing + DI)
- ✅ كود قليل
- ✅ فريق صغير

**لا تستخدمه عندما:**

- ❌ تحتاج patterns قياسية
- ❌ فريق كبير مع معايير صارمة
- ❌ قلق من الاعتماد على مكتبة واحدة
- ❌ تطبيق يحتاج صيانة طويلة المدى

**مثال:**

```dart
class CounterController extends GetxController {
  var count = 0.obs;
  
  void increment() => count++;
}

// في الـ UI
Obx(() => Text('${controller.count}'))
```

---

### MobX

**استخدمه عندما:**

- ✅ تفضل البرمجة التفاعلية
- ✅ خبرة مع MobX من React
- ✅ Observables و Computed مناسبة لحالتك
- ✅ code generation مقبول

**لا تستخدمه عندما:**

- ❌ لا تريد code generation
- ❌ فريق غير معتاد على Reactive Programming
- ❌ تحتاج حل أبسط

**مثال:**

```dart
class CounterStore = _CounterStore with _$CounterStore;

abstract class _CounterStore with Store {
  @observable
  int count = 0;

  @action
  void increment() => count++;
}

// في الـ UI
Observer(
  builder: (_) => Text('${store.count}'),
)
```

---

### Redux

**استخدمه عندما:**

- ✅ خبرة مع Redux من React
- ✅ تحتاج Predictable State
- ✅ Time Travel Debugging مهم
- ✅ تطبيق معقد جداً

**لا تستخدمه عندما:**

- ❌ تطبيق بسيط-متوسط
- ❌ فريق مبتدئ
- ❌ الكثير من Boilerplate غير مقبول
- ❌ تطوير سريع مطلوب

**مثال:**

```dart
// Reducer
int counterReducer(int state, dynamic action) {
  if (action == IncrementAction) return state + 1;
  return state;
}

// في الـ UI
StoreConnector<int, int>(
  converter: (store) => store.state,
  builder: (context, count) => Text('$count'),
)
```

---

## 📏 معايير الاختيار

### حسب حجم المشروع

**صغير (< 10 screens):**

1. setState
2. Provider
3. GetX

**متوسط (10-50 screens):**

1. Provider
2. Riverpod
3. GetX

**كبير (> 50 screens):**

1. BLoC
2. Riverpod
3. Redux

---

### حسب تعقيد الحالة

**بسيط:**

- setState
- Provider

**متوسط:**

- Provider
- Riverpod
- GetX

**معقد:**

- BLoC
- Redux
- Riverpod

---

### حسب خبرة الفريق

**مبتدئ:**

1. setState
2. Provider
3. GetX

**متوسط:**

1. Provider
2. Riverpod
3. BLoC

**متقدم:**

1. BLoC
2. Redux
3. Riverpod
4. أي طريقة مناسبة

---

## 🏢 أمثلة واقعية

### تطبيق To-Do بسيط

**الأفضل:** Provider أو setState

```dart
// باستخدام Provider
class TodoModel extends ChangeNotifier {
  List<String> _todos = [];

  void add(String todo) {
    _todos.add(todo);
    notifyListeners();
  }
}
```

---

### تطبيق تجارة إلكترونية

**الأفضل:** BLoC أو Riverpod

```dart
// باستخدام BLoC
class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc() : super(ProductInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<AddToCart>(_onAddToCart);
  }

  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      final products = await repository.getProducts();
      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }
}
```

---

### تطبيق اجتماعي

**الأفضل:** BLoC أو Redux

```dart
// باستخدام Redux
class AppState {
  final AuthState auth;
  final FeedState feed;
  final ProfileState profile;

  AppState({
    required this.auth,
    required this.feed,
    required this.profile,
  });
}

AppState appReducer(AppState state, dynamic action) {
  return AppState(
    auth: authReducer(state.auth, action),
    feed: feedReducer(state.feed, action),
    profile: profileReducer(state.profile, action),
  );
}
```

---

### تطبيق بسيط لعرض معلومات

**الأفضل:** setState أو Provider

```dart
// باستخدام setState
class InfoScreen extends StatefulWidget {
  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  String selectedTab = 'home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildContent(),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) => setState(() {
          selectedTab = ['home', 'settings'][index];
        }),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'الإعدادات',
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    switch (selectedTab) {
      case 'home':
        return HomeTab();
      case 'settings':
        return SettingsTab();
      default:
        return Container();
    }
  }
}
```

---

## 📊 ملخص التوصيات

| السيناريو | الحل الموصى به | البديل |
|-----------|-----------------|---------|
| تطبيق تعليمي | Provider | setState |
| MVP / Prototype | GetX | Provider |
| Startup Product | Riverpod | Provider |
| Enterprise App | BLoC | Redux |
| حالة محلية بسيطة | setState | - |
| مشاركة Theme/Config | InheritedWidget | Provider |
| Testing مهم جداً | BLoC | Riverpod |
| فريق مبتدئ | Provider | GetX |
| فريق متقدم | BLoC | Riverpod |
| تطوير سريع | GetX | Provider |

---

## 💡 نصائح عامة

- ✅ ابدأ بسيط (setState أو Provider) ثم انتقل للأعقد إذا احتجت
- ✅ لا تستخدم حل معقد لمشكلة بسيطة
- ✅ اختر حسب حجم الفريق وخبرتهم
- ✅ يمكن استخدام أكثر من طريقة في نفس التطبيق
- ✅ Provider خيار آمن لمعظم الحالات
- ✅ BLoC للمشاريع الكبيرة والمعقدة
- ✅ GetX للتطوير السريع والبسيط
- ✅ Riverpod للمشاريع الحديثة والمتوسطة

---

[⬅️ السابق: Redux](28_redux.md)
[🏠 العودة للفهرس](../README.md)
[التالي: أنماط State ➡️](30_state_patterns.md)
