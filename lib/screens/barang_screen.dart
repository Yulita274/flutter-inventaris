import 'package:flutter/material.dart';
import '../models/barang_model.dart';
import 'detail_barang_screen.dart';

class BarangPage extends StatelessWidget {
  final List<Barang> all;

  const BarangPage({Key? key, required this.all}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Barang')),
      body: ListView.builder(
        itemCount: all.length,
        itemBuilder: (context, index) {
          final barang = all[index];

          return ListTile(
            title: Text(barang.namaBarang),
            subtitle: Text('Kategori: ${barang.kategori}'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              print('Barang detail: ${barang.namaBarang}');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailBarangScreen(
                    barang: barang,
                    namaBarang: barang.namaBarang,
                    jumlah: barang.jumlah,
                    pemilik: barang.pemilik,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
