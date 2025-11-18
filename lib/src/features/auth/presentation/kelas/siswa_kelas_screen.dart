import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SiswaKelasScreen extends StatefulWidget {
  final String kelasId;
  final String namaKelas;

  const SiswaKelasScreen({
    super.key,
    required this.kelasId,
    required this.namaKelas,
  });

  @override
  State<SiswaKelasScreen> createState() => _SiswaKelasScreenState();
}

class _SiswaKelasScreenState extends State<SiswaKelasScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> _getSiswaData(String siswaId) async {
    try {
      final siswaDoc = await _firestore.collection('siswa').doc(siswaId).get();
      if (siswaDoc.exists) {
        return siswaDoc.data() as Map<String, dynamic>;
      }
    } catch (e) {
      print('Error getting siswa data: $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Siswa - ${widget.namaKelas}'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('siswa_kelas')
            .where('kelas_id', isEqualTo: widget.kelasId)
            .snapshots(),
        builder: (context, snapshot) {
          // print('=== SISWA KELAS DEBUG ===');
          // print('Kelas ID: ${widget.kelasId}');
          // print('ConnectionState: ${snapshot.connectionState}');
          // print('HasData: ${snapshot.hasData}');
          // print('HasError: ${snapshot.hasError}');

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
          print('Siswa count in this kelas: ${docs.length}');

          if (docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_outline, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada siswa di kelas ini',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tambahkan siswa ke kelas melalui manajemen siswa',
                    style: TextStyle(color: Colors.grey[500]),
                    textAlign: TextAlign.center,
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
              final siswaId = data['siswa_id'] ?? '';
              print('Siswa Kelas Document $docId: $data');

              return FutureBuilder<Map<String, dynamic>?>(
                future: _getSiswaData(siswaId),
                builder: (context, siswaSnapshot) {
                  print(siswaSnapshot.data);
                  final siswaData = siswaSnapshot.data;
                  final namaSiswa = siswaData?['nama'] ?? 'Nama tidak tersedia';
                  final nis = siswaData?['nis'] ?? '-';

                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.green[700],
                        child: Text(
                          (index + 1).toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text('Nama Siswa: $namaSiswa'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('NIS: $nis'),
                          Text('Siswa ID: $siswaId'),
                          Text('Kelas ID: ${data['kelas_id'] ?? '-'}'),
                        ],
                      ),
                      trailing: PopupMenuButton(
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'view',
                            child: Row(
                              children: [
                                Icon(Icons.visibility, color: Colors.blue),
                                SizedBox(width: 8),
                                Text('Lihat Detail'),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'remove',
                            child: Row(
                              children: [
                                Icon(Icons.remove_circle, color: Colors.red),
                                SizedBox(width: 8),
                                Text('Keluarkan dari Kelas'),
                              ],
                            ),
                          ),
                        ],
                        onSelected: (value) async {
                          if (value == 'view') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'View detail feature coming soon',
                                ),
                              ),
                            );
                          } else if (value == 'remove') {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Konfirmasi'),
                                content: Text(
                                  'Keluarkan "$namaSiswa" dari kelas ${widget.namaKelas}?',
                                ),
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
                                    child: const Text('Keluarkan'),
                                  ),
                                ],
                              ),
                            );

                            if (confirm == true) {
                              try {
                                await _firestore
                                    .collection('siswa_kelas')
                                    .doc(docId)
                                    .delete();
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Siswa berhasil dikeluarkan',
                                      ),
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
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddSiswaDialog,
        backgroundColor: Colors.blue[700],
        child: const Icon(Icons.person_add, color: Colors.white),
      ),
    );
  }

  void _showAddSiswaDialog() {
    showDialog(
      context: context,
      builder: (context) =>
          AddSiswaDialog(kelasId: widget.kelasId, namaKelas: widget.namaKelas),
    );
  }
}

class AddSiswaDialog extends StatefulWidget {
  final String kelasId;
  final String namaKelas;

  const AddSiswaDialog({
    super.key,
    required this.kelasId,
    required this.namaKelas,
  });

  @override
  State<AddSiswaDialog> createState() => _AddSiswaDialogState();
}

class _AddSiswaDialogState extends State<AddSiswaDialog> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _availableSiswa = [];
  String? _selectedSiswaId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAvailableSiswa();
  }

  Future<void> _loadAvailableSiswa() async {
    try {
      // Get all siswa from siswa collection
      final siswaSnapshot = await _firestore.collection('siswa').get();

      // Get siswa already in this kelas
      final siswaKelasSnapshot = await _firestore
          .collection('siswa_kelas')
          .where('kelas_id', isEqualTo: widget.kelasId)
          .get();

      final siswaInKelas = siswaKelasSnapshot.docs
          .map((doc) => doc.data()['siswa_id'] as String)
          .toSet();

      // Filter out siswa already in this kelas
      final availableSiswa = siswaSnapshot.docs
          .where((doc) => !siswaInKelas.contains(doc.id))
          .map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return {
              'id': doc.id,
              'nama': data['nama'] ?? 'Nama tidak tersedia',
              'nis': data['nis'] ?? '',
            };
          })
          .toList();

      setState(() {
        _availableSiswa = availableSiswa;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading siswa: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Tambah Siswa ke ${widget.namaKelas}'),
      content: _isLoading
          ? const SizedBox(
              height: 100,
              child: Center(child: CircularProgressIndicator()),
            )
          : _availableSiswa.isEmpty
          ? const Text('Tidak ada siswa yang tersedia untuk ditambahkan')
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: _selectedSiswaId,
                  decoration: const InputDecoration(
                    labelText: 'Pilih Siswa',
                    border: OutlineInputBorder(),
                  ),
                  items: _availableSiswa.map((siswa) {
                    return DropdownMenuItem<String>(
                      value: siswa['id'],
                      child: Text('${siswa['nama']} (${siswa['nis']})'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedSiswaId = value;
                    });
                  },
                ),
              ],
            ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: _selectedSiswaId == null ? null : _addSiswaToKelas,
          child: const Text('Tambah'),
        ),
      ],
    );
  }

  Future<void> _addSiswaToKelas() async {
    if (_selectedSiswaId == null) return;

    try {
      // Add to siswa_kelas collection with simple structure
      await _firestore.collection('siswa_kelas').add({
        'kelas_id': widget.kelasId,
        'siswa_id': _selectedSiswaId!,
      });

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Siswa berhasil ditambahkan ke kelas'),
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
