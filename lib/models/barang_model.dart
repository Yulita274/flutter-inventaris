class Barang {
  final int id;
  final String namaBarang;
  final int kategoriId;
  final String kategori; // berisi nama kategori dari relasi
  final int jumlah;
  final String pemilik;

  Barang({
    required this.id,
    required this.namaBarang,
    required this.kategoriId,
    required this.kategori,
    required this.jumlah,
    required this.pemilik,
  });

  factory Barang.fromJson(Map<String, dynamic> json) {
    return Barang(
      id: json['id'],
      namaBarang: json['nama_barang'],
      kategoriId: json['kategori_id'],
      kategori: json['kategori']?['nama_kategori'] ?? '', // ← aman walau null
      jumlah: json['jumlah'],
      pemilik: json['pemilik'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nama_barang': namaBarang,
      'kategori_id': kategoriId,
      'jumlah': jumlah,
      'pemilik': pemilik,
    };
  }
}
