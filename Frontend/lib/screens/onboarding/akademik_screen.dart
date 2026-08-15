import 'package:flutter/material.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/custom_tag_chip.dart';
import '../../widgets/progress_step_indicator.dart';
import 'minat_screen.dart';

class AkademikScreen extends StatefulWidget {
  final String userName;
  final String role;

  const AkademikScreen({
    Key? key,
    this.userName = 'Anindya Putri',
    this.role = 'Student',
  }) : super(key: key);

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
    const Color brandColor = Color(0xFF2B5C43);
    const Color brandSecondary = Color(0xFFD7E8D5);

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: Column(
        children: [
          // --- HEADER SECTION ---
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(color: brandColor),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                child: Row(
                  children: [
                    // Back Button
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 12),
                    // Logo Badge (Kotak kecil)
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(color: brandSecondary),
                      child: Center(
                        child: Image.asset(
                          'assets/images/Connie_app.png',
                          width: 56,
                          height: 56,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'EduConnect',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ProgressStepIndicator(currentStep: 3.5),
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

                    widget.role == 'Student' 
                      ? _buildStudentUI()
                      : _buildMentorUI(),
                      
                    const SizedBox(height: 40),

                    CustomButton(
                      text: 'Lanjut',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MinatScreen(
                              userName: widget.userName,
                              role: widget.role,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildStudentUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomTextField(
          label: 'Kampus',
          hintText: 'Kampus mana?',
        ),
        const SizedBox(height: 16),
        const CustomTextField(
          label: 'Jurusan',
          hintText: 'Jurusan apa?',
        ),
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
      ],
    );
  }

  Widget _buildMentorUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pendidikan Terakhir',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: 'Magister (S2)',
              items: ['Magister (S2)', 'Sarjana (S1)', 'Doktoral (S3)'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: const TextStyle(fontSize: 14)),
                );
              }).toList(),
              onChanged: (newValue) {}, // Dummy
            ),
          ),
        ),
        const SizedBox(height: 24),

        // S2 Section
        const Text('Riwayat Magister (S2)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 12),
        const CustomTextField(label: 'Jurusan', hintText: 'Jurusan apa?'),
        const SizedBox(height: 12),
        const CustomTextField(label: 'Universitas', hintText: 'Universitas apa?'),
        const SizedBox(height: 12),
        _buildUploadDocumentButton(),
        const SizedBox(height: 24),

        // S1 Section
        const Text('Riwayat Sarjana (S1)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 12),
        const CustomTextField(label: 'Jurusan', hintText: 'Jurusan apa?'),
        const SizedBox(height: 12),
        const CustomTextField(label: 'Universitas', hintText: 'Universitas apa?'),
        const SizedBox(height: 12),
        _buildUploadDocumentButton(),
        const SizedBox(height: 24),

        // Jenis Bimbingan
        const Text(
          'Jenis Bimbingan',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: ['UTBK/Ujian Mandiri', 'Sempro', 'Skripsi', 'Project'].map((jenis) {
            return CustomTagChip(
              label: jenis,
              isSelected: _selectedFase == jenis,
              onTap: () => setState(() => _selectedFase = jenis),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildUploadDocumentButton() {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.add, size: 18),
      label: const Text('Surat Kelulusan'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey.shade200,
        foregroundColor: const Color(0xFF2B5C43),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
