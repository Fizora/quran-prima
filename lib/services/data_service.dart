import 'dart:convert';
import 'package:flutter/services.dart';

class DataService {
  static Future<List<dynamic>> loadSurahList() async {
    try {
      final String response = await rootBundle.loadString(
        'assets/data/surah/surah_list.json',
      );
      final data = json.decode(response);
      return List<dynamic>.from(data);
    } catch (e) {
      print("Error loading surah list: $e");
      // Fallback data jika file tidak ditemukan
      return [
        {
          "nomor": 1,
          "nama": "Al-Fatihah",
          "ayat": 7,
          "arabic": "الفاتحة",
          "type": "Makkiyah",
        },
        {
          "nomor": 2,
          "nama": "Al-Baqarah",
          "ayat": 286,
          "arabic": "البقرة",
          "type": "Madaniyah",
        },
        {
          "nomor": 3,
          "nama": "Ali 'Imran",
          "ayat": 200,
          "arabic": "آل عمران",
          "type": "Madaniyah",
        },
      ];
    }
  }

  Future<Map<String, dynamic>> loadSurahData(int surahNumber) async {
    try {
      final String filePath = 'assets/data/surah/$surahNumber.json'; // Hapus underscore
      final String response = await rootBundle.loadString(filePath);
      final data = json.decode(response);
      return Map<String, dynamic>.from(data);
    } catch (e) {
      print("Error loading surah $surahNumber: $e");
      throw Exception("Failed to load surah data");
    }
  }
}
