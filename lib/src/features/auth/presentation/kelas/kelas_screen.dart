import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'kelas_bloc.dart';
import 'kelas_event.dart';
import 'kelas_state.dart';
import 'siswa_kelas_screen.dart';

class KelasScreen extends StatefulWidget {
  const KelasScreen({super.key});

  @override
  State<KelasScreen> createState() => _KelasScreenState();
}

class _KelasScreenState extends State<KelasScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => KelasBloc(),
      child: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Manajemen Kelas'),
            backgroundColor: Colors.blue[700],
            foregroundColor: Colors.white,
          ),
          body: StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('kelas').snapshots(),
            builder: (context, snapshot) {
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
                  String namaKelas = data['nama_kelas'] ?? '';
                  if (namaKelas.isEmpty) {
                    final jenjang = data['jenjang_kelas'] ?? '';
                    final nomor = data['nomor_kelas'] ?? '';
                    namaKelas = jenjang.isNotEmpty && nomor.isNotEmpty
                        ? '$jenjang $nomor'
                        : '$docId';
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
                      title: Text("Kelas $namaKelas"),
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
                      onTap: () {
                        // Navigate to siswa kelas screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SiswaKelasScreen(
                              kelasId: docId,
                              namaKelas: namaKelas,
                            ),
                          ),
                        );
                      },
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
        ),
      ),
    );
  }

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider(
        create: (context) => KelasBloc()..add(LoadGuru()),
        child: const AddKelasDialog(),
      ),
    );
  }
}

class AddKelasDialog extends StatefulWidget {
  const AddKelasDialog({Key? key}) : super(key: key);

  @override
  State<AddKelasDialog> createState() => _AddKelasDialogState();
}

class _AddKelasDialogState extends State<AddKelasDialog> {
  final jenjangController = TextEditingController();
  final nomorController = TextEditingController();
  final tahunController = TextEditingController(text: '2025-2026');
  String? selectedGuruId;
  String? selectedGuruNama;

  @override
  void dispose() {
    jenjangController.dispose();
    nomorController.dispose();
    tahunController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<KelasBloc, KelasState>(
      listener: (context, state) {
        if (state.successMessage != null) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.successMessage!),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error!), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        return AlertDialog(
          title: const Text('Tambah Kelas'),
          content: SingleChildScrollView(
            child: Column(
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
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: selectedGuruId,
                  decoration: const InputDecoration(
                    labelText: 'Wali Kelas',
                    border: OutlineInputBorder(),
                  ),
                  items: state.guruList.map((guru) {
                    return DropdownMenuItem<String>(
                      value: guru.id,
                      child: Text('${guru.namaLengkap} (${guru.nig})'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedGuruId = value;
                      selectedGuruNama = state.guruList
                          .firstWhere((guru) => guru.id == value)
                          .namaLengkap;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Wali kelas harus dipilih';
                    }
                    return null;
                  },
                ),
                if (state.isLoading && state.guruList.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: state.isLoading
                  ? null
                  : () {
                      if (jenjangController.text.trim().isEmpty ||
                          nomorController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Jenjang dan nomor kelas harus diisi',
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      if (selectedGuruId == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Wali kelas harus dipilih'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      final namaKelas =
                          '${jenjangController.text.trim()} ${nomorController.text.trim()}';

                      context.read<KelasBloc>().add(
                        AddKelas(
                          namaKelas: namaKelas,
                          jenjangKelas: jenjangController.text.trim(),
                          nomorKelas: nomorController.text.trim(),
                          tahunAjaran: tahunController.text.trim(),
                          guruId: selectedGuruId!,
                          namaGuru: selectedGuruNama!,
                        ),
                      );
                    },
              child: state.isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Tambah'),
            ),
          ],
        );
      },
    );
  }
}
