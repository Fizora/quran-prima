import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'ayat_page.dart';
import '../services/data_service.dart';
import '../services/font_size_service.dart';

class BacaQuranPage extends StatefulWidget {
  const BacaQuranPage({super.key});

  @override
  State<BacaQuranPage> createState() => _BacaQuranPageState();
}

class _BacaQuranPageState extends State<BacaQuranPage> {
  final TextEditingController searchCtrl = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();

  List<dynamic> surahList = [];
  List<dynamic> filteredSurah = [];
  bool isSearching = false;
  bool isLoading = true;
  double _normalFontSize = FontSizeService.defaultNormalFontSize;

  // Tab state
  int selectedTab = 0; // 0 = Surah, 1 = Juz

  // Juz data
  final List<Map<String, dynamic>> juzList = [
    {
      'juz': 1,
      'surah_start': 1,
      'ayah_start': 1,
      'surah_end': 1,
      'ayah_end': 141,
    },
    {
      'juz': 2,
      'surah_start': 1,
      'ayah_start': 142,
      'surah_end': 2,
      'ayah_end': 252,
    },
    {
      'juz': 3,
      'surah_start': 2,
      'ayah_start': 253,
      'surah_end': 3,
      'ayah_end': 92,
    },
    {
      'juz': 4,
      'surah_start': 3,
      'ayah_start': 93,
      'surah_end': 4,
      'ayah_end': 23,
    },
    {
      'juz': 5,
      'surah_start': 4,
      'ayah_start': 24,
      'surah_end': 4,
      'ayah_end': 147,
    },
    {
      'juz': 6,
      'surah_start': 4,
      'ayah_start': 148,
      'surah_end': 5,
      'ayah_end': 81,
    },
    {
      'juz': 7,
      'surah_start': 5,
      'ayah_start': 82,
      'surah_end': 6,
      'ayah_end': 110,
    },
    {
      'juz': 8,
      'surah_start': 6,
      'ayah_start': 111,
      'surah_end': 7,
      'ayah_end': 87,
    },
    {
      'juz': 9,
      'surah_start': 7,
      'ayah_start': 88,
      'surah_end': 8,
      'ayah_end': 40,
    },
    {
      'juz': 10,
      'surah_start': 8,
      'ayah_start': 41,
      'surah_end': 9,
      'ayah_end': 92,
    },
    {
      'juz': 11,
      'surah_start': 9,
      'ayah_start': 93,
      'surah_end': 11,
      'ayah_end': 5,
    },
    {
      'juz': 12,
      'surah_start': 11,
      'ayah_start': 6,
      'surah_end': 12,
      'ayah_end': 52,
    },
    {
      'juz': 13,
      'surah_start': 12,
      'ayah_start': 53,
      'surah_end': 14,
      'ayah_end': 52,
    },
    {
      'juz': 14,
      'surah_start': 15,
      'ayah_start': 1,
      'surah_end': 16,
      'ayah_end': 128,
    },
    {
      'juz': 15,
      'surah_start': 17,
      'ayah_start': 1,
      'surah_end': 18,
      'ayah_end': 74,
    },
    {
      'juz': 16,
      'surah_start': 18,
      'ayah_start': 75,
      'surah_end': 21,
      'ayah_end': 29,
    },
    {
      'juz': 17,
      'surah_start': 21,
      'ayah_start': 30,
      'surah_end': 23,
      'ayah_end': 118,
    },
    {
      'juz': 18,
      'surah_start': 24,
      'ayah_start': 1,
      'surah_end': 25,
      'ayah_end': 20,
    },
    {
      'juz': 19,
      'surah_start': 25,
      'ayah_start': 21,
      'surah_end': 27,
      'ayah_end': 55,
    },
    {
      'juz': 20,
      'surah_start': 27,
      'ayah_start': 56,
      'surah_end': 29,
      'ayah_end': 45,
    },
    {
      'juz': 21,
      'surah_start': 29,
      'ayah_start': 46,
      'surah_end': 33,
      'ayah_end': 30,
    },
    {
      'juz': 22,
      'surah_start': 33,
      'ayah_start': 31,
      'surah_end': 36,
      'ayah_end': 27,
    },
    {
      'juz': 23,
      'surah_start': 36,
      'ayah_start': 28,
      'surah_end': 39,
      'ayah_end': 31,
    },
    {
      'juz': 24,
      'surah_start': 39,
      'ayah_start': 32,
      'surah_end': 41,
      'ayah_end': 46,
    },
    {
      'juz': 25,
      'surah_start': 41,
      'ayah_start': 47,
      'surah_end': 45,
      'ayah_end': 37,
    },
    {
      'juz': 26,
      'surah_start': 46,
      'ayah_start': 1,
      'surah_end': 51,
      'ayah_end': 30,
    },
    {
      'juz': 27,
      'surah_start': 51,
      'ayah_start': 31,
      'surah_end': 57,
      'ayah_end': 29,
    },
    {
      'juz': 28,
      'surah_start': 58,
      'ayah_start': 1,
      'surah_end': 66,
      'ayah_end': 12,
    },
    {
      'juz': 29,
      'surah_start': 67,
      'ayah_start': 1,
      'surah_end': 77,
      'ayah_end': 50,
    },
    {
      'juz': 30,
      'surah_start': 78,
      'ayah_start': 1,
      'surah_end': 114,
      'ayah_end': 6,
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadSurahData();
    _loadFontSize();
    searchCtrl.addListener(_onSearchChanged);
  }

  Future<void> _loadFontSize() async {
    final fontSize = await FontSizeService.getNormalFontSize();
    setState(() {
      _normalFontSize = fontSize;
    });
  }

  Future<void> _loadSurahData() async {
    try {
      final data = await DataService.loadSurahList();
      setState(() {
        surahList = data;
        filteredSurah = List.from(surahList);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _onSearchChanged() {
    if (selectedTab != 0) return; // Hanya untuk tab Surah

    final query = searchCtrl.text.toLowerCase().trim();
    setState(() {
      isSearching = query.isNotEmpty;
      if (query.isEmpty) {
        filteredSurah = List.from(surahList);
      } else {
        filteredSurah = surahList.where((surah) {
          final surahMap = surah as Map<String, dynamic>;
          return surahMap["nama"].toLowerCase().contains(query) ||
              surahMap["arabic"].toString().contains(query) ||
              surahMap["nomor"].toString() == query;
        }).toList();
      }
    });
  }

  void _clearSearch() {
    searchCtrl.clear();
    searchFocusNode.unfocus();
  }

  @override
  void dispose() {
    searchCtrl.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

  void _navigateToSurah(Map<String, dynamic> surah) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Pilih Mode Tampilan',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Bagaimana Anda ingin menampilkan ayat?',
            style: TextStyle(fontSize: 14),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AyatPage(
                      surahName: surah['nama'],
                      surahNumber: surah['nomor'],
                      displayMode: 'ayat-only',
                    ),
                  ),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.green,
              ),
              child: const Text('Ayat Saja'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AyatPage(
                      surahName: surah['nama'],
                      surahNumber: surah['nomor'],
                      displayMode: 'ayat-translation',
                    ),
                  ),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.green,
              ),
              child: const Text('Ayat + Terjemahan'),
            ),
          ],
        );
      },
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(
        "Daftar Surah",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Colors.black87,
        ),
      ),
      centerTitle: false,
      backgroundColor: Colors.white,
      elevation: 1,
      iconTheme: const IconThemeData(color: Colors.black87),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: Container(
          color: Colors.white,
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedTab = 0;
                      searchCtrl.clear();
                      isSearching = false;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: selectedTab == 0
                              ? Colors.green
                              : Colors.transparent,
                          width: 3,
                        ),
                      ),
                    ),
                    child: Text(
                      'Surah',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: selectedTab == 0 ? Colors.green : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedTab = 1;
                      searchCtrl.clear();
                      isSearching = false;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: selectedTab == 1
                              ? Colors.green
                              : Colors.transparent,
                          width: 3,
                        ),
                      ),
                    ),
                    child: Text(
                      'Juz',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: selectedTab == 1 ? Colors.green : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: Colors.grey[500], size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: searchCtrl,
              focusNode: searchFocusNode,
              decoration: const InputDecoration(
                hintText: "Cari surah...",
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey),
              ),
              style: const TextStyle(fontSize: 16),
            ),
          ),
          if (isSearching)
            IconButton(
              icon: Icon(Icons.close, color: Colors.grey[500], size: 20),
              onPressed: _clearSearch,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
        ],
      ),
    );
  }

  Widget _buildSurahItem(dynamic surahData, int index) {
    final surah = surahData as Map<String, dynamic>;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.1),
        child: InkWell(
          onTap: () => _navigateToSurah(surah),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Number Badge
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.green[100]!),
                  ),
                  child: Center(
                    child: Text(
                      surah["nomor"].toString(),
                      style: TextStyle(
                        color: Colors.green[700],
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        surah["nama"],
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: _normalFontSize,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${surah["type"]} • ${surah["ayat"]} Ayat",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: _normalFontSize - 2,
                        ),
                      ),
                    ],
                  ),
                ),

                // Arabic Text
                Text(
                  surah["arabic"],
                  style: GoogleFonts.notoNaskhArabic(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(width: 12),

                // Arrow Icon
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.grey[400],
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSurahList() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
        ),
      );
    }

    if (filteredSurah.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_rounded, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              "Surah tidak ditemukan",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[500],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Coba dengan kata kunci lain",
              style: TextStyle(fontSize: 14, color: Colors.grey[400]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: filteredSurah.length,
      itemBuilder: (context, index) {
        return _buildSurahItem(filteredSurah[index], index);
      },
    );
  }

  Widget _buildJuzItem(Map<String, dynamic> juz) {
    final juzNumber = juz['juz'];
    final startSurah = juz['surah_start'];
    final startAyah = juz['ayah_start'];
    final endSurah = juz['surah_end'];

    // Get surah name from surahList
    String startSurahName = '';
    if (surahList.isNotEmpty && startSurah <= surahList.length) {
      startSurahName = surahList[startSurah - 1]['nama'] ?? 'Unknown';
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.1),
        child: InkWell(
          onTap: () {
            // Navigate to first surah of juz
            _navigateToSurah({'nama': startSurahName, 'nomor': startSurah});
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Number Badge
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.green[100]!),
                  ),
                  child: Center(
                    child: Text(
                      juzNumber.toString(),
                      style: TextStyle(
                        color: Colors.green[700],
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Juz $juzNumber',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: _normalFontSize,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'MULAI DI: ${startSurahName.toUpperCase()} AYAT $startAyah',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: _normalFontSize - 2,
                        ),
                      ),
                    ],
                  ),
                ),

                // Arrow Icon
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.grey[400],
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildJuzList() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: juzList.length,
      itemBuilder: (context, index) {
        return _buildJuzItem(juzList[index]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: selectedTab == 0
          ? Column(
              children: [
                _buildSearchField(),
                Expanded(child: _buildSurahList()),
              ],
            )
          : _buildJuzList(),
    );
  }
}
