import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../services/data_service.dart';
import '../services/last_read_service.dart';
import '../services/font_size_service.dart';

class AyatPage extends StatefulWidget {
  final String surahName;
  final int surahNumber;

  const AyatPage({
    super.key,
    required this.surahName,
    required this.surahNumber,
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
  String _displayMode = 'ayat-translation'; // Default: ayat+terjemahan

  // Konstanta untuk line height teks Arab (dinaikkan agar lebih renggang)
  static const double _arabicLineHeight = 2.0;

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
        // Setelah data dimuat, cek last read dan scroll ke ayat yang disimpan
        _checkLastReadAndScroll();
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

  Future<void> _checkLastReadAndScroll() async {
    if (surahData == null) return;
    final lastRead = await LastReadService.getLastRead();
    if (lastRead != null && lastRead['surahNumber'] == widget.surahNumber) {
      final ayahNumber = lastRead['ayahNumber'] as int?;
      if (ayahNumber != null && ayahNumber > 0) {
        final ayatList = surahData!['ayat'] as List;
        final index = ayatList.indexWhere(
          (ayat) => ayat['nomor'] == ayahNumber,
        );
        if (index != -1) {
          // Gunakan post frame callback untuk scroll setelah layout selesai
          SchedulerBinding.instance.addPostFrameCallback((_) {
            if (_scrollController.hasClients) {
              // Estimasi offset berdasarkan indeks (asumsi tinggi item ~180)
              double offset = index * 180.0;
              _scrollController.animateTo(
                offset,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            }
          });
        }
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
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Terjemahan',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _displayMode = _displayMode == 'ayat-translation'
                        ? 'ayat-only'
                        : 'ayat-translation';
                  });
                },
                child: Container(
                  width: 45,
                  height: 24,
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: _displayMode == 'ayat-translation'
                        ? Colors.green
                        : Colors.grey[400],
                  ),
                  child: Stack(
                    children: [
                      AnimatedAlign(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeInOut,
                        alignment: _displayMode == 'ayat-translation'
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 2,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAyatItem(Map<String, dynamic> ayat, int index) {
    bool isBasmalah = ayat['nomor'] == 0;

    // Mode 'ayat-only' - tampilkan hanya ayat
    if (_displayMode == 'ayat-only') {
      return Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                    style: TextStyle(
                      fontFamily: 'Quran12',
                      fontWeight: FontWeight.w500,
                      height: _arabicLineHeight,
                      fontSize: isBasmalah
                          ? _ayatFontSize + 10
                          : _ayatFontSize,
                      color: Colors.black87,
                    ),
                  ),
                  if (!isBasmalah) ...[
                    TextSpan(
                      text: _convertToArabicNumber(ayat['nomor']),
                      style: TextStyle(
                        fontFamily: 'Quran12',
                        fontSize: _ayatFontSize + 15,
                        fontWeight: FontWeight.normal,
                        color: Colors.green[700],
                        height: _arabicLineHeight,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            if (isBasmalah) const SizedBox(height: 8),

            // Tombol simpan untuk mode ayat-only (kecuali basmalah)
            if (!isBasmalah) ...[
              const SizedBox(height: 8),
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
                        content: Text(
                          'Ayat ${_convertToArabicNumber(ayat['nomor'])} disimpan',
                        ),
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
            ],
          ],
        ),
      );
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
                      style: TextStyle(
                        fontFamily: 'Quran12',
                        fontWeight: FontWeight.w500,
                        height: _arabicLineHeight,
                        fontSize: isBasmalah
                            ? _ayatFontSize + 10
                            : _ayatFontSize,
                        color: Colors.black87,
                      ),
                    ),
                    if (!isBasmalah) ...[
                      TextSpan(
                        text: ' ۝${_convertToArabicNumber(ayat['nomor'])} ',
                        style: TextStyle(
                          fontSize: _ayatFontSize + 10,
                          fontWeight: FontWeight.normal,
                          color: Colors.green[700],
                          height: _arabicLineHeight,
                          fontFamily: 'Quran12',
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

                // Bookmark button (sudah ada)
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
                          content: Text(
                            'Ayat ${_convertToArabicNumber(ayat['nomor'])} disimpan',
                          ),
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
