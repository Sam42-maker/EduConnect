import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color primaryGreen = const Color(0xFF2E5A40);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Icon(Icons.school, color: primaryGreen),
            const SizedBox(width: 8),
            Text('EduConnect', style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.notifications, color: Colors.grey), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Selamat pagi 👋', style: TextStyle(color: Colors.grey, fontSize: 14)),
            const Text('Shandy Developer', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            const Text('Teknik Informatika · Semester 7', style: TextStyle(color: Colors.grey, fontSize: 14)),
            
            const SizedBox(height: 24),
            // Profil Kelengkapan
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: primaryGreen.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Profil kamu 68% lengkap', style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold)),
                  Text('Lengkapi', style: TextStyle(color: primaryGreen, decoration: TextDecoration.underline)),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Recommended for You', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('Lihat semua', style: TextStyle(color: primaryGreen)),
              ],
            ),
            const SizedBox(height: 12),
            // Mock Card Rekomendasi
            _buildMatchCard('Reza Mahardika', 'Teknik Informatika', '95%', primaryGreen),
            _buildMatchCard('Bintang Nugroho', 'Teknik Informatika', '78%', primaryGreen),

            const SizedBox(height: 24),
            const Text('Mulai Sekarang', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildActionCard(Icons.search, 'Cari Study Partner')),
                const SizedBox(width: 12),
                Expanded(child: _buildActionCard(Icons.groups, 'Gabung Komunitas')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMatchCard(String name, String major, String matchPercent, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.shade300)),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(backgroundColor: color.withOpacity(0.2), child: Text(name[0], style: TextStyle(color: color, fontWeight: FontWeight.bold))),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(major, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
              child: Text('$matchPercent Match', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(IconData icon, String title) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 32, color: const Color(0xFF2E5A40)),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
