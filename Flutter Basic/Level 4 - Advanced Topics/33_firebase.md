# 33 - Firebase - Backend كخدمة

## 📋 المحتويات

- [المقدمة](#المقدمة)
- [إعداد Firebase](#إعداد-firebase)
- [Firebase Authentication](#firebase-authentication)
- [Cloud Firestore](#cloud-firestore)
- [Firebase Storage](#firebase-storage)
- [أمثلة عملية](#أمثلة-عملية)

---

## 🎯 المقدمة

Firebase منصة من Google توفر خدمات Backend جاهزة للتطبيقات.

**الخدمات الأساسية:**

- **Authentication**: تسجيل الدخول
- **Firestore**: قاعدة بيانات NoSQL
- **Storage**: تخزين الملفات
- **Cloud Functions**: وظائف سحابية
- **Analytics**: تحليلات

---

## ⚙️ إعداد Firebase

### 1. إنشاء مشروع Firebase

1. اذهب إلى [Firebase Console](https://console.firebase.google.com/)
2. أنشئ مشروع جديد
3. أضف تطبيق Android/iOS

---

### 2. تثبيت الحزم

```yaml
dependencies:
  firebase_core: ^2.24.2
  firebase_auth: ^4.15.3
  cloud_firestore: ^4.13.6
  firebase_storage: ^11.5.6
```

---

### 3. التهيئة

```dart
// main.dart
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
```

---

## 🔐 Firebase Authentication

### التسجيل بالبريد وكلمة المرور

```dart
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Current user
  User? get currentUser => _auth.currentUser;

  // Auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign Up
  Future<UserCredential> signUp({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw Exception('كلمة المرور ضعيفة');
      } else if (e.code == 'email-already-in-use') {
        throw Exception('البريد الإلكتروني مستخدم بالفعل');
      }
      throw Exception(e.message);
    }
  }

  // Sign In
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('المستخدم غير موجود');
      } else if (e.code == 'wrong-password') {
        throw Exception('كلمة المرور خاطئة');
      }
      throw Exception(e.message);
    }
  }

  // Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Reset Password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception('فشل إرسال رابط إعادة التعيين');
    }
  }

  // Update Profile
  Future<void> updateProfile({
    String? displayName,
    String? photoURL,
  }) async {
    try {
      await currentUser?.updateDisplayName(displayName);
      await currentUser?.updatePhotoURL(photoURL);
    } catch (e) {
      throw Exception('فشل تحديث الملف الشخصي');
    }
  }
}
```

---

### شاشة تسجيل الدخول

```dart
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await _authService.signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تسجيل الدخول')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'البريد الإلكتروني',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال البريد الإلكتروني';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'كلمة المرور',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال كلمة المرور';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _signIn,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('تسجيل الدخول'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

---

## 🗄️ Cloud Firestore

### إضافة البيانات

```dart
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Add document
  Future<void> addUser({
    required String uid,
    required String name,
    required String email,
  }) async {
    await _db.collection('users').doc(uid).set({
      'name': name,
      'email': email,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Add with auto-generated ID
  Future<DocumentReference> addPost({
    required String title,
    required String content,
    required String authorId,
  }) async {
    return await _db.collection('posts').add({
      'title': title,
      'content': content,
      'authorId': authorId,
      'createdAt': FieldValue.serverTimestamp(),
      'likes': 0,
    });
  }
}
```

---

### قراءة البيانات

```dart
class FirestoreService {
  // ... الكود السابق

  // Get single document
  Future<Map<String, dynamic>?> getUser(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    return doc.data();
  }

  // Get all documents
  Future<List<Map<String, dynamic>>> getAllPosts() async {
    final snapshot = await _db
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      return {
        'id': doc.id,
        ...doc.data(),
      };
    }).toList();
  }

  // Real-time updates
  Stream<List<Map<String, dynamic>>> getPostsStream() {
    return _db
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          ...doc.data(),
        };
      }).toList();
    });
  }

  // Query with filter
  Future<List<Map<String, dynamic>>> getUserPosts(String authorId) async {
    final snapshot = await _db
        .collection('posts')
        .where('authorId', isEqualTo: authorId)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      return {
        'id': doc.id,
        ...doc.data(),
      };
    }).toList();
  }
}
```

---

### تحديث وحذف البيانات

```dart
class FirestoreService {
  // ... الكود السابق

  // Update document
  Future<void> updatePost(String postId, Map<String, dynamic> data) async {
    await _db.collection('posts').doc(postId).update(data);
  }

  // Increment field
  Future<void> likePost(String postId) async {
    await _db.collection('posts').doc(postId).update({
      'likes': FieldValue.increment(1),
    });
  }

  // Delete document
  Future<void> deletePost(String postId) async {
    await _db.collection('posts').doc(postId).delete();
  }

  // Batch write
  Future<void> batchDelete(List<String> postIds) async {
    final batch = _db.batch();

    for (var id in postIds) {
      batch.delete(_db.collection('posts').doc(id));
    }

    await batch.commit();
  }
}
```

---

### استخدام StreamBuilder

```dart
class PostsScreen extends StatelessWidget {
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('المنشورات')),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _firestoreService.getPostsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('خطأ: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
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
                  title: Text(post['title']),
                  subtitle: Text(post['content']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.favorite_border),
                        onPressed: () {
                          _firestoreService.likePost(post['id']);
                        },
                      ),
                      Text('${post['likes']}'),
                    ],
                  ),
                ),
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

## 📁 Firebase Storage

### رفع الصور

```dart
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Upload file
  Future<String> uploadImage(File file, String path) async {
    try {
      final ref = _storage.ref().child(path);
      final uploadTask = ref.putFile(file);

      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      throw Exception('فشل رفع الصورة');
    }
  }

  // Upload with progress
  Future<String> uploadImageWithProgress(
    File file,
    String path,
    Function(double) onProgress,
  ) async {
    final ref = _storage.ref().child(path);
    final uploadTask = ref.putFile(file);

    uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
      final progress = snapshot.bytesTransferred / snapshot.totalBytes;
      onProgress(progress);
    });

    final snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  // Delete file
  Future<void> deleteFile(String path) async {
    await _storage.ref().child(path).delete();
  }

  // Get download URL
  Future<String> getDownloadURL(String path) async {
    return await _storage.ref().child(path).getDownloadURL();
  }
}
```

---

### اختيار ورفع صورة

```dart
import 'package:image_picker/image_picker.dart';

class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({super.key});

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  final StorageService _storageService = StorageService();
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  double _uploadProgress = 0;
  bool _isUploading = false;

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_selectedImage == null) return;

    setState(() => _isUploading = true);

    try {
      final path = 'images/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final url = await _storageService.uploadImageWithProgress(
        _selectedImage!,
        path,
        (progress) {
          setState(() => _uploadProgress = progress);
        },
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تم الرفع: $url')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ: $e')),
        );
      }
    } finally {
      setState(() {
        _isUploading = false;
        _uploadProgress = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('رفع صورة')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_selectedImage != null)
              Image.file(
                _selectedImage!,
                height: 200,
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('اختر صورة'),
            ),
            const SizedBox(height: 20),
            if (_isUploading)
              Column(
                children: [
                  CircularProgressIndicator(value: _uploadProgress),
                  Text('${(_uploadProgress * 100).toStringAsFixed(0)}%'),
                ],
              )
            else if (_selectedImage != null)
              ElevatedButton(
                onPressed: _uploadImage,
                child: const Text('رفع الصورة'),
              ),
          ],
        ),
      ),
    );
  }
}
```

---

## 💼 أمثلة عملية

### تطبيق دردشة بسيط

```dart
// models/message.dart
class Message {
  final String id;
  final String text;
  final String senderId;
  final String senderName;
  final DateTime timestamp;

  Message({
    required this.id,
    required this.text,
    required this.senderId,
    required this.senderName,
    required this.timestamp,
  });

  factory Message.fromMap(String id, Map<String, dynamic> map) {
    return Message(
      id: id,
      text: map['text'],
      senderId: map['senderId'],
      senderName: map['senderName'],
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'senderId': senderId,
      'senderName': senderName,
      'timestamp': FieldValue.serverTimestamp(),
    };
  }
}

// services/chat_service.dart
class ChatService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Message>> getMessages() {
    return _db
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Message.fromMap(doc.id, doc.data());
      }).toList();
    });
  }

  Future<void> sendMessage(Message message) async {
    await _db.collection('messages').add(message.toMap());
  }
}

// screens/chat_screen.dart
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final user = _authService.currentUser;
    if (user == null) return;

    _chatService.sendMessage(
      Message(
        id: '',
        text: _messageController.text.trim(),
        senderId: user.uid,
        senderName: user.displayName ?? 'مجهول',
        timestamp: DateTime.now(),
      ),
    );

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الدردشة')),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Message>>(
              stream: _chatService.getMessages(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!;

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isMe =
                        message.senderId == _authService.currentUser?.uid;

                    return Align(
                      alignment:
                          isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.blue : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              message.senderName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isMe ? Colors.white : Colors.black,
                              ),
                            ),
                            Text(
                              message.text,
                              style: TextStyle(
                                color: isMe ? Colors.white : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'اكتب رسالة...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

---

## 📚 المراجع والمصادر

1. **Firebase Packages**
   - [firebase_core](https://pub.dev/packages/firebase_core)
   - [firebase_auth](https://pub.dev/packages/firebase_auth)
   - [cloud_firestore](https://pub.dev/packages/cloud_firestore)
   - [firebase_storage](https://pub.dev/packages/firebase_storage)

2. **Documentation**
   - [Firebase Documentation](https://firebase.google.com/docs)
   - [FlutterFire](https://firebase.flutter.dev/)

---

## 💡 نصائح

- ✅ استخدم Security Rules لحماية البيانات
- ✅ استخدم Indexes للاستعلامات المعقدة
- ✅ راقب استهلاك الـ Reads/Writes
- ✅ استخدم StreamBuilder للتحديثات الفورية
- ✅ عالج الأخطاء بشكل صحيح
- ✅ لا تخزن بيانات حساسة في Firestore بدون تشفير

---

[⬅️ السابق: قواعد البيانات المحلية](32_local_database.md)
[🏠 العودة للفهرس](../README.md)
[التالي: الملفات والوسائط ➡️](34_files_media.md)
