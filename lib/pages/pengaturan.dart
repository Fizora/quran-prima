import 'package:flutter/material.dart';

class PengaturanPage extends StatelessWidget {
  const PengaturanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pengaturan")),
      body: const Center(
        child: Text(
          "Pengaturan aplikasi belum tersedia.",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
