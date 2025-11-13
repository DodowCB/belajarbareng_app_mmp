import 'package:flutter/material.dart';
import '../../core/utils/app_user.dart';

/// Contoh widget untuk menampilkan info user yang sedang login
class UserInfoWidget extends StatelessWidget {
  const UserInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Cek apakah user sudah login
    if (!AppUser.isLoggedIn) {
      return const Text('Belum login');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Greeting message
        Text(
          AppUser.greetingMessage,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),

        // Email
        Text('Email: ${AppUser.email ?? '-'}'),

        // Role
        Text('Role: ${AppUser.roleDisplayName}'),

        // Conditional info berdasarkan tipe user
        if (AppUser.isGuru) ...[
          Text('NIG: ${AppUser.nig ?? '-'}'),
          Text('Mata Pelajaran: ${AppUser.mataPelajaran ?? '-'}'),
        ],

        if (AppUser.isSiswa) ...[
          Text('NIS: ${AppUser.nis ?? '-'}'),
          Text('Kelas: ${AppUser.kelas ?? '-'}'),
        ],

        Text('Sekolah: ${AppUser.sekolah ?? '-'}'),

        const SizedBox(height: 16),

        // Logout button
        ElevatedButton(
          onPressed: () {
            AppUser.logout();
            // Navigate to login screen
            Navigator.of(context).pushReplacementNamed('/login');
          },
          child: const Text('Logout'),
        ),
      ],
    );
  }
}

/// Example penggunaan dalam widget lain
class ExampleUsage extends StatelessWidget {
  const ExampleUsage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard ${AppUser.roleDisplayName}'),
        actions: [
          // Tampilkan nama user di AppBar
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(AppUser.displayName),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Conditional content berdasarkan role
            if (AppUser.isGuru)
              const GuruDashboard()
            else if (AppUser.isSiswa)
              const SiswaDashboard()
            else
              const Text('Role tidak dikenali'),

            const SizedBox(height: 20),

            // User info widget
            const UserInfoWidget(),
          ],
        ),
      ),
    );
  }
}

class GuruDashboard extends StatelessWidget {
  const GuruDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Dashboard Guru',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text('Mata Pelajaran: ${AppUser.mataPelajaran ?? '-'}'),
            Text('NIG: ${AppUser.nig ?? '-'}'),
            // Add guru specific content here
          ],
        ),
      ),
    );
  }
}

class SiswaDashboard extends StatelessWidget {
  const SiswaDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Dashboard Siswa',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text('Kelas: ${AppUser.kelas ?? '-'}'),
            Text('NIS: ${AppUser.nis ?? '-'}'),
            // Add siswa specific content here
          ],
        ),
      ),
    );
  }
}
