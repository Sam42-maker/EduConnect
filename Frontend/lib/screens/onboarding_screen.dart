import 'package:flutter/material.dart';
import 'main_layout.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final Color primaryGreen = const Color(0xFF2E5A40);
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // State untuk Info Akademik (Page 1)
  String selectedFaseStudi = '';
  String selectedTujuanKolaborasi = '';
  
  // State untuk Pilih Minatmu (Page 2)
  List<String> selectedTags = [];
  
  // State untuk Preferensi Waktu (Page 3)
  Map<String, bool> timePreferences = {
    'Pagi (07:00 - 12:00)': false,
    'Siang (12:00 - 15:00)': false,
    'Sore (15:00 - 18:00)': false,
    'Malam (18:00 - 21:00)': false,
  };

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      // Simpan Profil ke Backend dan masuk ke Home Screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainLayout()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Icon(Icons.school, size: 24, color: primaryGreen),
            const SizedBox(width: 8),
            Text('EduConnect', style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {}, 
            child: Text('Lewati', style: TextStyle(color: Colors.grey.shade600))
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Linear Progress Indicator
            LinearProgressIndicator(
              value: (_currentPage + 1) / 3,
              backgroundColor: Colors.grey.shade200,
              color: primaryGreen,
              minHeight: 4,
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(), // User pake tombol Lanjut
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: [
                  _buildPage1InfoAkademik(),
                  _buildPage2PilihMinat(),
                  _buildPage3PreferensiWaktu(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: ElevatedButton(
                onPressed: _nextPage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(
                  _currentPage == 2 ? 'Selesai' : 'Lanjut',
                  style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // --- HALAMAN 1: INFO AKADEMIKMU ---
  Widget _buildPage1InfoAkademik() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Info Akademikmu', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Ini menentukan calon mitra belajarmu', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 24),
          
          _buildTextField('Kampus', 'Kampus mana?'),
          const SizedBox(height: 16),
          _buildTextField('Jurusan', 'Jurusan apa?'),
          const SizedBox(height: 16),
          _buildTextField('Semester', 'Semester?'),
          const SizedBox(height: 24),
          
          const Text('Fase Studi', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ['Course', 'Sempro', 'Skripsi', 'Project'].map((fase) {
              return ChoiceChip(
                label: Text(fase),
                selected: selectedFaseStudi == fase,
                selectedColor: primaryGreen.withOpacity(0.2),
                onSelected: (bool selected) {
                  setState(() => selectedFaseStudi = selected ? fase : '');
                },
              );
            }).toList(),
          ),
          
          const SizedBox(height: 24),
          const Text('Tujuan Kolaborasi', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ['Mencari Rekan Belajar', 'Kolaborasi Proyek', 'Diskusi Akademik', 'Persiapan Ujian', 'Penelitian Bersama'].map((tujuan) {
              return ChoiceChip(
                label: Text(tujuan),
                selected: selectedTujuanKolaborasi == tujuan,
                selectedColor: primaryGreen.withOpacity(0.2),
                onSelected: (bool selected) {
                  setState(() => selectedTujuanKolaborasi = selected ? tujuan : '');
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // --- HALAMAN 2: PILIH MINATMU ---
  Widget _buildPage2PilihMinat() {
    final List<String> allTags = [
      'Machine Learning', 'Data Science', 'Python', 'Computer Vision', 'NLP', 
      'Web Dev', 'Mobile Dev', 'Cloud', 'UI/UX', 'Statistika', 
      'Jaringan', 'Keamanan Siber', 'IoT', 'Robotika'
    ];
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Pilih Minatmu', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Pilih hingga 5 tag. Tandai satu sebagai Top Interest - ini menentukan kualitas matching paling besar.', style: TextStyle(color: Colors.grey, height: 1.5)),
          const SizedBox(height: 16),
          const Text('Pilih tag (maks. 5)', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: allTags.map((tag) {
              bool isSelected = selectedTags.contains(tag);
              return FilterChip(
                label: Text(tag, style: TextStyle(color: isSelected ? primaryGreen : Colors.black87)),
                selected: isSelected,
                backgroundColor: Colors.white,
                selectedColor: primaryGreen.withOpacity(0.1),
                shape: StadiumBorder(side: BorderSide(color: isSelected ? primaryGreen : Colors.grey.shade300)),
                onSelected: (bool selected) {
                  setState(() {
                    if (selected && selectedTags.length < 5) {
                      selectedTags.add(tag);
                    } else if (!selected) {
                      selectedTags.remove(tag);
                    }
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // --- HALAMAN 3: PREFERENSI WAKTU ---
  Widget _buildPage3PreferensiWaktu() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Preferensi Waktumu', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Kapan kamu biasanya bisa belajar bersama?', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 24),
          ...timePreferences.keys.map((time) {
            return Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: Colors.grey.shade300)
              ),
              margin: const EdgeInsets.only(bottom: 12),
              child: CheckboxListTile(
                title: Text(time),
                activeColor: primaryGreen,
                value: timePreferences[time],
                onChanged: (bool? value) {
                  setState(() {
                    timePreferences[time] = value ?? false;
                  });
                },
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: primaryGreen)),
          ),
        ),
      ],
    );
  }
}
