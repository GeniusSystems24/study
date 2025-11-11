import 'package:flutter/material.dart';

class LayoutScreen extends StatelessWidget {
  const LayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Layout - التخطيط')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection(context, '📏 Expanded & Flexible', _buildExpandedFlexibleExample()),
          _buildSection(context, '📚 Stack', _buildStackExample()),
          _buildSection(context, '🔄 Wrap', _buildWrapExample()),
          _buildSection(context, '🎯 Align & Center', _buildAlignCenterExample()),
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

  Widget _buildExpandedFlexibleExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Expanded - يملأ المساحة المتاحة:'),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  color: Colors.red,
                  child: const Center(child: Text('50', style: TextStyle(color: Colors.white))),
                ),
                Expanded(
                  child: Container(
                    height: 50,
                    color: Colors.blue,
                    child: const Center(child: Text('Expanded', style: TextStyle(color: Colors.white))),
                  ),
                ),
                Container(
                  width: 50,
                  height: 50,
                  color: Colors.green,
                  child: const Center(child: Text('50', style: TextStyle(color: Colors.white))),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text('Flexible مع flex مختلفة:'),
            const SizedBox(height: 12),
            Row(
              children: [
                Flexible(
                  flex: 1,
                  child: Container(
                    height: 50,
                    color: Colors.orange,
                    child: const Center(child: Text('flex: 1', style: TextStyle(color: Colors.white))),
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: Container(
                    height: 50,
                    color: Colors.purple,
                    child: const Center(child: Text('flex: 2', style: TextStyle(color: Colors.white))),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Container(
                    height: 50,
                    color: Colors.teal,
                    child: const Center(child: Text('flex: 1', style: TextStyle(color: Colors.white))),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStackExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Stack - تكديس العناصر فوق بعضها:'),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.blue, Colors.purple],
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  const Positioned(
                    top: 20,
                    left: 20,
                    child: Icon(Icons.star, size: 60, color: Colors.white),
                  ),
                  Positioned(
                    bottom: 20,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'Positioned',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const Center(
                    child: Text(
                      'Stack',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
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

  Widget _buildWrapExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Wrap - التفاف تلقائي للعناصر:'),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(
                15,
                (index) => Chip(
                  label: Text('عنصر ${index + 1}'),
                  backgroundColor: Colors.primaries[index % Colors.primaries.length].shade100,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlignCenterExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Align - المحاذاة:'),
            const SizedBox(height: 16),
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Chip(label: Text('أعلى يسار')),
                  ),
                  const Align(
                    alignment: Alignment.topRight,
                    child: Chip(label: Text('أعلى يمين')),
                  ),
                  const Align(
                    alignment: Alignment.center,
                    child: Chip(label: Text('مركز')),
                  ),
                  const Align(
                    alignment: Alignment.bottomLeft,
                    child: Chip(label: Text('أسفل يسار')),
                  ),
                  const Align(
                    alignment: Alignment.bottomRight,
                    child: Chip(label: Text('أسفل يمين')),
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
