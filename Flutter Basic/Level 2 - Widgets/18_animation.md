# 18 - Animation والحركات المتحركة

## 📋 المحتويات

- [المقدمة](#المقدمة)
- [AnimatedContainer](#animatedcontainer)
- [AnimatedOpacity](#animatedopacity)
- [Hero Animation](#hero-animation)
- [AnimationController](#animationcontroller)
- [أمثلة عملية](#أمثلة-عملية)

---

## 🎯 المقدمة

Animations في Flutter تجعل واجهة المستخدم أكثر جاذبية وسلاسة.

---

## 📦 AnimatedContainer

حاوية تتحرك تلقائياً عند تغيير خصائصها:

```dart
class AnimatedContainerExample extends StatefulWidget {
  const AnimatedContainerExample({super.key});

  @override
  State<AnimatedContainerExample> createState() =>
      _AnimatedContainerExampleState();
}

class _AnimatedContainerExampleState extends State<AnimatedContainerExample> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AnimatedContainer')),
      body: Center(
        child: GestureDetector(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(seconds: 1),
            width: _isExpanded ? 200 : 100,
            height: _isExpanded ? 200 : 100,
            decoration: BoxDecoration(
              color: _isExpanded ? Colors.blue : Colors.red,
              borderRadius: BorderRadius.circular(_isExpanded ? 100 : 20),
            ),
            child: const Center(
              child: Text(
                'اضغط',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
```

### AnimatedContainer متقدم

```dart
class AdvancedAnimatedContainer extends StatefulWidget {
  const AdvancedAnimatedContainer({super.key});

  @override
  State<AdvancedAnimatedContainer> createState() =>
      _AdvancedAnimatedContainerState();
}

class _AdvancedAnimatedContainerState
    extends State<AdvancedAnimatedContainer> {
  double _width = 100;
  double _height = 100;
  Color _color = Colors.blue;
  BorderRadiusGeometry _borderRadius = BorderRadius.circular(8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AnimatedContainer متقدم')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              width: _width,
              height: _height,
              decoration: BoxDecoration(
                color: _color,
                borderRadius: _borderRadius,
                boxShadow: [
                  BoxShadow(
                    color: _color.withOpacity(0.5),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _width = 200;
                      _height = 200;
                    });
                  },
                  child: const Text('تكبير'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _width = 100;
                      _height = 100;
                    });
                  },
                  child: const Text('تصغير'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _color = Colors.red;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text('أحمر'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _color = Colors.blue;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text('أزرق'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _borderRadius = _borderRadius == BorderRadius.circular(8)
                      ? BorderRadius.circular(100)
                      : BorderRadius.circular(8);
                });
              },
              child: const Text('تغيير الشكل'),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 🌟 AnimatedOpacity

تغيير الشفافية بشكل متحرك:

```dart
class AnimatedOpacityExample extends StatefulWidget {
  const AnimatedOpacityExample({super.key});

  @override
  State<AnimatedOpacityExample> createState() =>
      _AnimatedOpacityExampleState();
}

class _AnimatedOpacityExampleState extends State<AnimatedOpacityExample> {
  bool _visible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AnimatedOpacity')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedOpacity(
              opacity: _visible ? 1.0 : 0.0,
              duration: const Duration(seconds: 1),
              child: Container(
                width: 200,
                height: 200,
                color: Colors.blue,
                child: const Center(
                  child: Text(
                    'مرحباً',
                    style: TextStyle(color: Colors.white, fontSize: 30),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _visible = !_visible;
                });
              },
              child: Text(_visible ? 'إخفاء' : 'إظهار'),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 🦸 Hero Animation

حركة انتقالية بين شاشتين:

```dart
// الشاشة الأولى
class HeroFirstScreen extends StatelessWidget {
  const HeroFirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hero Animation')),
      body: Center(
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HeroSecondScreen(),
              ),
            );
          },
          child: Hero(
            tag: 'hero-image',
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Icon(
                Icons.favorite,
                color: Colors.white,
                size: 50,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// الشاشة الثانية
class HeroSecondScreen extends StatelessWidget {
  const HeroSecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('التفاصيل')),
      body: Center(
        child: Hero(
          tag: 'hero-image',
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(150),
            ),
            child: const Icon(
              Icons.favorite,
              color: Colors.white,
              size: 150,
            ),
          ),
        ),
      ),
    );
  }
}
```

---

## ⚙️ AnimationController

تحكم كامل في الحركات:

```dart
class AnimationControllerExample extends StatefulWidget {
  const AnimationControllerExample({super.key});

  @override
  State<AnimationControllerExample> createState() =>
      _AnimationControllerExampleState();
}

class _AnimationControllerExampleState
    extends State<AnimationControllerExample>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 300).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AnimationController')),
      body: Center(
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Container(
              width: _animation.value,
              height: _animation.value,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(_animation.value / 2),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_controller.isAnimating) {
            _controller.stop();
          } else {
            _controller.forward();
          }
        },
        child: Icon(_controller.isAnimating ? Icons.pause : Icons.play_arrow),
      ),
    );
  }
}
```

---

## 💼 أمثلة عملية

### قائمة متحركة

```dart
class AnimatedListExample extends StatefulWidget {
  const AnimatedListExample({super.key});

  @override
  State<AnimatedListExample> createState() => _AnimatedListExampleState();
}

class _AnimatedListExampleState extends State<AnimatedListExample> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final List<String> _items = ['عنصر 1', 'عنصر 2', 'عنصر 3'];

  void _addItem() {
    final newIndex = _items.length;
    _items.add('عنصر ${newIndex + 1}');
    _listKey.currentState?.insertItem(newIndex);
  }

  void _removeItem(int index) {
    final removedItem = _items[index];
    _items.removeAt(index);

    _listKey.currentState?.removeItem(
      index,
      (context, animation) => _buildItem(removedItem, animation),
    );
  }

  Widget _buildItem(String item, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ListTile(
          title: Text(item),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              final index = _items.indexOf(item);
              if (index != -1) {
                _removeItem(index);
              }
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('قائمة متحركة')),
      body: AnimatedList(
        key: _listKey,
        initialItemCount: _items.length,
        itemBuilder: (context, index, animation) {
          return _buildItem(_items[index], animation);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

### بطاقة قابلة للطي

```dart
class ExpandableCard extends StatefulWidget {
  const ExpandableCard({super.key});

  @override
  State<ExpandableCard> createState() => _ExpandableCardState();
}

class _ExpandableCardState extends State<ExpandableCard>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('بطاقة قابلة للطي')),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('معلومات المنتج'),
                trailing: RotationTransition(
                  turns: Tween(begin: 0.0, end: 0.5).animate(_animation),
                  child: const Icon(Icons.expand_more),
                ),
                onTap: _toggleExpanded,
              ),
              SizeTransition(
                sizeFactor: _animation,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('السعر: 299 ريال'),
                      SizedBox(height: 8),
                      Text('التقييم: ⭐⭐⭐⭐⭐'),
                      SizedBox(height: 8),
                      Text('متوفر في المخزون'),
                      SizedBox(height: 8),
                      Text(
                        'وصف المنتج: منتج عالي الجودة مصنوع من أفضل المواد...',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

### تأثير التحميل

```dart
class LoadingAnimation extends StatefulWidget {
  const LoadingAnimation({super.key});

  @override
  State<LoadingAnimation> createState() => _LoadingAnimationState();
}

class _LoadingAnimationState extends State<LoadingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تأثير التحميل')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RotationTransition(
              turns: _controller,
              child: const Icon(
                Icons.refresh,
                size: 100,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 20),
            FadeTransition(
              opacity: Tween<double>(begin: 0.3, end: 1.0).animate(
                CurvedAnimation(
                  parent: _controller,
                  curve: Curves.easeInOut,
                ),
              ),
              child: const Text(
                'جارٍ التحميل...',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

### صفحة انتقالية متحركة

```dart
class PageTransitionExample extends StatelessWidget {
  const PageTransitionExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('انتقال متحرك')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const SecondPage(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      const begin = Offset(1.0, 0.0);
                      const end = Offset.zero;
                      const curve = Curves.easeInOut;

                      var tween = Tween(begin: begin, end: end)
                          .chain(CurveTween(curve: curve));
                      var offsetAnimation = animation.drive(tween);

                      return SlideTransition(
                        position: offsetAnimation,
                        child: child,
                      );
                    },
                  ),
                );
              },
              child: const Text('انتقال منزلق'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const SecondPage(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                    },
                  ),
                );
              },
              child: const Text('انتقال بالتلاشي'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const SecondPage(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return ScaleTransition(
                        scale: animation,
                        child: child,
                      );
                    },
                  ),
                );
              },
              child: const Text('انتقال بالتكبير'),
            ),
          ],
        ),
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الصفحة الثانية')),
      body: const Center(
        child: Text('مرحباً بك في الصفحة الثانية!'),
      ),
    );
  }
}
```

---

## 📚 المراجع والمصادر

1. **Implicit Animations**
   - [AnimatedContainer](https://api.flutter.dev/flutter/widgets/AnimatedContainer-class.html)
   - [AnimatedOpacity](https://api.flutter.dev/flutter/widgets/AnimatedOpacity-class.html)
   - [Implicit Animations](https://docs.flutter.dev/development/ui/animations/implicit-animations)

2. **Hero Animations**
   - [Hero](https://api.flutter.dev/flutter/widgets/Hero-class.html)
   - [Hero Animations Tutorial](https://docs.flutter.dev/development/ui/animations/hero-animations)

3. **Explicit Animations**
   - [AnimationController](https://api.flutter.dev/flutter/animation/AnimationController-class.html)
   - [Tween](https://api.flutter.dev/flutter/animation/Tween-class.html)
   - [Animations Tutorial](https://docs.flutter.dev/development/ui/animations/tutorial)

4. **Advanced**
   - [AnimatedList](https://api.flutter.dev/flutter/widgets/AnimatedList-class.html)
   - [Custom Page Transitions](https://docs.flutter.dev/cookbook/animation/page-route-animation)

---

## 💡 نصائح

- ✅ استخدم Implicit Animations (AnimatedContainer) للحالات البسيطة
- ✅ Explicit Animations (AnimationController) للتحكم الكامل
- ✅ Hero مثالي للانتقالات بين الشاشات
- ✅ استخدم `Curves` لجعل الحركات أكثر طبيعية
- ✅ لا تنسَ `dispose()` للـ AnimationController

---

[⬅️ السابق: Navigation](17_navigation.md)
[🏠 العودة للفهرس](../README.md)
[التالي: Theme ➡️](19_theme.md)
