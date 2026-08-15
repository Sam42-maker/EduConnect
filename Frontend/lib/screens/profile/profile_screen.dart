import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = true;
  Map<String, dynamic> _profileData = {};
  
  final String currentUserId = "1"; // Mocked logged-in user

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    try {
      final res = await http.get(Uri.parse('http://localhost:5000/api/profile/$currentUserId'));
      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        if (data['success']) {
          setState(() {
            _profileData = data['data'];
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      debugPrint('Error fetching profile: $e');
      setState(() => _isLoading = false);
    }
  }

  void _showEditProfileBottomSheet() {
    // Controllers pre-filled with current data
    final nameCtrl = TextEditingController(text: _profileData['full_name']);
    final campusCtrl = TextEditingController(text: _profileData['institution']);
    final phaseCtrl = TextEditingController(text: _profileData['study_phase']);
    final objectiveCtrl = TextEditingController(text: _profileData['objective']);
    
    String selectedMajor = _profileData['major'] ?? 'Teknik Informatika';
    String selectedSemester = _profileData['current_semester'] ?? 'Semester 7';
    
    List<String> tags = List<String>.from(_profileData['tags'] ?? []);
    List<String> availability = List<String>.from(_profileData['availability'] ?? []);
    
    final tagCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20, right: 20, top: 20, 
                bottom: MediaQuery.of(context).viewInsets.bottom + 20
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(width: 40, height: 5, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10))),
                    ),
                    const SizedBox(height: 20),
                    const Text('Edit Profil', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2B5C43))),
                    const SizedBox(height: 20),
                    
                    // Avatar Edit
                    Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: const Color(0xFFD7E8D5),
                            child: Text(_profileData['full_name']?[0] ?? 'A', style: const TextStyle(fontSize: 30, color: Color(0xFF2B5C43), fontWeight: FontWeight.bold)),
                          ),
                          Positioned(
                            bottom: 0, right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(color: Color(0xFF2B5C43), shape: BoxShape.circle),
                              child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Data Pribadi
                    TextField(
                      controller: nameCtrl,
                      decoration: const InputDecoration(labelText: 'Nama Lengkap', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: TextEditingController(text: _profileData['email']),
                      enabled: false,
                      decoration: const InputDecoration(
                        labelText: 'Email Kampus', 
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.verified, color: Colors.green),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text('Info Akademik', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    TextField(
                      controller: campusCtrl,
                      decoration: const InputDecoration(labelText: 'Kampus', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: selectedMajor,
                      items: ['Teknik Informatika', 'Sistem Informasi', 'Ilmu Komputer', 'Teknik Elektro'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                      onChanged: (val) => setSheetState(() => selectedMajor = val!),
                      decoration: const InputDecoration(labelText: 'Jurusan', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: selectedSemester,
                      items: ['Semester 1', 'Semester 3', 'Semester 5', 'Semester 7', 'Semester 8+'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                      onChanged: (val) => setSheetState(() => selectedSemester = val!),
                      decoration: const InputDecoration(labelText: 'Semester', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: phaseCtrl,
                      decoration: const InputDecoration(labelText: 'Fase Studi (Misal: Skripsi)', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: objectiveCtrl,
                      decoration: const InputDecoration(labelText: 'Tujuan (Misal: Riset Bersama)', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 20),
                    
                    const Text('Tag Minat', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(child: TextField(controller: tagCtrl, decoration: const InputDecoration(hintText: 'Tambah minat', border: OutlineInputBorder(borderSide: BorderSide.none), filled: true, fillColor: Color(0xFFF5F5F5)))),
                        IconButton(
                          icon: const Icon(Icons.add_circle, color: Color(0xFF2B5C43)),
                          onPressed: () {
                            if (tagCtrl.text.isNotEmpty) {
                              setSheetState(() {
                                tags.add(tagCtrl.text);
                                tagCtrl.clear();
                              });
                            }
                          },
                        )
                      ],
                    ),
                    Wrap(
                      spacing: 8,
                      children: tags.map((t) => Chip(
                        label: Text(t),
                        onDeleted: () => setSheetState(() => tags.remove(t)),
                      )).toList(),
                    ),
                    
                    const SizedBox(height: 20),
                    const Text('Ketersediaan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8, runSpacing: 8,
                      children: ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min', 'Pagi', 'Siang', 'Sore-Malam'].map((d) {
                        final isSelected = availability.contains(d);
                        return InkWell(
                          onTap: () {
                            setSheetState(() {
                              isSelected ? availability.remove(d) : availability.add(d);
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFF2B5C43) : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(d, style: TextStyle(color: isSelected ? Colors.white : Colors.black87)),
                          ),
                        );
                      }).toList(),
                    ),
                    
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2B5C43), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
                        onPressed: () async {
                          // Save
                          final body = {
                            "full_name": nameCtrl.text,
                            "institution": campusCtrl.text,
                            "major": selectedMajor,
                            "current_semester": selectedSemester,
                            "study_phase": phaseCtrl.text,
                            "objective": objectiveCtrl.text,
                            "availability": availability,
                            "tags": tags
                          };
                          
                          try {
                            final res = await http.put(
                              Uri.parse('http://localhost:5000/api/profile/$currentUserId'),
                              headers: {"Content-Type": "application/json"},
                              body: json.encode(body),
                            );
                            if (res.statusCode == 200) {
                              Navigator.pop(context);
                              _fetchProfile(); // Refresh
                            }
                          } catch (e) {
                            debugPrint("Save failed: $e");
                          }
                        },
                        child: const Text('Selesai', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator(color: Color(0xFF2B5C43))));
    }

    final name = _profileData['full_name'] ?? 'Unknown';
    final initial = name.isNotEmpty ? name[0] : 'U';
    final email = _profileData['email'] ?? '';
    final isVerified = email.endsWith('.ac.id') || email.endsWith('.edu');
    
    final studyInfo = "${_profileData['major'] ?? '-'} · ${_profileData['institution'] ?? '-'} · ${_profileData['current_semester'] ?? '-'}";
    
    final tags = List<String>.from(_profileData['tags'] ?? []);
    final availability = List<String>.from(_profileData['availability'] ?? []).join(', ');

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        title: const Text('Profil', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Header
            CircleAvatar(
              radius: 40,
              backgroundColor: const Color(0xFFD7E8D5),
              child: Text(initial, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF2B5C43))),
            ),
            const SizedBox(height: 16),
            Text(name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(studyInfo, style: const TextStyle(fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 12),
            
            if (isVerified)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(20)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.verified, color: Colors.green, size: 16),
                    const SizedBox(width: 4),
                    Text(email, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                ),
              ),
              
            const SizedBox(height: 24),
            
            // Stats Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem('Koneksi', _profileData['connections']?.toString() ?? '0'),
                  _buildStatItem('Komunitas', _profileData['communities']?.toString() ?? '0'),
                  _buildStatItem('Sesi Done', _profileData['sessions_done']?.toString() ?? '0'),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Info Akademik
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Info Akademik', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  _buildInfoRow('Fase Studi', _profileData['study_phase'] ?? '-'),
                  const SizedBox(height: 12),
                  _buildInfoRow('Tujuan', _profileData['objective'] ?? '-'),
                  const SizedBox(height: 12),
                  const Text('Tag Minat', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8, runSpacing: 8,
                    children: tags.asMap().entries.map((entry) {
                      final idx = entry.key;
                      final t = entry.value;
                      final isTop = idx == 0;
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: isTop ? const Color(0xFFD7E8D5) : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isTop) const Icon(Icons.star, color: Color(0xFF2B5C43), size: 14),
                            if (isTop) const SizedBox(width: 4),
                            Text(t, style: TextStyle(color: isTop ? const Color(0xFF2B5C43) : Colors.black87, fontWeight: isTop ? FontWeight.bold : FontWeight.normal, fontSize: 12)),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow('Ketersediaan', availability.isNotEmpty ? availability : '-'),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF2B5C43)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                ),
                onPressed: _showEditProfileBottomSheet,
                child: const Text('Edit Profil', style: TextStyle(color: Color(0xFF2B5C43), fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String count) {
    return Column(
      children: [
        Text(count, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2B5C43))),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      ],
    );
  }
}
