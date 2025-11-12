import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class I18nHome extends StatelessWidget {
  const I18nHome({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 7,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Internationalization (i18n)'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'المقدمة'),
              Tab(text: 'Setup'),
              Tab(text: 'Translations'),
              Tab(text: 'RTL Support'),
              Tab(text: 'Date & Numbers'),
              Tab(text: 'Dynamic Locale'),
              Tab(text: 'Best Practices'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            IntroductionTab(),
            SetupTab(),
            TranslationsTab(),
            RtlSupportTab(),
            DateNumbersTab(),
            DynamicLocaleTab(),
            BestPracticesTab(),
          ],
        ),
      ),
    );
  }
}

// ==================== Tab 1: Introduction ====================
class IntroductionTab extends StatelessWidget {
  const IntroductionTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildInfoCard(
          context,
          '🌍 Internationalization (i18n)',
          'دعم اللغات المتعددة في التطبيقات',
        ),
        const SizedBox(height: 16),
        _buildContentCard(
          context,
          'ما هو i18n؟',
          '''
Internationalization (i18n):
• عملية تصميم التطبيق لدعم لغات متعددة
• العدد 18 يمثل عدد الحروف بين i و n
• يشمل الترجمة، التواريخ، الأرقام، العملات

Localization (l10n):
• عملية تكييف التطبيق لمنطقة محددة
• ترجمة النصوص
• تنسيق التواريخ والأرقام
• دعم RTL/LTR
''',
        ),
        _buildContentCard(
          context,
          'لماذا i18n مهم؟',
          '''
✅ وصول لجمهور أوسع
✅ تحسين تجربة المستخدم
✅ زيادة التحميلات والمبيعات
✅ احترافية التطبيق
✅ متطلبات بعض الأسواق
✅ تحسين SEO للتطبيقات
''',
        ),
        _buildCodeCard(
          context,
          'Locale Structure',
          '''
Locale locale = Locale('ar', 'SA');
//              Locale(languageCode, countryCode)

// أمثلة شائعة
Locale('en', 'US')  // English - United States
Locale('ar', 'SA')  // Arabic - Saudi Arabia
Locale('fr', 'FR')  // French - France
Locale('es', 'ES')  // Spanish - Spain
''',
        ),
      ],
    );
  }
}

// ==================== Tab 2: Setup ====================
class SetupTab extends StatelessWidget {
  const SetupTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildInfoCard(
          context,
          '⚙️ Setup i18n',
          'إعداد الترجمة في المشروع',
        ),
        const SizedBox(height: 16),
        _buildCodeCard(
          context,
          'Step 1: pubspec.yaml',
          '''
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  intl: ^0.19.0

flutter:
  generate: true
''',
        ),
        _buildCodeCard(
          context,
          'Step 2: l10n.yaml',
          '''
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
''',
        ),
        _buildCodeCard(
          context,
          'Step 3: ARB Files',
          '''
// lib/l10n/app_en.arb
{
  "@@locale": "en",
  "appTitle": "My Application",
  "hello": "Hello",
  "welcome": "Welcome {name}"
}

// lib/l10n/app_ar.arb
{
  "@@locale": "ar",
  "appTitle": "تطبيقي",
  "hello": "مرحباً",
  "welcome": "أهلاً {name}"
}
''',
        ),
        _buildCodeCard(
          context,
          'Step 4: main.dart',
          '''
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

MaterialApp(
  localizationsDelegates: const [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ],
  supportedLocales: const [
    Locale('en'),
    Locale('ar'),
  ],
  home: HomePage(),
)
''',
        ),
      ],
    );
  }
}

// ==================== Tab 3: Translations ====================
class TranslationsTab extends StatelessWidget {
  const TranslationsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildInfoCard(
          context,
          '📝 Translation Patterns',
          'أنماط الترجمة المختلفة',
        ),
        const SizedBox(height: 16),
        _buildCodeCard(
          context,
          'Simple Messages',
          '''
// app_en.arb
{
  "hello": "Hello",
  "save": "Save"
}

// app_ar.arb
{
  "hello": "مرحباً",
  "save": "حفظ"
}

// Usage
Text(AppLocalizations.of(context)!.hello)
''',
        ),
        _buildCodeCard(
          context,
          'Pluralization',
          '''
// app_en.arb
{
  "nMessages": "{count, plural, =0{No messages} =1{1 message} other{{count} messages}}"
}

// app_ar.arb
{
  "nMessages": "{count, plural, =0{لا توجد رسائل} =1{رسالة واحدة} =2{رسالتان} few{{count} رسائل} other{{count} رسالة}}"
}
''',
        ),
      ],
    );
  }
}

// ==================== Tab 4: RTL Support ====================
class RtlSupportTab extends StatelessWidget {
  const RtlSupportTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildInfoCard(
          context,
          '↔️ RTL Support',
          'دعم اللغات من اليمين لليسار',
        ),
        const SizedBox(height: 16),
        _buildContentCard(
          context,
          'RTL Languages',
          '''
اللغات التي تكتب من اليمين لليسار:
• العربية (ar)
• العبرية (he)
• الفارسية (fa)

Flutter يدعم RTL تلقائياً!
''',
        ),
        _buildCodeCard(
          context,
          'RTL-Aware Widgets',
          '''
// ✅ استخدم هذه بدلاً من left/right

EdgeInsetsDirectional.only(
  start: 16,  // يصبح right في RTL
  end: 8,     // يصبح left في RTL
)

AlignmentDirectional.centerStart  // RTL-aware

PositionedDirectional(
  start: 0,
  top: 0,
)
''',
        ),
      ],
    );
  }
}

// ==================== Tab 5: Date & Numbers ====================
class DateNumbersTab extends StatelessWidget {
  const DateNumbersTab({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final number = 1234567.89;
    
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildInfoCard(
          context,
          '📅 Date & Number Formatting',
          'تنسيق التواريخ والأرقام حسب اللغة',
        ),
        const SizedBox(height: 16),
        Card(
          color: Colors.blue.shade50,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '🎮 Live Demo',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(),
                Text('English Date: ${DateFormat.yMMMd('en').format(now)}'),
                Text('Arabic Date: ${DateFormat.yMMMd('ar').format(now)}'),
                const SizedBox(height: 8),
                Text('English Number: ${NumberFormat('#,###.##', 'en').format(number)}'),
                Text('Arabic Number: ${NumberFormat('#,###.##', 'ar').format(number)}'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildCodeCard(
          context,
          'Date Formatting',
          '''
import 'package:intl/intl.dart';

final now = DateTime.now();

// English
DateFormat.yMMMd('en').format(now)  // "Nov 12, 2025"

// Arabic
DateFormat.yMMMd('ar').format(now)  // "١٢ نوفمبر ٢٠٢٥"
''',
        ),
        _buildCodeCard(
          context,
          'Number Formatting',
          '''
final number = 1234567.89;

// English
NumberFormat('#,###.##', 'en').format(number)
// "1,234,567.89"

// Arabic - أرقام عربية
NumberFormat('#,###.##', 'ar').format(number)
// "١٬٢٣٤٬٥٦٧٫٨٩"
''',
        ),
        _buildCodeCard(
          context,
          'Currency',
          '''
NumberFormat.currency(
  locale: 'en_US',
  symbol: '\$',
).format(99.99)  // "\$99.99"

NumberFormat.currency(
  locale: 'ar_SA',
  symbol: 'ر.س',
).format(99.99)  // "٩٩٫٩٩ ر.س"
''',
        ),
      ],
    );
  }
}

// ==================== Tab 6: Dynamic Locale ====================
class DynamicLocaleTab extends StatefulWidget {
  const DynamicLocaleTab({super.key});

  @override
  State<DynamicLocaleTab> createState() => _DynamicLocaleTabState();
}

class _DynamicLocaleTabState extends State<DynamicLocaleTab> {
  String _selectedLang = 'en';

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildInfoCard(
          context,
          '🔄 Dynamic Locale Switching',
          'تغيير اللغة أثناء التشغيل',
        ),
        const SizedBox(height: 16),
        Card(
          color: Colors.blue.shade50,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  '🎮 Language Selector',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: 'en', label: Text('English')),
                    ButtonSegment(value: 'ar', label: Text('العربية')),
                    ButtonSegment(value: 'fr', label: Text('Français')),
                  ],
                  selected: {_selectedLang},
                  onSelectionChanged: (Set<String> selected) {
                    setState(() {
                      _selectedLang = selected.first;
                    });
                  },
                ),
                const SizedBox(height: 16),
                _buildDemoCard(),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildCodeCard(
          context,
          'Using Provider',
          '''
class LocaleProvider extends ChangeNotifier {
  Locale _locale = Locale('en');
  
  Locale get locale => _locale;
  
  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', locale.languageCode);
    
    notifyListeners();
  }
}

// In main.dart
ChangeNotifierProvider(
  create: (_) => LocaleProvider(),
  child: Consumer<LocaleProvider>(
    builder: (context, provider, child) {
      return MaterialApp(
        locale: provider.locale,
        ...
      );
    },
  ),
)
''',
        ),
      ],
    );
  }
  
  Widget _buildDemoCard() {
    final demoTexts = {
      'en': {'greeting': 'Hello!', 'welcome': 'Welcome'},
      'ar': {'greeting': 'مرحباً!', 'welcome': 'أهلاً بك'},
      'fr': {'greeting': 'Bonjour!', 'welcome': 'Bienvenue'},
    };
    
    final texts = demoTexts[_selectedLang]!;
    final isRtl = _selectedLang == 'ar';
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: isRtl ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              texts['greeting']!,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(texts['welcome']!),
            const Divider(),
            Text('Date: ${DateFormat.yMMMd(_selectedLang).format(DateTime.now())}'),
            Text('Number: ${NumberFormat('#,###', _selectedLang).format(12345)}'),
          ],
        ),
      ),
    );
  }
}

// ==================== Tab 7: Best Practices ====================
class BestPracticesTab extends StatelessWidget {
  const BestPracticesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildInfoCard(
          context,
          '✨ i18n Best Practices',
          'أفضل الممارسات في الترجمة',
        ),
        const SizedBox(height: 16),
        _buildContentCard(
          context,
          'Translation Organization',
          '''
✅ استخدم أسماء واضحة ووصفية
✅ نظّم بـ prefixes (login_, home_)
✅ اجعل المفاتيح بالإنجليزية دائماً
✅ أضف descriptions لكل نص
✅ استخدم placeholders
''',
        ),
        _buildContentCard(
          context,
          'RTL Best Practices',
          '''
✅ استخدم EdgeInsetsDirectional
✅ استخدم AlignmentDirectional
✅ اختبر التطبيق في وضع RTL
✅ انتبه لاتجاه الأيقونات
❌ تجنب hardcoded directions
''',
        ),
        _buildContentCard(
          context,
          'Common Mistakes',
          '''
❌ String concatenation
  "Hello" + name  // ❌
  l10n.hello(name)  // ✅

❌ Hardcoded text direction
  Alignment.left  // ❌
  AlignmentDirectional.start  // ✅

❌ ترجمة literals
  Text("Login")  // ❌
  Text(l10n.login)  // ✅
''',
        ),
        _buildCodeCard(
          context,
          'Production Checklist',
          '''
✅ جميع النصوص مترجمة
✅ لا توجد نصوص hardcoded
✅ RTL يعمل بشكل صحيح
✅ التواريخ والأرقام منسقة
✅ اختبار جميع اللغات
✅ حفظ اختيار اللغة
✅ UI للتبديل بين اللغات
''',
        ),
        _buildContentCard(
          context,
          'Tools & Resources',
          '''
📦 Packages:
• flutter_localizations (built-in)
• intl: Date/Number formatting
• easy_localization: Alternative

🛠️ Tools:
• ARB Editor VSCode extension
• Localizely: Translation management

📚 Resources:
• flutter.dev/docs/i18n
• pub.dev/packages/intl
''',
        ),
      ],
    );
  }
}

// ==================== Helper Widgets ====================
Widget _buildInfoCard(BuildContext context, String title, String subtitle) {
  return Card(
    color: Theme.of(context).colorScheme.primaryContainer,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}

Widget _buildContentCard(BuildContext context, String title, String content) {
  return Card(
    margin: const EdgeInsets.only(bottom: 16),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    ),
  );
}

Widget _buildCodeCard(BuildContext context, String title, String code) {
  return Card(
    margin: const EdgeInsets.only(bottom: 16),
    color: Colors.grey[900],
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(8),
            ),
            child: SelectableText(
              code,
              style: const TextStyle(
                fontFamily: 'monospace',
                color: Colors.greenAccent,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

