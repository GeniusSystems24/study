# 32 - قواعد البيانات المحلية - SQLite و Hive

## 📋 المحتويات

- [المقدمة](#المقدمة)
- [SQLite مع sqflite](#sqlite-مع-sqflite)
- [Hive - NoSQL](#hive---nosql)
- [SharedPreferences](#sharedpreferences)
- [المقارنة والاختيار](#المقارنة-والاختيار)

---

## 🎯 المقدمة

تخزين البيانات محلياً ضروري للتطبيقات التي تعمل Offline أو تحتاج cache.

**الخيارات المتاحة:**

- **SQLite (sqflite)**: قاعدة بيانات علائقية
- **Hive**: قاعدة بيانات NoSQL سريعة
- **SharedPreferences**: للبيانات البسيطة (key-value)

---

## 🗄️ SQLite مع sqflite

### التثبيت

```yaml
dependencies:
  sqflite: ^2.3.0
  path: ^1.8.3
```

---

### إنشاء Database Helper

```dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('notes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const integerType = 'INTEGER NOT NULL';

    await db.execute('''
      CREATE TABLE notes (
        id $idType,
        title $textType,
        content $textType,
        createdAt $textType
      )
    ''');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
```

---

### CRUD Operations

```dart
// models/note.dart
class Note {
  final int? id;
  final String title;
  final String content;
  final DateTime createdAt;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}

// في DatabaseHelper
class DatabaseHelper {
  // ... الكود السابق

  // CREATE
  Future<Note> createNote(Note note) async {
    final db = await instance.database;
    final id = await db.insert('notes', note.toMap());
    return note.copyWith(id: id);
  }

  // READ all
  Future<List<Note>> getAllNotes() async {
    final db = await instance.database;
    final result = await db.query('notes', orderBy: 'createdAt DESC');
    return result.map((map) => Note.fromMap(map)).toList();
  }

  // READ single
  Future<Note?> getNote(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Note.fromMap(maps.first);
    }
    return null;
  }

  // UPDATE
  Future<int> updateNote(Note note) async {
    final db = await instance.database;
    return db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  // DELETE
  Future<int> deleteNote(int id) async {
    final db = await instance.database;
    return db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // SEARCH
  Future<List<Note>> searchNotes(String query) async {
    final db = await instance.database;
    final result = await db.query(
      'notes',
      where: 'title LIKE ? OR content LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
    );
    return result.map((map) => Note.fromMap(map)).toList();
  }
}
```

---

### تطبيق ملاحظات كامل

```dart
import 'package:flutter/material.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final DatabaseHelper db = DatabaseHelper.instance;
  List<Note> notes = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    setState(() => isLoading = true);
    notes = await db.getAllNotes();
    setState(() => isLoading = false);
  }

  Future<void> _addNote() async {
    final titleController = TextEditingController();
    final contentController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ملاحظة جديدة'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'العنوان'),
            ),
            TextField(
              controller: contentController,
              decoration: const InputDecoration(labelText: 'المحتوى'),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (titleController.text.isNotEmpty) {
                await db.createNote(
                  Note(
                    title: titleController.text,
                    content: contentController.text,
                    createdAt: DateTime.now(),
                  ),
                );
                if (mounted) {
                  Navigator.pop(context);
                  _loadNotes();
                }
              }
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteNote(int id) async {
    await db.deleteNote(id);
    _loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ملاحظاتي')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : notes.isEmpty
              ? const Center(child: Text('لا توجد ملاحظات'))
              : ListView.builder(
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    final note = notes[index];
                    return Card(
                      margin: const EdgeInsets.all(8),
                      child: ListTile(
                        title: Text(
                          note.title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(note.content),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteNote(note.id!),
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNote,
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

---

## 📦 Hive - NoSQL

### التثبيت

```yaml
dependencies:
  hive: ^2.2.3
  hive_flutter: ^1.1.0

dev_dependencies:
  hive_generator: ^2.0.1
  build_runner: ^2.4.6
```

---

### التهيئة والنموذج

```dart
// main.dart
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  await Hive.openBox<Task>('tasks');
  runApp(const MyApp());
}

// models/task.dart
import 'package:hive/hive.dart';

part 'task.g.dart'; // سيتم توليده

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String description;

  @HiveField(2)
  bool isCompleted;

  @HiveField(3)
  DateTime createdAt;

  Task({
    required this.title,
    required this.description,
    this.isCompleted = false,
    required this.createdAt,
  });
}
```

توليد الكود:

```bash
flutter packages pub run build_runner build
```

---

### CRUD مع Hive

```dart
class HiveService {
  static const String boxName = 'tasks';

  // CREATE
  Future<void> addTask(Task task) async {
    final box = Hive.box<Task>(boxName);
    await box.add(task);
  }

  // READ all
  List<Task> getAllTasks() {
    final box = Hive.box<Task>(boxName);
    return box.values.toList();
  }

  // READ single
  Task? getTask(int index) {
    final box = Hive.box<Task>(boxName);
    return box.getAt(index);
  }

  // UPDATE
  Future<void> updateTask(int index, Task task) async {
    final box = Hive.box<Task>(boxName);
    await box.putAt(index, task);
  }

  // DELETE
  Future<void> deleteTask(int index) async {
    final box = Hive.box<Task>(boxName);
    await box.deleteAt(index);
  }

  // DELETE all
  Future<void> deleteAllTasks() async {
    final box = Hive.box<Task>(boxName);
    await box.clear();
  }
}
```

---

### تطبيق مهام مع Hive

```dart
class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final HiveService service = HiveService();

  void _addTask() async {
    final titleController = TextEditingController();
    final descController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('مهمة جديدة'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'العنوان'),
            ),
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: 'الوصف'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (titleController.text.isNotEmpty) {
                await service.addTask(
                  Task(
                    title: titleController.text,
                    description: descController.text,
                    createdAt: DateTime.now(),
                  ),
                );
                if (mounted) {
                  Navigator.pop(context);
                  setState(() {});
                }
              }
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('قائمة المهام')),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Task>('tasks').listenable(),
        builder: (context, Box<Task> box, _) {
          if (box.isEmpty) {
            return const Center(child: Text('لا توجد مهام'));
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final task = box.getAt(index)!;
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text(
                    task.title,
                    style: TextStyle(
                      decoration: task.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  subtitle: Text(task.description),
                  leading: Checkbox(
                    value: task.isCompleted,
                    onChanged: (value) async {
                      task.isCompleted = value!;
                      await task.save();
                    },
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await service.deleteTask(index);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

---

## 💾 SharedPreferences

### التثبيت والاستخدام

```yaml
dependencies:
  shared_preferences: ^2.2.2
```

```dart
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String keyTheme = 'theme_mode';
  static const String keyLanguage = 'language';
  static const String keyUsername = 'username';

  // Save
  Future<void> saveTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyTheme, isDark);
  }

  // Read
  Future<bool> getTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyTheme) ?? false;
  }

  // Save String
  Future<void> saveUsername(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyUsername, username);
  }

  // Read String
  Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyUsername);
  }

  // Save List
  Future<void> saveRecentSearches(List<String> searches) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('recent_searches', searches);
  }

  // Read List
  Future<List<String>> getRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('recent_searches') ?? [];
  }

  // Delete
  Future<void> deleteKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  // Clear all
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
```

---

## ⚖️ المقارنة والاختيار

| الميزة | SQLite | Hive | SharedPreferences |
|--------|--------|------|-------------------|
| **النوع** | علائقية (SQL) | NoSQL | Key-Value |
| **الأداء** | جيد | ممتاز | ممتاز للبيانات البسيطة |
| **حجم البيانات** | كبير | متوسط-كبير | صغير |
| **العلاقات** | ✅ | ❌ | ❌ |
| **سهولة الاستخدام** | متوسط | سهل | سهل جداً |
| **Type Safety** | ❌ | ✅ | ❌ |
| **استعلامات معقدة** | ✅ | محدود | ❌ |

---

### متى تستخدم كل واحدة؟

**SQLite:**

- ✅ بيانات علائقية معقدة
- ✅ استعلامات متقدمة (JOIN, GROUP BY)
- ✅ تطبيقات كبيرة
- مثال: نظام إدارة مخزون

**Hive:**

- ✅ بيانات بسيطة-متوسطة
- ✅ أداء عالٍ مطلوب
- ✅ Type safety
- مثال: تطبيق ملاحظات، قائمة مهام

**SharedPreferences:**

- ✅ إعدادات التطبيق
- ✅ بيانات بسيطة جداً
- ✅ Theme, Language
- مثال: تفضيلات المستخدم

---

## 📚 المراجع والمصادر

1. **SQLite**
   - [sqflite](https://pub.dev/packages/sqflite)
   - [path](https://pub.dev/packages/path)

2. **Hive**
   - [hive](https://pub.dev/packages/hive)
   - [hive_flutter](https://pub.dev/packages/hive_flutter)
   - [Hive Documentation](https://docs.hivedb.dev/)

3. **SharedPreferences**
   - [shared_preferences](https://pub.dev/packages/shared_preferences)

---

## 💡 نصائح

- ✅ استخدم Singleton pattern للـ Database Helper
- ✅ أغلق Database عند الانتهاء
- ✅ استخدم Transactions للعمليات المتعددة
- ✅ عالج الأخطاء بشكل صحيح
- ✅ Hive أسرع من SQLite للبيانات البسيطة
- ✅ لا تخزن بيانات حساسة في SharedPreferences بدون تشفير

---

[⬅️ السابق: HTTP و API](31_http_api.md)
[🏠 العودة للفهرس](../README.md)
[التالي: Firebase ➡️](33_firebase.md)
