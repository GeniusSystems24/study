import 'package:flutter/material.dart';

/// شاشة عرض State Management Basics - الموضوع 21
class StateBasicsDemo extends StatelessWidget {
  const StateBasicsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('State Management Basics'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'مفهوم State'),
              Tab(text: 'setState'),
              Tab(text: 'Lifecycle'),
              Tab(text: 'Ephemeral vs App State'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _StateConceptTab(),
            _SetStateTab(),
            _LifecycleTab(),
            _StateTypesTab(),
          ],
        ),
      ),
    );
  }
}

// التاب الأول: مفهوم State
class _StateConceptTab extends StatelessWidget {
  const _StateConceptTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '📚 ما هو State؟',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                const Text(
                  'State هو البيانات التي يمكن أن تتغير أثناء عمر Widget.\n\n'
                  'عندما تتغير State، يُعاد بناء Widget لتعكس التغيير.',
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'StatelessWidget vs StatefulWidget',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                const Text('📌 StatelessWidget:'),
                const Text('• لا يحتوي على state قابل للتغيير'),
                const Text('• يُبنى مرة واحدة فقط'),
                const Text('• مثالي للواجهات الثابتة'),
                const SizedBox(height: 8),
                const Text('📌 StatefulWidget:'),
                const Text('• يحتوي على state قابل للتغيير'),
                const Text('• يمكن إعادة بنائه عند تغيير State'),
                const Text('• مثالي للواجهات التفاعلية'),
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
                Row(
                  children: [
                    const Icon(Icons.code, color: Colors.blue),
                    const SizedBox(width: 8),
                    Text(
                      'مثال: StatelessWidget',
                      style: Theme.of(context).textTheme.titleMedium,
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
                    'class MyWidget extends StatelessWidget {\n'
                    '  @override\n'
                    '  Widget build(BuildContext context) {\n'
                    '    return Text("لا يتغير");\n'
                    '  }\n'
                    '}',
                    style: TextStyle(
                      color: Colors.greenAccent,
                      fontFamily: 'monospace',
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        Card(
          color: Colors.green.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.code, color: Colors.green),
                    const SizedBox(width: 8),
                    Text(
                      'مثال: StatefulWidget',
                      style: Theme.of(context).textTheme.titleMedium,
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
                    'class MyWidget extends StatefulWidget {\n'
                    '  @override\n'
                    '  State<MyWidget> createState() => _MyWidgetState();\n'
                    '}\n\n'
                    'class _MyWidgetState extends State<MyWidget> {\n'
                    '  int counter = 0;\n\n'
                    '  @override\n'
                    '  Widget build(BuildContext context) {\n'
                    '    return Text("العدد: \$counter");\n'
                    '  }\n'
                    '}',
                    style: TextStyle(
                      color: Colors.greenAccent,
                      fontFamily: 'monospace',
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// التاب الثاني: setState
class _SetStateTab extends StatefulWidget {
  const _SetStateTab();

  @override
  State<_SetStateTab> createState() => _SetStateTabState();
}

class _SetStateTabState extends State<_SetStateTab> {
  int _counter = 0;
  bool _isVisible = true;
  String _selectedColor = 'أزرق';

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _toggleVisibility() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '🔄 setState()',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                const Text(
                  'setState() هي الطريقة الأساسية لتحديث State في StatefulWidget.\n\n'
                  'عند استدعائها، تخبر Flutter بأن state قد تغيرت ويجب إعادة بناء Widget.',
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // مثال 1: Counter
        Card(
          color: Colors.blue.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  'مثال 1: Counter',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                Text(
                  'العدد: $_counter',
                  style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _incrementCounter,
                      icon: const Icon(Icons.add),
                      label: const Text('زيادة'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _counter = 0;
                        });
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('إعادة تعيين'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // مثال 2: Toggle Visibility
        Card(
          color: Colors.green.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  'مثال 2: Toggle Visibility',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                if (_isVisible)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'مرحباً! أنا مرئي الآن 👋',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _toggleVisibility,
                  icon: Icon(_isVisible ? Icons.visibility_off : Icons.visibility),
                  label: Text(_isVisible ? 'إخفاء' : 'إظهار'),
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // مثال 3: Dropdown
        Card(
          color: Colors.purple.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  'مثال 3: Dropdown',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                Text(
                  'اللون المختار: $_selectedColor',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 16),
                DropdownButton<String>(
                  value: _selectedColor,
                  isExpanded: true,
                  items: ['أزرق', 'أخضر', 'أحمر', 'برتقالي']
                      .map((color) => DropdownMenuItem(
                            value: color,
                            child: Text(color),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedColor = value!;
                    });
                  },
                ),
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
                    const Icon(Icons.warning_amber, color: Colors.orange),
                    const SizedBox(width: 8),
                    Text(
                      'ملاحظات مهمة',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text('✓ دائماً استخدم setState() لتحديث state'),
                const Text('✓ لا تقم بعمليات معقدة داخل setState()'),
                const Text('✓ setState() يُعيد بناء Widget بالكامل'),
                const Text('✗ لا تستدعي setState() في build()'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// التاب الثالث: Lifecycle
class _LifecycleTab extends StatefulWidget {
  const _LifecycleTab();

  @override
  State<_LifecycleTab> createState() => _LifecycleTabState();
}

class _LifecycleTabState extends State<_LifecycleTab> {
  final List<String> _logs = [];

  @override
  void initState() {
    super.initState();
    _addLog('initState() - يُستدعى مرة واحدة عند الإنشاء');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _addLog('didChangeDependencies() - يُستدعى عند تغيير dependencies');
  }

  @override
  void didUpdateWidget(_LifecycleTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    _addLog('didUpdateWidget() - يُستدعى عند تحديث Widget');
  }

  @override
  void dispose() {
    _addLog('dispose() - يُستدعى عند حذف Widget');
    super.dispose();
  }

  void _addLog(String message) {
    if (mounted) {
      setState(() {
        _logs.add('${DateTime.now().toString().substring(11, 19)} - $message');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '♻️ Widget Lifecycle',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Lifecycle Methods هي دوال تُستدعى في مراحل مختلفة من حياة Widget.',
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
                  'ترتيب استدعاء Methods',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                const Text('1️⃣ initState() - الإنشاء'),
                const Text('2️⃣ didChangeDependencies() - بعد initState'),
                const Text('3️⃣ build() - بناء UI'),
                const Text('4️⃣ didUpdateWidget() - عند التحديث'),
                const Text('5️⃣ setState() - تحديث State'),
                const Text('6️⃣ dispose() - عند الحذف'),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Lifecycle Logs',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _logs.clear();
                        });
                      },
                      icon: const Icon(Icons.clear_all),
                      label: const Text('مسح'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  height: 200,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListView.builder(
                    itemCount: _logs.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Text(
                          _logs[index],
                          style: const TextStyle(
                            color: Colors.greenAccent,
                            fontFamily: 'monospace',
                            fontSize: 12,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () => _addLog('Manual log entry'),
                  icon: const Icon(Icons.add),
                  label: const Text('إضافة سجل يدوياً'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// التاب الرابع: State Types
class _StateTypesTab extends StatelessWidget {
  const _StateTypesTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '🎯 Ephemeral vs App State',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                const Text(
                  'في Flutter، هناك نوعان أساسيان من State:',
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
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.blue, size: 32),
                    const SizedBox(width: 12),
                    Text(
                      'Ephemeral State',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text('📌 التعريف:'),
                const Text('State محلي لـ Widget واحد فقط'),
                const SizedBox(height: 8),
                const Text('📌 الخصائص:'),
                const Text('• لا يحتاج للمشاركة مع Widgets أخرى'),
                const Text('• يُدار بـ setState()'),
                const Text('• مؤقت وينتهي مع Widget'),
                const SizedBox(height: 8),
                const Text('📌 أمثلة:'),
                const Text('• PageView current page'),
                const Text('• TextField text'),
                const Text('• Animation progress'),
                const Text('• Checkbox value'),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        Card(
          color: Colors.green.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.public, color: Colors.green, size: 32),
                    const SizedBox(width: 12),
                    Text(
                      'App State',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text('📌 التعريف:'),
                const Text('State مشترك عبر التطبيق'),
                const SizedBox(height: 8),
                const Text('📌 الخصائص:'),
                const Text('• يحتاج للمشاركة مع Widgets متعددة'),
                const Text('• يُدار بحلول مثل Provider, BLoC'),
                const Text('• يستمر طوال عمر التطبيق'),
                const SizedBox(height: 8),
                const Text('📌 أمثلة:'),
                const Text('• User authentication'),
                const Text('• Shopping cart'),
                const Text('• Theme mode'),
                const Text('• Language settings'),
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
                    const Icon(Icons.lightbulb, color: Colors.orange),
                    const SizedBox(width: 8),
                    Text(
                      'متى تستخدم أي نوع؟',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text('✓ استخدم Ephemeral State عندما:'),
                const Text('  • State خاص بـ Widget واحد'),
                const Text('  • لا يحتاج Widgets أخرى للوصول إليه'),
                const Text('  • مثال: TextField, Checkbox'),
                const SizedBox(height: 8),
                const Text('✓ استخدم App State عندما:'),
                const Text('  • State يحتاج للمشاركة'),
                const Text('  • يؤثر على Widgets متعددة'),
                const Text('  • مثال: User data, Cart'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
