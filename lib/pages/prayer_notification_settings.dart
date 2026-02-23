import 'package:flutter/material.dart';
import '../services/prayer_notification_service.dart';

class PrayerNotificationSettingsPage extends StatefulWidget {
  const PrayerNotificationSettingsPage({super.key});

  @override
  State<PrayerNotificationSettingsPage> createState() =>
      _PrayerNotificationSettingsPageState();
}

class _PrayerNotificationSettingsPageState
    extends State<PrayerNotificationSettingsPage> {
  late Map<String, bool> _prayerStates = {};
  late int _advanceMinutes;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final states = <String, bool>{};
    for (String prayer in PrayerNotificationService.prayerNames.keys) {
      states[prayer] =
          await PrayerNotificationService.isPrayerNotificationEnabled(prayer);
    }

    final advanceTime =
        await PrayerNotificationService.getNotificationAdvanceTime();

    setState(() {
      _prayerStates = states;
      _advanceMinutes = advanceTime;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifikasi Sholat'),
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
                    // Info Section
                    Card(
                      color: Colors.green[50],
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Colors.green[700],
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Aktifkan notifikasi untuk menerima pengingat waktu sholat',
                                style: TextStyle(
                                  color: Colors.green[700],
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Prayer Notifications Section
                    const Text(
                      'Waktu Sholat',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Prayer Notification Toggles
                    ..._prayerStates.entries.map((entry) {
                      final prayer = entry.key;
                      final isEnabled = entry.value;
                      final prayerName =
                          PrayerNotificationService.prayerNames[prayer] ??
                              prayer;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  prayerName,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),
                                Switch(
                                  value: isEnabled,
                                  onChanged: (value) {
                                    _togglePrayerNotification(prayer, value);
                                  },
                                  activeColor: Colors.green,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),

                    const SizedBox(height: 24),

                    // Advance Time Section
                    const Text(
                      'Pengingat Sebelum Adzan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),

                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Waktu Pengingat',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.green[50],
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.green[200]!),
                                  ),
                                  child: Text(
                                    '$_advanceMinutes menit',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green[700],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Slider(
                              value: _advanceMinutes.toDouble(),
                              min: 0,
                              max: 30,
                              divisions: 30,
                              label: '$_advanceMinutes menit',
                              onChanged: (value) {
                                _setAdvanceTime(value.toInt());
                              },
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Anda akan menerima notifikasi $_advanceMinutes menit sebelum adzan',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Quick Actions
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              await PrayerNotificationService
                                  .setAllNotificationsEnabled(true);
                              await _loadSettings();
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Semua notifikasi diaktifkan'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              }
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
                              await PrayerNotificationService
                                  .setAllNotificationsEnabled(false);
                              await _loadSettings();
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Semua notifikasi dinonaktifkan'),
                                    backgroundColor: Colors.orange,
                                  ),
                                );
                              }
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
    );
  }
}
