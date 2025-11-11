import 'package:flutter/material.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({super.key});

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  bool _checkboxValue = false;
  int _radioValue = 0;
  bool _switchValue = false;
  double _sliderValue = 0.5;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Input - إدخال المستخدم')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection(context, '⌨️ TextField', _buildTextFieldExamples()),
          _buildSection(context, '📋 Form', _buildFormExample()),
          _buildSection(context, '☑️ Checkbox & Radio', _buildCheckboxRadioExamples()),
          _buildSection(context, '🔘 Switch & Slider', _buildSwitchSliderExamples()),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
        ),
        content,
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildTextFieldExamples() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: const [
            TextField(
              decoration: InputDecoration(
                labelText: 'الاسم',
                hintText: 'أدخل اسمك',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'البريد الإلكتروني',
                hintText: 'example@email.com',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'كلمة المرور',
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'الاسم الكامل *',
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
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'رقم الهاتف *',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال رقم الهاتف';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم التحقق بنجاح!')),
                    );
                  }
                },
                child: const Text('إرسال'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCheckboxRadioExamples() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Checkbox:', style: TextStyle(fontWeight: FontWeight.bold)),
            CheckboxListTile(
              title: const Text('أوافق على الشروط والأحكام'),
              value: _checkboxValue,
              onChanged: (value) => setState(() => _checkboxValue = value!),
            ),
            const Divider(height: 32),
            const Text('Radio Buttons:', style: TextStyle(fontWeight: FontWeight.bold)),
            RadioListTile(
              title: const Text('الخيار الأول'),
              value: 0,
              groupValue: _radioValue,
              onChanged: (value) => setState(() => _radioValue = value!),
            ),
            RadioListTile(
              title: const Text('الخيار الثاني'),
              value: 1,
              groupValue: _radioValue,
              onChanged: (value) => setState(() => _radioValue = value!),
            ),
            RadioListTile(
              title: const Text('الخيار الثالث'),
              value: 2,
              groupValue: _radioValue,
              onChanged: (value) => setState(() => _radioValue = value!),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchSliderExamples() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SwitchListTile(
              title: const Text('تفعيل الإشعارات'),
              subtitle: const Text('استلام تنبيهات فورية'),
              value: _switchValue,
              onChanged: (value) => setState(() => _switchValue = value),
            ),
            const SizedBox(height: 24),
            const Text('Slider:', style: TextStyle(fontWeight: FontWeight.bold)),
            Slider(
              value: _sliderValue,
              onChanged: (value) => setState(() => _sliderValue = value),
              label: '${(_sliderValue * 100).round()}%',
              divisions: 10,
            ),
            Text('القيمة: ${(_sliderValue * 100).round()}%'),
          ],
        ),
      ),
    );
  }
}
