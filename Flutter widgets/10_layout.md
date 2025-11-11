# Layout - التخطيط والتنسيق

[← العودة للفهرس الرئيسي](README.md)

## 📋 المحتويات

- [نظرة عامة](#نظرة-عامة)
- [فهم القيود (Constraints)](#فهم-القيود-constraints)
- [ويدجت التخطيط الأساسية](#ويدجت-التخطيط-الأساسية)
- [التخطيطات المتقدمة](#التخطيطات-المتقدمة)
- [الاستجابة والتكيف](#الاستجابة-والتكيف)
- [أمثلة عملية](#أمثلة-عملية)
- [أفضل الممارسات](#أفضل-الممارسات)
- [المراجع](#المراجع)

---

## نظرة عامة

التخطيط في Flutter يعتمد على مفهوم **الويدجت المتداخلة**. كل ويدجت مسؤولة عن تحديد حجم وموضع أطفالها. فهم كيفية عمل نظام التخطيط ضروري لبناء واجهات معقدة.

---

## فهم القيود (Constraints)

### القاعدة الذهبية

> **"القيود تنزل، الأحجام ترتفع، الأصل يحدد الموضع"**
> 
> Constraints go down. Sizes go up. Parent sets position.

```dart
// الأصل يمرر القيود للطفل
Container(
  width: 300,  // قيد أقصى
  height: 200, // قيد أقصى
  child: SizedBox(
    width: 100,  // يحاول 100
    height: 50,  // يحاول 50
    child: Container(
      color: Colors.blue,
      // الحجم الفعلي سيكون 100x50
    ),
  ),
)
```

### أنواع القيود

```dart
// 1. Tight Constraints (قيود ثابتة)
// الحد الأدنى = الحد الأقصى
SizedBox(
  width: 100,
  height: 100,
  child: child, // يجب أن يكون 100x100
)

// 2. Loose Constraints (قيود مرنة)
// الحد الأدنى = 0
Container(
  constraints: BoxConstraints(
    minWidth: 0,
    maxWidth: 300,
    minHeight: 0,
    maxHeight: 200,
  ),
  child: child, // يمكن أن يكون من 0 إلى 300x200
)

// 3. Unbounded Constraints (قيود غير محدودة)
// الحد الأقصى = لانهاية
Row(
  children: [
    child, // عرض غير محدود
  ],
)
```

---

## ويدجت التخطيط الأساسية

### 1. Container

الحاوية الأكثر مرونة.

```dart
Container(
  // القيود
  constraints: BoxConstraints(
    minWidth: 100,
    maxWidth: 300,
    minHeight: 50,
    maxHeight: 200,
  ),
  
  // أو استخدم width/height
  width: 200,
  height: 100,
  
  // المحاذاة
  alignment: Alignment.center,
  
  // الحشو
  padding: EdgeInsets.all(16),
  
  // الهامش
  margin: EdgeInsets.symmetric(horizontal: 20),
  
  child: Text('محتوى'),
)
```

### 2. Row

ترتيب أفقي.

```dart
Row(
  // المحاذاة الأفقية (المحور الرئيسي)
  mainAxisAlignment: MainAxisAlignment.start,      // في البداية
  mainAxisAlignment: MainAxisAlignment.end,        // في النهاية
  mainAxisAlignment: MainAxisAlignment.center,     // في المنتصف
  mainAxisAlignment: MainAxisAlignment.spaceBetween, // مسافات متساوية بين العناصر
  mainAxisAlignment: MainAxisAlignment.spaceAround,  // مسافات حول العناصر
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,  // مسافات متساوية تماماً
  
  // المحاذاة العمودية (المحور المتقاطع)
  crossAxisAlignment: CrossAxisAlignment.start,   // في الأعلى
  crossAxisAlignment: CrossAxisAlignment.end,     // في الأسفل
  crossAxisAlignment: CrossAxisAlignment.center,  // في المنتصف
  crossAxisAlignment: CrossAxisAlignment.stretch, // تمدد كامل
  crossAxisAlignment: CrossAxisAlignment.baseline, // على خط الأساس
  
  // حجم الصف
  mainAxisSize: MainAxisSize.max, // أقصى عرض متاح
  mainAxisSize: MainAxisSize.min, // أقل عرض ممكن
  
  children: [
    Container(width: 50, height: 50, color: Colors.red),
    Container(width: 50, height: 100, color: Colors.green),
    Container(width: 50, height: 75, color: Colors.blue),
  ],
)
```

### 3. Column

ترتيب عمودي (مثل Row لكن عمودياً).

```dart
Column(
  mainAxisAlignment: MainAxisAlignment.start,
  crossAxisAlignment: CrossAxisAlignment.center,
  mainAxisSize: MainAxisSize.min,
  
  children: [
    Text('عنوان'),
    SizedBox(height: 10),
    Text('فقرة'),
    SizedBox(height: 20),
    ElevatedButton(
      onPressed: () {},
      child: Text('إجراء'),
    ),
  ],
)
```

### 4. Stack

تكديس العناصر فوق بعضها.

```dart
Stack(
  // المحاذاة الافتراضية
  alignment: Alignment.center,
  
  // القص
  clipBehavior: Clip.none, // عدم القص
  clipBehavior: Clip.hardEdge, // قص حاد
  
  // الملاءمة
  fit: StackFit.loose,   // العناصر تأخذ حجمها الطبيعي
  fit: StackFit.expand,  // العناصر تتمدد
  fit: StackFit.passthrough, // تمرير القيود
  
  children: [
    // الطبقة الأولى (الأسفل)
    Container(
      width: 300,
      height: 300,
      color: Colors.blue,
    ),
    
    // الطبقة الثانية
    Positioned(
      top: 50,
      left: 50,
      child: Container(
        width: 100,
        height: 100,
        color: Colors.red,
      ),
    ),
    
    // الطبقة الثالثة (الأعلى)
    Positioned(
      bottom: 20,
      right: 20,
      child: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
    ),
  ],
)
```

### 5. Expanded و Flexible

توسيع العناصر في Row أو Column.

```dart
// Expanded - يأخذ كل المساحة المتاحة
Row(
  children: [
    Container(width: 50, color: Colors.red),
    Expanded(
      flex: 2, // ضعف المساحة
      child: Container(color: Colors.green),
    ),
    Expanded(
      flex: 1, // مساحة عادية
      child: Container(color: Colors.blue),
    ),
  ],
)

// Flexible - يأخذ المساحة لكن ليس إجباري
Row(
  children: [
    Flexible(
      fit: FlexFit.loose, // يأخذ ما يحتاج فقط
      child: Container(
        width: 100,
        color: Colors.orange,
      ),
    ),
    Flexible(
      fit: FlexFit.tight, // يأخذ كل المساحة (مثل Expanded)
      child: Container(color: Colors.purple),
    ),
  ],
)
```

### 6. Wrap

التفاف تلقائي للعناصر.

```dart
Wrap(
  // اتجاه الترتيب
  direction: Axis.horizontal, // أو Axis.vertical
  
  // المحاذاة
  alignment: WrapAlignment.start,
  alignment: WrapAlignment.center,
  alignment: WrapAlignment.end,
  alignment: WrapAlignment.spaceBetween,
  alignment: WrapAlignment.spaceAround,
  alignment: WrapAlignment.spaceEvenly,
  
  // المحاذاة العمودية
  crossAxisAlignment: WrapCrossAlignment.start,
  crossAxisAlignment: WrapCrossAlignment.center,
  crossAxisAlignment: WrapCrossAlignment.end,
  
  // المحاذاة عند التشغيل
  runAlignment: WrapAlignment.start,
  
  // المسافات
  spacing: 10,    // بين العناصر
  runSpacing: 15, // بين الأسطر
  
  children: [
    Chip(label: Text('Flutter')),
    Chip(label: Text('Dart')),
    Chip(label: Text('Mobile')),
    Chip(label: Text('Development')),
    Chip(label: Text('UI')),
    Chip(label: Text('UX')),
  ],
)
```

### 7. ListView

قائمة قابلة للتمرير.

```dart
// ListView بسيط
ListView(
  children: [
    ListTile(title: Text('عنصر 1')),
    ListTile(title: Text('عنصر 2')),
    ListTile(title: Text('عنصر 3')),
  ],
)

// ListView.builder - للقوائم الطويلة
ListView.builder(
  itemCount: 1000,
  itemBuilder: (context, index) {
    return ListTile(
      leading: CircleAvatar(child: Text('$index')),
      title: Text('عنصر $index'),
      subtitle: Text('وصف العنصر'),
      trailing: Icon(Icons.arrow_forward),
    );
  },
)

// ListView.separated - مع فواصل
ListView.separated(
  itemCount: 20,
  separatorBuilder: (context, index) => Divider(),
  itemBuilder: (context, index) {
    return ListTile(title: Text('عنصر $index'));
  },
)

// ListView.custom - مخصص تماماً
ListView.custom(
  childrenDelegate: SliverChildBuilderDelegate(
    (context, index) => ListTile(title: Text('عنصر $index')),
    childCount: 50,
  ),
)
```

### 8. GridView

عرض شبكي.

```dart
// GridView.count - عدد محدد من الأعمدة
GridView.count(
  crossAxisCount: 3, // 3 أعمدة
  mainAxisSpacing: 10,
  crossAxisSpacing: 10,
  padding: EdgeInsets.all(10),
  children: List.generate(20, (index) {
    return Container(
      color: Colors.primaries[index % Colors.primaries.length],
      child: Center(child: Text('$index')),
    );
  }),
)

// GridView.extent - حجم محدد للعناصر
GridView.extent(
  maxCrossAxisExtent: 150, // أقصى عرض للعنصر
  mainAxisSpacing: 10,
  crossAxisSpacing: 10,
  children: [
    // العناصر
  ],
)

// GridView.builder - بناء ديناميكي
GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    childAspectRatio: 1.5, // نسبة العرض/الارتفاع
  ),
  itemCount: 100,
  itemBuilder: (context, index) {
    return Card(
      child: Center(child: Text('عنصر $index')),
    );
  },
)
```

### 9. Table

جدول صفوف وأعمدة.

```dart
Table(
  // عرض الأعمدة
  columnWidths: {
    0: FlexColumnWidth(2), // عمود 0 ضعف العرض
    1: FlexColumnWidth(1),
    2: FixedColumnWidth(100), // عرض ثابت
  },
  
  // حدود
  border: TableBorder.all(color: Colors.grey),
  
  // عرض افتراضي للعمود
  defaultColumnWidth: IntrinsicColumnWidth(),
  
  // محاذاة عمودية
  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
  
  children: [
    // الصف الأول
    TableRow(
      children: [
        TableCell(child: Padding(
          padding: EdgeInsets.all(8),
          child: Text('الاسم', style: TextStyle(fontWeight: FontWeight.bold)),
        )),
        TableCell(child: Padding(
          padding: EdgeInsets.all(8),
          child: Text('العمر', style: TextStyle(fontWeight: FontWeight.bold)),
        )),
        TableCell(child: Padding(
          padding: EdgeInsets.all(8),
          child: Text('المدينة', style: TextStyle(fontWeight: FontWeight.bold)),
        )),
      ],
    ),
    
    // الصف الثاني
    TableRow(
      decoration: BoxDecoration(color: Colors.grey[100]),
      children: [
        Padding(padding: EdgeInsets.all(8), child: Text('محمد')),
        Padding(padding: EdgeInsets.all(8), child: Text('25')),
        Padding(padding: EdgeInsets.all(8), child: Text('الرياض')),
      ],
    ),
    
    // المزيد من الصفوف...
  ],
)
```

### 10. ConstrainedBox

تطبيق قيود على الطفل.

```dart
ConstrainedBox(
  constraints: BoxConstraints(
    minWidth: 100,
    maxWidth: 300,
    minHeight: 50,
    maxHeight: 200,
  ),
  child: Container(
    color: Colors.blue,
    // سيكون بين 100-300 عرض و 50-200 ارتفاع
  ),
)

// UnconstrainedBox - إزالة القيود
UnconstrainedBox(
  child: Container(
    width: 5000, // سيتجاوز حدود الشاشة
    height: 100,
    color: Colors.red,
  ),
)
```

### 11. AspectRatio

الحفاظ على نسبة العرض/الارتفاع.

```dart
AspectRatio(
  aspectRatio: 16 / 9, // نسبة 16:9
  child: Container(
    color: Colors.blue,
    child: Center(child: Text('16:9')),
  ),
)

// مثال: فيديو
AspectRatio(
  aspectRatio: 16 / 9,
  child: Image.network(
    'https://example.com/video-thumbnail.jpg',
    fit: BoxFit.cover,
  ),
)
```

### 12. FractionallySizedBox

تحجيم بنسبة من الأصل.

```dart
FractionallySizedBox(
  widthFactor: 0.5,  // 50% من عرض الأصل
  heightFactor: 0.3, // 30% من ارتفاع الأصل
  alignment: Alignment.center,
  child: Container(color: Colors.green),
)
```

---

## التخطيطات المتقدمة

### 1. CustomScrollView مع Slivers

```dart
CustomScrollView(
  slivers: [
    // شريط تطبيق قابل للطي
    SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text('عنوان'),
        background: Image.network(
          'https://picsum.photos/400/200',
          fit: BoxFit.cover,
        ),
      ),
    ),
    
    // قائمة
    SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => ListTile(title: Text('عنصر $index')),
        childCount: 20,
      ),
    ),
    
    // شبكة
    SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) => Container(
          color: Colors.primaries[index % Colors.primaries.length],
          child: Center(child: Text('$index')),
        ),
        childCount: 10,
      ),
    ),
    
    // حشو
    SliverPadding(
      padding: EdgeInsets.all(20),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          Text('محتوى إضافي'),
        ]),
      ),
    ),
  ],
)
```

### 2. Flow - تخطيط مخصص متقدم

```dart
class CircularFlow extends FlowDelegate {
  @override
  void paintChildren(FlowPaintingContext context) {
    double radius = 100;
    int count = context.childCount;
    
    for (int i = 0; i < count; i++) {
      double angle = (2 * pi / count) * i;
      double x = radius * cos(angle);
      double y = radius * sin(angle);
      
      context.paintChild(
        i,
        transform: Matrix4.translationValues(x, y, 0),
      );
    }
  }
  
  @override
  bool shouldRepaint(CircularFlow oldDelegate) => false;
}

// الاستخدام
Flow(
  delegate: CircularFlow(),
  children: List.generate(
    8,
    (index) => Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.blue,
        shape: BoxShape.circle,
      ),
      child: Center(child: Text('$index')),
    ),
  ),
)
```

---

## الاستجابة والتكيف

### 1. LayoutBuilder

بناء واجهة بناءً على القيود المتاحة.

```dart
LayoutBuilder(
  builder: (context, constraints) {
    if (constraints.maxWidth > 600) {
      // تخطيط للشاشات الكبيرة
      return Row(
        children: [
          Expanded(child: Sidebar()),
          Expanded(flex: 2, child: MainContent()),
        ],
      );
    } else {
      // تخطيط للشاشات الصغيرة
      return Column(
        children: [
          MainContent(),
        ],
      );
    }
  },
)
```

### 2. MediaQuery

الحصول على معلومات الشاشة.

```dart
Widget build(BuildContext context) {
  final size = MediaQuery.of(context).size;
  final orientation = MediaQuery.of(context).orientation;
  final padding = MediaQuery.of(context).padding;
  
  return Container(
    width: size.width * 0.8, // 80% من عرض الشاشة
    height: size.height * 0.5, // 50% من ارتفاع الشاشة
    child: orientation == Orientation.portrait
        ? PortraitLayout()
        : LandscapeLayout(),
  );
}
```

### 3. OrientationBuilder

بناء واجهة بناءً على الاتجاه.

```dart
OrientationBuilder(
  builder: (context, orientation) {
    return GridView.count(
      crossAxisCount: orientation == Orientation.portrait ? 2 : 3,
      children: items,
    );
  },
)
```

---

## أمثلة عملية

### تطبيق مراسلة - تخطيط متقدم

```dart
class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {},
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage('https://i.pravatar.cc/50'),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('محمد أحمد', style: TextStyle(fontSize: 16)),
                  Text(
                    'متصل الآن',
                    style: TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(icon: Icon(Icons.call), onPressed: () {}),
          IconButton(icon: Icon(Icons.videocam), onPressed: () {}),
          IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      
      body: Column(
        children: [
          // منطقة الرسائل
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: EdgeInsets.all(16),
              itemCount: 20,
              itemBuilder: (context, index) {
                bool isMe = index % 2 == 0;
                return _buildMessage(isMe, 'رسالة رقم ${20 - index}');
              },
            ),
          ),
          
          // منطقة الإدخال
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.emoji_emotions_outlined),
                    onPressed: () {},
                  ),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'اكتب رسالة...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: IconButton(
                      icon: Icon(Icons.send, color: Colors.white),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildMessage(bool isMe, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe) ...[
            CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage('https://i.pravatar.cc/50'),
            ),
            SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isMe ? Colors.blue : Colors.grey[300],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                text,
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black87,
                ),
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

## أفضل الممارسات

### 1. تجنب التداخل المفرط

```dart
// ❌ سيئ
Column(
  children: [
    Row(
      children: [
        Column(
          children: [
            Row(
              children: [
                // عمق كبير جداً
              ],
            ),
          ],
        ),
      ],
    ),
  ],
)

// ✅ جيد - استخراج ويدجت
Column(
  children: [
    HeaderWidget(),
    ContentWidget(),
    FooterWidget(),
  ],
)
```

### 2. استخدام الحد الأدنى من الويدجت

```dart
// ❌ سيئ
Container(
  child: Padding(
    padding: EdgeInsets.all(16),
    child: Center(
      child: child,
    ),
  ),
)

// ✅ جيد
Container(
  padding: EdgeInsets.all(16),
  alignment: Alignment.center,
  child: child,
)
```

### 3. الأداء

```dart
// ✅ استخدم ListView.builder للقوائم الطويلة
ListView.builder(
  itemCount: 1000,
  itemBuilder: (context, index) => ListTile(title: Text('$index')),
)

// ❌ لا تستخدم ListView مع children كبيرة
ListView(
  children: List.generate(1000, (i) => ListTile(title: Text('$i'))),
)
```

---

## المراجع

### التوثيق الرسمي

1. **Layout Widgets**  
   [https://docs.flutter.dev/development/ui/widgets/layout](https://docs.flutter.dev/development/ui/widgets/layout)

2. **Understanding Constraints**  
   [https://docs.flutter.dev/development/ui/layout/constraints](https://docs.flutter.dev/development/ui/layout/constraints)

3. **Building Layouts**  
   [https://docs.flutter.dev/development/ui/layout](https://docs.flutter.dev/development/ui/layout)

4. **Creating Responsive Apps**  
   [https://docs.flutter.dev/development/ui/layout/adaptive-responsive](https://docs.flutter.dev/development/ui/layout/adaptive-responsive)

5. **Slivers Explained**  
   [https://medium.com/flutter/slivers-demystified-6ff68ab0296f](https://medium.com/flutter/slivers-demystified-6ff68ab0296f)

### فيديوهات

6. **Layout Cheat Sheet**  
   [https://medium.com/flutter-community/flutter-layout-cheat-sheet-5363348d037e](https://medium.com/flutter-community/flutter-layout-cheat-sheet-5363348d037e)

7. **Layouts in Flutter - The Boring Show**  
   [https://www.youtube.com/watch?v=PzPDPhOIXrw](https://www.youtube.com/watch?v=PzPDPhOIXrw)

---

[← العودة للفهرس الرئيسي](README.md)
[السابق: Interaction](09_interaction.md)
[التالي: Painting and Effects →](11_painting_effects.md)

---

**آخر تحديث:** نوفمبر 2025  
**مستوى:** متقدم - احترافي
