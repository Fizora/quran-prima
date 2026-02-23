import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

class FontThemeService {
  static const String _keyFontTheme = 'font_theme';

  static const String fontDefault = 'default'; // System default
  static const String fontRoboto = 'roboto';
  static const String fontOpenSans = 'opensans';
  static const String fontLato = 'lato';
  static const String fontPoppins = 'poppins';

  static const List<String> availableFonts = [
    fontDefault,
    fontRoboto,
    fontOpenSans,
    fontLato,
    fontPoppins,
  ];

  static const Map<String, String> fontNames = {
    fontDefault: 'Default',
    fontRoboto: 'Roboto',
    fontOpenSans: 'Open Sans',
    fontLato: 'Lato',
    fontPoppins: 'Poppins',
  };

  static Future<String> getSelectedFont() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyFontTheme) ?? fontDefault;
  }

  static Future<void> setSelectedFont(String font) async {
    if (!availableFonts.contains(font)) {
      throw Exception('Invalid font: $font');
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyFontTheme, font);
  }

  static TextTheme getTextTheme(String fontName) {
    switch (fontName) {
      case fontRoboto:
        return GoogleFonts.robotoTextTheme();
      case fontOpenSans:
        return GoogleFonts.openSansTextTheme();
      case fontLato:
        return GoogleFonts.latoTextTheme();
      case fontPoppins:
        return GoogleFonts.poppinsTextTheme();
      case fontDefault:
      default:
        return GoogleFonts.notoNaskhArabicTextTheme();
    }
  }

  static String getFontFamily(String fontName) {
    switch (fontName) {
      case fontRoboto:
        return GoogleFonts.roboto().fontFamily ?? 'Roboto';
      case fontOpenSans:
        return GoogleFonts.openSans().fontFamily ?? 'Open Sans';
      case fontLato:
        return GoogleFonts.lato().fontFamily ?? 'Lato';
      case fontPoppins:
        return GoogleFonts.poppins().fontFamily ?? 'Poppins';
      case fontDefault:
      default:
        return 'NotoNaskhArabic';
    }
  }
}
