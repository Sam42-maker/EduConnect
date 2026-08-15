import 'package:flutter/material.dart';
import 'mentor_detail_screen.dart';

class MentorScreen extends StatefulWidget {
  const MentorScreen({super.key});

  @override
  State<MentorScreen> createState() => _MentorScreenState();
}

class _MentorScreenState extends State<MentorScreen> {
  final Color brandGreen = const Color(0xFF2B5C43);
  final Color lightGreen = const Color(0xFFE8F2E7);
  final Color darkGreen = const Color(0xFF1F4330);
  
  final List<Map<String, dynamic>> dummyMentors = [
    {
      'id': '1',
      'name': 'Frank Castle',
      'isVerified': true,
      'badges': ['Skripsi', 'Project'],
      'field': 'Sistem Informasi',
      'expertise': ['Machine Learning', 'Deep Learning', 'Python'],
      'description': 'Membantu menyusun draft proposal skripsi dan memberikan ulasan mingguan terkait machine learning.',
      'rating': 4.7,
      'reviews': 21,
      'price': 250000,
    },
    {
      'id': '2',
      'name': 'Shandius Afrianus',
      'isVerified': true,
      'badges': ['Project', 'Course'],
      'field': 'Teknik Informatika',
      'expertise': ['UI/UX', 'Figma', 'Flutter'],
      'description': 'Berpengalaman dalam desain UI/UX dan pengembangan aplikasi mobile. Siap membantu project Anda.',
      'rating': 4.9,
      'reviews': 45,
      'price': 150000,
    },
    {
      'id': '3',
      'name': 'Gabrielus Cruzalus',
      'isVerified': true,
      'badges': ['Skripsi', 'Course'],
      'field': 'Data Science',
      'expertise': ['Data Analysis', 'SQL', 'Tableau'],
      'description': 'Spesialis dalam analisis data dan visualisasi. Membantu dari tahap crawling data hingga dashboard.',
      'rating': 4.8,
      'reviews': 32,
      'price': 200000,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mentor',
              style: TextStyle(
                color: brandGreen,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            const Text(
              'Ruang kolaborasi berbasis topik & jurusan',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari Professional...',
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                prefixIcon: Icon(Icons.search, color: brandGreen),
                filled: true,
                fillColor: const Color(0xFFF3F4F6),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
          
          // Mentor List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: dummyMentors.length,
              itemBuilder: (context, index) {
                final mentor = dummyMentors[index];
                return _buildMentorCard(mentor);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMentorCard(Map<String, dynamic> mentor) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MentorDetailScreen(mentorData: mentor),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Avatar, Name, Verification
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: lightGreen,
                  child: Text(
                    mentor['name'][0],
                    style: TextStyle(
                      color: brandGreen,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              mentor['name'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (mentor['isVerified'])
                            const Icon(Icons.verified, color: Colors.green, size: 16),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        mentor['field'],
                        style: TextStyle(
                          fontSize: 13,
                          color: brandGreen,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Badges
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: (mentor['badges'] as List<String>).map((badge) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Text(
                              badge,
                              style: const TextStyle(fontSize: 10, color: Colors.black54),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Expertise Tags
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: (mentor['expertise'] as List<String>).map((skill) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: lightGreen,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    skill,
                    style: TextStyle(
                      fontSize: 11,
                      color: brandGreen,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            
            // Description
            Text(
              mentor['description'],
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black87,
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 12),
            
            // Footer: Rating and Price
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.star_rounded, color: Colors.amber, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      '${mentor['rating']}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '(${mentor['reviews']} ulasan)',
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MentorDetailScreen(mentorData: mentor),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: brandGreen,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: Text(
                    'Rp${mentor['price']}/Sesi',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
