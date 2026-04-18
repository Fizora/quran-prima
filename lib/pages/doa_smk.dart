import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/font_size_service.dart';

class DoaSMKPage extends StatefulWidget {
  const DoaSMKPage({super.key});

  @override
  State<DoaSMKPage> createState() => _DoaSMKPageState();
}

class _DoaSMKPageState extends State<DoaSMKPage> {
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
        title: const Text('Doa SMK'),
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
                'Doa-doa untuk Sekolah Menengah Kejuruan',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Berikut adalah kumpulan doa-doa yang bermanfaat untuk siswa SMK:',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),

              // Doa Memulai Pelajaran
              // Card(
              //   elevation: 2,
              //   margin: const EdgeInsets.only(bottom: 16),
              //   child: Padding(
              //     padding: const EdgeInsets.all(16.0),
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         const Text(
              //           'Doa Memulai Pelajaran:',
              //           style: TextStyle(
              //             fontWeight: FontWeight.bold,
              //             fontSize: 16,
              //             color: Colors.green,
              //           ),
              //         ),
              //         const SizedBox(height: 8),
              //         // Teks Arab rata kanan
              //         Container(
              //           width: double.infinity,
              //           child: Text(
              //             'رَبِّ زِدْنِي عِلْمًا',
              //             style: GoogleFonts.amiri(
              //               fontSize: _ayatFontSize,
              //               color: Colors.green[800],
              //             ),
              //             textDirection: TextDirection.rtl,
              //             textAlign: TextAlign.right,
              //           ),
              //         ),
              //         const SizedBox(height: 8),
              //         // Teks Latin
              //         const Text(
              //           '"Rabbi zidni \'ilma"',
              //           style: TextStyle(
              //             fontStyle: FontStyle.italic,
              //             fontSize: 14,
              //           ),
              //         ),
              //         const SizedBox(height: 8),
              //         // Terjemahan
              //         const Text(
              //           '"Ya Rabbku, tambahkanlah kepadaku ilmu"',
              //           style: TextStyle(fontSize: 14, color: Colors.grey),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),

              // Doa Memahami Pelajaran
              Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Doa Memulai Pelajaran:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        child: Text(
                          'اللَّهُمَّ انْفَعْنِي بِمَا عَلَّمْتَنِي وَعَلِّمْنِي مَا يَنْفَعُنِي',
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
                        '"Allahummanfa\'ni bima \'allamtani wa \'allimni ma yanfa\'uni"',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '"Ya Allah, berilah manfaat kepadaku dengan apa yang Engkau ajarkan kepadaku, dan ajarkanlah aku apa yang bermanfaat bagiku"',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),

              // Doa Sebelum Belajar
              Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Doa Sebelum Belajar:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        child: Text(
                          'يَا رَبِّ زِدْنِي عِلْمًا وَارْزُقْنِي فَهْمًا',
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
                        '"Ya Rabbi zidni \'ilman warzuqni fahman"',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '"Ya Rabbku, tambahkanlah aku ilmu dan berilah aku pemahaman"',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),

              // Doa Menghadapi Ujian
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Doa Menghadapi Ujian:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        child: Text(
                          'اللَّهُمَّ لاَ سَهْلَ إِلاَّ مَا جَعَلْتَهُ سَهْلاً وَأَنْتَ تَجْعَلُ الْحَزْنَ سَهْلاً',
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
                        '"Allahumma la sahla illa ma ja\'altahu sahla, wa anta taj\'alul hazna idha syi\'ta sahla"',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '"Ya Allah, tidak ada kemudahan kecuali apa yang Engkau jadikan mudah. Sedang yang susah bisa Engkau jadikan mudah, apabila Engkau menghendakinya"',
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
