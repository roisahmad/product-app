import 'package:flutter/material.dart';
import 'package:product_app/models/barang_model.dart';
import 'package:product_app/repositories/barang_repository.dart';

class BarangViewModel extends ChangeNotifier {
  List<Map<String, dynamic>> _barangList = [];
  bool _isLoading = false;
  int _offset = 0;
  final int _limit = 5;
  String _search = '';
  bool _hasMore = true;

  int _totalAll = 0;
  int _totalFiltered = 0;
  int _totalHarga = 0;
  int _totalStok = 0;

  List<Map<String, dynamic>> get barangList => _barangList;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;
  int get totalAll => _totalAll;
  int get totalFiltered => _totalFiltered;
  int get totalHarga => _totalHarga;
  int get totalStok => _totalStok;
  String get search => _search;

  void setSearch(String keyword) {
    _search = keyword.trim();
    refresh();
  }

  void refresh() {
    _offset = 0;
    _barangList.clear();
    _hasMore = true;
    fetchBarang(initial: true);
  }

  Future<void> fetchBarang({bool initial = false}) async {
    if (_isLoading || !_hasMore) return;

    _isLoading = true;
    notifyListeners();

    try {
      final result = await BarangRepository.getAll(
        offset: _offset,
        limit: _limit,
        search: _search,
      );

      final List<Map<String, dynamic>> newData =
          List<Map<String, dynamic>>.from(result['data']);
      _totalFiltered = result['totalFiltered'];
      _totalAll = result['totalAll'];
      _totalStok = result['totalStok'];
      _totalHarga = result['totalHarga'];

      if (initial) {
        _barangList = newData;
      } else {
        _barangList.addAll(newData);
      }

      _offset += _limit;
      _hasMore = _barangList.length < _totalFiltered;
    } catch (e) {
      debugPrint('Error fetching barang: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addBarang(Barang barang) async {
    await BarangRepository.insert(barang);
    refresh();
  }

  Future<void> deleteBarang(int id) async {
    await BarangRepository.delete(id);
    refresh();
  }

  Future<void> updateBarang(Barang barang) async {
    await BarangRepository.update(barang);
    refresh();
  }

  Future<void> bulkDeleteBarang(List<int> ids) async {
    if (ids.isEmpty) return;
    await BarangRepository.bulkDelete(ids);
    refresh();
  }
}
