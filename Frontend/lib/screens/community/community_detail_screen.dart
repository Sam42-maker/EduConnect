import 'package:frontend/services/api_client.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CommunityDetailScreen extends StatefulWidget {
  final String communityId;
  final String communityName;
  final bool isAdmin;
  
  const CommunityDetailScreen({
    super.key,
    required this.communityId,
    required this.communityName,
    this.isAdmin = false,
  });

  @override
  State<CommunityDetailScreen> createState() => _CommunityDetailScreenState();
}

class _CommunityDetailScreenState extends State<CommunityDetailScreen> {
  final Color brandColor = const Color(0xFF2B5C43);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  String _currentChannel = '#general';
  String _currentChannelId = '';
  late IO.Socket socket;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  bool _isLoadingChannels = true;
  List<dynamic> _textChannels = [];
  List<dynamic> _voiceChannels = [];
  List<Map<String, dynamic>> messages = [];

  @override
  void initState() {
    super.initState();
    _fetchChannels();
    _initSocket();
  }

  Future<void> _fetchChannels() async {
    try {
      final res = await http.get(Uri.parse(ApiClient.baseUrl + '/communities/${widget.communityId}/channels'));
      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        if (data['success']) {
          final allChannels = data['data'] as List;
          setState(() {
            _textChannels = allChannels.where((c) => c['type'] == 'text').toList();
            _voiceChannels = allChannels.where((c) => c['type'] == 'voice').toList();
            
            if (_textChannels.isNotEmpty) {
              _currentChannel = _textChannels[0]['name'];
              _currentChannelId = _textChannels[0]['id'].toString();
              _fetchMessages(_currentChannelId);
              _joinChannel(_currentChannelId);
            }
            _isLoadingChannels = false;
          });
        }
      }
    } catch (e) {
      debugPrint('Error fetching channels: $e');
    }
  }

  Future<void> _fetchMessages(String channelId) async {
    try {
      final res = await http.get(Uri.parse(ApiClient.baseUrl + '/communities/channels/$channelId/messages'));
      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        setState(() {
          messages = (data['data'] as List).map((m) => {
            'sender': m['sender_name'],
            'text': m['text'],
            'time': m['created_at'] != null ? DateFormat('HH:mm').format(DateTime.parse(m['created_at'])) : _currentTime(),
            'isMe': m['sender_name'] == 'Anindya Putri', // Mocking current user check
          }).toList();
        });
        _scrollToBottom();
      }
    } catch (e) {
      debugPrint('Error fetching messages: $e');
    }
  }

  void _joinChannel(String channelId) {
    if (socket.connected) {
      socket.emit('join_channel', channelId);
    }
  }

  void _initSocket() {
    try {
      // Connect to Socket.IO server
      socket = IO.io(ApiClient.baseUrl.replaceAll('/api', ''), <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      });

      socket.connect();

      socket.onConnect((_) {
        debugPrint('Connected to Socket.IO');
      });

      socket.on('receive_channel_message', (data) {
        if (mounted && data['channelId'].toString() == _currentChannelId) {
          setState(() {
            messages.add({
              'sender': data['sender'] ?? 'User',
              'text': data['text'] ?? '',
              'time': data['time'] ?? _currentTime(),
              'isMe': data['sender'] == 'Anindya Putri', 
            });
          });
          _scrollToBottom();
        }
      });

      socket.onDisconnect((_) => debugPrint('Disconnected from Socket.IO'));
    } catch (e) {
      debugPrint('Socket IO error: $e');
    }
  }

  String _currentTime() {
    return DateFormat('HH:mm').format(DateTime.now());
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty || _currentChannelId.isEmpty) return;
    
    final text = _messageController.text;
    _messageController.clear();
    
    final messageData = {
      'channelId': _currentChannelId,
      'senderId': 1,
      'senderName': 'Anindya Putri',
      'text': text,
    };

    socket.emit('send_channel_message', messageData);
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    socket.disconnect();
    socket.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildSidebar() {
    return Drawer(
      backgroundColor: const Color(0xFF1E1E1E), // Dark theme like Discord
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.white12)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.arrow_back_ios, color: Colors.white, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.communityName,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _isLoadingChannels ? const Center(child: CircularProgressIndicator()) : ListView(
                padding: const EdgeInsets.all(12),
                children: [
                  if (_textChannels.isNotEmpty) ...[
                    const Text('TEXT CHANNELS', style: TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    ..._textChannels.map((c) => _buildChannelItem(c['name'], c['id'].toString(), _currentChannelId == c['id'].toString())),
                    const SizedBox(height: 24),
                  ],
                  if (_voiceChannels.isNotEmpty) ...[
                    const Text('VOICE CHANNELS', style: TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    ..._voiceChannels.map((c) => _buildVoiceChannelItem(c['name'])),
                  ]
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChannelItem(String title, String id, bool isSelected) {
    return InkWell(
      onTap: () {
        setState(() {
          _currentChannel = title;
          _currentChannelId = id;
        });
        _fetchMessages(id);
        _joinChannel(id);
        Navigator.pop(context); // Close drawer
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white12 : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(Icons.tag, color: isSelected ? Colors.white : Colors.white54, size: 18),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(color: isSelected ? Colors.white : Colors.white54, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVoiceChannelItem(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.volume_up, color: Colors.white54, size: 18),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(color: Colors.white54)),
            ],
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.only(left: 26),
            child: Row(
              children: [
                CircleAvatar(radius: 14, backgroundColor: Colors.orange.shade300, child: const Text('R', style: TextStyle(fontSize: 12))),
                const SizedBox(width: 8),
                CircleAvatar(radius: 14, backgroundColor: Colors.blue.shade300, child: const Text('B', style: TextStyle(fontSize: 12))),
                const SizedBox(width: 8),
                CircleAvatar(radius: 14, backgroundColor: Colors.pink.shade300, child: const Text('C', style: TextStyle(fontSize: 12))),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildChatBubble(Map<String, dynamic> message) {
    final bool isMe = message['isMe'];
    final String sender = message['sender'];
    final String text = message['text'];
    final String time = message['time'];
    final String initial = sender.isNotEmpty ? sender[0].toUpperCase() : '?';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe) ...[
            CircleAvatar(
              radius: 18,
              backgroundColor: brandColor.withOpacity(0.8),
              child: Text(initial, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 12),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!isMe) ...[
                      Text(sender, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87)),
                      const SizedBox(width: 8),
                    ],
                    Text(time, style: const TextStyle(fontSize: 11, color: Colors.black45)),
                  ],
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isMe ? brandColor : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(isMe ? 16 : 0),
                      bottomRight: Radius.circular(isMe ? 0 : 16),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),
                  child: Text(
                    text,
                    style: TextStyle(
                      color: isMe ? Colors.white : Colors.black87,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isMe) const SizedBox(width: 30),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          )
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            InkWell(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add, color: Colors.black54),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    hintText: 'Message...',
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
            ),
            const SizedBox(width: 12),
            InkWell(
              onTap: _sendMessage,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: brandColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.send, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF4F6F5),
      drawer: _buildSidebar(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.black12,
        leadingWidth: 80,
        leading: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black87),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            IconButton(
              icon: const Icon(Icons.menu, color: Colors.black87),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
            ),
          ],
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(widget.communityName, style: const TextStyle(color: Colors.black54, fontSize: 12, fontWeight: FontWeight.bold)),
                if (widget.isAdmin) ...[
                  const SizedBox(width: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(
                      color: brandColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text('Admin', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                  ),
                ],
              ],
            ),
            Text(_currentChannel, style: const TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.w900)),
          ],
        ),
        actions: [
          if (widget.isAdmin)
            IconButton(icon: const Icon(Icons.settings_outlined, color: Colors.black87), onPressed: () {}),
          IconButton(icon: const Icon(Icons.call_outlined, color: Colors.black87), onPressed: () {}),
          IconButton(icon: const Icon(Icons.videocam_outlined, color: Colors.black87), onPressed: () {}),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(20),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return _buildChatBubble(messages[index]);
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }
}
