import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/mapel_model.dart';
import 'mapel_bloc.dart';
import 'mapel_event.dart';
import 'mapel_state.dart';

class MapelScreen extends StatefulWidget {
  const MapelScreen({super.key});

  @override
  State<MapelScreen> createState() => _MapelScreenState();
}

class _MapelScreenState extends State<MapelScreen> {
  late MapelBloc _mapelBloc;
  final TextEditingController _namaMapelController = TextEditingController();

  @override
  void initState() {
    super.initState();
    try {
      _mapelBloc = MapelBloc()..add(const LoadMapel());
    } catch (e) {
      print('Error initializing MapelBloc: $e');
      // Fallback initialization
      _mapelBloc = MapelBloc();
    }
  }

  @override
  void dispose() {
    _mapelBloc.close();
    _namaMapelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    try {
      return BlocProvider.value(
        value: _mapelBloc,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Manajemen Mata Pelajaran'),
            backgroundColor: Colors.blue[700],
            foregroundColor: Colors.white,
          ),
          body: BlocConsumer<MapelBloc, MapelState>(
            listener: (context, state) {
              if (state is MapelActionSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.green,
                  ),
                );
                _namaMapelController.clear(); // Clear input after success
              } else if (state is MapelError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              return _buildContent(state);
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showAddMapelDialog(),
            backgroundColor: Colors.blue[700],
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ),
      );
    } catch (e) {
      print('MapelScreen build error: $e');
      return Scaffold(
        appBar: AppBar(
          title: const Text('Manajemen Mata Pelajaran'),
          backgroundColor: Colors.blue[700],
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
              const SizedBox(height: 16),
              const Text('Terjadi Kesalahan', style: TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              Text(
                'Error: ${e.toString()}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Kembali'),
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildContent(MapelState state) {
    if (state is MapelLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is MapelLoaded) {
      if (state.mapelList.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.library_books_outlined,
                size: 80,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 24),
              Text(
                'No Mapel Added Yet',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Belum ada mata pelajaran yang ditambahkan.',
                style: TextStyle(fontSize: 16, color: Colors.grey[500]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Klik tombol + untuk menambahkan mata pelajaran pertama.',
                style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: state.mapelList.length,
        itemBuilder: (context, index) {
          final mapel = state.mapelList[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 2,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue[700],
                child: Text(
                  mapel.id.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(
                mapel.namaMapel,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                'Dibuat: ${_formatDate(mapel.createdAt)}',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey[400],
              ),
              onTap: () {
                // TODO: Navigate to materi list for this mapel
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Navigasi ke materi ${mapel.namaMapel}'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
            ),
          );
        },
      );
    } else if (state is MapelError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
            const SizedBox(height: 16),
            Text(
              'Terjadi Kesalahan',
              style: TextStyle(fontSize: 18, color: Colors.red[600]),
            ),
            const SizedBox(height: 8),
            Text(
              state.message,
              style: TextStyle(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _mapelBloc.add(const LoadMapel()),
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      );
    }

    return const Center(child: Text('State tidak dikenali'));
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _showAddMapelDialog() {
    _namaMapelController.clear();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tambah Mata Pelajaran'),
        content: TextField(
          controller: _namaMapelController,
          decoration: const InputDecoration(
            labelText: 'Nama Mata Pelajaran',
            hintText: 'Contoh: Matematika, IPA, IPS, dll',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
          textCapitalization: TextCapitalization.words,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              final namaMapel = _namaMapelController.text.trim();

              if (namaMapel.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Nama mata pelajaran tidak boleh kosong'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              if (namaMapel.length < 3) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Nama mata pelajaran minimal 3 karakter'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              _mapelBloc.add(AddMapel(namaMapel: namaMapel));
              Navigator.pop(context);
            },
            child: const Text('Tambah'),
          ),
        ],
      ),
    );
  }
}
