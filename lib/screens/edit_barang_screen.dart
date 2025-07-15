import 'package:flutter/material.dart';
import '../models/barang_model.dart';
import '../models/kategori_model.dart';
import '../services/api_service.dart';

class EditBarangPage extends StatefulWidget {
  final Barang barang;

  const EditBarangPage({Key? key, required this.barang}) : super(key: key);

  @override
  State<EditBarangPage> createState() => _EditBarangPageState();
}

class _EditBarangPageState extends State<EditBarangPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaController;
  late TextEditingController _jumlahController;
  late TextEditingController _pemilikController;

  int? _selectedKategoriId;
  List<Kategori> _kategoris = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.barang.namaBarang);
    _jumlahController = TextEditingController(text: widget.barang.jumlah.toString());
    _pemilikController = TextEditingController(text: widget.barang.pemilik);
    _selectedKategoriId = widget.barang.kategoriId;

    _loadKategori();
  }

  Future<void> _loadKategori() async {
    try {
      final data = await ApiService.fetchKategoris();
      setState(() => _kategoris = data);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memuat kategori: $e')),
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

  void _updateBarang() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final updatedBarang = Barang(
        id: widget.barang.id,
        namaBarang: _namaController.text.trim(),
        jumlah: int.parse(_jumlahController.text.trim()),
        pemilik: _pemilikController.text.trim(),
        kategoriId: _selectedKategoriId!,
        kategori: '', // Opsional
      );

      final success = await ApiService.updateBarang(updatedBarang);

      if (!mounted) return;

      setState(() => _isLoading = false);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Barang berhasil diupdate')),
        );
        Navigator.pop(context, true); // kembali ke halaman sebelumnya
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal mengupdate barang')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Barang')),
      body: _kategoris.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: _namaController,
                      decoration: const InputDecoration(labelText: 'Nama Barang'),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Nama tidak boleh kosong' : null,
                    ),
                    DropdownButtonFormField<int>(
                      value: _selectedKategoriId,
                      decoration: const InputDecoration(labelText: 'Kategori'),
                      items: _kategoris.map((kategori) {
                        return DropdownMenuItem<int>(
                          value: kategori.id,
                          child: Text(kategori.namaKategori),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => _selectedKategoriId = value);
                      },
                      validator: (value) =>
                          value == null ? 'Kategori harus dipilih' : null,
                    ),
                    TextFormField(
                      controller: _jumlahController,
                      decoration: const InputDecoration(labelText: 'Jumlah'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Jumlah tidak boleh kosong';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Jumlah harus berupa angka';
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
                    ElevatedButton.icon(
                      onPressed: _isLoading ? null : _updateBarang,
                      icon: _isLoading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.save),
                      label: const Text('Simpan Perubahan'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
