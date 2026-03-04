import 'package:flutter/material.dart';
import '../services/audio_service.dart';
import '../services/font_size_service.dart';
import '../services/prayer_notification_service.dart';

class SettingsPage extends StatefulWidget {
  final VoidCallback onFontChanged;
  const SettingsPage({super.key, required this.onFontChanged});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // Font
  late double _ayatFontSize;
  late double _normalFontSize;

  // Notifikasi
  Map<String, bool> _prayerStates = {};
  late int _advanceMinutes;

  // Audio
  late String _selectedSoundKey;
  String? _previewingKey;

  bool _isLoading = true;

  // ── Init & Dispose ──────────────────────────────

  @override
  void initState() {
    super.initState();
    _loadAll();

    // Reset tombol play ketika suara selesai diputar
    AudioService.playerCompleteStream.listen((_) {
      if (mounted) setState(() => _previewingKey = null);
    });
  }

  @override
  void dispose() {
    // Hentikan audio otomatis saat keluar halaman
    AudioService.stopPreview();
    super.dispose();
  }

  Future<void> _loadAll() async {
    setState(() => _isLoading = true);

    final ayat = await FontSizeService.getAyatFontSize();
    final normal = await FontSizeService.getNormalFontSize();

    final states = <String, bool>{};
    for (final p in PrayerNotificationService.prayerNames.keys) {
      states[p] = await PrayerNotificationService.isPrayerNotificationEnabled(
        p,
      );
    }
    final advance =
        await PrayerNotificationService.getNotificationAdvanceTime();
    final sound = await AudioService.getSelectedAlarmSound();

    setState(() {
      _ayatFontSize = ayat;
      _normalFontSize = normal;
      _prayerStates = states;
      _advanceMinutes = advance;
      _selectedSoundKey = sound;
      _isLoading = false;
    });
  }

  // ── Notifikasi ──────────────────────────────────

  Future<void> _togglePrayer(String prayer, bool value) async {
    await PrayerNotificationService.setPrayerNotificationEnabled(prayer, value);
    setState(() => _prayerStates[prayer] = value);
    final name = PrayerNotificationService.prayerNames[prayer]!;
    _snack(
      value ? 'Notifikasi $name diaktifkan' : 'Notifikasi $name dinonaktifkan',
      color: value ? Colors.green : Colors.orange,
    );
  }

  Future<void> _setAdvance(int minutes) async {
    await PrayerNotificationService.setNotificationAdvanceTime(minutes);
    setState(() => _advanceMinutes = minutes);
  }

  // ── Audio ───────────────────────────────────────

  /// Dipanggil saat pengguna mengetuk item suara.
  /// → Simpan pilihan + langsung putar preview otomatis.
  Future<void> _selectSound(String key) async {
    // Simpan sebagai alarm
    await AudioService.setSelectedAlarmSound(key);
    setState(() => _selectedSoundKey = key);

    // Default tidak punya audio → stop saja, tidak play
    if (key == 'default') {
      await AudioService.stopPreview();
      setState(() => _previewingKey = null);
      _snack(
        'Suara default dipilih (suara bawaan perangkat)',
        color: Colors.grey[700]!,
      );
      return;
    }

    // Putar otomatis sebagai preview
    final isPlaying = await AudioService.togglePreview(key);
    setState(() => _previewingKey = isPlaying ? key : null);
  }

  /// Dipanggil khusus tombol ▶/■ di sebelah kanan item.
  /// Toggle: play jika belum diputar, stop jika sedang diputar.
  Future<void> _togglePreview(String key) async {
    if (key == 'default') return;
    final isPlaying = await AudioService.togglePreview(key);
    setState(() => _previewingKey = isPlaying ? key : null);
  }

  // ── Font ────────────────────────────────────────

  Future<void> _setAyat(double v) async {
    await FontSizeService.setAyatFontSize(v);
    setState(() => _ayatFontSize = v);
    widget.onFontChanged();
  }

  Future<void> _setNormal(double v) async {
    await FontSizeService.setNormalFontSize(v);
    setState(() => _normalFontSize = v);
    widget.onFontChanged();
  }

  Future<void> _resetFonts() async {
    await FontSizeService.resetToDefaults();
    await _loadAll();
    widget.onFontChanged();
    _snack('Font direset ke default');
  }

  void _snack(String msg, {Color color = Colors.green}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: color,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ── Build ────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.green),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildNotifCard(),
                  const SizedBox(height: 16),
                  _buildSoundCard(),
                  const SizedBox(height: 16),
                  _buildFontCard('Ukuran Font Ayat', isAyat: true),
                  const SizedBox(height: 16),
                  _buildFontCard('Ukuran Font Biasa', isAyat: false),
                  const SizedBox(height: 16),
                  _buildResetBtn(),
                  const SizedBox(height: 32),
                ],
              ),
            ),
    );
  }

  // ── Card Notifikasi ─────────────────────────────

  Widget _buildNotifCard() {
    return Card(
      elevation: 2,
      color: Colors.green[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(Icons.notifications_active, 'Notifikasi Sholat'),
            const SizedBox(height: 4),
            Text(
              'Aktifkan pengingat untuk setiap waktu sholat wajib.',
              style: TextStyle(fontSize: 13, color: Colors.green[600]),
            ),
            const SizedBox(height: 16),

            ..._prayerStates.entries.map((entry) {
              final prayer = entry.key;
              final enabled = entry.value;
              final name = PrayerNotificationService.prayerNames[prayer]!;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(name, style: const TextStyle(fontSize: 15)),
                    ),
                    Switch(
                      value: enabled,
                      activeColor: Colors.green,
                      onChanged: (v) => _togglePrayer(prayer, v),
                    ),
                  ],
                ),
              );
            }),

            const Divider(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Pengingat sebelum adzan',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                _chip(
                  _advanceMinutes == 0
                      ? 'Tepat waktu'
                      : '$_advanceMinutes menit',
                ),
              ],
            ),
            Slider(
              value: _advanceMinutes.toDouble(),
              min: 0,
              max: 30,
              divisions: 30,
              label: _advanceMinutes == 0
                  ? 'Tepat waktu'
                  : '$_advanceMinutes menit',
              activeColor: Colors.green,
              onChanged: (v) => _setAdvance(v.toInt()),
            ),
            Text(
              _advanceMinutes == 0
                  ? 'Notifikasi tepat saat adzan'
                  : 'Notifikasi $_advanceMinutes menit sebelum adzan',
              style: TextStyle(fontSize: 12, color: Colors.green[600]),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await PrayerNotificationService.setAllNotificationsEnabled(
                        true,
                      );
                      await _loadAll();
                    },
                    icon: const Icon(Icons.done_all, size: 18),
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
                      await _loadAll();
                    },
                    icon: const Icon(Icons.clear_all, size: 18),
                    label: const Text('Nonaktifkan Semua'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[400],
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.amber[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber[200]!),
              ),
              child: Row(
                // children: [
                //   Icon(Icons.info_outline, size: 15, color: Colors.amber[700]),
                //   const SizedBox(width: 8),
                //   Expanded(
                //     child: Text(
                //       'Buka halaman Jadwal Sholat setelah mengubah pengaturan '
                //       'agar notifikasi dijadwalkan ulang.',
                //       style: TextStyle(fontSize: 12, color: Colors.amber[800]),
                //     ),
                //   ),
                // ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Card Suara ──────────────────────────────────

  Widget _buildSoundCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(Icons.music_note, 'Suara Notifikasi'),
            const SizedBox(height: 4),
            const Text(
              'Ketuk untuk memilih & preview otomatis. Tombol ■ untuk stop.',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 16),

            ...AudioService.sounds.map((sound) {
              final key = sound['key']!;
              final name = sound['name']!;
              final isSelected = _selectedSoundKey == key;
              final isPlaying = _previewingKey == key;
              final hasAudio = sound.containsKey('asset');

              return GestureDetector(
                onTap: () => _selectSound(key),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.green[50] : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? Colors.green : Colors.grey[300]!,
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: Colors.green.withOpacity(0.15),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : [],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    child: Row(
                      children: [
                        // Radio button
                        Radio<String>(
                          value: key,
                          groupValue: _selectedSoundKey,
                          activeColor: Colors.green,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          onChanged: (v) => _selectSound(v!),
                        ),
                        const SizedBox(width: 4),

                        // Nama + status
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                  color: isSelected
                                      ? Colors.green[800]
                                      : Colors.black87,
                                ),
                              ),
                              if (isPlaying) ...[
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.graphic_eq,
                                      size: 13,
                                      color: Colors.green[600],
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Sedang diputar...',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.green[600],
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ],
                                ),
                              ] else if (isSelected && !hasAudio) ...[
                                const SizedBox(height: 2),
                                Text(
                                  'Suara bawaan perangkat',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),

                        // Tombol play/stop (hanya untuk suara yang punya asset)
                        if (hasAudio)
                          GestureDetector(
                            // Tombol ini khusus toggle, tidak trigger _selectSound
                            onTap: () => _togglePreview(key),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: isPlaying
                                    ? Colors.green
                                    : Colors.green[50],
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.green,
                                  width: 1.5,
                                ),
                              ),
                              child: Icon(
                                isPlaying
                                    ? Icons.stop_rounded
                                    : Icons.play_arrow_rounded,
                                color: isPlaying ? Colors.white : Colors.green,
                                size: 24,
                              ),
                            ),
                          )
                        else
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.volume_up_rounded,
                              color: Colors.grey[400],
                              size: 20,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  // ── Card Font ───────────────────────────────────

  Widget _buildFontCard(String title, {required bool isAyat}) {
    final size = isAyat ? _ayatFontSize : _normalFontSize;
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
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
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green[200]!),
              ),
              child: Text(
                isAyat
                    ? 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ'
                    : 'Contoh teks ukuran font biasa',
                textAlign: isAyat ? TextAlign.right : TextAlign.left,
                style: TextStyle(
                  fontFamily: isAyat ? 'Quran12' : null,
                  fontSize: size,
                  color: Colors.green[900],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ukuran',
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                    Text(
                      size.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: size > FontSizeService.minFontSize
                          ? () => isAyat
                                ? _setAyat(size - 1)
                                : _setNormal(size - 1)
                          : null,
                      icon: const Icon(Icons.remove, size: 16),
                      label: const Text('Kecil'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: size < FontSizeService.maxFontSize
                          ? () => isAyat
                                ? _setAyat(size + 1)
                                : _setNormal(size + 1)
                          : null,
                      icon: const Icon(Icons.add, size: 16),
                      label: const Text('Besar'),
                    ),
                  ],
                ),
              ],
            ),
            Slider(
              value: size,
              min: FontSizeService.minFontSize,
              max: FontSizeService.maxFontSize,
              divisions: 20,
              label: size.toStringAsFixed(1),
              activeColor: Colors.green,
              onChanged: isAyat ? _setAyat : _setNormal,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResetBtn() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Reset Font ke Default'),
            content: const Text(
              'Reset ukuran font ke nilai default?\nPengaturan notifikasi tidak berubah.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _resetFonts();
                },
                child: const Text('Reset', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ),
        icon: const Icon(Icons.refresh, color: Colors.grey),
        label: const Text(
          'Reset Ukuran Font ke Default',
          style: TextStyle(color: Colors.grey),
        ),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _header(IconData icon, String label) => Row(
    children: [
      Icon(icon, color: Colors.green[700]),
      const SizedBox(width: 8),
      Text(
        label,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.green[700],
        ),
      ),
    ],
  );

  Widget _chip(String text) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    decoration: BoxDecoration(
      color: Colors.green[100],
      borderRadius: BorderRadius.circular(16),
    ),
    child: Text(text, style: TextStyle(color: Colors.green[700], fontSize: 13)),
  );
}
