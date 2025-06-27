import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:product_app/widgets/bottomsheet_detail.dart';
import 'package:provider/provider.dart';
import 'package:product_app/viewmodels/barang_viewmodel.dart';
import 'barang_form_screen.dart';

class BarangListScreen extends StatefulWidget {
  const BarangListScreen({super.key});

  @override
  State<BarangListScreen> createState() => _BarangListScreenState();
}

class _BarangListScreenState extends State<BarangListScreen> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  bool _isEditing = false;
  Set<int> _selectedIds = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = Provider.of<BarangViewModel>(context, listen: false);
      if (vm.barangList.isEmpty) {
        vm.fetchBarang(initial: true);
      }
    });
  }

  void _toggleSearch(BarangViewModel vm) {
    setState(() {
      if (_isSearching) {
        _isSearching = false;
        _searchController.clear();
        vm.setSearch('');
      } else {
        _isSearching = true;
      }
    });
  }

  void handleEditBarang(BuildContext context, Map<String, dynamic> barang) {
    Navigator.pop(context); // Tutup bottomsheet
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => BarangFormScreen(barang: barang)),
    );
  }

  Future<void> handleDeleteBarang(
    BuildContext context,
    Map<String, dynamic> barang,
    BarangViewModel vm,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Konfirmasi"),
            content: const Text("Yakin ingin menghapus barang ini?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Batal"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text("Hapus"),
              ),
            ],
          ),
    );

    if (confirm == true) {
      Navigator.pop(context); // Tutup bottomsheet
      await vm.deleteBarang(barang['id']);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<BarangViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        leading:
            Navigator.canPop(context)
                ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                )
                : null,
        title:
            _isSearching
                ? TextField(
                  controller: _searchController,
                  autofocus: true,
                  textAlignVertical:
                      TextAlignVertical.center, // center isi textfield
                  decoration: InputDecoration(
                    hintText: 'Cari barang...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8), // rounded penuh
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor:
                        Colors.blue[50], // background biru di dalam textfield
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 20,
                    ),
                  ),
                  onChanged: (val) => vm.setSearch(val),
                )
                : const Text("List Stok Barang"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () => _toggleSearch(vm),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child:
                vm.isLoading && vm.barangList.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : vm.barangList.isEmpty
                    ? const Center(child: Text("Tidak ada data ditemukan"))
                    : NotificationListener<ScrollNotification>(
                      onNotification: (scrollInfo) {
                        if (!vm.isLoading &&
                            vm.hasMore &&
                            scrollInfo.metrics.pixels ==
                                scrollInfo.metrics.maxScrollExtent) {
                          vm.fetchBarang();
                        }
                        return false;
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _isSearching
                                      ? "${vm.totalFiltered} Data cocok"
                                      : "${vm.totalAll} Data ditamppilkan",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _isEditing = !_isEditing;
                                      _selectedIds.clear(); // reset selected
                                    });
                                  },
                                  child: Text(
                                    _isEditing ? "Batal" : "Edit Data",
                                    style: TextStyle(color: Colors.blue[500]),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount:
                                  vm.barangList.length + (vm.hasMore ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (index == vm.barangList.length) {
                                  return const Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                }

                                final barang = vm.barangList[index];

                                return Column(
                                  children: [
                                    ListTile(
                                      leading:
                                          _isEditing
                                              ? Checkbox(
                                                value: _selectedIds.contains(
                                                  barang['id'],
                                                ),
                                                onChanged: (bool? checked) {
                                                  setState(() {
                                                    if (checked == true) {
                                                      _selectedIds.add(
                                                        barang['id'],
                                                      );
                                                    } else {
                                                      _selectedIds.remove(
                                                        barang['id'],
                                                      );
                                                    }
                                                  });
                                                },
                                              )
                                              : null,
                                      title: Text(
                                        barang['nama_barang'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                        ),
                                      ),
                                      subtitle: Text(
                                        "Stok: ${barang['stok'] ?? '-'}",
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            NumberFormat.currency(
                                              locale: 'id_ID',
                                              symbol: 'Rp',
                                              decimalDigits: 0,
                                            ).format(barang['harga'] ?? 0),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                      onTap: () {
                                        showBarangDetailSheet(
                                          context,
                                          barang,
                                          () =>
                                              handleEditBarang(context, barang),
                                          () => handleDeleteBarang(
                                            context,
                                            barang,
                                            vm,
                                          ),
                                        );
                                      },
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                      ),
                                      child: const Divider(height: 1),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
          ),
        ],
      ),
      floatingActionButton:
          _isEditing
              ? null
              : FloatingActionButton.extended(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const BarangFormScreen()),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text("Barang"),
                backgroundColor: const Color(0xFF001767),
                foregroundColor: Colors.white,
              ),
      bottomNavigationBar:
          _isEditing
              ? BottomAppBar(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: _selectedIds.length == vm.barangList.length,
                            onChanged: (val) {
                              setState(() {
                                if (val == true) {
                                  _selectedIds =
                                      vm.barangList
                                          .map<int>((e) => e['id'] as int)
                                          .toSet();
                                } else {
                                  _selectedIds.clear();
                                }
                              });
                            },
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if (_selectedIds.length ==
                                    vm.barangList.length) {
                                  _selectedIds.clear();
                                } else {
                                  _selectedIds =
                                      vm.barangList
                                          .map<int>((e) => e['id'] as int)
                                          .toSet();
                                }
                              });
                            },
                            child: Text(
                              _selectedIds.length < vm.barangList.length
                                  ? "Pilih Semua"
                                  : "Kosongkan",
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      OutlinedButton.icon(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        label: const Text(
                          "Hapus Barang",
                          style: TextStyle(color: Colors.red),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                          ),
                        ),
                        onPressed:
                            _selectedIds.isEmpty
                                ? null
                                : () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder:
                                        (_) => AlertDialog(
                                          title: const Text("Konfirmasi"),
                                          content: Text(
                                            "Yakin ingin menghapus ${_selectedIds.length} barang terpilih?",
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed:
                                                  () => Navigator.pop(
                                                    context,
                                                    false,
                                                  ),
                                              child: const Text("Batal"),
                                            ),
                                            ElevatedButton(
                                              onPressed:
                                                  () => Navigator.pop(
                                                    context,
                                                    true,
                                                  ),
                                              child: const Text("Hapus"),
                                            ),
                                          ],
                                        ),
                                  );

                                  if (confirm == true) {
                                    await vm.bulkDeleteBarang(
                                      _selectedIds.toList(),
                                    );
                                    setState(() {
                                      _selectedIds.clear();
                                      _isEditing = false;
                                    });
                                  }
                                },
                      ),
                    ],
                  ),
                ),
              )
              : BottomAppBar(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [Text("Total Stok"), Text("${vm.totalStok}")],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("Total Harga"),
                          Text(
                            NumberFormat.currency(
                              locale: 'id_ID',
                              symbol: 'Rp',
                              decimalDigits: 0,
                            ).format(vm.totalHarga),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
