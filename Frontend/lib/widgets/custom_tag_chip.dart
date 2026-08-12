import 'package:flutter/material.dart';

class CustomTagChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final bool isTopInterest; // Fitur khusus untuk UI "Top Interest (Bintang)"
  final VoidCallback onTap;

  const CustomTagChip({
    Key? key,
    required this.label,
    required this.isSelected,
    this.isTopInterest = false,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          // Jika dipilih, latarnya hijau pastel. Jika tidak, putih bersih.
          color: isSelected ? const Color(0xFFD7E8D5) : Colors.white,
          border: Border.all(
            // Garis pinggir hijau gelap jika dipilih, abu-abu jika belum
            color: isSelected ? const Color(0xFF2B5C43) : Colors.grey.shade300,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(24), // Bentuk kapsul (pill shape)
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Memunculkan ikon bintang jika ini adalah Top Interest,
            // atau ikon centang jika sekadar dipilih biasa.
            if (isSelected || isTopInterest) ...[
              Icon(
                isTopInterest ? Icons.star : Icons.check,
                size: 16,
                color: const Color(0xFF2B5C43),
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                color: isSelected ? const Color(0xFF2B5C43) : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
