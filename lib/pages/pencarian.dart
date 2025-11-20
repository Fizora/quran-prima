import 'package:flutter/material.dart';

class PencarianPage extends StatelessWidget {
  const PencarianPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pencarian")),
      body: const Center(
        child: Text(
          "Fitur pencarian belum tersedia.",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
