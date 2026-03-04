import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AudioService {
  static const String _selectedSoundKey = 'selected_alarm_sound';

  static final AudioPlayer _player = AudioPlayer();
  static String? _currentlyPlayingKey;

  /// Stream yang emit ketika suara selesai diputar.
  /// Di-listen di SettingsPage untuk auto-reset tombol play.
  static Stream<void> get playerCompleteStream =>
      _player.onPlayerComplete.map((_) => null);

  /// 4 pilihan suara.
  ///
  /// 'asset' → assets/audio/<nama>.mp3       (preview di app)
  /// 'raw'   → android/.../res/raw/<nama>    (tanpa ekstensi, notif Android)
  /// 'ios'   → ios/Runner/<nama>.mp3         (notif iOS)
  static const List<Map<String, String>> sounds = [
    {
      'key': 'default',
      'name': 'Default (Sistem)',
      // Tanpa asset/raw/ios → sistem pakai suara bawaan perangkat
    },
    {
      'key': 'adzan1',
      'name': 'Adzan 1',
      'asset': 'audio/adzan1.mp3',
      'raw': 'adzan1',
      'ios': 'adzan1.mp3',
    },
    {
      'key': 'adzan2',
      'name': 'Adzan 2',
      'asset': 'audio/adzan2.mp3',
      'raw': 'adzan2',
      'ios': 'adzan2.mp3',
    },
    {
      'key': 'adzan3',
      'name': 'Adzan 3',
      'asset': 'audio/adzan3.mp3',
      'raw': 'adzan3',
      'ios': 'adzan3.mp3',
    },
  ];

  // ── Preferensi ──────────────────────────────────

  static Future<String> getSelectedAlarmSound() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_selectedSoundKey) ?? 'default';
  }

  static Future<void> setSelectedAlarmSound(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_selectedSoundKey, key);
  }

  static Map<String, String>? getSoundByKey(String key) {
    try {
      return sounds.firstWhere((s) => s['key'] == key);
    } catch (_) {
      return sounds.first;
    }
  }

  // ── Preview ─────────────────────────────────────

  /// Toggle preview: play jika belum diputar, stop jika sudah diputar.
  /// Mengembalikan true jika mulai memutar, false jika berhenti.
  static Future<bool> togglePreview(String key) async {
    // Suara yang sama diklik lagi → stop
    if (_currentlyPlayingKey == key) {
      await stopPreview();
      return false;
    }

    // Hentikan suara sebelumnya
    await stopPreview();

    final sound = getSoundByKey(key);
    if (sound == null || !sound.containsKey('asset')) return false;

    _currentlyPlayingKey = key;
    await _player.play(AssetSource(sound['asset']!));

    // Auto-reset saat selesai
    _player.onPlayerComplete.first.then((_) {
      _currentlyPlayingKey = null;
    });

    return true;
  }

  /// Stop preview. Dipanggil dari dispose() SettingsPage agar audio
  /// otomatis berhenti saat pengguna keluar dari halaman.
  static Future<void> stopPreview() async {
    await _player.stop();
    _currentlyPlayingKey = null;
  }

  /// Key suara yang sedang diputar, null jika tidak ada.
  static String? get currentlyPlayingKey => _currentlyPlayingKey;

  // ── Helper untuk PrayerNotificationService ──────

  /// Raw resource Android (tanpa ekstensi). Null = suara default sistem.
  static String? getAndroidRaw(String key) => getSoundByKey(key)?['raw'];

  /// File suara iOS. Null = suara default sistem.
  static String? getIOSSound(String key) => getSoundByKey(key)?['ios'];
}
