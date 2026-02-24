import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import '../services/font_size_service.dart';

class AsmaulHusnaPage extends StatefulWidget {
  const AsmaulHusnaPage({super.key});

  @override
  State<AsmaulHusnaPage> createState() => _AsmaulHusnaPageState();
}

class _AsmaulHusnaPageState extends State<AsmaulHusnaPage> {
  final TextEditingController searchCtrl = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();

  List<dynamic> asmaulHusnaList = [];
  List<dynamic> filteredAsmaulHusna = [];
  bool isSearching = false;
  bool isLoading = true;
  double _ayatFontSize = FontSizeService.defaultAyatFontSize;

  @override
  void initState() {
    super.initState();
    _loadAsmaulHusnaData();
    _loadFontSize();
    searchCtrl.addListener(_onSearchChanged);
  }

  Future<void> _loadFontSize() async {
    final fontSize = await FontSizeService.getAyatFontSize();
    setState(() {
      _ayatFontSize = fontSize;
    });
  }

  Future<void> _loadAsmaulHusnaData() async {
    try {
      // Data Asmaul Husna statis (99 nama)
      final List<Map<String, dynamic>> staticData = [
        {
          "no": 1,
          "arabic": "الرَّحْمَنُ",
          "latin": "Ar Rahman",
          "terjemahan": "Yang Maha Pengasih",
        },
        {
          "no": 2,
          "arabic": "الرَّحِيمُ",
          "latin": "Ar Rahim",
          "terjemahan": "Yang Maha Penyayang",
        },
        {
          "no": 3,
          "arabic": "الْمَلِكُ",
          "latin": "Al Malik",
          "terjemahan": "Yang Maha Merajai",
        },
        {
          "no": 4,
          "arabic": "الْقُدُّوسُ",
          "latin": "Al Quddus",
          "terjemahan": "Yang Maha Suci",
        },
        {
          "no": 5,
          "arabic": "السَّلاَمُ",
          "latin": "As Salam",
          "terjemahan": "Yang Maha Memberi Kesejahteraan",
        },
        {
          "no": 6,
          "arabic": "الْمُؤْمِنُ",
          "latin": "Al Mu'min",
          "terjemahan": "Yang Maha Memberi Keamanan",
        },
        {
          "no": 7,
          "arabic": "الْمُهَيْمِنُ",
          "latin": "Al Muhaimin",
          "terjemahan": "Yang Maha Mengatur",
        },
        {
          "no": 8,
          "arabic": "الْعَزِيزُ",
          "latin": "Al Aziz",
          "terjemahan": "Yang Maha Perkasa",
        },
        {
          "no": 9,
          "arabic": "الْجَبَّارُ",
          "latin": "Al Jabbar",
          "terjemahan": "Yang Memiliki Mutlak Kegagahan",
        },
        {
          "no": 10,
          "arabic": "الْمُتَكَبِّرُ",
          "latin": "Al Mutakabbir",
          "terjemahan": "Yang Maha Megah",
        },
        {
          "no": 11,
          "arabic": "الْخَالِقُ",
          "latin": "Al Khaliq",
          "terjemahan": "Yang Maha Pencipta",
        },
        {
          "no": 12,
          "arabic": "الْبَارِئُ",
          "latin": "Al Bari",
          "terjemahan": "Yang Maha Melepaskan",
        },
        {
          "no": 13,
          "arabic": "الْمُصَوِّرُ",
          "latin": "Al Mushawwir",
          "terjemahan": "Yang Maha Membentuk Rupa",
        },
        {
          "no": 14,
          "arabic": "الْغَفَّارُ",
          "latin": "Al Ghaffar",
          "terjemahan": "Yang Maha Pengampun",
        },
        {
          "no": 15,
          "arabic": "الْقَهَّارُ",
          "latin": "Al Qahhar",
          "terjemahan": "Yang Maha Memaksa",
        },
        {
          "no": 16,
          "arabic": "الْوَهَّابُ",
          "latin": "Al Wahhab",
          "terjemahan": "Yang Maha Pemberi Karunia",
        },
        {
          "no": 17,
          "arabic": "الرَّزَّاقُ",
          "latin": "Ar Razzaq",
          "terjemahan": "Yang Maha Pemberi Rezeki",
        },
        {
          "no": 18,
          "arabic": "الْفَتَّاحُ",
          "latin": "Al Fattah",
          "terjemahan": "Yang Maha Pembuka Rahmat",
        },
        {
          "no": 19,
          "arabic": "اَلْعَلِيْمُ",
          "latin": "Al Alim",
          "terjemahan": "Yang Maha Mengetahui",
        },
        {
          "no": 20,
          "arabic": "الْقَابِضُ",
          "latin": "Al Qabid",
          "terjemahan": "Yang Maha Menyempitkan",
        },
        {
          "no": 21,
          "arabic": "الْبَاسِطُ",
          "latin": "Al Basit",
          "terjemahan": "Yang Maha Melapangkan",
        },
        {
          "no": 22,
          "arabic": "الْخَافِضُ",
          "latin": "Al Khafid",
          "terjemahan": "Yang Maha Merendahkan",
        },
        {
          "no": 23,
          "arabic": "الرَّافِعُ",
          "latin": "Ar Rafi",
          "terjemahan": "Yang Maha Meninggikan",
        },
        {
          "no": 24,
          "arabic": "المُعِزُّ",
          "latin": "Al Mu'izz",
          "terjemahan": "Yang Maha Memuliakan",
        },
        {
          "no": 25,
          "arabic": "المُذِلُّ",
          "latin": "Al Mudzil",
          "terjemahan": "Yang Maha Menghinakan",
        },
        {
          "no": 26,
          "arabic": "السَّمِيعُ",
          "latin": "As Sami",
          "terjemahan": "Yang Maha Mendengar",
        },
        {
          "no": 27,
          "arabic": "الْبَصِيرُ",
          "latin": "Al Bashir",
          "terjemahan": "Yang Maha Melihat",
        },
        {
          "no": 28,
          "arabic": "الْحَكَمُ",
          "latin": "Al Hakam",
          "terjemahan": "Yang Maha Menetapkan",
        },
        {
          "no": 29,
          "arabic": "الْعَدْلُ",
          "latin": "Al Adl",
          "terjemahan": "Yang Maha Adil",
        },
        {
          "no": 30,
          "arabic": "اللَّطِيفُ",
          "latin": "Al Latif",
          "terjemahan": "Yang Maha Lembut",
        },
        {
          "no": 31,
          "arabic": "الْخَبِيرُ",
          "latin": "Al Khabir",
          "terjemahan": "Yang Maha Mengetahui Rahasia",
        },
        {
          "no": 32,
          "arabic": "الْحَلِيمُ",
          "latin": "Al Halim",
          "terjemahan": "Yang Maha Penyantun",
        },
        {
          "no": 33,
          "arabic": "الْعَظِيمُ",
          "latin": "Al Azhim",
          "terjemahan": "Yang Maha Agung",
        },
        {
          "no": 34,
          "arabic": "الْغَفُورُ",
          "latin": "Al Ghafur",
          "terjemahan": "Yang Maha Pengampun",
        },
        {
          "no": 35,
          "arabic": "الشَّكُورُ",
          "latin": "As Syakur",
          "terjemahan": "Yang Maha Pembalas Budi",
        },
        {
          "no": 36,
          "arabic": "الْعَلِيُّ",
          "latin": "Al Ali",
          "terjemahan": "Yang Maha Tinggi",
        },
        {
          "no": 37,
          "arabic": "الْكَبِيرُ",
          "latin": "Al Kabir",
          "terjemahan": "Yang Maha Besar",
        },
        {
          "no": 38,
          "arabic": "الْحَفِيظُ",
          "latin": "Al Hafiz",
          "terjemahan": "Yang Maha Memelihara",
        },
        {
          "no": 39,
          "arabic": "المُقِيتُ",
          "latin": "Al Muqit",
          "terjemahan": "Yang Maha Pemberi Kecukupan",
        },
        {
          "no": 40,
          "arabic": "الْحَسِيبُ",
          "latin": "Al Hasib",
          "terjemahan": "Yang Maha Membuat Perhitungan",
        },
        {
          "no": 41,
          "arabic": "الْجَلِيلُ",
          "latin": "Al Jalil",
          "terjemahan": "Yang Maha Luhur",
        },
        {
          "no": 42,
          "arabic": "الْكَرِيمُ",
          "latin": "Al Karim",
          "terjemahan": "Yang Maha Pemurah",
        },
        {
          "no": 43,
          "arabic": "الرَّقِيبُ",
          "latin": "Ar Raqib",
          "terjemahan": "Yang Maha Mengawasi",
        },
        {
          "no": 44,
          "arabic": "الْمُجِيبُ",
          "latin": "Al Mujib",
          "terjemahan": "Yang Maha Mengabulkan",
        },
        {
          "no": 45,
          "arabic": "الْوَاسِعُ",
          "latin": "Al Wasi",
          "terjemahan": "Yang Maha Luas",
        },
        {
          "no": 46,
          "arabic": "الْحَكِيمُ",
          "latin": "Al Hakim",
          "terjemahan": "Yang Maha Maka Bijaksana",
        },
        {
          "no": 47,
          "arabic": "الْوَدُودُ",
          "latin": "Al Wadud",
          "terjemahan": "Yang Maha Mengasihi",
        },
        {
          "no": 48,
          "arabic": "الْمَجِيدُ",
          "latin": "Al Majid",
          "terjemahan": "Yang Maha Mulia",
        },
        {
          "no": 49,
          "arabic": "الْبَاعِثُ",
          "latin": "Al Ba'its",
          "terjemahan": "Yang Maha Membangkitkan",
        },
        {
          "no": 50,
          "arabic": "الشَّهِيدُ",
          "latin": "As Syahid",
          "terjemahan": "Yang Maha Menyaksikan",
        },
        {
          "no": 51,
          "arabic": "الْحَقُّ",
          "latin": "Al Haqq",
          "terjemahan": "Yang Maha Benar",
        },
        {
          "no": 52,
          "arabic": "الْوَكِيلُ",
          "latin": "Al Wakil",
          "terjemahan": "Yang Maha Memelihara",
        },
        {
          "no": 53,
          "arabic": "الْقَوِيُّ",
          "latin": "Al Qawiyy",
          "terjemahan": "Yang Maha Kuat",
        },
        {
          "no": 54,
          "arabic": "الْمَتِينُ",
          "latin": "Al Matin",
          "terjemahan": "Yang Maha Kokoh",
        },
        {
          "no": 55,
          "arabic": "الْوَلِيُّ",
          "latin": "Al Wali",
          "terjemahan": "Yang Maha Melindungi",
        },
        {
          "no": 56,
          "arabic": "الْحَمِيدُ",
          "latin": "Al Hamid",
          "terjemahan": "Yang Maha Terpuji",
        },
        {
          "no": 57,
          "arabic": "الْمُحْصِي",
          "latin": "Al Muhshi",
          "terjemahan": "Yang Maha Menghitung",
        },
        {
          "no": 58,
          "arabic": "الْمُبْدِئُ",
          "latin": "Al Mubdi",
          "terjemahan": "Yang Maha Memulai",
        },
        {
          "no": 59,
          "arabic": "الْمُعِيدُ",
          "latin": "Al Mu'id",
          "terjemahan": "Yang Maha Mengembalikan Kehidupan",
        },
        {
          "no": 60,
          "arabic": "الْمُحْيِي",
          "latin": "Al Muhyi",
          "terjemahan": "Yang Maha Menghidupkan",
        },
        {
          "no": 61,
          "arabic": "اَلْمُمِيتُ",
          "latin": "Al Mumit",
          "terjemahan": "Yang Maha Mematikan",
        },
        {
          "no": 62,
          "arabic": "الْحَيُّ",
          "latin": "Al Hayy",
          "terjemahan": "Yang Maha Hidup",
        },
        {
          "no": 63,
          "arabic": "الْقَيُّومُ",
          "latin": "Al Qayyum",
          "terjemahan": "Yang Maha Mandiri",
        },
        {
          "no": 64,
          "arabic": "الْوَاجِدُ",
          "latin": "Al Wajid",
          "terjemahan": "Yang Maha Penemu",
        },
        {
          "no": 65,
          "arabic": "الْمَاجِدُ",
          "latin": "Al Majid",
          "terjemahan": "Yang Maha Mulia",
        },
        {
          "no": 66,
          "arabic": "الواحِدُ",
          "latin": "Al Wahid",
          "terjemahan": "Yang Maha Tunggal",
        },
        {
          "no": 67,
          "arabic": "اَلاَحَدُ",
          "latin": "Al Ahad",
          "terjemahan": "Yang Maha Esa",
        },
        {
          "no": 68,
          "arabic": "الصَّمَدُ",
          "latin": "As Shamad",
          "terjemahan": "Yang Maha Dibutuhkan",
        },
        {
          "no": 69,
          "arabic": "الْقَادِرُ",
          "latin": "Al Qadir",
          "terjemahan": "Yang Maha Menentukan",
        },
        {
          "no": 70,
          "arabic": "الْمُقْتَدِرُ",
          "latin": "Al Muqtadir",
          "terjemahan": "Yang Maha Berkuasa",
        },
        {
          "no": 71,
          "arabic": "الْمُقَدِّمُ",
          "latin": "Al Muqaddim",
          "terjemahan": "Yang Maha Mendahulukan",
        },
        {
          "no": 72,
          "arabic": "الْمُؤَخِّرُ",
          "latin": "Al Mu'akhir",
          "terjemahan": "Yang Maha Mengakhirkan",
        },
        {
          "no": 73,
          "arabic": "الأوَّلُ",
          "latin": "Al Awwal",
          "terjemahan": "Yang Maha Awal",
        },
        {
          "no": 74,
          "arabic": "الآخِرُ",
          "latin": "Al Akhir",
          "terjemahan": "Yang Maha Akhir",
        },
        {
          "no": 75,
          "arabic": "الظَّاهِرُ",
          "latin": "Az Zahir",
          "terjemahan": "Yang Maha Nyata",
        },
        {
          "no": 76,
          "arabic": "الْبَاطِنُ",
          "latin": "Al Batin",
          "terjemahan": "Yang Maha Ghaib",
        },
        {
          "no": 77,
          "arabic": "الْوَالِي",
          "latin": "Al Wali",
          "terjemahan": "Yang Maha Memerintah",
        },
        {
          "no": 78,
          "arabic": "الْمُتَعَالِي",
          "latin": "Al Muta'ali",
          "terjemahan": "Yang Maha Tinggi",
        },
        {
          "no": 79,
          "arabic": "الْبَرُّ",
          "latin": "Al Barr",
          "terjemahan": "Yang Maha Penderma",
        },
        {
          "no": 80,
          "arabic": "التَّوَابُ",
          "latin": "At Tawwab",
          "terjemahan": "Yang Maha Penerima Tobat",
        },
        {
          "no": 81,
          "arabic": "الْمُنْتَقِمُ",
          "latin": "Al Muntaqim",
          "terjemahan": "Yang Maha Penuntut Balas",
        },
        {
          "no": 82,
          "arabic": "العَفُوُّ",
          "latin": "Al Afuww",
          "terjemahan": "Yang Maha Pemaaf",
        },
        {
          "no": 83,
          "arabic": "الرَّؤُوفُ",
          "latin": "Ar Rauf",
          "terjemahan": "Yang Maha Pengasih",
        },
        {
          "no": 84,
          "arabic": "مَالِكُ الْمُلْكِ",
          "latin": "Malikul Mulk",
          "terjemahan": "Yang Maha Penguasa Kerajaan",
        },
        {
          "no": 85,
          "arabic": "ذُوالْجَلاَلِ وَالإكْرَامِ",
          "latin": "Dzul Jalal wal Ikram",
          "terjemahan": "Yang Maha Pemilik Kebesaran dan Kemuliaan",
        },
        {
          "no": 86,
          "arabic": "الْمُقْسِطُ",
          "latin": "Al Muqsit",
          "terjemahan": "Yang Maha Adil",
        },
        {
          "no": 87,
          "arabic": "الْجَامِعُ",
          "latin": "Al Jami",
          "terjemahan": "Yang Maha Mengumpulkan",
        },
        {
          "no": 88,
          "arabic": "الْغَنِيُّ",
          "latin": "Al Ghani",
          "terjemahan": "Yang Maha Kaya",
        },
        {
          "no": 89,
          "arabic": "الْمُغْنِي",
          "latin": "Al Mughni",
          "terjemahan": "Yang Maha Pemberi Kekayaan",
        },
        {
          "no": 90,
          "arabic": "اَلْمَانِعُ",
          "latin": "Al Mani",
          "terjemahan": "Yang Maha Mencegah",
        },
        {
          "no": 91,
          "arabic": "الضَّارَّ",
          "latin": "Ad Darr",
          "terjemahan": "Yang Maha Penimpa Kemudharatan",
        },
        {
          "no": 92,
          "arabic": "النَّافِعُ",
          "latin": "An Nafi",
          "terjemahan": "Yang Maha Memberi Manfaat",
        },
        {
          "no": 93,
          "arabic": "النُّورُ",
          "latin": "An Nur",
          "terjemahan": "Yang Maha Bercahaya",
        },
        {
          "no": 94,
          "arabic": "الْهَادِي",
          "latin": "Al Hadi",
          "terjemahan": "Yang Maha Pemberi Petunjuk",
        },
        {
          "no": 95,
          "arabic": "الْبَدِيعُ",
          "latin": "Al Badi",
          "terjemahan": "Yang Maha Pencipta Yang Tiada Bandingannya",
        },
        {
          "no": 96,
          "arabic": "اَلْبَاقِي",
          "latin": "Al Baqi",
          "terjemahan": "Yang Maha Kekal",
        },
        {
          "no": 97,
          "arabic": "الْوَارِثُ",
          "latin": "Al Warith",
          "terjemahan": "Yang Maha Pewaris",
        },
        {
          "no": 98,
          "arabic": "الرَّشِيدُ",
          "latin": "Ar Rasyid",
          "terjemahan": "Yang Maha Pandai",
        },
        {
          "no": 99,
          "arabic": "الصَّبُورُ",
          "latin": "As Sabur",
          "terjemahan": "Yang Maha Sabar",
        },
      ];

      setState(() {
        asmaulHusnaList = staticData;
        filteredAsmaulHusna = List.from(staticData);
        isLoading = false;
      });
    } catch (e) {
      print("❌ Error loading Asmaul Husna data: $e");
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
        filteredAsmaulHusna = List.from(asmaulHusnaList);
      } else {
        filteredAsmaulHusna = asmaulHusnaList.where((asma) {
          final asmaMap = asma as Map<String, dynamic>;
          return asmaMap["latin"].toLowerCase().contains(query) ||
              asmaMap["arabic"].toString().contains(query) ||
              asmaMap["terjemahan"].toLowerCase().contains(query) ||
              asmaMap["no"].toString() == query;
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
                hintText: "Cari Asmaul Husna...",
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

  Widget _buildAsmaulHusnaItem(dynamic asmaData, int index) {
    final asma = asmaData as Map<String, dynamic>;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nomor Asmaul Husna dengan style yang mirip Doa SMK
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${asma["no"]}. ${asma["latin"]}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.green[700],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Teks Arab - pusatkan dan ukuran lebih besar
            Align(
              alignment: Alignment.center,
              child: Text(
                asma["arabic"],
                style: GoogleFonts.amiriQuran(
                  fontSize: _ayatFontSize + 8,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[800],
                ),
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
              ),
            ),
            const SizedBox(height: 16),

            // Arti/terjemahan
            Text(
              asma["terjemahan"],
              style: const TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAsmaulHusnaList() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
        ),
      );
    }

    if (filteredAsmaulHusna.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_rounded, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
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
      itemCount: filteredAsmaulHusna.length,
      itemBuilder: (context, index) {
        return _buildAsmaulHusnaItem(filteredAsmaulHusna[index], index);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Asmaul Husna'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search field tetap ada
            _buildSearchField(),
            const SizedBox(height: 8),

            // Informasi jumlah
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.info_outline, color: Colors.green[700], size: 18),
                  const SizedBox(width: 8),
                  Text(
                    '${filteredAsmaulHusna.length} Asmaul Husna ditemukan',
                    style: TextStyle(
                      color: Colors.green[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // List Asmaul Husna
            Expanded(child: _buildAsmaulHusnaList()),
          ],
        ),
      ),
    );
  }
}
