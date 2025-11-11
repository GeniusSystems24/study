import 'package:flutter/material.dart';

class MaterialWidgetsScreen extends StatelessWidget {
  const MaterialWidgetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Material Widgets'),
        elevation: 2,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader(context, '🔘 Buttons - الأزرار'),
          _buildButtonExamples(context),
          const SizedBox(height: 24),
          
          _buildSectionHeader(context, '🃏 Cards & Containers - البطاقات'),
          _buildCardExamples(context),
          const SizedBox(height: 24),
          
          _buildSectionHeader(context, '📋 Lists - القوائم'),
          _buildListExamples(context),
          const SizedBox(height: 24),
          
          _buildSectionHeader(context, '💬 Dialogs - الحوارات'),
          _buildDialogButton(context),
          const SizedBox(height: 24),
          
          _buildSectionHeader(context, '🧭 Navigation - التنقل'),
          _buildNavigationExamples(context),
          const SizedBox(height: 24),
          
          _buildSectionHeader(context, '📊 Progress Indicators - مؤشرات التقدم'),
          _buildProgressExamples(context),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildButtonExamples(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ElevatedButton
            ElevatedButton(
              onPressed: () {},
              child: const Text('ElevatedButton - زر بارز'),
            ),
            const SizedBox(height: 12),
            
            // FilledButton
            FilledButton(
              onPressed: () {},
              child: const Text('FilledButton - زر ممتلئ'),
            ),
            const SizedBox(height: 12),
            
            // OutlinedButton
            OutlinedButton(
              onPressed: () {},
              child: const Text('OutlinedButton - زر محدد'),
            ),
            const SizedBox(height: 12),
            
            // TextButton
            TextButton(
              onPressed: () {},
              child: const Text('TextButton - زر نصي'),
            ),
            const SizedBox(height: 12),
            
            // IconButton
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.favorite),
                  tooltip: 'مفضلة',
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.share),
                  tooltip: 'مشاركة',
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.download),
                  tooltip: 'تحميل',
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // FloatingActionButton
            const Text('FloatingActionButton:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton.small(
                  onPressed: () {},
                  child: const Icon(Icons.add),
                ),
                FloatingActionButton(
                  onPressed: () {},
                  child: const Icon(Icons.edit),
                ),
                FloatingActionButton.extended(
                  onPressed: () {},
                  icon: const Icon(Icons.save),
                  label: const Text('حفظ'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardExamples(BuildContext context) {
    return Column(
      children: [
        Card(
          elevation: 4,
          child: ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.person),
            ),
            title: const Text('بطاقة بسيطة'),
            subtitle: const Text('مع ListTile'),
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 160,
                color: Colors.blue.shade100,
                child: const Center(
                  child: Icon(Icons.image, size: 80, color: Colors.blue),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'بطاقة مع صورة',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'مثال على بطاقة Material مع صورة ومحتوى نصي.',
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: const Text('إلغاء'),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text('موافق'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildListExamples(BuildContext context) {
    return Card(
      child: Column(
        children: List.generate(
          4,
          (index) => ListTile(
            leading: CircleAvatar(
              child: Text('${index + 1}'),
            ),
            title: Text('عنصر القائمة ${index + 1}'),
            subtitle: Text('وصف العنصر ${index + 1}'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
        ),
      ),
    );
  }

  Widget _buildDialogButton(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () => _showAlertDialog(context),
              child: const Text('AlertDialog - حوار تنبيه'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => _showSimpleDialog(context),
              child: const Text('SimpleDialog - حوار بسيط'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => _showBottomSheet(context),
              child: const Text('BottomSheet - ورقة سفلية'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => _showSnackBar(context),
              child: const Text('SnackBar - شريط رسائل'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.info_outline),
        title: const Text('حوار تنبيه'),
        content: const Text('هذا مثال على حوار التنبيه في Material Design.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('موافق'),
          ),
        ],
      ),
    );
  }

  void _showSimpleDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('اختر خياراً'),
        children: [
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context),
            child: const Text('الخيار الأول'),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context),
            child: const Text('الخيار الثاني'),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context),
            child: const Text('الخيار الثالث'),
          ),
        ],
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'ورقة سفلية',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text('محتوى الورقة السفلية يظهر من أسفل الشاشة.'),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إغلاق'),
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('هذا شريط رسائل SnackBar'),
        action: SnackBarAction(
          label: 'تراجع',
          onPressed: () {},
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _buildNavigationExamples(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'أمثلة على عناصر التنقل:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const ListTile(
              leading: Icon(Icons.menu),
              title: Text('Drawer - قائمة جانبية'),
              subtitle: Text('يمكن فتحها من الزر أعلى اليسار'),
            ),
            const ListTile(
              leading: Icon(Icons.navigation),
              title: Text('NavigationBar - شريط تنقل'),
              subtitle: Text('في أسفل الشاشة'),
            ),
            const ListTile(
              leading: Icon(Icons.tab),
              title: Text('TabBar - شريط تبويبات'),
              subtitle: Text('للتنقل بين الصفحات'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressExamples(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'CircularProgressIndicator',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const CircularProgressIndicator(),
            const SizedBox(height: 24),
            const Text(
              'LinearProgressIndicator',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const LinearProgressIndicator(),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: 0.7,
              backgroundColor: Colors.grey.shade200,
            ),
          ],
        ),
      ),
    );
  }
}
