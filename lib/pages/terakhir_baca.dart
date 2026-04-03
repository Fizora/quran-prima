import 'package:flutter/material.dart';
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
  String? _surahLatinName;
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
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  String _formatTimestamp(String timestamp) {
    try {
      final dateTime = DateTime.parse(timestamp);
      return '${dateTime.day}/${dateTime.month}/${dateTime.year} • ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return timestamp;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          "Terakhir Baca",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              ),
            )
          : lastReadData == null
          ? _buildEmptyState()
          : _buildContent(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.green[50],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.bookmark_border,
              size: 60,
              color: Colors.green[300],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "Belum Ada Aktivitas Membaca",
            style: TextStyle(
              fontSize: _normalFontSize + 4,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              "Mulai membaca Al-Qur'an untuk melacak kemajuan Anda. Ayat terakhir yang Anda baca akan muncul di sini.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: _normalFontSize - 2,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.menu_book_rounded),
            label: const Text("Mulai Membaca"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8, bottom: 16),
              child: Text(
                "Lanjutkan bacaan Anda",
                style: TextStyle(
                  fontSize: _normalFontSize,
                  color: Colors.grey[600],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.green[50]!, Colors.green[100]!],
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Text(
                            'Terakhir Dibaca',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.bookmark_rounded,
                          color: Colors.green[700],
                          size: 32,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _surahLatinName ?? lastReadData!['surahName'],
                                style: TextStyle(
                                  fontSize: _normalFontSize + 8,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[900],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Ayat ${lastReadData!['ayahNumber']}',
                                style: TextStyle(
                                  fontSize: _normalFontSize + 4,
                                  color: Colors.green[700],
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 14,
                                color: Colors.green[700],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _formatTimestamp(lastReadData!['timestamp']),
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.green[800],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        lastReadData!['ayahText'] ?? '',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: _ayatFontSize,
                          height: 1.8,
                          fontFamily: 'Quran12',
                          color: Colors.green[900],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  colors: [Colors.green, Color(0xFF2E7D32)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AyatPage(
                        surahName:
                            _surahLatinName ?? lastReadData!['surahName'],
                        surahNumber: lastReadData!['surahNumber'],
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  minimumSize: const Size(double.infinity, 0),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.play_circle_fill, size: 28),
                    SizedBox(width: 12),
                    Text(
                      'Lanjutkan Membaca',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                'Baca, pahami, dan amalkan',
                style: TextStyle(
                  fontSize: _normalFontSize - 2,
                  color: Colors.grey[500],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
