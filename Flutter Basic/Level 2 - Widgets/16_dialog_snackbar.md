# 16 - Dialog و SnackBar

## 📋 المحتويات

- [المقدمة](#المقدمة)
- [AlertDialog](#alertdialog)
- [SimpleDialog](#simpledialog)
- [BottomSheet](#bottomsheet)
- [SnackBar](#snackbar)
- [أمثلة عملية](#أمثلة-عملية)

---

## 🎯 المقدمة

Dialogs و SnackBars توفر طرقاً للتواصل مع المستخدم وعرض رسائل تفاعلية.

---

## 🔔 AlertDialog

حوار تنبيه بسيط:

```dart
// عرض AlertDialog
void showAlertDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('تنبيه'),
        content: const Text('هل تريد حذف هذا العنصر؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              // تنفيذ الحذف
              Navigator.pop(context);
            },
            child: const Text('حذف'),
          ),
        ],
      );
    },
  );
}
```

### AlertDialog متقدم

```dart
void showCustomAlertDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,  // لا يمكن إغلاقه بالنقر خارجه
    builder: (context) {
      return AlertDialog(
        icon: const Icon(Icons.warning, size: 48, color: Colors.orange),
        title: const Text(
          'تحذير',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('هذا الإجراء لا يمكن التراجع عنه.'),
            SizedBox(height: 8),
            Text(
              'هل أنت متأكد من المتابعة؟',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // تنفيذ الإجراء
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('متابعة'),
          ),
        ],
      );
    },
  );
}
```

---

## 📝 SimpleDialog

حوار مع خيارات متعددة:

```dart
void showSimpleDialog(BuildContext context) async {
  final result = await showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: const Text('اختر لوناً'),
        children: [
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, 'أحمر'),
            child: Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  color: Colors.red,
                ),
                const SizedBox(width: 12),
                const Text('أحمر'),
              ],
            ),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, 'أزرق'),
            child: Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  color: Colors.blue,
                ),
                const SizedBox(width: 12),
                const Text('أزرق'),
              ],
            ),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, 'أخضر'),
            child: Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  color: Colors.green,
                ),
                const SizedBox(width: 12),
                const Text('أخضر'),
              ],
            ),
          ),
        ],
      );
    },
  );
  
  if (result != null) {
    print('تم اختيار: $result');
  }
}
```

---

## 📋 BottomSheet

### Modal BottomSheet

```dart
void showModalBottomSheetExample(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('مشاركة'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.link),
              title: const Text('نسخ الرابط'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('حذف'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    },
  );
}
```

### BottomSheet مخصص

```dart
void showCustomBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'الإعدادات',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            SwitchListTile(
              title: const Text('الإشعارات'),
              value: true,
              onChanged: (value) {},
            ),
            SwitchListTile(
              title: const Text('الوضع الداكن'),
              value: false,
              onChanged: (value) {},
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إغلاق'),
            ),
          ],
        ),
      );
    },
  );
}
```

---

## 🎉 SnackBar

رسالة قصيرة في أسفل الشاشة:

```dart
// SnackBar بسيط
void showSimpleSnackBar(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('تم الحفظ بنجاح'),
    ),
  );
}

// SnackBar مع إجراء
void showSnackBarWithAction(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: const Text('تم حذف العنصر'),
      action: SnackBarAction(
        label: 'تراجع',
        onPressed: () {
          // التراجع عن الحذف
        },
      ),
    ),
  );
}

// SnackBar مخصص
void showCustomSnackBar(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: const [
          Icon(Icons.check_circle, color: Colors.white),
          SizedBox(width: 12),
          Text('تم بنجاح!'),
        ],
      ),
      backgroundColor: Colors.green,
      duration: const Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.all(10),
    ),
  );
}
```

---

## 💼 أمثلة عملية

### نظام حذف مع تأكيد

```dart
class DeleteConfirmation extends StatelessWidget {
  final String itemName;
  final VoidCallback onDelete;

  const DeleteConfirmation({
    super.key,
    required this.itemName,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.delete),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('تأكيد الحذف'),
              content: Text('هل تريد حذف "$itemName"؟'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('إلغاء'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    onDelete();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('تم حذف "$itemName"'),
                        action: SnackBarAction(
                          label: 'تراجع',
                          onPressed: () {
                            // التراجع
                          },
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text('حذف'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
```

### حوار تحميل

```dart
class LoadingDialog {
  static void show(BuildContext context, {String? message}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(message ?? 'جارٍ التحميل...'),
            ],
          ),
        );
      },
    );
  }

  static void hide(BuildContext context) {
    Navigator.pop(context);
  }
}

// الاستخدام
void performAsyncOperation(BuildContext context) async {
  LoadingDialog.show(context, message: 'جارٍ الحفظ...');
  
  await Future.delayed(const Duration(seconds: 2));
  
  LoadingDialog.hide(context);
  
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('تم الحفظ بنجاح!')),
  );
}
```

### BottomSheet متقدم للفلاتر

```dart
class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  RangeValues _priceRange = const RangeValues(0, 1000);
  String _selectedCategory = 'الكل';
  bool _inStock = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'التصفية',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          
          const Text('نطاق السعر'),
          RangeSlider(
            values: _priceRange,
            min: 0,
            max: 1000,
            divisions: 10,
            labels: RangeLabels(
              '${_priceRange.start.round()}',
              '${_priceRange.end.round()}',
            ),
            onChanged: (values) {
              setState(() {
                _priceRange = values;
              });
            },
          ),
          
          const SizedBox(height: 16),
          
          const Text('الفئة'),
          DropdownButton<String>(
            value: _selectedCategory,
            isExpanded: true,
            items: ['الكل', 'إلكترونيات', 'ملابس', 'كتب']
                .map((cat) => DropdownMenuItem(
                      value: cat,
                      child: Text(cat),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedCategory = value!;
              });
            },
          ),
          
          const SizedBox(height: 16),
          
          SwitchListTile(
            title: const Text('متوفر في المخزون فقط'),
            value: _inStock,
            onChanged: (value) {
              setState(() {
                _inStock = value;
              });
            },
          ),
          
          const SizedBox(height: 20),
          
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _priceRange = const RangeValues(0, 1000);
                      _selectedCategory = 'الكل';
                      _inStock = false;
                    });
                  },
                  child: const Text('إعادة تعيين'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, {
                      'priceRange': _priceRange,
                      'category': _selectedCategory,
                      'inStock': _inStock,
                    });
                  },
                  child: const Text('تطبيق'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// الاستخدام
void showFilterSheet(BuildContext context) async {
  final result = await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => const FilterBottomSheet(),
  );
  
  if (result != null) {
    print('الفلاتر: $result');
  }
}
```

---

## 📚 المراجع والمصادر

1. **Dialogs**
   - [showDialog](https://api.flutter.dev/flutter/material/showDialog.html)
   - [AlertDialog](https://api.flutter.dev/flutter/material/AlertDialog-class.html)
   - [SimpleDialog](https://api.flutter.dev/flutter/material/SimpleDialog-class.html)

2. **BottomSheet**
   - [showModalBottomSheet](https://api.flutter.dev/flutter/material/showModalBottomSheet.html)
   - [BottomSheet](https://api.flutter.dev/flutter/material/BottomSheet-class.html)

3. **SnackBar**
   - [SnackBar](https://api.flutter.dev/flutter/material/SnackBar-class.html)
   - [ScaffoldMessenger](https://api.flutter.dev/flutter/material/ScaffoldMessenger-class.html)

---

## 💡 نصائح

- ✅ استخدم `AlertDialog` للتأكيدات المهمة
- ✅ `BottomSheet` مناسب للخيارات والفلاتر
- ✅ `SnackBar` للإشعارات السريعة
- ✅ استخدم `barrierDismissible: false` لمنع الإغلاق بالنقر خارج الحوار
- ✅ دائماً أضف إمكانية الإغلاق للمستخدم

---

[⬅️ السابق: ScrollView Widgets](15_scrollview_widgets.md)
[🏠 العودة للفهرس](../README.md)
[التالي: Navigation ➡️](17_navigation.md)
