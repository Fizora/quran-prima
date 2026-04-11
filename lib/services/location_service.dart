class LocationService {
  static const double defaultLatitude = -6.1751; // Jakarta
  static const double defaultLongitude = 106.8650;

  // Request location permission (Dinonaktifkan agar tidak muncul otomatis)
  static Future<bool> requestLocationPermission() async {
    return false;
  }

  // Get current user location
  static Future<Map<String, double>> getCurrentLocation() async {
    // Return default location instead of asking for device location
    return {'latitude': defaultLatitude, 'longitude': defaultLongitude};
  }

  // Calculate timezone offset from longitude
  static int calculateTimezoneOffset(double longitude) {
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
    // Since we're not using geocoding anymore, return default or "Jakarta"
    if (latitude == defaultLatitude && longitude == defaultLongitude) {
      return 'Jakarta';
    }
    return 'Indonesia';
  }
}

