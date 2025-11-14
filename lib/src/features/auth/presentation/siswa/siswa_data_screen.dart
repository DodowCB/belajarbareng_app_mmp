import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/config/theme.dart';
import '../profile_menu/profile_menu_widget.dart';
import 'siswa_bloc.dart';

class SiswaDataScreen extends StatefulWidget {
  const SiswaDataScreen({super.key});

  @override
  State<SiswaDataScreen> createState() => _SiswaDataScreenState();
}

class _SiswaDataScreenState extends State<SiswaDataScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SiswaBloc()..add(LoadSiswaData()),
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
        body: BlocConsumer<SiswaBloc, SiswaState>(
          listener: (context, state) {
            if (state is SiswaError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            } else if (state is SiswaActionSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is SiswaLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is SiswaLoaded) {
              return _buildSiswaTable(state.siswaList);
            }

            return const Center(child: Text('No data available'));
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // TODO: Navigate to add siswa screen
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Add Siswa feature coming soon')),
            );
          },
          backgroundColor: AppTheme.primaryPurple,
          child: const Icon(Icons.add, color: Colors.white),
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
                  const Icon(Icons.groups, color: AppTheme.primaryPurple),
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
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 20,
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
                        'Kelas',
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
                  rows: siswaList.map((siswa) {
                    final isDisabled = siswa['isDisabled'] as bool;
                    return DataRow(
                      cells: [
                        DataCell(
                          Text(
                            siswa['nama'] as String,
                            style: TextStyle(
                              color: isDisabled ? Colors.red : Colors.white,
                              decoration: isDisabled
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                        ),
                        DataCell(Text(siswa['nis'] as String)),
                        DataCell(Text(siswa['email'] as String)),
                        DataCell(Text(siswa['kelas'] as String)),
                        DataCell(Text(siswa['sekolah'] as String)),
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
                                color: isDisabled ? Colors.red : Colors.green,
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
                                icon: Icon(
                                  isDisabled ? Icons.check_circle : Icons.block,
                                  color: isDisabled
                                      ? Colors.green
                                      : Colors.orange,
                                  size: 20,
                                ),
                                onPressed: () => _showDisableDialog(
                                  siswa['id'] as String,
                                  !isDisabled,
                                  siswa['nama'] as String,
                                ),
                                tooltip: isDisabled ? 'Enable' : 'Disable',
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
            ),
          ],
        ),
      ),
    );
  }

  void _showDisableDialog(String siswaId, bool disable, String siswaName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(disable ? 'Disable Siswa' : 'Enable Siswa'),
          content: Text(
            disable
                ? 'Are you sure you want to disable this $siswaName?'
                : 'Are you sure you want to enable this $siswaName?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<SiswaBloc>().add(DisableSiswa(siswaId, disable));
                Navigator.of(context).pop();
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Siswa'),
          content: Text(
            'Are you sure you want to delete "$siswaName"? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<SiswaBloc>().add(DeleteSiswa(siswaId));
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
