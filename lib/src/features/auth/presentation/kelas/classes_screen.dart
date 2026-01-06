import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/config/theme.dart';
import '../widgets/admin_header.dart';
import '../admin/admin_bloc.dart';
import 'kelas_bloc.dart';
import 'kelas_event.dart';
import 'kelas_state.dart';
import 'siswa_kelas_screen.dart';

class ClassesScreen extends StatefulWidget {
  const ClassesScreen({super.key});

  @override
  State<ClassesScreen> createState() => _ClassesScreenState();
}

class _ClassesScreenState extends State<ClassesScreen> {
  late KelasBloc _kelasBloc;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _kelasBloc = KelasBloc()..add(LoadKelas());
  }

  @override
  void dispose() {
    _kelasBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _kelasBloc,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AdminHeader(
          title: 'Classes Management',
          icon: Icons.class_,
          additionalActions: [
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: () => _showClassForm(),
                tooltip: 'Add Class',
              ),
            ),
          ],
        ),
        body: BlocConsumer<KelasBloc, KelasState>(
          listener: (context, state) {
            if (state.error != null) {
              _showSnackBar(state.error!, isError: true);
            } else if (state.successMessage != null) {
              _showSnackBar(state.successMessage!, isError: false);
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                _buildSearchBar(),
                Expanded(child: _buildClassesList(state)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
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
        onChanged: (value) =>
            setState(() => _searchQuery = value.toLowerCase()),
        decoration: InputDecoration(
          hintText: 'Search classes by name, level, or teacher...',
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Theme.of(context).brightness == Brightness.dark
              ? AppTheme.backgroundDark
              : AppTheme.backgroundLight,
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

  Widget _buildClassesList(KelasState state) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('kelas').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text('Error: ${snapshot.error}'),
              ],
            ),
          );
        }

        final docs = snapshot.data?.docs ?? [];

        // Filter by search query
        List<QueryDocumentSnapshot> filteredDocs = docs;
        if (_searchQuery.isNotEmpty) {
          filteredDocs = docs.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final namaKelas = (data['nama_kelas'] ?? '')
                .toString()
                .toLowerCase();
            final jenjang = (data['jenjang_kelas'] ?? '')
                .toString()
                .toLowerCase();
            final nomor = (data['nomor_kelas'] ?? '').toString().toLowerCase();
            final guru = (data['nama_guru'] ?? '').toString().toLowerCase();
            return namaKelas.contains(_searchQuery) ||
                jenjang.contains(_searchQuery) ||
                nomor.contains(_searchQuery) ||
                guru.contains(_searchQuery);
          }).toList();
        }

        if (filteredDocs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.class_outlined, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'No classes found',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: () => _showClassForm(),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Class'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accentPink,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          );
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= 1200;
            final isTablet = constraints.maxWidth >= 768;
            final crossAxisCount = isDesktop
                ? 3
                : isTablet
                ? 2
                : 1;

            return GridView.builder(
              padding: const EdgeInsets.all(20),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: isDesktop
                    ? 1.4
                    : isTablet
                    ? 1.2
                    : 1.3,
              ),
              itemCount: filteredDocs.length,
              itemBuilder: (context, index) {
                final doc = filteredDocs[index];
                final data = doc.data() as Map<String, dynamic>;
                return _buildClassCard(doc.id, data);
              },
            );
          },
        );
      },
    );
  }

  Widget _buildClassCard(String docId, Map<String, dynamic> data) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    String namaKelas = data['nama_kelas'] ?? '';
    if (namaKelas.isEmpty) {
      final jenjang = data['jenjang_kelas'] ?? '';
      final nomor = data['nomor_kelas'] ?? '';
      namaKelas = jenjang.isNotEmpty && nomor.isNotEmpty
          ? '$jenjang $nomor'
          : docId;
    }

    final tahunAjaran = data['tahun_ajaran'] ?? 'N/A';
    final namaGuru = data['nama_guru'] ?? 'No teacher assigned';
    final status = data['status'] ?? false;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
            width: 1,
          ),
        ),
        child: InkWell(
          onTap: () => _showClassDetail(docId, data, namaKelas),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.accentPink.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        docId,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.accentPink,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Class $namaKelas',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.accentPink,
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            tahunAjaran,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildInfoRow(Icons.person_outline, namaGuru),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.circle,
                      size: 10,
                      color: status ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      status ? 'Active' : 'Inactive',
                      style: TextStyle(
                        fontSize: 12,
                        color: status ? Colors.green : Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Row(
                  children: [
                    Expanded(
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: InkWell(
                          onTap: () => _navigateToStudents(docId, namaKelas),
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: AppTheme.accentPink.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.people,
                                  size: 16,
                                  color: AppTheme.accentPink,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Students',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.accentPink,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _buildActionButton(
                      icon: Icons.edit,
                      color: Colors.blue,
                      onPressed: () => _showClassForm(docId: docId, data: data),
                    ),
                    const SizedBox(width: 4),
                    _buildActionButton(
                      icon: Icons.delete,
                      color: Colors.red,
                      onPressed: () => _showDeleteDialog(docId, namaKelas),
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

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppTheme.accentPink.withOpacity(0.7)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodySmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: color),
        ),
      ),
    );
  }

  void _navigateToStudents(String kelasId, String namaKelas) {
    // Get AdminBloc from context before navigation
    final adminBloc = context.read<AdminBloc>();
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: adminBloc,
          child: SiswaKelasScreen(kelasId: kelasId, namaKelas: namaKelas),
        ),
      ),
    );
  }

  void _showClassDetail(
    String docId,
    Map<String, dynamic> data,
    String namaKelas,
  ) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.accentPink.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        docId,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.accentPink,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Class $namaKelas',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.accentPink.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Class',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.accentPink,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 16),
                _buildDetailRow('Class ID', docId),
                _buildDetailRow('Class Name', namaKelas),
                _buildDetailRow('Level', data['jenjang_kelas'] ?? 'N/A'),
                _buildDetailRow('Number', data['nomor_kelas'] ?? 'N/A'),
                _buildDetailRow('Academic Year', data['tahun_ajaran'] ?? 'N/A'),
                _buildDetailRow('Homeroom Teacher', data['nama_guru'] ?? 'N/A'),
                _buildDetailRow(
                  'Status',
                  (data['status'] ?? false) ? 'Active' : 'Inactive',
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          _navigateToStudents(docId, namaKelas);
                        },
                        icon: const Icon(Icons.people),
                        label: const Text('View Students'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.accentPink,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          _showClassForm(docId: docId, data: data);
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text('Edit'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          _showDeleteDialog(docId, namaKelas);
                        },
                        icon: const Icon(Icons.delete),
                        label: const Text('Delete'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }

  void _showClassForm({String? docId, Map<String, dynamic>? data}) {
    final isEdit = docId != null;

    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider(
        create: (context) => KelasBloc()..add(LoadGuru()),
        child: ClassFormDialog(
          isEdit: isEdit,
          docId: docId,
          data: data,
          onSuccess: () {
            _kelasBloc.add(LoadKelas());
          },
        ),
      ),
    );
  }

  void _showDeleteDialog(String docId, String namaKelas) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.red),
            SizedBox(width: 12),
            Text('Delete Class'),
          ],
        ),
        content: Text(
          'Are you sure you want to delete "Class $namaKelas"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              _kelasBloc.add(DeleteKelas(id: docId));
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

  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

class ClassFormDialog extends StatefulWidget {
  final bool isEdit;
  final String? docId;
  final Map<String, dynamic>? data;
  final VoidCallback onSuccess;

  const ClassFormDialog({
    super.key,
    required this.isEdit,
    this.docId,
    this.data,
    required this.onSuccess,
  });

  @override
  State<ClassFormDialog> createState() => _ClassFormDialogState();
}

class _ClassFormDialogState extends State<ClassFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _jenjangController;
  late TextEditingController _nomorController;
  late TextEditingController _tahunController;
  String? _selectedGuruId;
  String? _selectedGuruNama;

  @override
  void initState() {
    super.initState();
    _jenjangController = TextEditingController(
      text: widget.data?['jenjang_kelas'] ?? '',
    );
    _nomorController = TextEditingController(
      text: widget.data?['nomor_kelas'] ?? '',
    );
    _tahunController = TextEditingController(
      text: widget.data?['tahun_ajaran'] ?? '2025-2026',
    );
    _selectedGuruId = widget.data?['guru_id']?.toString();
    _selectedGuruNama = widget.data?['nama_guru'];
  }

  @override
  void dispose() {
    _jenjangController.dispose();
    _nomorController.dispose();
    _tahunController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('🟢 ClassFormDialog build called');
    return BlocConsumer<KelasBloc, KelasState>(
      listener: (context, state) {
        print(
          '🟡 ClassFormDialog listener: guruList.length = ${state.guruList.length}',
        );

        if (state.successMessage != null) {
          Navigator.pop(context);
          widget.onSuccess();
        } else if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error!), backgroundColor: Colors.red),
          );
        }

        // Validasi _selectedGuruId saat guruList di-load
        if (state.guruList.isNotEmpty && _selectedGuruId != null) {
          final guruExists = state.guruList.any((g) => g.id == _selectedGuruId);
          if (!guruExists) {
            setState(() {
              _selectedGuruId = null;
              _selectedGuruNama = null;
            });
          }
        }
      },
      builder: (context, state) {
        print(
          '🟢 ClassFormDialog builder: guruList.length = ${state.guruList.length}',
        );
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppTheme.accentPink.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.class_,
                            color: AppTheme.accentPink,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            widget.isEdit ? 'Edit Class' : 'Add New Class',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _jenjangController,
                      decoration: InputDecoration(
                        labelText: 'Level (e.g., 10, 11, 12) *',
                        prefixIcon: const Icon(Icons.stairs),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Level is required' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _nomorController,
                      decoration: InputDecoration(
                        labelText: 'Class Number (e.g., A, B, C) *',
                        prefixIcon: const Icon(Icons.numbers),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) => value?.isEmpty ?? true
                          ? 'Class number is required'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _tahunController,
                      decoration: InputDecoration(
                        labelText: 'Academic Year *',
                        prefixIcon: const Icon(Icons.calendar_today),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) => value?.isEmpty ?? true
                          ? 'Academic year is required'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    // Dropdown Guru
                    BlocBuilder<KelasBloc, KelasState>(
                      builder: (context, state) {
                        print(
                          '🟣 Dropdown BlocBuilder: guruList.length = ${state.guruList.length}',
                        );

                        if (state.guruList.isEmpty) {
                          print(
                            '🟣 Dropdown: Showing loading (guruList is empty)',
                          );
                          return Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                                SizedBox(width: 16),
                                Text('Loading teachers...'),
                              ],
                            ),
                          );
                        }

                        print(
                          '🟣 Dropdown: Showing dropdown with ${state.guruList.length} teachers',
                        );
                        return DropdownButtonFormField<String>(
                          value: _selectedGuruId,
                          decoration: InputDecoration(
                            labelText: 'Homeroom Teacher *',
                            prefixIcon: const Icon(Icons.person),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          items: state.guruList.map((guru) {
                            return DropdownMenuItem<String>(
                              value: guru.id.toString(),
                              child: Text(
                                '${guru.namaLengkap} (NIG: ${guru.nig})',
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedGuruId = value;
                              if (value != null) {
                                final selectedGuru = state.guruList.firstWhere(
                                  (g) => g.id == value,
                                );
                                _selectedGuruNama = selectedGuru.namaLengkap;
                              }
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a homeroom teacher';
                            }
                            return null;
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Cancel'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: state.isLoading
                                ? null
                                : () {
                                    if (_formKey.currentState!.validate()) {
                                      final namaKelas =
                                          '${_jenjangController.text.trim()} ${_nomorController.text.trim()}';

                                      if (widget.isEdit) {
                                        context.read<KelasBloc>().add(
                                          UpdateKelas(
                                            id: widget.docId!,
                                            namaKelas: namaKelas,
                                            jenjangKelas: _jenjangController
                                                .text
                                                .trim(),
                                            nomorKelas: _nomorController.text
                                                .trim(),
                                            tahunAjaran: _tahunController.text
                                                .trim(),
                                            guruId: _selectedGuruId!,
                                            namaGuru: _selectedGuruNama!,
                                          ),
                                        );
                                      } else {
                                        context.read<KelasBloc>().add(
                                          AddKelas(
                                            namaKelas: namaKelas,
                                            jenjangKelas: _jenjangController
                                                .text
                                                .trim(),
                                            nomorKelas: _nomorController.text
                                                .trim(),
                                            tahunAjaran: _tahunController.text
                                                .trim(),
                                            guruId: _selectedGuruId!,
                                            namaGuru: _selectedGuruNama!,
                                          ),
                                        );
                                      }
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.accentPink,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: state.isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : Text(widget.isEdit ? 'Update' : 'Add'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
