import 'package:flutter/material.dart';

/// شاشة توضيحية لـ Dialog & SnackBar (الموضوع 16)
class DialogSnackBarDemo extends StatelessWidget {
  const DialogSnackBarDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('16. Dialog & SnackBar'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // AlertDialog
          _buildCard(
            'AlertDialog',
            ElevatedButton(
              onPressed: () => _showAlertDialog(context),
              child: const Text('عرض AlertDialog'),
            ),
          ),

          // SimpleDialog
          _buildCard(
            'SimpleDialog',
            ElevatedButton(
              onPressed: () => _showSimpleDialog(context),
              child: const Text('عرض SimpleDialog'),
            ),
          ),

          // BottomSheet
          _buildCard(
            'BottomSheet',
            ElevatedButton(
              onPressed: () => _showBottomSheet(context),
              child: const Text('عرض BottomSheet'),
            ),
          ),

          // ModalBottomSheet
          _buildCard(
            'ModalBottomSheet',
            ElevatedButton(
              onPressed: () => _showModalBottomSheet(context),
              child: const Text('عرض ModalBottomSheet'),
            ),
          ),

          // SnackBar
          _buildCard(
            'SnackBar',
            Column(
              children: [
                ElevatedButton(
                  onPressed: () => _showSnackBar(context, 'رسالة بسيطة'),
                  child: const Text('SnackBar بسيط'),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => _showSnackBarWithAction(context),
                  child: const Text('SnackBar مع إجراء'),
                ),
              ],
            ),
          ),

          // Custom Dialog
          _buildCard(
            'Custom Dialog',
            ElevatedButton(
              onPressed: () => _showCustomDialog(context),
              child: const Text('عرض Custom Dialog'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(String title, Widget child) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }

  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تنبيه'),
        content: const Text('هل أنت متأكد من هذا الإجراء؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSnackBar(context, 'تم التأكيد');
            },
            child: const Text('تأكيد'),
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
            onPressed: () {
              Navigator.pop(context);
              _showSnackBar(context, 'تم اختيار الخيار 1');
            },
            child: const Text('الخيار 1'),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context);
              _showSnackBar(context, 'تم اختيار الخيار 2');
            },
            child: const Text('الخيار 2'),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context);
              _showSnackBar(context, 'تم اختيار الخيار 3');
            },
            child: const Text('الخيار 3'),
          ),
        ],
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    showBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('مشاركة'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.link),
              title: const Text('نسخ الرابط'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('حذف'),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Text(
              'Modal Bottom Sheet',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text('هذا مثال على ModalBottomSheet'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إغلاق'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _showSnackBarWithAction(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('تم حذف العنصر'),
        action: SnackBarAction(
          label: 'تراجع',
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('تم التراجع')),
            );
          },
        ),
      ),
    );
  }

  void _showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 64),
              const SizedBox(height: 16),
              const Text(
                'نجح!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text('تمت العملية بنجاح'),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('موافق'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
