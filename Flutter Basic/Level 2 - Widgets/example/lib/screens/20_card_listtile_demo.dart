import 'package:flutter/material.dart';

/// شاشة توضيحية لـ Card & ListTile (الموضوع 20)
class CardListTileDemo extends StatelessWidget {
  const CardListTileDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('20. Card & ListTile'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Card بسيط
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text('Card بسيط', style: TextStyle(fontSize: 18)),
            ),
          ),

          const SizedBox(height: 16),

          // Card مع صورة
          Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  'https://picsum.photos/400/200',
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('عنوان البطاقة', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Text('هذا وصف للبطاقة. يمكن أن يحتوي على نص طويل.'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Card مع أزرار
          Card(
            child: Column(
              children: [
                const ListTile(
                  title: Text('بطاقة تفاعلية'),
                  subtitle: Text('مع أزرار إجراءات'),
                  leading: Icon(Icons.card_giftcard),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(onPressed: () {}, child: const Text('إلغاء')),
                      const SizedBox(width: 8),
                      ElevatedButton(onPressed: () {}, child: const Text('تأكيد')),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          const Text('ListTile Examples:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),

          // ListTile أمثلة
          Card(
            child: Column(
              children: [
                const ListTile(
                  leading: Icon(Icons.person),
                  title: Text('الاسم'),
                  subtitle: Text('محمد أحمد'),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
                const Divider(height: 1),
                const ListTile(
                  leading: Icon(Icons.email),
                  title: Text('البريد الإلكتروني'),
                  subtitle: Text('example@email.com'),
                ),
                const Divider(height: 1),
                const ListTile(
                  leading: Icon(Icons.phone),
                  title: Text('الهاتف'),
                  subtitle: Text('+966 50 123 4567'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.location_on),
                  title: const Text('الموقع'),
                  subtitle: const Text('الرياض، المملكة العربية السعودية'),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ListTile مع Switch
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('الإشعارات'),
                  subtitle: const Text('تفعيل/تعطيل الإشعارات'),
                  value: true,
                  onChanged: (value) {},
                  secondary: const Icon(Icons.notifications),
                ),
                const Divider(height: 1),
                CheckboxListTile(
                  title: const Text('حفظ كلمة المرور'),
                  value: false,
                  onChanged: (value) {},
                  secondary: const Icon(Icons.security),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // قائمة مع Divider
          const Text('قائمة مع فواصل:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: List.generate(5, (index) {
                return Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.primaries[index % Colors.primaries.length],
                        child: Text('${index + 1}'),
                      ),
                      title: Text('عنصر ${index + 1}'),
                      subtitle: Text('وصف العنصر ${index + 1}'),
                      trailing: const Icon(Icons.more_vert),
                    ),
                    if (index < 4) const Divider(height: 1),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
