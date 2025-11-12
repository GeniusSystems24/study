import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LocalDatabaseHome extends StatelessWidget {
  const LocalDatabaseHome({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 7,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Local Database'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'المقدمة'),
              Tab(text: 'SharedPreferences'),
              Tab(text: 'SQLite'),
              Tab(text: 'Hive'),
              Tab(text: 'CRUD Operations'),
              Tab(text: 'Migration'),
              Tab(text: 'Best Practices'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            IntroductionTab(),
            SharedPreferencesTab(),
            SQLiteTab(),
            HiveTab(),
            CrudOperationsTab(),
            MigrationTab(),
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
          '💾 Local Database',
          'تخزين البيانات محلياً على جهاز المستخدم',
        ),
        const SizedBox(height: 16),
        _buildContentCard(
          context,
          'لماذا نحتاج التخزين المحلي؟',
          '''
• العمل بدون إنترنت (Offline Mode)
• تحسين الأداء (Caching)
• حفظ إعدادات المستخدم
• تخزين البيانات الحساسة
• تقليل استهلاك البيانات
''',
        ),
        _buildContentCard(
          context,
          'خيارات التخزين المحلي',
          '''
1. SharedPreferences
   • بسيط وسريع
   • key-value pairs
   • للبيانات الصغيرة (إعدادات، preferences)

2. SQLite
   • قاعدة بيانات علائقية
   • SQL queries
   • للبيانات المعقدة والكبيرة

3. Hive
   • NoSQL database
   • سريع جداً
   • سهل الاستخدام
   • يدعم الـ encryption
''',
        ),
        _buildContentCard(
          context,
          'المقارنة',
          '''
┌─────────────────┬──────────┬─────────┬────────┐
│                 │ SharedPr │ SQLite  │ Hive   │
├─────────────────┼──────────┼─────────┼────────┤
│ السرعة          │ ⭐⭐⭐    │ ⭐⭐     │ ⭐⭐⭐⭐  │
│ سهولة الاستخدام │ ⭐⭐⭐⭐   │ ⭐⭐     │ ⭐⭐⭐   │
│ حجم البيانات    │ صغير     │ كبير    │ متوسط  │
│ الاستعلامات     │ لا       │ نعم     │ محدودة │
│ العلاقات        │ لا       │ نعم     │ لا     │
└─────────────────┴──────────┴─────────┴────────┘
''',
        ),
        _buildCodeCard(
          context,
          'Installation',
          '''
# في pubspec.yaml
dependencies:
  shared_preferences: ^2.2.2
  sqflite: ^2.3.0
  path: ^1.8.3
  hive: ^2.2.3
  hive_flutter: ^1.1.0

# ثم:
flutter pub get
''',
        ),
      ],
    );
  }
}

// ==================== Tab 2: SharedPreferences ====================
class SharedPreferencesTab extends StatefulWidget {
  const SharedPreferencesTab({super.key});

  @override
  State<SharedPreferencesTab> createState() => _SharedPreferencesTabState();
}

class _SharedPreferencesTabState extends State<SharedPreferencesTab> {
  final _keyController = TextEditingController();
  final _valueController = TextEditingController();
  String _savedValue = '';
  bool _isDarkMode = false;
  double _fontSize = 16.0;
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('darkMode') ?? false;
      _fontSize = prefs.getDouble('fontSize') ?? 16.0;
      _counter = prefs.getInt('counter') ?? 0;
    });
  }

  Future<void> _saveString() async {
    if (_keyController.text.isEmpty) return;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyController.text, _valueController.text);
    
    if (mounted) {
      ScaffoldMessenger.of(this.context).showSnackBar(
        const SnackBar(content: Text('تم الحفظ بنجاح')),
      );
    }
  }

  Future<void> _loadString() async {
    if (_keyController.text.isEmpty) return;
    
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedValue = prefs.getString(_keyController.text) ?? 'لا يوجد';
    });
  }

  Future<void> _toggleDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', value);
    setState(() {
      _isDarkMode = value;
    });
  }

  Future<void> _saveFontSize(double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('fontSize', value);
    setState(() {
      _fontSize = value;
    });
  }

  Future<void> _incrementCounter() async {
    final prefs = await SharedPreferences.getInstance();
    final newCounter = _counter + 1;
    await prefs.setInt('counter', newCounter);
    setState(() {
      _counter = newCounter;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildCodeCard(
          context,
          'Basic Usage',
          '''
import 'package:shared_preferences/shared_preferences.dart';

// حفظ البيانات
Future<void> saveData() async {
  final prefs = await SharedPreferences.getInstance();
  
  await prefs.setString('username', 'Ahmed');
  await prefs.setInt('age', 25);
  await prefs.setBool('isLoggedIn', true);
  await prefs.setDouble('rating', 4.5);
  await prefs.setStringList('tags', ['flutter', 'dart']);
}

// قراءة البيانات
Future<void> loadData() async {
  final prefs = await SharedPreferences.getInstance();
  
  String? username = prefs.getString('username');
  int? age = prefs.getInt('age');
  bool? isLoggedIn = prefs.getBool('isLoggedIn');
  double? rating = prefs.getDouble('rating');
  List<String>? tags = prefs.getStringList('tags');
}

// حذف البيانات
Future<void> deleteData() async {
  final prefs = await SharedPreferences.getInstance();
  
  await prefs.remove('username');  // حذف مفتاح محدد
  await prefs.clear();             // حذف كل البيانات
}
''',
        ),
        const SizedBox(height: 16),
        const Text(
          'تجربة عملية - حفظ وقراءة النصوص',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _keyController,
          decoration: const InputDecoration(
            labelText: 'Key',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _valueController,
          decoration: const InputDecoration(
            labelText: 'Value',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _saveString,
                icon: const Icon(Icons.save),
                label: const Text('حفظ'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _loadString,
                icon: const Icon(Icons.upload),
                label: const Text('قراءة'),
              ),
            ),
          ],
        ),
        if (_savedValue.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text('القيمة المحفوظة: $_savedValue'),
              ),
            ),
          ),
        const SizedBox(height: 24),
        const Text(
          'تجربة عملية - الإعدادات',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Card(
          child: Column(
            children: [
              SwitchListTile(
                title: const Text('Dark Mode'),
                subtitle: Text(_isDarkMode ? 'مفعّل' : 'معطّل'),
                value: _isDarkMode,
                onChanged: _toggleDarkMode,
              ),
              const Divider(),
              ListTile(
                title: const Text('حجم الخط'),
                subtitle: Slider(
                  value: _fontSize,
                  min: 12,
                  max: 24,
                  divisions: 12,
                  label: _fontSize.round().toString(),
                  onChanged: _saveFontSize,
                ),
              ),
              const Divider(),
              ListTile(
                title: const Text('العداد'),
                subtitle: Text('العدد: $_counter'),
                trailing: ElevatedButton(
                  onPressed: _incrementCounter,
                  child: const Text('+1'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _keyController.dispose();
    _valueController.dispose();
    super.dispose();
  }
}

// ==================== Tab 3: SQLite ====================
class SQLiteTab extends StatefulWidget {
  const SQLiteTab({super.key});

  @override
  State<SQLiteTab> createState() => _SQLiteTabState();
}

class _SQLiteTabState extends State<SQLiteTab> {
  Database? _database;
  List<Map<String, dynamic>> _users = [];
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'users.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            email TEXT NOT NULL,
            created_at TEXT NOT NULL
          )
        ''');
      },
    );
    
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    if (_database == null) return;
    
    final users = await _database!.query('users', orderBy: 'id DESC');
    setState(() {
      _users = users;
    });
  }

  Future<void> _addUser() async {
    if (_database == null || _nameController.text.isEmpty) return;

    await _database!.insert('users', {
      'name': _nameController.text,
      'email': _emailController.text,
      'created_at': DateTime.now().toIso8601String(),
    });

    _nameController.clear();
    _emailController.clear();
    _loadUsers();
    
    if (mounted) {
      ScaffoldMessenger.of(this.context).showSnackBar(
        const SnackBar(content: Text('تمت الإضافة بنجاح')),
      );
    }
  }

  Future<void> _deleteUser(int id) async {
    if (_database == null) return;

    await _database!.delete('users', where: 'id = ?', whereArgs: [id]);
    _loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildCodeCard(
                context,
                'Database Setup',
                '''
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;
  
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }
  
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app_database.db');
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }
  
  Future<void> _onCreate(Database db, int version) async {
    await db.execute(\'\'\'
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL,
        age INTEGER,
        created_at TEXT NOT NULL
      )
    \'\'\');
  }
}
''',
              ),
              _buildCodeCard(
                context,
                'CRUD Operations',
                '''
// Create - إضافة
Future<int> insertUser(Map<String, dynamic> user) async {
  final db = await database;
  return await db.insert('users', user);
}

// Read - قراءة
Future<List<Map<String, dynamic>>> getUsers() async {
  final db = await database;
  return await db.query('users');
}

Future<Map<String, dynamic>?> getUser(int id) async {
  final db = await database;
  final results = await db.query(
    'users',
    where: 'id = ?',
    whereArgs: [id],
  );
  return results.isNotEmpty ? results.first : null;
}

// Update - تحديث
Future<int> updateUser(Map<String, dynamic> user) async {
  final db = await database;
  return await db.update(
    'users',
    user,
    where: 'id = ?',
    whereArgs: [user['id']],
  );
}

// Delete - حذف
Future<int> deleteUser(int id) async {
  final db = await database;
  return await db.delete(
    'users',
    where: 'id = ?',
    whereArgs: [id],
  );
}
''',
              ),
              const SizedBox(height: 16),
              const Text(
                'تجربة عملية - إدارة المستخدمين',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'الاسم',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'البريد الإلكتروني',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: _addUser,
                icon: const Icon(Icons.add),
                label: const Text('إضافة مستخدم'),
              ),
            ],
          ),
        ),
        Container(
          height: 250,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'المستخدمون المحفوظون (${_users.length})',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: _users.isEmpty
                    ? const Center(child: Text('لا يوجد مستخدمون'))
                    : ListView.builder(
                        itemCount: _users.length,
                        itemBuilder: (context, index) {
                          final user = _users[index];
                          return Card(
                            child: ListTile(
                              leading: CircleAvatar(
                                child: Text('${user['id']}'),
                              ),
                              title: Text(user['name']),
                              subtitle: Text(user['email']),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteUser(user['id']),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _database?.close();
    super.dispose();
  }
}

// ==================== Tab 4: Hive ====================
class HiveTab extends StatefulWidget {
  const HiveTab({super.key});

  @override
  State<HiveTab> createState() => _HiveTabState();
}

class _HiveTabState extends State<HiveTab> {
  Box? _box;
  final _keyController = TextEditingController();
  final _valueController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initHive();
  }

  Future<void> _initHive() async {
    await Hive.initFlutter();
    _box = await Hive.openBox('myBox');
    setState(() {});
  }

  Future<void> _saveData() async {
    if (_box == null || _keyController.text.isEmpty) return;
    
    await _box!.put(_keyController.text, _valueController.text);
    
    if (mounted) {
      ScaffoldMessenger.of(this.context).showSnackBar(
        const SnackBar(content: Text('تم الحفظ في Hive')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildInfoCard(
          context,
          '🚀 Hive',
          'قاعدة بيانات NoSQL سريعة وخفيفة',
        ),
        const SizedBox(height: 16),
        _buildCodeCard(
          context,
          'Setup',
          '''
import 'package:hive_flutter/hive_flutter.dart';

// في main()
void main() async {
  await Hive.initFlutter();
  await Hive.openBox('settingsBox');
  runApp(MyApp());
}
''',
        ),
        _buildCodeCard(
          context,
          'Basic Operations',
          '''
// فتح Box
final box = await Hive.openBox('myBox');

// حفظ البيانات
await box.put('name', 'Ahmed');
await box.put('age', 25);
await box.put('user', {'id': 1, 'name': 'Ahmed'});

// قراءة البيانات
String? name = box.get('name');
int? age = box.get('age');
Map? user = box.get('user');

// حذف البيانات
await box.delete('name');
await box.clear();  // حذف كل البيانات

// إغلاق Box
await box.close();
''',
        ),
        _buildCodeCard(
          context,
          'Type Adapter - Custom Objects',
          '''
import 'package:hive/hive.dart';

part 'person.g.dart';

@HiveType(typeId: 0)
class Person extends HiveObject {
  @HiveField(0)
  String name;
  
  @HiveField(1)
  int age;
  
  @HiveField(2)
  String email;
  
  Person({
    required this.name,
    required this.age,
    required this.email,
  });
}

// التسجيل
Hive.registerAdapter(PersonAdapter());

// الاستخدام
final box = await Hive.openBox<Person>('persons');
await box.add(Person(name: 'Ahmed', age: 25, email: 'ahmed@example.com'));
''',
        ),
        const SizedBox(height: 16),
        const Text(
          'تجربة عملية',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _keyController,
          decoration: const InputDecoration(
            labelText: 'Key',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _valueController,
          decoration: const InputDecoration(
            labelText: 'Value',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: _saveData,
          icon: const Icon(Icons.save),
          label: const Text('حفظ في Hive'),
        ),
        const SizedBox(height: 16),
        if (_box != null)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'البيانات المحفوظة:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ..._box!.keys.map((key) {
                    return ListTile(
                      dense: true,
                      title: Text('$key'),
                      subtitle: Text('${_box!.get(key)}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, size: 20),
                        onPressed: () {
                          _box!.delete(key);
                          setState(() {});
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _keyController.dispose();
    _valueController.dispose();
    super.dispose();
  }
}

// ==================== Tab 5: CRUD Operations ====================
class CrudOperationsTab extends StatelessWidget {
  const CrudOperationsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildInfoCard(
          context,
          '🔄 CRUD Operations',
          'Create, Read, Update, Delete',
        ),
        const SizedBox(height: 16),
        _buildCodeCard(
          context,
          'Model Class',
          '''
class Task {
  final int? id;
  final String title;
  final String description;
  final bool isCompleted;
  final DateTime createdAt;
  
  Task({
    this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted ? 1 : 0,
      'createdAt': createdAt.toIso8601String(),
    };
  }
  
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      isCompleted: map['isCompleted'] == 1,
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
''',
        ),
        _buildCodeCard(
          context,
          'Database Helper',
          '''
class TaskDatabase {
  static Database? _database;
  
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }
  
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'tasks.db');
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(\'\'\'
          CREATE TABLE tasks(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            description TEXT,
            isCompleted INTEGER NOT NULL,
            createdAt TEXT NOT NULL
          )
        \'\'\');
      },
    );
  }
  
  // CREATE
  Future<int> createTask(Task task) async {
    final db = await database;
    return await db.insert('tasks', task.toMap());
  }
  
  // READ
  Future<List<Task>> getTasks() async {
    final db = await database;
    final maps = await db.query('tasks', orderBy: 'createdAt DESC');
    return maps.map((map) => Task.fromMap(map)).toList();
  }
  
  Future<Task?> getTask(int id) async {
    final db = await database;
    final maps = await db.query(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
    return maps.isNotEmpty ? Task.fromMap(maps.first) : null;
  }
  
  // UPDATE
  Future<int> updateTask(Task task) async {
    final db = await database;
    return await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }
  
  // DELETE
  Future<int> deleteTask(int id) async {
    final db = await database;
    return await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  
  // Search
  Future<List<Task>> searchTasks(String query) async {
    final db = await database;
    final maps = await db.query(
      'tasks',
      where: 'title LIKE ? OR description LIKE ?',
      whereArgs: ['%\$query%', '%\$query%'],
    );
    return maps.map((map) => Task.fromMap(map)).toList();
  }
}
''',
        ),
        _buildContentCard(
          context,
          'Best Practices for CRUD',
          '''
✅ استخدم Transactions للعمليات المتعددة
✅ أضف Indexes للحقول المستخدمة في البحث
✅ استخدم Batch operations للإدخال المتعدد
✅ تعامل مع الأخطاء بشكل صحيح
✅ أغلق الـ database عند عدم الحاجة
✅ استخدم Stream للتحديثات التلقائية
''',
        ),
      ],
    );
  }
}

// ==================== Tab 6: Migration ====================
class MigrationTab extends StatelessWidget {
  const MigrationTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildInfoCard(
          context,
          '🔄 Database Migration',
          'تحديث هيكل قاعدة البيانات',
        ),
        const SizedBox(height: 16),
        _buildCodeCard(
          context,
          'Version Migration',
          '''
Future<Database> _initDatabase() async {
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, 'app.db');
  
  return await openDatabase(
    path,
    version: 3,  // النسخة الجديدة
    onCreate: _onCreate,
    onUpgrade: _onUpgrade,
  );
}

Future<void> _onCreate(Database db, int version) async {
  // إنشاء الجداول للنسخة الأولى
  await db.execute(\'\'\'
    CREATE TABLE users(
      id INTEGER PRIMARY KEY,
      name TEXT,
      email TEXT
    )
  \'\'\');
}

Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
  // الترقية من v1 إلى v2
  if (oldVersion < 2) {
    await db.execute('ALTER TABLE users ADD COLUMN age INTEGER');
  }
  
  // الترقية من v2 إلى v3
  if (oldVersion < 3) {
    await db.execute('ALTER TABLE users ADD COLUMN phone TEXT');
    
    // إنشاء جدول جديد
    await db.execute(\'\'\'
      CREATE TABLE settings(
        key TEXT PRIMARY KEY,
        value TEXT
      )
    \'\'\');
  }
}
''',
        ),
        _buildCodeCard(
          context,
          'Complex Migration',
          '''
Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
  // إضافة عمود جديد
  if (oldVersion < 2) {
    await db.execute('ALTER TABLE users ADD COLUMN created_at TEXT');
    
    // تحديث البيانات الموجودة
    await db.execute("""
      UPDATE users 
      SET created_at = '${DateTime.now().toIso8601String()}' 
      WHERE created_at IS NULL
    """);
  }
  
  // إعادة هيكلة جدول
  if (oldVersion < 3) {
    // إنشاء جدول مؤقت
    await db.execute(\'\'\'
      CREATE TABLE users_new(
        id INTEGER PRIMARY KEY,
        full_name TEXT NOT NULL,
        email TEXT UNIQUE,
        created_at TEXT
      )
    \'\'\');
    
    // نسخ البيانات
    await db.execute(\'\'\'
      INSERT INTO users_new (id, full_name, email, created_at)
      SELECT id, name, email, created_at FROM users
    \'\'\');
    
    // حذف الجدول القديم
    await db.execute('DROP TABLE users');
    
    // إعادة تسمية الجدول الجديد
    await db.execute('ALTER TABLE users_new RENAME TO users');
  }
}
''',
        ),
        _buildContentCard(
          context,
          'Migration Best Practices',
          '''
1. دائماً احتفظ بنسخة احتياطية قبل الترقية
2. اختبر الـ migrations على أجهزة مختلفة
3. استخدم Transactions للحفاظ على سلامة البيانات
4. تعامل مع جميع الإصدارات السابقة
5. أضف validations للبيانات المنقولة
6. وثق كل migration بوضوح
''',
        ),
        _buildCodeCard(
          context,
          'Backup & Restore',
          '''
// إنشاء نسخة احتياطية
Future<void> backupDatabase() async {
  final dbPath = await getDatabasesPath();
  final dbFile = File(join(dbPath, 'app.db'));
  final backupFile = File(join(dbPath, 'app_backup_\${DateTime.now().millisecondsSinceEpoch}.db'));
  
  await dbFile.copy(backupFile.path);
}

// استعادة من نسخة احتياطية
Future<void> restoreDatabase(String backupPath) async {
  final dbPath = await getDatabasesPath();
  final dbFile = File(join(dbPath, 'app.db'));
  final backupFile = File(backupPath);
  
  if (await backupFile.exists()) {
    await backupFile.copy(dbFile.path);
  }
}
''',
        ),
      ],
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
          '✨ Best Practices',
          'أفضل الممارسات في التخزين المحلي',
        ),
        const SizedBox(height: 16),
        _buildContentCard(
          context,
          'متى تستخدم كل نوع؟',
          '''
SharedPreferences:
• إعدادات التطبيق
• تفضيلات المستخدم
• بيانات بسيطة (key-value)
• حجم صغير (<1MB)

SQLite:
• بيانات معقدة ومترابطة
• استعلامات SQL متقدمة
• علاقات بين الجداول
• حجم كبير (>10MB)

Hive:
• بيانات متوسطة الحجم
• سرعة القراءة/الكتابة مهمة
• لا تحتاج علاقات معقدة
• تحتاج encryption
''',
        ),
        _buildCodeCard(
          context,
          'Singleton Pattern',
          '''
class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;
  
  factory DatabaseService() => _instance;
  
  DatabaseService._internal();
  
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }
  
  Future<Database> _initDatabase() async {
    // Database initialization
  }
}

// الاستخدام
final db = await DatabaseService().database;
''',
        ),
        _buildCodeCard(
          context,
          'Error Handling',
          '''
Future<List<Task>> getTasks() async {
  try {
    final db = await database;
    final maps = await db.query('tasks');
    return maps.map((map) => Task.fromMap(map)).toList();
  } on DatabaseException catch (e) {
    print('Database error: \$e');
    return [];
  } catch (e) {
    print('Unexpected error: \$e');
    return [];
  }
}
''',
        ),
        _buildCodeCard(
          context,
          'Using Streams for Real-time Updates',
          '''
class TaskDatabase {
  final _taskController = StreamController<List<Task>>.broadcast();
  
  Stream<List<Task>> get tasksStream => _taskController.stream;
  
  Future<void> addTask(Task task) async {
    final db = await database;
    await db.insert('tasks', task.toMap());
    _updateStream();
  }
  
  Future<void> _updateStream() async {
    final tasks = await getTasks();
    _taskController.add(tasks);
  }
  
  void dispose() {
    _taskController.close();
  }
}

// في Widget
StreamBuilder<List<Task>>(
  stream: taskDatabase.tasksStream,
  builder: (context, snapshot) {
    if (!snapshot.hasData) {
      return CircularProgressIndicator();
    }
    return ListView.builder(
      itemCount: snapshot.data!.length,
      itemBuilder: (context, index) {
        return TaskTile(task: snapshot.data![index]);
      },
    );
  },
)
''',
        ),
        _buildContentCard(
          context,
          'Performance Tips',
          '''
✅ استخدم Batch operations للإدخال المتعدد
✅ أضف Indexes للحقول المستخدمة كثيراً
✅ استخدم Transactions للعمليات المتعددة
✅ تجنب القراءة/الكتابة في Main Thread
✅ استخدم Lazy Loading للقوائم الطويلة
✅ نظف البيانات القديمة بشكل دوري
''',
        ),
        _buildContentCard(
          context,
          'Security Tips',
          '''
🔒 لا تخزن كلمات المرور مباشرة
🔒 استخدم flutter_secure_storage للبيانات الحساسة
🔒 استخدم Hive مع encryption للبيانات المهمة
🔒 تجنب تخزين API keys في SharedPreferences
🔒 استخدم SQLCipher لتشفير SQLite
''',
        ),
        _buildCodeCard(
          context,
          'Testing Database',
          '''
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  
  group('Database Tests', () {
    late Database database;
    
    setUp(() async {
      database = await openDatabase(
        inMemoryDatabasePath,
        version: 1,
        onCreate: (db, version) {
          return db.execute(\'\'\'
            CREATE TABLE users(
              id INTEGER PRIMARY KEY,
              name TEXT
            )
          \'\'\');
        },
      );
    });
    
    tearDown(() async {
      await database.close();
    });
    
    test('Insert user', () async {
      await database.insert('users', {'name': 'Ahmed'});
      final users = await database.query('users');
      expect(users.length, 1);
      expect(users.first['name'], 'Ahmed');
    });
  });
}
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

