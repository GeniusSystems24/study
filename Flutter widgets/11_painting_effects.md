# Painting and Effects - الرسم والتأثيرات البصرية

> **المرجع الرسمي:** [Painting and Effects Widgets](https://docs.flutter.dev/ui/widgets/painting)

## 📚 المحتويات

- [مقدمة](#مقدمة)
- [1. Opacity - التحكم في الشفافية](#1-opacity---التحكم-في-الشفافية)
- [2. Clip Widgets - القص والتشذيب](#2-clip-widgets---القص-والتشذيب)
- [3. BackdropFilter - تأثير الضبابية](#3-backdropfilter---تأثير-الضبابية)
- [4. DecoratedBox - الزخرفة والتنسيق](#4-decoratedbox---الزخرفة-والتنسيق)
- [5. Transform - التحويلات الهندسية](#5-transform---التحويلات-الهندسية)
- [6. CustomPaint - الرسم المخصص](#6-custompaint---الرسم-المخصص)
- [7. ShaderMask - تطبيق Shaders](#7-shadermask---تطبيق-shaders)
- [8. ColorFiltered - فلاتر الألوان](#8-colorfiltered---فلاتر-الألوان)
- [9. مثال تطبيقي متكامل](#9-مثال-تطبيقي-متكامل)
- [10. Best Practices](#10-best-practices)
- [المراجع](#المراجع)

---

## مقدمة

ويدجت الرسم والتأثيرات البصرية تسمح لك بتطبيق تحويلات وتأثيرات مرئية على الويدجت **دون تغيير التخطيط أو الحجم**. تُستخدم لإضافة:

- **الشفافية والتلاشي**
- **القص والتشذيب** (Clipping)
- **الظلال والتدرجات**
- **التدوير والتحجيم والإمالة**
- **الرسم المخصص**
- **التأثيرات البصرية المتقدمة**

**الفرق الرئيسي:** هذه الويدجت تؤثر على **المظهر البصري** فقط، بينما ويدجت Layout تؤثر على **الموضع والحجم**.

---

## 1. Opacity - التحكم في الشفافية

### 1.1 المفهوم الأساسي

`Opacity` تتحكم في شفافية الويدجت الابنة.

```dart
Opacity(
  opacity: 0.5, // من 0.0 (شفاف كلياً) إلى 1.0 (معتم كلياً)
  child: Container(
    width: 100,
    height: 100,
    color: Colors.blue,
  ),
)
```

### 1.2 مثال متقدم: تلاشي عند التمرير

```dart
class FadeOnScrollExample extends StatefulWidget {
  @override
  _FadeOnScrollExampleState createState() => _FadeOnScrollExampleState();
}

class _FadeOnScrollExampleState extends State<FadeOnScrollExample> {
  final ScrollController _scrollController = ScrollController();
  double _opacity = 1.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      final offset = _scrollController.offset;
      setState(() {
        // تقليل الشفافية كلما مررنا لأسفل
        _opacity = (1.0 - (offset / 200)).clamp(0.0, 1.0);
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              background: Opacity(
                opacity: _opacity,
                child: Image.network(
                  'https://picsum.photos/400/200',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => ListTile(
                title: Text('عنصر $index'),
              ),
              childCount: 50,
            ),
          ),
        ],
      ),
    );
  }
}
```

### 1.3 AnimatedOpacity - تحريك الشفافية

```dart
class AnimatedOpacityExample extends StatefulWidget {
  @override
  _AnimatedOpacityExampleState createState() => _AnimatedOpacityExampleState();
}

class _AnimatedOpacityExampleState extends State<AnimatedOpacityExample> {
  bool _visible = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedOpacity(
          opacity: _visible ? 1.0 : 0.0,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          child: Container(
            width: 200,
            height: 200,
            color: Colors.blue,
            child: Center(
              child: Text(
                'أنا أختفي وأظهر!',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _visible = !_visible;
            });
          },
          child: Text(_visible ? 'إخفاء' : 'إظهار'),
        ),
      ],
    );
  }
}
```

**⚠️ تحذير الأداء:**
- `Opacity` مكلفة في الأداء لأنها تتطلب offscreen rendering
- استخدم `AnimatedOpacity` بدلاً من `Opacity` داخل `AnimatedBuilder`
- إذا كانت `opacity = 0.0`، استخدم `Visibility(visible: false)` بدلاً منها

---

## 2. Clip Widgets - القص والتشذيب

### 2.1 ClipRRect - قص بحواف دائرية

```dart
ClipRRect(
  borderRadius: BorderRadius.circular(20),
  child: Image.network(
    'https://picsum.photos/300/200',
    width: 300,
    height: 200,
    fit: BoxFit.cover,
  ),
)
```

### 2.2 ClipOval - قص بيضاوي/دائري

```dart
ClipOval(
  child: Image.network(
    'https://picsum.photos/200/200',
    width: 200,
    height: 200,
    fit: BoxFit.cover,
  ),
)
```

### 2.3 ClipPath - قص بمسار مخصص

```dart
class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width / 2, 0); // نقطة العلوية
    path.lineTo(size.width, size.height); // نقطة اليمين السفلية
    path.lineTo(0, size.height); // نقطة اليسار السفلية
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

// الاستخدام
ClipPath(
  clipper: TriangleClipper(),
  child: Container(
    width: 200,
    height: 200,
    color: Colors.blue,
    child: Center(
      child: Text(
        'شكل مثلث',
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    ),
  ),
)
```

### 2.4 مثال متقدم: بطاقة بتصميم مخصص

```dart
class CustomCardClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    
    // البداية من الزاوية العلوية اليسرى
    path.moveTo(0, 20);
    
    // منحنى علوي أيسر
    path.quadraticBezierTo(0, 0, 20, 0);
    
    // خط علوي
    path.lineTo(size.width - 20, 0);
    
    // منحنى علوي أيمن
    path.quadraticBezierTo(size.width, 0, size.width, 20);
    
    // خط أيمن
    path.lineTo(size.width, size.height - 50);
    
    // قطع مثلث في الأسفل
    path.lineTo(size.width / 2 + 20, size.height - 50);
    path.lineTo(size.width / 2, size.height - 30);
    path.lineTo(size.width / 2 - 20, size.height - 50);
    
    // خط أيسر
    path.lineTo(0, size.height - 50);
    
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

// الاستخدام
ClipPath(
  clipper: CustomCardClipper(),
  child: Container(
    width: 300,
    height: 200,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.purple, Colors.blue],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    child: Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'بطاقة مخصصة',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'تصميم فريد باستخدام ClipPath',
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    ),
  ),
)
```

### 2.5 ClipRect - قص مستطيل

```dart
ClipRect(
  child: Align(
    alignment: Alignment.topCenter,
    heightFactor: 0.5, // عرض نصف الصورة فقط
    child: Image.network(
      'https://picsum.photos/300/400',
    ),
  ),
)
```

---

## 3. BackdropFilter - تأثير الضبابية

### 3.1 المفهوم الأساسي

`BackdropFilter` يطبق فلتر على الخلفية خلف الويدجت.

```dart
Stack(
  children: [
    // الخلفية
    Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage('https://picsum.photos/400/600'),
          fit: BoxFit.cover,
        ),
      ),
    ),
    
    // تأثير ضبابي
    Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: 300,
            height: 200,
            color: Colors.white.withOpacity(0.2),
            child: Center(
              child: Text(
                'نص فوق خلفية ضبابية',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  ],
)
```

### 3.2 مثال متقدم: شريط تطبيقات زجاجي (Glassmorphism)

```dart
class GlassmorphicAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const GlassmorphicAppBar({required this.title});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            border: Border(
              bottom: BorderSide(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
          ),
          child: AppBar(
            title: Text(title),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        ),
      ),
    );
  }
}

// الاستخدام
Scaffold(
  extendBodyBehindAppBar: true,
  appBar: GlassmorphicAppBar(title: 'تأثير زجاجي'),
  body: Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.purple, Colors.blue],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    child: Center(child: Text('المحتوى')),
  ),
)
```

### 3.3 بطاقة زجاجية (Glass Card)

```dart
class GlassCard extends StatelessWidget {
  final Widget child;
  final double blur;
  final double opacity;

  const GlassCard({
    required this.child,
    this.blur = 10,
    this.opacity = 0.2,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(opacity),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1.5,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

// الاستخدام
Stack(
  children: [
    Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage('https://picsum.photos/400/800'),
          fit: BoxFit.cover,
        ),
      ),
    ),
    Center(
      child: GlassCard(
        blur: 15,
        opacity: 0.15,
        child: Padding(
          padding: EdgeInsets.all(30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.lock, size: 60, color: Colors.white),
              SizedBox(height: 20),
              Text(
                'تسجيل الدخول',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'مرحباً بك مجدداً',
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    ),
  ],
)
```

**💡 نصيحة:** استخدم `dart:ui` لاستيراد `ImageFilter`:
```dart
import 'dart:ui';
```

---

## 4. DecoratedBox - الزخرفة والتنسيق

### 4.1 المفهوم الأساسي

`DecoratedBox` يطبق `Decoration` على الويدجت الابنة.

```dart
DecoratedBox(
  decoration: BoxDecoration(
    color: Colors.blue,
    borderRadius: BorderRadius.circular(10),
    boxShadow: [
      BoxShadow(
        color: Colors.black26,
        blurRadius: 10,
        offset: Offset(0, 5),
      ),
    ],
  ),
  child: Padding(
    padding: EdgeInsets.all(20),
    child: Text('نص مزخرف'),
  ),
)
```

### 4.2 تدرجات معقدة (Complex Gradients)

```dart
DecoratedBox(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [
        Color(0xFF667eea),
        Color(0xFF764ba2),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: Color(0xFF667eea).withOpacity(0.5),
        blurRadius: 20,
        offset: Offset(0, 10),
      ),
    ],
  ),
  child: Container(
    width: 300,
    height: 150,
    child: Center(
      child: Text(
        'تدرج جميل',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ),
)
```

### 4.3 صور خلفية مع تأثيرات

```dart
DecoratedBox(
  decoration: BoxDecoration(
    image: DecorationImage(
      image: NetworkImage('https://picsum.photos/400/200'),
      fit: BoxFit.cover,
      colorFilter: ColorFilter.mode(
        Colors.black.withOpacity(0.5),
        BlendMode.darken,
      ),
    ),
    borderRadius: BorderRadius.circular(15),
  ),
  child: Container(
    width: 400,
    height: 200,
    child: Center(
      child: Text(
        'نص فوق صورة معتمة',
        style: TextStyle(
          color: Colors.white,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ),
)
```

### 4.4 حدود متقدمة (Advanced Borders)

```dart
DecoratedBox(
  decoration: BoxDecoration(
    color: Colors.white,
    border: Border.all(
      color: Colors.blue,
      width: 3,
    ),
    borderRadius: BorderRadius.circular(15),
    boxShadow: [
      BoxShadow(
        color: Colors.blue.withOpacity(0.3),
        blurRadius: 10,
        spreadRadius: 2,
      ),
    ],
  ),
  child: Padding(
    padding: EdgeInsets.all(20),
    child: Text('حدود ملونة مع ظل'),
  ),
)
```

### 4.5 تدرج شعاعي (Radial Gradient)

```dart
DecoratedBox(
  decoration: BoxDecoration(
    gradient: RadialGradient(
      colors: [
        Colors.yellow,
        Colors.orange,
        Colors.red,
      ],
      center: Alignment.topLeft,
      radius: 1.5,
    ),
    borderRadius: BorderRadius.circular(20),
  ),
  child: Container(
    width: 200,
    height: 200,
    child: Center(
      child: Text(
        'تدرج شعاعي',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ),
)
```

---

## 5. Transform - التحويلات الهندسية

### 5.1 Transform.rotate - التدوير

```dart
Transform.rotate(
  angle: 0.5, // بالراديان (0.5 ≈ 28.6 درجة)
  child: Container(
    width: 100,
    height: 100,
    color: Colors.blue,
    child: Center(child: Text('مدور')),
  ),
)

// التحويل من درجات إلى راديان
import 'dart:math' as math;

Transform.rotate(
  angle: 45 * math.pi / 180, // 45 درجة
  child: Container(...),
)
```

### 5.2 Transform.scale - التحجيم

```dart
Transform.scale(
  scale: 1.5, // تكبير بمقدار 1.5x
  child: Icon(Icons.favorite, size: 50, color: Colors.red),
)

// تحجيم مختلف للعرض والارتفاع
Transform(
  transform: Matrix4.diagonal3Values(1.5, 0.8, 1.0), // عرض 1.5x, ارتفاع 0.8x
  child: Container(
    width: 100,
    height: 100,
    color: Colors.green,
  ),
)
```

### 5.3 Transform.translate - الإزاحة

```dart
Transform.translate(
  offset: Offset(50, 20), // إزاحة 50 يميناً و 20 للأسفل
  child: Container(
    width: 100,
    height: 100,
    color: Colors.orange,
  ),
)
```

### 5.4 تحويلات متقدمة: المنظور ثلاثي الأبعاد

```dart
class FlipCard extends StatefulWidget {
  @override
  _FlipCardState createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _flip() {
    if (_controller.isCompleted) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _flip,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final angle = _animation.value * math.pi;
          final transform = Matrix4.identity()
            ..setEntry(3, 2, 0.001) // منظور
            ..rotateY(angle);

          return Transform(
            transform: transform,
            alignment: Alignment.center,
            child: angle < math.pi / 2
                ? _buildFrontCard()
                : Transform(
                    transform: Matrix4.rotationY(math.pi),
                    alignment: Alignment.center,
                    child: _buildBackCard(),
                  ),
          );
        },
      ),
    );
  }

  Widget _buildFrontCard() {
    return Container(
      width: 300,
      height: 200,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue, Colors.purple],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text(
          'الواجهة الأمامية',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }

  Widget _buildBackCard() {
    return Container(
      width: 300,
      height: 200,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange, Colors.red],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text(
          'الواجهة الخلفية',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}
```

### 5.5 تأثير الإمالة (Skew)

```dart
Transform(
  transform: Matrix4.skewX(0.3), // إمالة أفقية
  child: Container(
    width: 100,
    height: 100,
    color: Colors.teal,
    child: Center(child: Text('مائل')),
  ),
)

// إمالة عمودية
Transform(
  transform: Matrix4.skewY(0.3),
  child: Container(...),
)
```

### 5.6 تحويلات مدمجة

```dart
Transform(
  transform: Matrix4.identity()
    ..setEntry(3, 2, 0.001) // منظور
    ..rotateX(0.3)
    ..rotateY(0.2)
    ..rotateZ(0.1)
    ..scale(1.2),
  alignment: Alignment.center,
  child: Container(
    width: 150,
    height: 150,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.cyan, Colors.blue],
      ),
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black26,
          blurRadius: 20,
          offset: Offset(0, 10),
        ),
      ],
    ),
    child: Center(
      child: Text(
        '3D',
        style: TextStyle(
          color: Colors.white,
          fontSize: 40,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ),
)
```

---

## 6. CustomPaint - الرسم المخصص

### 6.1 المفهوم الأساسي

`CustomPaint` يسمح لك برسم أشكال مخصصة باستخدام `Canvas`.

```dart
class SimplePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    // رسم دائرة
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      50,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// الاستخدام
CustomPaint(
  size: Size(200, 200),
  painter: SimplePainter(),
)
```

### 6.2 رسم أشكال متعددة

```dart
class ShapesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    // مستطيل
    canvas.drawRect(
      Rect.fromLTWH(20, 20, 100, 60),
      paint,
    );

    // دائرة
    canvas.drawCircle(
      Offset(200, 50),
      40,
      paint..color = Colors.red,
    );

    // خط
    canvas.drawLine(
      Offset(20, 120),
      Offset(220, 120),
      paint..color = Colors.green,
    );

    // قوس
    canvas.drawArc(
      Rect.fromCircle(center: Offset(120, 180), radius: 50),
      0,
      math.pi,
      false,
      paint..color = Colors.purple,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
```

### 6.3 مثال متقدم: رسم مخطط دائري (Pie Chart)

```dart
class PieChartPainter extends CustomPainter {
  final List<double> values;
  final List<Color> colors;

  PieChartPainter({required this.values, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    final total = values.reduce((a, b) => a + b);

    double startAngle = -math.pi / 2;

    for (int i = 0; i < values.length; i++) {
      final sweepAngle = (values[i] / total) * 2 * math.pi;
      final paint = Paint()
        ..color = colors[i % colors.length]
        ..style = PaintingStyle.fill;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

// الاستخدام
CustomPaint(
  size: Size(300, 300),
  painter: PieChartPainter(
    values: [30, 20, 25, 25],
    colors: [Colors.blue, Colors.red, Colors.green, Colors.orange],
  ),
)
```

### 6.4 رسم مسارات معقدة (Complex Paths)

```dart
class WavePainter extends CustomPainter {
  final Color color;
  final double waveHeight;

  WavePainter({required this.color, this.waveHeight = 20});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height * 0.5);

    // رسم موجة باستخدام منحنيات بيزيه
    for (double i = 0; i < size.width; i++) {
      path.lineTo(
        i,
        size.height * 0.5 + math.sin((i / size.width) * 4 * math.pi) * waveHeight,
      );
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

// الاستخدام
CustomPaint(
  size: Size(double.infinity, 200),
  painter: WavePainter(
    color: Colors.blue.withOpacity(0.5),
    waveHeight: 30,
  ),
)
```

### 6.5 رسم متحرك (Animated Drawing)

```dart
class AnimatedCirclePainter extends CustomPainter {
  final double animationValue;

  AnimatedCirclePainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = math.min(size.width, size.height) / 2;

    for (int i = 0; i < 5; i++) {
      final radius = maxRadius * animationValue - (i * 20);
      if (radius > 0) {
        final paint = Paint()
          ..color = Colors.blue.withOpacity(1 - (i * 0.2))
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;

        canvas.drawCircle(center, radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

// الاستخدام مع Animation
class AnimatedCircleWidget extends StatefulWidget {
  @override
  _AnimatedCircleWidgetState createState() => _AnimatedCircleWidgetState();
}

class _AnimatedCircleWidgetState extends State<AnimatedCircleWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 2),
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
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size(200, 200),
          painter: AnimatedCirclePainter(animationValue: _controller.value),
        );
      },
    );
  }
}
```

---

## 7. ShaderMask - تطبيق Shaders

### 7.1 تدرج على نص

```dart
ShaderMask(
  shaderCallback: (Rect bounds) {
    return LinearGradient(
      colors: [Colors.pink, Colors.purple, Colors.blue],
    ).createShader(bounds);
  },
  child: Text(
    'نص ملون بتدرج',
    style: TextStyle(
      fontSize: 40,
      fontWeight: FontWeight.bold,
      color: Colors.white, // اللون الأبيض ضروري لظهور التدرج
    ),
  ),
)
```

### 7.2 تدرج على أيقونة

```dart
ShaderMask(
  shaderCallback: (Rect bounds) {
    return RadialGradient(
      colors: [Colors.yellow, Colors.orange, Colors.red],
      center: Alignment.topLeft,
      radius: 1.0,
    ).createShader(bounds);
  },
  child: Icon(
    Icons.favorite,
    size: 100,
    color: Colors.white,
  ),
)
```

### 7.3 تأثير متحرك على صورة

```dart
class ShaderAnimationWidget extends StatefulWidget {
  @override
  _ShaderAnimationWidgetState createState() => _ShaderAnimationWidgetState();
}

class _ShaderAnimationWidgetState extends State<ShaderAnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
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
        return ShaderMask(
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              colors: [
                Colors.transparent,
                Colors.black,
                Colors.transparent,
              ],
              stops: [
                _controller.value - 0.3,
                _controller.value,
                _controller.value + 0.3,
              ],
            ).createShader(bounds);
          },
          blendMode: BlendMode.dstIn,
          child: Image.network(
            'https://picsum.photos/300/300',
            width: 300,
            height: 300,
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }
}
```

---

## 8. ColorFiltered - فلاتر الألوان

### 8.1 تحويل لأبيض وأسود

```dart
ColorFiltered(
  colorFilter: ColorFilter.mode(
    Colors.grey,
    BlendMode.saturation,
  ),
  child: Image.network(
    'https://picsum.photos/300/200',
    width: 300,
    height: 200,
    fit: BoxFit.cover,
  ),
)
```

### 8.2 تطبيق لون على الصورة

```dart
ColorFiltered(
  colorFilter: ColorFilter.mode(
    Colors.blue.withOpacity(0.5),
    BlendMode.color,
  ),
  child: Image.network(
    'https://picsum.photos/300/200',
  ),
)
```

### 8.3 وضع Sepia (بني قديم)

```dart
ColorFiltered(
  colorFilter: ColorFilter.matrix([
    0.393, 0.769, 0.189, 0, 0,
    0.349, 0.686, 0.168, 0, 0,
    0.272, 0.534, 0.131, 0, 0,
    0, 0, 0, 1, 0,
  ]),
  child: Image.network(
    'https://picsum.photos/300/200',
  ),
)
```

---

## 9. مثال تطبيقي متكامل

### تطبيق معرض صور بتأثيرات متقدمة

```dart
import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math' as math;

class PhotoGalleryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: PhotoGalleryScreen(),
    );
  }
}

class PhotoGalleryScreen extends StatefulWidget {
  @override
  _PhotoGalleryScreenState createState() => _PhotoGalleryScreenState();
}

class _PhotoGalleryScreenState extends State<PhotoGalleryScreen> {
  final List<String> _images = List.generate(
    10,
    (index) => 'https://picsum.photos/400/600?random=$index',
  );

  int? _selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // الخلفية المتدرجة
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // شريط التطبيق الزجاجي
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: [Colors.cyan, Colors.blue],
                          ).createShader(bounds),
                          child: Icon(
                            Icons.photo_library,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 12),
                        ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: [Colors.cyan, Colors.blue],
                          ).createShader(bounds),
                          child: Text(
                            'معرض الصور',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // الشبكة
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 70,
              left: 16,
              right: 16,
              bottom: 16,
            ),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.7,
              ),
              itemCount: _images.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex = _selectedIndex == index ? null : index;
                    });
                  },
                  child: _buildPhotoCard(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoCard(int index) {
    final isSelected = _selectedIndex == index;

    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..rotateX(isSelected ? 0.1 : 0)
        ..scale(isSelected ? 1.05 : 1.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // الصورة
            Image.network(
              _images[index],
              fit: BoxFit.cover,
            ),

            // تأثير ضبابي عند التحديد
            if (isSelected)
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                child: Container(
                  color: Colors.black.withOpacity(0.2),
                ),
              ),

            // حدود متوهجة
            DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? Colors.cyan.withOpacity(0.8)
                      : Colors.white.withOpacity(0.2),
                  width: isSelected ? 3 : 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: Colors.cyan.withOpacity(0.5),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ]
                    : null,
              ),
            ),

            // رقم الصورة
            Positioned(
              bottom: 10,
              right: 10,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      '#${index + 1}',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // أيقونة التحديد
            if (isSelected)
              Center(
                child: Transform.scale(
                  scale: 1.2,
                  child: ShaderMask(
                    shaderCallback: (bounds) => RadialGradient(
                      colors: [Colors.cyan, Colors.blue],
                    ).createShader(bounds),
                    child: Icon(
                      Icons.check_circle,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
```

---

## 10. Best Practices

### ✅ افعل

1. **استخدم Const عند الإمكان**
```dart
const Opacity(
  opacity: 0.5,
  child: const Icon(Icons.star),
)
```

2. **استخدم RepaintBoundary للعناصر المعقدة**
```dart
RepaintBoundary(
  child: CustomPaint(
    painter: ComplexPainter(),
  ),
)
```

3. **استخدم AnimatedOpacity بدلاً من Opacity داخل AnimatedBuilder**
```dart
// ✅ صحيح
AnimatedOpacity(
  opacity: _visible ? 1.0 : 0.0,
  duration: Duration(milliseconds: 300),
  child: myWidget,
)

// ❌ خطأ (أقل كفاءة)
AnimatedBuilder(
  animation: _controller,
  builder: (context, child) {
    return Opacity(
      opacity: _controller.value,
      child: myWidget,
    );
  },
)
```

4. **استخدم shouldRepaint بحكمة في CustomPainter**
```dart
@override
bool shouldRepaint(CustomPainter oldDelegate) {
  return oldDelegate is MyPainter && oldDelegate.value != value;
}
```

### ❌ تجنب

1. **تجنب Opacity على أجزاء كبيرة من الشجرة**
```dart
// ❌ تجنب
Opacity(
  opacity: 0.5,
  child: Column(
    children: List.generate(100, (index) => ComplexWidget()),
  ),
)

// ✅ أفضل
Column(
  children: List.generate(100, (index) => 
    Opacity(opacity: 0.5, child: ComplexWidget()),
  ),
)
```

2. **تجنب BackdropFilter على مساحات كبيرة**
```dart
// ❌ مكلف جداً
BackdropFilter(
  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
  child: Container(
    width: double.infinity,
    height: double.infinity,
  ),
)

// ✅ حدد المساحة
ClipRRect(
  borderRadius: BorderRadius.circular(20),
  child: BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
    child: Container(
      width: 300,
      height: 200,
    ),
  ),
)
```

3. **تجنب Transform بدون alignment واضح**
```dart
// ❌ قد يسبب نتائج غير متوقعة
Transform.rotate(
  angle: 0.5,
  child: myWidget,
)

// ✅ حدد alignment
Transform.rotate(
  angle: 0.5,
  alignment: Alignment.center,
  child: myWidget,
)
```

### 💡 نصائح الأداء

1. **استخدم ClipRRect بدلاً من ClipPath عند الإمكان**
2. **تجنب تداخل BackdropFilter**
3. **استخدم `saveLayer` بحذر في CustomPaint**
4. **ضع RepaintBoundary حول العناصر التي نادراً ما تتغير**
5. **استخدم `const` للويدجت الثابتة**

---

## المراجع

1. **Flutter Painting and Effects Widgets**
   - [https://docs.flutter.dev/ui/widgets/painting](https://docs.flutter.dev/ui/widgets/painting)

2. **CustomPaint and Canvas**
   - [https://api.flutter.dev/flutter/widgets/CustomPaint-class.html](https://api.flutter.dev/flutter/widgets/CustomPaint-class.html)

3. **Transform Widget**
   - [https://api.flutter.dev/flutter/widgets/Transform-class.html](https://api.flutter.dev/flutter/widgets/Transform-class.html)

4. **BackdropFilter**
   - [https://api.flutter.dev/flutter/widgets/BackdropFilter-class.html](https://api.flutter.dev/flutter/widgets/BackdropFilter-class.html)

5. **Opacity Widget**
   - [https://api.flutter.dev/flutter/widgets/Opacity-class.html](https://api.flutter.dev/flutter/widgets/Opacity-class.html)

6. **ClipPath and Custom Clippers**
   - [https://api.flutter.dev/flutter/widgets/ClipPath-class.html](https://api.flutter.dev/flutter/widgets/ClipPath-class.html)

7. **ShaderMask**
   - [https://api.flutter.dev/flutter/widgets/ShaderMask-class.html](https://api.flutter.dev/flutter/widgets/ShaderMask-class.html)

8. **Matrix4 Transformations**
   - [https://api.flutter.dev/flutter/vector_math_64/Matrix4-class.html](https://api.flutter.dev/flutter/vector_math_64/Matrix4-class.html)

9. **Performance Best Practices**
   - [https://docs.flutter.dev/perf/best-practices](https://docs.flutter.dev/perf/best-practices)

10. **Glassmorphism in Flutter**
    - [https://medium.com/flutter-community/glassmorphism-in-flutter](https://medium.com/flutter-community/glassmorphism-in-flutter)

---

[⬅️ الرجوع للفهرس الرئيسي](./README.md)
