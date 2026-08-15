import 'package:flutter/material.dart';

class DummyProfile {
  final String name;
  final String initial;
  final Color color;
  final String major;
  final String university;
  final String matchRate;
  final String matchTitle;
  final String status;
  final String objective;
  final List<String> skills;
  final String topSkill;
  final String lastActive;

  DummyProfile({
    required this.name,
    required this.initial,
    required this.color,
    required this.major,
    required this.university,
    required this.matchRate,
    required this.matchTitle,
    required this.status,
    required this.objective,
    required this.skills,
    required this.topSkill,
    required this.lastActive,
  });
}

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  int _selectedTab = 0;
  
  List<String> _selectedQuickFilters = [];
  String _selectedMatchCriteria = 'Belum diatur';
  bool _isMatchSet = false;
  bool _isLoading = false;

  final List<String> _availableTags = [
    'Machine Learning', 'Data Science', 'Python', 'Computer Vision', 'NLP',
    'Web Dev', 'Mobile Dev', 'Cloud', 'UI/UX', 'Statistika', 'Jaringan',
    'Keamanan Siber', 'IoT', 'Robotika', 'Skripsi', 'Semester 6', 'Lulusan Baru'
  ];

  final List<DummyProfile> _allProfiles = [
    DummyProfile(
      name: 'Reza Mahardika',
      initial: 'R',
      color: const Color(0xFF2B5C43),
      major: 'Teknik Informatika',
      university: 'UGM',
      matchRate: '95%',
      matchTitle: 'TOP MATCH',
      status: 'Skripsi',
      objective: 'Tujuan: Riset Bersama — Topik: Computer Vision',
      skills: ['Machine Learning', 'Data Science', 'Python'],
      topSkill: 'Machine Learning',
      lastActive: 'Aktif 5 menit lalu',
    ),
    DummyProfile(
      name: 'Bintang Nugroho',
      initial: 'B',
      color: Colors.blue.shade700,
      major: 'Teknik Komputer',
      university: 'UI',
      matchRate: '80%',
      matchTitle: 'STRONG MATCH',
      status: 'Semester 6',
      objective: 'Tujuan: Lomba Gemastik — Topik: IoT, Smart City',
      skills: ['IoT', 'Robotika', 'Jaringan'],
      topSkill: 'IoT',
      lastActive: 'Aktif 1 jam lalu',
    ),
    DummyProfile(
      name: 'Clara Wijaya',
      initial: 'C',
      color: Colors.purple.shade700,
      major: 'Sistem Informasi',
      university: 'ITB',
      matchRate: '62%',
      matchTitle: 'RELEVANT',
      status: 'Lulusan Baru',
      objective: 'Tujuan: Bikin Startup — Bidang: Edutech',
      skills: ['UI/UX', 'Web Dev', 'Mobile Dev'],
      topSkill: 'UI/UX',
      lastActive: 'Aktif kemarin',
    ),
    DummyProfile(
      name: 'Dinda Lestari',
      initial: 'D',
      color: Colors.pink.shade500,
      major: 'Teknik Elektro',
      university: 'ITS',
      matchRate: '70%',
      matchTitle: 'GOOD MATCH',
      status: 'Semester 4',
      objective: 'Tujuan: Belajar Bareng — Topik: Web Development',
      skills: ['Web Dev', 'UI/UX', 'Cloud'],
      topSkill: 'Web Dev',
      lastActive: 'Aktif 10 menit lalu',
    ),
  ];

  List<DummyProfile> get _filteredProfiles {
    if (_selectedQuickFilters.isEmpty) {
      return _allProfiles;
    }
    return _allProfiles.where((profile) {
      bool matchSkill = profile.skills.any((skill) => _selectedQuickFilters.contains(skill));
      bool matchStatus = _selectedQuickFilters.contains(profile.status);
      return matchSkill || matchStatus;
    }).toList();
  }

  void _simulateLoading(VoidCallback onComplete) {
    setState(() {
      _isLoading = true;
    });
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        onComplete();
      }
    });
  }

  void _toggleFilter(String filter) {
    setState(() {
      if (_selectedQuickFilters.contains(filter)) {
        _selectedQuickFilters.remove(filter);
      } else {
        _selectedQuickFilters.add(filter);
      }
      
      if (_selectedQuickFilters.isNotEmpty) {
        _isMatchSet = true;
        _selectedMatchCriteria = _selectedQuickFilters.join(', ');
      } else {
        _isMatchSet = false;
        _selectedMatchCriteria = 'Belum diatur';
      }
    });
  }

  void _showFilterOptionsDialog() {
    List<String> tempSelected = List.from(_selectedQuickFilters);
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateSheet) {
            return Container(
              padding: const EdgeInsets.all(24),
              height: MediaQuery.of(context).size.height * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Pilih Filter Minat', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 10,
                        children: _availableTags.map((minat) {
                          final isSelected = tempSelected.contains(minat);
                          return ChoiceChip(
                            label: Text(minat),
                            selected: isSelected,
                            selectedColor: const Color(0xFF2B5C43),
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : Colors.black87,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal
                            ),
                            onSelected: (selected) {
                              setStateSheet(() {
                                if (selected) tempSelected.add(minat);
                                else tempSelected.remove(minat);
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          _selectedQuickFilters = tempSelected;
                          if (_selectedQuickFilters.isNotEmpty) {
                            _isMatchSet = true;
                            _selectedMatchCriteria = _selectedQuickFilters.join(', ');
                          } else {
                            _isMatchSet = false;
                            _selectedMatchCriteria = 'Belum diatur';
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2B5C43),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Terapkan Filter', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  )
                ],
              ),
            );
          },
        );
      }
    );
  }

  void _showMatchDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Find Your Match', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2B5C43))),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: const Color(0xFF2B5C43).withOpacity(0.1), shape: BoxShape.circle),
                  child: const Icon(Icons.person, color: Color(0xFF2B5C43)),
                ),
                title: const Text('Dengan Minatku Sendiri', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                subtitle: const Text('Cari orang yang memiliki minat sama dengan saya.', style: TextStyle(fontSize: 12)),
                onTap: () {
                  Navigator.pop(context);
                  _simulateLoading(() {
                    setState(() {
                      _selectedQuickFilters = ['Machine Learning', 'Python']; // Asumsi minat user
                      _selectedMatchCriteria = 'Minatku Sendiri';
                      _isMatchSet = true;
                      _selectedTab = 0; // Pindah ke Mahasiswa
                    });
                  });
                },
              ),
              const Divider(),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), shape: BoxShape.circle),
                  child: const Icon(Icons.search, color: Colors.blue),
                ),
                title: const Text('Custom Match', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                subtitle: const Text('Pilih kriteria dari daftar minat dan fase.', style: TextStyle(fontSize: 12)),
                onTap: () {
                  Navigator.pop(context);
                  _showCustomMatchDialog();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCustomMatchDialog() {
    List<String> tempSelected = List.from(_selectedQuickFilters);
    final List<String> faseStudiOptions = ['Semester 2', 'Semester 4', 'Semester 6', 'Skripsi', 'Lulusan Baru'];
    
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: const Text('Custom Match Kriteria', style: TextStyle(fontWeight: FontWeight.bold)),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Fase Studi', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2B5C43))),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: faseStudiOptions.map((fase) {
                        final isSelected = tempSelected.contains(fase);
                        return ChoiceChip(
                          label: Text(fase, style: TextStyle(fontSize: 12, color: isSelected ? Colors.white : Colors.black87)),
                          selected: isSelected,
                          selectedColor: const Color(0xFF2B5C43),
                          onSelected: (selected) {
                            setStateDialog(() {
                              if (selected) tempSelected.add(fase);
                              else tempSelected.remove(fase);
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    const Text('Minat & Keahlian', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2B5C43))),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _availableTags.where((t) => !faseStudiOptions.contains(t)).map((minat) {
                        final isSelected = tempSelected.contains(minat);
                        return ChoiceChip(
                          label: Text(minat, style: TextStyle(fontSize: 12, color: isSelected ? Colors.white : Colors.black87)),
                          selected: isSelected,
                          selectedColor: const Color(0xFF2B5C43),
                          onSelected: (selected) {
                            setStateDialog(() {
                              if (selected) tempSelected.add(minat);
                              else tempSelected.remove(minat);
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Batal', style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _simulateLoading(() {
                      setState(() {
                        _selectedQuickFilters = tempSelected;
                        _selectedTab = 0; // Pindah ke tab Mahasiswa
                        if (_selectedQuickFilters.isNotEmpty) {
                          _isMatchSet = true;
                          _selectedMatchCriteria = _selectedQuickFilters.join(', ');
                        } else {
                          _isMatchSet = false;
                          _selectedMatchCriteria = 'Belum diatur';
                        }
                      });
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2B5C43),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Terapkan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildMatchCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F7F4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF2B5C43).withOpacity(0.2)),
      ),
      child: Center(
        child: Column(
          children: [
            const Text(
              'Sesuaikan Pencarian',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: Color(0xFF2B5C43)),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _showMatchDialog,
              icon: const Icon(Icons.radar, color: Colors.white),
              label: const Text('Find Your Match', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2B5C43),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                elevation: 4,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Pilih kriteria untuk menemukan partner yang tepat',
              style: TextStyle(fontSize: 11, color: Colors.black54),
            ),
            if (_isMatchSet && !_isLoading) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF2B5C43).withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check_circle, color: Color(0xFF2B5C43), size: 16),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'Pencarian Aktif:\n$_selectedMatchCriteria',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 11, color: Color(0xFF2B5C43), fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              )
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildTabs() {
    final tabs = ['Mahasiswa', 'Komunitas', 'Publik'];
    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: tabs.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedTab == index;
          return GestureDetector(
            onTap: () => setState(() => _selectedTab = index),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF2B5C43) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: isSelected ? null : Border.all(color: Colors.grey.shade300),
              ),
              child: Center(
                child: Text(
                  tabs[index],
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black54,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilters() {
    // Menampilkan semua tag pilihan ditambah beberapa tag rekomendasi
    final displayedTags = {..._selectedQuickFilters, ..._availableTags.take(5)}.toList();
    
    return Container(
      height: 36,
      margin: const EdgeInsets.only(left: 20, bottom: 16),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          GestureDetector(
            onTap: _showFilterOptionsDialog,
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: const [
                  Icon(Icons.filter_list, size: 16, color: Colors.black54),
                  SizedBox(width: 6),
                  Text('Filter', style: TextStyle(fontSize: 12, color: Colors.black87, fontWeight: FontWeight.bold)),
                  SizedBox(width: 4),
                  Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.black54),
                ],
              ),
            ),
          ),
          ...displayedTags.map((f) {
            final isSelected = _selectedQuickFilters.contains(f);
            return GestureDetector(
              onTap: () => _toggleFilter(f),
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF2B5C43) : const Color(0xFF2B5C43).withOpacity(0.05),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: isSelected ? const Color(0xFF2B5C43) : const Color(0xFF2B5C43).withOpacity(0.2)),
                ),
                child: Center(
                  child: Row(
                    children: [
                      if (isSelected) const Icon(Icons.check, size: 14, color: Colors.white),
                      if (isSelected) const SizedBox(width: 4),
                      Text(f, style: TextStyle(fontSize: 12, color: isSelected ? Colors.white : const Color(0xFF2B5C43), fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildMatchBanner(int count) {
    if (!_isMatchSet) return const SizedBox();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2B5C43), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2B5C43).withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Color(0xFF2B5C43),
              shape: BoxShape.circle,
            ),
            child: Text(count.toString(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Match Possible', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: Colors.black87)),
                const SizedBox(height: 2),
                Text(
                  'Berdasarkan kriteria: $_selectedMatchCriteria',
                  style: const TextStyle(fontSize: 11, color: Colors.black54),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(DummyProfile profile) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: profile.color,
                    child: Text(profile.initial, style: const TextStyle(fontWeight: FontWeight.w900, color: Colors.white, fontSize: 20)),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.greenAccent.shade400,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2.5),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(profile.name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: Colors.black87)),
                    const SizedBox(height: 2),
                    Text('${profile.major} - ${profile.university}', style: const TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(profile.matchRate, style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF2B5C43), fontSize: 18)),
                  Text(profile.matchTitle, style: const TextStyle(fontSize: 9, color: Color(0xFF2B5C43), fontWeight: FontWeight.w800, letterSpacing: 0.5)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Text('📌 ${profile.status}', style: TextStyle(fontSize: 11, color: Colors.orange.shade900, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(profile.objective, style: const TextStyle(fontSize: 13, color: Colors.black87, fontWeight: FontWeight.w600, height: 1.4)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: profile.skills.map((s) {
              final isTop = s == profile.topSkill;
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: isTop ? const Color(0xFF2B5C43).withOpacity(0.08) : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: isTop ? Border.all(color: const Color(0xFF2B5C43)) : null,
                ),
                child: Text(
                  isTop ? '★ $s' : s, 
                  style: TextStyle(
                    fontSize: 11, 
                    color: isTop ? const Color(0xFF2B5C43) : Colors.black54, 
                    fontWeight: isTop ? FontWeight.bold : FontWeight.w600
                  )
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.access_time, size: 14, color: Colors.black38),
                  const SizedBox(width: 4),
                  Text(profile.lastActive, style: const TextStyle(fontSize: 11, color: Colors.black38, fontWeight: FontWeight.w500)),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Permintaan koneksi dikirim ke ${profile.name}!')));
                },
                icon: const Icon(Icons.person_add, size: 16, color: Colors.white),
                label: const Text('Connect', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2B5C43),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCommunityCard(String name, String members, String description, List<String> tags) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.group, color: Colors.blue.shade700),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text('$members anggota', style: const TextStyle(color: Colors.black54, fontSize: 12)),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2B5C43),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: const Text('Join', style: TextStyle(color: Colors.white, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(description, style: const TextStyle(color: Colors.black87, fontSize: 13)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: tags.map((t) => Chip(
              label: Text(t, style: const TextStyle(fontSize: 10, color: Colors.black54)),
              padding: EdgeInsets.zero,
              backgroundColor: Colors.grey.shade100,
              side: BorderSide.none,
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPublicCard(String author, String time, String title, String description) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.grey.shade300,
                child: const Icon(Icons.person, size: 20, color: Colors.white),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(author, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  Text(time, style: const TextStyle(color: Colors.black38, fontSize: 10)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 6),
          Text(description, style: const TextStyle(color: Colors.black87, fontSize: 13, height: 1.4)),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.thumb_up_alt_outlined, size: 16, color: Colors.grey.shade600),
              const SizedBox(width: 4),
              Text('Dukung', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
              const SizedBox(width: 16),
              Icon(Icons.comment_outlined, size: 16, color: Colors.grey.shade600),
              const SizedBox(width: 4),
              Text('Komentar', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayedProfiles = _filteredProfiles;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B5C43),
        elevation: 0,
        title: const Text(
          'Discover',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 22),
        ),
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMatchCard(),
            _buildTabs(),
            _buildFilters(),
            
            if (_isLoading)
              Container(
                margin: const EdgeInsets.only(top: 60),
                child: Center(
                  child: Column(
                    children: const [
                      CircularProgressIndicator(color: Color(0xFF2B5C43)),
                      SizedBox(height: 16),
                      Text(
                        'Sedang mencari match terbaik untuk Anda...',
                        style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              )
            else ...[
              if (_selectedTab == 0) ...[
                _buildMatchBanner(displayedProfiles.length),
                if (displayedProfiles.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(40),
                    child: Center(
                      child: Text(
                        'Tidak ada profil yang cocok dengan kriteria pencarian.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),
                  )
                else
                  ...displayedProfiles.map((profile) => _buildProfileCard(profile)).toList(),
              ] else if (_selectedTab == 1) ...[
                _buildCommunityCard('AI Enthusiast Indo', '1.2k', 'Grup riset AI dan Machine Learning.', ['Machine Learning', 'Data Science']),
                _buildCommunityCard('Web Dev Masters', '850', 'Diskusikan framework terbaru seperti React dan Flutter.', ['Web Dev', 'Frontend']),
              ] else if (_selectedTab == 2) ...[
                _buildPublicCard('Budi Santoso', '2 jam lalu', 'Mencari partner lomba Hackathon!', 'Saya butuh 1 frontend developer yang jago React.'),
                _buildPublicCard('Andi Wijaya', '5 jam lalu', 'Buku referensi Machine Learning?', 'Ada yang punya rekomendasi buku atau e-course?'),
              ],
            ],
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
