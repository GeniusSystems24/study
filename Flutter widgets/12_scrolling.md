# Scrolling - التمرير

[← العودة للفهرس الرئيسي](README.md)

## 📋 المحتويات

- [نظرة عامة](#نظرة-عامة)
- [أنواع ويدجت التمرير](#أنواع-ويدجت-التمرير)
- [ScrollController](#scrollcontroller)
- [Slivers](#slivers)
- [تقنيات متقدمة](#تقنيات-متقدمة)
- [أمثلة عملية](#أمثلة-عملية)
- [أفضل الممارسات](#أفضل-الممارسات)
- [المراجع](#المراجع)

---

## نظرة عامة

التمرير في Flutter يسمح بعرض محتوى أكبر من حجم الشاشة. Flutter يوفر مجموعة قوية من ويدجت التمرير المحسّنة للأداء.

---

## أنواع ويدجت التمرير

### 1. ListView

القائمة القابلة للتمرير الأكثر استخداماً.

```dart
// ListView بسيط
ListView(
  padding: EdgeInsets.all(16),
  children: [
    ListTile(
      leading: Icon(Icons.map),
      title: Text('الخريطة'),
    ),
    ListTile(
      leading: Icon(Icons.photo_album),
      title: Text('الألبوم'),
    ),
    ListTile(
      leading: Icon(Icons.phone),
      title: Text('الهاتف'),
    ),
  ],
)

// ListView.builder - للقوائم الطويلة (الأفضل للأداء)
ListView.builder(
  itemCount: 1000,
  itemBuilder: (context, index) {
    return ListTile(
      leading: CircleAvatar(
        child: Text('${index + 1}'),
      ),
      title: Text('عنصر ${index + 1}'),
      subtitle: Text('وصف العنصر ${index + 1}'),
      trailing: Icon(Icons.arrow_forward_ios),
      onTap: () {
        print('تم النقر على العنصر $index');
      },
    );
  },
)

// ListView.separated - مع فواصل
ListView.separated(
  itemCount: 50,
  separatorBuilder: (context, index) {
    // فاصل مخصص كل 5 عناصر
    if ((index + 1) % 5 == 0) {
      return Divider(
        color: Colors.blue,
        thickness: 2,
        height: 20,
      );
    }
    return Divider();
  },
  itemBuilder: (context, index) {
    return ListTile(
      title: Text('عنصر ${index + 1}'),
    );
  },
)

// ListView أفقي
ListView.builder(
  scrollDirection: Axis.horizontal,
  itemCount: 20,
  itemBuilder: (context, index) {
    return Container(
      width: 160,
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.primaries[index % Colors.primaries.length],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          'عنصر $index',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  },
)
```

### 2. GridView

عرض شبكي قابل للتمرير.

```dart
// GridView.count - عدد ثابت من الأعمدة
GridView.count(
  crossAxisCount: 3,
  mainAxisSpacing: 10,
  crossAxisSpacing: 10,
  padding: EdgeInsets.all(10),
  children: List.generate(100, (index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.primaries[index % Colors.primaries.length],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          '$index',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }),
)

// GridView.extent - حجم محدد للخلايا
GridView.extent(
  maxCrossAxisExtent: 150,
  mainAxisSpacing: 10,
  crossAxisSpacing: 10,
  childAspectRatio: 1.0, // نسبة 1:1 (مربع)
  children: [
    _buildGridItem('العنصر 1', Icons.home),
    _buildGridItem('العنصر 2', Icons.star),
    _buildGridItem('العنصر 3', Icons.favorite),
  ],
)

// GridView.builder - بناء ديناميكي
GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    childAspectRatio: 0.75,
    mainAxisSpacing: 10,
    crossAxisSpacing: 10,
  ),
  itemCount: 50,
  itemBuilder: (context, index) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Image.network(
              'https://picsum.photos/200/300?random=$index',
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'منتج ${index + 1}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '\$${(index + 1) * 10}',
                  style: TextStyle(color: Colors.green),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  },
)

// GridView مخصص مع SliverGridDelegate
GridView.builder(
  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
    maxCrossAxisExtent: 200,
    childAspectRatio: 3 / 2,
    crossAxisSpacing: 20,
    mainAxisSpacing: 20,
  ),
  itemBuilder: (context, index) => Container(
    color: Colors.amber,
    child: Center(child: Text('عنصر $index')),
  ),
)
```

### 3. SingleChildScrollView

تمرير عنصر واحد (للمحتوى الصغير).

```dart
SingleChildScrollView(
  // اتجاه التمرير
  scrollDirection: Axis.vertical,
  
  // الحشو
  padding: EdgeInsets.all(16),
  
  // الفيزياء
  physics: BouncingScrollPhysics(), // iOS-style
  physics: ClampingScrollPhysics(), // Android-style
  physics: NeverScrollableScrollPhysics(), // منع التمرير
  
  child: Column(
    children: [
      Container(height: 200, color: Colors.red),
      Container(height: 200, color: Colors.green),
      Container(height: 200, color: Colors.blue),
      Container(height: 200, color: Colors.yellow),
      Container(height: 200, color: Colors.purple),
    ],
  ),
)

// تمرير أفقي
SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  child: Row(
    children: List.generate(
      10,
      (index) => Container(
        width: 200,
        height: 150,
        margin: EdgeInsets.all(8),
        color: Colors.primaries[index],
        child: Center(child: Text('$index')),
      ),
    ),
  ),
)
```

### 4. PageView

تمرير صفحات كاملة.

```dart
class PageViewExample extends StatefulWidget {
  @override
  _PageViewExampleState createState() => _PageViewExampleState();
}

class _PageViewExampleState extends State<PageViewExample> {
  int _currentPage = 0;
  final PageController _pageController = PageController();
  
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            children: [
              _buildPage('الصفحة 1', Colors.red),
              _buildPage('الصفحة 2', Colors.green),
              _buildPage('الصفحة 3', Colors.blue),
              _buildPage('الصفحة 4', Colors.purple),
            ],
          ),
        ),
        
        // مؤشر الصفحات
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(4, (index) {
            return Container(
              width: 8,
              height: 8,
              margin: EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentPage == index ? Colors.blue : Colors.grey,
              ),
            );
          }),
        ),
        
        SizedBox(height: 20),
      ],
    );
  }
  
  Widget _buildPage(String title, Color color) {
    return Container(
      color: color,
      child: Center(
        child: Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: 32),
        ),
      ),
    );
  }
}

// PageView.builder
PageView.builder(
  itemCount: 10,
  itemBuilder: (context, index) {
    return Center(
      child: Text(
        'صفحة ${index + 1}',
        style: TextStyle(fontSize: 32),
      ),
    );
  },
)

// PageView عمودي
PageView(
  scrollDirection: Axis.vertical,
  children: pages,
)
```

### 5. CustomScrollView

تمرير مخصص مع Slivers.

```dart
CustomScrollView(
  slivers: [
    // شريط تطبيق قابل للطي
    SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text('عنوان التطبيق'),
        background: Image.network(
          'https://picsum.photos/400/200',
          fit: BoxFit.cover,
        ),
      ),
    ),
    
    // قائمة
    SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => ListTile(
          leading: Icon(Icons.message),
          title: Text('رسالة ${index + 1}'),
        ),
        childCount: 20,
      ),
    ),
    
    // شبكة
    SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.0,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) => Container(
          color: Colors.primaries[index % Colors.primaries.length],
          child: Center(child: Text('$index')),
        ),
        childCount: 10,
      ),
    ),
  ],
)
```

---

## ScrollController

التحكم في التمرير برمجياً.

```dart
class ScrollControllerExample extends StatefulWidget {
  @override
  _ScrollControllerExampleState createState() => _ScrollControllerExampleState();
}

class _ScrollControllerExampleState extends State<ScrollControllerExample> {
  final ScrollController _scrollController = ScrollController();
  bool _showBackToTopButton = false;
  
  @override
  void initState() {
    super.initState();
    
    // الاستماع للتمرير
    _scrollController.addListener(() {
      // إظهار زر العودة للأعلى
      if (_scrollController.offset >= 400) {
        if (!_showBackToTopButton) {
          setState(() {
            _showBackToTopButton = true;
          });
        }
      } else {
        if (_showBackToTopButton) {
          setState(() {
            _showBackToTopButton = false;
          });
        }
      }
      
      // معلومات التمرير
      print('الموضع: ${_scrollController.offset}');
      print('أقصى تمرير: ${_scrollController.position.maxScrollExtent}');
      print('أقل تمرير: ${_scrollController.position.minScrollExtent}');
    });
  }
  
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  
  // التمرير للأعلى
  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
  
  // التمرير للأسفل
  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
  
  // التمرير لموضع محدد
  void _scrollToIndex(int index) {
    double position = index * 100.0; // افترض كل عنصر 100 بكسل
    _scrollController.animateTo(
      position,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ScrollController'),
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_upward),
            onPressed: _scrollToTop,
          ),
          IconButton(
            icon: Icon(Icons.arrow_downward),
            onPressed: _scrollToBottom,
          ),
        ],
      ),
      
      body: ListView.builder(
        controller: _scrollController,
        itemCount: 100,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(child: Text('${index + 1}')),
            title: Text('عنصر ${index + 1}'),
            onTap: () => _scrollToIndex(index),
          );
        },
      ),
      
      floatingActionButton: _showBackToTopButton
          ? FloatingActionButton(
              onPressed: _scrollToTop,
              child: Icon(Icons.arrow_upward),
            )
          : null,
    );
  }
}
```

---

## Slivers

Slivers هي أجزاء قابلة للتمرير يمكن دمجها في CustomScrollView.

### 1. SliverAppBar

شريط تطبيق قابل للطي.

```dart
SliverAppBar(
  // الارتفاع الموسع
  expandedHeight: 200,
  
  // تثبيت عند التمرير
  pinned: true,
  
  // عائم
  floating: false,
  
  // snap (يتطلب floating: true)
  snap: false,
  
  // المحتوى المرن
  flexibleSpace: FlexibleSpaceBar(
    title: Text('عنوان'),
    background: Stack(
      fit: StackFit.expand,
      children: [
        Image.network(
          'https://picsum.photos/400/200',
          fit: BoxFit.cover,
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black54,
              ],
            ),
          ),
        ),
      ],
    ),
    centerTitle: true,
    collapseMode: CollapseMode.parallax,
  ),
  
  // الإجراءات
  actions: [
    IconButton(icon: Icon(Icons.search), onPressed: () {}),
    IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
  ],
)
```

### 2. SliverList

قائمة داخل CustomScrollView.

```dart
SliverList(
  delegate: SliverChildBuilderDelegate(
    (context, index) {
      return ListTile(
        leading: Icon(Icons.message),
        title: Text('رسالة ${index + 1}'),
        subtitle: Text('محتوى الرسالة'),
      );
    },
    childCount: 50,
  ),
)

// SliverList مع أطفال ثابتة
SliverList(
  delegate: SliverChildListDelegate([
    ListTile(title: Text('عنصر 1')),
    ListTile(title: Text('عنصر 2')),
    ListTile(title: Text('عنصر 3')),
  ]),
)
```

### 3. SliverGrid

شبكة داخل CustomScrollView.

```dart
SliverGrid(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 3,
    mainAxisSpacing: 10,
    crossAxisSpacing: 10,
    childAspectRatio: 1.0,
  ),
  delegate: SliverChildBuilderDelegate(
    (context, index) {
      return Container(
        color: Colors.primaries[index % Colors.primaries.length],
        child: Center(
          child: Text(
            '$index',
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
        ),
      );
    },
    childCount: 30,
  ),
)
```

### 4. SliverToBoxAdapter

تحويل ويدجت عادية لـ Sliver.

```dart
SliverToBoxAdapter(
  child: Container(
    height: 200,
    color: Colors.blue,
    child: Center(
      child: Text(
        'محتوى ثابت',
        style: TextStyle(color: Colors.white, fontSize: 24),
      ),
    ),
  ),
)
```

### 5. SliverPadding

إضافة حشو حول Sliver.

```dart
SliverPadding(
  padding: EdgeInsets.all(20),
  sliver: SliverList(
    delegate: SliverChildBuilderDelegate(
      (context, index) => ListTile(title: Text('عنصر $index')),
      childCount: 20,
    ),
  ),
)
```

---

## تقنيات متقدمة

### 1. RefreshIndicator

السحب للتحديث.

```dart
class RefreshExample extends StatefulWidget {
  @override
  _RefreshExampleState createState() => _RefreshExampleState();
}

class _RefreshExampleState extends State<RefreshExample> {
  List<String> items = List.generate(20, (i) => 'عنصر ${i + 1}');
  
  Future<void> _refresh() async {
    // محاكاة تحميل البيانات
    await Future.delayed(Duration(seconds: 2));
    
    setState(() {
      items = List.generate(20, (i) => 'عنصر محدث ${i + 1}');
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refresh,
      color: Colors.blue,
      backgroundColor: Colors.white,
      strokeWidth: 3,
      child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(items[index]),
          );
        },
      ),
    );
  }
}
```

### 2. NotificationListener

الاستماع لإشعارات التمرير.

```dart
NotificationListener<ScrollNotification>(
  onNotification: (ScrollNotification notification) {
    if (notification is ScrollStartNotification) {
      print('بدأ التمرير');
    } else if (notification is ScrollUpdateNotification) {
      print('جاري التمرير: ${notification.metrics.pixels}');
    } else if (notification is ScrollEndNotification) {
      print('انتهى التمرير');
    } else if (notification is OverscrollNotification) {
      print('تجاوز الحدود');
    }
    
    return true; // منع انتشار الإشعار للأعلى
  },
  child: ListView.builder(
    itemCount: 50,
    itemBuilder: (context, index) => ListTile(title: Text('عنصر $index')),
  ),
)
```

### 3. NestedScrollView

تمرير متداخل (AppBar + TabBar + Content).

```dart
class NestedScrollExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              title: Text('عنوان'),
              pinned: true,
              floating: true,
              forceElevated: innerBoxIsScrolled,
              bottom: TabBar(
                tabs: [
                  Tab(text: 'تبويب 1'),
                  Tab(text: 'تبويب 2'),
                  Tab(text: 'تبويب 3'),
                ],
              ),
            ),
          ];
        },
        body: TabBarView(
          children: [
            _buildList('تبويب 1'),
            _buildList('تبويب 2'),
            _buildList('تبويب 3'),
          ],
        ),
      ),
    );
  }
  
  Widget _buildList(String name) {
    return ListView.builder(
      itemCount: 30,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('$name - عنصر ${index + 1}'),
        );
      },
    );
  }
}
```

---

## أمثلة عملية

### تطبيق أخبار مع تمرير متقدم

```dart
class NewsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // شريط التطبيق القابل للطي
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('أخبار اليوم'),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    'https://picsum.photos/400/250',
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black87],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // الأخبار العاجلة (أفقي)
          SliverToBoxAdapter(
            child: Container(
              height: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'أخبار عاجلة',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Container(
                          width: 300,
                          margin: EdgeInsets.symmetric(horizontal: 8),
                          child: Card(
                            clipBehavior: Clip.antiAlias,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.network(
                                  'https://picsum.photos/300/150?random=$index',
                                  fit: BoxFit.cover,
                                ),
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors.black87,
                                        ],
                                      ),
                                    ),
                                    child: Text(
                                      'خبر عاجل ${index + 1}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // عنوان القسم
          SliverPadding(
            padding: EdgeInsets.all(16),
            sliver: SliverToBoxAdapter(
              child: Text(
                'جميع الأخبار',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          
          // قائمة الأخبار
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Card(
                    margin: EdgeInsets.only(bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(4),
                          ),
                          child: Image.network(
                            'https://picsum.photos/400/200?random=${index + 10}',
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'عنوان الخبر ${index + 1}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'وصف مختصر للخبر يوضح المحتوى الأساسي بشكل سريع...',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.access_time, size: 16, color: Colors.grey),
                                  SizedBox(width: 4),
                                  Text(
                                    'منذ ${index + 1} ساعة',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
                childCount: 20,
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

### 1. الأداء

```dart
// ✅ استخدم builder للقوائم الطويلة
ListView.builder(
  itemCount: 10000,
  itemBuilder: (context, index) => ListTile(title: Text('$index')),
)

// ❌ لا تستخدم children للقوائم الطويلة
ListView(
  children: List.generate(10000, (i) => ListTile(title: Text('$i'))),
)
```

### 2. التخلص من المتحكمات

```dart
@override
void dispose() {
  _scrollController.dispose();
  _pageController.dispose();
  super.dispose();
}
```

### 3. الفيزياء المناسبة

```dart
// iOS
physics: BouncingScrollPhysics()

// Android
physics: ClampingScrollPhysics()

// دائماً قابل للتمرير
physics: AlwaysScrollableScrollPhysics()

// منع التمرير
physics: NeverScrollableScrollPhysics()
```

---

## المراجع

### التوثيق الرسمي

1. **Scrolling Widgets**  
   [https://docs.flutter.dev/cookbook/lists](https://docs.flutter.dev/cookbook/lists)

2. **Slivers Explained**  
   [https://docs.flutter.dev/development/ui/advanced/slivers](https://docs.flutter.dev/development/ui/advanced/slivers)

3. **ScrollController**  
   [https://api.flutter.dev/flutter/widgets/ScrollController-class.html](https://api.flutter.dev/flutter/widgets/ScrollController-class.html)

4. **CustomScrollView**  
   [https://api.flutter.dev/flutter/widgets/CustomScrollView-class.html](https://api.flutter.dev/flutter/widgets/CustomScrollView-class.html)

5. **Slivers Demystified**  
   [https://medium.com/flutter/slivers-demystified-6ff68ab0296f](https://medium.com/flutter/slivers-demystified-6ff68ab0296f)

---

[← العودة للفهرس الرئيسي](README.md)
[السابق: Painting and Effects](11_painting_effects.md)
[التالي: Styling →](13_styling.md)

---

**آخر تحديث:** نوفمبر 2025  
**مستوى:** متقدم - احترافي
