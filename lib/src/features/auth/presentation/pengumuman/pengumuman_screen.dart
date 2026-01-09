import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/connectivity_service.dart';
import 'pengumuman_bloc.dart';
import 'pengumuman_event.dart';
import 'pengumuman_state.dart';
import '../../data/models/pengumuman_model.dart';
import '../widgets/admin_header.dart';

class PengumumanScreen extends StatefulWidget {
  const PengumumanScreen({super.key});

  @override
  State<PengumumanScreen> createState() => _PengumumanScreenState();
}

class _PengumumanScreenState extends State<PengumumanScreen> {
  String _searchQuery = '';
  final ConnectivityService _connectivityService = ConnectivityService();

  @override
  void initState() {
    super.initState();
    _connectivityService.initialize();
  }

  bool get _isOffline => !_connectivityService.isOnline;

  void _showOfflineDialog(String action) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.wifi_off, color: Colors.orange),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Offline Mode',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: Text(
          'Cannot $action while offline. Please connect to internet to perform this action.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PengumumanBloc()..add(LoadPengumuman()),
      child: Builder(
        builder: (context) => Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AdminHeader(
            title: 'Announcements Management',
            icon: Icons.announcement,
            additionalActions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  context.read<PengumumanBloc>().add(RefreshPengumuman());
                },
                tooltip: 'Refresh',
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: () {
                  if (_isOffline) {
                    _showOfflineDialog('add announcement');
                    return;
                  }
                  _showAddPengumumanDialog(context);
                },
                tooltip: 'Add Announcement',
              ),
            ],
          ),
          body: Column(
            children: [
              _buildSearchBar(context),
              Expanded(
                child: BlocConsumer<PengumumanBloc, PengumumanState>(
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

                    // Filter by search query
                    final filteredList = state.pengumumanList.where((
                      pengumuman,
                    ) {
                      if (_searchQuery.isEmpty) return true;
                      final query = _searchQuery.toLowerCase();
                      return pengumuman.judul.toLowerCase().contains(query) ||
                          pengumuman.deskripsi.toLowerCase().contains(query) ||
                          pengumuman.pembuatDisplay.toLowerCase().contains(
                            query,
                          );
                    }).toList();

                    if (filteredList.isEmpty) {
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
                              _searchQuery.isEmpty
                                  ? 'No announcements yet'
                                  : 'No announcements found',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _searchQuery.isEmpty
                                  ? 'Click the + button to add an announcement'
                                  : 'Try adjusting your search',
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
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          int crossAxisCount = 1;
                          if (constraints.maxWidth >= 1200) {
                            crossAxisCount = 3;
                          } else if (constraints.maxWidth >= 768) {
                            crossAxisCount = 2;
                          }

                          return GridView.builder(
                            padding: const EdgeInsets.all(20),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: crossAxisCount,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                  childAspectRatio: 1.5,
                                ),
                            itemCount: filteredList.length,
                            itemBuilder: (context, index) {
                              final pengumuman = filteredList[index];
                              return _buildPengumumanCard(context, pengumuman);
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        decoration: InputDecoration(
          hintText: 'Search announcements by title, description, or author...',
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey[800]
              : Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildPengumumanCard(
    BuildContext context,
    PengumumanModel pengumuman,
  ) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[800]!
                : Colors.grey[200]!,
            width: 1,
          ),
        ),
        child: InkWell(
          onTap: () => _showPengumumanDetail(context, pengumuman),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header dengan icon dan menu
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.announcement,
                        color: Colors.orange,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        pengumuman.judul,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    PopupMenuButton(
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit, color: Colors.blue, size: 16),
                              SizedBox(width: 8),
                              Text('Edit'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, color: Colors.red, size: 16),
                              SizedBox(width: 8),
                              Text('Delete'),
                            ],
                          ),
                        ),
                      ],
                      onSelected: (value) {
                        if (value == 'edit') {
                          if (_isOffline) {
                            _showOfflineDialog('edit announcement');
                            return;
                          }
                          _showEditPengumumanDialog(context, pengumuman);
                        } else if (value == 'delete') {
                          if (_isOffline) {
                            _showOfflineDialog('delete announcement');
                            return;
                          }
                          _showDeleteConfirmation(context, pengumuman);
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Deskripsi
                Expanded(
                  child: Text(
                    pengumuman.deskripsi,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
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
                            ? Colors.red.withOpacity(0.1)
                            : Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        pengumuman.pembuatDisplay,
                        style: TextStyle(
                          fontSize: 12,
                          color: pengumuman.pembuat == 'admin'
                              ? Colors.red[700]
                              : Colors.blue[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Icon(Icons.access_time, size: 14, color: Colors.grey[500]),
                    const SizedBox(width: 4),
                    Text(
                      pengumuman.formattedDateTime,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showPengumumanDetail(BuildContext context, PengumumanModel pengumuman) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.announcement, color: Colors.orange),
            ),
            const SizedBox(width: 12),
            const Expanded(child: Text('Announcement Details')),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Title', pengumuman.judul, Icons.title),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.description, size: 20, color: Colors.orange),
                        const SizedBox(width: 12),
                        Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      pengumuman.deskripsi,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildDetailRow(
                'Posted By',
                pengumuman.pembuatDisplay,
                Icons.person,
              ),
              const SizedBox(height: 16),
              _buildDetailRow(
                'Date & Time',
                pengumuman.formattedDateTime,
                Icons.access_time,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Close'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(dialogContext);
              _showEditPengumumanDialog(context, pengumuman);
            },
            icon: const Icon(Icons.edit, size: 18),
            label: const Text('Edit'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.orange),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
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
    final bloc = context.read<PengumumanBloc>();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: Text('Are you sure you want to delete "${pengumuman.judul}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              bloc.add(DeletePengumuman(id: pengumuman.id));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
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
          title: const Text('Add Announcement'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: judulController,
                  decoration: const InputDecoration(
                    labelText: 'Announcement Title',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Title is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: deskripsiController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Description is required';
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
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: state.isLoading ? null : _submitPengumuman,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
              child: state.isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Add'),
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
          title: const Text('Edit Announcement'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: judulController,
                  decoration: const InputDecoration(
                    labelText: 'Announcement Title',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Title is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: deskripsiController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Description is required';
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
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: state.isLoading ? null : _updatePengumuman,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
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
