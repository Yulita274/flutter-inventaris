import 'package:flutter/material.dart';
import 'package:inventarisklp1/models/barang_model.dart';
import 'package:inventarisklp1/screens/edit_barang_screen.dart';

class DetailBarangScreen extends StatelessWidget {
  final String namaBarang;
  final int jumlah;
  final String pemilik;

  const DetailBarangScreen({
    super.key,
    required this.namaBarang,
    required this.jumlah,
    required this.pemilik, required Barang barang,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Barang')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Nama Barang:", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(namaBarang),
            SizedBox(height: 16),
            Text("Jumlah:", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(jumlah.toString()),
            SizedBox(height: 16),
            Text("Pemilik:", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(pemilik),
          ],
        ),
      ),
    );
  }
}
