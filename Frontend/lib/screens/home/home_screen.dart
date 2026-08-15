import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../community/community_screen.dart';
import '../../services/api_client.dart';

class HomeScreen extends StatefulWidget {
  final String userName;

  const HomeScreen({Key? key, this.userName = 'Mahasiswa'}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Color brandColor = const Color(0xFF2B5C43);
  final Color bgColor = const Color(0xFFF9F9F9);
  final Color brandSecondary = const Color(0xFFD7E8D5);

  Map<String, dynamic> _profileData = {};
  bool _isLoading = true;
  String _displayName = '';

  @override
  void initState() {
    super.initState();
    _displayName = widget.userName;
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final userId = await ApiClient.getUserId();
      if (userId == null) {
        setState(() => _isLoading = false);
        return;
      }

      final res = await http.get(Uri.parse('http://34.128.96.164:5000/api/profile/$userId'));
      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        if (data['success']) {
          setState(() {
            _profileData = data['data'];
            if (_profileData['full_name'] != null && _profileData['full_name'].toString().isNotEmpty) {
              _displayName = _profileData['full_name'];
            }
            _isLoading = false;
          });
        } else {
          setState(() => _isLoading = false);
        }
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      debugPrint('Error fetching home data: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopHeader(),
            const SizedBox(height: 24),

            _buildNewsSection(context),
            const SizedBox(height: 24),

            _buildSectionHeader(
              'Recommended for You',
              subtitle: 'Berdasarkan jurusan, fase, dan minat kamu',
            ),
            const SizedBox(height: 16),
            _buildRecommendedList(context),
            const SizedBox(height: 24),

            _buildSectionHeader('Active Now'),
            const SizedBox(height: 12),
            _buildActiveNowList(context),
            const SizedBox(height: 24),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Text(
                'Mulai Sekarang',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 12),
            _buildQuickActions(context),
            const SizedBox(height: 24),

            _buildSectionHeader('Communities for You'),
            const SizedBox(height: 12),
            _buildCommunitiesList(context),
            const SizedBox(height: 12),

            _buildAboutFooter(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildTopHeader() {
    final major = _profileData['major'] ?? 'Belum ada jurusan';
    final semester = _profileData['current_semester'] ?? '-';
    final studyInfo = '$major · $semester';

    // Kalkulasi profil (mock, bisa dibikin dinamis nanti)
    final profileScore = _profileData['full_name'] != null ? 85 : 40;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 50, 20, 24),
      decoration: BoxDecoration(
        color: brandColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/images/Connie_app.png',
                    width: 32,
                    height: 32,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'EduConnect',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  _buildHeaderIconButton(Icons.notifications_none),
                  const SizedBox(width: 12),
                  _buildHeaderIconButton(Icons.chat_bubble_outline),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Selamat pagi 👋',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _displayName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    studyInfo,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              CircleAvatar(
                radius: 28,
                backgroundColor: brandSecondary,
                child: Text(
                  _displayName.isNotEmpty ? _displayName.trim()[0].toUpperCase() : 'A',
                  style: TextStyle(
                    color: brandColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Profil kamu $profileScore% lengkap',
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    Text(
                      '$profileScore%',
                      style: TextStyle(
                        color: brandSecondary,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: profileScore / 100,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(brandSecondary),
                  minHeight: 6,
                  borderRadius: BorderRadius.circular(10),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.add_circle, color: brandSecondary, size: 16),
                    const SizedBox(width: 6),
                    const Expanded(
                      child: Text(
                        'Tambah tujuan studi untuk muncul di lebih banyak hasil',
                        style: TextStyle(color: Colors.white70, fontSize: 11),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderIconButton(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }

  Widget _buildNewsSection(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            'News',
            subtitle: 'Update kampus & komunitas akademik',
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 170,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildNewsCard(
                  title: 'AI & Data Science\nBerkembang Pesat',
                  subtitle:
                      'Seminar dan workshop baru dibuka untuk mahasiswa IF dan DS.',
                  tag: 'Trending',
                  color: const Color(0xFF2B5C43),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Membuka berita AI & Data Science...'),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 12),
                _buildNewsCard(
                  title: 'Skripsi Sprint\nMinggu Ini',
                  subtitle:
                      'Konsultasi topik riset dan bimbingan bersama mentor.',
                  tag: 'Event',
                  color: const Color(0xFF4A90E2),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Membuka info Skripsi Sprint...'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsCard({
    required String title,
    required String subtitle,
    required String tag,
    required Color color,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 250,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                tag,
                style: TextStyle(
                  color: color,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.black54,
                height: 1.4,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, {String? subtitle}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                'Semua',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: brandColor,
                ),
              ),
            ],
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRecommendedList(context) {
    return SizedBox(
      height: 220,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          _buildMatchCard(
            name: 'Reza Mahardika',
            major: 'Teknik Informatika',
            matchType: 'TOP MATCH',
            matchPercent: '95%',
            borderColor: const Color(0xFF2B5C43),
            initial: 'R',
            tags: ['Skripsi', '★ Machine Learning', 'Data Science', 'Python'],
            lastActive: 'Aktif 5 menit lalu',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Melihat profil Reza Mahardika...'),
                ),
              );
            },
          ),
          const SizedBox(width: 16),
          _buildMatchCard(
            name: 'Bintang Nugroho',
            major: 'Teknik Informatika',
            matchType: 'STRONG MATCH',
            matchPercent: '78%',
            borderColor: const Color(0xFF4A90E2),
            initial: 'B',
            tags: ['Skripsi', '★ Machine Learning', 'Computer Vision'],
            lastActive: 'Aktif 2 jam lalu',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Melihat profil Bintang Nugroho...'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMatchCard({
    required String name,
    required String major,
    required String matchType,
    required String matchPercent,
    required Color borderColor,
    required String initial,
    required List<String> tags,
    required String lastActive,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 260,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor.withOpacity(0.5), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
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
                      radius: 22,
                      backgroundColor: borderColor.withOpacity(0.1),
                      child: Text(
                        initial,
                        style: TextStyle(
                          color: borderColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        major,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: borderColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        matchPercent,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      matchType,
                      style: TextStyle(
                        color: borderColor,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: tags
                  .map((tag) => _buildTagChip(tag, tag.contains('★')))
                  .toList(),
            ),
            const Spacer(),
            Row(
              children: [
                const Icon(Icons.access_time, size: 12, color: Colors.black38),
                const SizedBox(width: 4),
                Text(
                  lastActive,
                  style: const TextStyle(color: Colors.black38, fontSize: 10),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTagChip(String label, bool isTop) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isTop ? Colors.white : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isTop ? brandColor : Colors.transparent),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isTop ? brandColor : Colors.black54,
          fontSize: 10,
          fontWeight: isTop ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildActiveNowList(context) {
    final List<Map<String, String>> actives = [
      {
        'initial': 'F',
        'name': 'Fitri A.',
        'phase': 'Skripsi',
        'color': '0xFFD7E8D5',
      },
      {
        'initial': 'S',
        'name': 'Sinta W.',
        'phase': 'Sempro',
        'color': '0xFFE6E0F8',
      },
      {
        'initial': 'H',
        'name': 'Hendra P.',
        'phase': 'Skripsi',
        'color': '0xFFF8EBD0',
      },
      {
        'initial': 'L',
        'name': 'Lesta W.',
        'phase': 'Project',
        'color': '0xFFF8D0D0',
      },
      {
        'initial': 'Y',
        'name': 'Yoga M.',
        'phase': 'Skripsi',
        'color': '0xFFD0E0F8',
      },
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Sedang online di jurusanmu',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const Text(
                '8 mahasiswa',
                style: TextStyle(fontSize: 10, color: Colors.black38),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: actives
                .map(
                  (e) => GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Mengirim pesan ke ${e['name']}...'),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Color(int.parse(e['color']!)),
                          child: Text(
                            e['initial']!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          e['name']!,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          e['phase']!,
                          style: const TextStyle(
                            fontSize: 9,
                            color: Colors.black38,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.8,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buildActionCard(
            'Cari Study Partner',
            'Temukan mahasiswa se-fase & se-jalur studimu',
            Icons.search,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Membuka pencarian partner...')),
              );
            },
          ),
          _buildActionCard(
            'Gabung Komunitas',
            'Ruang diskusi berdasarkan topik & tujuan',
            Icons.people_outline,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const CommunityScreen(title: 'Komunitas'),
                ),
              );
            },
          ),
          _buildActionCard(
            'Update Tag Minat',
            'Atur ulang topik untuk match yang lebih tepat',
            Icons.local_offer_outlined,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Membuka pengaturan minat...')),
              );
            },
          ),
          _buildActionCard(
            'Ajak Temanmu',
            'Undang via email kampus .ac.id',
            Icons.mail_outline,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Membuka fitur undang teman...')),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(
    String title,
    String subtitle,
    IconData icon, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 20, color: Colors.black54),
            const Spacer(),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 8, color: Colors.black38),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommunitiesList(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _buildCommunityCard(
            'ML Study Group — IF UGM',
            'Diskusi rutin topik ML/DL, paper review, dan project bersama.',
            '124 anggota',
            'Terverifikasi',
            Icons.computer,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const CommunityScreen(title: 'ML Study Group'),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          _buildCommunityCard(
            'Skripsi Support Circle',
            'Sharing progres, tips sempro, dan sumber daya skripsi bareng.',
            '59 anggota',
            'Terverifikasi',
            Icons.edit_document,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const CommunityScreen(title: 'Skripsi Support'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCommunityCard(
    String title,
    String desc,
    String members,
    String badge,
    IconData icon, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: brandSecondary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: brandColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    desc,
                    style: const TextStyle(fontSize: 10, color: Colors.black54),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.people, size: 12, color: Colors.black38),
                      const SizedBox(width: 4),
                      Text(
                        members,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(
                        Icons.check_circle,
                        size: 12,
                        color: Colors.green,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        badge,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: brandColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                minimumSize: Size.zero,
              ),
              child: const Text(
                'Gabung',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMentorCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F6FF),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.blue.withOpacity(0.3),
            style: BorderStyle.solid,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.school, color: Colors.black87),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Mentor Akademik',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Hubungi senior atau dosen sesuai topik risetmu — segera hadir',
                    style: TextStyle(fontSize: 10, color: Colors.black54),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'SOON',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutFooter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Divider(color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text(
            'About EduConnect',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Platform kolaborasi akademik yang aman dan terpercaya untuk mahasiswa Indonesia.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, color: Colors.black54),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildFooterLink('Troubleshooting Help'),
              const Text(' • ', style: TextStyle(color: Colors.black38)),
              _buildFooterLink('Social Media'),
              const Text(' • ', style: TextStyle(color: Colors.black38)),
              _buildFooterLink('Contact'),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            '© 2026 EduConnect',
            style: TextStyle(fontSize: 10, color: Colors.black38),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterLink(String text) {
    return GestureDetector(
      onTap: () {},
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          color: brandColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
