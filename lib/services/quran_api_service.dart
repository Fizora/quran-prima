import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class QuranApiService {
  static const String _baseUrl = 'https://quran-api.santrikoding.com/api/surah';

  // Get application documents directory untuk menyimpan cache
  static Future<Directory> _getCacheDir() async {
    final appDir = await getApplicationDocumentsDirectory();
    final cacheDir = Directory('${appDir.path}/quran_cache');
    if (!await cacheDir.exists()) {
      await cacheDir.create(recursive: true);
    }
    return cacheDir;
  }

  // Path untuk file surah
  static Future<String> _getSurahFilePath(int surahNumber) async {
    final cacheDir = await _getCacheDir();
    return '${cacheDir.path}/$surahNumber.json';
  }

  // Fetch single surah dari API
  static Future<Map<String, dynamic>?> _fetchSurahFromApi(
    int surahNumber,
  ) async {
    try {
      print("📡 Fetching surah $surahNumber from API...");
      final response = await http
          .get(Uri.parse('$_baseUrl/$surahNumber'))
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("✅ Surah $surahNumber fetched successfully");
        return data['data'] as Map<String, dynamic>;
      } else {
        print("❌ Error: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("❌ Error fetching surah $surahNumber: $e");
      return null;
    }
  }

  // Save surah ke local JSON
  static Future<bool> _saveSurahToFile(
    int surahNumber,
    Map<String, dynamic> surahData,
  ) async {
    try {
      final filePath = await _getSurahFilePath(surahNumber);
      final file = File(filePath);
      await file.writeAsString(json.encode(surahData));
      print("💾 Surah $surahNumber saved to local file");
      return true;
    } catch (e) {
      print("❌ Error saving surah $surahNumber: $e");
      return false;
    }
  }

  // Load surah dari local file
  static Future<Map<String, dynamic>?> _loadSurahFromFile(
    int surahNumber,
  ) async {
    try {
      final filePath = await _getSurahFilePath(surahNumber);
      final file = File(filePath);

      if (!await file.exists()) {
        return null;
      }

      final content = await file.readAsString();
      final data = json.decode(content);
      print("📖 Surah $surahNumber loaded from local cache");
      return data as Map<String, dynamic>;
    } catch (e) {
      print("❌ Error loading surah $surahNumber from file: $e");
      return null;
    }
  }

  // Get surah data: try local first, then API
  static Future<Map<String, dynamic>?> getSurah(int surahNumber) async {
    // Try local cache first
    final localData = await _loadSurahFromFile(surahNumber);
    if (localData != null) {
      return localData;
    }

    // If not found locally, fetch from API and cache
    final apiData = await _fetchSurahFromApi(surahNumber);
    if (apiData != null) {
      await _saveSurahToFile(surahNumber, apiData);
      return apiData;
    }

    return null;
  }

  // Download all surahs dari API dan cache locally
  static Future<bool> downloadAllSurahs({
    required Function(int current, int total) onProgress,
  }) async {
    try {
      print("🔄 Starting to download all surahs...");
      int successCount = 0;

      for (int i = 1; i <= 114; i++) {
        onProgress(i, 114);
        final surahData = await _fetchSurahFromApi(i);
        if (surahData != null) {
          await _saveSurahToFile(i, surahData);
          successCount++;
          // Add delay to avoid rate limiting
          await Future.delayed(const Duration(milliseconds: 100));
        }
      }

      print("✅ Downloaded $successCount out of 114 surahs");
      return successCount == 114;
    } catch (e) {
      print("❌ Error downloading all surahs: $e");
      return false;
    }
  }

  // Check if all surahs are cached
  static Future<bool> isAllSurahsCached() async {
    try {
      final cacheDir = await _getCacheDir();
      int cachedCount = 0;

      for (int i = 1; i <= 114; i++) {
        final file = File('${cacheDir.path}/$i.json');
        if (await file.exists()) {
          cachedCount++;
        }
      }

      return cachedCount == 114;
    } catch (e) {
      print("❌ Error checking cache: $e");
      return false;
    }
  }

  // Get cache status
  static Future<int> getCachedSurahCount() async {
    try {
      final cacheDir = await _getCacheDir();
      int cachedCount = 0;

      for (int i = 1; i <= 114; i++) {
        final file = File('${cacheDir.path}/$i.json');
        if (await file.exists()) {
          cachedCount++;
        }
      }

      return cachedCount;
    } catch (e) {
      return 0;
    }
  }

  // Clear cache
  static Future<bool> clearCache() async {
    try {
      final cacheDir = await _getCacheDir();
      if (await cacheDir.exists()) {
        await cacheDir.delete(recursive: true);
        print("🗑️ Cache cleared");
        return true;
      }
      return false;
    } catch (e) {
      print("❌ Error clearing cache: $e");
      return false;
    }
  }
}
