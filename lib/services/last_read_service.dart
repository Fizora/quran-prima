// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert';

// class LastReadService {
//   static const String import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert';

// class LastReadService {
//   static const String _lastReadKey = 'last_read';

//   static Future<void> saveLastRead({
//     required int surahNumber,
//     required String surahName,
//   }) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final data = {
//         'surahNumber': surahNumber,
//         'surahName': surahName,
//         'timestamp': DateTime.now().millisecondsSinceEpoch,
//       };
//       await prefs.setString(_lastReadKey, jsonEncode(data));
//     } catch (e) {
//       // Untuk sementara gunakan print, bisa diganti dengan logging framework nanti
//       print('Error saving last read: $e');
//     }
//   }

//   static Future<Map<String, dynamic>?> getLastRead() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final data = prefs.getString(_lastReadKey);
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

//   static Future<void> saveLastRead({
//     required int surahNumber,
//     required String surahName,
//   }) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final data = {
//         'surahNumber': surahNumber,
//         'surahName': surahName,
//         'timestamp': DateTime.now().millisecondsSinceEpoch,
//       };
//       await prefs.setString(_lastReadKey, jsonEncode(data));
//     } catch (e) {
//       print('Error saving last read: $e');
//     }
//   }

//   static Future<Map<String, dynamic>?> getLastRead() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final data = prefs.getString(_lastReadKey);
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
