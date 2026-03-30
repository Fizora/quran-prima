import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart' as geocoding;

class LocationService {
  static const double defaultLatitude = -6.1751; // Jakarta
  static const double defaultLongitude = 106.8650;

  // Request location permission (Dinonaktifkan agar tidak muncul otomatis)
  static Future<bool> requestLocationPermission() async {
    return false;
  }

  // Get current user location
  static Future<Map<String, double>> getCurrentLocation() async {
    try {
      bool hasPermission = await requestLocationPermission();
      if (!hasPermission) {
        return {'latitude': defaultLatitude, 'longitude': defaultLongitude};
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      return {'latitude': position.latitude, 'longitude': position.longitude};
    } catch (e) {
      print('Error getting current location: $e');
      return {'latitude': defaultLatitude, 'longitude': defaultLongitude};
    }
  }

  // Calculate timezone offset from longitude
  // Indonesia: WIB (UTC+7), WITA (UTC+8), WIT (UTC+9)
  static int calculateTimezoneOffset(double longitude) {
    // Longitude reference points for each timezone:
    // WIB: 95°E - 141°E (roughly)
    // WITA: 141°E - 155°E (roughly, but Indonesia uses 120°E - 149°E)
    // WIT: 149°E onwards

    // More accurate for Indonesia:
    // WIB (UTC+7): Sumatra to Java (roughly 95°E - 105°E)
    // WITA (UTC+8): Kalimantan to Sulawesi (roughly 105°E - 132°E)
    // WIT (UTC+9): Papua and beyond (132°E and east)

    if (longitude < 105) {
      return 0; // WIB (UTC+7)
    } else if (longitude < 132) {
      return 1; // WITA (UTC+8)
    } else {
      return 2; // WIT (UTC+9)
    }
  }

  // Get timezone string from offset
  static String getTimezoneString(int offset) {
    switch (offset) {
      case 1:
        return 'WITA';
      case 2:
        return 'WIT';
      default:
        return 'WIB';
    }
  }

  // Get place name from coordinates
  static Future<String> getPlaceName(double latitude, double longitude) async {
    try {
      List<geocoding.Placemark> placemarks = await geocoding
          .placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isNotEmpty) {
        geocoding.Placemark place = placemarks.first;
        return '${place.locality}, ${place.administrativeArea}';
      }
      return 'Unknown Location';
    } catch (e) {
      print('Error getting place name: $e');
      return 'Unknown Location';
    }
  }
}
