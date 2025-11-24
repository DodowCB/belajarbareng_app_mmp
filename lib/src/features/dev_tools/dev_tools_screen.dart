import 'package:flutter/material.dart';
import '../../core/utils/data_seeder.dart';

class DevToolsScreen extends StatelessWidget {
  const DevToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Development Tools'),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Database Seeding Tools',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Use these tools to populate the database with sample data for testing.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 30),
            _buildSeedButton(
              context,
              'Seed Announcements',
              'Add sample announcements to the database',
              Icons.campaign,
              Colors.blue,
              () async {
                await DataSeeder.seedAnnouncements();
                _showSuccessSnackBar(
                  context,
                  'Announcements seeded successfully!',
                );
              },
            ),
            const SizedBox(height: 15),
            _buildSeedButton(
              context,
              'Seed Tugas',
              'Add sample assignments to the database',
              Icons.assignment,
              Colors.orange,
              () async {
                await DataSeeder.seedTugas();
                _showSuccessSnackBar(context, 'Tugas seeded successfully!');
              },
            ),
            const SizedBox(height: 15),
            _buildSeedButton(
              context,
              'Seed Kelas',
              'Add sample classes to the database',
              Icons.class_,
              Colors.green,
              () async {
                await DataSeeder.seedKelas();
                _showSuccessSnackBar(context, 'Kelas seeded successfully!');
              },
            ),
            const SizedBox(height: 15),
            _buildSeedButton(
              context,
              'Seed Siswa-Kelas Relations',
              'Add student-class relationships',
              Icons.people,
              Colors.purple,
              () async {
                await DataSeeder.seedSiswaKelas();
                _showSuccessSnackBar(
                  context,
                  'Siswa-Kelas relations seeded successfully!',
                );
              },
            ),
            const SizedBox(height: 30),
            _buildSeedButton(
              context,
              'Seed All Data',
              'Populate all sample data at once',
              Icons.auto_fix_high,
              Colors.red,
              () async {
                _showProgressDialog(context);
                await DataSeeder.seedAll();
                Navigator.of(context).pop(); // Close progress dialog
                _showSuccessSnackBar(context, 'All data seeded successfully!');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeedButton(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () async {
          final confirm = await _showConfirmDialog(context, title);
          if (confirm) {
            onPressed();
          }
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 16),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _showConfirmDialog(BuildContext context, String action) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Confirm $action'),
            content: Text('Are you sure you want to $action?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Confirm'),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _showProgressDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 20),
            Text('Seeding data...'),
          ],
        ),
      ),
    );
  }

  void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
