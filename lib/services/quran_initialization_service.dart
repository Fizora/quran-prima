import 'quran_api_service.dart';

class QuranInitializationService {
  static Future<void> initialize() async {
    try {
      // Check if all surahs are cached
      final isAllCached = await QuranApiService.isAllSurahsCached();

      if (!isAllCached) {
        print("📥 Starting background download of Quran data...");
        // Download all surahs in background
        _downloadAllSurahsInBackground();
      } else {
        print("✅ All Quran data is cached");
      }
    } catch (e) {
      print("❌ Error during initialization: $e");
    }
  }

  // Download all surahs in background without blocking UI
  static Future<void> _downloadAllSurahsInBackground() async {
    try {
      final success = await QuranApiService.downloadAllSurahs(
        onProgress: (current, total) {
          print("📥 Downloaded $current/$total surahs...");
        },
      );

      if (success) {
        print("✅ All surahs downloaded and cached successfully");
      } else {
        print("⚠️ Some surahs failed to download, will try again on next load");
      }
    } catch (e) {
      print("❌ Error downloading surahs: $e");
    }
  }

  // Check if currently downloading
  static Future<bool> hasAllSurahsCached() async {
    return await QuranApiService.isAllSurahsCached();
  }

  // Get cache status for UI
  static Future<int> getCachedCount() async {
    return await QuranApiService.getCachedSurahCount();
  }

  // Force download all (can be called from settings)
  static Future<bool> forceDownloadAll({
    required Function(int current, int total) onProgress,
  }) async {
    return await QuranApiService.downloadAllSurahs(onProgress: onProgress);
  }

  // Clear all cache (dangerous operation)
  static Future<bool> clearAllCache() async {
    return await QuranApiService.clearCache();
  }
}
