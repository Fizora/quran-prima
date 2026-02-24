import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/last_read_service.dart';
import 'ayat_page.dart';
import '../data/surah_data.dart';
import '../services/font_size_service.dart';

class TerakhirBacaPage extends StatefulWidget {
  const TerakhirBacaPage({super.key});

  @override
  State<TerakhirBacaPage> createState() => _TerakhirBacaPageState();
}

class _TerakhirBacaPageState extends State<TerakhirBacaPage> {
  Map<String, dynamic>? lastReadData;
  bool isLoading = true;
  String? _surahLatinName; // Untuk menyimpan nama Latin
  double _ayatFontSize = FontSizeService.defaultAyatFontSize;
  double _normalFontSize = FontSizeService.defaultNormalFontSize;

  @override
  void initState() {
    super.initState();
    _loadLastReadData();
    _loadFontSizes();
  }

  Future<void> _loadFontSizes() async {
    final ayatSize = await FontSizeService.getAyatFontSize();
    final normalSize = await FontSizeService.getNormalFontSize();
    setState(() {
      _ayatFontSize = ayatSize;
      _normalFontSize = normalSize;
    });
  }

  Future<void> _loadLastReadData() async {
    try {
      final data = await LastReadService.getLastRead();
      if (data != null) {
        // Cari nama Latin dari surah
        final surahNumber = data['surahNumber'] as int;
        final surahInfo = SurahData.list.firstWhere(
          (s) => s['nomor'] == surahNumber,
          orElse: () => {'nama_latin': data['surahName']},
        );

        setState(() {
          lastReadData = data;
          _surahLatinName = surahInfo['nama_latin'];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading last read data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Terakhir Baca"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              ),
            )
          : lastReadData == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.bookmark_outline,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Belum ada data terakhir baca.",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Mulai baca Al-Qur'an untuk melacak kemajuan Anda",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Card utama dengan info terakhir baca
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      color: Colors.green[50],
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.bookmark_outlined,
                                  color: Colors.green[700],
                                  size: 32,
                                ),
                                const SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Posisi Membaca Terkini',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Surah $_surahLatinName - Ayat ${lastReadData!['ayahNumber']}',
                                      style: TextStyle(
                                        fontSize: _normalFontSize + 4,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green[700],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                lastReadData!['ayahText'] ?? '',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontSize: _ayatFontSize,
                                  height: 1.8,
                                  fontFamily: 'Scheherazade',
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Icon(
                                  Icons.access_time,
                                  size: 16,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _formatTimestamp(lastReadData!['timestamp']),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Tombol lanjutkan membaca
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AyatPage(
                                surahName:
                                    _surahLatinName ??
                                    lastReadData!['surahName'],
                                surahNumber: lastReadData!['surahNumber'],
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.play_arrow),
                            SizedBox(width: 8),
                            Text(
                              'Lanjutkan Membaca',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  String _formatTimestamp(String timestamp) {
    try {
      final dateTime = DateTime.parse(timestamp);
      return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return timestamp;
    }
  }
}
