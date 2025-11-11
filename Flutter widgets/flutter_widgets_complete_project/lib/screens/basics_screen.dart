import 'package:flutter/material.dart';

class BasicsScreen extends StatelessWidget {
  const BasicsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Basics - الأساسيات')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection(context, '📦 Container', _buildContainerExample()),
          _buildSection(context, '↔️ Row & Column', _buildRowColumnExample()),
          _buildSection(context, '📝 Text', _buildTextExample(context)),
          _buildSection(context, '🏗️ Scaffold', _buildScaffoldInfo()),
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

  Widget _buildContainerExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  'Container',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Container مع لون، حواف دائرية، وظل',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRowColumnExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Row - صف أفقي:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildColorBox(Colors.red, '1'),
                _buildColorBox(Colors.green, '2'),
                _buildColorBox(Colors.blue, '3'),
              ],
            ),
            const SizedBox(height: 24),
            const Text('Column - عمود رأسي:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildColorBox(Colors.orange, 'أ'),
                const SizedBox(height: 8),
                _buildColorBox(Colors.purple, 'ب'),
                const SizedBox(height: 8),
                _buildColorBox(Colors.teal, 'ج'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorBox(Color color, String text) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildTextExample(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'نص عادي',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 12),
            Text(
              'نص كبير وعريض',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            const Text(
              'نص ملون',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            RichText(
              text: const TextSpan(
                style: TextStyle(fontSize: 16, color: Colors.black),
                children: [
                  TextSpan(text: 'نص '),
                  TextSpan(
                    text: 'متعدد ',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                  TextSpan(
                    text: 'الأنماط',
                    style: TextStyle(fontStyle: FontStyle.italic, color: Colors.blue),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScaffoldInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Scaffold - الهيكل الأساسي',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 12),
            ListTile(
              leading: Icon(Icons.apps, color: Colors.blue),
              title: Text('AppBar - شريط التطبيق'),
              subtitle: Text('في الأعلى'),
            ),
            ListTile(
              leading: Icon(Icons.dashboard, color: Colors.green),
              title: Text('Body - المحتوى الرئيسي'),
              subtitle: Text('في المنتصف'),
            ),
            ListTile(
              leading: Icon(Icons.add_circle, color: Colors.orange),
              title: Text('FloatingActionButton'),
              subtitle: Text('زر عائم'),
            ),
            ListTile(
              leading: Icon(Icons.menu, color: Colors.purple),
              title: Text('Drawer - قائمة جانبية'),
              subtitle: Text('من اليسار أو اليمين'),
            ),
          ],
        ),
      ),
    );
  }
}
