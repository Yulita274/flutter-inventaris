import 'package:flutter/material.dart';

class BarangListScreen extends StatelessWidget {
  const BarangListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Daftar Barang")),
      body: ListView(
        children: const [
          ListTile(title: Text("Laptop Acer")),
          ListTile(title: Text("Printer Canon")),
          ListTile(title: Text("Meja Kayu")),
        ],
      ),
    );
  }
}
