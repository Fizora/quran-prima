import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Kebijakan Keamanan Data',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              "1. Informasi yang Dikumpulkan",
              "Aplikasi Al Qur'an Prima tidak mengumpulkan data pribadi pengguna seperti nama, alamat email, nomor telepon, lokasi GPS, maupun informasi perangkat.\n\n"
              "Aplikasi hanya menyimpan data yang berkaitan dengan penggunaan aplikasi, seperti:\n"
              "- Riwayat bacaan terakhir\n"
              "- Preferensi tampilan (misalnya ukuran font dan jenis font)\n\n"
              "Data tersebut digunakan hanya untuk meningkatkan kenyamanan pengguna saat menggunakan aplikasi. Semua data tersebut disimpan secara lokal di perangkat pengguna dan tidak dikirim ke server kami.",
            ),
            const SizedBox(height: 24),
            _buildSection(
              "2. Penggunaan Data",
              "Data yang tersimpan di perangkat hanya digunakan untuk kebutuhan internal aplikasi, seperti:\n"
              "- Menampilkan kembali riwayat bacaan terakhir\n"
              "- Menyesuaikan tampilan aplikasi sesuai preferensi pengguna\n\n"
              "Aplikasi tidak mengirimkan, membagikan, atau menyimpan data tersebut ke server eksternal maupun pihak lain.",
            ),
            const SizedBox(height: 24),
            _buildSection(
              "3. Layanan Pihak Ketiga",
              "Aplikasi ini menggunakan sumber data dari layanan pihak ketiga untuk menyediakan konten Al-Qur'an.\n\n"
              "Data ayat Al-Qur'an diambil dari API SantriKoding pada saat proses pengembangan aplikasi. Data tersebut kemudian disimpan secara lokal di dalam aplikasi saat proses instalasi.\n\n"
              "Aplikasi tidak mengirimkan data pengguna ke layanan pihak ketiga.\n\n"
              "Jika di masa depan aplikasi menggunakan layanan API tambahan (misalnya untuk jadwal sholat), data yang digunakan hanya berupa lokasi yang dipilih secara manual oleh pengguna dan tidak menggunakan akses GPS.",
            ),
            const SizedBox(height: 24),
            _buildSection(
              "4. Penyimpanan Data",
              "Semua data yang dihasilkan dari penggunaan aplikasi disimpan secara lokal di perangkat pengguna dan tidak disimpan di server pengembang.",
            ),
            const SizedBox(height: 24),
            _buildSection(
              "5. Keamanan Data",
              "Kami berusaha menjaga keamanan data pengguna dengan memastikan bahwa aplikasi tidak mengumpulkan data pribadi dan tidak mengirimkan informasi pengguna ke server eksternal.",
            ),
            const SizedBox(height: 24),
            _buildSection(
              "6. Hak Pengguna",
              "Pengguna memiliki kendali penuh terhadap data yang tersimpan di perangkat. Pengguna dapat menghapus seluruh data aplikasi dengan cara menghapus data aplikasi melalui pengaturan perangkat atau dengan menghapus aplikasi dari perangkat.",
            ),
            const SizedBox(height: 24),
            _buildSection(
              "7. Perubahan Kebijakan Privasi",
              "Kebijakan privasi ini dapat diperbarui sewaktu-waktu apabila terdapat perubahan pada fitur aplikasi atau kebijakan yang berlaku. Perubahan akan diinformasikan melalui pembaruan aplikasi.",
            ),
            const SizedBox(height: 24),
            _buildSection(
              "8. Kontak Pengembang",
              "Jika Anda memiliki pertanyaan mengenai kebijakan privasi ini, Anda dapat menghubungi pengembang melalui email:\n"
              "Email: ",
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          content,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
            height: 1.6,
          ),
        ),
      ],
    );
  }
}
