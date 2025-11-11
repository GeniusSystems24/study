import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CupertinoWidgetsScreen extends StatefulWidget {
  const CupertinoWidgetsScreen({super.key});

  @override
  State<CupertinoWidgetsScreen> createState() => _CupertinoWidgetsScreenState();
}

class _CupertinoWidgetsScreenState extends State<CupertinoWidgetsScreen> {
  bool _switchValue = false;
  double _sliderValue = 0.5;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Cupertino Widgets'),
        previousPageTitle: 'رجوع',
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSection('🔘 Buttons - الأزرار', _buildButtons()),
            _buildSection('⚙️ Controls - عناصر التحكم', _buildControls()),
            _buildSection('📝 Input - الإدخال', _buildInput()),
            _buildSection('💬 Dialogs - الحوارات', _buildDialogs()),
            _buildSection('📋 Lists - القوائم', _buildLists()),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: CupertinoColors.systemBlue,
            ),
          ),
        ),
        content,
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CupertinoButton.filled(
          onPressed: () {},
          child: const Text('CupertinoButton.filled'),
        ),
        const SizedBox(height: 12),
        CupertinoButton(
          color: CupertinoColors.activeBlue,
          onPressed: () {},
          child: const Text('CupertinoButton مع لون'),
        ),
        const SizedBox(height: 12),
        CupertinoButton(
          onPressed: () {},
          child: const Text('CupertinoButton بسيط'),
        ),
      ],
    );
  }

  Widget _buildControls() {
    return Column(
      children: [
        // Switch
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('CupertinoSwitch', style: TextStyle(fontSize: 16)),
            CupertinoSwitch(
              value: _switchValue,
              onChanged: (value) => setState(() => _switchValue = value),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // Slider
        const Text('CupertinoSlider', style: TextStyle(fontSize: 16)),
        CupertinoSlider(
          value: _sliderValue,
          onChanged: (value) => setState(() => _sliderValue = value),
        ),
        const SizedBox(height: 16),
        
        // ActivityIndicator
        const Text('CupertinoActivityIndicator', style: TextStyle(fontSize: 16)),
        const SizedBox(height: 8),
        const CupertinoActivityIndicator(),
      ],
    );
  }

  Widget _buildInput() {
    return Column(
      children: [
        const CupertinoTextField(
          placeholder: 'أدخل نصاً',
          prefix: Padding(
            padding: EdgeInsets.only(right: 8),
            child: Icon(CupertinoIcons.search),
          ),
        ),
        const SizedBox(height: 16),
        const CupertinoTextField(
          placeholder: 'حقل نص متعدد الأسطر',
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildDialogs() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CupertinoButton.filled(
          onPressed: () => _showCupertinoDialog(),
          child: const Text('CupertinoAlertDialog'),
        ),
        const SizedBox(height: 12),
        CupertinoButton.filled(
          onPressed: () => _showActionSheet(),
          child: const Text('CupertinoActionSheet'),
        ),
      ],
    );
  }

  void _showCupertinoDialog() {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('حوار iOS'),
        content: const Text('هذا مثال على حوار بنمط iOS'),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.pop(context),
            child: const Text('موافق'),
          ),
        ],
      ),
    );
  }

  void _showActionSheet() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: const Text('الخيارات'),
        message: const Text('اختر إجراءً'),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(context),
            child: const Text('الخيار الأول'),
          ),
          CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(context),
            child: const Text('الخيار الثاني'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDestructiveAction: true,
          onPressed: () => Navigator.pop(context),
          child: const Text('إلغاء'),
        ),
      ),
    );
  }

  Widget _buildLists() {
    return Column(
      children: List.generate(
        4,
        (index) => CupertinoListTile(
          leading: const Icon(CupertinoIcons.person),
          title: Text('عنصر ${index + 1}'),
          subtitle: Text('وصف العنصر ${index + 1}'),
          trailing: const Icon(CupertinoIcons.chevron_forward),
          onTap: () {},
        ),
      ),
    );
  }
}
