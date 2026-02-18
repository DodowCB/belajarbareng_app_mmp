import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/config/theme.dart';

class AllUsersDialog extends StatefulWidget {
  const AllUsersDialog({super.key});

  @override
  State<AllUsersDialog> createState() => _AllUsersDialogState();
}

class _AllUsersDialogState extends State<AllUsersDialog> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppTheme.sunsetGradient,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.people,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'All Users',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.white),
                    tooltip: 'Close',
                  ),
                ],
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search user by name...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                              _searchQuery = '';
                            });
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.toLowerCase();
                  });
                },
              ),
            ),

            // Content
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('guru').snapshots(),
                builder: (context, guruSnapshot) {
                  if (guruSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('siswa')
                        .snapshots(),
                    builder: (context, siswaSnapshot) {
                      if (siswaSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (guruSnapshot.hasError || siswaSnapshot.hasError) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.error_outline,
                                size: 64,
                                color: Colors.red,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Error loading users',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      // Combine all users
                      final List<Map<String, String>> allUsers = [];
                      int teacherCount = 0;
                      int studentCount = 0;

                      // Add teachers (excluding admin@gmail.com)
                      if (guruSnapshot.hasData) {
                        for (var doc in guruSnapshot.data!.docs) {
                          final data = doc.data() as Map<String, dynamic>;
                          final email =
                              data['email']?.toString().toLowerCase() ?? '';
                          // Skip admin user
                          if (email == 'admin@gmail.com') continue;

                          final name = data['nama_lengkap'] ?? 'Unknown';
                          
                          if (_searchQuery.isEmpty || 
                              name.toLowerCase().contains(_searchQuery)) {
                            allUsers.add({'name': name, 'role': 'Teacher'});
                            teacherCount++;
                          }
                        }
                      }

                      // Add students
                      if (siswaSnapshot.hasData) {
                        for (var doc in siswaSnapshot.data!.docs) {
                          final data = doc.data() as Map<String, dynamic>;
                          final name = data['nama'] ?? 'Unknown';
                          
                          if (_searchQuery.isEmpty || 
                              name.toLowerCase().contains(_searchQuery)) {
                            allUsers.add({'name': name, 'role': 'Student'});
                            studentCount++;
                          }
                        }
                      }

                      // Sort by name
                      allUsers
                          .sort((a, b) => a['name']!.compareTo(b['name']!));

                      if (allUsers.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No users found',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return Column(
                        children: [
                          // Summary
                          if (_searchQuery.isEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16, 
                              vertical: 12,
                            ),
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.grey[800]
                                  : Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Flexible(
                                  child: _buildUserSummaryItem(
                                    'Total',
                                    allUsers.length.toString(),
                                    AppTheme.primaryPurple,
                                  ),
                                ),
                                Container(
                                  width: 1, 
                                  height: 30, 
                                  color: Colors.grey[400],
                                ),
                                Flexible(
                                  child: _buildUserSummaryItem(
                                    'Teachers',
                                    teacherCount.toString(),
                                    AppTheme.secondaryTeal,
                                  ),
                                ),
                                Container(
                                  width: 1,
                                  height: 30,
                                  color: Colors.grey[400],
                                ),
                                Flexible(
                                  child: _buildUserSummaryItem(
                                    'Students',
                                    studentCount.toString(),
                                    AppTheme.accentGreen,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 8),

                          // List
                          Expanded(
                            child: ListView.separated(
                              padding: const EdgeInsets.all(16),
                              itemCount: allUsers.length,
                              separatorBuilder: (context, index) =>
                                  const Divider(height: 1),
                              itemBuilder: (context, index) {
                                final user = allUsers[index];
                                final isTeacher = user['role'] == 'Teacher';
                                final color = isTeacher
                                    ? AppTheme.secondaryTeal
                                    : AppTheme.accentGreen;

                                return ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: color.withOpacity(0.1),
                                    child: Icon(
                                      isTeacher ? Icons.school : Icons.person,
                                      color: color,
                                      size: 20,
                                    ),
                                  ),
                                  title: Text(
                                    user['name']!,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    user['role']!,
                                    style: TextStyle(
                                      color: color,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserSummaryItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
