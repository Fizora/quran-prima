import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:quran_prima/pages/privacy_policy_page.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Info Aplikasi',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Logo Section
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.green[100]!, width: 2),
                ),
                child: Image.asset(
                  'assets/images/logo.png',
                  height: 100,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.menu_book_rounded,
                    size: 80,
                    color: Colors.green[700],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            Text(
              "Qur'an Prima",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.green[800],
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Versi 1.0.0 (Beta)",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 32),

            // Description Card
            _buildInfoCard(
              title: "Tentang Aplikasi",
              content: "Qur'an Prima adalah aplikasi Al-Qur'an digital modern yang dirancang untuk memudahkan umat Muslim dalam membaca, mempelajari, dan mengamalkan isi Al-Qur'an di mana saja dan kapan saja.",
              icon: Icons.description_outlined,
            ),
            const SizedBox(height: 16),

            // Development Card
            _buildInfoCard(
              title: "Pengembangan",
              content: "Dikembangkan oleh siswa XII PPLG (Pengembangan Perangkat Lunak & Gim) SMK PGRI 5 Jember sebagai proyek nyata implementasi teknologi mobile.",
              icon: Icons.code_rounded,
            ),
            const SizedBox(height: 16),

            // Credits Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[200]!),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Row(
                    children: [
                      Icon(Icons.source_outlined, color: Colors.green[700], size: 20),
                      const SizedBox(width: 12),
                      const Text(
                        "Sumber & Atribusi",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildCreditItem("Data Al-Qur'an", "SantriKoding API"),
                  _buildCreditItem("Jadwal Sholat", "Aladhan Cloud API"),
                  _buildCreditItem("Font Al-Qur'an", "LPMQ IsepMisbah (Kemenag RI)"),
                  _buildCreditItem("Dukungan Gedung", "SMK PGRI 05 Jember"),
                ],
              ),
            ),
            
            const SizedBox(height: 16),

            // Privacy Policy Link
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PrivacyPolicyPage()),
                );
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey[200]!),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(Icons.security_rounded, color: Colors.green[700], size: 20),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        "Kebijakan Keamanan Data",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey[400], size: 16),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),

            // Contributor Link
            InkWell(
              onTap: () {
                _launchUrl('https://quran-prima.laskarsigma.my.id/');
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey[200]!),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(Icons.people_alt_rounded, color: Colors.green[700], size: 20),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        "Kontributor",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Icon(Icons.open_in_new_rounded, color: Colors.grey[400], size: 16),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Footer
            Text(
              "© 2026 XII PPLG SMK PGRI 5 Jember",
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({required String title, required String content, required IconData icon}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.green[700], size: 20),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreditItem(String label, String source) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
          ),
          Text(
            source,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
