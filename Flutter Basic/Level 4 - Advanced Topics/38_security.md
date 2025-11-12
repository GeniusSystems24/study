# 38 - الأمان - Security & Encryption

## 📋 المحتويات

- [المقدمة](#المقدمة)
- [تشفير البيانات](#تشفير-البيانات)
- [التخزين الآمن](#التخزين-الآمن)
- [المصادقة البيومترية](#المصادقة-البيومترية)
- [أفضل الممارسات](#أفضل-الممارسات)

---

## 🎯 المقدمة

الأمان ضروري لحماية بيانات المستخدمين وضمان سلامة التطبيق.

---

## 🔐 تشفير البيانات

### التثبيت

```yaml
dependencies:
  encrypt: ^5.0.3
  crypto: ^3.0.3
```

---

### تشفير النصوص

```dart
import 'package:encrypt/encrypt.dart' as encrypt;

class EncryptionService {
  static final _key = encrypt.Key.fromLength(32);
  static final _iv = encrypt.IV.fromLength(16);
  static final _encrypter = encrypt.Encrypter(encrypt.AES(_key));

  // Encrypt text
  static String encryptText(String plainText) {
    final encrypted = _encrypter.encrypt(plainText, iv: _iv);
    return encrypted.base64;
  }

  // Decrypt text
  static String decryptText(String encryptedText) {
    final encrypted = encrypt.Encrypted.fromBase64(encryptedText);
    return _encrypter.decrypt(encrypted, iv: _iv);
  }
}

// مثال الاستخدام
void main() {
  const originalText = 'رسالة سرية';
  
  // تشفير
  final encrypted = EncryptionService.encryptText(originalText);
  print('مشفر: $encrypted');
  
  // فك التشفير
  final decrypted = EncryptionService.decryptText(encrypted);
  print('فك التشفير: $decrypted');
}
```

---

### Hashing

```dart
import 'package:crypto/crypto.dart';
import 'dart:convert';

class HashingService {
  // SHA-256 Hash
  static String sha256Hash(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // MD5 Hash
  static String md5Hash(String input) {
    final bytes = utf8.encode(input);
    final digest = md5.convert(bytes);
    return digest.toString();
  }

  // Verify password
  static bool verifyPassword(String password, String hashedPassword) {
    return sha256Hash(password) == hashedPassword;
  }
}

// مثال
void main() {
  const password = 'myPassword123';
  final hashed = HashingService.sha256Hash(password);
  print('Hashed: $hashed');
  
  final isValid = HashingService.verifyPassword(password, hashed);
  print('Valid: $isValid');
}
```

---

## 🔒 التخزين الآمن

### flutter_secure_storage

```yaml
dependencies:
  flutter_secure_storage: ^9.0.0
```

---

### استخدام التخزين الآمن

```dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const _storage = FlutterSecureStorage();

  // Write
  static Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  // Read
  static Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  // Delete
  static Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  // Delete all
  static Future<void> deleteAll() async {
    await _storage.deleteAll();
  }

  // Read all
  static Future<Map<String, String>> readAll() async {
    return await _storage.readAll();
  }
}

// مثال: حفظ Token
class AuthService {
  static Future<void> saveAuthToken(String token) async {
    await SecureStorageService.write('auth_token', token);
  }

  static Future<String?> getAuthToken() async {
    return await SecureStorageService.read('auth_token');
  }

  static Future<void> logout() async {
    await SecureStorageService.delete('auth_token');
  }
}
```

---

## 👆 المصادقة البيومترية

### التثبيت

```yaml
dependencies:
  local_auth: ^2.1.7
```

---

### إعداد الأذونات

**Android** (`android/app/src/main/AndroidManifest.xml`):

```xml
<uses-permission android:name="android.permission.USE_BIOMETRIC"/>
```

**iOS** (`ios/Runner/Info.plist`):

```xml
<key>NSFaceIDUsageDescription</key>
<string>نحتاج Face ID للمصادقة</string>
```

---

### استخدام البصمة

```dart
import 'package:local_auth/local_auth.dart';

class BiometricService {
  static final LocalAuthentication _auth = LocalAuthentication();

  // Check if device supports biometrics
  static Future<bool> canCheckBiometrics() async {
    try {
      return await _auth.canCheckBiometrics;
    } catch (e) {
      return false;
    }
  }

  // Get available biometrics
  static Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } catch (e) {
      return [];
    }
  }

  // Authenticate
  static Future<bool> authenticate({
    required String reason,
  }) async {
    try {
      return await _auth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
      );
    } catch (e) {
      return false;
    }
  }

  // Stop authentication
  static Future<void> stopAuthentication() async {
    await _auth.stopAuthentication();
  }
}
```

---

### شاشة مصادقة

```dart
class BiometricLoginScreen extends StatefulWidget {
  const BiometricLoginScreen({super.key});

  @override
  State<BiometricLoginScreen> createState() => _BiometricLoginScreenState();
}

class _BiometricLoginScreenState extends State<BiometricLoginScreen> {
  bool _canUseBiometric = false;
  List<BiometricType> _availableBiometrics = [];

  @override
  void initState() {
    super.initState();
    _checkBiometricSupport();
  }

  Future<void> _checkBiometricSupport() async {
    final canCheck = await BiometricService.canCheckBiometrics();
    final available = await BiometricService.getAvailableBiometrics();

    setState(() {
      _canUseBiometric = canCheck;
      _availableBiometrics = available;
    });
  }

  Future<void> _authenticate() async {
    final authenticated = await BiometricService.authenticate(
      reason: 'الرجاء المصادقة للدخول',
    );

    if (authenticated) {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('فشلت المصادقة')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تسجيل الدخول')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_canUseBiometric) ...[
              const Icon(Icons.fingerprint, size: 100),
              const SizedBox(height: 20),
              Text('المصادقات المتاحة: ${_availableBiometrics.length}'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _authenticate,
                child: const Text('مصادقة بالبصمة'),
              ),
            ] else
              const Text('المصادقة البيومترية غير متاحة'),
          ],
        ),
      ),
    );
  }
}
```

---

## 🛡️ أفضل الممارسات

### 1. حماية API Keys

```dart
// ❌ سيء
class ApiService {
  static const String apiKey = 'your-api-key-here'; // مكشوف في الكود
}

// ✅ جيد - استخدم environment variables
// في terminal:
// flutter run --dart-define=API_KEY=your-api-key

class ApiService {
  static const String apiKey = String.fromEnvironment('API_KEY');
}
```

---

### 2. التحقق من SSL Certificate

```dart
import 'package:http/http.dart' as http;
import 'dart:io';

class SecureHttpClient {
  static Future<http.Response> secureGet(String url) async {
    final client = http.Client();
    
    try {
      final response = await client.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
        },
      );

      // Verify SSL
      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception('HTTP Error: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('No internet connection');
    } on HandshakeException {
      throw Exception('SSL Certificate verification failed');
    } finally {
      client.close();
    }
  }
}
```

---

### 3. تنظيف البيانات الحساسة

```dart
class SensitiveDataHandler {
  String? _password;
  String? _creditCard;

  void setPassword(String password) {
    _password = password;
  }

  void clearPassword() {
    _password = null;
  }

  @override
  void dispose() {
    // تنظيف البيانات الحساسة
    _password = null;
    _creditCard = null;
  }
}
```

---

### 4. منع لقطات الشاشة

```yaml
dependencies:
  screenshot_callback: ^1.0.0
```

```dart
import 'package:screenshot_callback/screenshot_callback.dart';

class SecureScreen extends StatefulWidget {
  @override
  State<SecureScreen> createState() => _SecureScreenState();
}

class _SecureScreenState extends State<SecureScreen> {
  final ScreenshotCallback _screenshotCallback = ScreenshotCallback();

  @override
  void initState() {
    super.initState();
    _screenshotCallback.addListener(() {
      // تحذير المستخدم
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لقطة الشاشة غير مسموحة')),
      );
    });
  }

  @override
  void dispose() {
    _screenshotCallback.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('شاشة آمنة')),
      body: const Center(child: Text('محتوى حساس')),
    );
  }
}
```

---

### 5. التحقق من Root/Jailbreak

```yaml
dependencies:
  flutter_jailbreak_detection: ^1.10.0
```

```dart
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';

class SecurityChecker {
  static Future<bool> isDeviceSecure() async {
    try {
      final jailbroken = await FlutterJailbreakDetection.jailbroken;
      final developerMode = await FlutterJailbreakDetection.developerMode;

      return !jailbroken && !developerMode;
    } catch (e) {
      return true; // افتراض أن الجهاز آمن في حالة الخطأ
    }
  }

  static Future<void> checkAndWarn(BuildContext context) async {
    final isSecure = await isDeviceSecure();

    if (!isSecure) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('تحذير أمني'),
          content: const Text(
            'تم اكتشاف أن جهازك معدل (Rooted/Jailbroken). '
            'قد لا يعمل التطبيق بشكل صحيح.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('حسناً'),
            ),
          ],
        ),
      );
    }
  }
}
```

---

### 6. تشفير قاعدة البيانات المحلية

```yaml
dependencies:
  sqflite_sqlcipher: ^2.2.1
```

```dart
import 'package:sqflite_sqlcipher/sqflite.dart';

class SecureDatabaseHelper {
  static Future<Database> openSecureDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = '$databasesPath/secure_db.db';

    return await openDatabase(
      path,
      version: 1,
      password: 'your-secure-password', // استخدم password قوي
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY,
            name TEXT,
            email TEXT
          )
        ''');
      },
    );
  }
}
```

---

## 📚 المراجع والمصادر

1. **Packages**
   - [encrypt](https://pub.dev/packages/encrypt)
   - [crypto](https://pub.dev/packages/crypto)
   - [flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage)
   - [local_auth](https://pub.dev/packages/local_auth)

2. **Documentation**
   - [OWASP Mobile Security](https://owasp.org/www-project-mobile-security/)
   - [Flutter Security](https://flutter.dev/docs/deployment/obfuscate)

---

## 💡 نصائح

- ✅ لا تخزن بيانات حساسة في SharedPreferences
- ✅ استخدم flutter_secure_storage للبيانات الحساسة
- ✅ شفّر الاتصالات باستخدام HTTPS
- ✅ استخدم Certificate Pinning للأمان الإضافي
- ✅ تحقق من صحة المدخلات
- ✅ استخدم Obfuscation عند البناء للـ Production
- ✅ اختبر الأمان بانتظام

---

[⬅️ السابق: التدويل](37_internationalization.md)
[🏠 العودة للفهرس](../README.md)
[التالي: الاختبارات ➡️](39_testing.md)
