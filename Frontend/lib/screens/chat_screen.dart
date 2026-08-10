import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color primaryGreen = const Color(0xFF2E5A40);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Pesan', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari percakapan...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                _buildChatListTile('Reza Mahardika', 'Oke siap, besok kita bisa sesi bareng ya', '09:30', '2', primaryGreen),
                _buildChatListTile('Bintang Nugroho', '📎 paper_review_cv.pdf', 'Kemarin', '1', primaryGreen),
                _buildChatListTile('Lestari Rahayu', 'Sesi kemarin sudah aku mark done ✔', 'Sel', '', primaryGreen),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildChatListTile(String name, String lastMsg, String time, String unread, Color primary) {
    return ListTile(
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: primary.withOpacity(0.2),
        child: Text(name[0], style: TextStyle(color: primary, fontWeight: FontWeight.bold, fontSize: 20)),
      ),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(lastMsg, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.grey)),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(time, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          if (unread.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(color: primary, shape: BoxShape.circle),
              child: Text(unread, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
            )
        ],
      ),
    );
  }
}
