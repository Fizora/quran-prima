import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/font_size_service.dart';

class IstigosahPage extends StatefulWidget {
  const IstigosahPage({super.key});

  @override
  State<IstigosahPage> createState() => _IstigosahPageState();
}

class _IstigosahPageState extends State<IstigosahPage> {
  double _ayatFontSize = FontSizeService.defaultAyatFontSize;

  @override
  void initState() {
    super.initState();
    _loadFontSize();
  }

  Future<void> _loadFontSize() async {
    final fontSize = await FontSizeService.getAyatFontSize();
    setState(() {
      _ayatFontSize = fontSize;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Istigosah'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Bacaan Istigosah',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Istigosah adalah doa memohon pertolongan kepada Allah SWT. Berikut urutan bacaan yang umum diamalkan:',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),

              // 1. Syahadat (3x)
              Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '1. Syahadat (3x)',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          'أَشْهَدُ أَنْ لَا إِلَهَ إِلَّا اللهُ وَأَشْهَدُ أَنَّ مُحَمَّدًا رَسُولُ اللهِ',
                          style: GoogleFonts.amiri(
                            fontSize: _ayatFontSize,
                            color: Colors.green[800],
                          ),
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.right,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '"Asyhadu an laa ilaaha illallah, wa asyhadu anna Muhammadar rasulullah"',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '"Aku bersaksi bahwa tiada Tuhan selain Allah, dan aku bersaksi bahwa Muhammad adalah utusan Allah"',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),

              // 2. Dzikir Mulia (3x)
              Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '2. Dzikir Mulia (3x)',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          'سُبْحَانَ اللهِ وَالْحَمْدُ لِلَّهِ وَلَا إِلَهَ إِلَّا اللهُ وَاللهُ أَكْبَرُ',
                          style: GoogleFonts.amiri(
                            fontSize: _ayatFontSize,
                            color: Colors.green[800],
                          ),
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.right,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '"Subhanallah walhamdulillah wala ilaha illallah wallahu akbar"',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '"Maha Suci Allah, segala puji bagi Allah, tiada Tuhan selain Allah, Allah Maha Besar"',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),

              // 3. Hauqalah (3x)
              Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '3. Hauqalah (3x)',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          'لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللهِ',
                          style: GoogleFonts.amiri(
                            fontSize: _ayatFontSize,
                            color: Colors.green[800],
                          ),
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.right,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '"La haula wala quwwata illa billah"',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '"Tiada daya dan upaya kecuali dengan pertolongan Allah"',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),

              // 4. Bacaan Tawasul (1x)
              Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '4. Bacaan Tawasul (1x)',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          'إِلَىٰ حَضْرَةِ النَّبِيِّ مُحَمَّدٍ صَلَّى اللهُ عَلَيْهِ وَسَلَّمَ وَآلِهِ وَصَحْبِهِ، ثُمَّ إِلَىٰ أَرْوَاحِ جَمِيعِ الْمُسْلِمِينَ وَالْمُسْلِمَاتِ وَالْمُؤْمِنِينَ وَالْمُؤْمِنَاتِ، الْفَاتِحَةُ.',
                          style: GoogleFonts.amiri(
                            fontSize: _ayatFontSize,
                            color: Colors.green[800],
                            height: 1.8,
                          ),
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.right,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '"Ila hadrotin nabiyyi Muhammadin shallallahu alaihi wasallam wa alihi wa shohbihi, tsumma ila arwahi jamiil muslimina wal muslimat wal mukminina wal mukminat, al-Fatihah."',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '"Kepada junjungan Nabi Muhammad shallallahu alaihi wasallam, keluarga, dan sahabatnya, kemudian kepada arwah seluruh kaum muslimin dan muslimat, mukminin dan mukminat, (kita hadiahkan) Al-Fatihah."',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),

              // 5. Al Istighosah
              Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '5. Al Istighosah',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          'يَا حَيُّ يَا قَيُّومُ، بِرَحْمَتِكَ أَسْتَغِيْثُ، وَمِنْ عَذَابِكَ أَسْتَجِيْرُ، وَبِكَ أَسْتَعِيْنُ، فَاكْفِنِي كُلَّ مَا أَهَمَّنِي وَلَا تَكِلْنِي إِلَىٰ نَفْسِي طَرْفَةَ عَيْنٍ أَبَدًا',
                          style: GoogleFonts.amiri(
                            fontSize: _ayatFontSize,
                            color: Colors.green[800],
                            height: 1.8,
                          ),
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.right,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '"Ya Hayyu Ya Qayyum, birahmatika astaghits, wa min adzabika astajiiru, wa bika asta\'iinu, fakfini kulla ma ahammani wa la takilni ila nafsi thorfata \'ainin abada."',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '"Wahai Yang Maha Hidup, Yang Maha Berdiri Sendiri, dengan rahmat-Mu aku memohon pertolongan, dari siksa-Mu aku memohon perlindungan, dan hanya kepada-Mu aku memohon pertolongan. Maka cukupilah segala urusanku yang penting, dan jangan Engkau serahkan diriku kepada diriku sendiri meski sekejap mata."',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),

              // 6. Al-Fatihah (1x)
              Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '6. Al-Fatihah (1x)',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ\n'
                          'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ\n'
                          'الرَّحْمَٰنِ الرَّحِيمِ\n'
                          'مَالِكِ يَوْمِ الدِّينِ\n'
                          'إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ\n'
                          'اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ\n'
                          'صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ\n'
                          'غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ',
                          style: GoogleFonts.amiri(
                            fontSize: _ayatFontSize,
                            color: Colors.green[800],
                            height: 2.0,
                          ),
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.right,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Pembukaan - Surah Pertama',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 7. Istighfar (17x)
              Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '7. Istighfar (17x)',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          'أَسْتَغْفِرُ اللهَ الْعَظِيمَ',
                          style: GoogleFonts.amiri(
                            fontSize: _ayatFontSize,
                            color: Colors.green[800],
                          ),
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.right,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '"Astaghfirullahal \'adzim"',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '"Aku memohon ampun kepada Allah Yang Maha Agung"',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),

              // 8. Lauhaulawalaquwata (1x)
              Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '8. Lauhaulawalaquwata (1x)',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          'لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللهِ',
                          style: GoogleFonts.amiri(
                            fontSize: _ayatFontSize,
                            color: Colors.green[800],
                          ),
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.right,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '"La haula wala quwwata illa billah"',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '"Tiada daya dan upaya kecuali dengan pertolongan Allah"',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
