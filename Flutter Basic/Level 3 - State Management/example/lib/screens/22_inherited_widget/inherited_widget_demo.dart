import 'package:flutter/material.dart';

/// شاشة عرض InheritedWidget - الموضوع 22
class InheritedWidgetDemo extends StatelessWidget {
  const InheritedWidgetDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('InheritedWidget'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '🔗 ما هو InheritedWidget؟',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'InheritedWidget هو Widget خاص في Flutter يسمح بمشاركة البيانات '
                    'بكفاءة عبر Widget Tree دون الحاجة لتمرير البيانات يدوياً عبر constructors.\n\n'
                    'هو الأساس الذي بُنيت عليه معظم حلول State Management مثل Provider.',
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          Card(
            color: Colors.blue.withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '✨ المزايا',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  const Text('✓ مشاركة البيانات بسهولة'),
                  const Text('✓ تحديثات فعّالة'),
                  const Text('✓ لا حاجة لتمرير البيانات يدوياً'),
                  const Text('✓ الأساس لـ Provider وحلول أخرى'),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          Card(
            color: Colors.orange.withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.code, color: Colors.orange),
                      const SizedBox(width: 8),
                      Text(
                        'مثال على الكود',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'class MyInheritedWidget extends InheritedWidget {\n'
                      '  final int data;\n\n'
                      '  const MyInheritedWidget({\n'
                      '    required this.data,\n'
                      '    required super.child,\n'
                      '  });\n\n'
                      '  static MyInheritedWidget? of(BuildContext context) {\n'
                      '    return context.dependOnInheritedWidgetOfExactType<\n'
                      '        MyInheritedWidget>();\n'
                      '  }\n\n'
                      '  @override\n'
                      '  bool updateShouldNotify(MyInheritedWidget old) {\n'
                      '    return data != old.data;\n'
                      '  }\n'
                      '}',
                      style: TextStyle(
                        color: Colors.greenAccent,
                        fontFamily: 'monospace',
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // مثال تفاعلي
          const Text(
            '🎯 مثال تفاعلي',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          const _InheritedWidgetExample(),
        ],
      ),
    );
  }
}

// مثال InheritedWidget: Counter
class CounterInherited extends InheritedWidget {
  final int counter;
  final VoidCallback increment;

  const CounterInherited({
    super.key,
    required this.counter,
    required this.increment,
    required super.child,
  });

  static CounterInherited? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CounterInherited>();
  }

  @override
  bool updateShouldNotify(CounterInherited oldWidget) {
    return counter != oldWidget.counter;
  }
}

// Widget يستخدم InheritedWidget
class _InheritedWidgetExample extends StatefulWidget {
  const _InheritedWidgetExample();

  @override
  State<_InheritedWidgetExample> createState() => _InheritedWidgetExampleState();
}

class _InheritedWidgetExampleState extends State<_InheritedWidgetExample> {
  int _counter = 0;

  void _increment() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CounterInherited(
      counter: _counter,
      increment: _increment,
      child: Column(
        children: [
          Card(
            color: Colors.purple.withOpacity(0.1),
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'هذا Widget يعرض القيمة من InheritedWidget',
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 16),
                  _CounterDisplay(),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            color: Colors.green.withOpacity(0.1),
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'هذا Widget يعدّل القيمة',
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 16),
                  _IncrementButton(),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            color: Colors.amber.withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.info_outline, color: Colors.amber),
                      const SizedBox(width: 8),
                      Text(
                        'ملاحظة',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'لاحظ أن كلا الـ Widgets يصلان للبيانات نفسها '
                    'دون الحاجة لتمرير parameters!',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Widget يعرض العداد
class _CounterDisplay extends StatelessWidget {
  const _CounterDisplay();

  @override
  Widget build(BuildContext context) {
    final inherited = CounterInherited.of(context);
    
    return Column(
      children: [
        const Icon(Icons.visibility, size: 48, color: Colors.purple),
        const SizedBox(height: 8),
        Text(
          'العدد: ${inherited?.counter ?? 0}',
          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

// Widget يزيد العداد
class _IncrementButton extends StatelessWidget {
  const _IncrementButton();

  @override
  Widget build(BuildContext context) {
    final inherited = CounterInherited.of(context);
    
    return Column(
      children: [
        const Icon(Icons.touch_app, size: 48, color: Colors.green),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: inherited?.increment,
          icon: const Icon(Icons.add),
          label: const Text('زيادة العداد'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
      ],
    );
  }
}
