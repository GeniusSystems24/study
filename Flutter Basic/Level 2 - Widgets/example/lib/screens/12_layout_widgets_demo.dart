import 'package:flutter/material.dart';

/// شاشة توضيحية لـ Layout Widgets (الموضوع 12)
class LayoutWidgetsDemo extends StatelessWidget {
  const LayoutWidgetsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('12. Layout Widgets'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionTitle('1. Row - الترتيب الأفقي'),
          _buildRowExamples(),
          
          const SizedBox(height: 24),
          
          _buildSectionTitle('2. Column - الترتيب العمودي'),
          _buildColumnExamples(),
          
          const SizedBox(height: 24),
          
          _buildSectionTitle('3. Stack - التكديس'),
          _buildStackExamples(),
          
          const SizedBox(height: 24),
          
          _buildSectionTitle('4. Expanded & Flexible'),
          _buildExpandedFlexibleExamples(),
          
          const SizedBox(height: 24),
          
          _buildSectionTitle('5. Wrap - الالتفاف التلقائي'),
          _buildWrapExamples(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.green,
        ),
      ),
    );
  }

  Widget _buildRowExamples() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('محاذاة افتراضية (Start):'),
            const SizedBox(height: 8),
            Container(
              height: 60,
              color: Colors.grey[200],
              child: Row(
                children: [
                  _buildBox(Colors.red, '1'),
                  _buildBox(Colors.green, '2'),
                  _buildBox(Colors.blue, '3'),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            const Text('محاذاة في المنتصف (Center):'),
            const SizedBox(height: 8),
            Container(
              height: 60,
              color: Colors.grey[200],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildBox(Colors.red, '1'),
                  _buildBox(Colors.green, '2'),
                  _buildBox(Colors.blue, '3'),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            const Text('توزيع متساوي (SpaceBetween):'),
            const SizedBox(height: 8),
            Container(
              height: 60,
              color: Colors.grey[200],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildBox(Colors.red, '1'),
                  _buildBox(Colors.green, '2'),
                  _buildBox(Colors.blue, '3'),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            const Text('مسافات متساوية (SpaceEvenly):'),
            const SizedBox(height: 8),
            Container(
              height: 60,
              color: Colors.grey[200],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildBox(Colors.red, '1'),
                  _buildBox(Colors.green, '2'),
                  _buildBox(Colors.blue, '3'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColumnExamples() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Column 1
            Expanded(
              child: Column(
                children: [
                  const Text('محاذاة Start', style: TextStyle(fontSize: 12)),
                  const SizedBox(height: 4),
                  Container(
                    height: 150,
                    color: Colors.grey[200],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _buildBox(Colors.red, '1'),
                        _buildBox(Colors.green, '2'),
                        _buildBox(Colors.blue, '3'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(width: 8),
            
            // Column 2
            Expanded(
              child: Column(
                children: [
                  const Text('محاذاة Center', style: TextStyle(fontSize: 12)),
                  const SizedBox(height: 4),
                  Container(
                    height: 150,
                    color: Colors.grey[200],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildBox(Colors.red, '1'),
                        _buildBox(Colors.green, '2'),
                        _buildBox(Colors.blue, '3'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(width: 8),
            
            // Column 3
            Expanded(
              child: Column(
                children: [
                  const Text('محاذاة SpaceBetween', style: TextStyle(fontSize: 10)),
                  const SizedBox(height: 4),
                  Container(
                    height: 150,
                    color: Colors.grey[200],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildBox(Colors.red, '1'),
                        _buildBox(Colors.green, '2'),
                        _buildBox(Colors.blue, '3'),
                      ],
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

  Widget _buildStackExamples() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Stack - تكديس العناصر فوق بعضها:'),
            const SizedBox(height: 12),
            
            // مثال 1: Stack بسيط
            SizedBox(
              height: 200,
              child: Stack(
                children: [
                  // الطبقة الخلفية
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.purple[300]!, Colors.blue[300]!],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  
                  // أيقونة في المنتصف
                  const Center(
                    child: Icon(
                      Icons.layers,
                      size: 80,
                      color: Colors.white,
                    ),
                  ),
                  
                  // نص في الأعلى
                  const Positioned(
                    top: 16,
                    left: 16,
                    child: Text(
                      'Stack Example',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  
                  // زر في الأسفل
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text('Action'),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // مثال 2: Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildBadge(Icons.notifications, '5', Colors.red),
                _buildBadge(Icons.shopping_cart, '12', Colors.green),
                _buildBadge(Icons.message, '99+', Colors.blue),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandedFlexibleExamples() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Expanded - توسع متساوي:'),
            const SizedBox(height: 8),
            SizedBox(
              height: 60,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      color: Colors.red[300],
                      alignment: Alignment.center,
                      child: const Text('1', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.green[300],
                      alignment: Alignment.center,
                      child: const Text('1', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.blue[300],
                      alignment: Alignment.center,
                      child: const Text('1', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            const Text('Expanded بنسب مختلفة (flex):'),
            const SizedBox(height: 8),
            SizedBox(
              height: 60,
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      color: Colors.red[300],
                      alignment: Alignment.center,
                      child: const Text('flex: 1', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      color: Colors.green[300],
                      alignment: Alignment.center,
                      child: const Text('flex: 2', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      color: Colors.blue[300],
                      alignment: Alignment.center,
                      child: const Text('flex: 3', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            const Text('Flexible vs Expanded:'),
            const SizedBox(height: 8),
            SizedBox(
              height: 60,
              child: Row(
                children: [
                  Container(
                    width: 80,
                    color: Colors.grey[400],
                    alignment: Alignment.center,
                    child: const Text('Fixed', style: TextStyle(fontSize: 12)),
                  ),
                  Flexible(
                    child: Container(
                      color: Colors.orange[300],
                      alignment: Alignment.center,
                      child: const Text('Flexible', style: TextStyle(fontSize: 12)),
                    ),
                  ),
                  Container(
                    width: 80,
                    color: Colors.grey[400],
                    alignment: Alignment.center,
                    child: const Text('Fixed', style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWrapExamples() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Wrap - الالتفاف التلقائي عند عدم وجود مساحة:'),
            const SizedBox(height: 12),
            
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(
                15,
                (index) => Chip(
                  label: Text('Item ${index + 1}'),
                  backgroundColor: Colors.primaries[index % Colors.primaries.length][100],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            const Text('Wrap مع أحجام مختلفة:'),
            const SizedBox(height: 12),
            
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildChip('Small', Colors.red),
                _buildChip('Medium Tag', Colors.green),
                _buildChip('Large', Colors.blue),
                _buildChip('XS', Colors.orange),
                _buildChip('Very Long Tag Name', Colors.purple),
                _buildChip('Tag', Colors.teal),
                _buildChip('Another Tag', Colors.pink),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBox(Color color, String label) {
    return Container(
      width: 50,
      height: 50,
      color: color,
      alignment: Alignment.center,
      margin: const EdgeInsets.all(4),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildBadge(IconData icon, String count, Color color) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 32, color: color),
        ),
        Positioned(
          right: -5,
          top: -5,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
            child: Text(
              count,
              style: const TextStyle(color: Colors.white, fontSize: 10),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChip(String label, Color color) {
    return Chip(
      label: Text(label),
      backgroundColor: color.withOpacity(0.2),
      labelStyle: TextStyle(color: color),
    );
  }
}
