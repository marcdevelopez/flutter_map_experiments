import 'package:geolocator/geolocator.dart';

class LocationService {
  static Future<Position> getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location service are disabled');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Lopcation permissions are permanently denied.');
    }

    final settings = LocationSettings(accuracy: LocationAccuracy.high);
    return await Geolocator.getCurrentPosition(locationSettings: settings);
  }

  // Stream para seguimiento en tiempo real
  static Stream<Position> getPositionStream() {
    final settings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 5, // Solo emite cuando se mueve > 5m
    );
    return Geolocator.getPositionStream(locationSettings: settings);
  }
}
