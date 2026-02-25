import 'package:flutter/material.dart';
import '../services/font_size_service.dart';
import '../services/prayer_notification_service.dart';
import '../services/audio_service.dart'; // perlu dibuat service ini

class SettingsPage extends StatefulWidget {
  final VoidCallback onFontChanged;

  const SettingsPage({super.key, required this.onFontChanged});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late double _ayatFontSize;
  late double _normalFontSize;
  // Pengaturan notifikasi
  late Map<String, bool> _prayerStates = {};
  late int _advanceMinutes;
  late String _selectedAlarmSound;
  bool isLoading = true;

  // Daftar suara alarm (contoh)
  final List<Map<String, String>> _alarmSounds = [
    {'key': 'default', 'name': 'Suara Default'},
    {'key': 'adhan1', 'name': 'Adhan 1'},
    {'key': 'adhan2', 'name': 'Adhan 2'},
    {'key': 'notification1', 'name': 'Notifikasi 1'},
  ];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    // Muat ukuran font
    final ayatSize = await FontSizeService.getAyatFontSize();
    final normalSize = await FontSizeService.getNormalFontSize();

    // Muat pengaturan notifikasi
    final states = <String, bool>{};
    for (String prayer in PrayerNotificationService.prayerNames.keys) {
      states[prayer] =
          await PrayerNotificationService.isPrayerNotificationEnabled(prayer);
    }
    final advanceTime =
        await PrayerNotificationService.getNotificationAdvanceTime();

    // Muat suara alarm (default 'default')
    final alarmSound = await AudioService.getSelectedAlarmSound();

    setState(() {
      _ayatFontSize = ayatSize;
      _normalFontSize = normalSize;
      _prayerStates = states;
      _advanceMinutes = advanceTime;
      _selectedAlarmSound = alarmSound;
      isLoading = false;
    });
  }

  Future<void> _togglePrayerNotification(String prayer, bool value) async {
    await PrayerNotificationService.setPrayerNotificationEnabled(prayer, value);
    setState(() {
      _prayerStates[prayer] = value;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          value
              ? 'Notifikasi ${PrayerNotificationService.prayerNames[prayer]} diaktifkan'
              : 'Notifikasi ${PrayerNotificationService.prayerNames[prayer]} dinonaktifkan',
        ),
        backgroundColor: value ? Colors.green : Colors.orange,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _setAdvanceTime(int minutes) async {
    await PrayerNotificationService.setNotificationAdvanceTime(minutes);
    setState(() {
      _advanceMinutes = minutes;
    });
  }

  Future<void> _setAlarmSound(String soundKey) async {
    await AudioService.setSelectedAlarmSound(soundKey);
    setState(() {
      _selectedAlarmSound = soundKey;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Suara alarm diubah'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
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
    // Reset notifikasi? Mungkin tidak perlu, biarkan sesuai kebutuhan.
    await _loadSettings(); // reload semua
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pengaturan font direset ke default')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
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
                    // --- Bagian Notifikasi Sholat (langsung di sini) ---
                    Card(
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 16),
                      color: Colors.green[50],
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.notifications_active,
                                  color: Colors.green[700],
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Notifikasi Sholat',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green[700],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Aktifkan notifikasi untuk menerima pengingat waktu sholat',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.green[600],
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Daftar toggle per sholat
                            ..._prayerStates.entries.map((entry) {
                              final prayer = entry.key;
                              final isEnabled = entry.value;
                              final prayerName =
                                  PrayerNotificationService
                                      .prayerNames[prayer] ??
                                  prayer;

                              return Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      prayerName,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    Switch(
                                      value: isEnabled,
                                      onChanged: (value) =>
                                          _togglePrayerNotification(
                                            prayer,
                                            value,
                                          ),
                                      activeColor: Colors.green,
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),

                            const Divider(height: 24),

                            // Waktu pengingat
                            const Text(
                              'Pengingat Sebelum Adzan',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Waktu pengingat'),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.green[100],
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    '$_advanceMinutes menit',
                                    style: TextStyle(color: Colors.green[700]),
                                  ),
                                ),
                              ],
                            ),
                            Slider(
                              value: _advanceMinutes.toDouble(),
                              min: 0,
                              max: 30,
                              divisions: 30,
                              label: '$_advanceMinutes menit',
                              onChanged: (value) =>
                                  _setAdvanceTime(value.toInt()),
                            ),
                            const SizedBox(height: 8),

                            // Pilihan suara alarm
                            const Text(
                              'Suara Alarm',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.green[200]!),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: DropdownButton<String>(
                                value: _selectedAlarmSound,
                                isExpanded: true,
                                underline: const SizedBox(),
                                items: _alarmSounds.map((sound) {
                                  return DropdownMenuItem(
                                    value: sound['key'],
                                    child: Text(sound['name']!),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  if (value != null) _setAlarmSound(value);
                                },
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Tombol aksi cepat
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () async {
                                      await PrayerNotificationService.setAllNotificationsEnabled(
                                        true,
                                      );
                                      await _loadSettings();
                                    },
                                    icon: const Icon(Icons.done_all),
                                    label: const Text('Aktifkan Semua'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      foregroundColor: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () async {
                                      await PrayerNotificationService.setAllNotificationsEnabled(
                                        false,
                                      );
                                      await _loadSettings();
                                    },
                                    icon: const Icon(Icons.clear_all),
                                    label: const Text('Nonaktifkan Semua'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey[400],
                                      foregroundColor: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    // --- Ukuran Font Ayat ---
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
                                style: TextStyle(
                                  fontFamily: 'Quran12',
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
                                          ? () => _setAyatFontSize(
                                              _ayatFontSize - 1,
                                            )
                                          : null,
                                      icon: const Icon(Icons.remove),
                                      label: const Text('Kecil'),
                                    ),
                                    const SizedBox(width: 8),
                                    ElevatedButton.icon(
                                      onPressed:
                                          _ayatFontSize <
                                              FontSizeService.maxFontSize
                                          ? () => _setAyatFontSize(
                                              _ayatFontSize + 1,
                                            )
                                          : null,
                                      icon: const Icon(Icons.add),
                                      label: const Text('Besar'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
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

                    // --- Ukuran Font Biasa ---
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
                                          ? () => _setNormalFontSize(
                                              _normalFontSize - 1,
                                            )
                                          : null,
                                      icon: const Icon(Icons.remove),
                                      label: const Text('Kecil'),
                                    ),
                                    const SizedBox(width: 8),
                                    ElevatedButton.icon(
                                      onPressed:
                                          _normalFontSize <
                                              FontSizeService.maxFontSize
                                          ? () => _setNormalFontSize(
                                              _normalFontSize + 1,
                                            )
                                          : null,
                                      icon: const Icon(Icons.add),
                                      label: const Text('Besar'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
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

                    // --- Tombol Reset (hanya reset font) ---
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Reset ke Default'),
                              content: const Text(
                                'Apakah Anda yakin ingin mereset ukuran font ke nilai default? (Pengaturan notifikasi tidak berubah)',
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
                        child: const Text('Reset Ukuran Font ke Default'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
