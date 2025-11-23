import 'package:flutter/material.dart';
import 'package:quran_prima/pages/baca_quran.dart';
import 'package:quran_prima/pages/terakhir_baca.dart';
import 'package:quran_prima/pages/jadwal_sholat.dart';
import 'package:quran_prima/pages/pengaturan.dart';
import 'package:quran_prima/pages/doa_smk.dart'; // Import baru
import 'package:quran_prima/pages/istigosah.dart'; // Import baru

void main() {
  runApp(const QuranPrimaApp());
}

class QuranPrimaApp extends StatelessWidget {
  const QuranPrimaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Qur\'an Prima',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const QuranHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class QuranHomePage extends StatelessWidget {
  const QuranHomePage({super.key});

  void _navigateToPage(BuildContext context, String label) {
    switch (label) {
      case "BACA QUR'AN":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const BacaQuranPage(),
          ),
        );
        break;

      case "TERAKHIR BACA":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const TerakhirBacaPage(),
          ),
        );
        break;

      case "JADWAL SHOLAT":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const JadwalSholatPage(),
          ),
        );
        break;

      case "DOA SMK":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const DoaSMKPage(),
          ),
        );
        break;

      case "ISTIGOSAH":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const IstigosahPage(),
          ),
        );
        break;

      case "PENGATURAN":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const PengaturanPage(),
          ),
        );
        break;
    }
  }

  Widget _buildMenuButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      width: 250,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        elevation: 2,
        shadowColor: Color.fromRGBO(0, 0, 0, 0.1),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.green[100]!),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.green[700],
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.green[800],
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.green[400],
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> menuItems = [
      {
        "label": "BACA QUR'AN",
        "icon": Icons.menu_book_rounded,
      },
      {
        "label": "TERAKHIR BACA",
        "icon": Icons.history_rounded,
      },
      {
        "label": "JADWAL SHOLAT",
        "icon": Icons.access_time_rounded,
      },
      {
        "label": "DOA SMK",
        "icon": Icons.school_rounded,
      },
      {
        "label": "ISTIGOSAH",
        "icon": Icons.book_rounded, // Icon buku untuk istigosah
      },
      {
        "label": "PENGATURAN",
        "icon": Icons.settings_rounded,
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo dan Judul
              Image.asset('assets/images/Logo.png', height: 100),
              const SizedBox(height: 24),
              Text(
                'Qur\'an Prima',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Baca dan Pelajari Al-Qur\'an',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),

              const SizedBox(height: 40),

              // Menu Items (vertikal)
              ...menuItems.map((item) => _buildMenuButton(
                label: item['label'] as String,
                icon: item['icon'] as IconData,
                onTap: () {
                  _navigateToPage(context, item['label'] as String);
                },
              )),
            ],
          ),
        ),
      ),
    );
  }
}
