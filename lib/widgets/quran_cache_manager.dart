import 'package:flutter/material.dart';
import '../services/quran_initialization_service.dart';

class QuranCacheManager extends StatefulWidget {
  const QuranCacheManager({super.key});

  @override
  State<QuranCacheManager> createState() => _QuranCacheManagerState();
}

class _QuranCacheManagerState extends State<QuranCacheManager> {
  bool _isDownloading = false;
  int _downloadProgress = 0;
  late Future<int> _cachedCountFuture;

  @override
  void initState() {
    super.initState();
    _cachedCountFuture = QuranInitializationService.getCachedCount();
  }

  Future<void> _downloadAllSurahs() async {
    if (_isDownloading) return;

    setState(() {
      _isDownloading = true;
      _downloadProgress = 0;
    });

    try {
      final success = await QuranInitializationService.forceDownloadAll(
        onProgress: (current, total) {
          setState(() {
            _downloadProgress = ((current / total) * 100).toInt();
          });
        },
      );

      if (mounted) {
        setState(() {
          _isDownloading = false;
          _cachedCountFuture = QuranInitializationService.getCachedCount();
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success
                  ? '✅ Semua surah berhasil diunduh!'
                  : '⚠️ Beberapa surah gagal diunduh',
            ),
            backgroundColor: success ? Colors.green : Colors.orange,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isDownloading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _clearCache() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Cache?'),
        content: const Text(
          'Ini akan menghapus semua data Quran yang sudah diunduh. Data akan diunduh ulang saat dibuka.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await QuranInitializationService.clearAllCache();

              if (mounted) {
                setState(() {
                  _cachedCountFuture =
                      QuranInitializationService.getCachedCount();
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? '✅ Cache berhasil dihapus'
                          : '❌ Gagal menghapus cache',
                    ),
                    backgroundColor: success ? Colors.green : Colors.red,
                  ),
                );
              }
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Text(
            'Manajemen Cache Quran',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Status Cache',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 12),
                FutureBuilder<int>(
                  future: _cachedCountFuture,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Text('Memeriksa cache...');
                    }

                    final count = snapshot.data ?? 0;
                    final percentage = ((count / 114) * 100).toInt();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$count / 114 surah tersimpan ($percentage%)',
                          style: const TextStyle(fontSize: 13),
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: count / 114,
                            minHeight: 8,
                            backgroundColor: Colors.grey[300],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              count == 114 ? Colors.green : Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 16),
                if (_isDownloading)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mengunduh: $_downloadProgress%',
                        style: const TextStyle(fontSize: 12),
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: _downloadProgress / 100,
                          minHeight: 6,
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _isDownloading ? null : _downloadAllSurahs,
                        icon: const Icon(Icons.download),
                        label: Text(
                          _isDownloading ? 'Mengunduh...' : 'Unduh Semua',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isDownloading
                              ? Colors.grey
                              : Colors.green,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: _isDownloading ? null : _clearCache,
                      icon: const Icon(Icons.delete_outline),
                      label: const Text('Hapus'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isDownloading
                            ? Colors.grey
                            : Colors.red,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text(
            '💡 Tip: Data akan diunduh otomatis saat mengakses surah jika belum tersimpan. '
            'Unduh semua sekarang agar aplikasi bekerja tanpa koneksi internet.',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ),
      ],
    );
  }
}
