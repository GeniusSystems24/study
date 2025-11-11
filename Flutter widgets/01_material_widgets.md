# Material Widgets - ويدجت Material Design 3

[← العودة للفهرس الرئيسي](README.md)

## 📋 المحتويات

- [نظرة عامة](#نظرة-عامة)
- [فلسفة Material Design](#فلسفة-material-design)
- [التصنيفات الرئيسية](#التصنيفات-الرئيسية)
  - [الأزرار (Buttons)](#الأزرار-buttons)
  - [البطاقات والأسطح (Cards & Surfaces)](#البطاقات-والأسطح-cards--surfaces)
  - [التنقل (Navigation)](#التنقل-navigation)
  - [الإدخال والنماذج (Input & Forms)](#الإدخال-والنماذج-input--forms)
  - [الحوارات والأوراق السفلية (Dialogs & Bottom Sheets)](#الحوارات-والأوراق-السفلية-dialogs--bottom-sheets)
  - [المؤشرات (Indicators)](#المؤشرات-indicators)
  - [القوائم والشبكات (Lists & Grids)](#القوائم-والشبكات-lists--grids)
- [أمثلة متقدمة](#أمثلة-متقدمة)
- [أفضل الممارسات](#أفضل-الممارسات)
- [المراجع](#المراجع)

---

## نظرة عامة

**Material Design** هو نظام تصميم مرئي شامل طورته Google يجمع بين مبادئ التصميم الكلاسيكي والابتكار التقني. يوفر Flutter تطبيقاً كاملاً لمواصفات **Material 3** (المعروف أيضاً بـ Material You) من خلال مجموعة واسعة من الويدجت الجاهزة.

### لماذا Material Widgets؟

- ✅ **اتساق التصميم**: تجربة مستخدم موحدة عبر التطبيق
- ✅ **إمكانية الوصول**: دعم مدمج للقراءة الشاشية والتنقل بلوحة المفاتيح
- ✅ **التخصيص**: نظام ثيمات قوي مع دعم الوضع الليلي
- ✅ **الحركة**: رسوم متحركة وانتقالات سلسة مدمجة
- ✅ **الاستجابة**: تصميمات تتكيف مع مختلف أحجام الشاشات

---

## فلسفة Material Design

### المبادئ الأساسية

#### 1. **Material as Metaphor** - المادة كاستعارة

Material هو استعارة للسطح الفيزيائي. العناصر لها سُمك (elevation)، تلقي ظلالاً، ولا يمكن أن تمر عبر بعضها.

```dart
Card(
  elevation: 4.0, // ارتفاع البطاقة عن السطح
  child: Container(
    padding: EdgeInsets.all(16.0),
    child: Text('بطاقة مع ظل'),
  ),
)
```

#### 2. **Bold, Graphic, Intentional** - جريء، رسومي، مقصود

استخدام جريء للألوان، الصور، والطباعة لخلق تسلسل هرمي واضح.

```dart
Theme(
  data: ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.deepPurple,
      brightness: Brightness.light,
    ),
    useMaterial3: true,
  ),
  child: MyApp(),
)
```

#### 3. **Motion Provides Meaning** - الحركة توفر المعنى

الحركة توجه الانتباه وتحافظ على الاستمرارية، تقدم ملاحظات وتوضح العلاقات المكانية.

---

## التصنيفات الرئيسية

### الأزرار (Buttons)

Material 3 يوفر 5 أنواع رئيسية من الأزرار، كل منها لحالة استخدام محددة:

#### 1. **ElevatedButton** - للإجراءات الأساسية

```dart
ElevatedButton(
  onPressed: () {
    // الإجراء الأساسي
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: Theme.of(context).colorScheme.primary,
    foregroundColor: Theme.of(context).colorScheme.onPrimary,
    elevation: 2,
    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
  child: Text('زر مرتفع'),
)
```

**متى تستخدمه:** الإجراء الأساسي في الشاشة، يحتاج لبروز بصري عالي.

#### 2. **FilledButton** - الإجراء الأكثر أهمية (جديد في M3)

```dart
FilledButton(
  onPressed: () => {},
  style: FilledButton.styleFrom(
    backgroundColor: Theme.of(context).colorScheme.primary,
    minimumSize: Size(200, 48),
  ),
  child: Text('حفظ التغييرات'),
)
```

**متى تستخدمه:** الإجراء الأكثر أهمية في السياق الحالي (مثل "حفظ" أو "متابعة").

#### 3. **OutlinedButton** - للإجراءات الثانوية

```dart
OutlinedButton(
  onPressed: () => {},
  style: OutlinedButton.styleFrom(
    side: BorderSide(
      color: Theme.of(context).colorScheme.outline,
      width: 1,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
  child: Text('إلغاء'),
)
```

**متى تستخدمه:** إجراءات ثانوية أو بديلة، خاصة إلى جانب الأزرار المملوءة.

#### 4. **TextButton** - للإجراءات الأقل أهمية

```dart
TextButton(
  onPressed: () => {},
  child: Text('تخطي'),
)
```

**متى تستخدمه:** إجراءات منخفضة الأهمية، روابط، أو داخل الحوارات.

#### 5. **IconButton** - للإجراءات بدون نص

```dart
IconButton(
  icon: Icon(Icons.favorite_border),
  selectedIcon: Icon(Icons.favorite),
  isSelected: isFavorite,
  onPressed: () {
    setState(() => isFavorite = !isFavorite);
  },
  tooltip: 'إضافة للمفضلة',
)
```

#### 6. **FloatingActionButton** - للإجراء الأساسي العائم

```dart
FloatingActionButton(
  onPressed: () => {},
  tooltip: 'إضافة عنصر جديد',
  child: Icon(Icons.add),
)

// FAB ممتد مع نص
FloatingActionButton.extended(
  onPressed: () => {},
  icon: Icon(Icons.add),
  label: Text('إنشاء جديد'),
)
```

---

### البطاقات والأسطح (Cards & Surfaces)

#### 1. **Card** - بطاقات المحتوى

```dart
Card(
  elevation: 2,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  ),
  clipBehavior: Clip.antiAlias,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // صورة البطاقة
      Image.network(
        'https://example.com/image.jpg',
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
      
      // محتوى البطاقة
      Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'عنوان البطاقة',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 8),
            Text(
              'وصف البطاقة يوضح المحتوى بشكل مختصر',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
      
      // أزرار الإجراءات
      ButtonBar(
        children: [
          TextButton(
            onPressed: () => {},
            child: Text('إجراء 1'),
          ),
          TextButton(
            onPressed: () => {},
            child: Text('إجراء 2'),
          ),
        ],
      ),
    ],
  ),
)
```

#### 2. **Surface** - الأسطح المخصصة

```dart
Material(
  color: Theme.of(context).colorScheme.surface,
  elevation: 4,
  borderRadius: BorderRadius.circular(16),
  child: InkWell(
    onTap: () => {},
    borderRadius: BorderRadius.circular(16),
    child: Container(
      padding: EdgeInsets.all(24),
      child: Text('سطح تفاعلي'),
    ),
  ),
)
```

---

### التنقل (Navigation)

#### 1. **AppBar** - شريط التطبيق العلوي

```dart
AppBar(
  // الارتفاع التلقائي
  elevation: 0,
  
  // سطح شفاف (M3)
  surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
  
  // الأيقونة اليسرى
  leading: IconButton(
    icon: Icon(Icons.menu),
    onPressed: () => {},
  ),
  
  // العنوان
  title: Text('عنوان الشاشة'),
  
  // توسيط العنوان
  centerTitle: true,
  
  // إجراءات يمينية
  actions: [
    IconButton(
      icon: Icon(Icons.search),
      onPressed: () => {},
    ),
    IconButton(
      icon: Icon(Icons.more_vert),
      onPressed: () => {},
    ),
  ],
)
```

#### 2. **NavigationBar** - شريط التنقل السفلي (M3)

```dart
class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: const <NavigationDestination>[
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'الرئيسية',
          ),
          NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search),
            label: 'البحث',
          ),
          NavigationDestination(
            icon: Badge(
              label: Text('3'),
              child: Icon(Icons.notifications_outlined),
            ),
            selectedIcon: Badge(
              label: Text('3'),
              child: Icon(Icons.notifications),
            ),
            label: 'الإشعارات',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'الملف الشخصي',
          ),
        ],
      ),
      body: <Widget>[
        HomePage(),
        SearchPage(),
        NotificationsPage(),
        ProfilePage(),
      ][currentPageIndex],
    );
  }
}
```

#### 3. **NavigationRail** - شريط التنقل الجانبي

```dart
NavigationRail(
  selectedIndex: selectedIndex,
  onDestinationSelected: (int index) {
    setState(() => selectedIndex = index);
  },
  labelType: NavigationRailLabelType.all,
  leading: FloatingActionButton(
    onPressed: () {},
    child: Icon(Icons.add),
  ),
  destinations: [
    NavigationRailDestination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home),
      label: Text('الرئيسية'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.search),
      label: Text('البحث'),
    ),
  ],
)
```

#### 4. **Drawer** - القائمة الجانبية

```dart
Drawer(
  child: ListView(
    padding: EdgeInsets.zero,
    children: [
      // رأس القائمة
      UserAccountsDrawerHeader(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
        ),
        accountName: Text(
          'محمد أحمد',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
        accountEmail: Text(
          'mohamed@example.com',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
        currentAccountPicture: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: Text(
            'م',
            style: TextStyle(fontSize: 40.0),
          ),
        ),
      ),
      
      // عناصر القائمة
      ListTile(
        leading: Icon(Icons.home),
        title: Text('الرئيسية'),
        onTap: () => Navigator.pop(context),
      ),
      ListTile(
        leading: Icon(Icons.settings),
        title: Text('الإعدادات'),
        onTap: () {},
      ),
      Divider(),
      ListTile(
        leading: Icon(Icons.logout),
        title: Text('تسجيل الخروج'),
        onTap: () {},
      ),
    ],
  ),
)
```

---

### الإدخال والنماذج (Input & Forms)

#### 1. **TextField** - حقل النص الأساسي

```dart
TextField(
  decoration: InputDecoration(
    // التسمية العائمة
    labelText: 'البريد الإلكتروني',
    
    // النص المساعد
    helperText: 'أدخل بريدك الإلكتروني',
    
    // الأيقونة الأمامية
    prefixIcon: Icon(Icons.email),
    
    // الأيقونة الخلفية
    suffixIcon: IconButton(
      icon: Icon(Icons.clear),
      onPressed: () => controller.clear(),
    ),
    
    // الحدود
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    
    // الحدود عند التركيز
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        color: Theme.of(context).colorScheme.primary,
        width: 2,
      ),
    ),
  ),
  
  // المتحكم
  controller: emailController,
  
  // نوع لوحة المفاتيح
  keyboardType: TextInputType.emailAddress,
  
  // إجراء لوحة المفاتيح
  textInputAction: TextInputAction.next,
  
  // التحقق
  onChanged: (value) {
    // التحقق الفوري
  },
)
```

#### 2. **TextFormField** - حقل النص مع التحقق

```dart
Form(
  key: _formKey,
  child: Column(
    children: [
      TextFormField(
        decoration: InputDecoration(
          labelText: 'اسم المستخدم',
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'الرجاء إدخال اسم المستخدم';
          }
          if (value.length < 3) {
            return 'اسم المستخدم يجب أن يكون 3 أحرف على الأقل';
          }
          return null;
        },
      ),
      
      SizedBox(height: 16),
      
      TextFormField(
        decoration: InputDecoration(
          labelText: 'كلمة المرور',
          border: OutlineInputBorder(),
        ),
        obscureText: true,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'الرجاء إدخال كلمة المرور';
          }
          if (value.length < 6) {
            return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
          }
          return null;
        },
      ),
      
      SizedBox(height: 24),
      
      ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            // معالجة النموذج
          }
        },
        child: Text('تسجيل الدخول'),
      ),
    ],
  ),
)
```

#### 3. **Checkbox** - مربع الاختيار

```dart
CheckboxListTile(
  title: Text('قبول الشروط والأحكام'),
  subtitle: Text('الرجاء قراءة الشروط قبل الموافقة'),
  value: isChecked,
  onChanged: (bool? value) {
    setState(() {
      isChecked = value ?? false;
    });
  },
  secondary: Icon(Icons.article),
  controlAffinity: ListTileControlAffinity.leading,
)
```

#### 4. **Radio** - أزرار الاختيار

```dart
enum Gender { male, female, other }

Column(
  children: [
    RadioListTile<Gender>(
      title: Text('ذكر'),
      value: Gender.male,
      groupValue: selectedGender,
      onChanged: (Gender? value) {
        setState(() {
          selectedGender = value;
        });
      },
    ),
    RadioListTile<Gender>(
      title: Text('أنثى'),
      value: Gender.female,
      groupValue: selectedGender,
      onChanged: (Gender? value) {
        setState(() {
          selectedGender = value;
        });
      },
    ),
  ],
)
```

#### 5. **Switch** - مفتاح التبديل

```dart
SwitchListTile(
  title: Text('تفعيل الإشعارات'),
  subtitle: Text('تلقي إشعارات بالتحديثات الجديدة'),
  value: notificationsEnabled,
  onChanged: (bool value) {
    setState(() {
      notificationsEnabled = value;
    });
  },
  secondary: Icon(Icons.notifications),
)
```

#### 6. **Slider** - شريط التمرير

```dart
Column(
  children: [
    Text('مستوى الصوت: ${volume.round()}'),
    Slider(
      value: volume,
      min: 0,
      max: 100,
      divisions: 10,
      label: volume.round().toString(),
      onChanged: (double value) {
        setState(() {
          volume = value;
        });
      },
    ),
  ],
)
```

---

### الحوارات والأوراق السفلية (Dialogs & Bottom Sheets)

#### 1. **AlertDialog** - حوار التنبيه

```dart
Future<void> showAlertDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        icon: Icon(Icons.warning_amber_rounded),
        title: Text('تأكيد الحذف'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('هل أنت متأكد من حذف هذا العنصر؟'),
              Text('لا يمكن التراجع عن هذا الإجراء.'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('إلغاء'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FilledButton(
            child: Text('حذف'),
            onPressed: () {
              // تنفيذ الحذف
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
```

#### 2. **SimpleDialog** - حوار الاختيار

```dart
Future<void> showSimpleDialog(BuildContext context) async {
  final result = await showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: Text('اختر لغة التطبيق'),
        children: <Widget>[
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context, 'العربية');
            },
            child: ListTile(
              leading: Icon(Icons.language),
              title: Text('العربية'),
            ),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context, 'English');
            },
            child: ListTile(
              leading: Icon(Icons.language),
              title: Text('English'),
            ),
          ),
        ],
      );
    },
  );
  
  if (result != null) {
    print('اللغة المختارة: $result');
  }
}
```

#### 3. **BottomSheet** - الورقة السفلية

```dart
void showBottomSheet(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (BuildContext context) {
      return Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // مقبض السحب
            Container(
              width: 40,
              height: 4,
              margin: EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            ListTile(
              leading: Icon(Icons.share),
              title: Text('مشاركة'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.link),
              title: Text('نسخ الرابط'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.download),
              title: Text('تحميل'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    },
  );
}
```

---

### المؤشرات (Indicators)

#### 1. **CircularProgressIndicator** - مؤشر دائري

```dart
// مؤشر غير محدد
CircularProgressIndicator()

// مؤشر بنسبة محددة
CircularProgressIndicator(
  value: 0.7, // 70%
  backgroundColor: Colors.grey[200],
  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
)
```

#### 2. **LinearProgressIndicator** - مؤشر خطي

```dart
LinearProgressIndicator(
  value: 0.5, // 50%
  backgroundColor: Colors.grey[200],
  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
)
```

#### 3. **SnackBar** - شريط الإشعارات

```dart
void showSnackBar(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('تم حفظ التغييرات بنجاح'),
      action: SnackBarAction(
        label: 'تراجع',
        onPressed: () {
          // التراجع عن الإجراء
        },
      ),
      duration: Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
}
```

---

### القوائم والشبكات (Lists & Grids)

#### 1. **ListTile** - عنصر القائمة

```dart
ListTile(
  leading: CircleAvatar(
    backgroundImage: NetworkImage('https://example.com/avatar.jpg'),
  ),
  title: Text('أحمد محمد'),
  subtitle: Text('مطور Flutter'),
  trailing: Icon(Icons.arrow_forward_ios),
  onTap: () {
    // الانتقال للتفاصيل
  },
)
```

#### 2. **ExpansionTile** - قائمة قابلة للتوسيع

```dart
ExpansionTile(
  leading: Icon(Icons.folder),
  title: Text('المجلد الرئيسي'),
  children: <Widget>[
    ListTile(
      leading: Icon(Icons.file_present),
      title: Text('ملف 1'),
    ),
    ListTile(
      leading: Icon(Icons.file_present),
      title: Text('ملف 2'),
    ),
  ],
)
```

---

## أمثلة متقدمة

### مثال شامل: شاشة ملف شخصي

```dart
class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الملف الشخصي'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      
      body: SingleChildScrollView(
        child: Column(
          children: [
            // رأس الملف الشخصي
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.primaryContainer,
                  ],
                ),
              ),
              padding: EdgeInsets.all(24),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage('https://example.com/avatar.jpg'),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'محمد أحمد',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'مطور Flutter محترف',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ],
              ),
            ),
            
            // الإحصائيات
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(context, '150', 'متابِع'),
                  _buildStatItem(context, '200', 'متابَع'),
                  _buildStatItem(context, '50', 'منشور'),
                ],
              ),
            ),
            
            Divider(),
            
            // القائمة
            ListTile(
              leading: Icon(Icons.person),
              title: Text('تعديل الملف الشخصي'),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text('الإشعارات'),
              trailing: Badge(
                label: Text('3'),
                child: Icon(Icons.arrow_forward_ios, size: 16),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.security),
              title: Text('الخصوصية والأمان'),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStatItem(BuildContext context, String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
```

---

## أفضل الممارسات

### 1. استخدام Material 3

```dart
MaterialApp(
  theme: ThemeData(
    useMaterial3: true, // تفعيل Material 3
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.deepPurple,
    ),
  ),
  home: MyHomePage(),
)
```

### 2. نظام الألوان الديناميكي

```dart
// استخدام ألوان من الثيم بدلاً من الألوان الثابتة
Container(
  color: Theme.of(context).colorScheme.primaryContainer,
  child: Text(
    'نص',
    style: TextStyle(
      color: Theme.of(context).colorScheme.onPrimaryContainer,
    ),
  ),
)
```

### 3. إمكانية الوصول

```dart
// إضافة تلميحات للقراء الشاشية
IconButton(
  icon: Icon(Icons.delete),
  tooltip: 'حذف العنصر',
  onPressed: () {},
)

// استخدام Semantics
Semantics(
  label: 'زر الإعجاب',
  hint: 'اضغط للإعجاب بالمنشور',
  child: IconButton(
    icon: Icon(Icons.favorite_border),
    onPressed: () {},
  ),
)
```

### 4. الاستجابة

```dart
// استخدام LayoutBuilder للتكيف مع الأحجام
LayoutBuilder(
  builder: (context, constraints) {
    if (constraints.maxWidth > 600) {
      // تخطيط للشاشات الكبيرة
      return Row(children: [...]);
    } else {
      // تخطيط للشاشات الصغيرة
      return Column(children: [...]);
    }
  },
)
```

### 5. الأداء

```dart
// استخدام const للويدجت الثابتة
const Card(
  child: const ListTile(
    title: const Text('عنوان ثابت'),
  ),
)

// استخدام ListView.builder للقوائم الطويلة
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    return ListTile(title: Text(items[index]));
  },
)
```

---

## المراجع

### التوثيق الرسمي

1. **Flutter Material Widgets Catalog**  
   <https://docs.flutter.dev/ui/widgets/material>

2. **Material Design 3 Guidelines**  
   <https://m3.material.io/>

3. **Flutter Material Components**  
   <https://api.flutter.dev/flutter/material/material-library.html>

4. **Material Design Components**  
   <https://m3.material.io/components>

### مقالات ودروس متقدمة

5. **Migrating to Material 3**  
   <https://docs.flutter.dev/ui/design/material>

6. **Material Theme Builder**  
   <https://m3.material.io/theme-builder>

7. **Flutter Cookbook - Material Design**  
   <https://docs.flutter.dev/cookbook/design>

### أدوات مفيدة

8. **Material Color Tool**  
   <https://material.io/resources/color/>

9. **Material Icons**  
   <https://fonts.google.com/icons>

10. **Panache - Flutter Theme Editor**  
    <https://rxlabz.github.io/panache/>

### فيديوهات تعليمية

11. **Widget of the Week - Material Widgets Playlist**  
    <https://www.youtube.com/playlist?list=PLjxrf2q8roU23XGwz3Km7sQZFTdB996iG>

12. **Flutter in Focus - Material Design**  
    <https://www.youtube.com/playlist?list=PLjxrf2q8roU2HdJQDjJzOeO6J3FoFLWr2>

---

[← العودة للفهرس الرئيسي](README.md)
[التالي: Cupertino Widgets →](02_cupertino_widgets.md)

---

**آخر تحديث:** نوفمبر 2025  
**مستوى:** متقدم - احترافي
