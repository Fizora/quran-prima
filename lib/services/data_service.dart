import 'dart:convert';
import 'package:flutter/services.dart';

class DataService {
  static Future<List<dynamic>> loadSurahList() async {
    try {
      final String response = await rootBundle.loadString(
        'assets/data/surah_list.json',
      );
      final data = json.decode(response);
      return List<dynamic>.from(data);
    } catch (e) {
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

  static Future<List<dynamic>> loadJuzList() async {
    try {
      final String response = await rootBundle.loadString(
        'assets/data/juz_list.json',
      );
      final data = json.decode(response);
      return List<dynamic>.from(data);
    } catch (e) {
      // Fallback data untuk juz
      return List.generate(
        30,
        (index) => {
          "juz": index + 1,
          "description": "Juz ${index + 1} Al-Quran",
        },
      );
    }
  }

  static Future<Map<String, dynamic>> loadSurahData(int surahNumber) async {
    try {
      final String response = await rootBundle.loadString(
        'assets/data/surah/$surahNumber.json',
      );
      return json.decode(response);
    } catch (e) {
      // Fallback data jika file tidak ditemukan
      return {
        "nomor": surahNumber,
        "nama": "Surah $surahNumber",
        "nama_latin": "Surah $surahNumber",
        "jumlah_ayat": 7,
        "tempat_turun": "Mekah",
        "arti": "Arti Surah",
        "deskripsi": "Deskripsi surah...",
        "ayat": [
          {
            "nomor": 1,
            "arab": "بِسْمِ اللّٰهِ الرَّحْمٰنِ الرَّحِيْمِ",
            "latin": "Bismillāhir-raḥmānir-raḥīm",
            "arti": "Dengan nama Allah Yang Maha Pengasih, Maha Penyayang.",
          },
        ],
      };
    }
  }
}
