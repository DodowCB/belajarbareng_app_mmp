import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/config/theme.dart';
import '../../widgets/guru_app_scaffold.dart';

class MateriGuruScreen extends ConsumerStatefulWidget {
  const MateriGuruScreen({super.key});

  @override
  ConsumerState<MateriGuruScreen> createState() => _MateriGuruScreenState();
}

class _MateriGuruScreenState extends ConsumerState<MateriGuruScreen> {
  String _searchQuery = '';
  String _selectedKelas = 'Semua Kelas';
  String _selectedTipe = 'Semua Tipe';

  final List<Map<String, dynamic>> _materiList = [
    {
      'id': '1',
      'judul': 'Pengantar Trigonometri',
      'deskripsi': 'Materi dasar trigonometri: sin, cos, tan',
      'kelas': '10 IPA 1',
      'tipe': 'PDF',
      'ukuran': '2.5 MB',
      'tanggalUpload': DateTime.now().subtract(const Duration(days: 5)),
      'icon': Icons.picture_as_pdf,
      'color': Colors.red,
    },
    {
      'id': '2',
      'judul': 'Video Pembelajaran Integral',
      'deskripsi': 'Video tutorial integral tak tentu dan tentu',
      'kelas': '11 IPA 1',
      'tipe': 'Video',
      'ukuran': '45.8 MB',
      'tanggalUpload': DateTime.now().subtract(const Duration(days: 3)),
      'icon': Icons.video_library,
      'color': Colors.blue,
    },
    {
      'id': '3',
      'judul': 'Soal Latihan Limit',
      'deskripsi': 'Kumpulan soal latihan limit fungsi',
      'kelas': '10 IPA 2',
      'tipe': 'PDF',
      'ukuran': '1.2 MB',
      'tanggalUpload': DateTime.now().subtract(const Duration(days: 1)),
      'icon': Icons.picture_as_pdf,
      'color': Colors.red,
    },
    {
      'id': '4',
      'judul': 'Materi Presentasi Matriks',
      'deskripsi': 'Slide presentasi operasi matriks',
      'kelas': '11 IPA 1',
      'tipe': 'PPT',
      'ukuran': '5.4 MB',
      'tanggalUpload': DateTime.now().subtract(const Duration(days: 7)),
      'icon': Icons.slideshow,
      'color': AppTheme.accentOrange,
    },
    {
      'id': '5',
      'judul': 'Link Kalkulator Online',
      'deskripsi': 'Link ke website kalkulator matematika',
      'kelas': 'Semua Kelas',
      'tipe': 'Link',
      'ukuran': '-',
      'tanggalUpload': DateTime.now().subtract(const Duration(days: 10)),
      'icon': Icons.link,
      'color': AppTheme.secondaryTeal,
    },
  ];

  List<Map<String, dynamic>> get filteredList {
    var list = _materiList;
    if (_selectedKelas != 'Semua Kelas')
      list = list
          .where(
            (m) => m['kelas'] == _selectedKelas || m['kelas'] == 'Semua Kelas',
          )
          .toList();
    if (_selectedTipe != 'Semua Tipe')
      list = list.where((m) => m['tipe'] == _selectedTipe).toList();
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list
          .where(
            (m) => '${m['judul']} ${m['deskripsi']} ${m['kelas']} ${m['tipe']}'
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
      title: 'Materi Pembelajaran',
      icon: Icons.book,
      currentRoute: '/materi',
      additionalActions: [
        IconButton(
          icon: const Icon(Icons.add_circle_outline),
          onPressed: () => _showUploadDialog(context),
          tooltip: 'Upload Materi',
        ),
      ],
      body: Column(
        children: [
          _buildFilterBar(),
          Expanded(
            child: filteredList.isEmpty
                ? _buildEmptyState()
                : _buildMateriGrid(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showUploadDialog(context),
        icon: const Icon(Icons.upload_file, color: Colors.white),
        label: const Text(
          'Upload Materi',
          style: TextStyle(color: Colors.white),
        ),
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
              hintText: 'Cari materi...',
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
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedKelas,
                  decoration: InputDecoration(
                    labelText: 'Filter Kelas',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  items: ['Semua Kelas', '10 IPA 1', '10 IPA 2', '11 IPA 1']
                      .map((k) => DropdownMenuItem(value: k, child: Text(k)))
                      .toList(),
                  onChanged: (v) => setState(() => _selectedKelas = v!),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedTipe,
                  decoration: InputDecoration(
                    labelText: 'Filter Tipe',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  items: ['Semua Tipe', 'PDF', 'Video', 'PPT', 'Link']
                      .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                      .toList(),
                  onChanged: (v) => setState(() => _selectedTipe = v!),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.folder_open, size: 80, color: Colors.grey[400]),
        const SizedBox(height: 16),
        Text(
          'Tidak ada materi',
          style: TextStyle(fontSize: 18, color: Colors.grey[400]),
        ),
      ],
    ),
  );

  Widget _buildMateriGrid() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final list = filteredList;

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
            childAspectRatio: 1.3,
          ),
          itemCount: list.length,
          itemBuilder: (c, i) => _buildMateriCard(list[i], isDark),
        );
      },
    );
  }

  Widget _buildMateriCard(Map<String, dynamic> m, bool isDark) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _showPreviewDialog(context, m),
        child: Container(
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
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: m['color'].withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(m['icon'], color: m['color'], size: 28),
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
                            Text('Lihat'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'download',
                        child: Row(
                          children: [
                            Icon(Icons.download, size: 20),
                            SizedBox(width: 8),
                            Text('Download'),
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
                        _showPreviewDialog(context, m);
                      else if (v == 'download')
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Mengunduh ${m['judul']}...'),
                            backgroundColor: AppTheme.accentGreen,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        );
                      else if (v == 'edit')
                        _showEditDialog(context, m);
                      else if (v == 'delete')
                        _showDeleteDialog(context, m);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                m['judul'],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                m['deskripsi'],
                style: TextStyle(
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                  fontSize: 13,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              const Divider(),
              Row(
                children: [
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
                      m['kelas'],
                      style: TextStyle(
                        color: AppTheme.secondaryTeal,
                        fontWeight: FontWeight.w500,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: m['color'].withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      m['tipe'],
                      style: TextStyle(
                        color: m['color'],
                        fontWeight: FontWeight.w500,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    m['ukuran'],
                    style: TextStyle(
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                      fontSize: 12,
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

  void _showPreviewDialog(BuildContext context, Map<String, dynamic> m) {
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
                      color: m['color'].withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(m['icon'], color: m['color'], size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Preview Materi',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          m['judul'],
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
              _buildDetailRow(Icons.title, 'Judul', m['judul'], isDark),
              const SizedBox(height: 12),
              _buildDetailRow(
                Icons.description,
                'Deskripsi',
                m['deskripsi'],
                isDark,
              ),
              const SizedBox(height: 12),
              _buildDetailRow(Icons.class_, 'Kelas', m['kelas'], isDark),
              const SizedBox(height: 12),
              _buildDetailRow(Icons.category, 'Tipe', m['tipe'], isDark),
              const SizedBox(height: 12),
              _buildDetailRow(Icons.storage, 'Ukuran', m['ukuran'], isDark),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.grey[800]
                      : AppTheme.primaryPurple.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.primaryPurple.withOpacity(0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppTheme.primaryPurple,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Fitur preview lengkap akan segera hadir!',
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
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
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Mengunduh ${m['judul']}...'),
                          backgroundColor: AppTheme.accentGreen,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.download, size: 18),
                    label: const Text('Download'),
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

  void _showUploadDialog(BuildContext context) =>
      _showFormDialog(context, 'Upload Materi Baru', null);
  void _showEditDialog(BuildContext context, Map<String, dynamic> m) =>
      _showFormDialog(context, 'Edit Materi', m);

  void _showFormDialog(
    BuildContext context,
    String title,
    Map<String, dynamic>? m,
  ) {
    final formKey = GlobalKey<FormState>();
    final judul = TextEditingController(text: m?['judul']);
    final desk = TextEditingController(text: m?['deskripsi']);
    String kelas = m?['kelas'] ?? '10 IPA 1';
    String tipe = m?['tipe'] ?? 'PDF';

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
                  m == null ? Icons.upload_file : Icons.edit,
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
                      labelText: 'Judul Materi',
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
                    items: ['10 IPA 1', '10 IPA 2', '11 IPA 1', 'Semua Kelas']
                        .map((k) => DropdownMenuItem(value: k, child: Text(k)))
                        .toList(),
                    onChanged: (v) => setState(() => kelas = v!),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: tipe,
                    decoration: InputDecoration(
                      labelText: 'Tipe Materi',
                      prefixIcon: const Icon(Icons.category),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: ['PDF', 'Video', 'PPT', 'Link']
                        .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                        .toList(),
                    onChanged: (v) => setState(() => tipe = v!),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                          'Fitur upload file akan segera hadir',
                        ),
                        backgroundColor: AppTheme.primaryPurple,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    icon: const Icon(Icons.attach_file),
                    label: const Text('Pilih File'),
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
                  IconData icon;
                  Color color;
                  switch (tipe) {
                    case 'PDF':
                      icon = Icons.picture_as_pdf;
                      color = Colors.red;
                      break;
                    case 'Video':
                      icon = Icons.video_library;
                      color = Colors.blue;
                      break;
                    case 'PPT':
                      icon = Icons.slideshow;
                      color = AppTheme.accentOrange;
                      break;
                    case 'Link':
                      icon = Icons.link;
                      color = AppTheme.secondaryTeal;
                      break;
                    default:
                      icon = Icons.insert_drive_file;
                      color = Colors.grey;
                  }
                  this.setState(() {
                    if (m == null) {
                      _materiList.insert(0, {
                        'id': DateTime.now().toString(),
                        'judul': judul.text,
                        'deskripsi': desk.text,
                        'kelas': kelas,
                        'tipe': tipe,
                        'ukuran': '0 MB',
                        'tanggalUpload': DateTime.now(),
                        'icon': icon,
                        'color': color,
                      });
                    } else {
                      m['judul'] = judul.text;
                      m['deskripsi'] = desk.text;
                      m['kelas'] = kelas;
                      m['tipe'] = tipe;
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
                            m == null ? 'Materi diupload' : 'Materi diperbarui',
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
              child: Text(m == null ? 'Upload' : 'Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, Map<String, dynamic> m) {
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
        content: Text('Yakin hapus materi "${m['judul']}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => _materiList.remove(m));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.white),
                      SizedBox(width: 12),
                      Text('Materi dihapus'),
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
