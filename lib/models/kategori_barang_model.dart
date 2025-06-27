class KategoriBarang {
  final int? id;
  final String namaKategori;

  KategoriBarang({this.id, required this.namaKategori});

  Map<String, dynamic> toMap() {
    return {'id': id, 'nama_kategori': namaKategori};
  }

  factory KategoriBarang.fromMap(Map<String, dynamic> map) {
    return KategoriBarang(id: map['id'], namaKategori: map['nama_kategori']);
  }
}
