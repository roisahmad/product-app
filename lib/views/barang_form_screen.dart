import 'package:flutter/material.dart';
import 'package:product_app/viewmodels/kategori_barang_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:product_app/models/barang_model.dart';
import 'package:product_app/viewmodels/barang_viewmodel.dart';

class BarangFormScreen extends StatefulWidget {
  final Map<String, dynamic>? barang;

  const BarangFormScreen({super.key, this.barang});

  @override
  State<BarangFormScreen> createState() => _BarangFormScreenState();
}

class _BarangFormScreenState extends State<BarangFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _namaController = TextEditingController();
  final _kelompokController = TextEditingController();
  final _stokController = TextEditingController();
  final _hargaController = TextEditingController();

  int? _selectedKategoriId;

  @override
  void initState() {
    super.initState();

    final kategoriVM = Provider.of<KategoriBarangViewModel>(
      context,
      listen: false,
    );
    kategoriVM.fetchKategori();

    if (widget.barang != null) {
      final b = widget.barang!;
      _namaController.text = b['nama_barang'] ?? '';
      _kelompokController.text = b['kelompok_barang'] ?? '';
      _stokController.text = (b['stok'] ?? '').toString();
      _hargaController.text = (b['harga'] ?? '').toString();
      _selectedKategoriId = b['kategori_id'];
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final barang = Barang(
        id: widget.barang?['id'],
        namaBarang: _namaController.text.trim(),
        kelompokBarang: _kelompokController.text.trim(),
        stok: int.tryParse(_stokController.text.trim()) ?? 0,
        harga: int.tryParse(_hargaController.text.trim()) ?? 0,
        kategoriId: _selectedKategoriId!,
      );

      final vm = Provider.of<BarangViewModel>(context, listen: false);
      if (widget.barang == null) {
        vm.addBarang(barang);
      } else {
        vm.updateBarang(barang);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final kategoriVM = Provider.of<KategoriBarangViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.barang == null ? "Tambah Barang" : "Edit Barang"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(
                controller: _namaController,
                label: 'Nama Barang*',
                hint: 'Masukan Nama Barang',
                validatorMessage: 'Nama Barang Belum diisi',
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: _selectedKategoriId,
                items:
                    kategoriVM.kategoriList
                        .map(
                          (k) => DropdownMenuItem(
                            value: k.id,
                            child: Text(k.namaKategori),
                          ),
                        )
                        .toList(),
                decoration: _inputDecoration(
                  label: 'Kategori Barang*',
                  hint: 'Masukan Kategori Barang',
                ),
                validator:
                    (val) => val == null ? 'Kategori Barang Belum diisi' : null,
                onChanged: (val) => setState(() => _selectedKategoriId = val),
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _kelompokController,
                label: 'Kelompok Barang*',
                hint: 'Masukan Kelompok Barang',
                validatorMessage: 'Kelompok Barang Belum diisi',
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _stokController,
                label: 'Stok*',
                hint: 'Masukan Stok',
                keyboardType: TextInputType.number,
                validatorMessage: 'Stok Belum diisi',
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _hargaController,
                label: 'Harga*',
                hint: 'Masukan Harga',
                keyboardType: TextInputType.number,
                validatorMessage: 'Harga Belum diisi',
              ),
              const SizedBox(height: 80), // Jarak dengan bottom button
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) _submit();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF001767),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
            ),
            child: Text(
              widget.barang == null ? 'Tambah Barang' : 'Simpan Perubahan',
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required String validatorMessage,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: _inputDecoration(label: label, hint: hint),
      validator:
          (val) => val == null || val.trim().isEmpty ? validatorMessage : null,
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required String hint,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      errorStyle: const TextStyle(color: Colors.red),
    );
  }
}
