import 'package:flutter/material.dart';
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
                'Bacaan Istigosah Lengkap',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Istigosah adalah doa bersama untuk memohon pertolongan Allah SWT. Bacaan istigosah mencakup Al-Fatihah, Istighfar, dan berbagai doa penyembuhan.',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),

              // 1. Al-Fatihah
              Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '1. Al-Fatihah',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ\n'
                        'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ\n'
                        'الرَّحْمَٰنِ الرَّحِيمِ\n'
                        'مَالِكِ يَوْمِ الدِّينِ\n'
                        'إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ\n'
                        'اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ\n'
                        'صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ\n'
                        'غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ',
                        style: TextStyle(
                          fontFamily: 'Quran12',
                          height: 2.0,
                          color: Colors.green[900],
                          fontSize: _ayatFontSize,
                        ),
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.right,
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

              // 2. Istighfar
              Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '2. Istighfar (3x)',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'أَسْتَغْفِرُ اللهَ الْعَظِيمِ',
                        style: TextStyle(
                          fontFamily: 'Quran12',
                          color: Colors.green[800],
                          fontSize: _ayatFontSize,
                        ),
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.right,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '\'Astaghfirullahal adzim\'',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '\'Aku memohon ampun kepada Allah Yang Maha Agung\'',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),

              // 3. Kalimat Thayyibah
              Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '3. Kalimat Thayyibah (33x)',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'لاَ حَوْلَ وَلاَ قُوَّةَ إِلاَّ بِاللهِ الْعَلِيِّ الْعَظِيمِ',
                        style: TextStyle(
                          fontFamily: 'Quran12',
                          color: Colors.green[800],
                          fontSize: _ayatFontSize,
                        ),
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.right,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '\'La haula wa la quwwata illa billahil aliyyil adzim\'',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '\'Tidak ada daya dan upaya kecuali dengan pertolongan Allah Yang Maha Tinggi lagi Maha Agung\'',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),

              // 4. Shalawat
              Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '4. Shalawat (41x)',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'اللَّهُمَّ صَلِّ عَلَىٰ سَيِّدِنَا مُحَمَّدٍ وَعَلَىٰ آلِ سَيِّدِنَا مُحَمَّدٍ\n'
                        'سَلّاَمٌ عَلَيْهِ كَامِلَةٌ وَسَلَامٌ عَلَىٰ نَبِيِّنَا مُحَمَّدٍ\n'
                        'اَللَّهُمَّ صَلِّ عَلَىٰ سَيِّدِنَا مُحَمَّدٍ وَعَلَىٰ آلِهِ وَصَحْبِهِ',
                        style: TextStyle(
                          fontFamily: 'Quran12',
                          height: 2.0,
                          color: Colors.green[900],
                          fontSize: _ayatFontSize,
                        ),
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.right,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '\'Allahumma sholli ala sayyidina Muhammad wa ala ali sayyidina Muhammad, salamun alaihi kamilatan wa salamun ala nabiyyina Muhammad, Allahumma sholli ala sayyidina Muhammad wa ala alihi wa shohbihi\'',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '\'Ya Allah, limpahkanlah rahmat kepada Nabi Muhammad dan keluarganya, semoga keselamatan yang sempurna tercurah kepadanya dan salam sejahtera kepada Nabi kami Muhammad, Ya Allah limpahkanlah rahmat kepada Nabi Muhammad, keluarganya, dan sahabat-sahabatnya\'',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),

              // 5. Doa Kesembuhan
              Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '5. Doa Kesembuhan (33x)',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'أَسْتَغْفِرُ اللهَ الْعَظِيمِ إِنَّهُ كَانَ غَفَّارًا',
                        style: TextStyle(
                          fontFamily: 'Quran12',
                          color: Colors.green[800],
                          fontSize: _ayatFontSize,
                        ),
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.right,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '\'Astaghfirullahal adzima innahu kana ghaffara\'',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '\'Aku memohon ampun kepada Allah Yang Maha Agung, sesungguhnya Dia adalah Maha Pengampun\'',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),

              // 6. Doa Penyembuhan
              Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '6. Doa Penyembuhan (41x)',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'اللَّهُمَّ صَلِّ صَلاَةً كَامِلَةً وَسَلِّمْ سَلاَمًا تَامًّا عَلَىٰ سَيِّدِنَا مُحَمَّدٍ '
                        'الَّذِي تَحِلُّ بِهِ الْقُرَى وَتُفَرَّجُ بِهِ الْكُرُبُ وَتُقْضَىٰ بِهِ الْحَوَائِجُ '
                        'وَتَنَالُ بِهِ الرَّغَائِبُ وَحُسْنُ الْخَوَاتِيمِ وَيُسْتَسْقَىٰ الْغَمَامُ بِوَجْهِهِ '
                        'الْكَرِيمِ وَعَلَىٰ آلِهِ وَصَحْبِهِ فِي كُلِّ لَمْحَةٍ وَنَفَسٍ بِعَدَدِ كُلِّ مَعْلُومٍ لَكَ',
                        style: TextStyle(
                          fontFamily: 'Quran12',
                          height: 2.0,
                          color: Colors.green[900],
                          fontSize: _ayatFontSize,
                        ),
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.right,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Doa shalawat penyembuhan yang panjang',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Shalawat untuk memohon kesembuhan dan terbebas dari segala kesulitan',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),

              // 7. Ya Badi' dan Hasbunallah
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "7. Ya Badi' dan Hasbunallah (33x)",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'يَا بَدِيعُ\nحَسْبُنَا اللهُ وَنِعْمَ الْوَكِيلُ',
                        style: TextStyle(
                          fontFamily: 'Quran12',
                          height: 2.0,
                          color: Colors.green[900],
                          fontSize: _ayatFontSize,
                        ),
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.right,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '\'Ya Badii\' Hasbunallahu wa nimal wakil\'',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '\'Wahai Yang Maha Pencipta, Cukuplah Allah menjadi Penolong kami dan Dia adalah sebaik-baik Pelindung\'',
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
