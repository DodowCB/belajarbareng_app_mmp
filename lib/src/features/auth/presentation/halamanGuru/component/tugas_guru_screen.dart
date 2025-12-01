import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../../core/config/theme.dart';
import '../../widgets/guru_app_scaffold.dart';

class TugasGuruScreen extends ConsumerStatefulWidget {
  const TugasGuruScreen({super.key});

  @override
  ConsumerState<TugasGuruScreen> createState() => _TugasGuruScreenState();
}

class _TugasGuruScreenState extends ConsumerState<TugasGuruScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';

  final List<Map<String, dynamic>> _tugasList = [
    {
      'id': '1',
      'judul': 'Latihan Trigonometri',
      'deskripsi': 'Kerjakan soal halaman 45-50 buku paket',
      'kelas': '10 IPA 1',
      'deadline': DateTime.now().add(const Duration(days: 3)),
      'status': 'Aktif',
      'jumlahSiswa': 32,
      'sudahMengumpulkan': 20,
    },
    {
      'id': '2',
      'judul': 'Quiz Integral',
      'deskripsi': 'Quiz online melalui platform',
      'kelas': '11 IPA 1',
      'deadline': DateTime.now().add(const Duration(days: 1)),
      'status': 'Aktif',
      'jumlahSiswa': 28,
      'sudahMengumpulkan': 15,
    },
    {
      'id': '3',
      'judul': 'PR Limit Fungsi',
      'deskripsi': 'Kerjakan soal pilihan ganda dan essay',
      'kelas': '10 IPA 2',
      'deadline': DateTime.now().subtract(const Duration(days: 2)),
      'status': 'Selesai',
      'jumlahSiswa': 30,
      'sudahMengumpulkan': 28,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _getFilteredList(String status) {
    var list = status == 'Semua'
        ? _tugasList
        : _tugasList.where((t) => t['status'] == status).toList();
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list
          .where(
            (t) => '${t['judul']} ${t['deskripsi']} ${t['kelas']}'
                .toLowerCase()
                .contains(q),
          )
          .toList();
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return GuruAppScaffold(
      title: 'Manajemen Tugas',
      icon: Icons.assignment,
      currentRoute: '/tugas',
      body: Column(
        children: [
          _buildSearchAndTabs(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTugasTab(_getFilteredList('Semua')),
                _buildTugasTab(_getFilteredList('Aktif')),
                _buildTugasTab(_getFilteredList('Selesai')),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddDialog(context),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Buat Tugas', style: TextStyle(color: Colors.white)),
        backgroundColor: AppTheme.primaryPurple,
      ),
    );
  }

  Widget _buildSearchAndTabs() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
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
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: TextField(
              onChanged: (v) => setState(() => _searchQuery = v),
              decoration: InputDecoration(
                hintText: 'Cari tugas...',
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
          ),
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Semua'),
              Tab(text: 'Aktif'),
              Tab(text: 'Selesai'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTugasTab(List<Map<String, dynamic>> list) {
    if (list.isEmpty)
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assignment_outlined, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              _searchQuery.isEmpty ? 'Belum ada tugas' : 'Tidak ditemukan',
              style: TextStyle(fontSize: 18, color: Colors.grey[400]),
            ),
          ],
        ),
      );

    return LayoutBuilder(
      builder: (context, constraints) {
        final cols = constraints.maxWidth >= 1200
            ? 3
            : constraints.maxWidth >= 768
            ? 2
            : 1;
        return GridView.builder(
          padding: const EdgeInsets.all(20),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: cols,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.2,
          ),
          itemCount: list.length,
          itemBuilder: (c, i) => _buildTugasCard(list[i]),
        );
      },
    );
  }

  Widget _buildTugasCard(Map<String, dynamic> t) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final deadline = t['deadline'] as DateTime;
    final isOverdue =
        deadline.isBefore(DateTime.now()) && t['status'] == 'Aktif';
    final progress = (t['sudahMengumpulkan'] / t['jumlahSiswa']) * 100;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _showDetailDialog(context, t),
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isOverdue
                  ? Colors.red.withOpacity(0.5)
                  : (isDark ? Colors.grey[800]! : Colors.grey[200]!),
              width: isOverdue ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: t['status'] == 'Aktif'
                          ? AppTheme.accentGreen.withOpacity(0.1)
                          : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.assignment,
                      color: t['status'] == 'Aktif'
                          ? AppTheme.accentGreen
                          : Colors.grey,
                      size: 22,
                    ),
                  ),
                  const Spacer(),
                  PopupMenuButton(
                    icon: Icon(
                      Icons.more_vert,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                    itemBuilder: (c) => [
                      const PopupMenuItem(
                        value: 'view',
                        child: Row(
                          children: [
                            Icon(Icons.visibility, size: 20),
                            SizedBox(width: 8),
                            Text('Detail'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 20),
                            SizedBox(width: 8),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 20, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Hapus', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (v) {
                      if (v == 'view')
                        _showDetailDialog(context, t);
                      else if (v == 'edit')
                        _showEditDialog(context, t);
                      else if (v == 'delete')
                        _showDeleteDialog(context, t);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                t['judul'],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                t['deskripsi'],
                style: TextStyle(
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.secondaryTeal.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  t['kelas'],
                  style: TextStyle(
                    color: AppTheme.secondaryTeal,
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              ),
              const Spacer(),
              const Divider(),
              Row(
                children: [
                  Icon(
                    isOverdue ? Icons.error : Icons.schedule,
                    size: 18,
                    color: isOverdue
                        ? Colors.red
                        : (isDark ? Colors.grey[400] : Colors.grey[600]),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      isOverdue
                          ? 'Terlambat ${deadline.difference(DateTime.now()).inDays.abs()} hari'
                          : 'Deadline: ${DateFormat('dd MMM yyyy').format(deadline)}',
                      style: TextStyle(
                        color: isOverdue
                            ? Colors.red
                            : (isDark ? Colors.grey[400] : Colors.grey[600]),
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${t['sudahMengumpulkan']}/${t['jumlahSiswa']} siswa',
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress / 100,
                      backgroundColor: isDark
                          ? Colors.grey[800]
                          : Colors.grey[200],
                      color: progress < 50
                          ? Colors.red
                          : progress < 75
                          ? AppTheme.accentOrange
                          : AppTheme.accentGreen,
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDetailDialog(BuildContext context, Map<String, dynamic> t) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (c) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: 500,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: AppTheme.sunsetGradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.assignment,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Detail Tugas',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          t['judul'],
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),
              _buildDetailRow(Icons.title, 'Judul', t['judul'], isDark),
              const SizedBox(height: 12),
              _buildDetailRow(
                Icons.description,
                'Deskripsi',
                t['deskripsi'],
                isDark,
              ),
              const SizedBox(height: 12),
              _buildDetailRow(Icons.class_, 'Kelas', t['kelas'], isDark),
              const SizedBox(height: 12),
              _buildDetailRow(
                Icons.schedule,
                'Deadline',
                DateFormat('dd MMMM yyyy').format(t['deadline']),
                isDark,
              ),
              const SizedBox(height: 12),
              _buildDetailRow(Icons.info, 'Status', t['status'], isDark),
              const SizedBox(height: 12),
              _buildDetailRow(
                Icons.people,
                'Pengumpulan',
                '${t['sudahMengumpulkan']}/${t['jumlahSiswa']} siswa',
                isDark,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Tutup',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _showEditDialog(context, t);
                    },
                    icon: const Icon(Icons.edit, size: 18),
                    label: const Text('Edit'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryPurple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    IconData icon,
    String label,
    String value,
    bool isDark,
  ) => Row(
    children: [
      Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[800] : Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 20, color: AppTheme.primaryPurple),
      ),
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
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    ],
  );

  void _showAddDialog(BuildContext context) =>
      _showFormDialog(context, 'Buat Tugas Baru', null);
  void _showEditDialog(BuildContext context, Map<String, dynamic> t) =>
      _showFormDialog(context, 'Edit Tugas', t);

  void _showFormDialog(
    BuildContext context,
    String title,
    Map<String, dynamic>? t,
  ) {
    final formKey = GlobalKey<FormState>();
    final judul = TextEditingController(text: t?['judul']);
    final desk = TextEditingController(text: t?['deskripsi']);
    String kelas = t?['kelas'] ?? '10 IPA 1';
    DateTime deadline =
        t?['deadline'] ?? DateTime.now().add(const Duration(days: 7));

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
                  t == null ? Icons.add : Icons.edit,
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
                    controller: judul,
                    decoration: InputDecoration(
                      labelText: 'Judul Tugas',
                      prefixIcon: const Icon(Icons.title),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (v) => v?.isEmpty ?? true ? 'Wajib diisi' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: desk,
                    decoration: InputDecoration(
                      labelText: 'Deskripsi',
                      prefixIcon: const Icon(Icons.description),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    maxLines: 3,
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
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Deadline'),
                    subtitle: Text(DateFormat('dd MMMM yyyy').format(deadline)),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: deadline,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (picked != null) setState(() => deadline = picked);
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
                  this.setState(() {
                    if (t == null) {
                      _tugasList.add({
                        'id': DateTime.now().toString(),
                        'judul': judul.text,
                        'deskripsi': desk.text,
                        'kelas': kelas,
                        'deadline': deadline,
                        'status': 'Aktif',
                        'jumlahSiswa': 32,
                        'sudahMengumpulkan': 0,
                      });
                    } else {
                      t['judul'] = judul.text;
                      t['deskripsi'] = desk.text;
                      t['kelas'] = kelas;
                      t['deadline'] = deadline;
                    }
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          const Icon(Icons.check_circle, color: Colors.white),
                          const SizedBox(width: 12),
                          Text(t == null ? 'Tugas dibuat' : 'Tugas diperbarui'),
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
              child: Text(t == null ? 'Buat' : 'Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, Map<String, dynamic> t) {
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
        content: Text('Yakin hapus tugas "${t['judul']}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => _tugasList.remove(t));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.white),
                      SizedBox(width: 12),
                      Text('Tugas dihapus'),
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
