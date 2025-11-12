# 35 - الخرائط والموقع - Maps & Location

## 📋 المحتويات

- [المقدمة](#المقدمة)
- [الحصول على الموقع](#الحصول-على-الموقع)
- [Google Maps](#google-maps)
- [أمثلة عملية](#أمثلة-عملية)

---

## 🎯 المقدمة

التعامل مع الخرائط والموقع ضروري لتطبيقات التوصيل، السفر، والخدمات المحلية.

---

## 📍 الحصول على الموقع

### التثبيت

```yaml
dependencies:
  geolocator: ^10.1.0
  geocoding: ^2.1.1
```

---

### إعداد الأذونات

**Android** (`android/app/src/main/AndroidManifest.xml`):

```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

**iOS** (`ios/Runner/Info.plist`):

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>نحتاج موقعك لإظهار الخدمات القريبة</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>نحتاج موقعك لإظهار الخدمات القريبة</string>
```

---

### الحصول على الموقع الحالي

```dart
import 'package:geolocator/geolocator.dart';

class LocationService {
  // Check if location services are enabled
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  // Check and request permissions
  Future<bool> handlePermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  // Get current position
  Future<Position?> getCurrentPosition() async {
    final hasPermission = await handlePermission();
    if (!hasPermission) return null;

    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      print('Error getting location: $e');
      return null;
    }
  }

  // Get continuous position updates
  Stream<Position> getPositionStream() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // meters
      ),
    );
  }

  // Calculate distance between two points
  double calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
  }
}
```

---

### Geocoding - تحويل العنوان إلى إحداثيات

```dart
import 'package:geocoding/geocoding.dart';

class GeocodingService {
  // Address to coordinates
  Future<Location?> getCoordinatesFromAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      return locations.isNotEmpty ? locations.first : null;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  // Coordinates to address
  Future<String?> getAddressFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        return '${place.street}, ${place.locality}, ${place.country}';
      }
    } catch (e) {
      print('Error: $e');
    }
    return null;
  }
}
```

---

### مثال: عرض الموقع الحالي

```dart
class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final LocationService _locationService = LocationService();
  final GeocodingService _geocodingService = GeocodingService();
  
  Position? _currentPosition;
  String? _currentAddress;
  bool _isLoading = false;

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoading = true);

    final position = await _locationService.getCurrentPosition();
    
    if (position != null) {
      final address = await _geocodingService.getAddressFromCoordinates(
        position.latitude,
        position.longitude,
      );

      setState(() {
        _currentPosition = position;
        _currentAddress = address;
      });
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('موقعي')),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_currentPosition != null) ...[
                    Text('خط العرض: ${_currentPosition!.latitude}'),
                    Text('خط الطول: ${_currentPosition!.longitude}'),
                    if (_currentAddress != null)
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(_currentAddress!),
                      ),
                  ],
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _getCurrentLocation,
                    child: const Text('احصل على موقعي'),
                  ),
                ],
              ),
      ),
    );
  }
}
```

---

## 🗺️ Google Maps

### التثبيت

```yaml
dependencies:
  google_maps_flutter: ^2.5.0
```

---

### إعداد API Key

**Android** (`android/app/src/main/AndroidManifest.xml`):

```xml
<application>
    <meta-data
        android:name="com.google.android.geo.API_KEY"
        android:value="YOUR_API_KEY_HERE"/>
</application>
```

**iOS** (`ios/Runner/AppDelegate.swift`):

```swift
import GoogleMaps

GMSServices.provideAPIKey("YOUR_API_KEY_HERE")
```

---

### عرض الخريطة

```dart
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _mapController;
  final Set<Marker> _markers = {};
  
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(24.7136, 46.6753), // Riyadh
    zoom: 12,
  );

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _addMarker(LatLng position) {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId(position.toString()),
          position: position,
          infoWindow: const InfoWindow(
            title: 'موقع مختار',
            snippet: 'اضغط للمزيد',
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الخريطة')),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: _initialPosition,
        markers: _markers,
        onTap: _addMarker,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        mapType: MapType.normal,
        zoomControlsEnabled: false,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final position = await LocationService().getCurrentPosition();
          if (position != null) {
            _mapController.animateCamera(
              CameraUpdate.newLatLng(
                LatLng(position.latitude, position.longitude),
              ),
            );
          }
        },
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
```

---

### إضافة Polyline (خطوط)

```dart
class MapWithRouteScreen extends StatefulWidget {
  const MapWithRouteScreen({super.key});

  @override
  State<MapWithRouteScreen> createState() => _MapWithRouteScreenState();
}

class _MapWithRouteScreenState extends State<MapWithRouteScreen> {
  final Set<Polyline> _polylines = {};
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _createRoute();
  }

  void _createRoute() {
    final List<LatLng> points = [
      const LatLng(24.7136, 46.6753),
      const LatLng(24.7246, 46.6853),
      const LatLng(24.7356, 46.6953),
    ];

    setState(() {
      // Add polyline
      _polylines.add(
        Polyline(
          polylineId: const PolylineId('route'),
          points: points,
          color: Colors.blue,
          width: 5,
        ),
      );

      // Add markers for start and end
      _markers.addAll([
        Marker(
          markerId: const MarkerId('start'),
          position: points.first,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
          infoWindow: const InfoWindow(title: 'البداية'),
        ),
        Marker(
          markerId: const MarkerId('end'),
          position: points.last,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueRed,
          ),
          infoWindow: const InfoWindow(title: 'النهاية'),
        ),
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('المسار')),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(24.7136, 46.6753),
          zoom: 13,
        ),
        markers: _markers,
        polylines: _polylines,
      ),
    );
  }
}
```

---

## 💼 أمثلة عملية

### تطبيق البحث عن الأماكن القريبة

```dart
class Place {
  final String name;
  final LatLng location;
  final String category;

  Place({
    required this.name,
    required this.location,
    required this.category,
  });
}

class NearbyPlacesScreen extends StatefulWidget {
  const NearbyPlacesScreen({super.key});

  @override
  State<NearbyPlacesScreen> createState() => _NearbyPlacesScreenState();
}

class _NearbyPlacesScreenState extends State<NearbyPlacesScreen> {
  final LocationService _locationService = LocationService();
  Position? _currentPosition;
  final Set<Marker> _markers = {};

  final List<Place> _places = [
    Place(
      name: 'مطعم 1',
      location: const LatLng(24.7146, 46.6763),
      category: 'مطعم',
    ),
    Place(
      name: 'مقهى 1',
      location: const LatLng(24.7156, 46.6773),
      category: 'مقهى',
    ),
    Place(
      name: 'متجر 1',
      location: const LatLng(24.7166, 46.6783),
      category: 'متجر',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadCurrentLocation();
  }

  Future<void> _loadCurrentLocation() async {
    final position = await _locationService.getCurrentPosition();
    if (position != null) {
      setState(() {
        _currentPosition = position;
        _createMarkers();
      });
    }
  }

  void _createMarkers() {
    if (_currentPosition == null) return;

    // Current location marker
    _markers.add(
      Marker(
        markerId: const MarkerId('current'),
        position: LatLng(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueBlue,
        ),
        infoWindow: const InfoWindow(title: 'موقعي'),
      ),
    );

    // Place markers
    for (var place in _places) {
      final distance = _locationService.calculateDistance(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
        place.location.latitude,
        place.location.longitude,
      );

      _markers.add(
        Marker(
          markerId: MarkerId(place.name),
          position: place.location,
          infoWindow: InfoWindow(
            title: place.name,
            snippet: '${(distance / 1000).toStringAsFixed(1)} كم',
          ),
        ),
      );
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_currentPosition == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('الأماكن القريبة')),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  _currentPosition!.latitude,
                  _currentPosition!.longitude,
                ),
                zoom: 14,
              ),
              markers: _markers,
              myLocationEnabled: true,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _places.length,
              itemBuilder: (context, index) {
                final place = _places[index];
                final distance = _locationService.calculateDistance(
                  _currentPosition!.latitude,
                  _currentPosition!.longitude,
                  place.location.latitude,
                  place.location.longitude,
                );

                return ListTile(
                  leading: const Icon(Icons.place),
                  title: Text(place.name),
                  subtitle: Text(place.category),
                  trailing: Text(
                    '${(distance / 1000).toStringAsFixed(1)} كم',
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
```

---

### تتبع الموقع المباشر

```dart
class LiveTrackingScreen extends StatefulWidget {
  const LiveTrackingScreen({super.key});

  @override
  State<LiveTrackingScreen> createState() => _LiveTrackingScreenState();
}

class _LiveTrackingScreenState extends State<LiveTrackingScreen> {
  final LocationService _locationService = LocationService();
  GoogleMapController? _mapController;
  final List<LatLng> _pathPoints = [];
  final Set<Polyline> _polylines = {};
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _startTracking();
  }

  void _startTracking() {
    _locationService.getPositionStream().listen((position) {
      final newPoint = LatLng(position.latitude, position.longitude);

      setState(() {
        _currentPosition = position;
        _pathPoints.add(newPoint);

        _polylines.clear();
        _polylines.add(
          Polyline(
            polylineId: const PolylineId('path'),
            points: _pathPoints,
            color: Colors.blue,
            width: 5,
          ),
        );
      });

      _mapController?.animateCamera(
        CameraUpdate.newLatLng(newPoint),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تتبع مباشر'),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              setState(() {
                _pathPoints.clear();
                _polylines.clear();
              });
            },
          ),
        ],
      ),
      body: _currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              onMapCreated: (controller) => _mapController = controller,
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  _currentPosition!.latitude,
                  _currentPosition!.longitude,
                ),
                zoom: 16,
              ),
              polylines: _polylines,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),
    );
  }
}
```

---

## 📚 المراجع والمصادر

1. **Packages**
   - [geolocator](https://pub.dev/packages/geolocator)
   - [geocoding](https://pub.dev/packages/geocoding)
   - [google_maps_flutter](https://pub.dev/packages/google_maps_flutter)

2. **Documentation**
   - [Google Maps Platform](https://developers.google.com/maps)
   - [Flutter Location](https://flutter.dev/docs/cookbook/plugins)

---

## 💡 نصائح

- ✅ اطلب الأذونات قبل الوصول للموقع
- ✅ استخدم `desiredAccuracy` المناسب لتوفير البطارية
- ✅ عالج حالة رفض الأذونات
- ✅ استخدم `distanceFilter` لتقليل التحديثات
- ✅ احصل على Google Maps API Key
- ✅ dispose الـ controllers

---

[⬅️ السابق: الملفات والوسائط](34_files_media.md)
[🏠 العودة للفهرس](../README.md)
[التالي: الإشعارات ➡️](36_notifications.md)
