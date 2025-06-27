import 'package:flutter/material.dart';
import 'package:product_app/models/kategori_barang_model.dart';
import 'package:product_app/repositories/kategori_barang_repository.dart';

class KategoriBarangViewModel extends ChangeNotifier {
  List<KategoriBarang> _kategoriList = [];
  bool _isLoading = false;

  List<KategoriBarang> get kategoriList => _kategoriList;
  bool get isLoading => _isLoading;

  Future<void> fetchKategori() async {
    _isLoading = true;
    notifyListeners();

    try {
      _kategoriList = await KategoriBarangRepository.getAll();
    } catch (e) {
      debugPrint("Error fetching kategori: $e");
      _kategoriList = [];
    }

    _isLoading = false;
    notifyListeners();
  }
}
