import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'pengumuman_bloc.dart';
import 'pengumuman_event.dart';
import 'pengumuman_state.dart';
import '../../data/models/pengumuman_model.dart';

class PengumumanScreen extends StatefulWidget {
  const PengumumanScreen({super.key});

  @override
  State<PengumumanScreen> createState() => _PengumumanScreenState();
}

class _PengumumanScreenState extends State<PengumumanScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PengumumanBloc()..add(LoadPengumuman()),
      child: Builder(
        builder: (context) => Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: AppBar(
            title: const Text('Pengumuman'),
            backgroundColor: Colors.orange[700],
            foregroundColor: Colors.white,
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  context.read<PengumumanBloc>().add(RefreshPengumuman());
                },
              ),
            ],
          ),
          body: BlocConsumer<PengumumanBloc, PengumumanState>(
            listener: (context, state) {
              if (state.successMessage != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.successMessage!),
                    backgroundColor: Colors.green,
                  ),
                );
              } else if (state.error != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error!),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state.isLoading && state.pengumumanList.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.pengumumanList.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.announcement_outlined,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Belum ada pengumuman',
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tap tombol + untuk menambah pengumuman',
                        style: TextStyle(color: Colors.grey[500]),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<PengumumanBloc>().add(RefreshPengumuman());
                },
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.pengumumanList.length,
                  itemBuilder: (context, index) {
                    final pengumuman = state.pengumumanList[index];
                    return _buildPengumumanCard(context, pengumuman);
                  },
                ),
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showAddPengumumanDialog(context),
            backgroundColor: Colors.orange[700],
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildPengumumanCard(
    BuildContext context,
    PengumumanModel pengumuman,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header dengan judul dan menu
            Row(
              children: [
                Expanded(
                  child: Text(
                    pengumuman.judul,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                PopupMenuButton(
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
                  onSelected: (value) {
                    if (value == 'edit') {
                      _showEditPengumumanDialog(context, pengumuman);
                    } else if (value == 'delete') {
                      _showDeleteConfirmation(context, pengumuman);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Deskripsi
            Text(pengumuman.deskripsi, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 12),

            // Footer dengan pembuat dan tanggal
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: pengumuman.pembuat == 'admin'
                        ? Colors.red[100]
                        : Colors.blue[100],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    pengumuman.pembuatDisplay,
                    style: TextStyle(
                      fontSize: 12,
                      color: pengumuman.pembuat == 'admin'
                          ? Colors.red[800]
                          : Colors.blue[800],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  pengumuman.formattedDateTime,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAddPengumumanDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<PengumumanBloc>(),
        child: const AddPengumumanDialog(),
      ),
    );
  }

  void _showEditPengumumanDialog(
    BuildContext context,
    PengumumanModel pengumuman,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<PengumumanBloc>(),
        child: EditPengumumanDialog(pengumuman: pengumuman),
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    PengumumanModel pengumuman,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi'),
        content: Text('Hapus pengumuman "${pengumuman.judul}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<PengumumanBloc>().add(
                DeletePengumuman(id: pengumuman.id),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}

// Dialog untuk tambah pengumuman
class AddPengumumanDialog extends StatefulWidget {
  const AddPengumumanDialog({Key? key}) : super(key: key);

  @override
  State<AddPengumumanDialog> createState() => _AddPengumumanDialogState();
}

class _AddPengumumanDialogState extends State<AddPengumumanDialog> {
  final judulController = TextEditingController();
  final deskripsiController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    judulController.dispose();
    deskripsiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PengumumanBloc, PengumumanState>(
      listener: (context, state) {
        if (state.successMessage != null) {
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        return AlertDialog(
          title: const Text('Tambah Pengumuman'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: judulController,
                  decoration: const InputDecoration(
                    labelText: 'Judul Pengumuman',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Judul pengumuman harus diisi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: deskripsiController,
                  decoration: const InputDecoration(
                    labelText: 'Deskripsi',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Deskripsi harus diisi';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: state.isLoading ? null : _submitPengumuman,
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

  void _submitPengumuman() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implementasi untuk cek apakah user adalah guru atau admin
      // Untuk sekarang diasumsikan admin
      context.read<PengumumanBloc>().add(
        AddPengumuman(
          judul: judulController.text.trim(),
          deskripsi: deskripsiController.text.trim(),
          pembuat: 'admin', // Hardcoded untuk sekarang
          guruId: null, // null karena admin
          namaGuru: null, // null karena admin
        ),
      );
    }
  }
}

// Dialog untuk edit pengumuman
class EditPengumumanDialog extends StatefulWidget {
  final PengumumanModel pengumuman;

  const EditPengumumanDialog({Key? key, required this.pengumuman})
    : super(key: key);

  @override
  State<EditPengumumanDialog> createState() => _EditPengumumanDialogState();
}

class _EditPengumumanDialogState extends State<EditPengumumanDialog> {
  late TextEditingController judulController;
  late TextEditingController deskripsiController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    judulController = TextEditingController(text: widget.pengumuman.judul);
    deskripsiController = TextEditingController(
      text: widget.pengumuman.deskripsi,
    );
  }

  @override
  void dispose() {
    judulController.dispose();
    deskripsiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PengumumanBloc, PengumumanState>(
      listener: (context, state) {
        if (state.successMessage != null) {
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        return AlertDialog(
          title: const Text('Edit Pengumuman'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: judulController,
                  decoration: const InputDecoration(
                    labelText: 'Judul Pengumuman',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Judul pengumuman harus diisi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: deskripsiController,
                  decoration: const InputDecoration(
                    labelText: 'Deskripsi',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Deskripsi harus diisi';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: state.isLoading ? null : _updatePengumuman,
              child: state.isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _updatePengumuman() {
    if (_formKey.currentState!.validate()) {
      context.read<PengumumanBloc>().add(
        UpdatePengumuman(
          id: widget.pengumuman.id,
          judul: judulController.text.trim(),
          deskripsi: deskripsiController.text.trim(),
        ),
      );
    }
  }
}
