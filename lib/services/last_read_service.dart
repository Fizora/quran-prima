import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LastReadService {
  static const String _lastReadKey = 'last_read';

  // Model untuk last read
  static Future<void> saveLastRead({
    required int surahNumber,
    required String surahName,
    required int ayahNumber,
    required String ayahText,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = {
        'surahNumber': surahNumber,
        'surahName': surahName,
        'ayahNumber': ayahNumber,
        'ayahText': ayahText,
        'timestamp': DateTime.now().toIso8601String(),
        'timestampMs': DateTime.now().millisecondsSinceEpoch,
      };
      await prefs.setString(_lastReadKey, jsonEncode(data));
      print('Last read saved: Surah $surahName, Ayah $ayahNumber');
    } catch (e) {
      print('Error saving last read: $e');
    }
  }

  // Get last read data
  static Future<Map<String, dynamic>?> getLastRead() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString(_lastReadKey);
      if (data != null && data.isNotEmpty) {
        return jsonDecode(data);
      }
      return null;
    } catch (e) {
      print('Error getting last read: $e');
      return null;
    }
  }

  // Clear last read data
  static Future<void> clearLastRead() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_lastReadKey);
      print('Last read cleared');
    } catch (e) {
      print('Error clearing last read: $e');
    } 
  }

  // Get formatted last read info
  static Future<String> getLastReadInfo() async {
    final lastRead = await getLastRead();
    if (lastRead == null) {
      return 'Belum ada data terakhir baca';
    }

    final surahName = lastRead['surahName'] ?? 'Unknown';
    final ayahNumber = lastRead['ayahNumber'] ?? 0;
    final timestamp = lastRead['timestamp'] ?? '';

    // Format timestamp
    String formattedTime = '';
    try {
      final dateTime = DateTime.parse(timestamp);
      formattedTime =
          '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      formattedTime = timestamp;
    }

    return 'Surah $surahName - Ayah $ayahNumber\n($formattedTime)';
  }
}

//       if (data != null && data.isNotEmpty) {
//         return jsonDecode(data);
//       }
//       return null;
//     } catch (e) {
//       print('Error getting last read: $e');
//       return null;
//     }
//   }

//   static Future<void> clearLastRead() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.remove(_lastReadKey);
//     } catch (e) {
//       print('Error clearing last read: $e');
//     }
//   }

//   static Future<bool> hasLastRead() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       return prefs.containsKey(_lastReadKey);
//     } catch (e) {
//       print('Error checking last read: $e');
//       return false;
//     }
//   }
// }
