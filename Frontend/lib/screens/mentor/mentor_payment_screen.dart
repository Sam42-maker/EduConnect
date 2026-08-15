import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../home/main_navigation_screen.dart';

class MentorPaymentScreen extends StatefulWidget {
  final Map<String, dynamic> mentorData;
  final String topic;
  final DateTime date;
  final TimeOfDay time;
  final String notes;

  const MentorPaymentScreen({
    super.key,
    required this.mentorData,
    required this.topic,
    required this.date,
    required this.time,
    required this.notes,
  });

  @override
  State<MentorPaymentScreen> createState() => _MentorPaymentScreenState();
}

class _MentorPaymentScreenState extends State<MentorPaymentScreen> {
  final Color brandGreen = const Color(0xFF2B5C43);
  final Color lightGreen = const Color(0xFFE8F2E7);
  
  String? selectedPaymentMethod;
  final List<Map<String, dynamic>> paymentMethods = [
    {'id': 'ovo', 'name': 'OVO', 'icon': Icons.account_balance_wallet},
    {'id': 'gopay', 'name': 'Gopay', 'icon': Icons.account_balance_wallet},
    {'id': 'dana', 'name': 'DANA', 'icon': Icons.account_balance_wallet},
    {'id': 'bca', 'name': 'BCA Virtual Account', 'icon': Icons.account_balance},
    {'id': 'qris', 'name': 'QRIS', 'icon': Icons.qr_code_2},
  ];

  void _showQrisModal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return QrisPaymentDialog(
          amount: widget.mentorData['price'],
          onSuccess: _showSuccessModal,
        );
      },
    );
  }

  void _showSuccessModal() async {
    Navigator.pop(context); // Close QRIS dialog

    // Simpan ke backend
    try {
      final currentUserId = 1; // Dummy current user id (Shandy Developer)
      final body = {
        'studentId': currentUserId,
        'mentorId': int.parse(widget.mentorData['id']),
        'topic': widget.topic,
        'scheduleDate': widget.date.toIso8601String().split('T')[0],
        'scheduleTime': '${widget.time.hour.toString().padLeft(2, '0')}:${widget.time.minute.toString().padLeft(2, '0')}:00',
        'notes': widget.notes,
        'paymentMethod': selectedPaymentMethod,
        'amount': widget.mentorData['price'],
      };

      await http.post(
        Uri.parse('http://34.128.96.164:5000/api/mentors/book'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );
    } catch (e) {
      print('Gagal menyimpan booking: $e');
    }
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: lightGreen,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle, color: Colors.green, size: 64),
              ),
              const SizedBox(height: 24),
              const Text(
                'Payment Successful',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                'Pembayaran sesi mentoring Anda telah berhasil dikonfirmasi.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // close dialog
                    _navigateToConfirmation();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: brandGreen,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Lanjutkan', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _navigateToConfirmation() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => BookingConfirmationScreen(
          mentorData: widget.mentorData,
          topic: widget.topic,
          date: widget.date,
          time: widget.time,
        ),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text('Pembayaran', style: TextStyle(color: Colors.black, fontSize: 16)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Summary
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Ringkasan Sesi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 16),
                  _buildSummaryRow('Mentor', widget.mentorData['name']),
                  const SizedBox(height: 8),
                  _buildSummaryRow('Topik', widget.topic),
                  const SizedBox(height: 8),
                  _buildSummaryRow('Jadwal', '${widget.date.day}/${widget.date.month}/${widget.date.year} - ${widget.time.format(context)}'),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Pembayaran', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                        'Rp${widget.mentorData['price']}',
                        style: TextStyle(fontWeight: FontWeight.bold, color: brandGreen, fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Payment Methods
            const Text('Metode Pembayaran', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 16),
            ...paymentMethods.map((method) {
              final isSelected = selectedPaymentMethod == method['id'];
              return GestureDetector(
                onTap: () {
                  setState(() => selectedPaymentMethod = method['id']);
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSelected ? lightGreen : Colors.white,
                    border: Border.all(color: isSelected ? brandGreen : Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(method['icon'], color: isSelected ? brandGreen : Colors.grey.shade600),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          method['name'],
                          style: TextStyle(
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? brandGreen : Colors.black87,
                          ),
                        ),
                      ),
                      Radio<String>(
                        value: method['id'],
                        groupValue: selectedPaymentMethod,
                        activeColor: brandGreen,
                        onChanged: (value) {
                          setState(() => selectedPaymentMethod = value);
                        },
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ElevatedButton(
            onPressed: () {
              if (selectedPaymentMethod == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Pilih metode pembayaran terlebih dahulu')),
                );
                return;
              }
              
              if (selectedPaymentMethod == 'qris') {
                _showQrisModal();
              } else {
                // For dummy flow, just show success directly for other methods
                _showSuccessModal();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: brandGreen,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Bayar Sekarang', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 80, child: Text(label, style: const TextStyle(color: Colors.grey))),
        const Text(': ', style: TextStyle(color: Colors.grey)),
        Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500))),
      ],
    );
  }
}

// QRIS Dialog component
class QrisPaymentDialog extends StatefulWidget {
  final int amount;
  final VoidCallback onSuccess;

  const QrisPaymentDialog({super.key, required this.amount, required this.onSuccess});

  @override
  State<QrisPaymentDialog> createState() => _QrisPaymentDialogState();
}

class _QrisPaymentDialogState extends State<QrisPaymentDialog> {
  int secondsRemaining = 300; // 5 minutes
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining > 0) {
        setState(() => secondsRemaining--);
      } else {
        timer.cancel();
        Navigator.pop(context); // Close dialog if time runs out
      }
    });

    // Auto-success after 5 seconds for demonstration purposes
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        widget.onSuccess();
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  String get timerText {
    int m = secondsRemaining ~/ 60;
    int s = secondsRemaining % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Scan QRIS', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Buka aplikasi pembayaran Anda dan scan QR Code di bawah ini.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 24),
          
          // Dummy QR Code
          Container(
            width: 200,
            height: 200,
            color: Colors.black,
            child: const Center(
              child: Icon(Icons.qr_code_scanner, color: Colors.white, size: 100),
            ),
          ),
          
          const SizedBox(height: 24),
          const Text('Sisa Waktu Pembayaran', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 8),
          Text(
            timerText,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red),
          ),
          const SizedBox(height: 12),
          const Text('Mendeteksi pembayaran...', style: TextStyle(color: Color(0xFF2B5C43), fontStyle: FontStyle.italic)),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal', style: TextStyle(color: Colors.grey)),
        )
      ],
    );
  }
}

// Confirmation Screen
class BookingConfirmationScreen extends StatelessWidget {
  final Map<String, dynamic> mentorData;
  final String topic;
  final DateTime date;
  final TimeOfDay time;

  const BookingConfirmationScreen({
    super.key,
    required this.mentorData,
    required this.topic,
    required this.date,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.access_time_filled, color: Color(0xFF2B5C43), size: 100),
              const SizedBox(height: 24),
              const Text(
                'Session Request Sent\nPls wait for a moment',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'Permintaan sesi Anda telah dikirim ke mentor. Anda akan mendapatkan notifikasi ketika mentor menyetujui sesi ini.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, height: 1.5),
              ),
              const SizedBox(height: 32),
              
              // Summary card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(mentorData['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 8),
                    Text('$topic - ${date.day}/${date.month}/${date.year}', style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
              const SizedBox(height: 48),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Return to Home (MainNavigationScreen)
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const MainNavigationScreen(initialIndex: 4)),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2B5C43),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Kembali ke Beranda', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
