import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/data_service.dart';
import '../services/last_read_service.dart';
import '../services/font_size_service.dart';

class AyatPage extends StatefulWidget {
  final String surahName;
  final int surahNumber;
  final String displayMode; // 'ayat-only' atau 'ayat-translation'

  const AyatPage({
    super.key,
    required this.surahName,
    required this.surahNumber,
    this.displayMode = 'ayat-translation',
  });

  @override
  State<AyatPage> createState() => _AyatPageState();
}

class _AyatPageState extends State<AyatPage> {
  Map<String, dynamic>? surahData;
  bool isLoading = true;
  String errorMessage = '';
  final ScrollController _scrollController = ScrollController();
  double _ayatFontSize = FontSizeService.defaultAyatFontSize;

  // Helper untuk convert angka normal ke angka Arab
  String _convertToArabicNumber(int number) {
    const arabicNumbers = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    String result = '';
    for (int digit in number.toString().codeUnits) {
      int num = int.parse(String.fromCharCode(digit));
      result += arabicNumbers[num];
    }
    return result;
  }

  @override
  void initState() {
    super.initState();
    _loadSurahData();
    _loadFontSize();
  }

  Future<void> _loadFontSize() async {
    final fontSize = await FontSizeService.getAyatFontSize();
    setState(() {
      _ayatFontSize = fontSize;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadSurahData() async {
    try {
      final DataService dataService = DataService();
      final data = await dataService.loadSurahData(widget.surahNumber);

      if (mounted) {
        setState(() {
          surahData = data;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = 'Gagal memuat data';
          isLoading = false;
        });
      }
    }
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.surahName,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          if (surahData != null)
            Text(
              '${surahData!['jumlah_ayat']} Ayat',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
        ],
      ),
      backgroundColor: Colors.white,
    elevation: 0,
      iconTheme: const IconThemeData(color: Colors.black54),
    );
  }

  Widget _buildAyatOnlyCompact(List<dynamic> ayatList) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            // Basmalah - centered
            if (ayatList.isNotEmpty &&
                (ayatList[0] as Map<String, dynamic>)['nomor'] == 0) ...[
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: (ayatList[0] as Map<String, dynamic>)['arab'],
                  style: GoogleFonts.notoNaskhArabic(
                    fontSize: _ayatFontSize + 6,
                    height: 1.8,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            // Ayat lainnya - mengalir dari kanan ke kiri
            RichText(
              textAlign: TextAlign.right,
              text: TextSpan(
                children: [
                  for (int i = 0; i < ayatList.length; i++) ...[
                    // Skip basmalah karena sudah ditampilkan di atas
                    if ((ayatList[i] as Map<String, dynamic>)['nomor'] != 0) ...[
                      TextSpan(
                        text: (ayatList[i] as Map<String, dynamic>)['arab'],
                        style: GoogleFonts.notoNaskhArabic(
                          fontSize: _ayatFontSize,
                          height: 1.8,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      TextSpan(
                        text: ' ۝${_convertToArabicNumber((ayatList[i] as Map<String, dynamic>)['nomor'])} ',
                        style: TextStyle(
                          fontSize: _ayatFontSize - 4,
                          fontWeight: FontWeight.w600,
                          color: Colors.green[700],
                          height: 1.8,
                        ),
                      ),
                    ],
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAyatItem(Map<String, dynamic> ayat, int index) {
    bool isBasmalah = ayat['nomor'] == 0;

    // Mode 'ayat-only' - handled separately with compact flow
    if (widget.displayMode == 'ayat-only') {
      return const SizedBox.shrink(); // Tidak digunakan, gunakan _buildAyatOnlyCompact
    }

    // Mode 'ayat-translation' - card view dengan terjemahan
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (isBasmalah) const SizedBox(height: 8),

              // Arabic Text dengan nomor ayat inline
              RichText(
                textAlign: isBasmalah ? TextAlign.center : TextAlign.right,
                textDirection: TextDirection.rtl,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: ayat['arab'],
                      style: GoogleFonts.notoNaskhArabic(
                        fontSize: isBasmalah ? _ayatFontSize + 6 : _ayatFontSize,
                        height: 1.6,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    if (!isBasmalah) ...[
                      TextSpan(
                        text: ' ۝${_convertToArabicNumber(ayat['nomor'])} ',
                        style: TextStyle(
                          fontSize: _ayatFontSize - 4,
                          fontWeight: FontWeight.w600,
                          color: Colors.green[700],
                          height: 1.6,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              if (!isBasmalah) ...[
                const SizedBox(height: 16),

                // Transliteration (Latin)
                if (ayat['latin'] != null && ayat['latin'].isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      ayat['latin'],
                      style: TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey[700],
                        height: 1.4,
                      ),
                    ),
                  ),

                // Translation
                Container(
                  padding: const EdgeInsets.only(top: 12),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.grey[200]!, width: 1),
                    ),
                  ),
                  child: Text(
                    ayat['arti'],
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.5,
                      color: Colors.black87,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Bookmark button
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                      onTap: () async {
                        await LastReadService.saveLastRead(
                          surahNumber: widget.surahNumber,
                          surahName: widget.surahName,
                          ayahNumber: ayat['nomor'],
                          ayahText: ayat['arab'],
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Ayat ${_convertToArabicNumber(ayat['nomor'])} disimpan'),
                            backgroundColor: Colors.green,
                            duration: const Duration(seconds: 1),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(
                              Icons.bookmark_add_outlined,
                              size: 14,
                              color: Colors.green,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Simpan',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.green,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ] else if (isBasmalah) ...[
                const SizedBox(height: 8),
                // Translation for basmalah (centered)
                Container(
                  padding: const EdgeInsets.only(top: 12),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.grey[200]!, width: 1),
                    ),
                  ),
                  child: Text(
                    ayat['arti'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
          ),
          const SizedBox(height: 16),
          Text(
            'Memuat Surah ${widget.surahName}',
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'Gagal memuat data',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Text(
            errorMessage,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _loadSurahData,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }

  Widget _buildAyatList() {
    if (surahData == null || surahData!['ayat'] == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.book_outlined, size: 48, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'Tidak ada ayat tersedia',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      );
    }

    final List<dynamic> ayatList = surahData!['ayat'];

    // Mode 'ayat-only' menggunakan layout compact yang mengalir
    if (widget.displayMode == 'ayat-only') {
      return SingleChildScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(top: 4, bottom: 20),
        child: _buildAyatOnlyCompact(ayatList),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: ayatList.length,
      itemBuilder: (context, index) {
        return _buildAyatItem(ayatList[index] as Map<String, dynamic>, index);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: isLoading
          ? _buildLoading()
          : errorMessage.isNotEmpty
          ? _buildError()
          : RefreshIndicator(
              onRefresh: _loadSurahData,
              color: Colors.green,
              child: _buildAyatList(),
            ),
      floatingActionButton:
          _scrollController.hasClients && _scrollController.offset > 100
          ? FloatingActionButton(
              onPressed: () {
                _scrollController.animateTo(
                  0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              },
              backgroundColor: Colors.white,
              foregroundColor: Colors.green,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.arrow_upward),
            )
          : null,
    );
  }
}
