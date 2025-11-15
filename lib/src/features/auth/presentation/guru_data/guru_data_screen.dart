import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/config/theme.dart';
import '../profile_menu/profile_menu_widget.dart';
import 'guru_data_bloc.dart';
import 'guru_data_event.dart';
import 'guru_data_state.dart';

class GuruDataScreen extends StatefulWidget {
  const GuruDataScreen({super.key});

  @override
  State<GuruDataScreen> createState() => _GuruDataScreenState();
}

class _GuruDataScreenState extends State<GuruDataScreen> {
  late GuruDataBloc _guruDataBloc;

  @override
  void initState() {
    super.initState();
    _guruDataBloc = GuruDataBloc();
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
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: const Text('Data Guru'),
          backgroundColor: Colors.white,
          elevation: 1,
          titleTextStyle: const TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: const IconThemeData(color: Colors.black87),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12, left: 8),
              child: ProfileDropdownMenu(
                userName: 'Administrator',
                userEmail: 'Administrator@gmail.com',
              ),
            ),
          ],
        ),
        body: BlocListener<GuruDataBloc, GuruDataState>(
          listener: (context, state) {
            if (state is GuruDataError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            } else if (state is GuruDataActionSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );
            }
          },
          child: StreamBuilder<List<Map<String, dynamic>>>(
            stream: _guruDataBloc.getGuruStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No data available'));
              }

              return _buildGuruTable(snapshot.data!);
            },
          ),
        ),
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton(
              heroTag: "add_guru",
              onPressed: () => _showAddGuruDialog(),
              backgroundColor: AppTheme.primaryPurple,
              child: const Icon(Icons.add, color: Colors.white),
            ),
            const SizedBox(height: 10),
            FloatingActionButton(
              heroTag: "import_excel",
              onPressed: _importFromExcel,
              backgroundColor: AppTheme.accentGreen,
              child: const Icon(Icons.file_upload, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuruTable(List<Map<String, dynamic>> guruList) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.secondaryTeal.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.school, color: AppTheme.secondaryTeal),
                  const SizedBox(width: 8),
                  Text(
                    'Total Guru: ${guruList.length}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.secondaryTeal,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: constraints.maxWidth,
                      ),
                      child: DataTable(
                        columnSpacing: constraints.maxWidth > 800 ? 20 : 10,
                        columns: const [
                          DataColumn(
                            label: Text(
                              'Nama',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'NIG',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Email',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Mata Pelajaran',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Jenis Kelamin',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Sekolah',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Status',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Actions',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                        rows: guruList.map((guru) {
                          final isDisabled = guru['isDisabled'] as bool;
                          print(isDisabled);
                          return DataRow(
                            cells: [
                              DataCell(
                                Text(
                                  guru['nama'] as String,
                                  style: TextStyle(
                                    color: isDisabled
                                        ? Colors.grey
                                        : Colors.red,
                                  ),
                                ),
                              ),
                              DataCell(Text(guru['nig'] as String)),
                              DataCell(Text(guru['email'] as String)),
                              DataCell(Text(guru['mataPelajaran'] as String)),
                              DataCell(Text(guru['jenisKelamin'] as String)),
                              DataCell(Text(guru['sekolah'] as String)),
                              DataCell(
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isDisabled
                                        ? Colors.red.withOpacity(0.1)
                                        : Colors.green.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    isDisabled ? 'Active' : 'Disabled',
                                    style: TextStyle(
                                      color: isDisabled
                                          ? Colors.green
                                          : Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                              DataCell(
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.blue,
                                        size: 20,
                                      ),
                                      onPressed: () => _showEditGuruDialog(guru),
                                      tooltip: 'Edit',
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        isDisabled
                                            ? Icons.block
                                            : Icons.check_circle,
                                        color: isDisabled
                                            ? Colors.green
                                            : Colors.orange,
                                        size: 20,
                                      ),
                                      onPressed: () => _showDisableDialog(
                                        guru['id'] as String,
                                        isDisabled,
                                      ),
                                      tooltip: isDisabled
                                          ? 'Disable'
                                          : 'Enable',
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                        size: 20,
                                      ),
                                      onPressed: () => _showDeleteDialog(
                                        guru['id'] as String,
                                        guru['nama'] as String,
                                      ),
                                      tooltip: 'Delete',
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDisableDialog(String guruId, bool disable) {
    final blocContext = context; // Capture the widget's context
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(disable ? 'Disable Guru' : 'Enable Guru'),
          content: Text(
            disable
                ? 'Are you sure you want to disable this guru?'
                : 'Are you sure you want to enable this guru?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                blocContext.read<GuruDataBloc>().add(
                  DisableGuru(guruId, disable),
                );
                Navigator.of(dialogContext).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: disable ? Colors.orange : Colors.green,
              ),
              child: Text(disable ? 'Disable' : 'Enable'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteDialog(String guruId, String guruName) {
    final blocContext = context; // Capture the widget's context
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Delete Guru'),
          content: Text(
            'Are you sure you want to delete "$guruName"? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                blocContext.read<GuruDataBloc>().add(DeleteGuru(guruId));
                Navigator.of(dialogContext).pop();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _importFromExcel() {
    final blocContext = context;
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Import Guru from Excel'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Format Excel yang diperlukan:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Kolom A: Nama (Required)\n'
                  'Kolom B: NIG\n'
                  'Kolom C: Email (Required)\n'
                  'Kolom D: Mata Pelajaran\n'
                  'Kolom E: Jenis Kelamin (L/P)\n'
                  'Kolom F: Sekolah\n'
                  'Kolom G: Password (Required)',
                  style: TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Pastikan file Excel Anda sesuai format di atas.',
                  style: TextStyle(color: Colors.orange),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                blocContext.read<GuruDataBloc>().add(
                  const ImportGuruFromExcel(),
                );
              },
              child: const Text('Choose Excel File'),
            ),
          ],
        );
      },
    );
  }

  void _showAddGuruDialog() {
    _showGuruFormDialog();
  }

  void _showEditGuruDialog(Map<String, dynamic> guru) {
    _showGuruFormDialog(guru: guru);
  }

  void _showGuruFormDialog({Map<String, dynamic>? guru}) {
    final isEdit = guru != null;
    final namaController = TextEditingController(text: guru?['nama'] ?? '');
    final nigController = TextEditingController(text: guru?['nig'] ?? '');
    final emailController = TextEditingController(text: guru?['email'] ?? '');
    final mataPelajaranController = TextEditingController(text: guru?['mataPelajaran'] ?? '');
    final sekolahController = TextEditingController(text: guru?['sekolah'] ?? '');
    final passwordController = TextEditingController();
    String selectedJenisKelamin = guru?['jenisKelamin'] ?? 'L';

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(isEdit ? 'Edit Guru' : 'Tambah Guru'),
              content: SizedBox(
                width: double.maxFinite,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: namaController,
                        decoration: const InputDecoration(
                          labelText: 'Nama',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: nigController,
                        decoration: const InputDecoration(
                          labelText: 'NIG',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: mataPelajaranController,
                        decoration: const InputDecoration(
                          labelText: 'Mata Pelajaran',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: selectedJenisKelamin,
                        decoration: const InputDecoration(
                          labelText: 'Jenis Kelamin',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'L', child: Text('Laki-laki')),
                          DropdownMenuItem(value: 'P', child: Text('Perempuan')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedJenisKelamin = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: sekolahController,
                        decoration: const InputDecoration(
                          labelText: 'Sekolah',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          labelText: isEdit ? 'Password (kosongkan jika tidak diubah)' : 'Password',
                          border: const OutlineInputBorder(),
                        ),
                        obscureText: true,
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final nama = namaController.text.trim();
                    final nig = nigController.text.trim();
                    final email = emailController.text.trim();
                    final mataPelajaran = mataPelajaranController.text.trim();
                    final sekolah = sekolahController.text.trim();
                    final password = passwordController.text.trim();

                    if (nama.isEmpty || email.isEmpty || (!isEdit && password.isEmpty)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Nama, Email, dan Password harus diisi'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    final guruData = {
                      'nama_lengkap': nama,
                      'nig': nig,
                      'email': email,
                      'mata_pelajaran': mataPelajaran,
                      'jenis_kelamin': selectedJenisKelamin,
                      'sekolah': sekolah,
                      'status': 'active',
                      'photo_url': '',
                      'createdAt': DateTime.now().toIso8601String(),
                    };

                    if (password.isNotEmpty) {
                      guruData['password'] = password;
                    }

                    Navigator.of(dialogContext).pop();

                    if (isEdit) {
                      _guruDataBloc.add(UpdateGuru(guru['id'], guruData));
                    } else {
                      _guruDataBloc.add(AddGuru(guruData));
                    }
                  },
                  child: Text(isEdit ? 'Update' : 'Tambah'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
