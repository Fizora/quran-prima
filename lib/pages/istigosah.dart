import 'package:flutter/material.dart';

class IstigosahPage extends StatelessWidget {
  const IstigosahPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Istigosah'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bacaan Istigosah',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Istigosah adalah doa bersama untuk memohon pertolongan Allah SWT:',
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 16),
              // Tambahkan bacaan istigosah di sini
              Text(
                'Doa Istigosah:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('لاَ إِلَهَ إِلاَّ اللهُ الْعَظِيْمُ الْحَلِيْمُ، لاَ إِلَهَ إِلاَّ اللهُ رَبُّ الْعَرْشِ الْعَظِيْمِ، لاَ إِلَهَ إِلاَّ اللهُ رَبُّ السَّمَوَاتِ وَرَبُّ اْلأَرْضِ وَرَبُّ الْعَرْشِ الْكَرِيْمِ'),
              SizedBox(height: 16),
              Text(
                'Makna:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('"Tidak ada ilah yang berhak diibadahi dengan benar selain Allah Yang Maha Agung lagi Maha Lembut. Tidak ada ilah yang berhak diibadahi dengan benar selain Allah, Rabb Arsy yang agung. Tidak ada ilah yang berhak diibadahi dengan benar selain Allah, Rabb langit, Rabb bumi dan Rabb Arsy yang mulia."'),
            ],
          ),
        ),
      ),
    );
  }
}
