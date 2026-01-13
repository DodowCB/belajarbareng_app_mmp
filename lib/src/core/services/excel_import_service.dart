import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

class ExcelImportService {
  static Future<List<Map<String, dynamic>>?> importGuruFromExcel() async {
    try {
      // Pick Excel file
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls'],
        allowMultiple: false,
        withData: true, // Ensure data is loaded on all platforms
      );

      if (result != null && result.files.single != null) {
        late final List<int> bytes;

        // Try to get bytes directly (works on web and sometimes mobile)
        if (result.files.single.bytes != null) {
          bytes = result.files.single.bytes!;
        }
        // On mobile/desktop, read from path if bytes are null
        else if (result.files.single.path != null) {
          final file = File(result.files.single.path!);
          bytes = await file.readAsBytes();
        } else {
          debugPrint('❌ No file data available');
          return null;
        }

        final excel = Excel.decodeBytes(bytes);

        List<Map<String, dynamic>> guruList = [];

        // Get the first sheet
        String? sheetName = excel.tables.keys.first;
        var table = excel.tables[sheetName];

        if (table != null && table.rows.isNotEmpty) {
          // Skip header row (index 0)
          for (int i = 1; i < table.rows.length; i++) {
            var row = table.rows[i];

            // Skip empty rows
            if (row.isEmpty || row.every((cell) => cell?.value == null)) {
              continue;
            }

            // Expected columns: Nama, NIG, Email, Mata Pelajaran, Jenis Kelamin, Sekolah, Password
            String nama = row[0]?.value?.toString().trim() ?? '';
            String nig = row[1]?.value?.toString().trim() ?? '';
            String email = row[2]?.value?.toString().trim() ?? '';
            String mataPelajaran = row[3]?.value?.toString().trim() ?? '';
            String jenisKelamin = row[4]?.value?.toString().trim() ?? '';
            String sekolah = row[5]?.value?.toString().trim() ?? '';
            String password = row[6]?.value?.toString().trim() ?? '';

            // Validate required fields
            if (nama.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
              guruList.add({
                'nama_lengkap': nama,
                'nig': nig,
                'email': email,
                'password': password,
                'mata_pelajaran': mataPelajaran,
                'jenis_kelamin': jenisKelamin,
                'sekolah': sekolah,
                'photo_url': '',
                'status': 'active',
                'createdAt': DateTime.now().toIso8601String(),
              });
            }
          }
        }

        return guruList;
      } else {
        debugPrint('❌ No file selected or file picker was cancelled');
      }
    } catch (e) {
      debugPrint('❌ Error importing guru from Excel: $e');
      throw Exception('Failed to import Excel file: $e');
    }
    return null;
  }

  static Future<List<Map<String, dynamic>>?> importSiswaFromExcel() async {
    try {
      // Pick Excel file
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls'],
        allowMultiple: false,
        withData: true, // Ensure data is loaded on all platforms
      );

      if (result != null && result.files.single != null) {
        late final List<int> bytes;

        // Try to get bytes directly (works on web and sometimes mobile)
        if (result.files.single.bytes != null) {
          bytes = result.files.single.bytes!;
        }
        // On mobile/desktop, read from path if bytes are null
        else if (result.files.single.path != null) {
          final file = File(result.files.single.path!);
          bytes = await file.readAsBytes();
        } else {
          debugPrint('❌ No file data available');
          return null;
        }

        final excel = Excel.decodeBytes(bytes);

        List<Map<String, dynamic>> siswaList = [];

        // Get the first sheet
        String? sheetName = excel.tables.keys.first;
        var table = excel.tables[sheetName];

        if (table != null && table.rows.isNotEmpty) {
          // Skip header row (index 0)
          for (int i = 1; i < table.rows.length; i++) {
            var row = table.rows[i];

            // Skip empty rows
            if (row.isEmpty || row.every((cell) => cell?.value == null)) {
              continue;
            }

            // Expected columns: Nama, NIS, Email, Jenis Kelamin, Tanggal Lahir
            String nama = row[0]?.value?.toString().trim() ?? '';
            String nis = row[1]?.value?.toString().trim() ?? '';
            String email = row[2]?.value?.toString().trim() ?? '';
            String password = row[3]?.value?.toString().trim() ?? '';
            String jenisKelamin = row[4]?.value?.toString().trim() ?? '';
            String tanggalLahir = row[5]?.value?.toString().trim() ?? '';

            // Validate required fields
            if (nama.isNotEmpty && email.isNotEmpty) {
              siswaList.add({
                'nama': nama,
                'nis': nis,
                'email': email,
                'password': password,
                'jenis_kelamin': jenisKelamin,
                'tanggal_lahir': tanggalLahir,
                'photo_url': '',
                'status': 'active',
                'createdAt': DateTime.now().toIso8601String(),
              });
            }
          }
        }

        return siswaList;
      } else {
        debugPrint('❌ No file selected or file picker was cancelled');
      }
    } catch (e) {
      debugPrint('❌ Error importing siswa from Excel: $e');
      throw Exception('Failed to import Excel file: $e');
    }
    return null;
  }

  static String getGuruExcelTemplate() {
    return """
Format Excel untuk Import Data Guru:

Kolom A: Nama (Required)
Kolom B: NIG 
Kolom C: Email (Required)
Kolom D: Password (Required)
Kolom E: Mata Pelajaran
Kolom F: Jenis Kelamin (L/P)
Kolom G: Sekolah

Contoh:
| Nama          | NIG      | Email              | Password   | Mata Pelajaran | Jenis Kelamin | Sekolah    |
|---------------|----------|--------------------|------------|----------------|---------------|------------|
| John Doe      | 12345    | john@example.com   | password123| Matematika     | L             | SMAN 1     |
| Jane Smith    | 12346    | jane@example.com   | password456| Bahasa Inggris | P             | SMAN 1     |
""";
  }

  static String getSiswaExcelTemplate() {
    return """
Format Excel untuk Import Data Siswa:

Kolom A: Nama (Required)
Kolom B: NIS
Kolom C: Email (Required)
Kolom D: Jenis Kelamin (L/P)
Kolom E: Tanggal Lahir (DD/MM/YYYY)

Contoh:
| Nama          | NIS      | Email              | Jenis Kelamin | Tanggal Lahir |
|---------------|----------|--------------------|---------------|---------------|
| Ahmad Rizki   | 001      | ahmad@example.com  | L             | 15/08/2005    |
| Siti Nurhaliza| 002      | siti@example.com   | P             | 22/03/2006    |
""";
  }
}
