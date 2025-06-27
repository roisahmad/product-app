class Barang {
  final int? id;
  final String namaBarang;
  final int kategoriId;
  final int stok;
  final String kelompokBarang;
  final int harga;

  Barang({
    this.id,
    required this.namaBarang,
    required this.kategoriId,
    required this.stok,
    required this.kelompokBarang,
    required this.harga,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama_barang': namaBarang,
      'kategori_id': kategoriId,
      'stok': stok,
      'kelompok_barang': kelompokBarang,
      'harga': harga,
    };
  }

  factory Barang.fromMap(Map<String, dynamic> map) {
    return Barang(
      id: map['id'],
      namaBarang: map['nama_barang'],
      kategoriId: map['kategori_id'],
      stok: map['stok'],
      kelompokBarang: map['kelompok_barang'],
      harga: map['harga'],
    );
  }
}
