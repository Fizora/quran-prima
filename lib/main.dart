import 'package:flutter/material.dart';
import 'package:quran_prima/pages/baca_quran.dart';
// import 'package:quran_prima/pages/ayat_page.dart';
import 'package:quran_prima/pages/terakhir_baca.dart';
import 'package:quran_prima/pages/pencarian.dart';
import 'package:quran_prima/pages/jadwal_sholat.dart';
import 'package:quran_prima/pages/pengaturan.dart';

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

  @override
  Widget build(BuildContext context) {
    final List<String> menuItems = [
      "BACA QUR'AN",
      "TERAKHIR BACA",
      "PENCARIAN",
      "JADWAL SHOLAT",
      "PENGATURAN",
    ];

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/quran_bg.jpg', fit: BoxFit.cover),
          Container(color: Colors.black.withOpacity(0.5)),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/Logo.png', height: 100),
                const SizedBox(height: 40),
                ...menuItems.map(
                  (label) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: SizedBox(
                      width: 250,
                      height: 48,
                      child: OutlinedButton(
                        onPressed: () {
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

                            case "PENCARIAN":
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const PencarianPage(),
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

                            case "PENGATURAN":
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const PengaturanPage(),
                                ),
                              );
                              break;
                          }
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: Colors.white,
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          backgroundColor: Colors.white.withOpacity(0.1),
                        ),
                        child: Text(
                          label,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
