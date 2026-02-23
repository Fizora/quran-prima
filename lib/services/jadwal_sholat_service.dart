import 'package:http/http.dart' as http;
import 'dart:convert';

class JadwalSholatService {
  // Using Aladhan API (public, no key required)
  static const String _baseUrl = 'https://api.aladhan.com/v1';

  /// Get jadwal sholat untuk koordinat tertentu
  /// latitude, longitude: koordinat lokasi
  /// Mengembalikan map dengan waktu sholat (Fajr, Dhuhr, Asr, Maghrib, Isha)
  Future<Map<String, String>?> getJadwalSholat({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final today = DateTime.now();
      final dateString =
          '${today.day}-${today.month}-${today.year}'; // DD-MM-YYYY format

      final url =
          '$_baseUrl/timings/$dateString?latitude=$latitude&longitude=$longitude&method=2'; // Method 2 = ISNA

      final response = await http.get(Uri.parse(url)).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('Request timeout'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final timings = data['data']['timings'] as Map<String, dynamic>;

        // Extract only prayer times
        return {
          'fajr': timings['Fajr'] ?? '',
          'dhuhr': timings['Dhuhr'] ?? '',
          'asr': timings['Asr'] ?? '',
          'maghrib': timings['Maghrib'] ?? '',
          'isha': timings['Isha'] ?? '',
          'imsak': timings['Imsak'] ?? '',
        };
      } else {
        throw Exception('Failed to fetch jadwal sholat');
      }
    } catch (e) {
      print('Error fetching jadwal sholat: $e');
      return null;
    }
  }

  /// Get jadwal sholat berdasarkan kota/daerah
  /// city: nama kota, country: nama negara
  Future<Map<String, String>?> getJadwalSholatByCity({
    required String city,
    required String country,
  }) async {
    try {
      final today = DateTime.now();
      final dateString = '${today.day}-${today.month}-${today.year}';

      final url =
          '$_baseUrl/timingsByCity/$dateString?city=$city&country=$country&method=2';

      final response = await http.get(Uri.parse(url)).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('Request timeout'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final timings = data['data']['timings'] as Map<String, dynamic>;

        return {
          'fajr': timings['Fajr'] ?? '',
          'dhuhr': timings['Dhuhr'] ?? '',
          'asr': timings['Asr'] ?? '',
          'maghrib': timings['Maghrib'] ?? '',
          'isha': timings['Isha'] ?? '',
          'imsak': timings['Imsak'] ?? '',
        };
      } else {
        throw Exception('Failed to fetch jadwal sholat');
      }
    } catch (e) {
      print('Error fetching jadwal sholat by city: $e');
      return null;
    }
  }

  /// Get next prayer based on current time
  /// Returns {name, time} or null if all prayers passed
  Future<Map<String, String>?> getNextPrayer({
    required double latitude,
    required double longitude,
  }) async {
    final jadwal = await getJadwalSholat(
      latitude: latitude,
      longitude: longitude,
    );

    if (jadwal == null) return null;

    final now = DateTime.now();
    final prayerOrder = ['fajr', 'dhuhr', 'asr', 'maghrib', 'isha'];
    final prayerNames = {
      'fajr': 'Subuh',
      'dhuhr': 'Dhuhur',
      'asr': 'Ashar',
      'maghrib': 'Maghrib',
      'isha': 'Isya',
    };

    for (String prayer in prayerOrder) {
      final timeStr = jadwal[prayer];
      if (timeStr != null && timeStr.isNotEmpty) {
        final parts = timeStr.split(':');
        final hour = int.parse(parts[0]);
        final minute = int.parse(parts[1]);

        final prayerTime = DateTime(now.year, now.month, now.day, hour, minute);

        if (prayerTime.isAfter(now)) {
          return {
            'name': prayerNames[prayer] ?? prayer,
            'time': timeStr,
            'prayer': prayer,
          };
        }
      }
    }

    return null;
  }
}
