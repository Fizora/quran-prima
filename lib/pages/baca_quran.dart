import 'package:flutter/material.dart';
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

  // 🔒 Fitur Juz disembunyikan – semua kode terkait Juz dikomentari
  // int selectedTab = 0; // Tidak digunakan lagi

  /*
  // Data Juz (tidak digunakan)
  final List<Map<String, dynamic>> juzList = [ ... ];
  */

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
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            AyatPage(surahName: surah['nama'], surahNumber: surah['nomor']),
      ),
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
      // 🔒 Tab Juz dihilangkan – hanya menampilkan judul saja
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
                  style: TextStyle(
                    fontFamily: 'Quran12',
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

  // 🔒 Fungsi untuk Juz dikomentari agar tidak digunakan
  /*
  Widget _buildJuzItem(Map<String, dynamic> juz) { ... }
  Widget _buildJuzList() { ... }
  */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      // Selalu tampilkan daftar Surah (tanpa tab Juz)
      body: Column(
        children: [
          _buildSearchField(),
          Expanded(child: _buildSurahList()),
        ],
      ),
    );
  }
}
