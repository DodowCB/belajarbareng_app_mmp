import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart' as excel_lib;

import '../../../../core/services/connectivity_service.dart';
import '../widgets/admin_header.dart';
import 'jadwal_mengajar_bloc.dart';
import 'jadwal_mengajar_event.dart';
import 'jadwal_mengajar_state.dart';

class JadwalMengajarScreen extends StatefulWidget {
  const JadwalMengajarScreen({super.key});

  @override
  State<JadwalMengajarScreen> createState() => _JadwalMengajarScreenState();
}

class _JadwalMengajarScreenState extends State<JadwalMengajarScreen> {
  late JadwalMengajarBloc _jadwalBloc;
  final ConnectivityService _connectivityService = ConnectivityService();

  @override
  void initState() {
    super.initState();
    _jadwalBloc = JadwalMengajarBloc();
    _jadwalBloc.add(LoadJadwalMengajar());
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
  void dispose() {
    _jadwalBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _jadwalBloc,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AdminHeader(
          title: 'Jadwal Mengajar Management',
          icon: Icons.schedule,
          additionalActions: [
            BlocBuilder<JadwalMengajarBloc, JadwalMengajarState>(
              builder: (context, state) => IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: () {
                  if (_isOffline) {
                    _showOfflineDialog('add teaching schedule');
                    return;
                  }
                  _showJadwalForm(
                    state: state is JadwalMengajarLoaded ? state : null,
                  );
                },
                tooltip: 'Add Teaching Schedule',
              ),
            ),
          ],
        ),
        body: BlocListener<JadwalMengajarBloc, JadwalMengajarState>(
          listener: (context, state) {
            if (state is JadwalMengajarError) {
              _showSnackBar(state.message, isError: true);
            } else if (state is JadwalMengajarActionSuccess) {
              _showSnackBar(state.message, isError: false);
            }
          },
          child: Column(
            children: [
              _buildSearchBar(),
              Expanded(child: _buildJadwalList()),
            ],
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
      child: Column(
        children: [
          TextField(
            onChanged: (value) {
              _jadwalBloc.add(SearchJadwal(value));
            },
            decoration: InputDecoration(
              hintText:
                  'Search by teacher name, class, subject, day, or time...',
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
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: BlocBuilder<JadwalMengajarBloc, JadwalMengajarState>(
                  builder: (context, state) => ElevatedButton.icon(
                    onPressed: () {
                      if (_isOffline) {
                        _showOfflineDialog('add teaching schedule');
                        return;
                      }
                      _showJadwalForm(
                        state: state is JadwalMengajarLoaded ? state : null,
                      );
                    },
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Add Manual'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (_isOffline) {
                      _showOfflineDialog('import data');
                      return;
                    }
                    _showImportDialog();
                  },
                  icon: const Icon(Icons.file_upload, size: 18),
                  label: const Text('Import Excel'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildJadwalList() {
    return BlocBuilder<JadwalMengajarBloc, JadwalMengajarState>(
      builder: (context, state) {
        if (state is JadwalMengajarLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is JadwalMengajarError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text('Error: ${state.message}'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _jadwalBloc.add(LoadJadwalMengajar()),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (state is JadwalMengajarLoaded) {
          final jadwalList = state.filteredJadwalList;

          if (jadwalList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.schedule_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No teaching schedules found',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: () => _showJadwalForm(state: state),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Teaching Schedule'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: jadwalList.length,
            itemBuilder: (context, index) {
              final jadwal = jadwalList[index];
              return _buildJadwalCard(jadwal, state);
            },
          );
        }

        return const SizedBox();
      },
    );
  }

  Widget _buildJadwalCard(
    Map<String, dynamic> jadwal,
    JadwalMengajarLoaded state,
  ) {
    // Helper functions to get names from IDs
    String getGuruName(String? guruId) {
      if (guruId == null) return 'Unknown Teacher';
      print(state.guruList);
      final guru = state.guruList.firstWhere(
        (g) => g['id'] == guruId,
        orElse: () => {'nama_lengkap': 'Unknown Teacher'},
      );
      return guru['nama_lengkap'] ?? 'Unknown Teacher';
    }

    String getKelasName(String? kelasId) {
      if (kelasId == null) return 'Unknown Class';
      final kelas = state.kelasList.firstWhere(
        (k) => k['id'] == kelasId,
        orElse: () => {'nama': 'Unknown Class'},
      );
      return kelas['nama_kelas'] ?? 'Unknown Class';
    }

    String getMapelName(String? mapelId) {
      if (mapelId == null) return 'Unknown Subject';
      final mapel = state.mapelList.firstWhere(
        (m) => m['id'] == mapelId,
        orElse: () => {'namaMapel': 'Unknown Subject'},
      );
      return mapel['namaMapel'] ?? 'Unknown Subject';
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          onTap: () => _showJadwalDetail(jadwal, state),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.purple.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.schedule, color: Colors.purple),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            getGuruName(jadwal['id_guru']),
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${getKelasName(jadwal['id_kelas'])} - ${getMapelName(jadwal['id_mapel'])}',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: Colors.grey[600]),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'edit') {
                          if (_isOffline) {
                            _showOfflineDialog('edit teaching schedule');
                            return;
                          }
                          _showJadwalForm(jadwal: jadwal, state: state);
                        } else if (value == 'delete') {
                          if (_isOffline) {
                            _showOfflineDialog('delete teaching schedule');
                            return;
                          }
                          _deleteJadwal(jadwal['id']);
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit, size: 16),
                              SizedBox(width: 8),
                              Text('Edit'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, size: 16, color: Colors.red),
                              SizedBox(width: 8),
                              Text(
                                'Delete',
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.teal.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.access_time, size: 16, color: Colors.teal),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          '${jadwal['hari'] ?? 'No day'} - ${jadwal['jam'] ?? 'No time'}',
                          style: TextStyle(
                            color: Colors.teal,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showJadwalForm({
    Map<String, dynamic>? jadwal,
    JadwalMengajarLoaded? state,
  }) {
    showDialog(
      context: context,
      builder: (context) => BlocProvider.value(
        value: _jadwalBloc,
        child: JadwalFormDialog(jadwal: jadwal, state: state),
      ),
    );
  }

  void _showImportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Import from Excel'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Import teaching schedules from Excel file (.xlsx only)'),
            SizedBox(height: 16),
            Text(
              'Excel format should have columns:',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 8),
            Text('• Guru (Teacher Name)'),
            Text('• Kelas (Class Name)'),
            Text('• Mapel (Subject Name)'),
            Text('• Hari (Day)'),
            Text('• Jam (Time)'),
            Text('• Tanggal (Date: DD/MM/YYYY)'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _importFromExcel();
            },
            child: const Text('Select Excel File'),
          ),
        ],
      ),
    );
  }

  void _deleteJadwal(String jadwalId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Teaching Schedule'),
        content: const Text(
          'Are you sure you want to delete this teaching schedule?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _jadwalBloc.add(DeleteJadwalMengajar(jadwalId));
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showJadwalDetail(
    Map<String, dynamic> jadwal,
    JadwalMengajarLoaded state,
  ) {
    // Helper functions to get names from IDs
    String getGuruName(String? guruId) {
      if (guruId == null) return 'Unknown Teacher';
      final guru = state.guruList.firstWhere(
        (g) => g['id'] == guruId,
        orElse: () => {'nama_lengkap': 'Unknown Teacher'},
      );
      return guru['nama_lengkap'] ?? 'Unknown Teacher';
    }

    String getKelasName(String? kelasId) {
      if (kelasId == null) return 'Unknown Class';
      final kelas = state.kelasList.firstWhere(
        (k) => k['id'] == kelasId,
        orElse: () => {'nama_kelas': 'Unknown Class'},
      );
      return kelas['nama_kelas'] ?? 'Unknown Class';
    }

    String getMapelName(String? mapelId) {
      if (mapelId == null) return 'Unknown Subject';
      final mapel = state.mapelList.firstWhere(
        (m) => m['id'] == mapelId,
        orElse: () => {'namaMapel': 'Unknown Subject'},
      );
      return mapel['namaMapel'] ?? 'Unknown Subject';
    }

    String formatDate(dynamic tanggal) {
      if (tanggal is Timestamp) {
        final date = tanggal.toDate();
        return '${date.day}/${date.month}/${date.year}';
      }
      return 'N/A';
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.purple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.schedule, color: Colors.purple),
            ),
            const SizedBox(width: 12),
            const Expanded(child: Text('Teaching Schedule Details')),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow(
                'Teacher',
                getGuruName(jadwal['id_guru']),
                Icons.person,
              ),
              const SizedBox(height: 12),
              _buildDetailRow(
                'Class',
                getKelasName(jadwal['id_kelas']),
                Icons.class_,
              ),
              const SizedBox(height: 12),
              _buildDetailRow(
                'Subject',
                getMapelName(jadwal['id_mapel']),
                Icons.book,
              ),
              const SizedBox(height: 12),
              _buildDetailRow(
                'Day',
                jadwal['hari'] ?? 'N/A',
                Icons.calendar_today,
              ),
              const SizedBox(height: 12),
              _buildDetailRow(
                'Time',
                jadwal['jam'] ?? 'N/A',
                Icons.access_time,
              ),
              const SizedBox(height: 12),
              _buildDetailRow(
                'Date',
                formatDate(jadwal['tanggal']),
                Icons.event,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              _showJadwalForm(jadwal: jadwal, state: state);
            },
            icon: const Icon(Icons.edit, size: 18),
            label: const Text('Edit'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
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
          Icon(icon, size: 20, color: Colors.teal),
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
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  Future<void> _importFromExcel() async {
    try {
      print('🔄 Starting Excel import process...');

      // Pick Excel file - only .xlsx files
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
        allowMultiple: false,
      );
      print(
        '📁 File picker result: ${result?.files.length ?? 0} files selected',
      );

      if (result != null && result.files.single.bytes != null) {
        final bytes = result.files.single.bytes!;
        final excel = excel_lib.Excel.decodeBytes(bytes);

        // Get the first sheet
        String? sheetName = excel.tables.keys.first;
        var table = excel.tables[sheetName];

        if (table != null && table.rows.isNotEmpty) {
          print('📊 Processing Excel file with ${table.rows.length} rows...');
          _showSnackBar('Processing Excel file...');

          int successCount = 0;
          int errorCount = 0;

          // Skip header row (index 0)
          for (int i = 1; i < table.rows.length; i++) {
            var row = table.rows[i];

            // Skip empty rows
            if (row.isEmpty || row.every((cell) => cell?.value == null)) {
              continue;
            }

            try {
              // Expected columns: Guru, Kelas, Mapel, Hari, Jam, Tanggal
              String guruName = row[0]?.value?.toString().trim() ?? '';
              String kelasName = row[1]?.value?.toString().trim() ?? '';
              String mapelName = row[2]?.value?.toString().trim() ?? '';
              String hari = row[3]?.value?.toString().trim() ?? '';
              String jam = row[4]?.value?.toString().trim() ?? '';
              String tanggalStr = row[5]?.value?.toString().trim() ?? '';

              if (guruName.isEmpty ||
                  kelasName.isEmpty ||
                  mapelName.isEmpty ||
                  hari.isEmpty ||
                  jam.isEmpty ||
                  tanggalStr.isEmpty) {
                print(
                  '❌ Row $i: Missing required fields - Guru: "$guruName", Kelas: "$kelasName", Mapel: "$mapelName", Hari: "$hari", Jam: "$jam", Tanggal: "$tanggalStr"',
                );
                errorCount++;
                continue;
              }

              // Find IDs from names
              final guruId = await _findGuruIdByName(guruName);
              final kelasId = await _findKelasIdByName(kelasName);
              final mapelId = await _findMapelIdByName(mapelName);

              if (guruId == null || kelasId == null || mapelId == null) {
                print(
                  '❌ Row $i: ID lookup failed - GuruId: $guruId ("$guruName"), KelasId: $kelasId ("$kelasName"), MapelId: $mapelId ("$mapelName")',
                );
                errorCount++;
                continue;
              }

              // Parse date
              DateTime? tanggal = _parseDate(tanggalStr);
              if (tanggal == null) {
                print('❌ Row $i: Date parsing failed for "$tanggalStr"');
                errorCount++;
                continue;
              }

              // Generate next integer ID and save
              await _saveJadwalWithIntegerId(
                guruId: guruId,
                kelasId: kelasId,
                mapelId: mapelId,
                jam: jam,
                hari: hari,
                tanggal: tanggal,
              );

              print(
                '✅ Row $i: Successfully imported - $guruName, $kelasName, $mapelName, $hari, $jam',
              );
              successCount++;
            } catch (e) {
              errorCount++;
              debugPrint('Error processing row $i: $e');
            }
          }

          // Reload data after import
          _jadwalBloc.add(LoadJadwalMengajar());

          print(
            '🏁 Import completed - Success: $successCount, Errors: $errorCount',
          );
          if (mounted) {
            _showSnackBar(
              'Import completed! Success: $successCount, Errors: $errorCount',
              isError: errorCount > successCount,
            );
          }
        } else {
          print('❌ Excel file is empty or invalid');
          _showSnackBar('Excel file is empty or invalid', isError: true);
        }
      } else {
        print('❌ No file selected');
        _showSnackBar('No file selected', isError: true);
      }
    } catch (e, stackTrace) {
      print('💥 Excel import error: $e');
      print('📍 Stack trace: $stackTrace');
      _showSnackBar('Error importing Excel: $e', isError: true);
    }
  }

  Future<String?> _findGuruIdByName(String name) async {
    try {
      print('🔍 Searching for Guru: "$name"');

      final snapshot = await FirebaseFirestore.instance
          .collection('guru')
          .where('nama_lengkap', isEqualTo: name)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        print('✅ Found Guru: ${snapshot.docs.first.id}');
        return snapshot.docs.first.id;
      }

      print('❌ Guru not found: "$name"');
      return null;
    } catch (e) {
      print('💥 Error searching Guru: $e');
      return null;
    }
  }

  Future<String?> _findKelasIdByName(String name) async {
    try {
      print('🔍 Searching for Kelas: "$name"');

      final snapshot = await FirebaseFirestore.instance
          .collection('kelas')
          .where('nama_kelas', isEqualTo: name)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        print('✅ Found Kelas: ${snapshot.docs.first.id}');
        return snapshot.docs.first.id;
      }

      print('❌ Kelas not found: "$name"');
      return null;
    } catch (e) {
      print('💥 Error searching Kelas: $e');
      return null;
    }
  }

  Future<String?> _findMapelIdByName(String name) async {
    try {
      print('🔍 Searching for Mapel: "$name"');

      final snapshot = await FirebaseFirestore.instance
          .collection('mapel')
          .where('namaMapel', isEqualTo: name)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        print('✅ Found Mapel: ${snapshot.docs.first.id}');
        return snapshot.docs.first.id;
      }

      print('❌ Mapel not found: "$name"');
      return null;
    } catch (e) {
      print('💥 Error searching Mapel: $e');
      return null;
    }
  }

  DateTime? _parseDate(String dateStr) {
    try {
      // Try DD/MM/YYYY format
      final parts = dateStr.split('/');
      if (parts.length == 3) {
        final day = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final year = int.parse(parts[2]);
        return DateTime(year, month, day);
      }
      // Try other formats if needed
      return DateTime.tryParse(dateStr);
    } catch (e) {
      return null;
    }
  }

  Future<void> _saveJadwalWithIntegerId({
    required String guruId,
    required String kelasId,
    required String mapelId,
    required String jam,
    required String hari,
    required DateTime tanggal,
  }) async {
    try {
      // Generate next integer ID
      final querySnapshot = await FirebaseFirestore.instance
          .collection('kelas_ngajar')
          .orderBy('id', descending: true)
          .limit(1)
          .get();

      String nextId = '1';
      if (querySnapshot.docs.isNotEmpty) {
        final lastDoc = querySnapshot.docs.first;
        final lastId = int.tryParse(lastDoc.id) ?? 0;
        nextId = (lastId + 1).toString();
      }

      // Create document with specific integer ID
      await FirebaseFirestore.instance
          .collection('kelas_ngajar')
          .doc(nextId)
          .set({
            'id': int.parse(nextId),
            'id_guru': guruId,
            'id_kelas': kelasId,
            'id_mapel': mapelId,
            'jam': jam,
            'hari': hari,
            'tanggal': Timestamp.fromDate(tanggal),
            'createdAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
          });
    } catch (e) {
      rethrow;
    }
  }
}

// Form Dialog Widget
class JadwalFormDialog extends StatefulWidget {
  final Map<String, dynamic>? jadwal;
  final JadwalMengajarLoaded? state;

  const JadwalFormDialog({super.key, this.jadwal, this.state});

  @override
  State<JadwalFormDialog> createState() => _JadwalFormDialogState();
}

class _JadwalFormDialogState extends State<JadwalFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? _selectedGuruId;
  String? _selectedKelasId;
  String? _selectedMapelId;
  String? _selectedHari;
  final _jamController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  // Method to get day name from DateTime
  String _getDayNameFromDate(DateTime date) {
    final days = [
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
    ];
    return days[date.weekday % 7];
  }

  // Method untuk parse waktu dari format HH:MM-HH:MM
  List<DateTime> _parseTimeRange(String timeRange, DateTime date) {
    try {
      final parts = timeRange.split('-');
      if (parts.length != 2) return [];

      final startParts = parts[0].split(':');
      final endParts = parts[1].split(':');

      if (startParts.length != 2 || endParts.length != 2) return [];

      final startTime = DateTime(
        date.year,
        date.month,
        date.day,
        int.parse(startParts[0]),
        int.parse(startParts[1]),
      );

      final endTime = DateTime(
        date.year,
        date.month,
        date.day,
        int.parse(endParts[0]),
        int.parse(endParts[1]),
      );

      return [startTime, endTime];
    } catch (e) {
      return [];
    }
  }

  // Method untuk cek overlap waktu
  bool _isTimeOverlapping(String time1, String time2, DateTime date) {
    final range1 = _parseTimeRange(time1, date);
    final range2 = _parseTimeRange(time2, date);

    if (range1.length != 2 || range2.length != 2) return false;

    final start1 = range1[0];
    final end1 = range1[1];
    final start2 = range2[0];
    final end2 = range2[1];

    // Check if there's any overlap
    return start1.isBefore(end2) && start2.isBefore(end1);
  }

  // Method untuk validasi bentrok jadwal dari database
  Future<Map<String, dynamic>?> _checkScheduleConflict() async {
    if (_selectedKelasId == null ||
        _jamController.text.isEmpty ||
        _selectedHari == null) {
      return null;
    }

    try {
      // Query database untuk jadwal di kelas, hari, dan tanggal yang sama
      final querySnapshot = await _firestore
          .collection('kelas_ngajar')
          .where('id_kelas', isEqualTo: _selectedKelasId)
          .where('hari', isEqualTo: _selectedHari)
          .get();

      final dateStr =
          '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}';

      for (final doc in querySnapshot.docs) {
        final data = doc.data();

        // Skip current jadwal if editing
        if (widget.jadwal != null) {
          final currentId = widget.jadwal!['id'];
          if (doc.id == currentId ||
              data['id'].toString() == currentId.toString()) {
            continue;
          }
        }

        // Cek apakah tanggal sama
        final jadwalDate = data['tanggal'];
        String jadwalDateStr = '';

        if (jadwalDate is Timestamp) {
          final date = jadwalDate.toDate();
          jadwalDateStr =
              '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
        } else if (jadwalDate is String) {
          jadwalDateStr = jadwalDate;
        }

        if (jadwalDateStr == dateStr) {
          // Cek overlap waktu
          final existingTime = data['jam'] ?? '';
          if (_isTimeOverlapping(
            _jamController.text,
            existingTime,
            _selectedDate,
          )) {
            // Get teacher name
            final teacherDoc = await _firestore
                .collection('guru')
                .doc(data['id_guru'])
                .get();

            final teacherName = teacherDoc.exists
                ? (teacherDoc.data()?['nama'] ?? 'Unknown Teacher')
                : 'Unknown Teacher';

            return {
              'hasConflict': true,
              'teacherName': teacherName,
              'existingTime': existingTime,
              'conflictData': data,
            };
          }
        }
      }

      return {'hasConflict': false};
    } catch (e) {
      debugPrint('Error checking schedule conflict: $e');
      return null;
    }
  }

  final List<String> _hariList = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  // Helper method to convert Indonesian day names to English
  String _convertDayToEnglish(String? day) {
    if (day == null) return 'Monday';
    final Map<String, String> dayMap = {
      'Senin': 'Monday',
      'Selasa': 'Tuesday',
      'Rabu': 'Wednesday',
      'Kamis': 'Thursday',
      'Jumat': 'Friday',
      'Sabtu': 'Saturday',
      'Minggu': 'Sunday',
    };
    return dayMap[day] ?? day; // Return original if already in English
  }

  // Helper method to convert English day names to Indonesian for saving
  String _convertDayToIndonesian(String? day) {
    if (day == null) return 'Senin';
    final Map<String, String> dayMap = {
      'Monday': 'Senin',
      'Tuesday': 'Selasa',
      'Wednesday': 'Rabu',
      'Thursday': 'Kamis',
      'Friday': 'Jumat',
      'Saturday': 'Sabtu',
      'Sunday': 'Minggu',
    };
    return dayMap[day] ?? day; // Return original if already in Indonesian
  }

  @override
  void initState() {
    super.initState();
    if (widget.jadwal != null) {
      _selectedGuruId = widget.jadwal!['id_guru']?.toString();
      _selectedKelasId = widget.jadwal!['id_kelas']?.toString();
      _selectedMapelId = widget.jadwal!['id_mapel']?.toString();
      // Convert Indonesian day name to English for dropdown
      _selectedHari = _convertDayToEnglish(widget.jadwal!['hari']);
      _jamController.text = widget.jadwal!['jam'] ?? '';
    } else {
      // Set initial day based on selected date
      _selectedHari = _getDayNameFromDate(_selectedDate);
    }
  }

  @override
  void dispose() {
    _jamController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.jadwal != null
            ? 'Edit Teaching Schedule'
            : 'Add Teaching Schedule',
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                BlocBuilder<JadwalMengajarBloc, JadwalMengajarState>(
                  builder: (context, state) {
                    if (state is JadwalMengajarLoaded) {
                      return Column(
                        children: [
                          // Dropdown Guru dengan styling seperti classes_screen
                          state.guruList.isEmpty
                              ? Container(
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
                                )
                              : DropdownButtonFormField<String>(
                                  value: _selectedGuruId,
                                  decoration: InputDecoration(
                                    labelText: 'Teacher *',
                                    prefixIcon: const Icon(Icons.person),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  items: state.guruList.map((guru) {
                                    return DropdownMenuItem<String>(
                                      value: guru['id'],
                                      child: Text(
                                        '${guru['nama_lengkap'] ?? 'Unknown'} (NIG: ${guru['nig'] ?? '-'})',
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) =>
                                      setState(() => _selectedGuruId = value),
                                  validator: (value) => value == null
                                      ? 'Please select a teacher'
                                      : null,
                                ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            value: _selectedKelasId,
                            decoration: const InputDecoration(
                              labelText: 'Class',
                              border: OutlineInputBorder(),
                            ),
                            items: state.kelasList.map((kelas) {
                              return DropdownMenuItem<String>(
                                value: kelas['id'],
                                child: Text(kelas['nama_kelas'] ?? 'Unknown'),
                              );
                            }).toList(),
                            onChanged: (value) =>
                                setState(() => _selectedKelasId = value),
                            validator: (value) =>
                                value == null ? 'Please select a class' : null,
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            value: _selectedMapelId,
                            decoration: const InputDecoration(
                              labelText: 'Subject',
                              border: OutlineInputBorder(),
                            ),
                            items: state.mapelList.map((mapel) {
                              return DropdownMenuItem<String>(
                                value: mapel['id'],
                                child: Text(mapel['namaMapel'] ?? 'Unknown'),
                              );
                            }).toList(),
                            onChanged: (value) =>
                                setState(() => _selectedMapelId = value),
                            validator: (value) => value == null
                                ? 'Please select a subject'
                                : null,
                          ),
                          const SizedBox(height: 16),
                        ],
                      );
                    } else {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                  },
                ),
                DropdownButtonFormField<String>(
                  value: _selectedHari,
                  decoration: const InputDecoration(
                    labelText: 'Day',
                    border: OutlineInputBorder(),
                  ),
                  items: _hariList.map((hari) {
                    return DropdownMenuItem<String>(
                      value: hari,
                      child: Text(hari),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => _selectedHari = value),
                  validator: (value) =>
                      value == null ? 'Please select a day' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _jamController,
                  decoration: const InputDecoration(
                    labelText: 'Time (e.g., 08:00-09:30)',
                    border: OutlineInputBorder(),
                    helperText: 'Format: HH:MM-HH:MM',
                  ),
                  onChanged: (value) async {
                    // Real-time validation for schedule conflict
                    if (value.isNotEmpty &&
                        value.contains('-') &&
                        _selectedKelasId != null &&
                        _selectedHari != null) {
                      final conflictResult = await _checkScheduleConflict();
                      if (conflictResult != null &&
                          conflictResult['hasConflict'] == true &&
                          mounted) {
                        final teacherName =
                            conflictResult['teacherName'] ?? 'Unknown Teacher';
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '⚠️ Warning: Class is being taught by $teacherName!',
                            ),
                            backgroundColor: Colors.orange,
                            duration: const Duration(seconds: 3),
                          ),
                        );
                      }
                    }
                  },
                  validator: (value) {
                    if (value?.isEmpty == true) {
                      return 'Please enter time';
                    }
                    // Basic time format validation
                    final timeRegex = RegExp(r'^\d{2}:\d{2}-\d{2}:\d{2}$');
                    if (!timeRegex.hasMatch(value!)) {
                      return 'Format must be HH:MM-HH:MM (e.g., 08:00-09:30)';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: Text(
                    'Date: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                  ),
                  subtitle: const Text(
                    'Day will be automatically set based on selected date',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime.now().subtract(
                        const Duration(days: 365),
                      ),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (date != null) {
                      setState(() {
                        _selectedDate = date;
                        // Auto-select day based on selected date
                        _selectedHari = _getDayNameFromDate(date);
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submitForm,
          child: Text(widget.jadwal != null ? 'Update' : 'Add'),
        ),
      ],
    );
  }

  void _submitForm() async {
    if (_formKey.currentState?.validate() == true) {
      // Double-check that all required fields are not null
      if (_selectedGuruId == null ||
          _selectedKelasId == null ||
          _selectedMapelId == null ||
          _selectedHari == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please fill all required fields'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Check for schedule conflict
      final conflictResult = await _checkScheduleConflict();
      if (conflictResult != null && conflictResult['hasConflict'] == true) {
        final teacherName = conflictResult['teacherName'] ?? 'Unknown Teacher';
        final existingTime = conflictResult['existingTime'] ?? 'Unknown Time';

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'This class is already being taught by $teacherName at $existingTime!\n'
              'Please select a different time.',
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'OK',
              textColor: Colors.white,
              onPressed: () {},
            ),
          ),
        );
        return;
      }

      final bloc = context.read<JadwalMengajarBloc>();

      if (widget.jadwal != null) {
        bloc.add(
          UpdateJadwalMengajar(
            jadwalId: widget.jadwal!['id'],
            idGuru: _selectedGuruId!,
            idKelas: _selectedKelasId!,
            idMapel: _selectedMapelId!,
            jam: _jamController.text,
            // Convert back to Indonesian for database
            hari: _convertDayToIndonesian(_selectedHari),
            tanggal: _selectedDate,
          ),
        );
      } else {
        // Add jadwal with integer ID directly from form dialog
        await _addJadwalDirectly();
      }

      Navigator.pop(context);
    }
  }

  // Method untuk add jadwal langsung dari form dialog
  Future<void> _addJadwalDirectly({
    String? idGuru,
    String? idKelas,
    String? idMapel,
    String? jam,
    String? hari,
    DateTime? tanggal,
  }) async {
    try {
      // Generate next integer ID
      final querySnapshot = await _firestore.collection('kelas_ngajar').get();

      int maxId = 0;
      for (var doc in querySnapshot.docs) {
        final id = int.tryParse(doc.id) ?? 0;
        if (id > maxId) maxId = id;
      }
      String nextId = (maxId + 1).toString();

      // Use parameters if provided (for Excel import), otherwise use form values
      await _firestore.collection('kelas_ngajar').doc(nextId).set({
        'id_guru': idGuru ?? _selectedGuruId!,
        'id_kelas': idKelas ?? _selectedKelasId!,
        'id_mapel': idMapel ?? _selectedMapelId!,
        'jam': jam ?? _jamController.text,
        // Convert back to Indonesian for database
        'hari': hari ?? _convertDayToIndonesian(_selectedHari),
        'tanggal': Timestamp.fromDate(tanggal ?? _selectedDate),
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Only reload and show success for form dialog (when no parameters passed)
      if (idGuru == null) {
        // Reload data in the bloc
        context.read<JadwalMengajarBloc>().add(LoadJadwalMengajar());

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Teaching schedule added successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted && idGuru == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
      rethrow; // Rethrow for Excel import error handling
    }
  }
}
