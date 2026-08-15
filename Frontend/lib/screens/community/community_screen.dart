import 'package:flutter/material.dart';
import 'community_detail_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

class DummyCommunity {
  final String id;
  final String name;
  final String iconInitial;
  final Color iconColor;
  final String accessLevel;
  final String objective;
  final List<String> tags;
  final String description;
  final String memberCount;

  DummyCommunity({
    required this.id,
    required this.name,
    required this.iconInitial,
    required this.iconColor,
    required this.accessLevel,
    required this.objective,
    required this.tags,
    required this.description,
    required this.memberCount,
  });
}

class CommunityScreen extends StatefulWidget {
  final String title;

  const CommunityScreen({super.key, this.title = 'Komunitas'});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final Color brandColor = const Color(0xFF2B5C43);
  
  List<DummyCommunity> _communities = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCommunities();
  }

  Future<void> _fetchCommunities() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:5000/api/communities'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          setState(() {
            _communities = (data['data'] as List).map((c) {
              return DummyCommunity(
                id: c['id'].toString(),
                name: c['name'],
                iconInitial: c['icon_initial'] ?? 'C',
                iconColor: brandColor,
                accessLevel: c['privacy'] == 'Private' ? 'Verified' : 'Publik',
                objective: c['objective'] ?? 'Umum',
                tags: (c['tags'] is List) ? List<String>.from(c['tags']) : [],
                description: c['description'] ?? '',
                memberCount: '1 anggota', // TODO: count from members table
              );
            }).toList();
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      debugPrint('Error fetching communities: $e');
      setState(() => _isLoading = false);
    }
  }

  Widget _buildCommunityCard(DummyCommunity community) {
    final isVerified = community.accessLevel == 'Campus-Verified';
    
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CommunityDetailScreen(
              communityId: community.id,
              communityName: community.name,
              isAdmin: false, // Default member
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: const EdgeInsets.all(20),
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
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: community.iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Text(
                      community.iconInitial, 
                      style: TextStyle(fontWeight: FontWeight.w900, color: community.iconColor, fontSize: 18)
                    )
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(community.name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: Colors.black87)),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: isVerified ? brandColor : Colors.grey.shade600,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (isVerified) const Icon(Icons.verified, color: Colors.white, size: 12),
                                if (isVerified) const SizedBox(width: 4),
                                Text(
                                  community.accessLevel, 
                                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              community.objective, 
                              style: TextStyle(color: Colors.blue.shade700, fontSize: 10, fontWeight: FontWeight.bold)
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: community.tags.map((tag) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(tag, style: TextStyle(fontSize: 11, color: Colors.grey.shade700, fontWeight: FontWeight.w600)),
              )).toList(),
            ),
            const SizedBox(height: 16),
            Text(
              community.description,
              style: const TextStyle(fontSize: 13, color: Colors.black87, height: 1.4),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 60,
                      height: 24,
                      child: Stack(
                        children: [
                          Positioned(left: 0, child: CircleAvatar(radius: 12, backgroundColor: Colors.blue.shade200)),
                          Positioned(left: 15, child: CircleAvatar(radius: 12, backgroundColor: Colors.orange.shade200)),
                          Positioned(left: 30, child: CircleAvatar(radius: 12, backgroundColor: Colors.pink.shade200)),
                        ],
                      ),
                    ),
                    Text(community.memberCount, style: const TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.bold)),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CommunityDetailScreen(
                          communityId: community.id,
                          communityName: community.name,
                          isAdmin: false,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isVerified ? brandColor : Colors.grey.shade800,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(isVerified ? 'Gabung' : 'Lihat', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _showCreateGroupDialog() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descController = TextEditingController();
    final TextEditingController tagController = TextEditingController();
    
    List<String> tags = [];
    List<String> textChannels = ['#general'];
    List<String> voiceChannels = ['Diskusi Terbuka'];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: const Text('Buat Komunitas Baru', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2B5C43))),
              content: SizedBox(
                width: 400,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: nameController,
                        decoration: const InputDecoration(labelText: 'Nama Grup', border: OutlineInputBorder()),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: descController,
                        decoration: const InputDecoration(labelText: 'Deskripsi', border: OutlineInputBorder()),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 12),
                      // Input Tags
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: tagController,
                              decoration: const InputDecoration(labelText: 'Tambah Tag Minat', border: OutlineInputBorder(), isDense: true),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle, color: Color(0xFF2B5C43)),
                            onPressed: () {
                              if (tagController.text.isNotEmpty) {
                                setModalState(() {
                                  tags.add(tagController.text);
                                  tagController.clear();
                                });
                              }
                            },
                          )
                        ],
                      ),
                      if (tags.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Wrap(
                            spacing: 4,
                            children: tags.map((t) => Chip(
                              label: Text(t, style: const TextStyle(fontSize: 10)),
                              onDeleted: () => setModalState(() => tags.remove(t)),
                            )).toList(),
                          ),
                        ),
                      const Divider(height: 24),
                      const Text('Text Channels (Awalan #)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      ...textChannels.map((tc) => Row(
                        children: [
                          const Icon(Icons.tag, size: 14),
                          const SizedBox(width: 4),
                          Expanded(child: Text(tc)),
                          if (tc != '#general')
                            IconButton(
                              icon: const Icon(Icons.delete, size: 16, color: Colors.red),
                              onPressed: () => setModalState(() => textChannels.remove(tc)),
                            )
                        ],
                      )),
                      TextButton.icon(
                        onPressed: () {
                          // Simple mock add
                          setModalState(() => textChannels.add('#channel-${textChannels.length + 1}'));
                        },
                        icon: const Icon(Icons.add, size: 14),
                        label: const Text('Tambah Text Channel'),
                      ),
                      const Divider(height: 24),
                      const Text('Voice Channels', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      ...voiceChannels.map((vc) => Row(
                        children: [
                          const Icon(Icons.volume_up, size: 14),
                          const SizedBox(width: 4),
                          Expanded(child: Text(vc)),
                          IconButton(
                            icon: const Icon(Icons.delete, size: 16, color: Colors.red),
                            onPressed: () => setModalState(() => voiceChannels.remove(vc)),
                          )
                        ],
                      )),
                      TextButton.icon(
                        onPressed: () {
                          setModalState(() => voiceChannels.add('Room ${voiceChannels.length + 1}'));
                        },
                        icon: const Icon(Icons.add, size: 14),
                        label: const Text('Tambah Voice Channel'),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Batal', style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (nameController.text.isNotEmpty) {
                      final body = {
                        "name": nameController.text,
                        "description": descController.text,
                        "icon_initial": nameController.text.substring(0, 1).toUpperCase(),
                        "tags": tags,
                        "textChannels": textChannels,
                        "voiceChannels": voiceChannels
                      };

                      try {
                        final res = await http.post(
                          Uri.parse('http://localhost:5000/api/communities'),
                          headers: {"Content-Type": "application/json"},
                          body: json.encode(body),
                        );
                        
                        if (res.statusCode == 201) {
                          final data = json.decode(res.body);
                          _fetchCommunities(); // Refresh list
                          Navigator.pop(context);
                          
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CommunityDetailScreen(
                                communityId: data['communityId'].toString(),
                                communityName: nameController.text,
                                isAdmin: true,
                              ),
                            ),
                          );
                        }
                      } catch (e) {
                        debugPrint('Gagal buat komunitas: $e');
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2B5C43)),
                  child: const Text('Buat Grup', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            );
          }
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: Text(widget.title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: brandColor,
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Temukan Ruang Kolaborasimu',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.black87),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Ruang kolaborasi berbasis topik & jurusan',
                  style: TextStyle(fontSize: 13, color: Colors.black54),
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Cari komunitas atau topik...',
                      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                      prefixIcon: const Icon(Icons.search, color: Color(0xFF2B5C43)),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
          _isLoading ? const Center(child: CircularProgressIndicator()) : Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 30),
              itemCount: _communities.length,
              itemBuilder: (context, index) {
                return _buildCommunityCard(_communities[index]);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreateGroupDialog,
        backgroundColor: brandColor,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Buat Grup', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
