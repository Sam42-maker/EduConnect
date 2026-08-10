import 'package:flutter/material.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color primaryGreen = const Color(0xFF2E5A40);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryGreen,
        elevation: 0,
        title: const Text('Komunitas', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: const Icon(Icons.search, color: Colors.white), onPressed: () {}),
        ],
      ),
      body: Row(
        children: [
          // Sidebar ala Discord (Channels)
          Container(
            width: 100,
            color: Colors.grey.shade100,
            child: ListView(
              children: [
                _buildChannelItem(Icons.groups, 'ML Study Group', true, primaryGreen),
                _buildChannelItem(Icons.book, 'Skripsi Circle', false, primaryGreen),
                _buildChannelItem(Icons.code, 'Web Dev ID', false, primaryGreen),
              ],
            ),
          ),
          // Main Chat Area
          Expanded(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade200))),
                  child: Row(
                    children: [
                      const Icon(Icons.tag, color: Colors.grey),
                      const SizedBox(width: 8),
                      const Text('General', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      _buildChatBubble('Frank Castle', 'Guys! Kalian mau mentoring gak sama dosen willy?', '19:43', false),
                      _buildChatBubble('Shandy A', 'Emang dia bisa malam ini?', '19:45', true, primaryGreen),
                      _buildChatBubble('Gabriel C', 'Hayya, dia online malam ini pasti bisalah', '19:55', false),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.grey.shade200))),
                  child: Row(
                    children: [
                      IconButton(icon: const Icon(Icons.add_circle_outline, color: Colors.grey), onPressed: () {}),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Message #General',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          ),
                        ),
                      ),
                      IconButton(icon: Icon(Icons.send, color: primaryGreen), onPressed: () {}),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildChannelItem(IconData icon, String name, bool isActive, Color primary) {
    return Container(
      color: isActive ? primary.withOpacity(0.1) : Colors.transparent,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          Icon(icon, color: isActive ? primary : Colors.grey, size: 32),
          const SizedBox(height: 4),
          Text(name, textAlign: TextAlign.center, style: TextStyle(fontSize: 10, color: isActive ? primary : Colors.grey, fontWeight: isActive ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }

  Widget _buildChatBubble(String sender, String message, String time, bool isMe, [Color? primary]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isMe) CircleAvatar(radius: 16, backgroundColor: Colors.grey.shade300, child: Text(sender[0], style: const TextStyle(color: Colors.black))),
          if (!isMe) const SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isMe ? primary : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isMe) Text(sender, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: primary ?? Colors.black)),
                  if (!isMe) const SizedBox(height: 4),
                  Text(message, style: TextStyle(color: isMe ? Colors.white : Colors.black87)),
                  const SizedBox(height: 4),
                  Text(time, style: TextStyle(fontSize: 10, color: isMe ? Colors.white70 : Colors.grey)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
