import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'user_info_bloc.dart';

/// Widget untuk menampilkan info user yang sedang login dengan BLoC pattern
class UserInfoWidget extends StatelessWidget {
  const UserInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserInfoBloc()..add(LoadUserInfo()),
      child: BlocConsumer<UserInfoBloc, UserInfoState>(
        listener: (context, state) {
          if (state is LogoutSuccess) {
            Navigator.of(context).pushReplacementNamed('/login');
          } else if (state is UserInfoError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is UserInfoLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is UserInfoLoaded) {
            if (!state.isLoggedIn) {
              return const Text('Belum login');
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Greeting message
                Text(
                  state.greetingMessage ?? 'Hello User',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                // Email
                Text('Email: ${state.email ?? '-'}'),

                // Role
                Text('Role: ${state.roleDisplayName ?? '-'}'),

                // Conditional info berdasarkan tipe user
                if (state.isGuru) ...[
                  Text('NIG: ${state.nig ?? '-'}'),
                  Text('Mata Pelajaran: ${state.mataPelajaran ?? '-'}'),
                ],

                if (state.isSiswa) ...[
                  Text('NIS: ${state.nis ?? '-'}'),
                  Text('Kelas: ${state.kelas ?? '-'}'),
                ],

                Text('Sekolah: ${state.sekolah ?? '-'}'),

                const SizedBox(height: 16),

                // Logout button
                ElevatedButton(
                  onPressed: () {
                    context.read<UserInfoBloc>().add(LogoutUser());
                  },
                  child: const Text('Logout'),
                ),
              ],
            );
          }

          return const Text('Error loading user info');
        },
      ),
    );
  }
}

/// Example penggunaan dalam widget lain dengan BLoC pattern
class ExampleUsage extends StatelessWidget {
  const ExampleUsage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard User'),
        actions: [
          // Tampilkan nama user di AppBar
          BlocBuilder<UserInfoBloc, UserInfoState>(
            builder: (context, state) {
              if (state is UserInfoLoaded) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Text(state.displayName ?? 'User'),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Conditional content berdasarkan role
            BlocBuilder<UserInfoBloc, UserInfoState>(
              builder: (context, state) {
                if (state is UserInfoLoaded) {
                  if (state.isGuru) {
                    return const GuruDashboard();
                  } else if (state.isSiswa) {
                    return const SiswaDashboard();
                  }
                }
                return const Text('Role tidak dikenali');
              },
            ),

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
    return BlocBuilder<UserInfoBloc, UserInfoState>(
      builder: (context, state) {
        if (state is UserInfoLoaded) {
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
                  Text('Mata Pelajaran: ${state.mataPelajaran ?? '-'}'),
                  Text('NIG: ${state.nig ?? '-'}'),
                  // Add guru specific content here
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class SiswaDashboard extends StatelessWidget {
  const SiswaDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserInfoBloc, UserInfoState>(
      builder: (context, state) {
        if (state is UserInfoLoaded) {
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
                  Text('Kelas: ${state.kelas ?? '-'}'),
                  Text('NIS: ${state.nis ?? '-'}'),
                  // Add siswa specific content here
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
