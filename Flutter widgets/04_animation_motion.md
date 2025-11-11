# Animation and Motion - الحركة والرسوم المتحركة

[← العودة للفهرس الرئيسي](README.md)

## 📋 المحتويات

- [نظرة عامة](#نظرة-عامة)
- [أنواع الرسوم المتحركة](#أنواع-الرسوم-المتحركة)
- [Implicit Animations](#implicit-animations)
- [Explicit Animations](#explicit-animations)
- [Hero Animations](#hero-animations)
- [Custom Animations](#custom-animations)
- [أمثلة متقدمة](#أمثلة-متقدمة)
- [أفضل الممارسات](#أفضل-الممارسات)
- [المراجع](#المراجع)

---

## نظرة عامة

الرسوم المتحركة في Flutter تُحسّن تجربة المستخدم بشكل كبير من خلال:
- ✨ **التغذية الراجعة البصرية**: إعلام المستخدم بالتغييرات
- 🎯 **توجيه الانتباه**: لفت النظر للعناصر المهمة
- 🔄 **الاستمرارية**: ربط الحالات المختلفة بسلاسة
- 🎨 **الجمالية**: إضافة حيوية وجاذبية للتطبيق

---

## أنواع الرسوم المتحركة

### 1. Implicit Animations (الضمنية)
رسوم متحركة بسيطة تحدث تلقائياً عند تغيير القيم.

### 2. Explicit Animations (الصريحة)
رسوم متحركة متقدمة تمنحك تحكماً كاملاً.

### 3. Hero Animations (البطولية)
انتقالات سلسة بين الشاشات.

### 4. Physics-based Animations (فيزيائية)
رسوم متحركة تحاكي القوانين الفيزيائية.

---

## Implicit Animations

### 1. AnimatedContainer

أكثر الويدجت استخداماً للرسوم المتحركة الضمنية.

```dart
class AnimatedContainerExample extends StatefulWidget {
  @override
  _AnimatedContainerExampleState createState() => _AnimatedContainerExampleState();
}

class _AnimatedContainerExampleState extends State<AnimatedContainerExample> {
  bool isExpanded = false;
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
        });
      },
      child: AnimatedContainer(
        // المدة الزمنية
        duration: Duration(milliseconds: 300),
        
        // منحنى الحركة
        curve: Curves.easeInOut,
        
        // الأبعاد
        width: isExpanded ? 300 : 100,
        height: isExpanded ? 300 : 100,
        
        // اللون
        decoration: BoxDecoration(
          color: isExpanded ? Colors.blue : Colors.red,
          borderRadius: BorderRadius.circular(isExpanded ? 50 : 10),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: isExpanded ? 20 : 5,
              offset: Offset(0, isExpanded ? 10 : 5),
            ),
          ],
        ),
        
        // المحاذاة
        alignment: isExpanded ? Alignment.center : Alignment.topLeft,
        
        // الحشو
        padding: EdgeInsets.all(isExpanded ? 20 : 10),
        
        child: Icon(
          isExpanded ? Icons.fullscreen_exit : Icons.fullscreen,
          color: Colors.white,
        ),
        
        // استدعاء عند انتهاء الحركة
        onEnd: () {
          print('Animation completed!');
        },
      ),
    );
  }
}
```

### 2. AnimatedOpacity

تحريك الشفافية.

```dart
class FadeInExample extends StatefulWidget {
  @override
  _FadeInExampleState createState() => _FadeInExampleState();
}

class _FadeInExampleState extends State<FadeInExample> {
  bool isVisible = false;
  
  @override
  void initState() {
    super.initState();
    // إظهار العنصر بعد ثانية
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        isVisible = true;
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isVisible ? 1.0 : 0.0,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeIn,
      child: Container(
        width: 200,
        height: 200,
        color: Colors.blue,
        child: Center(
          child: Text(
            'مرحباً!',
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
        ),
      ),
    );
  }
}
```

### 3. AnimatedPositioned

تحريك موضع العنصر داخل Stack.

```dart
class AnimatedPositionedExample extends StatefulWidget {
  @override
  _AnimatedPositionedExampleState createState() => _AnimatedPositionedExampleState();
}

class _AnimatedPositionedExampleState extends State<AnimatedPositionedExample> {
  bool isTop = true;
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedPositioned(
          duration: Duration(milliseconds: 500),
          curve: Curves.bounceOut,
          
          // الموضع
          top: isTop ? 50 : 300,
          left: isTop ? 50 : 200,
          
          child: GestureDetector(
            onTap: () {
              setState(() {
                isTop = !isTop;
              });
            },
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(Icons.touch_app, color: Colors.white, size: 40),
            ),
          ),
        ),
      ],
    );
  }
}
```

### 4. AnimatedAlign

تحريك محاذاة العنصر.

```dart
class AnimatedAlignExample extends StatefulWidget {
  @override
  _AnimatedAlignExampleState createState() => _AnimatedAlignExampleState();
}

class _AnimatedAlignExampleState extends State<AnimatedAlignExample> {
  Alignment alignment = Alignment.topLeft;
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          alignment = alignment == Alignment.topLeft 
              ? Alignment.bottomRight 
              : Alignment.topLeft;
        });
      },
      child: Container(
        color: Colors.grey[200],
        child: AnimatedAlign(
          alignment: alignment,
          duration: Duration(milliseconds: 600),
          curve: Curves.elasticOut,
          child: Container(
            width: 50,
            height: 50,
            color: Colors.green,
          ),
        ),
      ),
    );
  }
}
```

### 5. AnimatedCrossFade

التبديل بين ويدجت بحركة تلاشي.

```dart
class AnimatedCrossFadeExample extends StatefulWidget {
  @override
  _AnimatedCrossFadeExampleState createState() => _AnimatedCrossFadeExampleState();
}

class _AnimatedCrossFadeExampleState extends State<AnimatedCrossFadeExample> {
  bool showFirst = true;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedCrossFade(
          firstChild: Container(
            width: 200,
            height: 200,
            color: Colors.blue,
            child: Center(
              child: Icon(Icons.brightness_5, size: 80, color: Colors.white),
            ),
          ),
          secondChild: Container(
            width: 200,
            height: 200,
            color: Colors.indigo,
            child: Center(
              child: Icon(Icons.brightness_2, size: 80, color: Colors.white),
            ),
          ),
          crossFadeState: showFirst 
              ? CrossFadeState.showFirst 
              : CrossFadeState.showSecond,
          duration: Duration(milliseconds: 500),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            setState(() {
              showFirst = !showFirst;
            });
          },
          child: Text('تبديل'),
        ),
      ],
    );
  }
}
```

### 6. AnimatedDefaultTextStyle

تحريك نمط النص.

```dart
class AnimatedTextStyleExample extends StatefulWidget {
  @override
  _AnimatedTextStyleExampleState createState() => _AnimatedTextStyleExampleState();
}

class _AnimatedTextStyleExampleState extends State<AnimatedTextStyleExample> {
  bool isLarge = false;
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isLarge = !isLarge;
        });
      },
      child: AnimatedDefaultTextStyle(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        style: TextStyle(
          fontSize: isLarge ? 48 : 24,
          fontWeight: isLarge ? FontWeight.bold : FontWeight.normal,
          color: isLarge ? Colors.red : Colors.blue,
        ),
        child: Text('انقر لتغيير النمط'),
      ),
    );
  }
}
```

### 7. AnimatedPadding

تحريك الحشو.

```dart
AnimatedPadding(
  padding: EdgeInsets.all(isExpanded ? 40 : 10),
  duration: Duration(milliseconds: 300),
  curve: Curves.easeInOut,
  child: Container(
    color: Colors.teal,
    child: Text('محتوى'),
  ),
)
```

### 8. AnimatedPhysicalModel

تحريك الارتفاع والظل.

```dart
AnimatedPhysicalModel(
  duration: Duration(milliseconds: 500),
  curve: Curves.easeInOut,
  elevation: isElevated ? 20 : 0,
  shape: BoxShape.rectangle,
  shadowColor: Colors.black,
  color: Colors.white,
  borderRadius: BorderRadius.circular(isElevated ? 20 : 0),
  child: Container(
    width: 200,
    height: 200,
    child: Center(child: Text('محتوى')),
  ),
)
```

---

## Explicit Animations

### 1. AnimationController

المتحكم الأساسي في الرسوم المتحركة الصريحة.

```dart
class ExplicitAnimationExample extends StatefulWidget {
  @override
  _ExplicitAnimationExampleState createState() => _ExplicitAnimationExampleState();
}

class _ExplicitAnimationExampleState extends State<ExplicitAnimationExample> 
    with SingleTickerProviderStateMixin {
  
  late AnimationController _controller;
  late Animation<double> _animation;
  
  @override
  void initState() {
    super.initState();
    
    // إنشاء المتحكم
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    
    // إنشاء Tween
    _animation = Tween<double>(
      begin: 0,
      end: 300,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );
    
    // الاستماع للتغييرات
    _animation.addListener(() {
      setState(() {});
    });
    
    // الاستماع للحالة
    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        print('Animation completed!');
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
    return Column(
      children: [
        Container(
          width: _animation.value,
          height: _animation.value,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(_animation.value / 2),
          ),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _controller.forward(),
              child: Text('تشغيل'),
            ),
            SizedBox(width: 10),
            ElevatedButton(
              onPressed: () => _controller.reverse(),
              child: Text('عكس'),
            ),
            SizedBox(width: 10),
            ElevatedButton(
              onPressed: () => _controller.repeat(),
              child: Text('تكرار'),
            ),
            SizedBox(width: 10),
            ElevatedButton(
              onPressed: () => _controller.reset(),
              child: Text('إعادة'),
            ),
          ],
        ),
      ],
    );
  }
}
```

### 2. Tween Animations

إنشاء رسوم متحركة مخصصة بين قيمتين.

```dart
class TweenAnimationExample extends StatefulWidget {
  @override
  _TweenAnimationExampleState createState() => _TweenAnimationExampleState();
}

class _TweenAnimationExampleState extends State<TweenAnimationExample> 
    with SingleTickerProviderStateMixin {
  
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _sizeAnimation;
  late Animation<double> _rotationAnimation;
  
  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );
    
    // تحريك اللون
    _colorAnimation = ColorTween(
      begin: Colors.red,
      end: Colors.blue,
    ).animate(_controller);
    
    // تحريك الحجم
    _sizeAnimation = Tween<double>(
      begin: 50,
      end: 200,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    
    // تحريك الدوران
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 2 * 3.14159, // دورة كاملة
    ).animate(_controller);
    
    _controller.addListener(() {
      setState(() {});
    });
    
    _controller.repeat(reverse: true);
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: _rotationAnimation.value,
      child: Container(
        width: _sizeAnimation.value,
        height: _sizeAnimation.value,
        decoration: BoxDecoration(
          color: _colorAnimation.value,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
```

### 3. AnimatedBuilder

بناء واجهة بناءً على التحريك دون الحاجة لاستدعاء setState.

```dart
class AnimatedBuilderExample extends StatefulWidget {
  @override
  _AnimatedBuilderExampleState createState() => _AnimatedBuilderExampleState();
}

class _AnimatedBuilderExampleState extends State<AnimatedBuilderExample> 
    with SingleTickerProviderStateMixin {
  
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  
  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );
    
    _controller.repeat(reverse: true);
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        );
      },
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.purple,
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.favorite, color: Colors.white, size: 40),
      ),
    );
  }
}
```

### 4. TweenAnimationBuilder

رسوم متحركة بسيطة بدون AnimationController.

```dart
class TweenAnimationBuilderExample extends StatefulWidget {
  @override
  _TweenAnimationBuilderExampleState createState() => _TweenAnimationBuilderExampleState();
}

class _TweenAnimationBuilderExampleState extends State<TweenAnimationBuilderExample> {
  double targetValue = 100;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: targetValue),
          duration: Duration(milliseconds: 500),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return Column(
              children: [
                Container(
                  width: value,
                  height: value,
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(value / 2),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '${value.toInt()}',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            );
          },
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            setState(() {
              targetValue = targetValue == 100 ? 200 : 100;
            });
          },
          child: Text('تغيير الحجم'),
        ),
      ],
    );
  }
}
```

---

## Hero Animations

انتقالات سلسة بين الشاشات.

```dart
// الشاشة الأولى
class FirstScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('الشاشة الأولى')),
      body: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SecondScreen()),
          );
        },
        child: Hero(
          tag: 'imageHero',
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage('https://picsum.photos/200'),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }
}

// الشاشة الثانية
class SecondScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('الشاشة الثانية')),
      body: Center(
        child: Hero(
          tag: 'imageHero', // نفس الـ tag
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage('https://picsum.photos/200'),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
    );
  }
}
```

### Hero مع نص

```dart
Hero(
  tag: 'titleHero',
  child: Material(
    color: Colors.transparent,
    child: Text(
      'عنوان',
      style: TextStyle(
        fontSize: firstScreen ? 24 : 48,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
)
```

---

## Custom Animations

### 1. Staggered Animations (متداخلة)

```dart
class StaggeredAnimationExample extends StatefulWidget {
  @override
  _StaggeredAnimationExampleState createState() => _StaggeredAnimationExampleState();
}

class _StaggeredAnimationExampleState extends State<StaggeredAnimationExample> 
    with SingleTickerProviderStateMixin {
  
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  
  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    
    // الشفافية (0.0 - 0.5)
    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );
    
    // التحجيم (0.5 - 0.8)
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.5, 0.8, curve: Curves.easeOut),
      ),
    );
    
    // الانزلاق (0.8 - 1.0)
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.8, 1.0, curve: Curves.bounceOut),
      ),
    );
    
    _controller.forward();
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: SlideTransition(
              position: _slideAnimation,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    'رسوم متداخلة',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
```

### 2. Physics-based Animations

```dart
class PhysicsAnimationExample extends StatefulWidget {
  @override
  _PhysicsAnimationExampleState createState() => _PhysicsAnimationExampleState();
}

class _PhysicsAnimationExampleState extends State<PhysicsAnimationExample> 
    with SingleTickerProviderStateMixin {
  
  late AnimationController _controller;
  late Animation<double> _animation;
  
  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    
    // محاكاة الجاذبية والارتداد
    _animation = Tween<double>(begin: 0, end: 400).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.bounceOut,
      ),
    );
    
    _controller.addListener(() {
      setState(() {});
    });
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _controller.reset();
        _controller.forward();
      },
      child: Stack(
        children: [
          Positioned(
            top: _animation.value,
            left: 150,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

---

## أمثلة متقدمة

### مثال شامل: بطاقة منتج متحركة

```dart
class AnimatedProductCard extends StatefulWidget {
  @override
  _AnimatedProductCardState createState() => _AnimatedProductCardState();
}

class _AnimatedProductCardState extends State<AnimatedProductCard> 
    with SingleTickerProviderStateMixin {
  
  bool isExpanded = false;
  late AnimationController _controller;
  late Animation<double> _expandAnimation;
  late Animation<double> _fadeAnimation;
  
  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: Duration(milliseconds: 400),
      vsync: this,
    );
    
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.5, 1.0),
      ),
    );
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  void _toggleExpand() {
    setState(() {
      isExpanded = !isExpanded;
      if (isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleExpand,
      child: AnimatedBuilder(
        animation: _expandAnimation,
        builder: (context, child) {
          return Container(
            width: 300,
            height: 150 + (250 * _expandAnimation.value),
            margin: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10 + (10 * _expandAnimation.value),
                  offset: Offset(0, 5 + (5 * _expandAnimation.value)),
                ),
              ],
            ),
            child: Column(
              children: [
                // الصورة
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  child: Image.network(
                    'https://picsum.photos/300/150',
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                
                // المحتوى الأساسي
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'منتج رائع',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'وصف مختصر للمنتج',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                
                // المحتوى الموسع
                if (_expandAnimation.value > 0)
                  Opacity(
                    opacity: _fadeAnimation.value,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Divider(),
                          Text(
                            'تفاصيل إضافية:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text('• مواصفات ممتازة'),
                          Text('• جودة عالية'),
                          Text('• سعر مناسب'),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '\$99.99',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {},
                                child: Text('إضافة للسلة'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
```

---

## أفضل الممارسات

### 1. اختيار النوع المناسب

```dart
// ✅ استخدم Implicit للحالات البسيطة
AnimatedContainer(
  duration: Duration(milliseconds: 300),
  color: isActive ? Colors.blue : Colors.grey,
  child: child,
)

// ✅ استخدم Explicit للتحكم الكامل
AnimationController _controller;
// مع forward(), reverse(), repeat()

// ✅ استخدم TweenAnimationBuilder للحالات المتوسطة
TweenAnimationBuilder<double>(
  tween: Tween(begin: 0, end: 1),
  duration: Duration(seconds: 1),
  builder: (context, value, child) => ...,
)
```

### 2. الأداء

```dart
// ✅ استخدم const للأطفال الثابتة
AnimatedBuilder(
  animation: animation,
  child: const Text('ثابت'), // لن يُعاد بناؤه
  builder: (context, child) {
    return Transform.scale(
      scale: animation.value,
      child: child,
    );
  },
)

// ✅ تخلص من المتحكمات
@override
void dispose() {
  _controller.dispose();
  super.dispose();
}

// ❌ تجنب الرسوم المتحركة الثقيلة
// استخدم RepaintBoundary للعناصر المعقدة
RepaintBoundary(
  child: ComplexWidget(),
)
```

### 3. المدة والمنحنيات

```dart
// ✅ مدد مناسبة
Duration(milliseconds: 200) // للتفاعلات السريعة
Duration(milliseconds: 300) // الأكثر شيوعاً
Duration(milliseconds: 500) // للتحولات الكبيرة

// ✅ منحنيات مناسبة
Curves.easeInOut    // للتحركات العامة
Curves.easeOut      // للعناصر التي تدخل
Curves.easeIn       // للعناصر التي تخرج
Curves.bounceOut    // للارتداد
Curves.elasticOut   // للمرونة
```

### 4. إمكانية الوصول

```dart
// ✅ احترم إعدادات المستخدم
bool reduceAnimations = MediaQuery.of(context).disableAnimations;

Duration animationDuration = reduceAnimations 
    ? Duration.zero 
    : Duration(milliseconds: 300);
```

---

## المراجع

### التوثيق الرسمي

1. **Flutter Animations Documentation**  
   [https://docs.flutter.dev/development/ui/animations](https://docs.flutter.dev/development/ui/animations)

2. **Animations Tutorial**  
   [https://docs.flutter.dev/development/ui/animations/tutorial](https://docs.flutter.dev/development/ui/animations/tutorial)

3. **Animation Class**  
   [https://api.flutter.dev/flutter/animation/Animation-class.html](https://api.flutter.dev/flutter/animation/Animation-class.html)

4. **AnimationController Class**  
   [https://api.flutter.dev/flutter/animation/AnimationController-class.html](https://api.flutter.dev/flutter/animation/AnimationController-class.html)

### الدروس والكتب

5. **Implicit Animations Codelab**  
   [https://docs.flutter.dev/codelabs/implicit-animations](https://docs.flutter.dev/codelabs/implicit-animations)

6. **Animation Deep Dive**  
   [https://medium.com/flutter/animation-deep-dive-39d3ffea111f](https://medium.com/flutter/animation-deep-dive-39d3ffea111f)

7. **The Boring Flutter Show - Animations**  
   [https://www.youtube.com/watch?v=yI-8QHpGIP4](https://www.youtube.com/watch?v=yI-8QHpGIP4)

### أدوات ومكتبات

8. **Lottie Animations**  
   [https://pub.dev/packages/lottie](https://pub.dev/packages/lottie)

9. **Rive (formerly Flare)**  
   [https://rive.app/](https://rive.app/)

10. **Animations Package**  
    [https://pub.dev/packages/animations](https://pub.dev/packages/animations)

11. **Flutter Animate**  
    [https://pub.dev/packages/flutter_animate](https://pub.dev/packages/flutter_animate)

### مراجع متقدمة

12. **Material Motion Guidelines**  
    [https://m3.material.io/styles/motion/overview](https://m3.material.io/styles/motion/overview)

13. **Curves Class - All Curves**  
    [https://api.flutter.dev/flutter/animation/Curves-class.html](https://api.flutter.dev/flutter/animation/Curves-class.html)

---

[← العودة للفهرس الرئيسي](README.md)
[السابق: Accessibility](03_accessibility.md)
[التالي: Assets, Images, and Icons →](05_assets_images_icons.md)

---

**آخر تحديث:** نوفمبر 2025  
**مستوى:** متقدم - احترافي
