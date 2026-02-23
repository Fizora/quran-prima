import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class DataService {
  // Load surah list dari surah_list.json
  static Future<List<Map<String, dynamic>>> loadSurahList() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/data/surah_list.json',
      );
      final List<dynamic> data = json.decode(jsonString);

      return data.map((surah) {
        return {
          'nomor': surah['nomor'],
          'nama': surah['nama_latin'] ?? surah['nama'],
          'nama_latin': surah['nama_latin'] ?? surah['nama'],
          'ayat': surah['jumlah_ayat'] ?? surah['ayat'] ?? 0,
          'arabic': surah['arabic'] ?? surah['nama'],
          'type': surah['tempat_turun'] ?? surah['type'] ?? 'Makkiyah',
          'arti':
              surah['arti'] ??
              _getArtiFromNama(surah['nama_latin'] ?? surah['nama']),
        };
      }).toList();
    } catch (e) {
      print('❌ Error loading surah list from JSON: $e');
      return [];
    }
  }

  // Helper untuk mendapatkan arti dari nama surah
  static String _getArtiFromNama(String namaLatin) {
    final Map<String, String> artiMap = {
      'Al-Fatihah': 'Pembukaan',
      'Al-Baqarah': 'Sapi Betina',
      'Ali \'Imran': 'Keluarga Imran',
      'An-Nisa': 'Wanita',
      'Al-Ma\'idah': 'Hidangan',
      'Al-An\'am': 'Binatang Ternak',
      'Al-A\'raf': 'Tempat Tertinggi',
      'Al-Anfal': 'Rampasan Perang',
      'At-Taubah': 'Pengampunan',
      'Yunus': 'Yunus',
      'Hud': 'Hud',
      'Yusuf': 'Yusuf',
      'Ar-Ra\'d': 'Guruh',
      'Ibrahim': 'Ibrahim',
      'Al-Hijr': 'Batu',
      'An-Nahl': 'Lebah',
      'Al-Isra': 'Perjalanan Malam',
      'Al-Kahf': 'Gua',
      'Maryam': 'Maryam',
      'Taha': 'Taha',
      'Al-Anbiya': 'Para Nabi',
      'Al-Hajj': 'Haji',
      'Al-Mu\'minun': 'Orang-Orang Mukmin',
      'An-Nur': 'Cahaya',
      'Al-Furqan': 'Pembeda',
      'Asy-Syu\'ara': 'Penyair',
      'An-Naml': 'Semut',
      'Al-Qasas': 'Kisah-Kisah',
      'Al-\'Ankabut': 'Laba-Laba',
      'Ar-Rum': 'Romawi',
      'Luqman': 'Luqman',
      'As-Sajdah': 'Sujud',
      'Al-Ahzab': 'Golongan yang Bersekutu',
      'Saba': 'Saba\'',
      'Fatir': 'Pencipta',
      'Yasin': 'Yasin',
      'As-Saffat': 'Barisan',
      'Sad': 'Shad',
      'Az-Zumar': 'Rombongan',
      'Ghafir': 'Yang Mengampuni',
      'Fussilat': 'Yang Dijelaskan',
      'Asy-Syura': 'Musyawarah',
      'Az-Zukhruf': 'Perhiasan',
      'Ad-Dukhan': 'Kabut',
      'Al-Jasiyah': 'Yang Berlutut',
      'Al-Ahqaf': 'Bukit-Bukit Pasir',
      'Muhammad': 'Muhammad',
      'Al-Fath': 'Kemenangan',
      'Al-Hujurat': 'Kamar-Kamar',
      'Qaf': 'Qaf',
      'Az-Zariyat': 'Angin yang Menerbangkan',
      'At-Tur': 'Bukit',
      'An-Najm': 'Bintang',
      'Al-Qamar': 'Bulan',
      'Ar-Rahman': 'Yang Maha Pengasih',
      'Al-Waqi\'ah': 'Hari Kiamat',
      'Al-Hadid': 'Besi',
      'Al-Mujadalah': 'Wanita yang Mengajukan Gugatan',
      'Al-Hasyr': 'Pengusiran',
      'Al-Mumtahanah': 'Wanita yang Diuji',
      'As-Saff': 'Barisan',
      'Al-Jumu\'ah': 'Hari Jum\'at',
      'Al-Munafiqun': 'Orang-Orang Munafik',
      'At-Tagabun': 'Hari Ditampakkan Kesalahan',
      'At-Talaq': 'Talak',
      'At-Tahrim': 'Pengharaman',
      'Al-Mulk': 'Kerajaan',
      'Al-Qalam': 'Pena',
      'Al-Haqqah': 'Hari Kiamat',
      'Al-Ma\'arij': 'Tempat Naik',
      'Nuh': 'Nuh',
      'Al-Jinn': 'Jin',
      'Al-Muzzammil': 'Orang yang Berselimut',
      'Al-Muddassir': 'Orang yang Berkemul',
      'Al-Qiyamah': 'Hari Kiamat',
      'Al-Insan': 'Manusia',
      'Al-Mursalat': 'Malaikat yang Diutus',
      'An-Naba': 'Berita Besar',
      'An-Nazi\'at': 'Malaikat yang Mencabut',
      '\'Abasa': 'Ia Bermuka Masam',
      'At-Takwir': 'Penggulungan',
      'Al-Infitar': 'Terbelah',
      'Al-Mutaffifin': 'Orang-Orang yang Curang',
      'Al-Insyiqaq': 'Terbelah',
      'Al-Buruj': 'Gugusan Bintang',
      'At-Tariq': 'Yang Datang di Malam Hari',
      'Al-A\'la': 'Yang Paling Tinggi',
      'Al-Gasyiyah': 'Hari Pembalasan',
      'Al-Fajr': 'Fajar',
      'Al-Balad': 'Negeri',
      'Asy-Syams': 'Matahari',
      'Al-Lail': 'Malam',
      'Ad-Duha': 'Waktu Dhuha',
      'Al-Insyirah': 'Kelapangan',
      'At-Tin': 'Buah Tin',
      'Al-\'Alaq': 'Segumpal Darah',
      'Al-Qadr': 'Kemuliaan',
      'Al-Bayyinah': 'Bukti Nyata',
      'Az-Zalzalah': 'Kegoncangan',
      'Al-\'Adiyat': 'Kuda Perang',
      'Al-Qari\'ah': 'Hari Kiamat',
      'At-Takasur': 'Bermegah-megahan',
      'Al-Asr': 'Masa',
      'Al-Humazah': 'Pengumpat',
      'Al-Fil': 'Gajah',
      'Quraisy': 'Quraisy',
      'Al-Ma\'un': 'Barang yang Berguna',
      'Al-Kausar': 'Nikmat yang Banyak',
      'Al-Kafirun': 'Orang-Orang Kafir',
      'An-Nasr': 'Pertolongan',
      'Al-Lahab': 'Gejolak Api',
      'Al-Ikhlas': 'Ikhlas',
      'Al-Falaq': 'Waktu Subuh',
      'An-Nas': 'Manusia',
    };

    return artiMap[namaLatin] ?? namaLatin;
  }

  // Load surah data dari asset JSON
  Future<Map<String, dynamic>> loadSurahData(int surahNumber) async {
    try {
      print("🔄 Loading surah $surahNumber from assets...");

      // Load dari asset file
      final String jsonString = await rootBundle.loadString(
        'assets/data/surah/$surahNumber.json',
      );
      final Map<String, dynamic> surahData = json.decode(jsonString);

      print("✅ Surah $surahNumber loaded successfully from assets");

      // Format data sesuai kebutuhan AyatPage
      return {
        'nomor': surahData['nomor'] ?? surahNumber,
        'nama': surahData['nama'] ?? 'Surah $surahNumber',
        'nama_latin':
            surahData['nama_latin'] ??
            surahData['nama'] ??
            'Surah $surahNumber',
        'jumlah_ayat': surahData['jumlah_ayat'] ?? 0,
        'tempat_turun': surahData['tempat_turun'] ?? 'Makkah',
        'arti': surahData['arti'] ?? '',
        'deskripsi': surahData['deskripsi'] ?? '',
        'ayat': _extractAndFormatAyat(surahData['ayat'] ?? []),
      };
    } catch (e) {
      print("❌ Error loading surah $surahNumber from assets: $e");
      return _getFallbackSurahData(surahNumber);
    }
  }

  // Ekstrak dan format ayat
  List<Map<String, dynamic>> _extractAndFormatAyat(List<dynamic> ayatList) {
    final List<Map<String, dynamic>> formattedAyat = [];

    for (var ayat in ayatList) {
      final Map<String, dynamic> ayatMap = Map<String, dynamic>.from(ayat);

      // Pastikan tipe data benar
      formattedAyat.add({
        'nomor': ayatMap['nomor'] is int
            ? ayatMap['nomor']
            : int.tryParse(ayatMap['nomor'].toString()) ?? 0,
        'arab':
            ayatMap['arab']?.toString() ??
            ayatMap['teks_arab']?.toString() ??
            ayatMap['text']?.toString() ??
            '',
        'latin':
            ayatMap['latin']?.toString() ??
            ayatMap['teks_latin']?.toString() ??
            ayatMap['transliteration']?.toString() ??
            '',
        'arti':
            ayatMap['arti']?.toString() ??
            ayatMap['terjemahan']?.toString() ??
            ayatMap['idn']?.toString() ??
            '',
      });
    }

    // Urutkan berdasarkan nomor ayat
    formattedAyat.sort(
      (a, b) => (a['nomor'] as int).compareTo(b['nomor'] as int),
    );

    return formattedAyat;
  }

  // Data fallback
  Map<String, dynamic> _getFallbackSurahData(int surahNumber) {
    final fallbackAyat = [
      {
        "nomor": 1,
        "arab": "بِسْمِ اللّٰهِ الرَّحْمٰنِ الرَّحِيْمِ",
        "latin": "Bismillāhir-raḥmānir-raḥīm",
        "arti": "Dengan nama Allah Yang Maha Pengasih, Maha Penyayang.",
      },
    ];

    return {
      "nomor": surahNumber,
      "nama": surahNumber == 1 ? "الفاتحة" : "سورة",
      "nama_latin": surahNumber == 1 ? "Al-Fatihah" : "Surah $surahNumber",
      "jumlah_ayat": surahNumber == 1 ? 7 : 1,
      "tempat_turun": "Makkah",
      "arti": surahNumber == 1 ? "Pembukaan" : "Artinya",
      "deskripsi": "",
      "ayat": fallbackAyat,
    };
  }

  // Metode kompatibilitas
  static Future<List<dynamic>> loadAyatList(int surahNumber) async {
    try {
      final dataService = DataService();
      final surahData = await dataService.loadSurahData(surahNumber);
      return surahData['ayat'] ?? [];
    } catch (e) {
      print('❌ Error loading ayat list for surah $surahNumber: $e');
      return [];
    }
  }
}
