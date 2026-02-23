import 'package:shared_preferences/shared_preferences.dart';

class FontSizeService {
  static const String _keyAyatFontSize = 'ayat_font_size';
  static const String _keyNormalFontSize = 'normal_font_size';

  // Default values
  static const double defaultAyatFontSize = 20.0;
  static const double defaultNormalFontSize = 16.0;
  static const double minFontSize = 12.0;
  static const double maxFontSize = 32.0;

  static Future<double> getAyatFontSize() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_keyAyatFontSize) ?? defaultAyatFontSize;
  }

  static Future<double> getNormalFontSize() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_keyNormalFontSize) ?? defaultNormalFontSize;
  }

  static Future<void> setAyatFontSize(double size) async {
    if (size < minFontSize || size > maxFontSize) {
      throw Exception(
        'Font size must be between $minFontSize and $maxFontSize',
      );
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_keyAyatFontSize, size);
  }

  static Future<void> setNormalFontSize(double size) async {
    if (size < minFontSize || size > maxFontSize) {
      throw Exception(
        'Font size must be between $minFontSize and $maxFontSize',
      );
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_keyNormalFontSize, size);
  }

  static Future<void> resetToDefaults() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyAyatFontSize);
    await prefs.remove(_keyNormalFontSize);
  }
}
