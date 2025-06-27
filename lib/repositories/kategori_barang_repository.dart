import 'package:product_app/database/database.dart';
import 'package:product_app/models/kategori_barang_model.dart';

class KategoriBarangRepository {
  static Future<List<KategoriBarang>> getAll() async {
    final db = await AppDatabase.database;
    final result = await db.query('kategori');
    return result.map((e) => KategoriBarang.fromMap(e)).toList();
  }
}
