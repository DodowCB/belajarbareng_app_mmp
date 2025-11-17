import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class KelasScreen extends StatefulWidget {
  const KelasScreen({super.key});

  @override
  State<KelasScreen> createState() => _KelasScreenState();
}

class _KelasScreenState extends State<KelasScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manajemen Kelas'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('kelas').snapshots(),
        builder: (context, snapshot) {
          // Debug logging
          print('=== KELAS DEBUG ===');
          print('ConnectionState: ${snapshot.connectionState}');
          print('HasData: ${snapshot.hasData}');
          print('HasError: ${snapshot.hasError}');

          if (snapshot.hasError) {
            print('Error: ${snapshot.error}');
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, size: 64, color: Colors.red[400]),
                  const SizedBox(height: 16),
                  Text('Error: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => setState(() {}),
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data?.docs ?? [];
          print('Document count: ${docs.length}');

          if (docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.class_, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada kelas',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap tombol + untuk menambah kelas',
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final docId = docs[index].id;

              print('Document $docId: $data');

              // Build display name
              String namaKelas = data['namaKelas'] ?? '';
              if (namaKelas.isEmpty) {
                final jenjang = data['jenjang_kelas'] ?? '';
                final nomor = data['nomor_kelas'] ?? '';
                namaKelas = jenjang.isNotEmpty && nomor.isNotEmpty
                    ? 'Kelas $jenjang $nomor'
                    : 'Kelas $docId';
              }

              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue[700],
                    child: Text(
                      docId,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(namaKelas),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Jenjang: ${data['jenjang_kelas'] ?? '-'}'),
                      Text('Nomor: ${data['nomor_kelas'] ?? '-'}'),
                      Text('Tahun: ${data['tahun_ajaran'] ?? '-'}'),
                      Text(
                        'Status: ${data['status'] ?? false ? 'Aktif' : 'Tidak Aktif'}',
                      ),
                    ],
                  ),
                  trailing: PopupMenuButton(
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, color: Colors.blue),
                            SizedBox(width: 8),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Hapus'),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (value) async {
                      if (value == 'edit') {
                        // TODO: Implement edit
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Edit feature coming soon'),
                          ),
                        );
                      } else if (value == 'delete') {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Konfirmasi'),
                            content: Text('Hapus kelas "$namaKelas"?'),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text('Batal'),
                              ),
                              ElevatedButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                child: const Text('Hapus'),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          try {
                            await _firestore
                                .collection('kelas')
                                .doc(docId)
                                .delete();
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Kelas berhasil dihapus'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            }
                          } catch (e) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error: ${e.toString()}'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        }
                      }
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        backgroundColor: Colors.blue[700],
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showAddDialog() {
    final jenjangController = TextEditingController();
    final nomorController = TextEditingController();
    final tahunController = TextEditingController(text: '2025-2026');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tambah Kelas'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: jenjangController,
              decoration: const InputDecoration(
                labelText: 'Jenjang Kelas (misal: 10)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nomorController,
              decoration: const InputDecoration(
                labelText: 'Nomor Kelas (misal: A)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: tahunController,
              decoration: const InputDecoration(
                labelText: 'Tahun Ajaran',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              jenjangController.clear();
              nomorController.clear();
              tahunController.clear();
              Navigator.of(context).pop();
            },
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (jenjangController.text.trim().isEmpty ||
                  nomorController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Jenjang dan nomor kelas harus diisi'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              try {
                await _firestore.collection('kelas').add({
                  'jenjang_kelas': jenjangController.text.trim(),
                  'nomor_kelas': nomorController.text.trim(),
                  'tahun_ajaran': tahunController.text.trim(),
                  'guru_id': '1',
                  'status': true,
                  'createdAt': FieldValue.serverTimestamp(),
                });

                jenjangController.clear();
                nomorController.clear();
                tahunController.clear();

                if (mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Kelas berhasil ditambahkan'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: ${e.toString()}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('Tambah'),
          ),
        ],
      ),
    );
  }
}
