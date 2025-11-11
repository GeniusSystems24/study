import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextScreen extends StatelessWidget {
  const TextScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Text - النصوص')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection(context, '📝 Text Styles', _buildTextStylesExample(context)),
          _buildSection(context, '🎨 RichText', _buildRichTextExample()),
          _buildSection(context, '✂️ SelectableText', _buildSelectableTextExample()),
          _buildSection(context, '🔤 Google Fonts', _buildGoogleFontsExample()),
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

  Widget _buildTextStylesExample(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Display Large', style: Theme.of(context).textTheme.displayLarge),
            const SizedBox(height: 12),
            Text('Display Medium', style: Theme.of(context).textTheme.displayMedium),
            const SizedBox(height: 12),
            Text('Display Small', style: Theme.of(context).textTheme.displaySmall),
            const Divider(height: 32),
            Text('Headline Large', style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 12),
            Text('Headline Medium', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 12),
            Text('Headline Small', style: Theme.of(context).textTheme.headlineSmall),
            const Divider(height: 32),
            Text('Title Large', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            Text('Title Medium', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Text('Title Small', style: Theme.of(context).textTheme.titleSmall),
            const Divider(height: 32),
            Text('Body Large', style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 12),
            Text('Body Medium', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 12),
            Text('Body Small', style: Theme.of(context).textTheme.bodySmall),
            const Divider(height: 32),
            Text('Label Large', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 12),
            Text('Label Medium', style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(height: 12),
            Text('Label Small', style: Theme.of(context).textTheme.labelSmall),
          ],
        ),
      ),
    );
  }

  Widget _buildRichTextExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'نص متعدد الأنماط:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            RichText(
              text: const TextSpan(
                style: TextStyle(fontSize: 18, color: Colors.black),
                children: [
                  TextSpan(text: 'هذا '),
                  TextSpan(
                    text: 'نص ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  TextSpan(
                    text: 'متعدد ',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.red,
                    ),
                  ),
                  TextSpan(
                    text: 'الأنماط ',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.green,
                    ),
                  ),
                  TextSpan(
                    text: 'والألوان!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.purple,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 16, color: Colors.black87),
                children: [
                  const TextSpan(text: 'يمكنك أيضاً إضافة '),
                  WidgetSpan(
                    child: Icon(Icons.emoji_emotions, size: 24, color: Colors.orange),
                  ),
                  const TextSpan(text: ' أيقونات '),
                  WidgetSpan(
                    child: Icon(Icons.star, size: 24, color: Colors.yellow),
                  ),
                  const TextSpan(text: ' داخل النص!'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectableTextExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'نص قابل للتحديد والنسخ:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            SelectableText(
              'هذا نص قابل للتحديد. جرب النقر عليه والتحديد بالماوس أو باللمس. يمكنك نسخه أيضاً!',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            SelectableText.rich(
              TextSpan(
                style: TextStyle(fontSize: 16),
                children: [
                  TextSpan(text: 'يمكن أيضاً استخدام '),
                  TextSpan(
                    text: 'SelectableText.rich ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  TextSpan(text: 'مع أنماط متعددة!'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoogleFontsExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Google Fonts:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              'Cairo Font - خط Cairo',
              style: GoogleFonts.cairo(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              'Roboto Font',
              style: GoogleFonts.roboto(fontSize: 20),
            ),
            const SizedBox(height: 12),
            Text(
              'Lato Font',
              style: GoogleFonts.lato(fontSize: 20, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 12),
            Text(
              'Montserrat Font',
              style: GoogleFonts.montserrat(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Playfair Display',
              style: GoogleFonts.playfairDisplay(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
