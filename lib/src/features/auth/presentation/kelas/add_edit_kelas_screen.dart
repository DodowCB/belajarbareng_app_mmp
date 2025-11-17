import 'package:flutter/material.dart';

class AddEditKelasScreen extends StatefulWidget {
  final dynamic kelasBloc;
  final dynamic kelas;

  const AddEditKelasScreen({super.key, required this.kelasBloc, this.kelas});

  @override
  State<AddEditKelasScreen> createState() => _AddEditKelasScreenState();
}

class _AddEditKelasScreenState extends State<AddEditKelasScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Kelas'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: const Center(child: Text('Form kelas akan segera tersedia')),
    );
  }
}
