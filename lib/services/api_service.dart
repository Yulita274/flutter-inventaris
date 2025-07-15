import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/kategori_model.dart';
import '../models/barang_model.dart';

class ApiService {
  // Ganti IP dan port sesuai dengan alamat backend lokal kamu
  static const String baseUrl = 'http://10.19.113.176/backendinventaris/public/api';

  // ✅ Ambil semua kategori
  static Future<List<Kategori>> fetchKategoris() async {
    final response = await http.get(Uri.parse('$baseUrl/kategoris'));
    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((e) => Kategori.fromJson(e)).toList();
    } else {
      throw Exception('Gagal memuat data kategori');
    }
  }

  // ✅ Tambah barang
  static Future<bool> addBarang(Barang barang) async {
    final response = await http.post(
      Uri.parse('$baseUrl/barangs'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(barang.toJson()),
    );
    return response.statusCode == 201;
  }

  // ✅ Ambil semua barang
  static Future<List<Barang>> fetchBarangs() async {
    final response = await http.get(Uri.parse('$baseUrl/barangs'));
    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((e) => Barang.fromJson(e)).toList();
    } else {
      throw Exception('Gagal memuat data barang');
    }
  }

  // ✅ Update barang
  static Future<bool> updateBarang(Barang barang) async {
    final response = await http.put(
      Uri.parse('$baseUrl/barangs/${barang.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nama_barang': barang.namaBarang,
        'kategori_id': barang.kategoriId,
        'jumlah': barang.jumlah,
        'pemilik': barang.pemilik,
      }),
    );
    return response.statusCode == 200;
  }

  // ✅ Hapus barang
  static Future<bool> deleteBarang(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/barangs/$id'));
    return response.statusCode == 200;
  }

  // ✅ Ambil barang berdasarkan ID
  static Future<Barang> fetchBarangById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/barangs/$id'));
    if (response.statusCode == 200) {
      return Barang.fromJson(json.decode(response.body));
    } else {
      throw Exception('Gagal memuat data barang');
    }
  }

  // ✅ Cari barang berdasarkan kata kunci
  static Future<List<Barang>> searchBarangs(String query) async {
    final response = await http.get(Uri.parse('$baseUrl/barangs/search?query=$query'));
    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((e) => Barang.fromJson(e)).toList();
    } else {
      throw Exception('Gagal mencari barang');
    }
  }

  // ✅ Ambil barang berdasarkan kategori
  static Future<List<Barang>> fetchBarangsByKategori(int kategoriId) async {
    final response = await http.get(Uri.parse('$baseUrl/kategoris/$kategoriId/barangs'));
    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((e) => Barang.fromJson(e)).toList();
    } else {
      throw Exception('Gagal memuat barang berdasarkan kategori');
    }
  }
}
