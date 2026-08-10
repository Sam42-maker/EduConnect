import 'package:flutter/material.dart';

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color primaryGreen = const Color(0xFF2E5A40);
    
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text('Discover', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          bottom: TabBar(
            labelColor: primaryGreen,
            unselectedLabelColor: Colors.grey,
            indicatorColor: primaryGreen,
            tabs: const [
              Tab(text: 'Mahasiswa'),
              Tab(text: 'Komunitas'),
              Tab(text: 'Publik'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Tab Mahasiswa
            ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildDiscoverCard('Reza Mahardika', 'Teknik Informatika - UGM', '95%', primaryGreen, true),
                _buildDiscoverCard('Bintang Nugroho', 'Teknik Informatika - UGM', '78%', primaryGreen, false),
                _buildDiscoverCard('Citra Dewi', 'Statistika Terapan - UGM', '52%', primaryGreen, false),
              ],
            ),
            const Center(child: Text('Daftar Komunitas')),
            const Center(child: Text('Publik')),
          ],
        ),
      ),
    );
  }

  Widget _buildDiscoverCard(String name, String desc, String match, Color color, bool isTopMatch) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: isTopMatch ? color : Colors.grey.shade300, width: isTopMatch ? 2 : 1)),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(radius: 24, backgroundColor: color.withOpacity(0.2), child: Text(name[0], style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold))),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(desc, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Text(match, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(isTopMatch ? 'TOP MATCH' : 'MATCH', style: const TextStyle(color: Colors.grey, fontSize: 10)),
                  ],
                )
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: [
                Chip(label: const Text('Skripsi', style: TextStyle(fontSize: 10)), padding: EdgeInsets.zero, backgroundColor: Colors.grey.shade100),
                Chip(label: const Text('Machine Learning', style: TextStyle(fontSize: 10)), padding: EdgeInsets.zero, backgroundColor: color.withOpacity(0.1)),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.person_add, size: 16, color: Colors.white),
                label: const Text('Connect', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(backgroundColor: color, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
              ),
            )
          ],
        ),
      ),
    );
  }
}
