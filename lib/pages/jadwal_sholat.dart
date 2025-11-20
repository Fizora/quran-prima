import 'package:flutter/material.dart';

class JadwalSholatPage extends StatefulWidget {
  const JadwalSholatPage({super.key});

  @override
  State<JadwalSholatPage> createState() => _JadwalSholatPageState();
}

class _JadwalSholatPageState extends State<JadwalSholatPage> {
  String selectedCity = "Jakarta";
  DateTime selectedDate = DateTime.now();

  // Data jadwal sholat dengan waktu yang realistis
  List<Map<String, dynamic>> get jadwalSholat {
    final now = DateTime.now();
    final currentTime = TimeOfDay.fromDateTime(now);

    // Contoh jadwal sholat (bisa disesuaikan)
    List<Map<String, dynamic>> sholat = [
      {"name": "Subuh", "time": "04:30", "order": 1},
      {"name": "Syuruq", "time": "05:45", "order": 2},
      {"name": "Dzuhur", "time": "12:00", "order": 3},
      {"name": "Ashar", "time": "15:15", "order": 4},
      {"name": "Maghrib", "time": "18:05", "order": 5},
      {"name": "Isya", "time": "19:20", "order": 6},
    ];

    // Hitung status passed dan next berdasarkan waktu sekarang
    for (var sholatItem in sholat) {
      final sholatTime = _parseTime(sholatItem["time"]);
      final isPassed =
          currentTime.hour > sholatTime.hour ||
          (currentTime.hour == sholatTime.hour &&
              currentTime.minute >= sholatTime.minute);

      sholatItem["passed"] = isPassed;
      sholatItem["isNext"] = false;
    }

    // Tentukan sholat berikutnya (yang belum lewat pertama)
    final nextSholat = sholat.firstWhere(
      (item) => !item["passed"],
      orElse: () => sholat.first, // Jika semua sudah lewat, ambil subuh besok
    );

    if (nextSholat.isNotEmpty) {
      nextSholat["isNext"] = true;
    }

    return sholat;
  }

  // Parse waktu string ke TimeOfDay
  TimeOfDay _parseTime(String timeString) {
    final parts = timeString.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  // Daftar kota
  final List<String> cities = [
    "Jakarta",
    "Bandung",
    "Surabaya",
    "Yogyakarta",
    "Medan",
    "Makassar",
    "Semarang",
    "Palembang",
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
          // Lokasi
          Row(
            children: [
              Icon(Icons.location_on, color: Colors.green[600], size: 20),
              const SizedBox(width: 8),
              Text(
                "Lokasi",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: selectedCity,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
            ),
            items: cities.map((String city) {
              return DropdownMenuItem<String>(
                value: city,
                child: Text(city, style: const TextStyle(fontSize: 14)),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedCity = newValue!;
              });
            },
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
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                  fontSize: 14,
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                    style: const TextStyle(fontSize: 14),
                  ),
                  Icon(Icons.calendar_month, color: Colors.grey[500], size: 20),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Waktu Sekarang
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green[100]!),
            ),
            child: Column(
              children: [
                Text(
                  "Waktu Sekarang",
                  style: TextStyle(
                    color: Colors.green[700],
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                StreamBuilder(
                  stream: Stream.periodic(const Duration(seconds: 1)),
                  builder: (context, snapshot) {
                    return Text(
                      _formatTime(DateTime.now()),
                      style: TextStyle(
                        color: Colors.green[700],
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 4),
                Text(
                  _formatDate(DateTime.now()),
                  style: TextStyle(color: Colors.green[600], fontSize: 12),
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
                // Icon Sholat
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isNext
                        ? Colors.green[50]
                        : isPassed
                        ? Colors.grey[100]
                        : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isNext
                          ? Colors.green[100]!
                          : isPassed
                          ? Colors.grey[300]!
                          : Colors.grey[200]!,
                      width: isNext ? 2 : 1,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      _getSholatIcon(sholat["name"]),
                      color: isNext
                          ? Colors.green[600]
                          : isPassed
                          ? Colors.grey[500]
                          : Colors.green[600],
                      size: 20,
                    ),
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
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: isPassed ? Colors.grey[500] : Colors.black87,
                          decoration: isPassed
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isPassed ? "Sudah lewat" : "Akan datang",
                        style: TextStyle(
                          color: isPassed
                              ? Colors.grey[400]
                              : Colors.green[600],
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),

                // Waktu dan Status
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      sholat["time"],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: isNext ? Colors.green[600] : Colors.black87,
                      ),
                    ),
                    if (isNext) ...[
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          "BERIKUTNYA",
                          style: TextStyle(
                            color: Colors.green[600],
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
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

    // Cek jika semua sholat sudah lewat (malam hari), maka Subuh besok adalah berikutnya
    final allPassed = currentSholat.every((item) => item["passed"]);
    if (allPassed) {
      currentSholat.first["isNext"] = true;
      currentSholat.first["passed"] = false;
    }

    return Column(
      children: [
        const SizedBox(height: 8),
        ...currentSholat.asMap().entries.map((entry) {
          return _buildSholatItem(entry.value, entry.key);
        }),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            _buildHeaderCard(),
            _buildSholatList(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
