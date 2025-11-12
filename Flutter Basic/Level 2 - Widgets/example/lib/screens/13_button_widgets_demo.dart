import 'package:flutter/material.dart';

/// شاشة توضيحية لـ Button Widgets (الموضوع 13)
class ButtonWidgetsDemo extends StatefulWidget {
  const ButtonWidgetsDemo({super.key});

  @override
  State<ButtonWidgetsDemo> createState() => _ButtonWidgetsDemoState();
}

class _ButtonWidgetsDemoState extends State<ButtonWidgetsDemo> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('13. Button Widgets'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ElevatedButton
          _buildSection(
            'ElevatedButton',
            Column(
              children: [
                ElevatedButton(
                  onPressed: () => _showMessage('ElevatedButton'),
                  child: const Text('Elevated Button'),
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                  label: const Text('With Icon'),
                ),
                const SizedBox(height: 8),
                const ElevatedButton(
                  onPressed: null,
                  child: Text('Disabled'),
                ),
              ],
            ),
          ),

          // TextButton
          _buildSection(
            'TextButton',
            Column(
              children: [
                TextButton(
                  onPressed: () => _showMessage('TextButton'),
                  child: const Text('Text Button'),
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.delete),
                  label: const Text('Delete'),
                ),
              ],
            ),
          ),

          // OutlinedButton
          _buildSection(
            'OutlinedButton',
            Column(
              children: [
                OutlinedButton(
                  onPressed: () => _showMessage('OutlinedButton'),
                  child: const Text('Outlined Button'),
                ),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.download),
                  label: const Text('Download'),
                ),
              ],
            ),
          ),

          // IconButton
          _buildSection(
            'IconButton',
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.favorite),
                  color: Colors.red,
                  iconSize: 32,
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.share),
                  color: Colors.blue,
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.settings),
                  color: Colors.grey,
                ),
              ],
            ),
          ),

          // Custom Buttons
          _buildSection(
            'Custom Styled Buttons',
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Custom Elevated'),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.green,
                    side: const BorderSide(color: Colors.green, width: 2),
                    shape: const StadiumBorder(),
                  ),
                  child: const Text('Custom Outlined'),
                ),
              ],
            ),
          ),

          // Counter Example
          _buildSection(
            'مثال تفاعلي - عداد',
            Column(
              children: [
                Text(
                  'العدد: $_counter',
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _counter > 0 ? () => setState(() => _counter--) : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(16),
                      ),
                      child: const Icon(Icons.remove),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () => setState(() => _counter = 0),
                      child: const Text('إعادة ضبط'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () => setState(() => _counter++),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(16),
                      ),
                      child: const Icon(Icons.add),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showMessage('FloatingActionButton'),
        tooltip: 'Floating Action Button',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSection(String title, Widget child) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }

  void _showMessage(String button) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تم الضغط على $button')),
    );
  }
}
