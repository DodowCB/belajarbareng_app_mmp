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
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GuruDataBloc()..add(const LoadGuruData()),
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
        body: BlocConsumer<GuruDataBloc, GuruDataState>(
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
          builder: (context, state) {
            if (state is GuruDataLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is GuruDataLoaded) {
              return _buildGuruTable(state.guruList);
            }

            return const Center(child: Text('No data available'));
          },
        ),
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton(
              heroTag: "add_guru",
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Add Guru feature coming soon')),
                );
              },
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
                      constraints: BoxConstraints(minWidth: constraints.maxWidth),
                      child: DataTable(
                        columnSpacing: constraints.maxWidth > 800 ? 20 : 10,
                        columns: const [
                          DataColumn(label: Text('Nama', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('NIG', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Email', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Mata Pelajaran', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Jenis Kelamin', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Sekolah', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold))),
                        ],
                        rows: guruList.map((guru) {
                          final isDisabled = guru['isDisabled'] as bool;
                          return DataRow(
                            cells: [
                              DataCell(
                                Text(
                                  guru['nama'] as String,
                                  style: TextStyle(
                                    color: isDisabled ? Colors.grey : Colors.black,
                                    decoration: isDisabled ? TextDecoration.lineThrough : null,
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
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: isDisabled ? Colors.red.withOpacity(0.1) : Colors.green.withOpacity(0.1),
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
                                        color: isDisabled ? Colors.green : Colors.orange,
                                        size: 20,
                                      ),
                                      onPressed: () => _showDisableDialog(guru['id'] as String, !isDisabled),
                                      tooltip: isDisabled ? 'Enable' : 'Disable',
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                                      onPressed: () => _showDeleteDialog(guru['id'] as String, guru['nama'] as String),
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
                blocContext.read<GuruDataBloc>().add(DisableGuru(guruId, disable));
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
          content: Text('Are you sure you want to delete "$guruName"? This action cannot be undone.'),
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Import from Excel'),
          content: const Text('Excel import functionality will be implemented when file_picker and excel packages are added to pubspec.yaml'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}