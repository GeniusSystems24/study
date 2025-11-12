# 31 - HTTP و API - التعامل مع الطلبات الشبكية

## 📋 المحتويات

- [المقدمة](#المقدمة)
- [تثبيت الحزم](#تثبيت-الحزم)
- [HTTP Methods](#http-methods)
- [معالجة JSON](#معالجة-json)
- [معالجة الأخطاء](#معالجة-الأخطاء)
- [أمثلة عملية](#أمثلة-عملية)

---

## 🎯 المقدمة

التعامل مع API هو جزء أساسي من أي تطبيق حديث. سنتعلم كيفية إرسال واستقبال البيانات من الخوادم.

**المفاهيم الأساسية:**

- HTTP Methods (GET, POST, PUT, DELETE)
- JSON Parsing
- Error Handling
- Authentication

---

## 📦 تثبيت الحزم

أضف في `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.1.0
```

ثم نفذ:

```bash
flutter pub get
```

---

## 🌐 HTTP Methods

### GET Request

```dart
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<User>> fetchUsers() async {
  final response = await http.get(
    Uri.parse('https://jsonplaceholder.typicode.com/users'),
  );

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    return data.map((json) => User.fromJson(json)).toList();
  } else {
    throw Exception('فشل في تحميل المستخدمين');
  }
}
```

---

### POST Request

```dart
Future<User> createUser(User user) async {
  final response = await http.post(
    Uri.parse('https://jsonplaceholder.typicode.com/users'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode(user.toJson()),
  );

  if (response.statusCode == 201) {
    return User.fromJson(json.decode(response.body));
  } else {
    throw Exception('فشل في إنشاء المستخدم');
  }
}
```

---

### PUT Request

```dart
Future<User> updateUser(String id, User user) async {
  final response = await http.put(
    Uri.parse('https://jsonplaceholder.typicode.com/users/$id'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode(user.toJson()),
  );

  if (response.statusCode == 200) {
    return User.fromJson(json.decode(response.body));
  } else {
    throw Exception('فشل في تحديث المستخدم');
  }
}
```

---

### DELETE Request

```dart
Future<void> deleteUser(String id) async {
  final response = await http.delete(
    Uri.parse('https://jsonplaceholder.typicode.com/users/$id'),
  );

  if (response.statusCode != 200) {
    throw Exception('فشل في حذف المستخدم');
  }
}
```

---

## 📄 معالجة JSON

### نموذج البيانات

```dart
class User {
  final int id;
  final String name;
  final String email;
  final String phone;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
  });

  // تحويل من JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
    );
  }

  // تحويل إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
    };
  }
}
```

---

### نموذج معقد

```dart
class Post {
  final int id;
  final int userId;
  final String title;
  final String body;
  final User? author;

  Post({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    this.author,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      userId: json['userId'],
      title: json['title'],
      body: json['body'],
      author: json['author'] != null 
          ? User.fromJson(json['author']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'body': body,
      if (author != null) 'author': author!.toJson(),
    };
  }
}
```

---

## ⚠️ معالجة الأخطاء

### Exception Classes

```dart
class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
}

class ServerException implements Exception {
  final String message;
  final int statusCode;
  ServerException(this.message, this.statusCode);
}

class TimeoutException implements Exception {
  final String message;
  TimeoutException(this.message);
}
```

---

### معالجة شاملة

```dart
Future<List<User>> fetchUsersWithErrorHandling() async {
  try {
    final response = await http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/users'))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => User.fromJson(json)).toList();
    } else if (response.statusCode == 404) {
      throw ServerException('المورد غير موجود', 404);
    } else if (response.statusCode >= 500) {
      throw ServerException('خطأ في الخادم', response.statusCode);
    } else {
      throw ServerException('خطأ غير متوقع', response.statusCode);
    }
  } on SocketException {
    throw NetworkException('لا يوجد اتصال بالإنترنت');
  } on TimeoutException {
    throw TimeoutException('انتهت مهلة الاتصال');
  } on FormatException {
    throw Exception('خطأ في تنسيق البيانات');
  } catch (e) {
    throw Exception('خطأ غير متوقع: $e');
  }
}
```

---

## 💼 أمثلة عملية

### تطبيق قائمة المستخدمين

```dart
// models/user.dart
class User {
  final int id;
  final String name;
  final String email;
  final String phone;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
    );
  }
}

// services/api_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  Future<List<User>> getUsers() async {
    final response = await http.get(Uri.parse('$baseUrl/users'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('فشل في تحميل المستخدمين');
    }
  }

  Future<User> getUserById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/users/$id'));

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('فشل في تحميل المستخدم');
    }
  }
}

// screens/users_screen.dart
import 'package:flutter/material.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final ApiService apiService = ApiService();
  late Future<List<User>> futureUsers;

  @override
  void initState() {
    super.initState();
    futureUsers = apiService.getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('قائمة المستخدمين')),
      body: FutureBuilder<List<User>>(
        future: futureUsers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('خطأ: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        futureUsers = apiService.getUsers();
                      });
                    },
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('لا توجد بيانات'));
          }

          final users = snapshot.data!;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                leading: CircleAvatar(child: Text('${user.id}')),
                title: Text(user.name),
                subtitle: Text(user.email),
                trailing: Text(user.phone),
                onTap: () {
                  // Navigate to details
                },
              );
            },
          );
        },
      ),
    );
  }
}
```

---

### تطبيق مدونة مع CRUD

```dart
// models/post.dart
class Post {
  final int? id;
  final int userId;
  final String title;
  final String body;

  Post({
    this.id,
    required this.userId,
    required this.title,
    required this.body,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      userId: json['userId'],
      title: json['title'],
      body: json['body'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'title': title,
      'body': body,
    };
  }
}

// services/post_service.dart
class PostService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  // GET all posts
  Future<List<Post>> getPosts() async {
    final response = await http.get(Uri.parse('$baseUrl/posts'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Post.fromJson(json)).toList();
    } else {
      throw Exception('فشل في تحميل المنشورات');
    }
  }

  // GET single post
  Future<Post> getPost(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/posts/$id'));

    if (response.statusCode == 200) {
      return Post.fromJson(json.decode(response.body));
    } else {
      throw Exception('فشل في تحميل المنشور');
    }
  }

  // CREATE post
  Future<Post> createPost(Post post) async {
    final response = await http.post(
      Uri.parse('$baseUrl/posts'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(post.toJson()),
    );

    if (response.statusCode == 201) {
      return Post.fromJson(json.decode(response.body));
    } else {
      throw Exception('فشل في إنشاء المنشور');
    }
  }

  // UPDATE post
  Future<Post> updatePost(int id, Post post) async {
    final response = await http.put(
      Uri.parse('$baseUrl/posts/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(post.toJson()),
    );

    if (response.statusCode == 200) {
      return Post.fromJson(json.decode(response.body));
    } else {
      throw Exception('فشل في تحديث المنشور');
    }
  }

  // DELETE post
  Future<void> deletePost(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/posts/$id'));

    if (response.statusCode != 200) {
      throw Exception('فشل في حذف المنشور');
    }
  }
}

// screens/posts_screen.dart
class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  final PostService postService = PostService();
  late Future<List<Post>> futurePosts;

  @override
  void initState() {
    super.initState();
    futurePosts = postService.getPosts();
  }

  void _createPost() async {
    final titleController = TextEditingController();
    final bodyController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('منشور جديد'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'العنوان'),
            ),
            TextField(
              controller: bodyController,
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
              try {
                await postService.createPost(
                  Post(
                    userId: 1,
                    title: titleController.text,
                    body: bodyController.text,
                  ),
                );
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تم إنشاء المنشور بنجاح')),
                  );
                  setState(() {
                    futurePosts = postService.getPosts();
                  });
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('خطأ: $e')),
                  );
                }
              }
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }

  void _deletePost(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: const Text('هل تريد حذف هذا المنشور؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('حذف'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await postService.deletePost(id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم حذف المنشور بنجاح')),
          );
          setState(() {
            futurePosts = postService.getPosts();
          });
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('خطأ: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('المنشورات')),
      body: FutureBuilder<List<Post>>(
        future: futurePosts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('خطأ: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('لا توجد منشورات'));
          }

          final posts = snapshot.data!;
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text(
                    post.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    post.body,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deletePost(post.id!),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createPost,
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

---

### Authentication مع Token

```dart
// services/auth_service.dart
class AuthService {
  static const String baseUrl = 'https://your-api.com';
  String? _token;

  String? get token => _token;

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _token = data['token'];
      return data;
    } else {
      throw Exception('فشل تسجيل الدخول');
    }
  }

  Future<List<dynamic>> getProtectedData() async {
    if (_token == null) {
      throw Exception('يجب تسجيل الدخول أولاً');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/protected/data'),
      headers: {
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 401) {
      throw Exception('انتهت صلاحية الجلسة');
    } else {
      throw Exception('فشل في تحميل البيانات');
    }
  }

  void logout() {
    _token = null;
  }
}
```

---

## 📚 المراجع والمصادر

1. **HTTP Package**
   - [http](https://pub.dev/packages/http)
   - [dio](https://pub.dev/packages/dio) (بديل متقدم)

2. **Documentation**
   - [Flutter Networking](https://flutter.dev/docs/cookbook/networking)
   - [JSON and serialization](https://flutter.dev/docs/development/data-and-backend/json)

3. **Testing APIs**
   - [JSONPlaceholder](https://jsonplaceholder.typicode.com/)
   - [ReqRes](https://reqres.in/)

---

## 💡 نصائح

- ✅ استخدم `const` في Base URLs
- ✅ عالج جميع حالات الأخطاء المحتملة
- ✅ استخدم `timeout` لتجنب التعليق
- ✅ أنشئ Models منفصلة للبيانات
- ✅ استخدم Services/Repositories للتنظيم
- ✅ لا تنسَ `async/await` مع Future
- ✅ استخدم `FutureBuilder` للعرض التلقائي

---

[⬅️ السابق: أنماط State](../Level%203%20-%20State%20Management/30_state_patterns.md)
[🏠 العودة للفهرس](../README.md)
[التالي: قواعد البيانات المحلية ➡️](32_local_database.md)
