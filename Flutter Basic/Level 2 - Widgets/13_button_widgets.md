# 13 - Button Widgets

## 📋 المحتويات

- [المقدمة](#المقدمة)
- [ElevatedButton](#elevatedbutton)
- [TextButton](#textbutton)
- [OutlinedButton](#outlinedbutton)
- [IconButton](#iconbutton)
- [FloatingActionButton](#floatingactionbutton)
- [تخصيص الأزرار](#تخصيص-الأزرار)
- [أمثلة عملية](#أمثلة-عملية)

---

## 🎯 المقدمة

الأزرار (Buttons) هي عناصر تفاعلية أساسية لاستقبال إدخالات المستخدم.

---

## 🔘 ElevatedButton

زر بارز مع ظل:

```dart
ElevatedButton(
  onPressed: () {
    print('تم الضغط');
  },
  child: const Text('اضغط هنا'),
)

// زر معطل
ElevatedButton(
  onPressed: null,  // null = معطل
  child: const Text('معطل'),
)

// مع أيقونة
ElevatedButton.icon(
  onPressed: () {},
  icon: const Icon(Icons.save),
  label: const Text('حفظ'),
)
```

---

## 📝 TextButton

زر نصي بسيط:

```dart
TextButton(
  onPressed: () {
    print('نقر النص');
  },
  child: const Text('انقر هنا'),
)

// مع أيقونة
TextButton.icon(
  onPressed: () {},
  icon: const Icon(Icons.cancel),
  label: const Text('إلغاء'),
)
```

---

## 🔲 OutlinedButton

زر بحدود:

```dart
OutlinedButton(
  onPressed: () {},
  child: const Text('زر بحدود'),
)

// مع أيقونة
OutlinedButton.icon(
  onPressed: () {},
  icon: const Icon(Icons.add),
  label: const Text('إضافة'),
)
```

---

## 🎨 IconButton

زر أيقونة:

```dart
IconButton(
  icon: const Icon(Icons.favorite),
  onPressed: () {},
  color: Colors.red,
  iconSize: 30,
)

// مع tooltip
IconButton(
  icon: const Icon(Icons.info),
  onPressed: () {},
  tooltip: 'معلومات',
)
```

---

## ➕ FloatingActionButton

زر عائم:

```dart
FloatingActionButton(
  onPressed: () {},
  child: const Icon(Icons.add),
)

// ممتد
FloatingActionButton.extended(
  onPressed: () {},
  icon: const Icon(Icons.add),
  label: const Text('إضافة'),
)

// صغير
FloatingActionButton.small(
  onPressed: () {},
  child: const Icon(Icons.edit),
)

// كبير
FloatingActionButton.large(
  onPressed: () {},
  child: const Icon(Icons.add),
)
```

---

## 🎨 تخصيص الأزرار

### تخصيص ElevatedButton

```dart
ElevatedButton(
  onPressed: () {},
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.blue,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(
      horizontal: 32,
      vertical: 16,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
    ),
    elevation: 5,
    shadowColor: Colors.blue.shade200,
    minimumSize: const Size(200, 50),
  ),
  child: const Text(
    'زر مخصص',
    style: TextStyle(fontSize: 18),
  ),
)
```

### ButtonStyle متقدم

```dart
ElevatedButton(
  onPressed: () {},
  style: ButtonStyle(
    backgroundColor: MaterialStateProperty.resolveWith<Color>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.pressed)) {
          return Colors.blue.shade700;
        } else if (states.contains(MaterialState.disabled)) {
          return Colors.grey;
        }
        return Colors.blue;
      },
    ),
    foregroundColor: MaterialStateProperty.all(Colors.white),
    padding: MaterialStateProperty.all(
      const EdgeInsets.all(16),
    ),
    shape: MaterialStateProperty.all(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  ),
  child: const Text('زر متقدم'),
)
```

---

## 💼 أمثلة عملية

### مثال 1: مجموعة أزرار

```dart
class ButtonShowcase extends StatelessWidget {
  const ButtonShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الأزرار')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ElevatedButton
            ElevatedButton(
              onPressed: () {},
              child: const Text('ElevatedButton'),
            ),
            const SizedBox(height: 12),
            
            // TextButton
            TextButton(
              onPressed: () {},
              child: const Text('TextButton'),
            ),
            const SizedBox(height: 12),
            
            // OutlinedButton
            OutlinedButton(
              onPressed: () {},
              child: const Text('OutlinedButton'),
            ),
            const SizedBox(height: 12),
            
            // مع أيقونات
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.save),
              label: const Text('حفظ'),
            ),
            const SizedBox(height: 12),
            
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.cancel),
              label: const Text('إلغاء'),
            ),
            const SizedBox(height: 20),
            
            // أزرار أيقونات
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.favorite),
                  onPressed: () {},
                  color: Colors.red,
                ),
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () {},
                  color: Colors.blue,
                ),
                IconButton(
                  icon: const Icon(Icons.bookmark),
                  onPressed: () {},
                  color: Colors.amber,
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

### مثال 2: أزرار مخصصة

```dart
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final IconData? icon;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color = Colors.blue,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 14,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 3,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 20),
            const SizedBox(width: 8),
          ],
          Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// الاستخدام
CustomButton(
  text: 'حفظ',
  icon: Icons.save,
  color: Colors.green,
  onPressed: () {},
)
```

---

## 📚 المراجع والمصادر

1. **Flutter Buttons**
   - [Material Buttons](https://docs.flutter.dev/development/ui/widgets/material#Buttons)
   - [ElevatedButton](https://api.flutter.dev/flutter/material/ElevatedButton-class.html)
   - [TextButton](https://api.flutter.dev/flutter/material/TextButton-class.html)
   - [OutlinedButton](https://api.flutter.dev/flutter/material/OutlinedButton-class.html)
   - [IconButton](https://api.flutter.dev/flutter/material/IconButton-class.html)
   - [FloatingActionButton](https://api.flutter.dev/flutter/material/FloatingActionButton-class.html)

---

## 💡 نصائح

- ✅ استخدم `ElevatedButton` للإجراءات الأساسية
- ✅ استخدم `TextButton` للإجراءات الثانوية
- ✅ استخدم `OutlinedButton` للإجراءات البديلة
- ✅ `onPressed: null` يعطل الزر
- ✅ استخدم `.icon` للأزرار مع أيقونات

---

[⬅️ السابق: Layout Widgets](12_layout_widgets.md)
[🏠 العودة للفهرس](../README.md)
[التالي: Input Widgets ➡️](14_input_widgets.md)
