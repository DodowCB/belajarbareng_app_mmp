import 'dart:io';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';

class ExcelTemplateService {
  static Future<String> createGuruTemplate() async {
    final excel = Excel.createExcel();
    final sheet = excel['Guru Template'];

    // Header row
    sheet.cell(CellIndex.indexByString('A1')).value = TextCellValue('Nama');
    sheet.cell(CellIndex.indexByString('B1')).value = TextCellValue('NIG');
    sheet.cell(CellIndex.indexByString('C1')).value = TextCellValue('Email');
    sheet.cell(CellIndex.indexByString('D1')).value = TextCellValue(
      'Mata Pelajaran',
    );
    sheet.cell(CellIndex.indexByString('E1')).value = TextCellValue(
      'Jenis Kelamin',
    );
    sheet.cell(CellIndex.indexByString('F1')).value = TextCellValue('Sekolah');
    sheet.cell(CellIndex.indexByString('G1')).value = TextCellValue('Password');

    // Example data rows
    sheet.cell(CellIndex.indexByString('A2')).value = TextCellValue('John Doe');
    sheet.cell(CellIndex.indexByString('B2')).value = TextCellValue('12345');
    sheet.cell(CellIndex.indexByString('C2')).value = TextCellValue(
      'john@example.com',
    );
    sheet.cell(CellIndex.indexByString('D2')).value = TextCellValue(
      'Matematika',
    );
    sheet.cell(CellIndex.indexByString('E2')).value = TextCellValue('L');
    sheet.cell(CellIndex.indexByString('F2')).value = TextCellValue('SMAN 1');
    sheet.cell(CellIndex.indexByString('G2')).value = TextCellValue(
      'password123',
    );

    sheet.cell(CellIndex.indexByString('A3')).value = TextCellValue(
      'Jane Smith',
    );
    sheet.cell(CellIndex.indexByString('B3')).value = TextCellValue('12346');
    sheet.cell(CellIndex.indexByString('C3')).value = TextCellValue(
      'jane@example.com',
    );
    sheet.cell(CellIndex.indexByString('D3')).value = TextCellValue(
      'Bahasa Inggris',
    );
    sheet.cell(CellIndex.indexByString('E3')).value = TextCellValue('P');
    sheet.cell(CellIndex.indexByString('F3')).value = TextCellValue('SMAN 1');
    sheet.cell(CellIndex.indexByString('G3')).value = TextCellValue(
      'password456',
    );

    // Save to downloads directory
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/template_guru.xlsx';
    final fileBytes = excel.save();

    if (fileBytes != null) {
      final file = File(filePath);
      await file.writeAsBytes(fileBytes);
      return filePath;
    }

    throw Exception('Failed to create template file');
  }

  static Future<String> createSiswaTemplate() async {
    final excel = Excel.createExcel();
    final sheet = excel['Siswa Template'];

    // Header row
    sheet.cell(CellIndex.indexByString('A1')).value = TextCellValue('Nama');
    sheet.cell(CellIndex.indexByString('B1')).value = TextCellValue('NIS');
    sheet.cell(CellIndex.indexByString('C1')).value = TextCellValue('Email');
    sheet.cell(CellIndex.indexByString('D1')).value = TextCellValue(
      'Jenis Kelamin',
    );
    sheet.cell(CellIndex.indexByString('E1')).value = TextCellValue(
      'Tanggal Lahir',
    );

    // Example data rows
    sheet.cell(CellIndex.indexByString('A2')).value = TextCellValue(
      'Ahmad Rizki',
    );
    sheet.cell(CellIndex.indexByString('B2')).value = TextCellValue('001');
    sheet.cell(CellIndex.indexByString('C2')).value = TextCellValue(
      'ahmad@example.com',
    );
    sheet.cell(CellIndex.indexByString('D2')).value = TextCellValue('L');
    sheet.cell(CellIndex.indexByString('E2')).value = TextCellValue(
      '15/08/2005',
    );

    sheet.cell(CellIndex.indexByString('A3')).value = TextCellValue(
      'Siti Nurhaliza',
    );
    sheet.cell(CellIndex.indexByString('B3')).value = TextCellValue('002');
    sheet.cell(CellIndex.indexByString('C3')).value = TextCellValue(
      'siti@example.com',
    );
    sheet.cell(CellIndex.indexByString('D3')).value = TextCellValue('P');
    sheet.cell(CellIndex.indexByString('E3')).value = TextCellValue(
      '22/03/2006',
    );

    // Save to downloads directory
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/template_siswa.xlsx';
    final fileBytes = excel.save();

    if (fileBytes != null) {
      final file = File(filePath);
      await file.writeAsBytes(fileBytes);
      return filePath;
    }

    throw Exception('Failed to create template file');
  }
}
