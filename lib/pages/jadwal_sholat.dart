import 'package:flutter/material.dart';
import 'dart:async';
import '../services/location_service.dart';

class JadwalSholatPage extends StatefulWidget {
  const JadwalSholatPage({super.key});

  @override
  State<JadwalSholatPage> createState() => _JadwalSholatPageState();
}

class _JadwalSholatPageState extends State<JadwalSholatPage> {
  String selectedTimeZone = "WIB";
  DateTime selectedDate = DateTime.now();
  double userLatitude = LocationService.defaultLatitude;
  double userLongitude = LocationService.defaultLongitude;
  String userLocation = "Jakarta (Default)";
  bool isLoadingLocation = true;
  Timer? _updateTimer;

  @override
  void initState() {
    super.initState();
    _loadUserLocation();
    // Update UI setiap detik untuk real-time
    _updateTimer = Timer.periodic(Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  Future<void> _loadUserLocation() async {
    try {
      final location = await LocationService.getCurrentLocation();
      final latitude = location['latitude']!;
      final longitude = location['longitude']!;

      // Calculate timezone from longitude
      final offset = LocationService.calculateTimezoneOffset(longitude);
      final timezoneString = LocationService.getTimezoneString(offset);

      // Get place name
      final placeName = await LocationService.getPlaceName(latitude, longitude);

      if (mounted) {
        setState(() {
          userLatitude = latitude;
          userLongitude = longitude;
          selectedTimeZone = timezoneString;
          userLocation = placeName;
          isLoadingLocation = false;
        });
      }
    } catch (e) {
      print('Error loading location: $e');
      if (mounted) {
        setState(() {
          isLoadingLocation = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    super.dispose();
  }

  // Mapping zona waktu ke offset jam dari WIB
  Map<String, int> timeZoneOffsets = {
    "WIB": 0, // Waktu Indonesia Barat (UTC+7)
    "WITA": 1, // Waktu Indonesia Tengah (UTC+8)
    "WIT": 2, // Waktu Indonesia Timur (UTC+9)
  };

  // Data jadwal sholat base (WIB - Waktu Indonesia Barat)
  List<Map<String, dynamic>> get jadwalSholatBase {
    return [
      {"name": "Subuh", "time": "04:30", "order": 1, "type": "wajib"},
      {"name": "Syuruq", "time": "05:45", "order": 2, "type": "sunah"},
      {"name": "Duha", "time": "06:15", "order": 3, "type": "sunah_sekolah"},
      {"name": "Dzuhur", "time": "11:30", "order": 4, "type": "wajib"},
      {"name": "Ashar", "time": "15:15", "order": 5, "type": "wajib"},
      {"name": "Maghrib", "time": "18:05", "order": 6, "type": "wajib"},
      {"name": "Isya", "time": "19:20", "order": 7, "type": "wajib"},
    ];
  }

  // Sesuaikan waktu sholat berdasarkan zona waktu yang dipilih
  List<Map<String, dynamic>> get jadwalSholat {
    final now = DateTime.now();
    final currentTime = TimeOfDay.fromDateTime(now);
    final offset = timeZoneOffsets[selectedTimeZone] ?? 0;

    List<Map<String, dynamic>> sholat = [];

    for (var item in jadwalSholatBase) {
      final baseTime = _parseTime(item["time"]);
      // Tambahkan offset zona waktu
      int newHour = (baseTime.hour + offset) % 24;
      final newTime =
          "${newHour.toString().padLeft(2, '0')}:${baseTime.minute.toString().padLeft(2, '0')}";

      final Map<String, dynamic> adjustedItem = Map.from(item);
      adjustedItem["time"] = newTime;
      adjustedItem["passed"] = false;
      adjustedItem["isNext"] = false;

      sholat.add(adjustedItem);
    }

    // Hitung status passed berdasarkan waktu sekarang
    for (var sholatItem in sholat) {
      final sholatTime = _parseTime(sholatItem["time"]);
      final isPassed =
          currentTime.hour > sholatTime.hour ||
          (currentTime.hour == sholatTime.hour &&
              currentTime.minute >= sholatTime.minute);

      sholatItem["passed"] = isPassed;
    }

    // Tentukan sholat berikutnya (yang belum lewat pertama)
    try {
      final nextSholatList = sholat
          .where((item) => !item["passed"] && item["type"] == "wajib")
          .toList();

      if (nextSholatList.isNotEmpty) {
        nextSholatList.first["isNext"] = true;
      } else {
        final wajibList = sholat
            .where((item) => item["type"] == "wajib")
            .toList();
        if (wajibList.isNotEmpty) {
          wajibList.first["isNext"] = true;
        }
      }
    } catch (e) {
      print("Error setting next sholat: $e");
    }

    return sholat;
  }

  // Parse waktu string ke TimeOfDay
  TimeOfDay _parseTime(String timeString) {
    final parts = timeString.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  // Daftar zona waktu Indonesia
  final List<String> timeZones = [
    "WIB", // Waktu Indonesia Barat
    "WITA", // Waktu Indonesia Tengah
    "WIT", // Waktu Indonesia Timur
  ];

  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        "Jadwal Sholat",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Colors.black87,
        ),
      ),
      centerTitle: false,
      backgroundColor: Colors.white,
      elevation: 1,
      iconTheme: const IconThemeData(color: Colors.black87),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Lokasi User
          Row(
            children: [
              Icon(Icons.location_on, color: Colors.green[600], size: 20),
              const SizedBox(width: 8),
              Text(
                "Lokasi Anda",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (isLoadingLocation)
            const SizedBox(
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              ),
            )
          else
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green[100]!),
              ),
              child: Text(
                userLocation,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.green[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          const SizedBox(height: 16),

          // Zona Waktu
          Row(
            children: [
              Icon(Icons.schedule, color: Colors.green[600], size: 20),
              const SizedBox(width: 8),
              Text(
                "Zona Waktu",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButton<String>(
              isExpanded: true,
              value: selectedTimeZone,
              underline: const SizedBox(),
              items: timeZones.map((String tz) {
                return DropdownMenuItem<String>(value: tz, child: Text(tz));
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedTimeZone = newValue!;
                });
              },
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _getTimeZoneDescription(selectedTimeZone),
            style: TextStyle(fontSize: 12, color: Colors.grey[500]),
          ),
          const SizedBox(height: 16),

          // Tanggal
          Row(
            children: [
              Icon(Icons.calendar_today, color: Colors.green[600], size: 20),
              const SizedBox(width: 8),
              Text(
                "Tanggal",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: _selectDate,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _formatDate(selectedDate),
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Waktu Sekarang (Real-time)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green[50],
              border: Border.all(color: Colors.green[100]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Waktu Sekarang",
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(height: 8),
                Text(
                  _formatTime(DateTime.now()),
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700],
                    fontFamily: 'monospace',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatDate(DateTime.now()),
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk sholat sunah yang diwajibkan sekolah (Duha)
  Widget _buildSholatSekolahCard() {
    final duhaSholat = jadwalSholat.firstWhere(
      (item) => item["name"] == "Duha",
      orElse: () => {},
    );

    if (duhaSholat.isEmpty) return const SizedBox();

    bool isPassed = duhaSholat["passed"] as bool;
    final sholatTime = duhaSholat["time"] as String;
    final sholatTimeObj = _parseTime(sholatTime);
    final now = DateTime.now();
    final currentTime = TimeOfDay.fromDateTime(now);

    // Hitung berapa menit lagi sampai sholat Duha (jika belum lewat)
    int minutesRemaining = 0;
    if (!isPassed) {
      int totalCurrentMinutes = currentTime.hour * 60 + currentTime.minute;
      int totalSholatMinutes = sholatTimeObj.hour * 60 + sholatTimeObj.minute;
      minutesRemaining = totalSholatMinutes - totalCurrentMinutes;
    }

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isPassed ? Colors.orange[50] : Colors.orange[100],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPassed ? Colors.orange[200]! : Colors.orange[400]!,
          width: isPassed ? 1 : 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(isPassed ? 0.05 : 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.wb_sunny_rounded, color: Colors.orange[700], size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Sholat Duha (Wajib Sekolah)",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange[800],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isPassed ? "Telah lewat" : "Akan dimulai",
                      style: TextStyle(fontSize: 12, color: Colors.orange[600]),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    sholatTime,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange[800],
                      fontFamily: 'monospace',
                    ),
                  ),
                  if (!isPassed)
                    Text(
                      "dalam $minutesRemaining menit",
                      style: TextStyle(fontSize: 11, color: Colors.orange[600]),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Mulai",
                      style: TextStyle(fontSize: 11, color: Colors.orange[600]),
                    ),
                    Text(
                      sholatTime,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.orange[800],
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Durasi",
                      style: TextStyle(fontSize: 11, color: Colors.orange[600]),
                    ),
                    Text(
                      "±15 menit",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.orange[800],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Akhir",
                      style: TextStyle(fontSize: 11, color: Colors.orange[600]),
                    ),
                    Text(
                      _addMinutesToTime(sholatTime, 15),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.orange[800],
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(color: Colors.orange[300], height: 1),
          const SizedBox(height: 12),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Catatan: ",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[800],
                  ),
                ),
                TextSpan(
                  text:
                      "Sholat Duha adalah sholat sunah yang diprogramkan sebagai kegiatan wajib di sekolah. Waktu optimal adalah 2 jam setelah matahari terbit hingga menjelang Dzuhur.",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.orange[700],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSholatItem(Map<String, dynamic> sholat, int index) {
    bool isPassed = sholat["passed"] as bool;
    bool isNext = sholat["isNext"] as bool;
    String type = sholat["type"] as String;

    // Skip Duha karena sudah ada card khusus
    if (sholat["name"] == "Duha") return const SizedBox();

    Color primaryColor;
    IconData icon;

    if (type == "wajib") {
      primaryColor = isNext ? Colors.green[600]! : Colors.grey[500]!;
      icon = _getSholatIcon(sholat["name"]);
    } else {
      primaryColor = Colors.blue[600]!;
      icon = Icons.wb_sunny;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.1),
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Ikon
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(icon, color: primaryColor, size: 24),
                  ),
                ),
                const SizedBox(width: 16),

                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sholat["name"],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isPassed
                            ? "Telah lewat"
                            : (isNext ? "Berikutnya" : "Akan datang"),
                        style: TextStyle(
                          fontSize: 12,
                          color: isPassed
                              ? Colors.grey[500]
                              : (isNext ? Colors.green[600] : Colors.grey[500]),
                          fontWeight: isNext
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),

                // Waktu
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      sholat["time"],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isPassed ? Colors.grey[400] : primaryColor,
                        fontFamily: 'monospace',
                      ),
                    ),
                    if (isNext)
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green[100],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          "Next",
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.green[700],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSholatList() {
    final currentSholat = jadwalSholat;

    // Cek jika semua sholat wajib sudah lewat (malam hari), maka Subuh besok adalah berikutnya
    final wajibList = currentSholat
        .where((item) => item["type"] == "wajib")
        .toList();
    final allPassed = wajibList.every((item) => item["passed"]);

    if (allPassed && wajibList.isNotEmpty) {
      final subuhList = currentSholat
          .where((item) => item["name"] == "Subuh")
          .toList();
      if (subuhList.isNotEmpty) {
        subuhList.first["isNext"] = true;
        subuhList.first["passed"] = false;
      }
    }

    return Column(
      children: [
        const SizedBox(height: 8),
        ...currentSholat.asMap().entries.map((entry) {
          return _buildSholatItem(entry.value, entry.key);
        }).toList(),
      ],
    );
  }

  String _formatTime(DateTime date) {
    return "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}";
  }

  String _formatDate(DateTime date) {
    final months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    final days = [
      'Minggu',
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
    ];

    return "${days[date.weekday - 1]}, ${date.day} ${months[date.month - 1]} ${date.year}";
  }

  String _addMinutesToTime(String timeString, int minutes) {
    final parts = timeString.split(':');
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);

    minute += minutes;
    if (minute >= 60) {
      hour += minute ~/ 60;
      minute = minute % 60;
      hour = hour % 24;
    }

    return "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}";
  }

  IconData _getSholatIcon(String sholatName) {
    switch (sholatName) {
      case "Subuh":
        return Icons.nightlight_round;
      case "Syuruq":
        return Icons.wb_sunny;
      case "Dzuhur":
        return Icons.brightness_high;
      case "Ashar":
        return Icons.brightness_medium;
      case "Maghrib":
        return Icons.brightness_low;
      case "Isya":
        return Icons.nights_stay;
      default:
        return Icons.access_time;
    }
  }

  String _getTimeZoneDescription(String timeZone) {
    switch (timeZone) {
      case "WIB":
        return "Waktu Indonesia Barat (UTC+7)";
      case "WITA":
        return "Waktu Indonesia Tengah (UTC+8)";
      case "WIT":
        return "Waktu Indonesia Timur (UTC+9)";
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderCard(),
            _buildSholatSekolahCard(),
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
              child: Text(
                "Jadwal Sholat Wajib",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
            ),
            _buildSholatList(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
