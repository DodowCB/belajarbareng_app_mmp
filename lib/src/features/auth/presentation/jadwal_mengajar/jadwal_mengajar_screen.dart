import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  @override
  void initState() {
    super.initState();
    _jadwalBloc = JadwalMengajarBloc();
    _jadwalBloc.add(LoadJadwalMengajar());
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
                onPressed: () => _showJadwalForm(
                  state: state is JadwalMengajarLoaded ? state : null,
                ),
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
              hintText: 'Search by time, day, or other details...',
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
                    onPressed: () => _showJadwalForm(
                      state: state is JadwalMengajarLoaded ? state : null,
                    ),
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
                  onPressed: () => _showImportDialog(),
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
        orElse: () => {'nama': 'Unknown Teacher'},
      );
      return guru['nama'] ?? 'Unknown Teacher';
    }

    String getKelasName(String? kelasId) {
      if (kelasId == null) return 'Unknown Class';
      final kelas = state.kelasList.firstWhere(
        (k) => k['id'] == kelasId,
        orElse: () => {'nama': 'Unknown Class'},
      );
      return kelas['nama'] ?? 'Unknown Class';
    }

    String getMapelName(String? mapelId) {
      if (mapelId == null) return 'Unknown Subject';
      final mapel = state.mapelList.firstWhere(
        (m) => m['id'] == mapelId,
        orElse: () => {'nama': 'Unknown Subject'},
      );
      return mapel['nama'] ?? 'Unknown Subject';
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${getKelasName(jadwal['id_kelas'])} - ${getMapelName(jadwal['id_mapel'])}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      _showJadwalForm(jadwal: jadwal, state: state);
                    } else if (value == 'delete') {
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
                          Text('Delete', style: TextStyle(color: Colors.red)),
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
                  Text(
                    '${jadwal['hari'] ?? 'No day'} - ${jadwal['jam'] ?? 'No time'}',
                    style: TextStyle(
                      color: Colors.teal,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
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
            Text('Import teaching schedules from Excel file (.xlsx or .xls)'),
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
            Text('• Tanggal (Date: YYYY-MM-DD)'),
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
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Excel import feature will be implemented soon',
                  ),
                  backgroundColor: Colors.orange,
                ),
              );
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

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
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
  String? _selectedGuruId;
  String? _selectedKelasId;
  String? _selectedMapelId;
  String? _selectedHari;
  final _jamController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  final List<String> _hariList = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
    'Minggu',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.jadwal != null) {
      _selectedGuruId = widget.jadwal!['id_guru'];
      _selectedKelasId = widget.jadwal!['id_kelas'];
      _selectedMapelId = widget.jadwal!['id_mapel'];
      _selectedHari = widget.jadwal!['hari'];
      _jamController.text = widget.jadwal!['jam'] ?? '';
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
                          DropdownButtonFormField<String>(
                            value: _selectedGuruId,
                            decoration: const InputDecoration(
                              labelText: 'Teacher',
                              border: OutlineInputBorder(),
                            ),
                            items: state.guruList.map((guru) {
                              print(guru);
                              return DropdownMenuItem<String>(
                                value: guru['id'],
                                child: Text(guru['nama_lengkap'] ?? 'Unknown'),
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
                                child: Text(kelas['namaKelas'] ?? 'Unknown'),
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
                  ),
                  validator: (value) =>
                      value?.isEmpty == true ? 'Please enter time' : null,
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: Text(
                    'Date: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
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
                      setState(() => _selectedDate = date);
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

  void _submitForm() {
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

      final bloc = context.read<JadwalMengajarBloc>();

      if (widget.jadwal != null) {
        bloc.add(
          UpdateJadwalMengajar(
            jadwalId: widget.jadwal!['id'],
            idGuru: _selectedGuruId!,
            idKelas: _selectedKelasId!,
            idMapel: _selectedMapelId!,
            jam: _jamController.text,
            hari: _selectedHari!,
            tanggal: _selectedDate,
          ),
        );
      } else {
        bloc.add(
          AddJadwalMengajar(
            idGuru: _selectedGuruId!,
            idKelas: _selectedKelasId!,
            idMapel: _selectedMapelId!,
            jam: _jamController.text,
            hari: _selectedHari!,
            tanggal: _selectedDate,
          ),
        );
      }

      Navigator.pop(context);
    }
  }
}
