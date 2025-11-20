import 'package:flutter/material.dart';
import '../services/data_service.dart';

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
  final DataService _dataService = DataService();

  @override
  void initState() {
    super.initState();
    _loadSurahData();
  }

  Future<void> _loadSurahData() async {
    try {
      final data = await _dataService.loadSurahData(widget.surahNumber);
      setState(() {
        surahData = data;
        isLoading = false;
      });
    } catch (e) {
      print("Error in _loadSurahData: $e");
      setState(() {
        isLoading = false;
        errorMessage = 'Gagal memuat data surah';
      });
    }
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Surah ${widget.surahName}",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.black87,
            ),
          ),
          if (surahData != null)
            Text(
              "${surahData!['jumlah_ayat'] ?? '-'} Ayat",
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
        ],
      ),
      centerTitle: false,
      backgroundColor: Colors.white,
      elevation: 1,
      iconTheme: const IconThemeData(color: Colors.black87),
    );
  }

  Widget _buildAyatItem(Map<String, dynamic> ayat, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        elevation: 0.5,
        shadowColor: Colors.black.withOpacity(0.05),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Ayat - lebih sederhana
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Center(
                      child: Text(
                        "${ayat['nomor'] ?? (index + 1)}",
                        style: TextStyle(
                          color: Colors.green[700],
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Teks Arab - font lebih besar dan bagus
              Text(
                ayat['arab'] ?? '-',
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 24,
                  height: 1.8,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Scheherazade', // Font Arabic yang bagus
                ),
              ),
              const SizedBox(height: 12),

              // Teks Latin
              if (ayat['latin'] != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  child: Text(
                    ayat['latin'],
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.4,
                      color: Colors.grey[700],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),

              // Arti
              Container(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  ayat['arti'] ?? '-',
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAyatList() {
    if (isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
            ),
            SizedBox(height: 16),
            Text(
              "Memuat ayat...",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    if (errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              errorMessage,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadSurahData,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[50],
                foregroundColor: Colors.green[700],
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text("Coba Lagi"),
            ),
          ],
        ),
      );
    }

    if (surahData == null || surahData!['ayat'] == null) {
      return const Center(
        child: Text(
          "Data ayat tidak tersedia",
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    final List<dynamic> ayatList = surahData!['ayat'];

    return ListView.builder(
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
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: _buildAppBar(),
      body: _buildAyatList(), // Langsung tampilkan list ayat tanpa header
    );
  }
}
