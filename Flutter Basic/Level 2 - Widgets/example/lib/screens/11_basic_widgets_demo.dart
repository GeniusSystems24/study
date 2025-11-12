import 'package:flutter/material.dart';

/// شاشة توضيحية للـ Widgets الأساسية (الموضوع 11)
class BasicWidgetsDemo extends StatelessWidget {
  const BasicWidgetsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('11. Basic Widgets'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // قسم Text
          _buildSectionTitle('1. Text Widget'),
          _buildTextExamples(),
          
          const SizedBox(height: 24),
          
          // قسم Image
          _buildSectionTitle('2. Image Widget'),
          _buildImageExamples(),
          
          const SizedBox(height: 24),
          
          // قسم Icon
          _buildSectionTitle('3. Icon Widget'),
          _buildIconExamples(),
          
          const SizedBox(height: 24),
          
          // قسم Container
          _buildSectionTitle('4. Container Widget'),
          _buildContainerExamples(),
          
          const SizedBox(height: 24),
          
          // قسم Padding & SizedBox
          _buildSectionTitle('5. Padding & SizedBox'),
          _buildPaddingExamples(),
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
          color: Colors.blue,
        ),
      ),
    );
  }

  Widget _buildTextExamples() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // نص بسيط
            const Text('نص بسيط - Simple Text'),
            
            const SizedBox(height: 12),
            
            // نص منسق
            const Text(
              'نص منسق بخط كبير وعريض',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
            
            const SizedBox(height: 12),
            
            // نص متعدد الأسطر
            const Text(
              'هذا نص متعدد الأسطر يوضح كيفية التعامل مع النصوص الطويلة في Flutter. '
              'يمكنك التحكم في عدد الأسطر والتجاوز (overflow).',
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(height: 1.5),
            ),
            
            const SizedBox(height: 12),
            
            // RichText - نص منسق جزئياً
            RichText(
              text: const TextSpan(
                text: 'نص مختلط: ',
                style: TextStyle(color: Colors.black, fontSize: 16),
                children: [
                  TextSpan(
                    text: 'عريض',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: ' و '),
                  TextSpan(
                    text: 'ملون',
                    style: TextStyle(color: Colors.red),
                  ),
                  TextSpan(text: ' و '),
                  TextSpan(
                    text: 'مائل',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageExamples() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('صور من الشبكة:'),
            const SizedBox(height: 8),
            
            // صورة من الإنترنت
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                'https://picsum.photos/400/200',
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: 150,
                    color: Colors.grey[200],
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 150,
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(Icons.error, color: Colors.red),
                    ),
                  );
                },
              ),
            ),
            
            const SizedBox(height: 12),
            
            // صور مصغرة
            const Text('أحجام مختلفة:'),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ClipOval(
                  child: Image.network(
                    'https://picsum.photos/100/100?random=1',
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    'https://picsum.photos/100/100?random=2',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.blue, width: 3),
                  ),
                  child: ClipOval(
                    child: Image.network(
                      'https://picsum.photos/100/100?random=3',
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconExamples() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('أيقونات Material:'),
            const SizedBox(height: 12),
            
            // أيقونات بأحجام وألوان مختلفة
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _buildIconItem(Icons.home, 'Home', Colors.blue),
                _buildIconItem(Icons.favorite, 'Favorite', Colors.red),
                _buildIconItem(Icons.star, 'Star', Colors.amber),
                _buildIconItem(Icons.settings, 'Settings', Colors.grey),
                _buildIconItem(Icons.notifications, 'Notifications', Colors.orange),
                _buildIconItem(Icons.person, 'Person', Colors.green),
                _buildIconItem(Icons.shopping_cart, 'Cart', Colors.purple),
                _buildIconItem(Icons.search, 'Search', Colors.teal),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // أيقونات بأحجام مختلفة
            const Text('أحجام مختلفة:'),
            const SizedBox(height: 8),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(Icons.star, size: 20, color: Colors.amber),
                Icon(Icons.star, size: 30, color: Colors.amber),
                Icon(Icons.star, size: 40, color: Colors.amber),
                Icon(Icons.star, size: 50, color: Colors.amber),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconItem(IconData icon, String label, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 11),
        ),
      ],
    );
  }

  Widget _buildContainerExamples() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('أمثلة Container:'),
            const SizedBox(height: 12),
            
            // Container بسيط
            Container(
              width: double.infinity,
              height: 60,
              color: Colors.blue[100],
              alignment: Alignment.center,
              child: const Text('Container بلون خلفية'),
            ),
            
            const SizedBox(height: 12),
            
            // Container مع زخرفة
            Container(
              width: double.infinity,
              height: 80,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.purple, Colors.pink],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: const Text(
                'Container مع Gradient',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Containers متعددة
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.favorite, color: Colors.white),
                ),
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.check, color: Colors.white),
                ),
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue, width: 3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.star, color: Colors.blue),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaddingExamples() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Padding - المسافات الداخلية:'),
            const SizedBox(height: 12),
            
            // Padding متساوية
            Container(
              color: Colors.grey[200],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  color: Colors.blue[100],
                  height: 50,
                  alignment: Alignment.center,
                  child: const Text('Padding متساوية (16)'),
                ),
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Padding غير متساوية
            Container(
              color: Colors.grey[200],
              child: Padding(
                padding: const EdgeInsets.fromLTRB(32, 8, 16, 24),
                child: Container(
                  color: Colors.green[100],
                  height: 50,
                  alignment: Alignment.center,
                  child: const Text('Padding مختلفة'),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            const Text('SizedBox - صندوق بحجم محدد:'),
            const SizedBox(height: 12),
            
            // SizedBox كمسافة
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  color: Colors.red,
                ),
                const SizedBox(width: 16), // مسافة أفقية
                Container(
                  width: 50,
                  height: 50,
                  color: Colors.green,
                ),
                const SizedBox(width: 32), // مسافة أكبر
                Container(
                  width: 50,
                  height: 50,
                  color: Colors.blue,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
