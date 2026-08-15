import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class ChatDetailScreen extends StatefulWidget {
  final String partnerId;
  final String partnerName;

  const ChatDetailScreen({
    super.key,
    required this.partnerId,
    required this.partnerName,
  });

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  late IO.Socket socket;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  List<dynamic> _messages = [];
  bool _isLoading = true;
  final String currentUserId = "1"; // Mocked user

  @override
  void initState() {
    super.initState();
    _fetchMessages();
    _initSocket();
  }

  Future<void> _fetchMessages() async {
    try {
      final res = await http.get(Uri.parse('http://34.128.96.164:5000/api/chats/${widget.partnerId}?userId=$currentUserId'));
      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        if (data['success']) {
          setState(() {
            _messages = data['data'];
            _isLoading = false;
          });
          _scrollToBottom();
        }
      }
    } catch (e) {
      debugPrint('Error fetching chat history: $e');
      setState(() => _isLoading = false);
    }
  }

  void _initSocket() {
    socket = IO.io('http://34.128.96.164:5000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();
    socket.onConnect((_) {
      socket.emit('user_connect', int.parse(currentUserId));
    });

    socket.on('receive_message', (data) {
      if (mounted) {
        if (data['senderId'].toString() == widget.partnerId) {
          setState(() {
            _messages.add(data);
          });
          _scrollToBottom();
        }
      }
    });
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final text = _messageController.text;
    _messageController.clear();

    final messageData = {
      'senderId': int.parse(currentUserId),
      'receiverId': int.parse(widget.partnerId),
      'message': text,
      'timestamp': DateTime.now().toIso8601String(),
    };

    // Emit to server
    socket.emit('send_message', messageData);

    // Optimistically update UI
    setState(() {
      _messages.add(messageData);
    });
    _scrollToBottom();
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

  String _formatTime(String timestamp) {
    try {
      final date = DateTime.parse(timestamp).toLocal();
      return DateFormat('HH:mm').format(date);
    } catch (e) {
      return '';
    }
  }

  @override
  void dispose() {
    socket.disconnect();
    socket.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE5DDD5), // WhatsApp chat background color
      appBar: AppBar(
        backgroundColor: const Color(0xFF075E54), // WhatsApp dark green
        iconTheme: const IconThemeData(color: Colors.white),
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.grey.shade400,
              child: Text(
                widget.partnerName[0].toUpperCase(),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                widget.partnerName,
                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.videocam), onPressed: () {}),
          IconButton(icon: const Icon(Icons.call), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final msg = _messages[index];
                      final isMe = msg['sender_id'].toString() == currentUserId || msg['senderId'].toString() == currentUserId;
                      
                      return Align(
                        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.75,
                          ),
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: isMe ? const Color(0xFFDCF8C6) : Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(12),
                                topRight: const Radius.circular(12),
                                bottomLeft: isMe ? const Radius.circular(12) : const Radius.circular(0),
                                bottomRight: isMe ? const Radius.circular(0) : const Radius.circular(12),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 1,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Flexible(
                                  child: Text(
                                    msg['message'] ?? '',
                                    style: const TextStyle(fontSize: 15, color: Colors.black87),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      _formatTime(msg['timestamp']),
                                      style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                                    ),
                                    if (isMe) ...[
                                      const SizedBox(width: 2),
                                      const Icon(Icons.done_all, size: 14, color: Colors.blue),
                                    ]
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          // Input Area
          Container(
            padding: const EdgeInsets.all(8.0),
            color: Colors.transparent,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.emoji_emotions_outlined, color: Colors.grey),
                          onPressed: () {},
                        ),
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            decoration: const InputDecoration(
                              hintText: 'Ketik pesan',
                              border: InputBorder.none,
                            ),
                            maxLines: null,
                            textInputAction: TextInputAction.send,
                            onSubmitted: (_) => _sendMessage(),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.attach_file, color: Colors.grey),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(Icons.camera_alt, color: Colors.grey),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFF075E54),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
