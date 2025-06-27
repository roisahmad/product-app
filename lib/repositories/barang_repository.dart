import 'package:product_app/database/database.dart';
import 'package:product_app/models/barang_model.dart';
import 'package:sqflite/sqflite.dart';

class BarangRepository {
  static Future<Map<String, dynamic>> getAll({
    int offset = 0,
    int limit = 10,
    String? search,
  }) async {
    final db = await AppDatabase.database;

    final whereClause =
        (search != null && search.isNotEmpty)
            ? "WHERE b.nama_barang LIKE ?"
            : "";

    final args = (search != null && search.isNotEmpty) ? ['%$search%'] : [];

    final data = await db.rawQuery('''
    SELECT b.*, k.nama_kategori 
    FROM barang b
    LEFT JOIN kategori k ON b.kategori_id = k.id
    $whereClause
    ORDER BY b.id DESC
    LIMIT $limit OFFSET $offset
  ''', args);

    final totalAllQuery = await db.rawQuery(
      'SELECT COUNT(*) as total FROM barang',
    );
    final totalAll = Sqflite.firstIntValue(totalAllQuery) ?? 0;

    final totalFilteredQuery = await db.rawQuery(
      'SELECT COUNT(*) as total FROM barang b $whereClause',
      args,
    );
    final totalFiltered = Sqflite.firstIntValue(totalFilteredQuery) ?? 0;

    final totalStokQuery = await db.rawQuery(
      'SELECT SUM(b.stok) as total_stok FROM barang b $whereClause',
      args,
    );
    final totalStok = Sqflite.firstIntValue(totalStokQuery) ?? 0;

    final totalHargaQuery = await db.rawQuery(
      'SELECT SUM(b.harga * b.stok) as total_harga FROM barang b $whereClause',
      args,
    );
    final totalHarga = Sqflite.firstIntValue(totalHargaQuery) ?? 0;

    return {
      'data': data,
      'totalAll': totalAll,
      'totalFiltered': totalFiltered,
      'totalStok': totalStok,
      'totalHarga': totalHarga,
    };
  }

  static Future<void> insert(Barang barang) async {
    final db = await AppDatabase.database;
    await db.insert('barang', barang.toMap());
  }

  static Future<void> update(Barang barang) async {
    final db = await AppDatabase.database;
    await db.update(
      'barang',
      barang.toMap(),
      where: 'id = ?',
      whereArgs: [barang.id],
    );
  }

  static Future<void> delete(int id) async {
    final db = await AppDatabase.database;
    await db.delete('barang', where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> bulkDelete(List<int> ids) async {
    if (ids.isEmpty) return;
    final db = await AppDatabase.database;

    final placeholders = List.filled(ids.length, '?').join(', ');
    await db.delete('barang', where: 'id IN ($placeholders)', whereArgs: ids);
  }
}
