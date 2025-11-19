import 'package:flutter/material.dart';

void main() {
  runApp(const QuranPrimaApp());
}

class QuranPrimaApp extends StatelessWidget {
  const QuranPrimaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Qur’an Prima',
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
          Image.asset(
            'assets/images/quran_bg.jpg', // gambar
            fit: BoxFit.cover,
          ),
          Container(color: Colors.black.withOpacity(0.5)),
          // Konten di tengah
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo atau tulisan Qur'an di atas
                Image.asset(
                  'assets/images/Logo.png', //Logo aplikasi smk pgri
                  height: 100,
                ),
                const SizedBox(height: 40),
                // Tombol-tombol navigasi
                ...menuItems.map(
                  (label) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: SizedBox(
                      width: 250, // lebar konsisten
                      height: 48, // tinggi konsisten
                      child: OutlinedButton(
                        onPressed: () {
                          // nanti tambahin navigasi sesuai fitur
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
