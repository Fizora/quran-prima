import 'package:flutter/material.dart';

class AyatPage extends StatelessWidget {
  final String surahName;
  final int surahNumber;

  const AyatPage({
    super.key,
    required this.surahName,
    required this.surahNumber,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> ayatList = [
      "بِسْمِ اللّٰهِ الرَّحْمٰنِ الرَّحِيْمِ",
      "اَلْحَمْدُ لِلّٰهِ رَبِّ الْعٰلَمِيْنَ",
      "الرَّحْمٰنِ الرَّحِيْمِ",
      "مٰلِكِ يَوْمِ الدِّيْنِ",
    ];

    return Scaffold(
      appBar: AppBar(title: Text("Surah $surahName")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: ayatList.length,
        itemBuilder: (context, i) {
          return Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              "${i + 1}. ${ayatList[i]}",
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 22,
                height: 2.4,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        },
      ),
    );
  }
}
