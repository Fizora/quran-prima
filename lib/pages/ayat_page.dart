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
        errorMessage = 'Gagal memuat data surah: $e';
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
              "${surahData!['arti'] ?? '-'} • ${surahData!['jumlah_ayat'] ?? '-'} Ayat",
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

  Widget _buildHeader() {
    if (surahData == null) return const SizedBox();

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nomor Surah
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green[100]!),
            ),
            child: Text(
              "Surah ${surahData!['nomor'] ?? '-'}",
              style: TextStyle(
                color: Colors.green[700],
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Nama Surah
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      surahData!['nama_latin'] ?? widget.surahName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      surahData!['nama'] ?? '-',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green[100]!),
                ),
                child: Center(
                  child: Text(
                    "${surahData!['nomor'] ?? '-'}",
                    style: TextStyle(
                      color: Colors.green[700],
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Info Surah
          Text(
            "${surahData!['arti'] ?? '-'} • ${surahData!['tempat_turun'] ?? '-'} • ${surahData!['jumlah_ayat'] ?? '-'} Ayat",
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
          const SizedBox(height: 12),

          // Deskripsi
          if (surahData!['deskripsi'] != null)
            Text(
              surahData!['deskripsi'] ?? '',
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 14,
                height: 1.5,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAyatItem(Map<String, dynamic> ayat, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.1),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Ayat
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green[100]!),
                    ),
                    child: Center(
                      child: Text(
                        "${ayat['nomor'] ?? (index + 1)}",
                        style: TextStyle(
                          color: Colors.green[700],
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(child: Divider(color: Colors.grey, height: 1)),
                ],
              ),
              const SizedBox(height: 16),

              // Teks Arab
              Text(
                ayat['arab'] ?? '-',
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 22,
                  height: 2.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),

              // Teks Latin
              if (ayat['latin'] != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    ayat['latin'],
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: Colors.grey[700],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              if (ayat['latin'] != null) const SizedBox(height: 12),

              // Arti
              Text(
                ayat['arti'] ?? '-',
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: Colors.black87,
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
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
        ),
      );
    }

    if (errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              errorMessage,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[500],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadSurahData,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[50],
                foregroundColor: Colors.green[700],
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
      body: Column(
        children: [
          if (surahData != null) _buildHeader(),
          Expanded(child: _buildAyatList()),
        ],
      ),
    );
  }
}
