import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HttpApiHome extends StatelessWidget {
  const HttpApiHome({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 7,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('HTTP & API'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'المقدمة'),
              Tab(text: 'GET Requests'),
              Tab(text: 'POST/PUT/DELETE'),
              Tab(text: 'dio Package'),
              Tab(text: 'JSON Parsing'),
              Tab(text: 'Error Handling'),
              Tab(text: 'Best Practices'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            IntroductionTab(),
            GetRequestsTab(),
            PostPutDeleteTab(),
            DioPackageTab(),
            JsonParsingTab(),
            ErrorHandlingTab(),
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
          '🌐 HTTP & REST APIs',
          'التواصل مع الخوادم وجلب البيانات من الإنترنت',
        ),
        const SizedBox(height: 16),
        _buildContentCard(
          context,
          'ما هو HTTP؟',
          '''
HTTP (HyperText Transfer Protocol) هو بروتوكول الاتصال الأساسي للويب:

• GET: جلب البيانات من الخادم
• POST: إرسال بيانات جديدة
• PUT: تحديث بيانات موجودة
• DELETE: حذف بيانات
• PATCH: تحديث جزئي للبيانات
''',
        ),
        _buildContentCard(
          context,
          'REST API Principles',
          '''
REST (Representational State Transfer):

1. Stateless: كل طلب مستقل
2. Client-Server: فصل واضح بين العميل والخادم
3. Cacheable: قابلية التخزين المؤقت
4. Uniform Interface: واجهة موحدة
5. Resource-Based: التعامل مع الموارد
''',
        ),
        _buildContentCard(
          context,
          'HTTP Status Codes',
          '''
أكواد الحالة الشائعة:

2xx - نجاح:
  • 200: OK
  • 201: Created
  • 204: No Content

4xx - خطأ من العميل:
  • 400: Bad Request
  • 401: Unauthorized
  • 404: Not Found

5xx - خطأ من الخادم:
  • 500: Internal Server Error
  • 503: Service Unavailable
''',
        ),
        _buildCodeCard(
          context,
          'إضافة package http',
          '''
# في pubspec.yaml
dependencies:
  http: ^1.1.0

# ثم قم بتشغيل:
flutter pub get
''',
        ),
      ],
    );
  }
}

// ==================== Tab 2: GET Requests ====================
class GetRequestsTab extends StatefulWidget {
  const GetRequestsTab({super.key});

  @override
  State<GetRequestsTab> createState() => _GetRequestsTabState();
}

class _GetRequestsTabState extends State<GetRequestsTab> {
  List<dynamic> _posts = [];
  bool _isLoading = false;
  String _error = '';

  Future<void> _fetchPosts() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/posts'),
      );

      if (response.statusCode == 200) {
        setState(() {
          _posts = json.decode(response.body);
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Error: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildCodeCard(
                context,
                'GET Request - Basic Example',
                '''
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> fetchData() async {
  // إنشاء URL
  final url = Uri.parse('https://api.example.com/data');
  
  // إرسال GET request
  final response = await http.get(url);
  
  // التحقق من الحالة
  if (response.statusCode == 200) {
    // تحويل JSON إلى Dart object
    final data = json.decode(response.body);
    print(data);
  } else {
    throw Exception('Failed to load data');
  }
}
''',
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _fetchPosts,
                icon: const Icon(Icons.cloud_download),
                label: const Text('Fetch Posts from JSONPlaceholder'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
              ),
              if (_error.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Card(
                    color: Colors.red[100],
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        _error,
                        style: TextStyle(color: Colors.red[900]),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (_isLoading)
          const Expanded(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        else
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _posts.take(10).length,
              itemBuilder: (context, index) {
                final post = _posts[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text('${post['id']}'),
                    ),
                    title: Text(
                      post['title'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      post['body'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}

// ==================== Tab 3: POST/PUT/DELETE ====================
class PostPutDeleteTab extends StatefulWidget {
  const PostPutDeleteTab({super.key});

  @override
  State<PostPutDeleteTab> createState() => _PostPutDeleteTabState();
}

class _PostPutDeleteTabState extends State<PostPutDeleteTab> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  String _result = '';
  bool _isLoading = false;

  Future<void> _createPost() async {
    if (_titleController.text.isEmpty) return;

    setState(() {
      _isLoading = true;
      _result = '';
    });

    try {
      final response = await http.post(
        Uri.parse('https://jsonplaceholder.typicode.com/posts'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'title': _titleController.text,
          'body': _bodyController.text,
          'userId': 1,
        }),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        setState(() {
          _result = 'POST Success! Created ID: ${data['id']}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _result = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _updatePost() async {
    setState(() {
      _isLoading = true;
      _result = '';
    });

    try {
      final response = await http.put(
        Uri.parse('https://jsonplaceholder.typicode.com/posts/1'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'id': 1,
          'title': _titleController.text,
          'body': _bodyController.text,
          'userId': 1,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          _result = 'PUT Success! Updated post';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _result = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _deletePost() async {
    setState(() {
      _isLoading = true;
      _result = '';
    });

    try {
      final response = await http.delete(
        Uri.parse('https://jsonplaceholder.typicode.com/posts/1'),
      );

      if (response.statusCode == 200) {
        setState(() {
          _result = 'DELETE Success! Deleted post';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _result = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildCodeCard(
          context,
          'POST Request - Create Data',
          '''
Future<void> createPost(String title, String body) async {
  final response = await http.post(
    Uri.parse('https://api.example.com/posts'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({
      'title': title,
      'body': body,
      'userId': 1,
    }),
  );
  
  if (response.statusCode == 201) {
    final newPost = json.decode(response.body);
    print('Created: \$newPost');
  }
}
''',
        ),
        _buildCodeCard(
          context,
          'PUT Request - Update Data',
          '''
Future<void> updatePost(int id, String title) async {
  final response = await http.put(
    Uri.parse('https://api.example.com/posts/\$id'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({
      'id': id,
      'title': title,
      'userId': 1,
    }),
  );
  
  if (response.statusCode == 200) {
    print('Updated successfully');
  }
}
''',
        ),
        _buildCodeCard(
          context,
          'DELETE Request - Remove Data',
          '''
Future<void> deletePost(int id) async {
  final response = await http.delete(
    Uri.parse('https://api.example.com/posts/\$id'),
  );
  
  if (response.statusCode == 200) {
    print('Deleted successfully');
  }
}
''',
        ),
        const SizedBox(height: 16),
        const Text(
          'تجربة عملية',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _titleController,
          decoration: const InputDecoration(
            labelText: 'Title',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _bodyController,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Body',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: _isLoading ? null : _createPost,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: const Text('POST'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton(
                onPressed: _isLoading ? null : _updatePost,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                ),
                child: const Text('PUT'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton(
                onPressed: _isLoading ? null : _deletePost,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('DELETE'),
              ),
            ),
          ],
        ),
        if (_isLoading)
          const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          ),
        if (_result.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Card(
              color: _result.startsWith('Error')
                  ? Colors.red[100]
                  : Colors.green[100],
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  _result,
                  style: TextStyle(
                    color: _result.startsWith('Error')
                        ? Colors.red[900]
                        : Colors.green[900],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }
}

// ==================== Tab 4: dio Package ====================
class DioPackageTab extends StatelessWidget {
  const DioPackageTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildInfoCard(
          context,
          '🚀 dio Package',
          'مكتبة قوية لإدارة HTTP requests مع ميزات متقدمة',
        ),
        const SizedBox(height: 16),
        _buildCodeCard(
          context,
          'Installation',
          '''
# في pubspec.yaml
dependencies:
  dio: ^5.4.0

# ثم:
flutter pub get
''',
        ),
        _buildCodeCard(
          context,
          'Basic Usage',
          '''
import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.example.com',
      connectTimeout: Duration(seconds: 5),
      receiveTimeout: Duration(seconds: 3),
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );
  
  Future<List<Post>> getPosts() async {
    try {
      final response = await _dio.get('/posts');
      return (response.data as List)
          .map((json) => Post.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  Future<Post> createPost(Post post) async {
    final response = await _dio.post(
      '/posts',
      data: post.toJson(),
    );
    return Post.fromJson(response.data);
  }
}
''',
        ),
        _buildCodeCard(
          context,
          'Interceptors - Request/Response Logging',
          '''
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    print('REQUEST[\${options.method}] => \${options.path}');
    print('Headers: \${options.headers}');
    print('Data: \${options.data}');
    super.onRequest(options, handler);
  }
  
  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    print('RESPONSE[\${response.statusCode}] => \${response.requestOptions.path}');
    super.onResponse(response, handler);
  }
  
  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) {
    print('ERROR[\${err.response?.statusCode}] => \${err.message}');
    super.onError(err, handler);
  }
}

// إضافة الـ interceptor
dio.interceptors.add(LoggingInterceptor());
''',
        ),
        _buildCodeCard(
          context,
          'Authentication Interceptor',
          '''
class AuthInterceptor extends Interceptor {
  final String token;
  
  AuthInterceptor(this.token);
  
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    // إضافة التوكن لكل طلب
    options.headers['Authorization'] = 'Bearer \$token';
    super.onRequest(options, handler);
  }
  
  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) {
    // التعامل مع 401 Unauthorized
    if (err.response?.statusCode == 401) {
      // إعادة تسجيل الدخول أو refresh token
      print('Unauthorized - refreshing token...');
    }
    super.onError(err, handler);
  }
}
''',
        ),
        _buildContentCard(
          context,
          'ميزات dio',
          '''
• Global configuration
• Request/Response Interceptors
• FormData & File Upload
• Request Cancellation
• Timeouts
• Error Handling
• Retry Logic
• Progress Callbacks
• HTTP2 Support
''',
        ),
      ],
    );
  }
}

// ==================== Tab 5: JSON Parsing ====================
class JsonParsingTab extends StatelessWidget {
  const JsonParsingTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildInfoCard(
          context,
          '📦 JSON Parsing',
          'تحويل JSON إلى Dart objects والعكس',
        ),
        const SizedBox(height: 16),
        _buildCodeCard(
          context,
          'Model Class',
          '''
class User {
  final int id;
  final String name;
  final String email;
  final Address address;
  
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.address,
  });
  
  // From JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      address: Address.fromJson(json['address']),
    );
  }
  
  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'address': address.toJson(),
    };
  }
}

class Address {
  final String street;
  final String city;
  
  Address({required this.street, required this.city});
  
  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'] as String,
      city: json['city'] as String,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'street': street,
      'city': city,
    };
  }
}
''',
        ),
        _buildCodeCard(
          context,
          'Parsing List of Objects',
          '''
Future<List<User>> fetchUsers() async {
  final response = await http.get(
    Uri.parse('https://api.example.com/users'),
  );
  
  if (response.statusCode == 200) {
    final List<dynamic> jsonList = json.decode(response.body);
    
    return jsonList
        .map((json) => User.fromJson(json))
        .toList();
  } else {
    throw Exception('Failed to load users');
  }
}
''',
        ),
        _buildCodeCard(
          context,
          'json_serializable - Code Generation',
          '''
# في pubspec.yaml
dependencies:
  json_annotation: ^4.8.1

dev_dependencies:
  build_runner: ^2.4.7
  json_serializable: ^6.7.1

# ثم قم بتشغيل:
flutter pub get
flutter pub run build_runner build
''',
        ),
        _buildCodeCard(
          context,
          'Using json_serializable',
          '''
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';  // سيتم إنشاؤه تلقائياً

@JsonSerializable()
class User {
  final int id;
  final String name;
  
  @JsonKey(name: 'email_address')  // map من اسم مختلف
  final String email;
  
  @JsonKey(defaultValue: false)  // قيمة افتراضية
  final bool isActive;
  
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.isActive,
  });
  
  // سيتم إنشاؤها تلقائياً
  factory User.fromJson(Map<String, dynamic> json) =>
      _\$UserFromJson(json);
  
  Map<String, dynamic> toJson() => _\$UserToJson(this);
}
''',
        ),
        _buildContentCard(
          context,
          'Best Practices',
          '''
1. استخدم type casting للأمان
2. تعامل مع null values بحذر
3. استخدم json_serializable للمشاريع الكبيرة
4. اختبر JSON parsing بشكل جيد
5. استخدم freezed package للimmutable models
''',
        ),
      ],
    );
  }
}

// ==================== Tab 6: Error Handling ====================
class ErrorHandlingTab extends StatelessWidget {
  const ErrorHandlingTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildInfoCard(
          context,
          '⚠️ Error Handling',
          'التعامل الصحيح مع الأخطاء والاستثناءات',
        ),
        const SizedBox(height: 16),
        _buildCodeCard(
          context,
          'Custom Exception Classes',
          '''
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  
  ApiException(this.message, [this.statusCode]);
  
  @override
  String toString() => 'ApiException: \$message (\$statusCode)';
}

class NetworkException implements Exception {
  final String message;
  
  NetworkException(this.message);
  
  @override
  String toString() => 'NetworkException: \$message';
}

class TimeoutException implements Exception {
  final String message = 'Request timeout';
  
  @override
  String toString() => 'TimeoutException: \$message';
}
''',
        ),
        _buildCodeCard(
          context,
          'Comprehensive Error Handling',
          '''
class ApiService {
  final Dio dio;
  
  Future<List<Post>> getPosts() async {
    try {
      final response = await dio.get('/posts');
      return (response.data as List)
          .map((json) => Post.fromJson(json))
          .toList();
          
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ApiException('Unexpected error: \$e');
    }
  }
  
  Exception _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException();
        
      case DioExceptionType.badResponse:
        switch (error.response?.statusCode) {
          case 400:
            return ApiException('Bad request', 400);
          case 401:
            return ApiException('Unauthorized', 401);
          case 404:
            return ApiException('Not found', 404);
          case 500:
            return ApiException('Server error', 500);
          default:
            return ApiException(
              'Error: \${error.response?.statusCode}',
              error.response?.statusCode,
            );
        }
        
      case DioExceptionType.cancel:
        return ApiException('Request cancelled');
        
      case DioExceptionType.connectionError:
        return NetworkException('No internet connection');
        
      default:
        return ApiException('Unknown error');
    }
  }
}
''',
        ),
        _buildCodeCard(
          context,
          'Using Error Handling in UI',
          '''
class PostsScreen extends StatefulWidget {
  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  List<Post>? posts;
  String? errorMessage;
  bool isLoading = false;
  
  @override
  void initState() {
    super.initState();
    _loadPosts();
  }
  
  Future<void> _loadPosts() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    
    try {
      final result = await apiService.getPosts();
      setState(() {
        posts = result;
        isLoading = false;
      });
    } on TimeoutException {
      setState(() {
        errorMessage = 'فشل الاتصال - تحقق من الإنترنت';
        isLoading = false;
      });
    } on NetworkException catch (e) {
      setState(() {
        errorMessage = e.message;
        isLoading = false;
      });
    } on ApiException catch (e) {
      setState(() {
        errorMessage = e.message;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'خطأ غير متوقع: \$e';
        isLoading = false;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    
    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error, size: 64, color: Colors.red),
            SizedBox(height: 16),
            Text(errorMessage!),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadPosts,
              child: Text('إعادة المحاولة'),
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      itemCount: posts?.length ?? 0,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(posts![index].title),
        );
      },
    );
  }
}
''',
        ),
        _buildContentCard(
          context,
          'Error Handling Best Practices',
          '''
1. استخدم custom exception classes
2. عرض رسائل خطأ واضحة للمستخدم
3. أضف retry mechanism
4. log الأخطاء للتحليل
5. تعامل مع حالات no internet
6. استخدم timeout للطلبات
7. اختبر سيناريوهات الأخطاء المختلفة
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
          'أفضل الممارسات في التعامل مع APIs',
        ),
        const SizedBox(height: 16),
        _buildCodeCard(
          context,
          '1. API Service Layer',
          '''
// api_service.dart
class ApiService {
  static const String baseUrl = 'https://api.example.com';
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: Duration(seconds: 5),
      receiveTimeout: Duration(seconds: 3),
    ),
  );
  
  // Singleton pattern
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal() {
    _dio.interceptors.add(LoggingInterceptor());
  }
  
  Future<List<Post>> getPosts() async {
    final response = await _dio.get('/posts');
    return (response.data as List)
        .map((json) => Post.fromJson(json))
        .toList();
  }
}
''',
        ),
        _buildCodeCard(
          context,
          '2. Repository Pattern',
          '''
// post_repository.dart
abstract class PostRepository {
  Future<List<Post>> getPosts();
  Future<Post> getPost(int id);
  Future<Post> createPost(Post post);
}

class PostRepositoryImpl implements PostRepository {
  final ApiService _apiService;
  
  PostRepositoryImpl(this._apiService);
  
  @override
  Future<List<Post>> getPosts() async {
    try {
      return await _apiService.getPosts();
    } catch (e) {
      // Log error
      rethrow;
    }
  }
  
  @override
  Future<Post> getPost(int id) async {
    return await _apiService.getPost(id);
  }
  
  @override
  Future<Post> createPost(Post post) async {
    return await _apiService.createPost(post);
  }
}
''',
        ),
        _buildCodeCard(
          context,
          '3. Caching Strategy',
          '''
class CachedPostRepository implements PostRepository {
  final PostRepository _repository;
  final Map<int, Post> _cache = {};
  DateTime? _lastFetch;
  
  CachedPostRepository(this._repository);
  
  @override
  Future<List<Post>> getPosts() async {
    // التحقق من الـ cache
    if (_lastFetch != null &&
        DateTime.now().difference(_lastFetch!) < Duration(minutes: 5)) {
      return _cache.values.toList();
    }
    
    // جلب من API
    final posts = await _repository.getPosts();
    
    // تحديث الـ cache
    _cache.clear();
    for (var post in posts) {
      _cache[post.id] = post;
    }
    _lastFetch = DateTime.now();
    
    return posts;
  }
  
  @override
  Future<Post> getPost(int id) async {
    // التحقق من الـ cache
    if (_cache.containsKey(id)) {
      return _cache[id]!;
    }
    
    // جلب من API
    final post = await _repository.getPost(id);
    _cache[id] = post;
    
    return post;
  }
}
''',
        ),
        _buildCodeCard(
          context,
          '4. Loading States',
          '''
enum LoadingState<T> {
  initial,
  loading,
  success(T data),
  error(String message);
  
  bool get isLoading => this == LoadingState.loading;
  bool get isSuccess => this is LoadingStateSuccess<T>;
  bool get isError => this is LoadingStateError<T>;
}

class PostsController extends ChangeNotifier {
  LoadingState<List<Post>> _state = LoadingState.initial;
  LoadingState<List<Post>> get state => _state;
  
  final PostRepository _repository;
  
  PostsController(this._repository);
  
  Future<void> loadPosts() async {
    _state = LoadingState.loading;
    notifyListeners();
    
    try {
      final posts = await _repository.getPosts();
      _state = LoadingState.success(posts);
    } catch (e) {
      _state = LoadingState.error(e.toString());
    }
    
    notifyListeners();
  }
}
''',
        ),
        _buildContentCard(
          context,
          'API Best Practices Checklist',
          '''
✅ استخدم HTTPS دائماً
✅ أضف timeout للطلبات
✅ استخدم interceptors للـ logging
✅ طبق error handling شامل
✅ استخدم caching للبيانات
✅ طبق retry logic
✅ استخدم pagination للقوائم الطويلة
✅ أضف loading states
✅ استخدم environment variables للـ API keys
✅ طبق rate limiting
✅ استخدم repository pattern
✅ اختبر API calls
''',
        ),
        _buildContentCard(
          context,
          'Security Tips',
          '''
🔒 لا تضع API keys في الكود
🔒 استخدم environment variables
🔒 طبق SSL pinning
🔒 استخدم OAuth 2.0 للـ authentication
🔒 احفظ tokens بشكل آمن (flutter_secure_storage)
🔒 استخدم refresh tokens
🔒 تحقق من SSL certificates
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
