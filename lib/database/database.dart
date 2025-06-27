import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    return await initDB();
  }

  static Future<Database> initDB() async {
    final path = join(await getDatabasesPath(), 'app.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE kategori (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          nama_kategori TEXT
        )
      ''');

        await db.execute('''
        CREATE TABLE barang (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          nama_barang TEXT,
          kategori_id INTEGER,
          stok INTEGER,
          kelompok_barang TEXT,
          harga INTEGER,
          FOREIGN KEY(kategori_id) REFERENCES kategori(id)
        )
      ''');

        await db.insert('kategori', {'nama_kategori': 'Elektronik'});
        await db.insert('kategori', {'nama_kategori': 'Pakaian'});
        await db.insert('kategori', {
          'nama_kategori': 'Peralatan Rumah Tangga',
        });
        await db.insert('kategori', {'nama_kategori': 'Makanan & Minuman'});
        await db.insert('kategori', {
          'nama_kategori': 'Kecantikan & Kesehatan',
        });

        final barangList = [
          {
            'nama_barang': 'Smartphone Samsung Galaxy A14',
            'kategori_id': 1,
            'stok': 50,
            'kelompok_barang': 'Elektronik',
            'harga': 2500000,
          },
          {
            'nama_barang': 'Laptop Lenovo Ideapad Slim 3',
            'kategori_id': 1,
            'stok': 20,
            'kelompok_barang': 'Elektronik',
            'harga': 6200000,
          },
          {
            'nama_barang': 'Kemeja Lengan Panjang Pria',
            'kategori_id': 2,
            'stok': 100,
            'kelompok_barang': 'Pakaian',
            'harga': 150000,
          },
          {
            'nama_barang': 'Celana Jeans Wanita',
            'kategori_id': 2,
            'stok': 75,
            'kelompok_barang': 'Pakaian',
            'harga': 180000,
          },
          {
            'nama_barang': 'Blender Philips HR2115',
            'kategori_id': 3,
            'stok': 30,
            'kelompok_barang': 'Peralatan Dapur',
            'harga': 450000,
          },
          {
            'nama_barang': 'Setrika Uap Maspion',
            'kategori_id': 3,
            'stok': 40,
            'kelompok_barang': 'Peralatan Rumah Tangga',
            'harga': 220000,
          },
          {
            'nama_barang': 'Snack Kripik Kentang BBQ',
            'kategori_id': 4,
            'stok': 200,
            'kelompok_barang': 'Makanan Ringan',
            'harga': 12000,
          },
          {
            'nama_barang': 'Minuman Isotonik Pocari Sweat',
            'kategori_id': 4,
            'stok': 120,
            'kelompok_barang': 'Minuman',
            'harga': 8000,
          },
          {
            'nama_barang': 'Face Wash Garnier Men',
            'kategori_id': 5,
            'stok': 60,
            'kelompok_barang': 'Perawatan Pria',
            'harga': 30000,
          },
          {
            'nama_barang': 'Lipstik Wardah Matte',
            'kategori_id': 5,
            'stok': 90,
            'kelompok_barang': 'Kecantikan',
            'harga': 45000,
          },
          {
            'nama_barang': 'TV LED Sharp 32 Inch',
            'kategori_id': 1,
            'stok': 15,
            'kelompok_barang': 'Elektronik',
            'harga': 1800000,
          },
          {
            'nama_barang': 'Mouse Wireless Logitech',
            'kategori_id': 1,
            'stok': 55,
            'kelompok_barang': 'Aksesoris Komputer',
            'harga': 120000,
          },
          {
            'nama_barang': 'Dress Muslimah',
            'kategori_id': 2,
            'stok': 60,
            'kelompok_barang': 'Pakaian',
            'harga': 250000,
          },
          {
            'nama_barang': 'Panci Stainless Steel Set',
            'kategori_id': 3,
            'stok': 25,
            'kelompok_barang': 'Dapur',
            'harga': 380000,
          },
          {
            'nama_barang': 'Air Mineral Aqua 600ml',
            'kategori_id': 4,
            'stok': 300,
            'kelompok_barang': 'Minuman',
            'harga': 4000,
          },
          {
            'nama_barang': 'Sabun Mandi Lifebuoy',
            'kategori_id': 5,
            'stok': 80,
            'kelompok_barang': 'Kesehatan',
            'harga': 9000,
          },
          {
            'nama_barang': 'Baju Kaos Polos Pria',
            'kategori_id': 2,
            'stok': 110,
            'kelompok_barang': 'Pakaian',
            'harga': 50000,
          },
          {
            'nama_barang': 'Rice Cooker Miyako',
            'kategori_id': 3,
            'stok': 35,
            'kelompok_barang': 'Dapur',
            'harga': 290000,
          },
          {
            'nama_barang': 'Shampoo Dove 160ml',
            'kategori_id': 5,
            'stok': 70,
            'kelompok_barang': 'Perawatan Rambut',
            'harga': 26000,
          },
          {
            'nama_barang': 'Susu UHT Ultra Milk Coklat',
            'kategori_id': 4,
            'stok': 150,
            'kelompok_barang': 'Minuman',
            'harga': 8500,
          },
        ];

        for (final barang in barangList) {
          await db.insert('barang', barang);
        }
      },
    );
  }
}
