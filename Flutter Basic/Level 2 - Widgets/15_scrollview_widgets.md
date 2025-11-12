# 15 - ScrollView Widgets

## 📋 المحتويات

- [المقدمة](#المقدمة)
- [SingleChildScrollView](#singlechildscrollview)
- [ListView](#listview)
- [GridView](#gridview)
- [PageView](#pageview)
- [CustomScrollView](#customscrollview)
- [أمثلة عملية](#أمثلة-عملية)

---

## 🎯 المقدمة

ScrollView Widgets تسمح بعرض محتوى أكبر من حجم الشاشة مع إمكانية التمرير.

---

## 📜 SingleChildScrollView

تمرير بسيط لعنصر واحد:

```dart
SingleChildScrollView(
  child: Column(
    children: [
      Container(height: 300, color: Colors.red),
      Container(height: 300, color: Colors.blue),
      Container(height: 300, color: Colors.green),
    ],
  ),
)

// تمرير أفقي
SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  child: Row(
    children: [
      Container(width: 200, height: 100, color: Colors.red),
      Container(width: 200, height: 100, color: Colors.blue),
      Container(width: 200, height: 100, color: Colors.green),
    ],
  ),
)
```

---

## 📋 ListView

### ListView بسيط

```dart
ListView(
  children: [
    ListTile(
      leading: Icon(Icons.person),
      title: Text('أحمد'),
      subtitle: Text('مطور تطبيقات'),
    ),
    ListTile(
      leading: Icon(Icons.person),
      title: Text('فاطمة'),
      subtitle: Text('مصممة UI/UX'),
    ),
  ],
)
```

### ListView.builder

الأكثر كفاءة للقوائم الطويلة:

```dart
ListView.builder(
  itemCount: 100,
  itemBuilder: (context, index) {
    return ListTile(
      leading: CircleAvatar(child: Text('${index + 1}')),
      title: Text('عنصر $index'),
      subtitle: Text('وصف العنصر $index'),
      trailing: Icon(Icons.arrow_forward_ios),
      onTap: () {
        print('تم النقر على العنصر $index');
      },
    );
  },
)
```

### ListView.separated

مع فواصل بين العناصر:

```dart
ListView.separated(
  itemCount: 50,
  separatorBuilder: (context, index) => Divider(),
  itemBuilder: (context, index) {
    return ListTile(
      title: Text('عنصر $index'),
    );
  },
)
```

---

## 🔲 GridView

### GridView.count

شبكة بعدد أعمدة ثابت:

```dart
GridView.count(
  crossAxisCount: 2,  // عدد الأعمدة
  crossAxisSpacing: 10,
  mainAxisSpacing: 10,
  padding: EdgeInsets.all(10),
  children: List.generate(20, (index) {
    return Container(
      color: Colors.primaries[index % Colors.primaries.length],
      child: Center(
        child: Text(
          '${index + 1}',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }),
)
```

### GridView.builder

```dart
GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 3,
    crossAxisSpacing: 8,
    mainAxisSpacing: 8,
    childAspectRatio: 1,
  ),
  itemCount: 30,
  padding: EdgeInsets.all(8),
  itemBuilder: (context, index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(child: Text('$index')),
    );
  },
)
```

### GridView.extent

شبكة بحجم أقصى للعنصر:

```dart
GridView.extent(
  maxCrossAxisExtent: 150,  // أقصى عرض للعنصر
  crossAxisSpacing: 10,
  mainAxisSpacing: 10,
  children: List.generate(20, (index) {
    return Card(
      child: Center(child: Text('عنصر $index')),
    );
  }),
)
```

---

## 📖 PageView

عرض الصفحات بالتمرير:

```dart
class PageViewDemo extends StatelessWidget {
  const PageViewDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return PageView(
      children: [
        Container(
          color: Colors.red,
          child: Center(
            child: Text(
              'الصفحة 1',
              style: TextStyle(color: Colors.white, fontSize: 32),
            ),
          ),
        ),
        Container(
          color: Colors.blue,
          child: Center(
            child: Text(
              'الصفحة 2',
              style: TextStyle(color: Colors.white, fontSize: 32),
            ),
          ),
        ),
        Container(
          color: Colors.green,
          child: Center(
            child: Text(
              'الصفحة 3',
              style: TextStyle(color: Colors.white, fontSize: 32),
            ),
          ),
        ),
      ],
    );
  }
}

// مع مؤشر الصفحة
class PageViewWithIndicator extends StatefulWidget {
  const PageViewWithIndicator({super.key});

  @override
  State<PageViewWithIndicator> createState() => _PageViewWithIndicatorState();
}

class _PageViewWithIndicatorState extends State<PageViewWithIndicator> {
  int _currentPage = 0;
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            children: [
              _buildPage('الصفحة 1', Colors.red),
              _buildPage('الصفحة 2', Colors.blue),
              _buildPage('الصفحة 3', Colors.green),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            return Container(
              margin: EdgeInsets.all(4),
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentPage == index
                    ? Colors.blue
                    : Colors.grey,
              ),
            );
          }),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildPage(String text, Color color) {
    return Container(
      color: color,
      child: Center(
        child: Text(
          text,
          style: TextStyle(color: Colors.white, fontSize: 32),
        ),
      ),
    );
  }
}
```

---

## 🎨 CustomScrollView

تمرير مخصص مع Slivers:

```dart
CustomScrollView(
  slivers: [
    SliverAppBar(
      expandedHeight: 200,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text('عنوان التطبيق'),
        background: Image.network(
          'https://via.placeholder.com/400x200',
          fit: BoxFit.cover,
        ),
      ),
    ),
    SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => ListTile(
          title: Text('عنصر $index'),
        ),
        childCount: 20,
      ),
    ),
    SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) => Container(
          color: Colors.blue.shade100,
          child: Center(child: Text('$index')),
        ),
        childCount: 10,
      ),
    ),
  ],
)
```

---

## 💼 أمثلة عملية

### قائمة جهات الاتصال

```dart
class ContactsList extends StatelessWidget {
  final List<Contact> contacts = List.generate(
    50,
    (index) => Contact(
      name: 'جهة اتصال ${index + 1}',
      phone: '+966 50 ${index}00 ${index}000',
      email: 'contact$index@example.com',
    ),
  );

  ContactsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('جهات الاتصال')),
      body: ListView.separated(
        itemCount: contacts.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final contact = contacts[index];
          return ListTile(
            leading: CircleAvatar(
              child: Text(contact.name[0]),
            ),
            title: Text(contact.name),
            subtitle: Text(contact.phone),
            trailing: IconButton(
              icon: const Icon(Icons.phone),
              onPressed: () {},
            ),
            onTap: () {
              // عرض التفاصيل
            },
          );
        },
      ),
    );
  }
}

class Contact {
  final String name;
  final String phone;
  final String email;

  Contact({
    required this.name,
    required this.phone,
    required this.email,
  });
}
```

### شبكة منتجات

```dart
class ProductsGrid extends StatelessWidget {
  final List<Product> products = List.generate(
    20,
    (index) => Product(
      name: 'منتج ${index + 1}',
      price: (index + 1) * 50.0,
      image: 'https://via.placeholder.com/200',
    ),
  );

  ProductsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('المنتجات')),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.75,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Image.network(
                    product.image,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${product.price} ريال',
                        style: const TextStyle(
                          color: Colors.green,
                          fontSize: 16,
                        ),
                      ),
                    ],
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

class Product {
  final String name;
  final double price;
  final String image;

  Product({
    required this.name,
    required this.price,
    required this.image,
  });
}
```

---

## 📚 المراجع والمصادر

1. **ScrollView Widgets**
   - [Scrolling](https://docs.flutter.dev/development/ui/widgets/scrolling)
   - [SingleChildScrollView](https://api.flutter.dev/flutter/widgets/SingleChildScrollView-class.html)
   - [ListView](https://api.flutter.dev/flutter/widgets/ListView-class.html)
   - [GridView](https://api.flutter.dev/flutter/widgets/GridView-class.html)
   - [PageView](https://api.flutter.dev/flutter/widgets/PageView-class.html)
   - [CustomScrollView](https://api.flutter.dev/flutter/widgets/CustomScrollView-class.html)

---

## 💡 نصائح

- ✅ استخدم `ListView.builder` للقوائم الطويلة
- ✅ `GridView.builder` أكثر كفاءة من `GridView.count`
- ✅ استخدم `const` للعناصر الثابتة
- ✅ `PageView` مناسب للتعليمات التفاعلية
- ✅ `CustomScrollView` للتمرير المخصص المتقدم

---

[⬅️ السابق: Input Widgets](14_input_widgets.md)
[🏠 العودة للفهرس](../README.md)
[التالي: Dialog و SnackBar ➡️](16_dialog_snackbar.md)
