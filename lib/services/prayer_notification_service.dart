import 'package:shared_preferences/shared_preferences.dart';
import 'jadwal_sholat_service.dart';

class PrayerNotificationService {
  static const String _prefixKey = 'prayer_notification_';
  static const Map<String, String> prayerNames = {
    'fajr': 'Subuh',
    'dhuhr': 'Dhuhur',
    'asr': 'Ashar',
    'maghrib': 'Maghrib',
    'isha': 'Isya',
  };

  // Enable/disable notifikasi untuk prayer tertentu
  static Future<void> setPrayerNotificationEnabled(
    String prayer,
    bool enabled,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('${_prefixKey}${prayer}_enabled', enabled);
  }

  // Check apakah notifikasi prayer diaktifkan
  static Future<bool> isPrayerNotificationEnabled(String prayer) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('${_prefixKey}${prayer}_enabled') ?? true;
  }

  // Enable/disable semua notifikasi sholat
  static Future<void> setAllNotificationsEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    for (String prayer in prayerNames.keys) {
      await prefs.setBool('${_prefixKey}${prayer}_enabled', enabled);
    }
  }

  // Check apakah ada notifikasi yang diaktifkan
  static Future<bool> hasAnyNotificationEnabled() async {
    for (String prayer in prayerNames.keys) {
      final enabled = await isPrayerNotificationEnabled(prayer);
      if (enabled) return true;
    }
    return false;
  }

  // Get waktu notifikasi sebelum adzan (dalam menit)
  static Future<int> getNotificationAdvanceTime() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('${_prefixKey}advance_time_minutes') ?? 5;
  }

  // Set waktu notifikasi sebelum adzan (dalam menit)
  static Future<void> setNotificationAdvanceTime(int minutes) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('${_prefixKey}advance_time_minutes', minutes);
  }

  // Calculate next prayer time dalam UTC
  static Future<DateTime?> getNextPrayerTimeUTC({
    required double latitude,
    required double longitude,
  }) async {
    final now = DateTime.now().toUtc();

    try {
      final jadwalService = JadwalSholatService();
      final jadwal = await jadwalService.getJadwalSholat(
        latitude: latitude,
        longitude: longitude,
      );

      if (jadwal == null) return null;

      // Parse jadwal times
      final prayerTimes = {
        'fajr': _parseTimeToUTC(jadwal['fajr'] ?? ''),
        'dhuhr': _parseTimeToUTC(jadwal['dhuhr'] ?? ''),
        'asr': _parseTimeToUTC(jadwal['asr'] ?? ''),
        'maghrib': _parseTimeToUTC(jadwal['maghrib'] ?? ''),
        'isha': _parseTimeToUTC(jadwal['isha'] ?? ''),
      };

      // Find next enabled prayer
      DateTime? nextPrayerTime;
      for (String prayer in prayerNames.keys) {
        final prayerTime = prayerTimes[prayer];
        if (prayerTime != null && prayerTime.isAfter(now)) {
          final enabled = await isPrayerNotificationEnabled(prayer);
          if (enabled) {
            if (nextPrayerTime == null || prayerTime.isBefore(nextPrayerTime)) {
              nextPrayerTime = prayerTime;
            }
          }
        }
      }

      return nextPrayerTime;
    } catch (e) {
      print('Error calculating next prayer time: $e');
      return null;
    }
  }

  static DateTime _parseTimeToUTC(String timeString) {
    try {
      if (timeString.isEmpty) {
        return DateTime.now().toUtc();
      }

      final parts = timeString.split(':');
      if (parts.length < 2) {
        return DateTime.now().toUtc();
      }

      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);

      final now = DateTime.now();
      return DateTime.utc(now.year, now.month, now.day, hour, minute).toUtc();
    } catch (e) {
      return DateTime.now().toUtc();
    }
  }
}
