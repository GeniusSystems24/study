# Basics - الأساسيات

[← العودة للفهرس الرئيسي](README.md)

## 📋 المحتويات

- [نظرة عامة](#نظرة-عامة)
- [الويدجت الأساسية](#الويدجت-الأساسية)
- [أمثلة عملية](#أمثلة-عملية)
- [أفضل الممارسات](#أفضل-الممارسات)
- [المراجع](#المراجع)

---

## نظرة عامة

هذه هي الويدجت الأساسية التي يجب معرفتها قبل بناء أول تطبيق Flutter. إتقان هذه الويدجت هو الأساس لبناء واجهات معقدة.

---

## الويدجت الأساسية

### 1. Container

الحاوية الأكثر استخداماً في Flutter - صندوق قابل للتخصيص.

```dart
Container(
  // الأبعاد
  width: 200,
  height: 100,
  
  // الحشو الداخلي
  padding: EdgeInsets.all(16),
  
  // الهامش الخارجي
  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  
  // المحاذاة
  alignment: Alignment.center,
  
  // التحويل
  transform: Matrix4.rotationZ(0.1),
  
  // الزخرفة
  decoration: BoxDecoration(
    // اللون
    color: Colors.blue,
    
    // التدرج
    gradient: LinearGradient(
      colors: [Colors.blue, Colors.purple],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    
    // الحدود
    border: Border.all(color: Colors.white, width: 2),
    
    // نصف قطر الحواف
    borderRadius: BorderRadius.circular(12),
    
    // الظل
    boxShadow: [
      BoxShadow(
        color: Colors.black26,
        blurRadius: 10,
        offset: Offset(0, 5),
      ),
    ],
    
    // صورة خلفية
    image: DecorationImage(
      image: NetworkImage('https://example.com/bg.jpg'),
      fit: BoxFit.cover,
    ),
  ),
  
  child: Text('محتوى الحاوية'),
)
```

### 2. Row - الصف الأفقي

ترتيب الويدجت أفقياً.

```dart
Row(
  // المحاذاة الأفقية
  mainAxisAlignment: MainAxisAlignment.spaceBetween, // start, end, center, spaceEvenly, spaceAround
  
  // المحاذاة العمودية
  crossAxisAlignment: CrossAxisAlignment.center, // start, end, stretch, baseline
  
  // حجم الصف
  mainAxisSize: MainAxisSize.max, // min, max
  
  // اتجاه النص
  textDirection: TextDirection.ltr, // rtl
  
  // المحاذاة العمودية
  verticalDirection: VerticalDirection.down, // up
  
  children: [
    Icon(Icons.star, color: Colors.amber),
    SizedBox(width: 8),
    Text('تقييم 4.5'),
    Spacer(), // مساحة مرنة
    IconButton(
      icon: Icon(Icons.share),
      onPressed: () {},
    ),
  ],
)
```

### 3. Column - العمود الرأسي

ترتيب الويدجت عمودياً.

```dart
Column(
  // المحاذاة الرأسية
  mainAxisAlignment: MainAxisAlignment.start,
  
  // المحاذاة الأفقية
  crossAxisAlignment: CrossAxisAlignment.stretch,
  
  // حجم العمود
  mainAxisSize: MainAxisSize.min,
  
  children: [
    Text(
      'عنوان رئيسي',
      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    ),
    SizedBox(height: 8),
    Text(
      'نص فرعي يوضح المزيد من التفاصيل',
      style: TextStyle(color: Colors.grey),
    ),
    SizedBox(height: 16),
    ElevatedButton(
      onPressed: () {},
      child: Text('إجراء'),
    ),
  ],
)
```

### 4. Text - النص

عرض النصوص.

```dart
// نص بسيط
Text('مرحباً بك في Flutter')

// نص بتنسيق
Text(
  'نص منسق',
  style: TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.italic,
    color: Colors.blue,
    letterSpacing: 2,
    wordSpacing: 5,
    decoration: TextDecoration.underline,
    decorationColor: Colors.red,
    decorationStyle: TextDecorationStyle.wavy,
    shadows: [
      Shadow(
        color: Colors.black26,
        offset: Offset(2, 2),
        blurRadius: 4,
      ),
    ],
  ),
  textAlign: TextAlign.center,
  maxLines: 2,
  overflow: TextOverflow.ellipsis,
)

// نص بخطوط Google
Text(
  'نص بخط مخصص',
  style: GoogleFonts.cairo(
    fontSize: 20,
    fontWeight: FontWeight.w600,
  ),
)
```

### 5. Scaffold - الهيكل الأساسي

الهيكل الأساسي للشاشة.

```dart
Scaffold(
  // شريط التطبيق
  appBar: AppBar(
    title: Text('عنوان التطبيق'),
    leading: IconButton(
      icon: Icon(Icons.menu),
      onPressed: () {},
    ),
    actions: [
      IconButton(
        icon: Icon(Icons.search),
        onPressed: () {},
      ),
      IconButton(
        icon: Icon(Icons.more_vert),
        onPressed: () {},
      ),
    ],
    elevation: 4,
    centerTitle: true,
  ),
  
  // المحتوى الرئيسي
  body: Center(
    child: Text('محتوى الشاشة'),
  ),
  
  // زر عائم
  floatingActionButton: FloatingActionButton(
    onPressed: () {},
    child: Icon(Icons.add),
    tooltip: 'إضافة',
  ),
  
  // موضع الزر العائم
  floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
  
  // القائمة الجانبية
  drawer: Drawer(
    child: ListView(
      children: [
        DrawerHeader(
          decoration: BoxDecoration(color: Colors.blue),
          child: Text('القائمة', style: TextStyle(color: Colors.white, fontSize: 24)),
        ),
        ListTile(
          leading: Icon(Icons.home),
          title: Text('الرئيسية'),
          onTap: () {},
        ),
      ],
    ),
  ),
  
  // شريط التنقل السفلي
  bottomNavigationBar: BottomNavigationBar(
    currentIndex: 0,
    items: [
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'الرئيسية',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.search),
        label: 'البحث',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person),
        label: 'الملف الشخصي',
      ),
    ],
  ),
  
  // الورقة السفلية الدائمة
  bottomSheet: Container(
    height: 50,
    color: Colors.amber,
    child: Center(child: Text('إعلان')),
  ),
  
  // لون الخلفية
  backgroundColor: Colors.grey[100],
)
```

### 6. AppBar

شريط التطبيق العلوي.

```dart
AppBar(
  // العنوان
  title: Text('عنوان الشاشة'),
  
  // زر القائمة/الرجوع
  leading: IconButton(
    icon: Icon(Icons.arrow_back),
    onPressed: () => Navigator.pop(context),
  ),
  
  // الإجراءات اليمينية
  actions: [
    IconButton(
      icon: Icon(Icons.favorite),
      onPressed: () {},
    ),
    IconButton(
      icon: Icon(Icons.share),
      onPressed: () {},
    ),
    PopupMenuButton(
      itemBuilder: (context) => [
        PopupMenuItem(child: Text('إعدادات'), value: 'settings'),
        PopupMenuItem(child: Text('مساعدة'), value: 'help'),
      ],
    ),
  ],
  
  // الارتفاع
  elevation: 4,
  
  // توسيط العنوان
  centerTitle: true,
  
  // الألوان
  backgroundColor: Colors.blue,
  foregroundColor: Colors.white,
  
  // الشكل
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
  ),
  
  // تبويب سفلي
  bottom: TabBar(
    tabs: [
      Tab(icon: Icon(Icons.home), text: 'الرئيسية'),
      Tab(icon: Icon(Icons.star), text: 'المفضلة'),
      Tab(icon: Icon(Icons.person), text: 'الملف'),
    ],
  ),
  
  // شريط التقدم
  bottom: PreferredSize(
    preferredSize: Size.fromHeight(4),
    child: LinearProgressIndicator(),
  ),
)
```

### 7. Center

توسيط الويدجت.

```dart
Center(
  // عامل التوسيع
  widthFactor: 2.0, // ضعف عرض الطفل
  heightFactor: 1.5, // 1.5 ضعف ارتفاع الطفل
  
  child: Text('نص في المنتصف'),
)
```

### 8. Align

محاذاة الويدجت.

```dart
Align(
  alignment: Alignment.topRight,
  // أو استخدام FractionalOffset
  alignment: FractionalOffset(0.5, 0.5), // (0,0) = topLeft, (1,1) = bottomRight
  
  child: Container(
    width: 100,
    height: 100,
    color: Colors.red,
  ),
)
```

### 9. SizedBox

صندوق بحجم محدد.

```dart
// عرض وارتفاع محددين
SizedBox(
  width: 200,
  height: 100,
  child: ElevatedButton(
    onPressed: () {},
    child: Text('زر بحجم ثابت'),
  ),
)

// مساحة فارغة
SizedBox(height: 20) // مسافة عمودية
SizedBox(width: 10)  // مسافة أفقية

// توسيع كامل
SizedBox.expand(
  child: Container(color: Colors.blue),
)

// تقليص
SizedBox.shrink() // عدم عرض شيء
```

### 10. Padding

إضافة مسافات داخلية.

```dart
// حشو متساوٍ من جميع الجهات
Padding(
  padding: EdgeInsets.all(16),
  child: Text('نص مع حشو'),
)

// حشو مخصص
Padding(
  padding: EdgeInsets.only(
    left: 20,
    top: 10,
    right: 20,
    bottom: 10,
  ),
  child: child,
)

// حشو متماثل
Padding(
  padding: EdgeInsets.symmetric(
    horizontal: 24,
    vertical: 12,
  ),
  child: child,
)

// حشو من اتجاه واحد
Padding(
  padding: EdgeInsets.fromLTRB(10, 20, 30, 40), // left, top, right, bottom
  child: child,
)
```

### 11. Spacer

مساحة مرنة في Row أو Column.

```dart
Row(
  children: [
    Text('يسار'),
    Spacer(), // يأخذ كل المساحة المتاحة
    Text('يمين'),
  ],
)

// مع عامل توسع
Row(
  children: [
    Text('A'),
    Spacer(flex: 2), // ضعف المساحة
    Text('B'),
    Spacer(flex: 1), // مساحة عادية
    Text('C'),
  ],
)
```

### 12. Divider

خط فاصل أفقي.

```dart
// بسيط
Divider()

// مخصص
Divider(
  color: Colors.grey,
  thickness: 2,
  indent: 20,    // مسافة من اليسار
  endIndent: 20, // مسافة من اليمين
  height: 40,    // الارتفاع الكلي (مع المسافات)
)

// عمودي
VerticalDivider(
  color: Colors.grey,
  thickness: 1,
  width: 20,
)
```

---

## أمثلة عملية

### بطاقة بروفايل بسيطة

```dart
class ProfileCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 300,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // الصورة الشخصية
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage('https://i.pravatar.cc/300'),
            ),
            
            SizedBox(height: 16),
            
            // الاسم
            Text(
              'محمد أحمد',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            SizedBox(height: 8),
            
            // الوصف
            Text(
              'مطور Flutter',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
            
            SizedBox(height: 16),
            
            Divider(),
            
            SizedBox(height: 16),
            
            // الإحصائيات
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatColumn('120', 'متابِع'),
                _buildStatColumn('80', 'متابَع'),
                _buildStatColumn('25', 'منشور'),
              ],
            ),
            
            SizedBox(height: 20),
            
            // الأزرار
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text('متابعة'),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    child: Text('رسالة'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStatColumn(String count, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          count,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
```

### شاشة رئيسية كاملة

```dart
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الرئيسية'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.purple],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 40),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'اسم المستخدم',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('الرئيسية'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('الإعدادات'),
              onTap: () {},
            ),
          ],
        ),
      ),
      
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'مرحباً بك!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'اكتشف المحتوى الجديد',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
            SizedBox(height: 24),
            
            // البطاقات
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  _buildCard('التقارير', Icons.assessment, Colors.blue),
                  _buildCard('الإحصائيات', Icons.bar_chart, Colors.green),
                  _buildCard('الإعدادات', Icons.settings, Colors.orange),
                  _buildCard('المساعدة', Icons.help, Colors.purple),
                ],
              ),
            ),
          ],
        ),
      ),
      
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
    );
  }
  
  Widget _buildCard(String title, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 50, color: color),
          SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
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

### 1. استخدام const

```dart
// ✅ جيد - استخدم const للأداء الأفضل
const SizedBox(height: 20)
const Text('نص ثابت')
const Divider()

// ❌ سيئ - بدون const
SizedBox(height: 20)
```

### 2. تجنب التداخل الزائد

```dart
// ❌ سيئ - تداخل غير ضروري
Container(
  child: Container(
    child: Container(
      child: Text('نص'),
    ),
  ),
)

// ✅ جيد - مباشر
Container(
  child: Text('نص'),
)
```

### 3. استخراج الويدجت

```dart
// ✅ جيد - استخراج ويدجت معقدة
class MyCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(...);
  }
}

// بدلاً من كتابة كل شيء في build()
```

---

## المراجع

### التوثيق الرسمي

1. **Introduction to Widgets**  
   [https://docs.flutter.dev/development/ui/widgets-intro](https://docs.flutter.dev/development/ui/widgets-intro)

2. **Widget Catalog - Basics**  
   [https://docs.flutter.dev/ui/widgets/basics](https://docs.flutter.dev/ui/widgets/basics)

3. **Container Class**  
   [https://api.flutter.dev/flutter/widgets/Container-class.html](https://api.flutter.dev/flutter/widgets/Container-class.html)

4. **Row and Column**  
   [https://docs.flutter.dev/development/ui/layout#lay-out-multiple-widgets-vertically-and-horizontally](https://docs.flutter.dev/development/ui/layout#lay-out-multiple-widgets-vertically-and-horizontally)

5. **Building Layouts**  
   [https://docs.flutter.dev/development/ui/layout](https://docs.flutter.dev/development/ui/layout)

### فيديوهات تعليمية

6. **Flutter Basics - Official Playlist**  
   [https://www.youtube.com/playlist?list=PLjxrf2q8roU2HdJQDjJzOeO6J3FoFLWr2](https://www.youtube.com/playlist?list=PLjxrf2q8roU2HdJQDjJzOeO6J3FoFLWr2)

7. **Container Widget - Widget of the Week**  
   [https://www.youtube.com/watch?v=c1xLMaTUWCY](https://www.youtube.com/watch?v=c1xLMaTUWCY)

---

[← العودة للفهرس الرئيسي](README.md)
[السابق: Async](06_async.md)
[التالي: Input →](08_input.md)

---

**آخر تحديث:** نوفمبر 2025  
**مستوى:** متقدم - احترافي
