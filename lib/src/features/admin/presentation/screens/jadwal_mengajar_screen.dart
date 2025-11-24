import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/config/theme.dart';
import '../../../auth/presentation/widgets/admin_header.dart';

class JadwalMengajarScreen extends StatefulWidget {
  const JadwalMengajarScreen({super.key});

  @override
  State<JadwalMengajarScreen> createState() => _JadwalMengajarScreenState();
}

class _JadwalMengajarScreenState extends State<JadwalMengajarScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AdminHeader(
        title: 'Jadwal Mengajar Management',
        icon: Icons.schedule,
        additionalActions: [
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: () => _showJadwalForm(),
              tooltip: 'Add Teaching Schedule',
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(child: _buildJadwalList()),
        ],
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
          hintText: 'Search by teacher name, class, or subject...',
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

  Widget _buildJadwalList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('kelas_ngajar').snapshots(),
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

        final jadwalDocs = snapshot.data?.docs ?? [];

        if (jadwalDocs.isEmpty) {
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
                  onPressed: () => _showJadwalForm(),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Teaching Schedule'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.secondaryTeal,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: jadwalDocs.length,
          itemBuilder: (context, index) {
            final jadwal = jadwalDocs[index].data() as Map<String, dynamic>;
            final jadwalId = jadwalDocs[index].id;

            return _buildJadwalCard(jadwal, jadwalId);
          },
        );
      },
    );
  }

  Widget _buildJadwalCard(Map<String, dynamic> jadwal, String jadwalId) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _showJadwalDetails(jadwal, jadwalId),
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
                      color: AppTheme.primaryPurple.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.schedule, color: AppTheme.primaryPurple),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FutureBuilder<String>(
                          future: _getTeacherName(jadwal['id_guru']),
                          builder: (context, snapshot) {
                            return Text(
                              snapshot.data ?? 'Loading...',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            );
                          },
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            FutureBuilder<String>(
                              future: _getClassName(jadwal['id_kelas']),
                              builder: (context, snapshot) {
                                return Text(
                                  'Class: ${snapshot.data ?? 'Loading...'}',
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(color: Colors.grey[600]),
                                );
                              },
                            ),
                            const SizedBox(width: 16),
                            FutureBuilder<String>(
                              future: _getSubjectName(jadwal['id_mapel']),
                              builder: (context, snapshot) {
                                return Text(
                                  'Subject: ${snapshot.data ?? 'Loading...'}',
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(color: Colors.grey[600]),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') {
                        _showJadwalForm(jadwal: jadwal, jadwalId: jadwalId);
                      } else if (value == 'delete') {
                        _deleteJadwal(jadwalId);
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
                  color: AppTheme.secondaryTeal.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: AppTheme.secondaryTeal,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Schedule: ${jadwal['jam'] ?? 'Not set'}',
                      style: TextStyle(
                        color: AppTheme.secondaryTeal,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> _getTeacherName(String? guruId) async {
    if (guruId == null) return 'Unknown Teacher';
    try {
      final doc = await _firestore.collection('guru').doc(guruId).get();
      if (doc.exists) {
        return doc.data()?['nama'] ?? 'Unknown Teacher';
      }
    } catch (e) {
      debugPrint('Error getting teacher name: $e');
    }
    return 'Unknown Teacher';
  }

  Future<String> _getClassName(String? kelasId) async {
    if (kelasId == null) return 'Unknown Class';
    try {
      final doc = await _firestore.collection('kelas').doc(kelasId).get();
      if (doc.exists) {
        return doc.data()?['nama'] ?? 'Unknown Class';
      }
    } catch (e) {
      debugPrint('Error getting class name: $e');
    }
    return 'Unknown Class';
  }

  Future<String> _getSubjectName(String? mapelId) async {
    if (mapelId == null) return 'Unknown Subject';
    try {
      final doc = await _firestore.collection('mapel').doc(mapelId).get();
      if (doc.exists) {
        return doc.data()?['nama'] ?? 'Unknown Subject';
      }
    } catch (e) {
      debugPrint('Error getting subject name: $e');
    }
    return 'Unknown Subject';
  }

  void _showJadwalDetails(Map<String, dynamic> jadwal, String jadwalId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Teaching Schedule Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<String>(
              future: _getTeacherName(jadwal['id_guru']),
              builder: (context, snapshot) {
                return _buildDetailRow(
                  'Teacher',
                  snapshot.data ?? 'Loading...',
                );
              },
            ),
            FutureBuilder<String>(
              future: _getClassName(jadwal['id_kelas']),
              builder: (context, snapshot) {
                return _buildDetailRow('Class', snapshot.data ?? 'Loading...');
              },
            ),
            FutureBuilder<String>(
              future: _getSubjectName(jadwal['id_mapel']),
              builder: (context, snapshot) {
                return _buildDetailRow(
                  'Subject',
                  snapshot.data ?? 'Loading...',
                );
              },
            ),
            _buildDetailRow('Schedule', jadwal['jam'] ?? 'Not set'),
            _buildDetailRow(
              'Created',
              jadwal['createdAt'] != null
                  ? DateTime.fromMillisecondsSinceEpoch(
                      jadwal['createdAt'],
                    ).toString()
                  : 'Unknown',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showJadwalForm(jadwal: jadwal, jadwalId: jadwalId);
            },
            child: const Text('Edit'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _showJadwalForm({Map<String, dynamic>? jadwal, String? jadwalId}) {
    // TODO: Implement form dialog for creating/editing teaching schedules
    // This would include dropdowns for selecting teacher, class, and subject
    // Plus time picker for schedule
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Form dialog will be implemented next...'),
        backgroundColor: Colors.orange,
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
            onPressed: () async {
              try {
                await _firestore
                    .collection('kelas_ngajar')
                    .doc(jadwalId)
                    .delete();
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Teaching schedule deleted successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error deleting schedule: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
