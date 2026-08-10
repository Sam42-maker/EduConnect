import 'package:flutter/material.dart';

class MentorScreen extends StatelessWidget {
  const MentorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color primaryGreen = const Color(0xFF2E5A40);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Mentor', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Mentor Header Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 10, spreadRadius: 2)],
              ),
              child: Column(
                children: [
                  const CircleAvatar(radius: 40, backgroundColor: Colors.blueAccent, child: Text('GC', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold))),
                  const SizedBox(height: 12),
                  const Text('Gabrielus Cruzalus', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const Text('Data Science Expert', style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.star, color: Colors.orange, size: 16),
                      const Text(' 4.5 ', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('(40 ulasan)', style: TextStyle(color: Colors.grey.shade600)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Chip(label: const Text('Verified', style: TextStyle(fontSize: 10, color: Colors.white)), backgroundColor: primaryGreen, padding: EdgeInsets.zero),
                      const SizedBox(width: 8),
                      Chip(label: const Text('Skripsi', style: TextStyle(fontSize: 10)), backgroundColor: Colors.grey.shade200, padding: EdgeInsets.zero),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // About Section
            const Align(alignment: Alignment.centerLeft, child: Text('About', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
            const SizedBox(height: 8),
            const Text(
              'Penggerak komunitas lintas kampus yang berfokus pada Data Science, pemrograman Python, dan kompetisi Kaggle. Memfasilitasi diskusi problem-solving bagi mahasiswa tingkat akhir.',
              style: TextStyle(color: Colors.black87, height: 1.5),
            ),
            const SizedBox(height: 24),

            // Portfolio Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCardPlaceholder('Project/Portfolio', Icons.folder, Colors.blue.shade100),
                _buildCardPlaceholder('Certificate', Icons.military_tech, Colors.orange.shade100),
              ],
            ),
            const SizedBox(height: 24),

            // Reviews
            const Align(alignment: Alignment.centerLeft, child: Text('Review & Feedback', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
            const SizedBox(height: 12),
            _buildReview('Cheit Gipiti', 'Penjelasannya sangat rapi dan bagus! Ditambah orangnya ganteng banget.'),
            _buildReview('Jeremy Chris', 'Suka banget, ga hanya teori yang diomongin, tapi prakteknya juga!'),
            
            const SizedBox(height: 24),
            // Action Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Booking (Rp50.000/Sesi)', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCardPlaceholder(String title, IconData icon, Color color) {
    return Container(
      width: 150,
      height: 100,
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: Colors.black54),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildReview(String name, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              const Spacer(),
              const Icon(Icons.star, color: Colors.orange, size: 12),
              const Icon(Icons.star, color: Colors.orange, size: 12),
              const Icon(Icons.star, color: Colors.orange, size: 12),
              const Icon(Icons.star, color: Colors.orange, size: 12),
              const Icon(Icons.star, color: Colors.orange, size: 12),
            ],
          ),
          const SizedBox(height: 4),
          Text(text, style: const TextStyle(fontSize: 12, color: Colors.black87)),
        ],
      ),
    );
  }
}
