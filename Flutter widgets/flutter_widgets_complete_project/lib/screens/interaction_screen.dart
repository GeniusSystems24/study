import 'package:flutter/material.dart';

class InteractionScreen extends StatefulWidget {
  const InteractionScreen({super.key});

  @override
  State<InteractionScreen> createState() => _InteractionScreenState();
}

class _InteractionScreenState extends State<InteractionScreen> {
  String _gestureText = 'انقر أو اسحب على المربع';
  Offset _position = const Offset(100, 100);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Interaction Models')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection(context, '👆 GestureDetector', _buildGestureDetectorExample()),
          _buildSection(context, '💧 InkWell', _buildInkWellExample()),
          _buildSection(context, '🚮 Dismissible', _buildDismissibleExample()),
          _buildSection(context, '🎯 Draggable', _buildDraggableExample()),
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

  Widget _buildGestureDetectorExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              _gestureText,
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Center(
              child: GestureDetector(
                onTap: () => setState(() => _gestureText = 'تم النقر! 👆'),
                onDoubleTap: () => setState(() => _gestureText = 'نقر مزدوج! 👆👆'),
                onLongPress: () => setState(() => _gestureText = 'ضغطة طويلة! ⏱️'),
                onPanUpdate: (details) =>
                    setState(() => _gestureText = 'السحب: ${details.delta}'),
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.blue, Colors.purple],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Center(
                    child: Icon(Icons.touch_app, size: 80, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInkWellExample() {
    return Card(
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم النقر على InkWell')),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: const [
              Icon(Icons.water_drop, size: 60, color: Colors.blue),
              SizedBox(height: 16),
              Text(
                'InkWell - تأثير الحبر',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('انقر لرؤية تأثير الموجة'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDismissibleExample() {
    final List<String> items = List.generate(5, (index) => 'عنصر ${index + 1}');
    
    return Card(
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'اسحب العنصر لليسار أو اليمين لحذفه',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          ...items.map((item) => Dismissible(
                key: Key(item),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (direction) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('تم حذف $item')),
                  );
                },
                child: ListTile(
                  leading: const Icon(Icons.label),
                  title: Text(item),
                  trailing: const Icon(Icons.chevron_right),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildDraggableExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'اسحب المربع لتحريكه',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: Stack(
                children: [
                  Positioned(
                    left: _position.dx,
                    top: _position.dy,
                    child: Draggable(
                      feedback: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Icon(Icons.catching_pokemon, size: 50, color: Colors.white),
                      ),
                      childWhenDragging: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onDragEnd: (details) {
                        setState(() {
                          _position = details.offset;
                        });
                      },
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Icon(Icons.catching_pokemon, size: 50, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
