import 'package:flutter/material.dart';
import 'screens/31_http_api/http_api_home.dart';
import 'screens/32_local_database/local_database_home.dart';
import 'screens/33_firebase/firebase_home.dart';
import 'screens/34_files_media/files_media_home.dart';
import 'screens/35_maps_location/maps_location_home.dart';
import 'screens/36_notifications/notifications_home.dart';
import 'screens/37_internationalization/i18n_home.dart';
import 'screens/38_security/security_home.dart';
import 'screens/39_testing/testing_home.dart';
import 'screens/40_deployment/deployment_home.dart';

void main() {
  runApp(const Level4AdvancedTopicsApp());
}

class Level4AdvancedTopicsApp extends StatelessWidget {
  const Level4AdvancedTopicsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Level 4: Advanced Topics',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Level 4: Advanced Topics'),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildHeader(
            context,
            '🚀 المستوى الرابع: المواضيع المتقدمة',
            '10 مشاريع عملية شاملة تغطي المفاهيم المتقدمة في Flutter',
          ),
          const SizedBox(height: 24),
          _buildSection(
            context,
            '🌐 البيانات والشبكات',
            Colors.blue,
            [
              _ProjectCard(
                number: '31',
                title: 'HTTP & API',
                description: 'استخدام REST APIs، JSON Parsing، dio package',
                icon: Icons.cloud,
                color: Colors.blue,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const HttpApiHome(),
                  ),
                ),
              ),
              _ProjectCard(
                number: '32',
                title: 'Local Database',
                description: 'SQLite، Hive، SharedPreferences، CRUD',
                icon: Icons.storage,
                color: Colors.teal,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LocalDatabaseHome(),
                  ),
                ),
              ),
              _ProjectCard(
                number: '33',
                title: 'Firebase',
                description: 'Auth، Firestore، Storage، Push Notifications',
                icon: Icons.whatshot,
                color: Colors.orange,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const FirebaseHome(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            context,
            '📸 الوسائط والخدمات',
            Colors.purple,
            [
              _ProjectCard(
                number: '34',
                title: 'Files & Media',
                description: 'Camera، Image Picker، File Management',
                icon: Icons.camera_alt,
                color: Colors.purple,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const FilesMediaHome(),
                  ),
                ),
              ),
              _ProjectCard(
                number: '35',
                title: 'Maps & Location',
                description: 'Google Maps، Geolocator، Geocoding',
                icon: Icons.map,
                color: Colors.green,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const MapsLocationHome(),
                  ),
                ),
              ),
              _ProjectCard(
                number: '36',
                title: 'Notifications',
                description: 'Local & Push Notifications، Scheduling',
                icon: Icons.notifications,
                color: Colors.red,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const NotificationsHome(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            context,
            '🔐 الأمان والنشر',
            Colors.indigo,
            [
              _ProjectCard(
                number: '37',
                title: 'Internationalization',
                description: 'Multi-language، RTL، Translations',
                icon: Icons.language,
                color: Colors.indigo,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const I18nHome(),
                  ),
                ),
              ),
              _ProjectCard(
                number: '38',
                title: 'Security',
                description: 'Encryption، Biometric، Secure Storage',
                icon: Icons.security,
                color: Colors.deepOrange,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SecurityHome(),
                  ),
                ),
              ),
              _ProjectCard(
                number: '39',
                title: 'Testing',
                description: 'Unit، Widget، Integration Tests، TDD',
                icon: Icons.bug_report,
                color: Colors.pink,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const TestingHome(),
                  ),
                ),
              ),
              _ProjectCard(
                number: '40',
                title: 'Deployment',
                description: 'App Store، Play Store، CI/CD',
                icon: Icons.publish,
                color: Colors.cyan,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const DeploymentHome(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildFooter(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String title, String subtitle) {
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
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

  Widget _buildSection(
    BuildContext context,
    String title,
    Color color,
    List<Widget> children,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12, right: 8),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
              ),
            ],
          ),
        ),
        ...children,
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Icon(Icons.emoji_events, size: 48, color: Colors.amber),
            const SizedBox(height: 12),
            Text(
              'مبروك! 🎉',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'بإكمال هذا المستوى ستكون قد أتقنت المفاهيم المتقدمة في Flutter',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  final String number;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ProjectCard({
    required this.number,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            number,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            title,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
