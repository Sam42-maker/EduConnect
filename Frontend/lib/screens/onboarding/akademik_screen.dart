import 'package:flutter/material.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/custom_tag_chip.dart';
import 'minat_screen.dart';

class AkademikScreen extends StatefulWidget {
  const AkademikScreen({Key? key}) : super(key: key);

  @override
  State<AkademikScreen> createState() => _AkademikScreenState();
}

class _AkademikScreenState extends State<AkademikScreen> {
  // State untuk menyimpan pilihan yang diklik
  String _selectedFase = '';
  String _selectedTujuan = '';

  final List<String> _faseStudi = ['Course', 'Sempro', 'Skripsi', 'Project'];
  final List<String> _tujuanKolaborasi = [
    'Mencari Rekan Belajar',
    'Kolaborasi Proyek',
    'Diskusi Akademik',
    'Persiapan Ujian',
    'Penelitian Bersama',
  ];

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
                        color: index < 3
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
                'Info Akademikmu',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Ini menentukan calon mitra belajarmu',
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 32),

              const CustomTextField(label: 'Kampus', hintText: 'Kampus mana?'),
              const SizedBox(height: 16),
              const CustomTextField(label: 'Jurusan', hintText: 'Jurusan apa?'),
              const SizedBox(height: 16),
              const CustomTextField(
                label: 'Semester',
                hintText: 'Semester?',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 24),

              const Text(
                'Fase Studi',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _faseStudi.map((fase) {
                  return CustomTagChip(
                    label: fase,
                    isSelected: _selectedFase == fase,
                    onTap: () => setState(() => _selectedFase = fase),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              const Text(
                'Tujuan Kolaborasi',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _tujuanKolaborasi.map((tujuan) {
                  return CustomTagChip(
                    label: tujuan,
                    isSelected: _selectedTujuan == tujuan,
                    onTap: () => setState(() => _selectedTujuan = tujuan),
                  );
                }).toList(),
              ),
              const SizedBox(height: 40),

              CustomButton(
                text: 'Lanjut',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MinatScreen(),
                    ),
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
