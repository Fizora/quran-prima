// services/audio_service.dart
import 'package:shared_preferences/shared_preferences.dart';

class AudioService {
  static const String _prefKey = 'selected_alarm_sound';

  static Future<String> getSelectedAlarmSound() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_prefKey) ?? 'default';
  }

  static Future<void> setSelectedAlarmSound(String soundKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKey, soundKey);
  }
}
