import 'package:flutter/material.dart';
import '../models/barang_model.dart';
import '../models/kategori_model.dart';
import '../services/api_service.dart';

class TambahBarangPage extends StatefulWidget {
  const TambahBarangPage({super.key});

  @override
  State<TambahBarangPage> createState() => _TambahBarangPageState();
}

class _TambahBarangPageState extends State<TambahBarangPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _jumlahController = TextEditingController();
  final _pemilikController = TextEditingController();

  List<Kategori> _kategoriList = [];
  Kategori? _selectedKategori;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadKategoris();
  }

  // Ambil data kategori dari API
  void _loadKategoris() async {
    try {
      final list = await ApiService.fetchKategoris();
      setState(() => _kategoriList = list);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memuat kategori: $e')),
        );
      }
    }
  }

  // Reset seluruh form
  void _resetForm() {
    _formKey.currentState?.reset();
    _namaController.clear();
    _jumlahController.clear();
    _pemilikController.clear();
    setState(() {
      _selectedKategori = null;
    });
  }

  // Submit data ke API
  void _submitForm() async {
    if (_formKey.currentState!.validate() && _selectedKategori != null) {
      setState(() => _isLoading = true);

      final barang = Barang(
        id: 0,
        namaBarang: _namaController.text.trim(),
        kategoriId: _selectedKategori!.id,
        kategori: _selectedKategori!.namaKategori,
        jumlah: int.parse(_jumlahController.text.trim()),
        pemilik: _pemilikController.text.trim(),
      );

      final success = await ApiService.addBarang(barang);

      if (!mounted) return;

      setState(() => _isLoading = false);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Barang berhasil ditambahkan')),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menambahkan barang')),
        );
      }
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _jumlahController.dispose();
    _pemilikController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Barang')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _kategoriList.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: _namaController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(labelText: 'Nama Barang'),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Nama tidak boleh kosong' : null,
                    ),
                    DropdownButtonFormField<Kategori>(
                      value: _selectedKategori,
                      items: _kategoriList.map((kategori) {
                        return DropdownMenuItem<Kategori>(
                          value: kategori,
                          child: Text(kategori.namaKategori),
                        );
                      }).toList(),
                      onChanged: (value) => setState(() => _selectedKategori = value),
                      decoration: const InputDecoration(labelText: 'Kategori'),
                      validator: (value) =>
                          value == null ? 'Pilih kategori' : null,
                    ),
                    TextFormField(
                      controller: _jumlahController,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(labelText: 'Jumlah'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Jumlah tidak boleh kosong';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Masukkan angka yang valid';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _pemilikController,
                      decoration: const InputDecoration(labelText: 'Pemilik'),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Pemilik tidak boleh kosong' : null,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _isLoading ? null : _submitForm,
                            icon: _isLoading
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : const Icon(Icons.save),
                            label: const Text('Simpan'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton.icon(
                          onPressed: _resetForm,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Reset'),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
