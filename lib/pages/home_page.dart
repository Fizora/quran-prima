// import 'package:flutter/material.dart';
// import 'package:quran_prima/main.dart';

// void main() {
//   runApp(const QuranPrimaApp());

//   class QuranHomePage  extends StatelessWidget {
//     const QuranHomePage({super.key});

//     @override
//     Widget build(BuildContext context) {
//       final List<String> menuItems = [
//         "BACA QUR'AN",
//         "TERAKHIR BACA",
//         "PENCARIAN",
//         "JADWAL SHOLAT",
//         "PENGATURAN",
//       ];

//       return Scaffold(
//         body: Stack(
//           fit: StackFit.expand,
//           children: [
//             // Background image blur or dark overlay
//             Image.asset(
//               'assets/images/quran_bg.jpg', // ganti sesuai path gambar lo
//               fit: BoxFit.cover,
//             ),
//             Container(
//               color: Colors.black.withOpacity(
//                 0.5,
//               ), // biar teks dan tombol lebih jelas
//             ),
//             // Konten di tengah
//             Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   // Logo atau tulisan Qur'an di atas
//                   Image.asset(
//                     'assets/images/Logo.png', //Logo aplikasi smk pgri
//                     height: 100,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       );
//     }
//   }
// } 
