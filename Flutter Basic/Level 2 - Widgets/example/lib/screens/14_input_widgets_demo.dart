import 'package:flutter/material.dart';

/// شاشة توضيحية لـ Input Widgets (الموضوع 14)
class InputWidgetsDemo extends StatefulWidget {
  const InputWidgetsDemo({super.key});

  @override
  State<InputWidgetsDemo> createState() => _InputWidgetsDemoState();
}

class _InputWidgetsDemoState extends State<InputWidgetsDemo> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  bool _checkboxValue = false;
  String _radioValue = 'option1';
  bool _switchValue = false;
  double _sliderValue = 50;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('14. Input Widgets'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // TextField
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('TextField', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'الاسم',
                        hintText: 'أدخل اسمك',
                        prefixIcon: Icon(Icons.person),
                      ),
                      controller: _nameController,
                    ),
                    const SizedBox(height: 12),
                    const TextField(
                      decoration: InputDecoration(
                        labelText: 'البريد الإلكتروني',
                        prefixIcon: Icon(Icons.email),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 12),
                    const TextField(
                      decoration: InputDecoration(
                        labelText: 'كلمة المرور',
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: Icon(Icons.visibility),
                      ),
                      obscureText: true,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Checkbox
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Checkbox', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    CheckboxListTile(
                      title: const Text('أوافق على الشروط والأحكام'),
                      value: _checkboxValue,
                      onChanged: (value) => setState(() => _checkboxValue = value!),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Radio
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Radio', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    RadioListTile(
                      title: const Text('الخيار 1'),
                      value: 'option1',
                      groupValue: _radioValue,
                      onChanged: (value) => setState(() => _radioValue = value!),
                    ),
                    RadioListTile(
                      title: const Text('الخيار 2'),
                      value: 'option2',
                      groupValue: _radioValue,
                      onChanged: (value) => setState(() => _radioValue = value!),
                    ),
                    RadioListTile(
                      title: const Text('الخيار 3'),
                      value: 'option3',
                      groupValue: _radioValue,
                      onChanged: (value) => setState(() => _radioValue = value!),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Switch
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Switch', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SwitchListTile(
                      title: const Text('تفعيل الإشعارات'),
                      subtitle: Text(_switchValue ? 'مفعل' : 'معطل'),
                      value: _switchValue,
                      onChanged: (value) => setState(() => _switchValue = value),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Slider
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Slider', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text('القيمة: ${_sliderValue.round()}'),
                    Slider(
                      value: _sliderValue,
                      min: 0,
                      max: 100,
                      divisions: 10,
                      label: _sliderValue.round().toString(),
                      onChanged: (value) => setState(() => _sliderValue = value),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Submit Button
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تم الإرسال بنجاح!')),
                  );
                }
              },
              child: const Text('إرسال'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
