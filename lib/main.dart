import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran_prima/pages/baca_quran.dart';
import 'package:quran_prima/pages/terakhir_baca.dart';
import 'package:quran_prima/pages/jadwal_sholat.dart';
import 'package:quran_prima/pages/doa_smk.dart';
import 'package:quran_prima/pages/istigosah.dart';
import 'package:quran_prima/pages/asmaul_husna.dart';
import 'package:quran_prima/pages/settings_page.dart';
import 'package:quran_prima/services/font_theme_service.dart';
import 'package:quran_prima/services/location_service.dart';

void main() {
  runApp(const QuranPrimaApp());
}
//
class QuranPrimaApp extends StatefulWidget {
  const QuranPrimaApp({super.key});

  @override
  State<QuranPrimaApp> createState() => _QuranPrimaAppState();
}

class _QuranPrimaAppState extends State<QuranPrimaApp> {
  late Future<String> _fontThemeFuture;

  @override
  void initState() {
    super.initState();
    _fontThemeFuture = FontThemeService.getSelectedFont();
    // Request location permission at startup
    LocationService.requestLocationPermission();
  }

  void _onFontChanged() {
    setState(() {
      _fontThemeFuture = FontThemeService.getSelectedFont();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _fontThemeFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          // Tampilkan loading screen kustom
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: LoadingScreen(),
          );
        }

        final selectedFont = snapshot.data ?? FontThemeService.fontDefault;
        final textTheme = FontThemeService.getTextTheme(selectedFont);

        return MaterialApp(
          title: 'Qur\'an Prima',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
            useMaterial3: true,
            textTheme: textTheme,
          ),
          home: QuranHomePage(onFontChanged: _onFontChanged),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}

/// Loading screen kustom dengan logo, beta version, dan credit
class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(), // Mendorong konten ke tengah vertikal
            // Logo di tengah
            Image.asset(
              'assets/images/logo.png',
              height: 100,
              // Fallback jika gambar tidak ditemukan (misal di development)
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.menu_book_rounded,
                    size: 60,
                    color: Colors.green[700],
                  ),
                );
              },
            ),
            const SizedBox(height: 16),

            // Beta version
            Text(
              'beta version 0.1',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),

            const Spacer(), // Mendorong teks credit ke bawah
            // Credit di bagian paling bawah
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Text(
                'Development By XII PPLG - Support By SMK PGRI 05 Jember',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QuranHomePage extends StatelessWidget {
  final VoidCallback onFontChanged;

  const QuranHomePage({super.key, required this.onFontChanged});

  void _navigateToPage(BuildContext context, String label) {
    switch (label) {
      case "BACA QUR'AN":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const BacaQuranPage()),
        );
        break;

      case "TERAKHIR BACA":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const TerakhirBacaPage()),
        );
        break;

      case "JADWAL SHOLAT":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const JadwalSholatPage()),
        );
        break;

      case "ASMAUL HUSNA":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AsmaulHusnaPage()),
        );
        break;

      case "DOA SMK":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const DoaSMKPage()),
        );
        break;

      case "ISTIGOSAH":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const IstigosahPage()),
        );
        break;

      case "PENGATURAN":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SettingsPage(onFontChanged: onFontChanged),
          ),
        );
        break;
    }
  }

  Widget _buildMenuButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
    required bool isSmallScreen,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: isSmallScreen ? 6 : 8,
        horizontal: isSmallScreen ? 12 : 0,
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        elevation: 2,
        shadowColor: const Color.fromRGBO(0, 0, 0, 0.1),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
            child: Row(
              children: [
                Container(
                  width: isSmallScreen ? 32 : 40,
                  height: isSmallScreen ? 32 : 40,
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.green[100]!),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.green[700],
                    size: isSmallScreen ? 16 : 20,
                  ),
                ),
                SizedBox(width: isSmallScreen ? 12 : 16),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 13 : 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.green[800],
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.green[400],
                  size: isSmallScreen ? 14 : 16,
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
      {"label": "BACA QUR'AN", "icon": Icons.menu_book_rounded},
      {"label": "TERAKHIR BACA", "icon": Icons.history_rounded},
      {"label": "JADWAL SHOLAT", "icon": Icons.access_time_rounded},
      {"label": "ASMAUL HUSNA", "icon": Icons.light_mode_rounded},
      {"label": "DOA SMK", "icon": Icons.school_rounded},
      {"label": "ISTIGOSAH", "icon": Icons.book_rounded},
      {"label": "PENGATURAN", "icon": Icons.settings_rounded},
    ];

    // Responsive values berdasarkan ukuran layar
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.height < 700;
    final isExtraSmallScreen = size.height < 600;

    final logoHeight = isSmallScreen ? 70.0 : 100.0;
    final titleFontSize = isSmallScreen ? 22.0 : 28.0;
    final subtitleFontSize = isSmallScreen ? 12.0 : 14.0;
    final topSpacing = isSmallScreen ? 16.0 : 24.0;
    final itemSpacing = isSmallScreen ? 16.0 : 40.0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: size.height - MediaQuery.of(context).padding.top,
            ),
            child: IntrinsicHeight(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo dan Judul
                    SizedBox(height: isExtraSmallScreen ? 8 : 12),
                    Image.asset(
                      'assets/images/logo.png',
                      height: logoHeight,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: logoHeight,
                          width: logoHeight,
                          decoration: BoxDecoration(
                            color: Colors.green[50],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.menu_book_rounded,
                            size: logoHeight * 0.6,
                            color: Colors.green[700],
                          ),
                        );
                      },
                    ),
                    SizedBox(height: topSpacing * 0.6),
                    Text(
                      'Qur\'an Prima',
                      style: TextStyle(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                      ),
                    ),
                    SizedBox(height: topSpacing * 0.3),
                    Text(
                      'Baca dan Pelajari Al-Qur\'an',
                      style: TextStyle(
                        fontSize: subtitleFontSize,
                        color: Colors.grey[600],
                      ),
                    ),

                    SizedBox(height: itemSpacing * 0.6),

                    // Menu Items (vertikal) - Responsive width
                    SizedBox(
                      width: size.width > 400 ? 300 : size.width * 0.85,
                      child: Column(
                        children: menuItems.map(
                          (item) => _buildMenuButton(
                            label: item['label'] as String,
                            icon: item['icon'] as IconData,
                            onTap: () {
                              _navigateToPage(context, item['label'] as String);
                            },
                            isSmallScreen: isSmallScreen,
                          ),
                        ).toList(),
                      ),
                    ),

                    SizedBox(height: isSmallScreen ? 16 : 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
