import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/font_size_service.dart';
import '../services/font_theme_service.dart';
import 'prayer_notification_settings.dart';

class SettingsPage extends StatefulWidget {
  final VoidCallback onFontChanged;

  const SettingsPage({super.key, required this.onFontChanged});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late double _ayatFontSize;
  late double _normalFontSize;
  late String _selectedFont;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final ayatSize = await FontSizeService.getAyatFontSize();
    final normalSize = await FontSizeService.getNormalFontSize();
    final selectedFont = await FontThemeService.getSelectedFont();

    setState(() {
      _ayatFontSize = ayatSize;
      _normalFontSize = normalSize;
      _selectedFont = selectedFont;
      isLoading = false;
    });
  }

  Future<void> _setSelectedFont(String font) async {
    await FontThemeService.setSelectedFont(font);
    setState(() {
      _selectedFont = font;
    });
    widget.onFontChanged();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Font berubah menjadi ${FontThemeService.fontNames[font]}',
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _setAyatFontSize(double size) async {
    await FontSizeService.setAyatFontSize(size);
    setState(() {
      _ayatFontSize = size;
    });
  }

  Future<void> _setNormalFontSize(double size) async {
    await FontSizeService.setNormalFontSize(size);
    setState(() {
      _normalFontSize = size;
    });
  }

  Future<void> _resetToDefaults() async {
    await FontSizeService.resetToDefaults();
    await _loadSettings();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Font sizes reset to default')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan Font'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Prayer Notification Settings Card
                    Card(
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 16),
                      color: Colors.green[50],
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const PrayerNotificationSettingsPage(),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.notifications_active,
                                color: Colors.green[700],
                                size: 32,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Notifikasi Sholat',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green[700],
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Atur pengingat waktu sholat harian',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.green[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.green[400],
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Font Theme Section
                    Card(
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Pilih Font',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Font Preview
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.green[50],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.green[200]!),
                              ),
                              child: Text(
                                'The quick brown fox jumps over the lazy dog',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.green[900],
                                  fontFamily: FontThemeService.getFontFamily(
                                    _selectedFont,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Font Selection Dropdown
                            DropdownButtonFormField<String>(
                              value: _selectedFont,
                              decoration: InputDecoration(
                                labelText: 'Font Aplikasi',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                prefixIcon: const Icon(
                                  Icons.text_fields,
                                  color: Colors.green,
                                ),
                              ),
                              items: FontThemeService.availableFonts
                                  .map(
                                    (font) => DropdownMenuItem(
                                      value: font,
                                      child: Text(
                                        FontThemeService.fontNames[font] ??
                                            font,
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (String? value) {
                                if (value != null) {
                                  _setSelectedFont(value);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Ayat Font Size Section
                    Card(
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Ukuran Font Ayat',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Preview
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.green[50],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.green[200]!),
                              ),
                              child: Text(
                                'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                                textAlign: TextAlign.right,
                                style: GoogleFonts.notoNaskhArabic(
                                  fontSize: _ayatFontSize,
                                  color: Colors.green[900],
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Size Display and Controls
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Ukuran Saat Ini',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      '${_ayatFontSize.toStringAsFixed(1)}',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    ElevatedButton.icon(
                                      onPressed:
                                          _ayatFontSize >
                                              FontSizeService.minFontSize
                                          ? () {
                                              _setAyatFontSize(
                                                _ayatFontSize - 1,
                                              );
                                            }
                                          : null,
                                      icon: const Icon(Icons.remove),
                                      label: const Text('Kecil'),
                                    ),
                                    const SizedBox(width: 8),
                                    ElevatedButton.icon(
                                      onPressed:
                                          _ayatFontSize <
                                              FontSizeService.maxFontSize
                                          ? () {
                                              _setAyatFontSize(
                                                _ayatFontSize + 1,
                                              );
                                            }
                                          : null,
                                      icon: const Icon(Icons.add),
                                      label: const Text('Besar'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            // Slider
                            Slider(
                              value: _ayatFontSize,
                              min: FontSizeService.minFontSize,
                              max: FontSizeService.maxFontSize,
                              divisions: 20,
                              label: _ayatFontSize.toStringAsFixed(1),
                              onChanged: _setAyatFontSize,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Normal Font Size Section
                    Card(
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Ukuran Font Biasa',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Preview
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.green[50],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.green[200]!),
                              ),
                              child: Text(
                                'Ini adalah contoh teks dengan ukuran font biasa yang dapat disesuaikan.',
                                style: TextStyle(
                                  fontSize: _normalFontSize,
                                  color: Colors.green[900],
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Size Display and Controls
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Ukuran Saat Ini',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      '${_normalFontSize.toStringAsFixed(1)}',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    ElevatedButton.icon(
                                      onPressed:
                                          _normalFontSize >
                                              FontSizeService.minFontSize
                                          ? () {
                                              _setNormalFontSize(
                                                _normalFontSize - 1,
                                              );
                                            }
                                          : null,
                                      icon: const Icon(Icons.remove),
                                      label: const Text('Kecil'),
                                    ),
                                    const SizedBox(width: 8),
                                    ElevatedButton.icon(
                                      onPressed:
                                          _normalFontSize <
                                              FontSizeService.maxFontSize
                                          ? () {
                                              _setNormalFontSize(
                                                _normalFontSize + 1,
                                              );
                                            }
                                          : null,
                                      icon: const Icon(Icons.add),
                                      label: const Text('Besar'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            // Slider
                            Slider(
                              value: _normalFontSize,
                              min: FontSizeService.minFontSize,
                              max: FontSizeService.maxFontSize,
                              divisions: 20,
                              label: _normalFontSize.toStringAsFixed(1),
                              onChanged: _setNormalFontSize,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Reset Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Reset ke Default'),
                              content: const Text(
                                'Apakah Anda yakin ingin mereset ukuran font ke nilai default?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Batal'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    _resetToDefaults();
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Reset'),
                                ),
                              ],
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[400],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('Reset ke Default'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
