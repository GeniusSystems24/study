# 14 - Input Widgets

## 📋 المحتويات

- [المقدمة](#المقدمة)
- [TextField](#textfield)
- [Form و TextFormField](#form-و-textformfield)
- [Checkbox](#checkbox)
- [Radio](#radio)
- [Switch](#switch)
- [Slider](#slider)
- [DropdownButton](#dropdownbutton)
- [أمثلة عملية](#أمثلة-عملية)

---

## 🎯 المقدمة

Input Widgets تسمح للمستخدم بإدخال البيانات والتفاعل مع التطبيق.

---

## ✏️ TextField

حقل إدخال نصي:

```dart
TextField(
  decoration: InputDecoration(
    labelText: 'الاسم',
    hintText: 'أدخل اسمك',
    border: OutlineInputBorder(),
  ),
  onChanged: (value) {
    print('القيمة: $value');
  },
)
```

### TextField متقدم

```dart
class TextFieldDemo extends StatefulWidget {
  const TextFieldDemo({super.key});

  @override
  State<TextFieldDemo> createState() => _TextFieldDemoState();
}

class _TextFieldDemoState extends State<TextFieldDemo> {
  final _controller = TextEditingController();
  bool _obscureText = true;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // حقل نص عادي
        TextField(
          controller: _controller,
          decoration: const InputDecoration(
            labelText: 'الاسم',
            prefixIcon: Icon(Icons.person),
            border: OutlineInputBorder(),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // حقل كلمة المرور
        TextField(
          obscureText: _obscureText,
          decoration: InputDecoration(
            labelText: 'كلمة المرور',
            prefixIcon: const Icon(Icons.lock),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            ),
            border: const OutlineInputBorder(),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // حقل بريد إلكتروني
        TextField(
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'البريد الإلكتروني',
            prefixIcon: Icon(Icons.email),
            border: OutlineInputBorder(),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // حقل رقم
        TextField(
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'رقم الهاتف',
            prefixIcon: Icon(Icons.phone),
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
```

---

## 📋 Form و TextFormField

### نموذج بسيط

```dart
class SimpleForm extends StatefulWidget {
  const SimpleForm({super.key});

  @override
  State<SimpleForm> createState() => _SimpleFormState();
}

class _SimpleFormState extends State<SimpleForm> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  String? _email;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'الاسم',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'الرجاء إدخال الاسم';
              }
              return null;
            },
            onSaved: (value) => _name = value,
          ),
          
          const SizedBox(height: 16),
          
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'البريد الإلكتروني',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'الرجاء إدخال البريد الإلكتروني';
              }
              if (!value.contains('@')) {
                return 'بريد إلكتروني غير صحيح';
              }
              return null;
            },
            onSaved: (value) => _email = value,
          ),
          
          const SizedBox(height: 24),
          
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                print('الاسم: $_name');
                print('البريد: $_email');
              }
            },
            child: const Text('إرسال'),
          ),
        ],
      ),
    );
  }
}
```

---

## ☑️ Checkbox

```dart
class CheckboxDemo extends StatefulWidget {
  const CheckboxDemo({super.key});

  @override
  State<CheckboxDemo> createState() => _CheckboxDemoState();
}

class _CheckboxDemoState extends State<CheckboxDemo> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: const Text('موافق على الشروط'),
      value: _isChecked,
      onChanged: (bool? value) {
        setState(() {
          _isChecked = value ?? false;
        });
      },
    );
  }
}
```

---

## 🔘 Radio

```dart
class RadioDemo extends StatefulWidget {
  const RadioDemo({super.key});

  @override
  State<RadioDemo> createState() => _RadioDemoState();
}

class _RadioDemoState extends State<RadioDemo> {
  String _selectedGender = 'male';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RadioListTile<String>(
          title: const Text('ذكر'),
          value: 'male',
          groupValue: _selectedGender,
          onChanged: (value) {
            setState(() {
              _selectedGender = value!;
            });
          },
        ),
        RadioListTile<String>(
          title: const Text('أنثى'),
          value: 'female',
          groupValue: _selectedGender,
          onChanged: (value) {
            setState(() {
              _selectedGender = value!;
            });
          },
        ),
      ],
    );
  }
}
```

---

## 🔄 Switch

```dart
class SwitchDemo extends StatefulWidget {
  const SwitchDemo({super.key});

  @override
  State<SwitchDemo> createState() => _SwitchDemoState();
}

class _SwitchDemoState extends State<SwitchDemo> {
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: const Text('تفعيل الإشعارات'),
      value: _notificationsEnabled,
      onChanged: (bool value) {
        setState(() {
          _notificationsEnabled = value;
        });
      },
    );
  }
}
```

---

## 🎚️ Slider

```dart
class SliderDemo extends StatefulWidget {
  const SliderDemo({super.key});

  @override
  State<SliderDemo> createState() => _SliderDemoState();
}

class _SliderDemoState extends State<SliderDemo> {
  double _currentValue = 50;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('القيمة: ${_currentValue.round()}'),
        Slider(
          value: _currentValue,
          min: 0,
          max: 100,
          divisions: 100,
          label: _currentValue.round().toString(),
          onChanged: (double value) {
            setState(() {
              _currentValue = value;
            });
          },
        ),
      ],
    );
  }
}
```

---

## 📋 DropdownButton

```dart
class DropdownDemo extends StatefulWidget {
  const DropdownDemo({super.key});

  @override
  State<DropdownDemo> createState() => _DropdownDemoState();
}

class _DropdownDemoState extends State<DropdownDemo> {
  String? _selectedCity;
  
  final List<String> _cities = [
    'الرياض',
    'جدة',
    'الدمام',
    'مكة',
    'المدينة',
  ];

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: _selectedCity,
      hint: const Text('اختر المدينة'),
      isExpanded: true,
      items: _cities.map((String city) {
        return DropdownMenuItem<String>(
          value: city,
          child: Text(city),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedCity = newValue;
        });
      },
    );
  }
}
```

---

## 💼 أمثلة عملية

### نموذج تسجيل كامل

```dart
class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key});

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  String? _selectedCity;
  String _selectedGender = 'male';
  bool _acceptTerms = false;
  
  final List<String> _cities = ['الرياض', 'جدة', 'الدمام'];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (!_acceptTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('يجب الموافقة على الشروط'),
          ),
        );
        return;
      }
      
      // معالجة البيانات
      print('الاسم: ${_nameController.text}');
      print('البريد: ${_emailController.text}');
      print('المدينة: $_selectedCity');
      print('الجنس: $_selectedGender');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('التسجيل')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // الاسم
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'الاسم الكامل',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الرجاء إدخال الاسم';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 16),
            
            // البريد الإلكتروني
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'البريد الإلكتروني',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الرجاء إدخال البريد الإلكتروني';
                }
                if (!value.contains('@')) {
                  return 'بريد إلكتروني غير صحيح';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 16),
            
            // كلمة المرور
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'كلمة المرور',
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الرجاء إدخال كلمة المرور';
                }
                if (value.length < 6) {
                  return 'كلمة المرور قصيرة جداً';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 16),
            
            // المدينة
            DropdownButtonFormField<String>(
              value: _selectedCity,
              decoration: const InputDecoration(
                labelText: 'المدينة',
                border: OutlineInputBorder(),
              ),
              items: _cities.map((city) {
                return DropdownMenuItem(
                  value: city,
                  child: Text(city),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCity = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'الرجاء اختيار المدينة';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 16),
            
            // الجنس
            const Text('الجنس:', style: TextStyle(fontSize: 16)),
            RadioListTile<String>(
              title: const Text('ذكر'),
              value: 'male',
              groupValue: _selectedGender,
              onChanged: (value) {
                setState(() {
                  _selectedGender = value!;
                });
              },
            ),
            RadioListTile<String>(
              title: const Text('أنثى'),
              value: 'female',
              groupValue: _selectedGender,
              onChanged: (value) {
                setState(() {
                  _selectedGender = value!;
                });
              },
            ),
            
            const SizedBox(height: 16),
            
            // الشروط
            CheckboxListTile(
              title: const Text('أوافق على الشروط والأحكام'),
              value: _acceptTerms,
              onChanged: (value) {
                setState(() {
                  _acceptTerms = value ?? false;
                });
              },
            ),
            
            const SizedBox(height: 24),
            
            // زر الإرسال
            ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'تسجيل',
                style: TextStyle(fontSize: 18),
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

## 📚 المراجع والمصادر

1. **Input Widgets**
   - [TextField](https://api.flutter.dev/flutter/material/TextField-class.html)
   - [Form](https://api.flutter.dev/flutter/widgets/Form-class.html)
   - [TextFormField](https://api.flutter.dev/flutter/material/TextFormField-class.html)
   - [Checkbox](https://api.flutter.dev/flutter/material/Checkbox-class.html)
   - [Radio](https://api.flutter.dev/flutter/material/Radio-class.html)
   - [Switch](https://api.flutter.dev/flutter/material/Switch-class.html)
   - [Slider](https://api.flutter.dev/flutter/material/Slider-class.html)
   - [DropdownButton](https://api.flutter.dev/flutter/material/DropdownButton-class.html)

---

## 💡 نصائح

- ✅ استخدم `TextEditingController` لقراءة قيم الحقول
- ✅ استخدم `Form` و `validator` للتحقق من البيانات
- ✅ لا تنسَ `dispose()` للـ controllers
- ✅ استخدم `TextInputType` المناسب للوحة المفاتيح

---

[⬅️ السابق: Button Widgets](13_button_widgets.md)
[🏠 العودة للفهرس](../README.md)
[التالي: ScrollView Widgets ➡️](15_scrollview_widgets.md)
