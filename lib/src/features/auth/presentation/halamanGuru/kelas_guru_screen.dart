import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/config/theme.dart';
import '../widgets/guru_app_scaffold.dart';

class KelasGuruScreen extends ConsumerStatefulWidget {
  const KelasGuruScreen({super.key});

  @override
  ConsumerState<KelasGuruScreen> createState() => _KelasGuruScreenState();
}

class _KelasGuruScreenState extends ConsumerState<KelasGuruScreen> {
  String _searchQuery = '';
  
  final List<Map<String, dynamic>> _kelasList = [
    {'id': '1', 'nama': '10 IPA 1', 'mataPelajaran': 'Matematika', 'jumlahSiswa': 32, 'jadwal': 'Senin, 07:00 - 09:00', 'ruangan': 'R.201', 'waliKelas': 'Bu Siti', 'semester': 'Ganjil 2024/2025'},
    {'id': '2', 'nama': '10 IPA 2', 'mataPelajaran': 'Matematika', 'jumlahSiswa': 30, 'jadwal': 'Selasa, 08:00 - 10:00', 'ruangan': 'R.202', 'waliKelas': 'Pak Budi', 'semester': 'Ganjil 2024/2025'},
    {'id': '3', 'nama': '11 IPA 1', 'mataPelajaran': 'Matematika', 'jumlahSiswa': 28, 'jadwal': 'Rabu, 09:00 - 11:00', 'ruangan': 'R.301', 'waliKelas': 'Bu Ani', 'semester': 'Ganjil 2024/2025'},
  ];

  List<Map<String, dynamic>> get filteredKelasList {
    if (_searchQuery.isEmpty) return _kelasList;
    return _kelasList.where((k) {
      final q = _searchQuery.toLowerCase();
      return '${k['nama']} ${k['mataPelajaran']} ${k['ruangan']} ${k['waliKelas']}'.toLowerCase().contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return GuruAppScaffold(
      title: 'Manajemen Kelas',
      icon: Icons.class_,
      currentRoute: '/kelas',
      additionalActions: [IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: () => _showAddDialog(context), tooltip: 'Tambah Kelas')],
      body: Column(children: [_buildSearchBar(), Expanded(child: _buildList())]),
      floatingActionButton: FloatingActionButton.extended(onPressed: () => _showAddDialog(context), icon: const Icon(Icons.add, color: Colors.white), label: const Text('Tambah Kelas', style: TextStyle(color: Colors.white)), backgroundColor: AppTheme.primaryPurple),
    );
  }

  Widget _buildSearchBar() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: isDark ? const Color(0xFF1E1E1E) : Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))]),
      child: TextField(
        onChanged: (v) => setState(() => _searchQuery = v),
        decoration: InputDecoration(hintText: 'Cari kelas...', prefixIcon: const Icon(Icons.search), filled: true, fillColor: isDark ? AppTheme.backgroundDark : AppTheme.backgroundLight, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none), contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
      ),
    );
  }

  Widget _buildList() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final list = filteredKelasList;
    if (list.isEmpty) return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.class_outlined, size: 80, color: Colors.grey[400]), const SizedBox(height: 16), Text(_searchQuery.isEmpty ? 'Belum ada kelas' : 'Tidak ditemukan', style: TextStyle(fontSize: 18, color: Colors.grey[400]))]));
    
    return LayoutBuilder(builder: (context, constraints) {
      final cols = constraints.maxWidth >= 1200 ? 3 : constraints.maxWidth >= 768 ? 2 : 1;
      return GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: cols, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 1.3),
        itemCount: list.length,
        itemBuilder: (c, i) => _buildCard(list[i], isDark),
      );
    });
  }

  Widget _buildCard(Map<String, dynamic> k, bool isDark) {
    return MouseRegion(cursor: SystemMouseCursors.click, child: GestureDetector(
      onTap: () => _showDetail(context, k),
      child: Container(
        decoration: BoxDecoration(color: isDark ? const Color(0xFF1E1E1E) : Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: isDark ? AppTheme.primaryPurple.withOpacity(0.3) : AppTheme.primaryPurple.withOpacity(0.2)), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))]),
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(gradient: AppTheme.sunsetGradient, borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.class_, color: Colors.white, size: 24)), const Spacer(), PopupMenuButton(icon: Icon(Icons.more_vert, color: isDark ? Colors.grey[400] : Colors.grey[600]), itemBuilder: (c) => [const PopupMenuItem(value: 'view', child: Row(children: [Icon(Icons.visibility, size: 20), SizedBox(width: 8), Text('Detail')])), const PopupMenuItem(value: 'edit', child: Row(children: [Icon(Icons.edit, size: 20), SizedBox(width: 8), Text('Edit')])), const PopupMenuItem(value: 'delete', child: Row(children: [Icon(Icons.delete, size: 20, color: Colors.red), SizedBox(width: 8), Text('Hapus', style: TextStyle(color: Colors.red))]))], onSelected: (v) { if (v == 'view') _showDetail(context, k); else if (v == 'edit') _showEditDialog(context, k); else if (v == 'delete') _showDeleteDialog(context, k); })]),
          const SizedBox(height: 16),
          Text(k['nama'], style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: AppTheme.secondaryTeal.withOpacity(0.1), borderRadius: BorderRadius.circular(8), border: Border.all(color: AppTheme.secondaryTeal.withOpacity(0.3))), child: Text(k['mataPelajaran'], style: TextStyle(color: AppTheme.secondaryTeal, fontWeight: FontWeight.w600, fontSize: 13))),
          const Spacer(),
          const Divider(),
          _buildInfo(Icons.people, '${k['jumlahSiswa']} Siswa', isDark),
          const SizedBox(height: 8),
          _buildInfo(Icons.schedule, k['jadwal'], isDark),
          const SizedBox(height: 8),
          _buildInfo(Icons.room, k['ruangan'], isDark),
        ]),
      ),
    ));
  }

  Widget _buildInfo(IconData icon, String text, bool isDark) => Row(children: [Icon(icon, size: 16, color: isDark ? Colors.grey[400] : Colors.grey[600]), const SizedBox(width: 6), Expanded(child: Text(text, style: TextStyle(fontSize: 13, color: isDark ? Colors.grey[400] : Colors.grey[600]), overflow: TextOverflow.ellipsis))]);

  void _showDetail(BuildContext context, Map<String, dynamic> k) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(context: context, builder: (c) => Dialog(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), child: Container(width: 500, padding: const EdgeInsets.all(24), child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(gradient: AppTheme.sunsetGradient, borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.class_, color: Colors.white, size: 28)), const SizedBox(width: 16), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Detail Kelas', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)), Text(k['nama'], style: TextStyle(color: Colors.grey[600], fontSize: 14))])), IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close))]), const SizedBox(height: 24), const Divider(), const SizedBox(height: 16), _buildDetailRow(Icons.class_, 'Nama Kelas', k['nama'], isDark), const SizedBox(height: 12), _buildDetailRow(Icons.book, 'Mata Pelajaran', k['mataPelajaran'], isDark), const SizedBox(height: 12), _buildDetailRow(Icons.people, 'Jumlah Siswa', '${k['jumlahSiswa']} Siswa', isDark), const SizedBox(height: 12), _buildDetailRow(Icons.schedule, 'Jadwal', k['jadwal'], isDark), const SizedBox(height: 12), _buildDetailRow(Icons.room, 'Ruangan', k['ruangan'], isDark), const SizedBox(height: 12), _buildDetailRow(Icons.person, 'Wali Kelas', k['waliKelas'], isDark), const SizedBox(height: 24), Row(mainAxisAlignment: MainAxisAlignment.end, children: [TextButton(onPressed: () => Navigator.pop(context), child: Text('Tutup', style: TextStyle(color: Colors.grey[600]))), const SizedBox(width: 8), ElevatedButton.icon(onPressed: () { Navigator.pop(context); _showEditDialog(context, k); }, icon: const Icon(Icons.edit, size: 18), label: const Text('Edit'), style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryPurple, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))))])]))));
  }

  Widget _buildDetailRow(IconData icon, String label, String value, bool isDark) => Row(children: [Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: isDark ? Colors.grey[800] : Colors.grey[100], borderRadius: BorderRadius.circular(8)), child: Icon(icon, size: 20, color: AppTheme.primaryPurple)), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600], fontWeight: FontWeight.w500)), const SizedBox(height: 2), Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600))]))]);

  void _showAddDialog(BuildContext context) => _showFormDialog(context, 'Tambah Kelas Baru', null);
  void _showEditDialog(BuildContext context, Map<String, dynamic> k) => _showFormDialog(context, 'Edit Kelas', k);

  void _showFormDialog(BuildContext context, String title, Map<String, dynamic>? k) {
    final formKey = GlobalKey<FormState>();
    final nama = TextEditingController(text: k?['nama']);
    final mapel = TextEditingController(text: k?['mataPelajaran']);
    final siswa = TextEditingController(text: k?['jumlahSiswa']?.toString());
    final jadwal = TextEditingController(text: k?['jadwal']);
    final ruangan = TextEditingController(text: k?['ruangan']);
    final wali = TextEditingController(text: k?['waliKelas']);

    showDialog(context: context, builder: (c) => AlertDialog(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), title: Row(children: [Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(gradient: AppTheme.sunsetGradient, borderRadius: BorderRadius.circular(8)), child: Icon(k == null ? Icons.add : Icons.edit, color: Colors.white, size: 20)), const SizedBox(width: 12), Text(title)]), content: SingleChildScrollView(child: Form(key: formKey, child: Column(mainAxisSize: MainAxisSize.min, children: [TextFormField(controller: nama, decoration: InputDecoration(labelText: 'Nama Kelas', prefixIcon: const Icon(Icons.class_), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))), validator: (v) => v?.isEmpty ?? true ? 'Wajib diisi' : null), const SizedBox(height: 16), TextFormField(controller: mapel, decoration: InputDecoration(labelText: 'Mata Pelajaran', prefixIcon: const Icon(Icons.book), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))), validator: (v) => v?.isEmpty ?? true ? 'Wajib diisi' : null), const SizedBox(height: 16), TextFormField(controller: siswa, decoration: InputDecoration(labelText: 'Jumlah Siswa', prefixIcon: const Icon(Icons.people), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))), keyboardType: TextInputType.number, validator: (v) => v?.isEmpty ?? true ? 'Wajib diisi' : null), const SizedBox(height: 16), TextFormField(controller: jadwal, decoration: InputDecoration(labelText: 'Jadwal', prefixIcon: const Icon(Icons.schedule), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))), validator: (v) => v?.isEmpty ?? true ? 'Wajib diisi' : null), const SizedBox(height: 16), TextFormField(controller: ruangan, decoration: InputDecoration(labelText: 'Ruangan', prefixIcon: const Icon(Icons.room), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))), validator: (v) => v?.isEmpty ?? true ? 'Wajib diisi' : null), const SizedBox(height: 16), TextFormField(controller: wali, decoration: InputDecoration(labelText: 'Wali Kelas', prefixIcon: const Icon(Icons.person), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))), validator: (v) => v?.isEmpty ?? true ? 'Wajib diisi' : null)]))), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')), ElevatedButton(onPressed: () { if (formKey.currentState!.validate()) { setState(() { if (k == null) { _kelasList.add({'id': DateTime.now().toString(), 'nama': nama.text, 'mataPelajaran': mapel.text, 'jumlahSiswa': int.parse(siswa.text), 'jadwal': jadwal.text, 'ruangan': ruangan.text, 'waliKelas': wali.text, 'semester': 'Ganjil 2024/2025'}); } else { k['nama'] = nama.text; k['mataPelajaran'] = mapel.text; k['jumlahSiswa'] = int.parse(siswa.text); k['jadwal'] = jadwal.text; k['ruangan'] = ruangan.text; k['waliKelas'] = wali.text; } }); Navigator.pop(context); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Row(children: [const Icon(Icons.check_circle, color: Colors.white), const SizedBox(width: 12), Text(k == null ? 'Kelas ditambahkan' : 'Kelas diperbarui')]), backgroundColor: AppTheme.accentGreen, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)))); } }, style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryPurple, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))), child: const Text('Simpan'))]));
  }

  void _showDeleteDialog(BuildContext context, Map<String, dynamic> k) {
    showDialog(context: context, builder: (c) => AlertDialog(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), title: const Row(children: [Icon(Icons.warning, color: Colors.red, size: 28), SizedBox(width: 12), Text('Konfirmasi Hapus')]), content: Text('Yakin hapus kelas "${k['nama']}"?'), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')), ElevatedButton(onPressed: () { setState(() => _kelasList.remove(k)); Navigator.pop(context); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Row(children: [Icon(Icons.check_circle, color: Colors.white), SizedBox(width: 12), Text('Kelas dihapus')]), backgroundColor: Colors.red, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)))); }, style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))), child: const Text('Hapus'))]));
  }
}
