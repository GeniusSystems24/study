# Cupertino Widgets - ويدجت iOS/macOS

[← العودة للفهرس الرئيسي](README.md)

## 📋 المحتويات

- [نظرة عامة](#نظرة-عامة)
- [فلسفة التصميم](#فلسفة-التصميم)
- [التصنيفات الرئيسية](#التصنيفات-الرئيسية)
  - [الأزرار](#الأزرار)
  - [التنقل](#التنقل)
  - [الإدخال](#الإدخال)
  - [المختارات](#المختارات)
  - [الحوارات](#الحوارات)
  - [القوائم](#القوائم)
- [الفروقات عن Material](#الفروقات-عن-material)
- [أمثلة متقدمة](#أمثلة-متقدمة)
- [أفضل الممارسات](#أفضل-الممارسات)
- [المراجع](#المراجع)

---

## نظرة عامة

**Cupertino** هي مجموعة ويدجت Flutter التي تحاكي تصميم iOS و macOS بدقة عالية، متبعةً **Apple's Human Interface Guidelines (HIG)**. تقدم تجربة مستخدم أصيلة لمنصات Apple مع كل التفاصيل البصرية والسلوكية.

### لماذا Cupertino Widgets؟

- ✅ **مظهر iOS الأصلي**: تطابق كامل مع تصميم Apple
- ✅ **سلوك مألوف**: إيماءات وحركات معتادة لمستخدمي iOS
- ✅ **تكامل النظام**: يبدو التطبيق كجزء طبيعي من iOS/macOS
- ✅ **دعم الوضع الداكن**: تكيف تلقائي مع سمة النظام
- ✅ **الأداء**: محسّنة للأداء السلس على أجهزة Apple

---

## فلسفة التصميم

### مبادئ Apple HIG

#### 1. **الوضوح (Clarity)**

النص واضح وقابل للقراءة بجميع الأحجام، الأيقونات دقيقة ومعبرة، الزخارف دقيقة ومناسبة.

```dart
Text(
  'نص واضح',
  style: CupertinoTheme.of(context).textTheme.textStyle,
)
```

#### 2. **الاحترام (Deference)**

المحتوى يملأ الشاشة بالكامل، التدرجات الشفافة والضبابية تشير للسياق، الحركات الدقيقة توجه الانتباه.

```dart
CupertinoNavigationBar(
  backgroundColor: CupertinoColors.systemBackground.withOpacity(0.8),
  border: null,
  middle: Text('عنوان'),
)
```

#### 3. **العمق (Depth)**

الطبقات والحركة توفر عمقاً وتسلسلاً هرمياً، تساعد المستخدم على فهم العلاقات بين العناصر.

---

## التصنيفات الرئيسية

### الأزرار

#### 1. **CupertinoButton** - الزر الأساسي

```dart
// زر نصي بسيط
CupertinoButton(
  child: Text('اضغط هنا'),
  onPressed: () {
    print('تم الضغط');
  },
)

// زر بخلفية ملونة
CupertinoButton.filled(
  child: Text('حفظ'),
  onPressed: () {},
)

// زر بحجم صغير
CupertinoButton(
  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  minSize: 0,
  child: Text('صغير'),
  onPressed: () {},
)
```

**الخصائص المتقدمة:**

```dart
CupertinoButton(
  // تعطيل الزر
  onPressed: isEnabled ? () {} : null,
  
  // لون مخصص
  color: CupertinoColors.activeBlue,
  
  // نصف قطر الحواف
  borderRadius: BorderRadius.circular(8),
  
  // الحشو
  padding: EdgeInsets.all(16),
  
  // الضغط الطويل
  onLongPress: () {},
  
  child: Text('زر متقدم'),
)
```

---

### التنقل

#### 1. **CupertinoNavigationBar** - شريط التنقل العلوي

```dart
CupertinoPageScaffold(
  navigationBar: CupertinoNavigationBar(
    // الحافة السفلية
    border: Border(
      bottom: BorderSide(
        color: CupertinoColors.systemGrey.withOpacity(0.3),
        width: 0.5,
      ),
    ),
    
    // الخلفية
    backgroundColor: CupertinoColors.systemBackground,
    
    // العنوان الوسطي
    middle: Text('الرئيسية'),
    
    // الزر الأيسر
    leading: CupertinoNavigationBarBackButton(
      onPressed: () => Navigator.pop(context),
    ),
    
    // الأزرار اليمينية
    trailing: CupertinoButton(
      padding: EdgeInsets.zero,
      child: Icon(CupertinoIcons.search),
      onPressed: () {},
    ),
    
    // شريط كبير (iOS 11+)
    previousPageTitle: 'رجوع',
  ),
  
  child: SafeArea(
    child: Center(child: Text('المحتوى')),
  ),
)
```

#### 2. **CupertinoSliverNavigationBar** - شريط قابل للطي

```dart
CustomScrollView(
  slivers: <Widget>[
    CupertinoSliverNavigationBar(
      // عنوان كبير
      largeTitle: Text('العنوان الكبير'),
      
      // الأزرار
      leading: CupertinoButton(
        padding: EdgeInsets.zero,
        child: Icon(CupertinoIcons.back),
        onPressed: () {},
      ),
      
      trailing: CupertinoButton(
        padding: EdgeInsets.zero,
        child: Icon(CupertinoIcons.add),
        onPressed: () {},
      ),
      
      // تمديد الخلفية
      stretch: true,
    ),
    
    SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => ListTile(title: Text('عنصر $index')),
        childCount: 50,
      ),
    ),
  ],
)
```

#### 3. **CupertinoTabScaffold** - التبويبات السفلية

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      home: CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.home),
              label: 'الرئيسية',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.search),
              label: 'البحث',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.person),
              label: 'الملف الشخصي',
            ),
          ],
          
          // اللون النشط
          activeColor: CupertinoColors.activeBlue,
          
          // اللون غير النشط
          inactiveColor: CupertinoColors.systemGrey,
          
          // لون الخلفية
          backgroundColor: CupertinoColors.systemBackground,
        ),
        
        tabBuilder: (BuildContext context, int index) {
          return CupertinoTabView(
            builder: (BuildContext context) {
              return CupertinoPageScaffold(
                navigationBar: CupertinoNavigationBar(
                  middle: Text('صفحة $index'),
                ),
                child: Center(
                  child: Text('محتوى التبويب $index'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
```

---

### الإدخال

#### 1. **CupertinoTextField** - حقل النص

```dart
CupertinoTextField(
  // العنصر النائب
  placeholder: 'أدخل النص هنا',
  
  // اللون
  decoration: BoxDecoration(
    color: CupertinoColors.systemGrey6,
    borderRadius: BorderRadius.circular(8),
    border: Border.all(
      color: CupertinoColors.systemGrey4,
      width: 1,
    ),
  ),
  
  // الحشو
  padding: EdgeInsets.all(12),
  
  // الأيقونة الأمامية
  prefix: Padding(
    padding: EdgeInsets.only(left: 8),
    child: Icon(
      CupertinoIcons.search,
      color: CupertinoColors.systemGrey,
    ),
  ),
  
  // زر المسح
  suffix: CupertinoButton(
    padding: EdgeInsets.zero,
    child: Icon(
      CupertinoIcons.clear_thick_circled,
      color: CupertinoColors.systemGrey,
    ),
    onPressed: () => controller.clear(),
  ),
  
  // المتحكم
  controller: controller,
  
  // نوع لوحة المفاتيح
  keyboardType: TextInputType.text,
  
  // التصحيح التلقائي
  autocorrect: true,
  
  // الاستماع للتغييرات
  onChanged: (value) {
    print('النص: $value');
  },
)
```

#### 2. **CupertinoSearchTextField** - حقل البحث

```dart
CupertinoSearchTextField(
  placeholder: 'ابحث...',
  controller: searchController,
  onChanged: (value) {
    // تنفيذ البحث
  },
  onSubmitted: (value) {
    // البحث عند الضغط على Enter
  },
)
```

---

### المختارات

#### 1. **CupertinoSwitch** - مفتاح التبديل

```dart
CupertinoSwitch(
  value: switchValue,
  onChanged: (bool value) {
    setState(() {
      switchValue = value;
    });
  },
  
  // اللون النشط
  activeColor: CupertinoColors.activeGreen,
  
  // لون المسار
  trackColor: CupertinoColors.systemGrey5,
)

// في قائمة
CupertinoListTile(
  title: Text('تفعيل الإشعارات'),
  trailing: CupertinoSwitch(
    value: notificationsEnabled,
    onChanged: (value) {
      setState(() => notificationsEnabled = value);
    },
  ),
)
```

#### 2. **CupertinoSlider** - شريط التمرير

```dart
Column(
  children: [
    Text('مستوى الصوت: ${volume.round()}'),
    CupertinoSlider(
      value: volume,
      min: 0,
      max: 100,
      divisions: 10,
      activeColor: CupertinoColors.activeBlue,
      onChanged: (double value) {
        setState(() {
          volume = value;
        });
      },
    ),
  ],
)
```

#### 3. **CupertinoPicker** - المنتقي الدوار

```dart
void showPicker(BuildContext context) {
  showCupertinoModalPopup(
    context: context,
    builder: (BuildContext context) {
      return Container(
        height: 250,
        color: CupertinoColors.systemBackground,
        child: SafeArea(
          top: false,
          child: CupertinoPicker(
            backgroundColor: CupertinoColors.systemBackground,
            itemExtent: 32.0,
            onSelectedItemChanged: (int index) {
              setState(() {
                selectedItem = items[index];
              });
            },
            children: items.map((item) => Text(item)).toList(),
          ),
        ),
      );
    },
  );
}
```

#### 4. **CupertinoDatePicker** - منتقي التاريخ

```dart
void showDatePicker(BuildContext context) {
  showCupertinoModalPopup(
    context: context,
    builder: (BuildContext context) {
      return Container(
        height: 250,
        color: CupertinoColors.systemBackground,
        child: SafeArea(
          top: false,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            initialDateTime: selectedDate,
            minimumDate: DateTime(2000),
            maximumDate: DateTime.now(),
            onDateTimeChanged: (DateTime newDate) {
              setState(() {
                selectedDate = newDate;
              });
            },
          ),
        ),
      );
    },
  );
}
```

#### 5. **CupertinoSegmentedControl** - التحكم المقسم

```dart
enum Filter { all, active, completed }

CupertinoSegmentedControl<Filter>(
  children: {
    Filter.all: Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Text('الكل'),
    ),
    Filter.active: Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Text('نشط'),
    ),
    Filter.completed: Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Text('مكتمل'),
    ),
  },
  groupValue: currentFilter,
  onValueChanged: (Filter value) {
    setState(() {
      currentFilter = value;
    });
  },
  
  // اللون
  selectedColor: CupertinoColors.activeBlue,
  unselectedColor: CupertinoColors.systemGrey6,
  borderColor: CupertinoColors.systemGrey4,
)
```

---

### الحوارات

#### 1. **CupertinoAlertDialog** - حوار التنبيه

```dart
void showAlert(BuildContext context) {
  showCupertinoDialog(
    context: context,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: Text('حذف العنصر'),
        content: Text('هل أنت متأكد من حذف هذا العنصر؟ لا يمكن التراجع عن هذا الإجراء.'),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            child: Text('إلغاء'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: Text('حذف'),
            onPressed: () {
              // تنفيذ الحذف
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}
```

#### 2. **CupertinoActionSheet** - ورقة الإجراءات

```dart
void showActionSheet(BuildContext context) {
  showCupertinoModalPopup(
    context: context,
    builder: (BuildContext context) {
      return CupertinoActionSheet(
        title: Text('خيارات الملف'),
        message: Text('اختر إجراءً للملف المحدد'),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            child: Text('مشاركة'),
            onPressed: () {
              Navigator.pop(context);
              // تنفيذ المشاركة
            },
          ),
          CupertinoActionSheetAction(
            child: Text('نسخ'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          CupertinoActionSheetAction(
            child: Text('تنزيل'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            child: Text('حذف'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          child: Text('إلغاء'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      );
    },
  );
}
```

---

### القوائم

#### 1. **CupertinoListSection** - قسم القائمة

```dart
CupertinoListSection(
  header: Text('الإعدادات'),
  children: <CupertinoListTile>[
    CupertinoListTile(
      title: Text('الملف الشخصي'),
      leading: Icon(CupertinoIcons.person),
      trailing: CupertinoListTileChevron(),
      onTap: () {},
    ),
    CupertinoListTile(
      title: Text('الإشعارات'),
      leading: Icon(CupertinoIcons.bell),
      trailing: CupertinoSwitch(
        value: true,
        onChanged: (value) {},
      ),
    ),
  ],
)

// قائمة مع إطار
CupertinoListSection.insetGrouped(
  header: Text('الحساب'),
  footer: Text('معلومات إضافية عن الحساب'),
  children: [
    CupertinoListTile(
      title: Text('اسم المستخدم'),
      additionalInfo: Text('mohammed_dev'),
    ),
    CupertinoListTile(
      title: Text('البريد الإلكتروني'),
      additionalInfo: Text('mohammed@example.com'),
    ),
  ],
)
```

---

## الفروقات عن Material

### المقارنة المباشرة

| الميزة | Material | Cupertino |
|--------|----------|-----------|
| **شريط التطبيق** | AppBar | CupertinoNavigationBar |
| **الزر** | ElevatedButton | CupertinoButton |
| **حقل النص** | TextField | CupertinoTextField |
| **التبويبات** | BottomNavigationBar | CupertinoTabBar |
| **المفتاح** | Switch | CupertinoSwitch |
| **الحوار** | AlertDialog | CupertinoAlertDialog |
| **القوائم** | ListTile | CupertinoListTile |
| **المنتقي** | DropdownButton | CupertinoPicker |

### متى تستخدم كل منها؟

```dart
// نهج مشترك: التكيف مع المنصة
Widget buildButton(BuildContext context) {
  return Platform.isIOS
      ? CupertinoButton(
          child: Text('زر'),
          onPressed: () {},
        )
      : ElevatedButton(
          child: Text('زر'),
          onPressed: () {},
        );
}

// أفضل: استخدام PlatformWidget
Widget buildAdaptiveButton() {
  return PlatformWidget(
    cupertino: (context) => CupertinoButton(
      child: Text('زر'),
      onPressed: () {},
    ),
    material: (context) => ElevatedButton(
      child: Text('زر'),
      onPressed: () {},
    ),
  );
}
```

---

## أمثلة متقدمة

### تطبيق إعدادات كامل بنمط iOS

```dart
class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = true;
  bool darkMode = false;
  double fontSize = 16.0;
  
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('الإعدادات'),
      ),
      
      child: SafeArea(
        child: ListView(
          children: [
            // قسم الحساب
            CupertinoListSection.insetGrouped(
              header: Text('الحساب'),
              children: [
                CupertinoListTile(
                  title: Text('الملف الشخصي'),
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: CupertinoColors.systemBlue,
                    ),
                    child: Icon(
                      CupertinoIcons.person,
                      color: CupertinoColors.white,
                    ),
                  ),
                  trailing: CupertinoListTileChevron(),
                  onTap: () {},
                ),
                CupertinoListTile(
                  title: Text('تغيير كلمة المرور'),
                  leading: Icon(CupertinoIcons.lock),
                  trailing: CupertinoListTileChevron(),
                  onTap: () {},
                ),
              ],
            ),
            
            // قسم الإشعارات
            CupertinoListSection.insetGrouped(
              header: Text('الإشعارات'),
              children: [
                CupertinoListTile(
                  title: Text('تفعيل الإشعارات'),
                  leading: Icon(CupertinoIcons.bell),
                  trailing: CupertinoSwitch(
                    value: notificationsEnabled,
                    onChanged: (value) {
                      setState(() => notificationsEnabled = value);
                    },
                  ),
                ),
              ],
            ),
            
            // قسم المظهر
            CupertinoListSection.insetGrouped(
              header: Text('المظهر'),
              children: [
                CupertinoListTile(
                  title: Text('الوضع الداكن'),
                  leading: Icon(CupertinoIcons.moon),
                  trailing: CupertinoSwitch(
                    value: darkMode,
                    onChanged: (value) {
                      setState(() => darkMode = value);
                    },
                  ),
                ),
                CupertinoListTile(
                  title: Text('حجم الخط'),
                  leading: Icon(CupertinoIcons.textformat_size),
                  trailing: Text('${fontSize.round()} pt'),
                  onTap: () {
                    showCupertinoModalPopup(
                      context: context,
                      builder: (context) => _buildFontSizePicker(),
                    );
                  },
                ),
              ],
            ),
            
            // قسم عن التطبيق
            CupertinoListSection.insetGrouped(
              header: Text('عن التطبيق'),
              children: [
                CupertinoListTile(
                  title: Text('الإصدار'),
                  additionalInfo: Text('1.0.0'),
                ),
                CupertinoListTile(
                  title: Text('الشروط والأحكام'),
                  trailing: CupertinoListTileChevron(),
                  onTap: () {},
                ),
                CupertinoListTile(
                  title: Text('سياسة الخصوصية'),
                  trailing: CupertinoListTileChevron(),
                  onTap: () {},
                ),
              ],
            ),
            
            // زر تسجيل الخروج
            Padding(
              padding: EdgeInsets.all(16),
              child: CupertinoButton(
                color: CupertinoColors.destructiveRed,
                child: Text('تسجيل الخروج'),
                onPressed: () {
                  _showLogoutDialog();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildFontSizePicker() {
    return Container(
      height: 250,
      color: CupertinoColors.systemBackground,
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    child: Text('إلغاء'),
                    onPressed: () => Navigator.pop(context),
                  ),
                  CupertinoButton(
                    child: Text('تم'),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: CupertinoPicker(
                itemExtent: 32.0,
                scrollController: FixedExtentScrollController(
                  initialItem: (fontSize - 12).toInt(),
                ),
                onSelectedItemChanged: (int index) {
                  setState(() {
                    fontSize = (12 + index).toDouble();
                  });
                },
                children: List.generate(
                  13,
                  (index) => Center(child: Text('${12 + index} pt')),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _showLogoutDialog() {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text('تسجيل الخروج'),
          content: Text('هل أنت متأكد من تسجيل الخروج؟'),
          actions: [
            CupertinoDialogAction(
              child: Text('إلغاء'),
              onPressed: () => Navigator.pop(context),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: Text('تسجيل الخروج'),
              onPressed: () {
                Navigator.pop(context);
                // تنفيذ تسجيل الخروج
              },
            ),
          ],
        );
      },
    );
  }
}
```

---

## أفضل الممارسات

### 1. استخدام CupertinoApp بدلاً من MaterialApp

```dart
CupertinoApp(
  title: 'تطبيقي',
  theme: CupertinoThemeData(
    brightness: Brightness.light,
    primaryColor: CupertinoColors.activeBlue,
  ),
  home: MyHomePage(),
)
```

### 2. احترام SafeArea

```dart
CupertinoPageScaffold(
  child: SafeArea(
    child: MyContent(),
  ),
)
```

### 3. استخدام الألوان الديناميكية

```dart
// تتكيف مع الوضع الداكن تلقائياً
Container(
  color: CupertinoColors.systemBackground,
  child: Text(
    'نص',
    style: TextStyle(
      color: CupertinoColors.label,
    ),
  ),
)
```

### 4. الانتقالات بنمط iOS

```dart
Navigator.push(
  context,
  CupertinoPageRoute(
    builder: (context) => NextPage(),
  ),
)
```

### 5. التعامل مع الإيماءات

```dart
// إيماءة السحب للرجوع (مدمجة تلقائياً)
CupertinoPageScaffold(
  // السماح بالسحب للرجوع
  navigationBar: CupertinoNavigationBar(
    // automaticallyImplyLeading: true (افتراضي)
  ),
)
```

---

## المراجع

### التوثيق الرسمي

1. **Flutter Cupertino Widgets Catalog**  
   [https://docs.flutter.dev/ui/widgets/cupertino](https://docs.flutter.dev/ui/widgets/cupertino)

2. **Cupertino (iOS-style) API Reference**  
   [https://api.flutter.dev/flutter/cupertino/cupertino-library.html](https://api.flutter.dev/flutter/cupertino/cupertino-library.html)

3. **Apple Human Interface Guidelines**  
   [https://developer.apple.com/design/human-interface-guidelines/](https://developer.apple.com/design/human-interface-guidelines/)

### إرشادات التصميم

4. **iOS Design Themes**  
   [https://developer.apple.com/design/human-interface-guidelines/ios/overview/themes/](https://developer.apple.com/design/human-interface-guidelines/ios/overview/themes/)

5. **SF Symbols (iOS Icons)**  
   [https://developer.apple.com/sf-symbols/](https://developer.apple.com/sf-symbols/)

### مقالات متقدمة

6. **Building Adaptive Apps**  
   [https://docs.flutter.dev/development/ui/layout/building-adaptive-apps](https://docs.flutter.dev/development/ui/layout/building-adaptive-apps)

7. **Platform-Specific Behaviors and Adaptations**  
   [https://docs.flutter.dev/resources/platform-adaptations](https://docs.flutter.dev/resources/platform-adaptations)

### أدوات

8. **Cupertino Icons Gallery**  
   [https://api.flutter.dev/flutter/cupertino/CupertinoIcons-class.html](https://api.flutter.dev/flutter/cupertino/CupertinoIcons-class.html)

9. **iOS Design Resources**  
   [https://developer.apple.com/design/resources/](https://developer.apple.com/design/resources/)

### فيديوهات

10. **Flutter Widget of the Week - Cupertino Playlist**  
    [https://www.youtube.com/playlist?list=PLjxrf2q8roU23XGwz3Km7sQZFTdB996iG](https://www.youtube.com/playlist?list=PLjxrf2q8roU23XGwz3Km7sQZFTdB996iG)

---

[← العودة للفهرس الرئيسي](README.md)
[السابق: Material Widgets](01_material_widgets.md)
[التالي: Accessibility →](03_accessibility.md)

---

**آخر تحديث:** نوفمبر 2025  
**مستوى:** متقدم - احترافي
