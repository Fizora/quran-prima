import 'dart:convert';
import 'package:flutter/services.dart';

class DataService {
  static Future<List<dynamic>> loadSurahList() async {
    try {
      final String response = await rootBundle.loadString(
        'assets/data/surah_list.json',
      );
      final data = json.decode(response);
      print("✅ Surah list loaded: ${data.length} items");
      return List<dynamic>.from(data);
    } catch (e) {
      print("❌ Error loading surah list: $e");
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

   static Future<List<dynamic>> loadAyatList(int surahNumber) async {
    // Contoh data dummy - ganti dengan data real dari API atau local
    await Future.delayed(const Duration(milliseconds: 500));

    List<Map<String, dynamic>> dummyAyat = [];

    for (int i = 1; i <= 10; i++) {
      dummyAyat.add({
        'nomor': i,
        'arabic': 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
        'latin': 'Bismillāhir raḥmānir raḥīm',
        'translation': 'Dengan nama Allah Yang Maha Pengasih, Maha Penyayang.',
      });
    }

    return dummyAyat;
  }

  Future<Map<String, dynamic>> loadSurahData(int surahNumber) async {
    try {
      // PERBAIKAN: Gunakan path yang benar tanpa 'surah_' prefix
      final String filePath = 'assets/data/surah/$surahNumber.json';
      print("📁 Loading file: $filePath");
      final String response = await rootBundle.loadString(filePath);
      final data = json.decode(response);
      print("✅ Surah $surahNumber loaded successfully");
      return Map<String, dynamic>.from(data);
    } catch (e) {
      print("❌ Error loading surah $surahNumber: $e");
      // Fallback data untuk testing
      return {
        "nomor": surahNumber,
        "nama": "Surah $surahNumber",
        "nama_latin": "Surah $surahNumber",
        "jumlah_ayat": 0,
        "tempat_turun": "Unknown",
        "arti": "Artinya",
        "ayat": [
          {
            "nomor": 1,
            "arab": "بِسْمِ اللّٰهِ الرَّحْمٰنِ الرَّحِيْمِ",
            "latin": "Bismillāhir-raḥmānir-raḥīm",
            "arti": "Dengan nama Allah Yang Maha Pengasih, Maha Penyayang."
          }
        ]
      };
    }
  }
}
