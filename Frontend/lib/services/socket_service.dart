import 'package:frontend/services/api_client.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'api_client.dart';

class SocketService {
  late IO.Socket socket;

  void initSocket(int userId) {
    // Hubungkan ke server yang sama dengan API
    socket = IO.io(ApiClient.baseUrl.replaceAll('/api', ''), <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();

    socket.onConnect((_) {
      print('✅ Terhubung ke Socket Server');
      // Daftarkan user ID ini ke server Redis/Socket
      socket.emit('user_connect', userId);
    });

    // Dengarkan jika ada pesan masuk
    socket.on('receive_message', (data) {
      print('💬 Pesan baru diterima: $data');
      // Nanti ini bisa disambungkan ke state management (Provider/Bloc) untuk update UI
    });

    socket.onDisconnect((_) => print('❌ Terputus dari Socket Server'));
  }

  // Fungsi untuk mengirim chat
  void sendMessage(int senderId, int receiverId, String messageText) {
    final payload = {
      'senderId': senderId,
      'receiverId': receiverId,
      'message': messageText,
    };
    socket.emit('send_message', payload);
  }

  // Membersihkan memori saat aplikasi ditutup
  void dispose() {
    socket.disconnect();
  }
}
