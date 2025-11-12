# 20 - Card و ListTile

## 📋 المحتويات

- [المقدمة](#المقدمة)
- [Card Widget](#card-widget)
- [ListTile Widget](#listtile-widget)
- [ExpansionTile](#expansiontile)
- [أمثلة عملية](#أمثلة-عملية)

---

## 🎯 المقدمة

Card و ListTile من الـ Widgets الأساسية لعرض المحتوى بشكل منظم وجذاب.

---

## 📇 Card Widget

بطاقة بسيطة:

```dart
Card(
  child: Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'عنوان البطاقة',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text('محتوى البطاقة هنا...'),
      ],
    ),
  ),
);
```

### Card مخصصة

```dart
Card(
  elevation: 4,  // الظل
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  ),
  margin: const EdgeInsets.all(8),
  color: Colors.blue.shade50,
  child: InkWell(
    onTap: () {
      print('تم النقر على البطاقة');
    },
    borderRadius: BorderRadius.circular(12),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Icon(Icons.notifications, size: 40, color: Colors.blue),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'إشعار جديد',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text('لديك رسالة جديدة من أحمد'),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward, color: Colors.grey),
        ],
      ),
    ),
  ),
);
```

---

## 📝 ListTile Widget

ListTile بسيط:

```dart
ListTile(
  leading: const Icon(Icons.person),
  title: const Text('أحمد محمد'),
  subtitle: const Text('مطور تطبيقات'),
  trailing: const Icon(Icons.arrow_forward),
  onTap: () {
    print('تم النقر');
  },
);
```

### ListTile متقدم

```dart
ListTile(
  leading: CircleAvatar(
    backgroundColor: Colors.blue,
    child: const Text('أ'),
  ),
  title: const Text(
    'أحمد محمد',
    style: TextStyle(fontWeight: FontWeight.bold),
  ),
  subtitle: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: const [
      Text('مطور تطبيقات Flutter'),
      SizedBox(height: 4),
      Text(
        'متصل الآن',
        style: TextStyle(color: Colors.green, fontSize: 12),
      ),
    ],
  ),
  trailing: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      IconButton(
        icon: const Icon(Icons.message),
        onPressed: () {},
      ),
      IconButton(
        icon: const Icon(Icons.call),
        onPressed: () {},
      ),
    ],
  ),
  isThreeLine: true,
  onTap: () {},
);
```

### CheckboxListTile و SwitchListTile

```dart
// CheckboxListTile
bool isChecked = false;

CheckboxListTile(
  title: const Text('قبول الشروط والأحكام'),
  subtitle: const Text('يجب الموافقة للمتابعة'),
  value: isChecked,
  onChanged: (value) {
    setState(() {
      isChecked = value!;
    });
  },
  secondary: const Icon(Icons.check_circle),
);

// SwitchListTile
bool isEnabled = true;

SwitchListTile(
  title: const Text('الإشعارات'),
  subtitle: const Text('تلقي الإشعارات الفورية'),
  value: isEnabled,
  onChanged: (value) {
    setState(() {
      isEnabled = value;
    });
  },
  secondary: const Icon(Icons.notifications),
);
```

---

## 📂 ExpansionTile

قائمة قابلة للتوسيع:

```dart
ExpansionTile(
  leading: const Icon(Icons.folder),
  title: const Text('المستندات'),
  subtitle: const Text('3 ملفات'),
  children: const [
    ListTile(
      leading: Icon(Icons.insert_drive_file),
      title: Text('ملف 1.pdf'),
    ),
    ListTile(
      leading: Icon(Icons.insert_drive_file),
      title: Text('ملف 2.docx'),
    ),
    ListTile(
      leading: Icon(Icons.insert_drive_file),
      title: Text('ملف 3.xlsx'),
    ),
  ],
);
```

---

## 💼 أمثلة عملية

### قائمة جهات اتصال

```dart
class Contact {
  final String name;
  final String phone;
  final String email;
  final bool isFavorite;

  Contact({
    required this.name,
    required this.phone,
    required this.email,
    this.isFavorite = false,
  });
}

class ContactsList extends StatefulWidget {
  const ContactsList({super.key});

  @override
  State<ContactsList> createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
  final List<Contact> contacts = [
    Contact(name: 'أحمد محمد', phone: '0501234567', email: 'ahmed@email.com'),
    Contact(
        name: 'فاطمة علي',
        phone: '0507654321',
        email: 'fatima@email.com',
        isFavorite: true),
    Contact(name: 'محمد سالم', phone: '0509876543', email: 'mohammad@email.com'),
    Contact(name: 'نورة أحمد', phone: '0502468135', email: 'noura@email.com'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('جهات الاتصال')),
      body: ListView.separated(
        itemCount: contacts.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          final contact = contacts[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue,
                child: Text(
                  contact.name[0],
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              title: Text(
                contact.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.phone, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(contact.phone),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.email, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(contact.email),
                    ],
                  ),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (contact.isFavorite)
                    const Icon(Icons.star, color: Colors.amber),
                  IconButton(
                    icon: const Icon(Icons.message),
                    onPressed: () {},
                  ),
                ],
              ),
              isThreeLine: true,
              onTap: () {
                _showContactDetails(context, contact);
              },
            ),
          );
        },
      ),
    );
  }

  void _showContactDetails(BuildContext context, Contact contact) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blue,
                child: Text(
                  contact.name[0],
                  style: const TextStyle(fontSize: 40, color: Colors.white),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                contact.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.phone),
                title: Text(contact.phone),
                trailing: IconButton(
                  icon: const Icon(Icons.call),
                  onPressed: () {},
                ),
              ),
              ListTile(
                leading: const Icon(Icons.email),
                title: Text(contact.email),
                trailing: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
```

### بطاقات المنتجات

```dart
class Product {
  final String name;
  final double price;
  final String category;
  final int rating;
  final bool inStock;

  Product({
    required this.name,
    required this.price,
    required this.category,
    required this.rating,
    this.inStock = true,
  });
}

class ProductsGrid extends StatelessWidget {
  const ProductsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final products = [
      Product(
          name: 'هاتف ذكي',
          price: 2999,
          category: 'إلكترونيات',
          rating: 5),
      Product(name: 'حقيبة', price: 299, category: 'إكسسوارات', rating: 4),
      Product(
          name: 'ساعة ذكية',
          price: 899,
          category: 'إلكترونيات',
          rating: 4,
          inStock: false),
      Product(name: 'سماعات', price: 499, category: 'إلكترونيات', rating: 5),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('المنتجات')),
      body: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                        ),
                        child: const Center(
                          child: Icon(Icons.image, size: 60),
                        ),
                      ),
                      if (!product.inStock)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'نفذ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          product.category,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: List.generate(
                            5,
                            (index) => Icon(
                              index < product.rating
                                  ? Icons.star
                                  : Icons.star_border,
                              size: 16,
                              color: Colors.amber,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${product.price} ريال',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
```

### قائمة الإعدادات

```dart
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifications = true;
  bool _darkMode = false;
  bool _autoUpdate = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الإعدادات')),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'عام',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.notifications),
                  title: const Text('الإشعارات'),
                  subtitle: const Text('تلقي الإشعارات الفورية'),
                  value: _notifications,
                  onChanged: (value) {
                    setState(() {
                      _notifications = value;
                    });
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.dark_mode),
                  title: const Text('الوضع الداكن'),
                  subtitle: const Text('تفعيل المظهر الداكن'),
                  value: _darkMode,
                  onChanged: (value) {
                    setState(() {
                      _darkMode = value;
                    });
                  },
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'التحديثات',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.system_update),
                  title: const Text('التحديث التلقائي'),
                  value: _autoUpdate,
                  onChanged: (value) {
                    setState(() {
                      _autoUpdate = value;
                    });
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.info),
                  title: const Text('الإصدار'),
                  subtitle: const Text('1.0.0'),
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: () {},
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'الحساب',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('الملف الشخصي'),
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: () {},
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.lock),
                  title: const Text('الخصوصية'),
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: () {},
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text(
                    'تسجيل الخروج',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

---

## 📚 المراجع والمصادر

1. **Card**
   - [Card](https://api.flutter.dev/flutter/material/Card-class.html)
   - [Material Cards](https://m3.material.io/components/cards/overview)

2. **ListTile**
   - [ListTile](https://api.flutter.dev/flutter/material/ListTile-class.html)
   - [CheckboxListTile](https://api.flutter.dev/flutter/material/CheckboxListTile-class.html)
   - [SwitchListTile](https://api.flutter.dev/flutter/material/SwitchListTile-class.html)

3. **ExpansionTile**
   - [ExpansionTile](https://api.flutter.dev/flutter/material/ExpansionTile-class.html)

---

## 💡 نصائح

- ✅ Card مثالية لعرض محتوى منفصل
- ✅ ListTile موحدة للقوائم البسيطة
- ✅ استخدم `InkWell` مع Card لإضافة تفاعل
- ✅ `isThreeLine: true` للنصوص الطويلة
- ✅ ExpansionTile للمحتوى القابل للإخفاء

---

[⬅️ السابق: Theme](19_theme.md)
[🏠 العودة للفهرس](../README.md)
[التالي: State Management ➡️](../Level%203%20-%20State%20Management/21_state_management.md)
