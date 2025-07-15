import 'package:flutter/material.dart';
import 'models/barang_model.dart';
import 'services/api_service.dart';
import 'screens/tambah_barang_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inventaris Barang',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const BarangListPage(),
    );
  }
}

class BarangListPage extends StatefulWidget {
  const BarangListPage({super.key});

  @override
  State<BarangListPage> createState() => _BarangListPageState();
}

class _BarangListPageState extends State<BarangListPage> {
  late Future<List<Barang>> futureBarangs;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() {
    futureBarangs = ApiService.fetchBarangs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Barang Inventaris'),
      ),
      body: FutureBuilder<List<Barang>>(
        future: futureBarangs,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada data barang.'));
          }

          final barangs = snapshot.data!;
          return ListView.builder(
            itemCount: barangs.length,
            itemBuilder: (context, index) {
              final barang = barangs[index];
              return Card(
                child: ListTile(
                  title: Text(barang.namaBarang),
                  subtitle: Text('Kategori: ${barang.kategori} | Jumlah: ${barang.jumlah}'),
                  trailing: Text(barang.pemilik),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TambahBarangPage()),
          );
          if (result == true) {
            setState(() {
              loadData();
            });
          }
        },
      ),
    );
  }
}
