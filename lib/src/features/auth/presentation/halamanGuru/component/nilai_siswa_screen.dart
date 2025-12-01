import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/config/theme.dart';
import '../../widgets/guru_app_scaffold.dart';

class NilaiSiswaScreen extends ConsumerStatefulWidget {
  const NilaiSiswaScreen({super.key});

  @override
  ConsumerState<NilaiSiswaScreen> createState() => _NilaiSiswaScreenState();
}

class _NilaiSiswaScreenState extends ConsumerState<NilaiSiswaScreen> {
  String _searchQuery = '';
  String _selectedKelas = 'Semua Kelas';

  final List<Map<String, dynamic>> _nilaiList = [
    {
      'id': '1',
      'nama': 'Ahmad Rizki',
      'nis': 'NIS001',
      'kelas': '10 IPA 1',
      'tugas': 85,
      'uts': 78,
      'uas': 88,
      'rataRata': 83.67,
    },
    {
      'id': '2',
      'nama': 'Siti Nurhaliza',
      'nis': 'NIS002',
      'kelas': '10 IPA 1',
      'tugas': 92,
      'uts': 89,
      'uas': 95,
      'rataRata': 92.0,
    },
    {
      'id': '3',
      'nama': 'Budi Santoso',
      'nis': 'NIS003',
      'kelas': '10 IPA 2',
      'tugas': 65,
      'uts': 70,
      'uas': 68,
      'rataRata': 67.67,
    },
    {
      'id': '4',
      'nama': 'Ani Wijaya',
      'nis': 'NIS004',
      'kelas': '11 IPA 1',
      'tugas': 58,
      'uts': 55,
      'uas': 60,
      'rataRata': 57.67,
    },
  ];

  List<Map<String, dynamic>> get filteredList {
    var list = _nilaiList;
    if (_selectedKelas != 'Semua Kelas')
      list = list.where((n) => n['kelas'] == _selectedKelas).toList();
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list
          .where(
            (n) => '${n['nama']} ${n['nis']} ${n['kelas']}'
                .toLowerCase()
                .contains(q),
          )
          .toList();
    }
    return list;
  }

  Color _getGradeColor(double rata) => rata >= 75
      ? AppTheme.accentGreen
      : rata >= 60
      ? AppTheme.accentOrange
      : Colors.red;

  @override
  Widget build(BuildContext context) {
    return GuruAppScaffold(
      title: 'Nilai Siswa',
      icon: Icons.star,
      currentRoute: '/nilai-siswa',
      additionalActions: [
        IconButton(
          icon: const Icon(Icons.download),
          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Download report...'),
              backgroundColor: AppTheme.primaryPurple,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          tooltip: 'Download',
        ),
      ],
      body: Column(
        children: [
          _buildFilterBar(),
          Expanded(child: _buildNilaiList()),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddDialog(context),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Input Nilai', style: TextStyle(color: Colors.white)),
        backgroundColor: AppTheme.primaryPurple,
      ),
    );
  }

  Widget _buildFilterBar() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
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
            onChanged: (v) => setState(() => _searchQuery = v),
            decoration: InputDecoration(
              hintText: 'Cari siswa...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: isDark
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
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _selectedKelas,
            decoration: InputDecoration(
              labelText: 'Filter Kelas',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            items: [
              'Semua Kelas',
              '10 IPA 1',
              '10 IPA 2',
              '11 IPA 1',
            ].map((k) => DropdownMenuItem(value: k, child: Text(k))).toList(),
            onChanged: (v) => setState(() => _selectedKelas = v!),
          ),
        ],
      ),
    );
  }

  Widget _buildNilaiList() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final list = filteredList;
    if (list.isEmpty)
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assessment_outlined, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Data tidak ditemukan',
              style: TextStyle(fontSize: 18, color: Colors.grey[400]),
            ),
          ],
        ),
      );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 900) return _buildTable(list, isDark);
        return _buildCards(list, isDark);
      },
    );
  }

  Widget _buildTable(List<Map<String, dynamic>> list, bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: DataTable(
          headingRowColor: MaterialStateProperty.all(
            isDark ? Colors.grey[850] : Colors.grey[100],
          ),
          columns: const [
            DataColumn(
              label: Text('NIS', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            DataColumn(
              label: Text(
                'Nama',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                'Kelas',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                'Tugas',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text('UTS', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            DataColumn(
              label: Text('UAS', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            DataColumn(
              label: Text(
                'Rata-Rata',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                'Aksi',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
          rows: list
              .map(
                (n) => DataRow(
                  cells: [
                    DataCell(Text(n['nis'])),
                    DataCell(Text(n['nama'])),
                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.secondaryTeal.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          n['kelas'],
                          style: TextStyle(
                            color: AppTheme.secondaryTeal,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    DataCell(Text('${n['tugas']}')),
                    DataCell(Text('${n['uts']}')),
                    DataCell(Text('${n['uas']}')),
                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _getGradeColor(n['rataRata']).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${n['rataRata'].toStringAsFixed(2)}',
                          style: TextStyle(
                            color: _getGradeColor(n['rataRata']),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, size: 20),
                            onPressed: () => _showEditDialog(context, n),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              size: 20,
                              color: Colors.red,
                            ),
                            onPressed: () => _showDeleteDialog(context, n),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget _buildCards(List<Map<String, dynamic>> list, bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: list.length,
      itemBuilder: (c, i) {
        final n = list[i];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          n['nama'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          n['nis'],
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getGradeColor(n['rataRata']).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${n['rataRata'].toStringAsFixed(2)}',
                      style: TextStyle(
                        color: _getGradeColor(n['rataRata']),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.secondaryTeal.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  n['kelas'],
                  style: TextStyle(color: AppTheme.secondaryTeal, fontSize: 12),
                ),
              ),
              const Divider(height: 24),
              Row(
                children: [
                  Expanded(child: _buildGradeItem('Tugas', n['tugas'], isDark)),
                  Expanded(child: _buildGradeItem('UTS', n['uts'], isDark)),
                  Expanded(child: _buildGradeItem('UAS', n['uas'], isDark)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _showEditDialog(context, n),
                      icon: const Icon(Icons.edit, size: 18),
                      label: const Text('Edit'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryPurple,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _showDeleteDialog(context, n),
                      icon: const Icon(
                        Icons.delete,
                        size: 18,
                        color: Colors.red,
                      ),
                      label: const Text(
                        'Hapus',
                        style: TextStyle(color: Colors.red),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGradeItem(String label, int nilai, bool isDark) => Column(
    children: [
      Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      const SizedBox(height: 4),
      Text(
        '$nilai',
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    ],
  );

  void _showAddDialog(BuildContext context) =>
      _showFormDialog(context, 'Input Nilai Baru', null);
  void _showEditDialog(BuildContext context, Map<String, dynamic> n) =>
      _showFormDialog(context, 'Edit Nilai', n);

  void _showFormDialog(
    BuildContext context,
    String title,
    Map<String, dynamic>? n,
  ) {
    final formKey = GlobalKey<FormState>();
    final nama = TextEditingController(text: n?['nama']);
    final nis = TextEditingController(text: n?['nis']);
    String kelas = n?['kelas'] ?? '10 IPA 1';
    final tugas = TextEditingController(text: n?['tugas']?.toString());
    final uts = TextEditingController(text: n?['uts']?.toString());
    final uas = TextEditingController(text: n?['uas']?.toString());

    showDialog(
      context: context,
      builder: (c) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: AppTheme.sunsetGradient,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  n == null ? Icons.add : Icons.edit,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(title),
            ],
          ),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nama,
                    decoration: InputDecoration(
                      labelText: 'Nama Siswa',
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (v) => v?.isEmpty ?? true ? 'Wajib diisi' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: nis,
                    decoration: InputDecoration(
                      labelText: 'NIS',
                      prefixIcon: const Icon(Icons.badge),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (v) => v?.isEmpty ?? true ? 'Wajib diisi' : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: kelas,
                    decoration: InputDecoration(
                      labelText: 'Kelas',
                      prefixIcon: const Icon(Icons.class_),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: ['10 IPA 1', '10 IPA 2', '11 IPA 1']
                        .map((k) => DropdownMenuItem(value: k, child: Text(k)))
                        .toList(),
                    onChanged: (v) => setState(() => kelas = v!),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: tugas,
                    decoration: InputDecoration(
                      labelText: 'Nilai Tugas',
                      prefixIcon: const Icon(Icons.assignment),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      if (v?.isEmpty ?? true) return 'Wajib diisi';
                      final val = int.tryParse(v!);
                      if (val == null || val < 0 || val > 100)
                        return 'Nilai 0-100';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: uts,
                    decoration: InputDecoration(
                      labelText: 'Nilai UTS',
                      prefixIcon: const Icon(Icons.school),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      if (v?.isEmpty ?? true) return 'Wajib diisi';
                      final val = int.tryParse(v!);
                      if (val == null || val < 0 || val > 100)
                        return 'Nilai 0-100';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: uas,
                    decoration: InputDecoration(
                      labelText: 'Nilai UAS',
                      prefixIcon: const Icon(Icons.assessment),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      if (v?.isEmpty ?? true) return 'Wajib diisi';
                      final val = int.tryParse(v!);
                      if (val == null || val < 0 || val > 100)
                        return 'Nilai 0-100';
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final t = int.parse(tugas.text);
                  final u = int.parse(uts.text);
                  final a = int.parse(uas.text);
                  final rata = (t + u + a) / 3;
                  this.setState(() {
                    if (n == null) {
                      _nilaiList.add({
                        'id': DateTime.now().toString(),
                        'nama': nama.text,
                        'nis': nis.text,
                        'kelas': kelas,
                        'tugas': t,
                        'uts': u,
                        'uas': a,
                        'rataRata': rata,
                      });
                    } else {
                      n['nama'] = nama.text;
                      n['nis'] = nis.text;
                      n['kelas'] = kelas;
                      n['tugas'] = t;
                      n['uts'] = u;
                      n['uas'] = a;
                      n['rataRata'] = rata;
                    }
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          const Icon(Icons.check_circle, color: Colors.white),
                          const SizedBox(width: 12),
                          Text(
                            n == null
                                ? 'Nilai ditambahkan'
                                : 'Nilai diperbarui',
                          ),
                        ],
                      ),
                      backgroundColor: AppTheme.accentGreen,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryPurple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, Map<String, dynamic> n) {
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.red, size: 28),
            SizedBox(width: 12),
            Text('Konfirmasi Hapus'),
          ],
        ),
        content: Text('Yakin hapus nilai "${n['nama']}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => _nilaiList.remove(n));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.white),
                      SizedBox(width: 12),
                      Text('Nilai dihapus'),
                    ],
                  ),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}
