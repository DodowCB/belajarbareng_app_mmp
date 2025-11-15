import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/config/theme.dart';
import '../profile_menu/profile_menu_widget.dart';
import 'siswa_data_bloc.dart';
import 'siswa_data_event.dart';
import 'siswa_data_state.dart';

class SiswaDataScreen extends StatefulWidget {
  const SiswaDataScreen({super.key});

  @override
  State<SiswaDataScreen> createState() => _SiswaDataScreenState();
}

class _SiswaDataScreenState extends State<SiswaDataScreen> {
  late SiswaDataBloc _siswaDataBloc;

  @override
  void initState() {
    super.initState();
    _siswaDataBloc = SiswaDataBloc();
  }

  @override
  void dispose() {
    _siswaDataBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _siswaDataBloc,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: const Text('Data Siswa'),
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
        body: BlocListener<SiswaDataBloc, SiswaState>(
          listener: (context, state) {
            if (state is SiswaDataError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            } else if (state is SiswaDataActionSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );
            }
          },
          child: StreamBuilder<List<Map<String, dynamic>>>(
            stream: _siswaDataBloc.getSiswaStream(),
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

              return _buildSiswaTable(snapshot.data!);
            },
          ),
        ),
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton(
              heroTag: "add_siswa",
              onPressed: () => _showAddSiswaDialog(),
              backgroundColor: AppTheme.primaryPurple,
              child: const Icon(Icons.add, color: Colors.white),
            ),
            const SizedBox(height: 10),
            FloatingActionButton(
              heroTag: "import_excel_siswa",
              onPressed: _importFromExcel,
              backgroundColor: AppTheme.accentGreen,
              child: const Icon(Icons.file_upload, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSiswaTable(List<Map<String, dynamic>> siswaList) {
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
                color: AppTheme.primaryPurple.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.person, color: AppTheme.primaryPurple),
                  const SizedBox(width: 8),
                  Text(
                    'Total Siswa: ${siswaList.length}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryPurple,
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
                              'NIS',
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
                              'Password',
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
                              'Tanggal Lahir',
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
                        rows: siswaList.map((siswa) {
                          final isDisabled = siswa['isDisabled'] as bool;
                          return DataRow(
                            cells: [
                              DataCell(
                                Text(
                                  siswa['nama'] as String,
                                  style: TextStyle(
                                    color: isDisabled
                                        ? Colors.red
                                        : Colors.white,
                                    decoration: isDisabled
                                        ? TextDecoration.lineThrough
                                        : null,
                                  ),
                                ),
                              ),
                              DataCell(Text(siswa['nis'] as String)),
                              DataCell(Text(siswa['email'] as String)),
                              DataCell(Text(siswa['password'] as String)),
                              DataCell(Text(siswa['jenisKelamin'] as String)),
                              DataCell(Text(siswa['tanggalLahir'] as String)),
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
                                    isDisabled ? 'Disabled' : 'Active',
                                    style: TextStyle(
                                      color: isDisabled
                                          ? Colors.red
                                          : Colors.green,
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
                                      onPressed: () => _showEditSiswaDialog(siswa),
                                      tooltip: 'Edit',
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        isDisabled
                                            ? Icons.check_circle
                                            : Icons.block,
                                        color: isDisabled
                                            ? Colors.green
                                            : Colors.orange,
                                        size: 20,
                                      ),
                                      onPressed: () => _showDisableDialog(
                                        siswa['id'] as String,
                                        !isDisabled,
                                      ),
                                      tooltip: isDisabled
                                          ? 'Enable'
                                          : 'Disable',
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                        size: 20,
                                      ),
                                      onPressed: () => _showDeleteDialog(
                                        siswa['id'] as String,
                                        siswa['nama'] as String,
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

  void _showDisableDialog(String siswaId, bool disable) {
    final blocContext = context; // Capture the widget's context
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(disable ? 'Disable Siswa' : 'Enable Siswa'),
          content: Text(
            disable
                ? 'Are you sure you want to disable this siswa?'
                : 'Are you sure you want to enable this siswa?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                blocContext.read<SiswaDataBloc>().add(
                  DisableSiswa(siswaId, disable),
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

  void _showDeleteDialog(String siswaId, String siswaName) {
    final blocContext = context; // Capture the widget's context
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Delete Siswa'),
          content: Text(
            'Are you sure you want to delete "$siswaName"? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                blocContext.read<SiswaDataBloc>().add(DeleteSiswa(siswaId));
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
          title: const Text('Import Siswa from Excel'),
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
                  'Kolom B: NIS\n'
                  'Kolom C: Email (Required)\n'
                  'Kolom D: Password (Required)\n'
                  'Kolom D: Jenis Kelamin (L/P)\n'
                  'Kolom E: Tanggal Lahir (DD/MM/YYYY)',
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
                blocContext.read<SiswaDataBloc>().add(
                  const ImportSiswaFromExcel(),
                );
              },
              child: const Text('Choose Excel File'),
            ),
          ],
        );
      },
    );
  }

  void _showAddSiswaDialog() {
    _showSiswaFormDialog();
  }

  void _showEditSiswaDialog(Map<String, dynamic> siswa) {
    _showSiswaFormDialog(siswa: siswa);
  }

  void _showSiswaFormDialog({Map<String, dynamic>? siswa}) {
    final isEdit = siswa != null;
    final namaController = TextEditingController(text: siswa?['nama'] ?? '');
    final nisController = TextEditingController(text: siswa?['nis'] ?? '');
    final emailController = TextEditingController(text: siswa?['email'] ?? '');
    final tanggalLahirController = TextEditingController(text: siswa?['tanggalLahir'] ?? '');
    String selectedJenisKelamin = siswa?['jenisKelamin'] ?? 'L';

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(isEdit ? 'Edit Siswa' : 'Tambah Siswa'),
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
                        controller: nisController,
                        decoration: const InputDecoration(
                          labelText: 'NIS',
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
                        controller: tanggalLahirController,
                        decoration: const InputDecoration(
                          labelText: 'Tanggal Lahir (DD/MM/YYYY)',
                          border: OutlineInputBorder(),
                        ),
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null) {
                            tanggalLahirController.text = 
                              '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
                          }
                        },
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
                    final nis = nisController.text.trim();
                    final email = emailController.text.trim();
                    final tanggalLahir = tanggalLahirController.text.trim();

                    if (nama.isEmpty || email.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Nama dan Email harus diisi'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    final siswaData = {
                      'nama': nama,
                      'nis': nis,
                      'email': email,
                      'jenis_kelamin': selectedJenisKelamin,
                      'tanggal_lahir': tanggalLahir,
                      'status': 'active',
                      'photo_url': '',
                      'createdAt': DateTime.now().toIso8601String(),
                    };

                    Navigator.of(dialogContext).pop();

                    if (isEdit) {
                      _siswaDataBloc.add(UpdateSiswa(siswa['id'], siswaData));
                    } else {
                      _siswaDataBloc.add(AddSiswa(siswaData));
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
