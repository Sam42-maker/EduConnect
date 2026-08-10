import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color primaryGreen = const Color(0xFF2E5A40);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryGreen,
        elevation: 0,
        title: const Text('Profil Saya', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(icon: const Icon(Icons.settings, color: Colors.white), onPressed: () {})
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: primaryGreen,
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                children: [
                  const CircleAvatar(radius: 40, backgroundColor: Colors.white, child: Icon(Icons.person, size: 40, color: Colors.grey)),
                  const SizedBox(height: 12),
                  const Text('Anindya Putri', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  const Text('Teknik Informatika · UGM', style: TextStyle(color: Colors.white70, fontSize: 14)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                    child: const Text('anindya.putri@gmail.com', style: TextStyle(color: Colors.white, fontSize: 12)),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatBox('4', 'Koneksi'),
                      _buildStatBox('2', 'Komunitas'),
                      _buildStatBox('6', 'Sesi Selesai'),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text('INFO AKADEMIK', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12)),
                  const SizedBox(height: 12),
                  _buildInfoRow(Icons.school, 'Fase Studi', 'Skripsi'),
                  _buildInfoRow(Icons.track_changes, 'Tujuan', 'Riset Bersama'),
                  const SizedBox(height: 16),
                  const Text('Tag Minat', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      Chip(label: const Text('Machine Learning', style: TextStyle(fontSize: 12)), backgroundColor: primaryGreen.withOpacity(0.1)),
                      Chip(label: const Text('Data Science', style: TextStyle(fontSize: 12)), backgroundColor: primaryGreen.withOpacity(0.1)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.edit),
                      label: const Text('Edit Profil'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: primaryGreen, side: BorderSide(color: primaryGreen),
                        padding: const EdgeInsets.symmetric(vertical: 12)
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildStatBox(String count, String label) {
    return Column(
      children: [
        Text(count, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey, size: 20),
          const SizedBox(width: 8),
          Expanded(child: Text(label, style: const TextStyle(color: Colors.grey))),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
