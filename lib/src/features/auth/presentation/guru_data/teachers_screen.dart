import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/config/theme.dart';
import '../../../../core/services/connectivity_service.dart';
import '../widgets/admin_header.dart';
import 'guru_data_bloc.dart';
import 'guru_data_event.dart';
import 'guru_data_state.dart';

class TeachersScreen extends StatefulWidget {
  final String? highlightId;
  
  const TeachersScreen({super.key, this.highlightId});

  @override
  State<TeachersScreen> createState() => _TeachersScreenState();
}

class _TeachersScreenState extends State<TeachersScreen> {
  late GuruDataBloc _guruDataBloc;
  String _searchQuery = '';
  final ConnectivityService _connectivityService = ConnectivityService();
  
  String? get _highlightId => widget.highlightId;

  @override
  void initState() {
    super.initState();
    _guruDataBloc = GuruDataBloc();
    _connectivityService.initialize();
    // Listen to connectivity changes to update UI
    _connectivityService.addListener(() {
      if (mounted) setState(() {});
    });

    // Show notification if highlighting a specific teacher
    if (_highlightId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Showing teacher registration: $_highlightId'),
            backgroundColor: AppTheme.primaryPurple,
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: 'OK',
              textColor: Colors.white,
              onPressed: () {},
            ),
          ),
        );
      });
    }
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
  void dispose() {
    _guruDataBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _guruDataBloc,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AdminHeader(
          title: 'Teachers Management',
          icon: Icons.school,
          additionalActions: [
            // Connection status indicator

            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: () {
                  if (_isOffline) {
                    _showOfflineDialog('add teacher');
                    return;
                  }
                  _showTeacherForm();
                },
                tooltip: 'Add Teacher',
              ),
            ),
          ],
        ),
        body: BlocListener<GuruDataBloc, GuruDataState>(
          listener: (context, state) {
            if (state is GuruDataError) {
              _showSnackBar(state.message, isError: true);
            } else if (state is GuruDataActionSuccess) {
              _showSnackBar(state.message, isError: false);
            }
          },
          child: Column(
            children: [
              _buildSearchBar(),
              if (_isOffline) _buildOfflineBanner(),
              Expanded(child: _buildTeachersList()),
            ],
          ),
        ),
        floatingActionButton: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: FloatingActionButton.extended(
            onPressed: () {
              if (_isOffline) {
                _showOfflineDialog('import data');
                return;
              }
              _showImportDialog();
            },
            backgroundColor: AppTheme.accentGreen,
            icon: const Icon(Icons.file_upload, color: Colors.white),
            label: const Text(
              'Import Excel',
              style: TextStyle(color: Colors.white),
            ),
          ),
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
          hintText: 'Search teachers by name, email, NIG, or subject...',
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

  Widget _buildOfflineBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.wifi_off, color: Colors.orange, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Offline Mode',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[800],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'You can view cached data. Adding/editing/deleting is disabled.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.orange[700]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeachersList() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _guruDataBloc.getGuruStream(),
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

        List<Map<String, dynamic>> teachers = snapshot.data ?? [];

        // Filter by search query
        if (_searchQuery.isNotEmpty) {
          teachers = teachers.where((teacher) {
            final name = (teacher['nama'] ?? '').toString().toLowerCase();
            final email = (teacher['email'] ?? '').toString().toLowerCase();
            final nig = (teacher['nig'] ?? '').toString().toLowerCase();
            final subject = (teacher['mataPelajaran'] ?? '')
                .toString()
                .toLowerCase();
            return name.contains(_searchQuery) ||
                email.contains(_searchQuery) ||
                nig.contains(_searchQuery) ||
                subject.contains(_searchQuery);
          }).toList();
        }

        if (teachers.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.school_outlined, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'No teachers found',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: () => _showTeacherForm(),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Teacher'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.secondaryTeal,
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
                    : 1.5,
              ),
              itemCount: teachers.length,
              itemBuilder: (context, index) =>
                  _buildTeacherCard(teachers[index]),
            );
          },
        );
      },
    );
  }

  Widget _buildTeacherCard(Map<String, dynamic> teacher) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isDisabled = teacher['isDisabled'] ?? false;
    final teacherId = teacher['id']?.toString();
    final isHighlighted = _highlightId != null && teacherId == _highlightId;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Card(
        elevation: isHighlighted ? 8 : 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isHighlighted 
                ? AppTheme.primaryPurple 
                : isDark ? Colors.grey[800]! : Colors.grey[200]!,
            width: isHighlighted ? 3 : 1,
          ),
        ),
        color: isHighlighted 
            ? AppTheme.primaryPurple.withOpacity(0.1)
            : null,
        child: InkWell(
          onTap: () => _showTeacherDetail(teacher),
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              if (isHighlighted)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryPurple,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'NEW',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: AppTheme.secondaryTeal.withOpacity(
                            0.2,
                          ),
                          child: Text(
                            (teacher['nama'] ?? 'T')[0].toUpperCase(),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.secondaryTeal,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                teacher['nama'] ?? 'N/A',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.secondaryTeal,
                                    ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'NIG: ${teacher['nig'] ?? 'N/A'}',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow(
                      Icons.book,
                      teacher['mataPelajaran'] ?? 'N/A',
                    ),
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      Icons.email_outlined,
                      teacher['email'] ?? 'N/A',
                    ),
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      Icons.location_city,
                      teacher['sekolah'] ?? 'N/A',
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Icon(
                          Icons.circle,
                          size: 10,
                          color: isDisabled ? Colors.red : Colors.green,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          isDisabled ? 'Inactive' : 'Active',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDisabled ? Colors.red : Colors.green,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        _buildActionButton(
                          icon: Icons.edit,
                          color: Colors.blue,
                          onPressed: () {
                            if (_isOffline) {
                              _showOfflineDialog('edit teacher');
                              return;
                            }
                            _showTeacherForm(teacher: teacher);
                          },
                        ),
                        const SizedBox(width: 4),
                        _buildActionButton(
                          icon: Icons.delete,
                          color: Colors.red,
                          onPressed: () {
                            if (_isOffline) {
                              _showOfflineDialog('delete teacher');
                              return;
                            }
                            _showDeleteDialog(teacher);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (isDisabled)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppTheme.secondaryTeal.withOpacity(0.7)),
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

  void _showTeacherDetail(Map<String, dynamic> teacher) {
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
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: AppTheme.secondaryTeal.withOpacity(0.2),
                      child: Text(
                        (teacher['nama'] ?? 'T')[0].toUpperCase(),
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.secondaryTeal,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            teacher['nama'] ?? 'N/A',
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
                              color: AppTheme.secondaryTeal.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Teacher',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.secondaryTeal,
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
                _buildDetailRow('NIG', teacher['nig']?.toString() ?? 'N/A'),
                _buildDetailRow('Email', teacher['email'] ?? 'N/A'),
                _buildDetailRow(
                  'Mata Pelajaran',
                  teacher['mataPelajaran'] ?? 'N/A',
                ),
                _buildDetailRow('Sekolah', teacher['sekolah'] ?? 'N/A'),
                _buildDetailRow(
                  'Jenis Kelamin',
                  teacher['jenisKelamin'] ?? 'N/A',
                ),
                _buildDetailRow(
                  'Status',
                  (teacher['isDisabled'] ?? false) ? 'Inactive' : 'Active',
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          if (_isOffline) {
                            Navigator.pop(context);
                            _showOfflineDialog('edit teacher');
                            return;
                          }
                          Navigator.pop(context);
                          _showTeacherForm(teacher: teacher);
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
                          if (_isOffline) {
                            Navigator.pop(context);
                            _showOfflineDialog('delete teacher');
                            return;
                          }
                          Navigator.pop(context);
                          _showDeleteDialog(teacher);
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
            width: 120,
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

  void _showTeacherForm({Map<String, dynamic>? teacher}) {
    final isEdit = teacher != null;
    final formKey = GlobalKey<FormState>();

    final namaController = TextEditingController(text: teacher?['nama'] ?? '');
    final nigController = TextEditingController(
      text: teacher?['nig']?.toString() ?? '',
    );
    final emailController = TextEditingController(
      text: teacher?['email'] ?? '',
    );
    final mataPelajaranController = TextEditingController(
      text: teacher?['mataPelajaran'] ?? '',
    );
    final sekolahController = TextEditingController(
      text: teacher?['sekolah'] ?? '',
    );
    final passwordController = TextEditingController();
    String selectedJenisKelamin = teacher?['jenisKelamin'] ?? 'L';

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            padding: const EdgeInsets.all(24),
            child: Form(
              key: formKey,
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
                            color: AppTheme.secondaryTeal.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.school,
                            color: AppTheme.secondaryTeal,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            isEdit ? 'Edit Teacher' : 'Add New Teacher',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(dialogContext),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: namaController,
                      decoration: InputDecoration(
                        labelText: 'Nama Lengkap *',
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Nama harus diisi' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: nigController,
                      decoration: InputDecoration(
                        labelText: 'NIG',
                        prefixIcon: const Icon(Icons.badge),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email *',
                        prefixIcon: const Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value?.isEmpty ?? true) return 'Email harus diisi';
                        if (!RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        ).hasMatch(value!)) {
                          return 'Email tidak valid';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: mataPelajaranController,
                      decoration: InputDecoration(
                        labelText: 'Mata Pelajaran',
                        prefixIcon: const Icon(Icons.book),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: selectedJenisKelamin,
                      decoration: InputDecoration(
                        labelText: 'Jenis Kelamin',
                        prefixIcon: const Icon(Icons.wc),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'L', child: Text('Laki-laki')),
                        DropdownMenuItem(value: 'P', child: Text('Perempuan')),
                      ],
                      onChanged: (value) {
                        setDialogState(() => selectedJenisKelamin = value!);
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: sekolahController,
                      decoration: InputDecoration(
                        labelText: 'Sekolah',
                        prefixIcon: const Icon(Icons.location_city),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: isEdit
                            ? 'Password (kosongkan jika tidak diubah)'
                            : 'Password *',
                        prefixIcon: const Icon(Icons.lock),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (!isEdit && (value?.isEmpty ?? true)) {
                          return 'Password harus diisi';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(dialogContext),
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
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                final guruData = {
                                  'nama_lengkap': namaController.text.trim(),
                                  'nig': nigController.text.trim(),
                                  'email': emailController.text.trim(),
                                  'mata_pelajaran': mataPelajaranController.text
                                      .trim(),
                                  'jenis_kelamin': selectedJenisKelamin,
                                  'sekolah': sekolahController.text.trim(),
                                  'status': 'active',
                                  'photo_url': '',
                                  'createdAt': DateTime.now().toIso8601String(),
                                };

                                if (passwordController.text.isNotEmpty) {
                                  guruData['password'] = passwordController.text
                                      .trim();
                                }

                                Navigator.pop(dialogContext);

                                if (isEdit) {
                                  _guruDataBloc.add(
                                    UpdateGuru(teacher['id'], guruData),
                                  );
                                } else {
                                  _guruDataBloc.add(AddGuru(guruData));
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.secondaryTeal,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(isEdit ? 'Update' : 'Add'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(Map<String, dynamic> teacher) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.red),
            SizedBox(width: 12),
            Text('Delete Teacher'),
          ],
        ),
        content: Text(
          'Are you sure you want to delete "${teacher['nama']}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              _guruDataBloc.add(DeleteGuru(teacher['id']));
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

  void _showImportDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.file_upload, color: AppTheme.accentGreen),
            SizedBox(width: 12),
            Text('Import from Excel'),
          ],
        ),
        content: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Required Excel Format:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Column A: Nama (Required)\n'
                'Column B: NIG\n'
                'Column C: Email (Required)\n'
                'Column D: Mata Pelajaran\n'
                'Column E: Jenis Kelamin (L/P)\n'
                'Column F: Sekolah\n'
                'Column G: Password (Required)',
                style: TextStyle(fontSize: 12),
              ),
              SizedBox(height: 16),
              Text(
                'Please ensure your Excel file matches this format.',
                style: TextStyle(color: Colors.orange, fontSize: 12),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(dialogContext);
              _guruDataBloc.add(const ImportGuruFromExcel());
            },
            icon: const Icon(Icons.file_present),
            label: const Text('Choose File'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentGreen,
              foregroundColor: Colors.white,
            ),
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
