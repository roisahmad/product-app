import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void showBarangDetailSheet(
  BuildContext context,
  Map<String, dynamic> barang,
  void Function()? onEdit,
  void Function()? onDelete,
) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      final screenHeight = MediaQuery.of(context).size.height;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: SizedBox(
          height: screenHeight * 0.75,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 12),

              Container(
                width: double.infinity,
                height: 360,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.image, size: 180, color: Colors.grey),
              ),

              const SizedBox(height: 16),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      _buildDetailRow("Nama barang", barang['nama_barang']),
                      const Divider(height: 4),
                      _buildDetailRow(
                        "Kategori",
                        barang['nama_kategori'] ?? '-',
                      ),
                      const Divider(height: 4),
                      _buildDetailRow("Kelompok", barang['kelompok_barang']),
                      const Divider(height: 4),
                      _buildDetailRow("Stok", barang['stok'].toString()),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 8),

              Container(
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
                padding: const EdgeInsets.all(8.0),
                child: _buildDetailRow(
                  "Harga",
                  NumberFormat.currency(
                    locale: 'id_ID',
                    symbol: 'Rp',
                    decimalDigits: 0,
                  ).format(barang['harga'] ?? 0),
                ),
              ),

              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onDelete,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        ),
                      ),
                      child: const Text("Hapus Barang"),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onEdit,

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF001767),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        ),
                      ),
                      child: const Text("Edit Barang"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget _buildDetailRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(color: Colors.grey[700]),
          ),
        ),
      ],
    ),
  );
}
