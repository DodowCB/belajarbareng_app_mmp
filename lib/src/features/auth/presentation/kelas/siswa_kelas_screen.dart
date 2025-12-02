import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/config/theme.dart';
import '../widgets/admin_header.dart';

class SiswaKelasScreen extends StatefulWidget {
  final String kelasId;
  final String namaKelas;

  const SiswaKelasScreen({
    super.key,
    required this.kelasId,
    required this.namaKelas,
  });

  @override
  State<SiswaKelasScreen> createState() => _SiswaKelasScreenState();
}

class _SiswaKelasScreenState extends State<SiswaKelasScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _searchQuery = '';

  Future<Map<String, dynamic>?> _getSiswaData(String siswaId) async {
    try {
      final siswaDoc = await _firestore.collection('siswa').doc(siswaId).get();
      if (siswaDoc.exists) {
        return siswaDoc.data() as Map<String, dynamic>;
      }
    } catch (e) {
      print('Error getting siswa data: $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AdminHeader(
        title: 'Students - ${widget.namaKelas}',
        icon: Icons.people,
        additionalActions: [
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: IconButton(
              icon: const Icon(Icons.person_add),
              onPressed: _showAddSiswaDialog,
              tooltip: 'Add Student',
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(child: _buildStudentsList()),
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
          hintText: 'Search students by name or NIS...',
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

  Widget _buildStudentsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('siswa_kelas')
          .where('kelas_id', isEqualTo: widget.kelasId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text('Error: ${snapshot.error}'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => setState(() {}),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accentGreen,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data?.docs ?? [];

        if (docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.people_outline, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                const Text(
                  'No students in this class yet',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                Text(
                  'Add students using the + button above',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _showAddSiswaDialog,
                  icon: const Icon(Icons.person_add),
                  label: const Text('Add Student'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accentGreen,
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
                childAspectRatio: 1.5,
              ),
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final data = docs[index].data() as Map<String, dynamic>;
                final docId = docs[index].id;
                final siswaId = data['siswa_id'] ?? '';

                return FutureBuilder<Map<String, dynamic>?>(
                  future: _getSiswaData(siswaId),
                  builder: (context, siswaSnapshot) {
                    if (siswaSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    }

                    final siswaData = siswaSnapshot.data;
                    final namaSiswa = siswaData?['nama'] ?? 'Unknown';
                    final nis = siswaData?['nis'] ?? '-';
                    final email = siswaData?['email'] ?? '-';

                    // Filter by search
                    if (_searchQuery.isNotEmpty) {
                      if (!namaSiswa.toLowerCase().contains(_searchQuery) &&
                          !nis.toLowerCase().contains(_searchQuery)) {
                        return const SizedBox.shrink();
                      }
                    }

                    return _buildStudentCard(
                      namaSiswa,
                      nis,
                      email,
                      siswaId,
                      docId,
                      index,
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildStudentCard(
    String namaSiswa,
    String nis,
    String email,
    String siswaId,
    String docId,
    int index,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
          onTap: () => _showStudentDetail(namaSiswa, nis, email, siswaId),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: AppTheme.accentGreen.withOpacity(0.2),
                      child: Text(
                        namaSiswa.isNotEmpty ? namaSiswa[0].toUpperCase() : 'S',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.accentGreen,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            namaSiswa,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.accentGreen,
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'NIS: $nis',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuButton(
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'view',
                          child: Row(
                            children: [
                              Icon(
                                Icons.visibility,
                                color: Colors.blue,
                                size: 16,
                              ),
                              SizedBox(width: 8),
                              Text('View Detail'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'remove',
                          child: Row(
                            children: [
                              Icon(
                                Icons.remove_circle,
                                color: Colors.red,
                                size: 16,
                              ),
                              SizedBox(width: 8),
                              Text('Remove from Class'),
                            ],
                          ),
                        ),
                      ],
                      onSelected: (value) =>
                          _handleMenuAction(value, namaSiswa, docId),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildInfoRow(Icons.email, email),
                const SizedBox(height: 4),
                _buildInfoRow(Icons.badge, 'ID: $siswaId'),
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
        Icon(icon, size: 14, color: Colors.grey[600]),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  void _showStudentDetail(
    String nama,
    String nis,
    String email,
    String siswaId,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppTheme.accentGreen.withOpacity(0.2),
              child: const Icon(Icons.person, color: AppTheme.accentGreen),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Student Details',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.accentGreen,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow(Icons.person, 'Name', nama),
            const Divider(),
            _buildDetailRow(Icons.badge, 'NIS', nis),
            const Divider(),
            _buildDetailRow(Icons.email, 'Email', email),
            const Divider(),
            _buildDetailRow(Icons.key, 'Student ID', siswaId),
            const Divider(),
            _buildDetailRow(Icons.class_, 'Class', widget.namaKelas),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppTheme.accentGreen),
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
                Text(value, style: const TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleMenuAction(dynamic value, String namaSiswa, String docId) async {
    if (value == 'view') {
      // Will show detail via card click
      return;
    } else if (value == 'remove') {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Confirm Removal'),
          content: Text('Remove "$namaSiswa" from ${widget.namaKelas}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Remove'),
            ),
          ],
        ),
      );

      if (confirm == true) {
        try {
          await _firestore.collection('siswa_kelas').doc(docId).delete();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Student removed from class successfully'),
                backgroundColor: Colors.green,
              ),
            );
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${e.toString()}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      }
    }
  }

  void _showAddSiswaDialog() {
    showDialog(
      context: context,
      builder: (context) =>
          AddSiswaDialog(kelasId: widget.kelasId, namaKelas: widget.namaKelas),
    );
  }
}

class AddSiswaDialog extends StatefulWidget {
  final String kelasId;
  final String namaKelas;

  const AddSiswaDialog({
    super.key,
    required this.kelasId,
    required this.namaKelas,
  });

  @override
  State<AddSiswaDialog> createState() => _AddSiswaDialogState();
}

class _AddSiswaDialogState extends State<AddSiswaDialog> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _availableSiswa = [];
  String? _selectedSiswaId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAvailableSiswa();
  }

  Future<void> _loadAvailableSiswa() async {
    try {
      // Get all siswa from siswa collection
      final siswaSnapshot = await _firestore.collection('siswa').get();

      // Get siswa already in this kelas
      final siswaKelasSnapshot = await _firestore
          .collection('siswa_kelas')
          .where('kelas_id', isEqualTo: widget.kelasId)
          .get();

      final siswaInKelas = siswaKelasSnapshot.docs
          .map((doc) => doc.data()['siswa_id'] as String)
          .toSet();

      // Filter out siswa already in this kelas
      final availableSiswa = siswaSnapshot.docs
          .where((doc) => !siswaInKelas.contains(doc.id))
          .map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return {
              'id': doc.id,
              'nama': data['nama'] ?? 'Nama tidak tersedia',
              'nis': data['nis'] ?? '',
            };
          })
          .toList();

      setState(() {
        _availableSiswa = availableSiswa;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading siswa: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.accentGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.person_add, color: AppTheme.accentGreen),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Add Student to ${widget.namaKelas}',
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
      content: _isLoading
          ? const SizedBox(
              height: 100,
              child: Center(child: CircularProgressIndicator()),
            )
          : _availableSiswa.isEmpty
          ? const Text('No available students to add')
          : SizedBox(
              width: 400,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    value: _selectedSiswaId,
                    decoration: InputDecoration(
                      labelText: 'Select Student',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.person),
                    ),
                    items: _availableSiswa.map((siswa) {
                      return DropdownMenuItem<String>(
                        value: siswa['id'],
                        child: Text('${siswa['nama']} (${siswa['nis']})'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedSiswaId = value;
                      });
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
          onPressed: _selectedSiswaId == null ? null : _addSiswaToKelas,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.accentGreen,
            foregroundColor: Colors.white,
            disabledBackgroundColor: Colors.grey,
          ),
          child: const Text('Add'),
        ),
      ],
    );
  }

  Future<void> _addSiswaToKelas() async {
    if (_selectedSiswaId == null) return;

    try {
      // Generate next integer ID by getting all docs and finding max ID
      final querySnapshot = await _firestore.collection('siswa_kelas').get();

      int maxId = 0;
      for (var doc in querySnapshot.docs) {
        final id = int.tryParse(doc.id) ?? 0;
        if (id > maxId) {
          maxId = id;
        }
      }

      String nextId = (maxId + 1).toString();

      // Add to siswa_kelas collection with integer ID
      await _firestore.collection('siswa_kelas').doc(nextId).set({
        'kelas_id': widget.kelasId,
        'siswa_id': _selectedSiswaId!,
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Student added to class successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
