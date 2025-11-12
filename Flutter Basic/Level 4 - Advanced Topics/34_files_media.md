# 34 - الملفات والوسائط - Images, Files, Camera

## 📋 المحتويات

- [المقدمة](#المقدمة)
- [اختيار الصور](#اختيار-الصور)
- [التقاط الصور](#التقاط-الصور)
- [قراءة وكتابة الملفات](#قراءة-وكتابة-الملفات)
- [تشغيل الفيديو والصوت](#تشغيل-الفيديو-والصوت)

---

## 🎯 المقدمة

التعامل مع الملفات والوسائط ضروري لمعظم التطبيقات الحديثة.

---

## 🖼️ اختيار الصور

### التثبيت

```yaml
dependencies:
  image_picker: ^1.0.4
```

---

### اختيار صورة من المعرض

```dart
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  // Pick single image
  Future<File?> pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1920,
      maxHeight: 1080,
      imageQuality: 85,
    );

    if (image != null) {
      return File(image.path);
    }
    return null;
  }

  // Pick multiple images
  Future<List<File>> pickMultipleImages() async {
    final List<XFile> images = await _picker.pickMultiImage(
      maxWidth: 1920,
      maxHeight: 1080,
      imageQuality: 85,
    );

    return images.map((image) => File(image.path)).toList();
  }
}
```

---

### مثال عملي

```dart
class ImagePickerScreen extends StatefulWidget {
  const ImagePickerScreen({super.key});

  @override
  State<ImagePickerScreen> createState() => _ImagePickerScreenState();
}

class _ImagePickerScreenState extends State<ImagePickerScreen> {
  final ImagePickerService _imageService = ImagePickerService();
  File? _selectedImage;
  List<File> _selectedImages = [];

  Future<void> _pickSingleImage() async {
    final image = await _imageService.pickImageFromGallery();
    if (image != null) {
      setState(() => _selectedImage = image);
    }
  }

  Future<void> _pickMultipleImages() async {
    final images = await _imageService.pickMultipleImages();
    setState(() => _selectedImages = images);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('اختيار الصور')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _pickSingleImage,
              child: const Text('اختر صورة واحدة'),
            ),
            if (_selectedImage != null)
              Image.file(_selectedImage!, height: 200),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickMultipleImages,
              child: const Text('اختر صور متعددة'),
            ),
            if (_selectedImages.isNotEmpty)
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                ),
                itemCount: _selectedImages.length,
                itemBuilder: (context, index) {
                  return Image.file(
                    _selectedImages[index],
                    fit: BoxFit.cover,
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
```

---

## 📷 التقاط الصور

### التقاط صورة من الكاميرا

```dart
class CameraService {
  final ImagePicker _picker = ImagePicker();

  Future<File?> takePhoto() async {
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.rear,
      maxWidth: 1920,
      maxHeight: 1080,
      imageQuality: 85,
    );

    if (photo != null) {
      return File(photo.path);
    }
    return null;
  }

  Future<File?> takeSelfie() async {
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
    );

    if (photo != null) {
      return File(photo.path);
    }
    return null;
  }
}
```

---

### تسجيل فيديو

```dart
class VideoService {
  final ImagePicker _picker = ImagePicker();

  Future<File?> recordVideo() async {
    final XFile? video = await _picker.pickVideo(
      source: ImageSource.camera,
      maxDuration: const Duration(seconds: 30),
    );

    if (video != null) {
      return File(video.path);
    }
    return null;
  }

  Future<File?> pickVideoFromGallery() async {
    final XFile? video = await _picker.pickVideo(
      source: ImageSource.gallery,
    );

    if (video != null) {
      return File(video.path);
    }
    return null;
  }
}
```

---

## 📂 قراءة وكتابة الملفات

### التثبيت

```yaml
dependencies:
  path_provider: ^2.1.1
```

---

### الحصول على مسارات الملفات

```dart
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class FileService {
  // Get documents directory
  Future<Directory> getDocumentsDirectory() async {
    return await getApplicationDocumentsDirectory();
  }

  // Get temporary directory
  Future<Directory> getTemporaryDirectory() async {
    return await getTemporaryDirectory();
  }

  // Get app support directory
  Future<Directory> getAppSupportDirectory() async {
    return await getApplicationSupportDirectory();
  }
}
```

---

### كتابة وقراءة الملفات

```dart
import 'dart:convert';

class FileService {
  // Write text file
  Future<void> writeTextFile(String filename, String content) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$filename');
    await file.writeAsString(content);
  }

  // Read text file
  Future<String> readTextFile(String filename) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$filename');
      return await file.readAsString();
    } catch (e) {
      return '';
    }
  }

  // Write JSON file
  Future<void> writeJsonFile(
    String filename,
    Map<String, dynamic> data,
  ) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$filename');
    final jsonString = json.encode(data);
    await file.writeAsString(jsonString);
  }

  // Read JSON file
  Future<Map<String, dynamic>?> readJsonFile(String filename) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$filename');
      final jsonString = await file.readAsString();
      return json.decode(jsonString);
    } catch (e) {
      return null;
    }
  }

  // Delete file
  Future<void> deleteFile(String filename) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$filename');
    if (await file.exists()) {
      await file.delete();
    }
  }

  // Check if file exists
  Future<bool> fileExists(String filename) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$filename');
    return await file.exists();
  }

  // List all files
  Future<List<FileSystemEntity>> listFiles() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.listSync();
  }
}
```

---

### مثال: حفظ وقراءة ملاحظات

```dart
class NotesFileScreen extends StatefulWidget {
  const NotesFileScreen({super.key});

  @override
  State<NotesFileScreen> createState() => _NotesFileScreenState();
}

class _NotesFileScreenState extends State<NotesFileScreen> {
  final FileService _fileService = FileService();
  final TextEditingController _controller = TextEditingController();
  String _savedNote = '';

  @override
  void initState() {
    super.initState();
    _loadNote();
  }

  Future<void> _loadNote() async {
    final note = await _fileService.readTextFile('note.txt');
    setState(() => _savedNote = note);
  }

  Future<void> _saveNote() async {
    await _fileService.writeTextFile('note.txt', _controller.text);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم حفظ الملاحظة')),
    );
    _loadNote();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ملاحظاتي')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'اكتب ملاحظة',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveNote,
              child: const Text('حفظ'),
            ),
            const SizedBox(height: 32),
            Text('الملاحظة المحفوظة:'),
            Text(_savedNote),
          ],
        ),
      ),
    );
  }
}
```

---

## 🎥 تشغيل الفيديو والصوت

### التثبيت

```yaml
dependencies:
  video_player: ^2.8.1
  audioplayers: ^5.2.1
```

---

### تشغيل الفيديو

```dart
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerScreen({super.key, required this.videoUrl});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    _controller = VideoPlayerController.network(widget.videoUrl);
    await _controller.initialize();
    setState(() => _isInitialized = true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تشغيل الفيديو')),
      body: Center(
        child: _isInitialized
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  ),
                  VideoProgressIndicator(
                    _controller,
                    allowScrubbing: true,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(
                          _controller.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                        ),
                        onPressed: () {
                          setState(() {
                            _controller.value.isPlaying
                                ? _controller.pause()
                                : _controller.play();
                          });
                        },
                      ),
                    ],
                  ),
                ],
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}
```

---

### تشغيل الصوت

```dart
import 'package:audioplayers/audioplayers.dart';

class AudioPlayerScreen extends StatefulWidget {
  const AudioPlayerScreen({super.key});

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _setupAudioPlayer();
  }

  void _setupAudioPlayer() {
    _audioPlayer.onDurationChanged.listen((duration) {
      setState(() => _duration = duration);
    });

    _audioPlayer.onPositionChanged.listen((position) {
      setState(() => _position = position);
    });

    _audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() => _isPlaying = state == PlayerState.playing);
    });
  }

  Future<void> _playAudio(String url) async {
    await _audioPlayer.play(UrlSource(url));
  }

  Future<void> _pauseAudio() async {
    await _audioPlayer.pause();
  }

  Future<void> _stopAudio() async {
    await _audioPlayer.stop();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('مشغل الصوت')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Slider(
              min: 0,
              max: _duration.inSeconds.toDouble(),
              value: _position.inSeconds.toDouble(),
              onChanged: (value) {
                _audioPlayer.seek(Duration(seconds: value.toInt()));
              },
            ),
            Text(
              '${_position.toString().split('.').first} / ${_duration.toString().split('.').first}',
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                  onPressed: () {
                    if (_isPlaying) {
                      _pauseAudio();
                    } else {
                      _playAudio(
                        'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
                      );
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.stop),
                  onPressed: _stopAudio,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 📚 المراجع والمصادر

1. **Packages**
   - [image_picker](https://pub.dev/packages/image_picker)
   - [path_provider](https://pub.dev/packages/path_provider)
   - [video_player](https://pub.dev/packages/video_player)
   - [audioplayers](https://pub.dev/packages/audioplayers)

2. **Documentation**
   - [Flutter File Handling](https://flutter.dev/docs/cookbook/persistence/reading-writing-files)

---

## 💡 نصائح

- ✅ اطلب الأذونات قبل الوصول للكاميرا والملفات
- ✅ ضغط الصور قبل الرفع
- ✅ استخدم `path_provider` للمسارات الصحيحة
- ✅ عالج الأخطاء عند فشل التحميل
- ✅ dispose الـ Controllers
- ✅ استخدم thumbnails للصور الكبيرة

---

[⬅️ السابق: Firebase](33_firebase.md)
[🏠 العودة للفهرس](../README.md)
[التالي: الخرائط والموقع ➡️](35_maps_location.md)
