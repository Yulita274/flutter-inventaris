class Kategori {
  final int id;
  final String namaKategori;
  final String? deskripsi;

  Kategori({
    required this.id,
    required this.namaKategori,
    this.deskripsi,
  });

  factory Kategori.fromJson(Map<String, dynamic> json) {
    return Kategori(
      id: json['id'],
      namaKategori: json['nama_kategori'],
      deskripsi: json['deskripsi'],
    );
  }
}
