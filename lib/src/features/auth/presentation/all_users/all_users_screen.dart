import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/config/theme.dart';
import '../widgets/admin_header.dart';
import '../admin/admin_bloc.dart';

class AllUsersScreen extends StatefulWidget {
  const AllUsersScreen({super.key});

  @override
  State<AllUsersScreen> createState() => _AllUsersScreenState();
}

class _AllUsersScreenState extends State<AllUsersScreen> {
  String _searchQuery = '';
  String _filterRole = 'All';
  
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AdminBloc()..add(LoadAdminData()),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: const AdminHeader(
          title: 'All Users',
          icon: Icons.people,
        ),
        body: Column(
        children: [
          _buildSearchAndFilter(),
          Expanded(child: _buildUsersList()),
        ],
      ),
    ),
    );
  }

  Widget _buildSearchAndFilter() {
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
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth >= 768;
          
          if (isDesktop) {
            return Row(
              children: [
                Expanded(child: _buildSearchField()),
                const SizedBox(width: 16),
                SizedBox(width: 200, child: _buildFilterDropdown()),
              ],
            );
          } else {
            return Column(
              children: [
                _buildSearchField(),
                const SizedBox(height: 12),
                _buildFilterDropdown(),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      onChanged: (value) => setState(() => _searchQuery = value.toLowerCase()),
      decoration: InputDecoration(
        hintText: 'Search by name, email, or ID...',
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Theme.of(context).brightness == Brightness.dark
            ? AppTheme.backgroundDark
            : AppTheme.backgroundLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _buildFilterDropdown() {
    return DropdownButtonFormField<String>(
      value: _filterRole,
      decoration: InputDecoration(
        filled: true,
        fillColor: Theme.of(context).brightness == Brightness.dark
            ? AppTheme.backgroundDark
            : AppTheme.backgroundLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        prefixIcon: const Icon(Icons.filter_list),
      ),
      items: ['All', 'Teachers', 'Students'].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (value) => setState(() => _filterRole = value ?? 'All'),
    );
  }

  Widget _buildUsersList() {
    return StreamBuilder<Map<String, List<Map<String, dynamic>>>>(
      stream: _getAllUsersStream(),
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

        final data = snapshot.data ?? {};
        final teachers = data['teachers'] ?? [];
        final students = data['students'] ?? [];
        
        List<Map<String, dynamic>> allUsers = [];
        
        if (_filterRole == 'All' || _filterRole == 'Teachers') {
          allUsers.addAll(teachers.map((t) => {...t, 'role': 'Teacher'}));
        }
        if (_filterRole == 'All' || _filterRole == 'Students') {
          allUsers.addAll(students.map((s) => {...s, 'role': 'Student'}));
        }

        // Filter by search query
        if (_searchQuery.isNotEmpty) {
          allUsers = allUsers.where((user) {
            final name = (user['nama'] ?? '').toString().toLowerCase();
            final email = (user['email'] ?? '').toString().toLowerCase();
            final id = (user['nig'] ?? user['nis'] ?? '').toString().toLowerCase();
            return name.contains(_searchQuery) || 
                   email.contains(_searchQuery) || 
                   id.contains(_searchQuery);
          }).toList();
        }

        if (allUsers.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person_off, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'No users found',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= 1200;
            final isTablet = constraints.maxWidth >= 768;
            final crossAxisCount = isDesktop ? 3 : isTablet ? 2 : 1;

            return GridView.builder(
              padding: const EdgeInsets.all(20),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: isDesktop ? 1.5 : isTablet ? 1.3 : 1.8,
              ),
              itemCount: allUsers.length,
              itemBuilder: (context, index) => _buildUserCard(allUsers[index]),
            );
          },
        );
      },
    );
  }

  Widget _buildUserCard(Map<String, dynamic> user) {
    final role = user['role'] as String;
    final isTeacher = role == 'Teacher';
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final cardColor = isTeacher ? AppTheme.secondaryTeal : AppTheme.accentGreen;
    final name = user['nama'] ?? 'N/A';
    final email = user['email'] ?? 'N/A';
    final id = isTeacher ? (user['nig'] ?? 'N/A') : (user['nis'] ?? 'N/A');
    final isDisabled = user['isDisabled'] ?? false;

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
          onTap: () => _showUserDetail(user),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: cardColor.withOpacity(0.2),
                      child: Icon(
                        isTeacher ? Icons.school : Icons.person,
                        color: cardColor,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: cardColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: cardColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              role,
                              style: TextStyle(
                                color: cardColor,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildInfoRow(Icons.badge, isTeacher ? 'NIG' : 'NIS', id.toString(), cardColor),
                const SizedBox(height: 8),
                _buildInfoRow(Icons.email_outlined, 'Email', email, cardColor),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.circle, size: 10, color: isDisabled ? Colors.red : Colors.green),
                    const SizedBox(width: 6),
                    Text(
                      isDisabled ? 'Inactive' : 'Active',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDisabled ? Colors.red : Colors.green,
                        fontWeight: FontWeight.w600,
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

  Widget _buildInfoRow(IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color.withOpacity(0.7)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            '$label: $value',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  void _showUserDetail(Map<String, dynamic> user) {
    final role = user['role'] as String;
    final isTeacher = role == 'Teacher';
    final cardColor = isTeacher ? AppTheme.secondaryTeal : AppTheme.accentGreen;

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: cardColor.withOpacity(0.2),
                      child: Icon(
                        isTeacher ? Icons.school : Icons.person,
                        color: cardColor,
                        size: 36,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user['nama'] ?? 'N/A',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: cardColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: cardColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              role,
                              style: TextStyle(
                                color: cardColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
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
                _buildDetailRow('ID', isTeacher ? (user['nig'] ?? 'N/A').toString() : (user['nis'] ?? 'N/A').toString()),
                _buildDetailRow('Email', user['email'] ?? 'N/A'),
                if (isTeacher) ...[
                  _buildDetailRow('Mata Pelajaran', user['mataPelajaran'] ?? 'N/A'),
                  _buildDetailRow('Sekolah', user['sekolah'] ?? 'N/A'),
                ],
                _buildDetailRow('Jenis Kelamin', user['jenisKelamin'] ?? 'N/A'),
                if (!isTeacher)
                  _buildDetailRow('Tanggal Lahir', user['tanggalLahir'] ?? 'N/A'),
                _buildDetailRow('Status', (user['isDisabled'] ?? false) ? 'Inactive' : 'Active'),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                    label: const Text('Close'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cardColor,
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
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Stream<Map<String, List<Map<String, dynamic>>>> _getAllUsersStream() {
    return FirebaseFirestore.instance
        .collection('users')
        .snapshots()
        .map((snapshot) {
      final teachers = <Map<String, dynamic>>[];
      final students = <Map<String, dynamic>>[];

      for (var doc in snapshot.docs) {
        final data = doc.data();
        data['id'] = doc.id;
        
        final userType = data['userType'] ?? '';
        if (userType == 'guru') {
          teachers.add(data);
        } else if (userType == 'siswa') {
          students.add(data);
        }
      }

      return {'teachers': teachers, 'students': students};
    });
  }
}
