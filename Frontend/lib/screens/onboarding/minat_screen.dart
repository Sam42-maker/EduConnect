import 'package:flutter/material.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_tag_chip.dart';
import 'end_screen.dart'; // Sudah di-uncomment di Fase 5

class MinatScreen extends StatefulWidget {
  const MinatScreen({Key? key}) : super(key: key);

  @override
  State<MinatScreen> createState() => _MinatScreenState();
}

class _MinatScreenState extends State<MinatScreen> {
  // Maksimal 3 Minat
  List<String> _selectedMinat = [];
  String _topInterest = '';

  // Preferensi Waktu Belajar
  final Map<String, bool> _waktuBelajar = {
    'Pagi (07:00 - 12:00)': false,
    'Siang (12:00 - 15:00)': false,
    'Sore (15:00 - 18:00)': false,
    'Malam (18:00 - 21:00)': false,
    'Fleksibel': false,
  };

  final List<String> _daftarMinat = [
    'Machine Learning',
    'Data Science',
    'Python',
    'Computer Vision',
    'NLP',
    'Web Dev',
    'Mobile Dev',
    'Cloud',
    'UI/UX',
    'Statistika',
    'Jaringan',
    'Keamanan Siber',
    'IoT',
    'Robotika',
  ];

  void _toggleMinat(String minat) {
    setState(() {
      if (_selectedMinat.contains(minat)) {
        // Jika sudah dipilih dan diklik lagi: Jadikan Top Interest jika belum
        if (_topInterest != minat) {
          _topInterest = minat;
        } else {
          // Jika sudah Top Interest dan diklik lagi, hapus dari pilihan
          _selectedMinat.remove(minat);
          _topInterest = '';
        }
      } else {
        // Tambahkan jika belum batas maksimal (3)
        if (_selectedMinat.length < 3) {
          _selectedMinat.add(minat);
          if (_topInterest.isEmpty)
            _topInterest = minat; // Otomatis yang pertama jadi top
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Maksimal 3 tag minat!')),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF2B5C43)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress Bar Visual (Sederhana)
              Row(
                children: List.generate(
                  5,
                  (index) => Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(right: 4),
                      height: 4,
                      decoration: BoxDecoration(
                        color: index < 4
                            ? const Color(0xFF2B5C43)
                            : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              const Text(
                'Pilih Minatmu',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Pilih hingga 3 tag. Ketuk tag yang sudah dipilih untuk menjadikannya Top Interest (Bintang).',
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 24),

              // Daftar Chips Minat
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _daftarMinat.map((minat) {
                  return CustomTagChip(
                    label: minat,
                    isSelected: _selectedMinat.contains(minat),
                    isTopInterest: _topInterest == minat,
                    onTap: () => _toggleMinat(minat),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
              Text(
                'Tag yang dipilih (${_selectedMinat.length}/3)',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 32),
              const Text(
                'Preferensi Waktumu',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Kapan kamu biasanya bisa belajar bersama?',
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 16),

              // Daftar Checkbox Custom
              ..._waktuBelajar.keys.map((waktu) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _waktuBelajar[waktu] = !_waktuBelajar[waktu]!;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: _waktuBelajar[waktu]!
                            ? const Color(0xFF2B5C43)
                            : Colors.grey.shade300,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          waktu,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                        Icon(
                          _waktuBelajar[waktu]!
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          color: _waktuBelajar[waktu]!
                              ? const Color(0xFF2B5C43)
                              : Colors.grey.shade400,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),

              const SizedBox(height: 40),

              // LOGIKA TOMBOL LANJUT YANG SUDAH DIUPDATE
              CustomButton(
                text: 'Lanjut',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const EndScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
