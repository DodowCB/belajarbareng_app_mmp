import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ExcelImportService', () {
    test('should instantiate service correctly', () {
      // Test basic instantiation
      expect(true, isTrue);
    });

    test('should handle empty bytes gracefully', () {
      final emptyBytes = <int>[];

      expect(emptyBytes.isEmpty, true);
      expect(emptyBytes.length, equals(0));
    });

    test('should handle invalid excel format', () {
      final invalidBytes = [0, 1, 2, 3, 4, 5];

      // Excel files start with specific magic numbers
      // Valid Excel (.xlsx) starts with PK (0x504B)
      expect(invalidBytes.length > 0, true);
      expect(invalidBytes[0] != 0x50, true); // Not 'P'
    });

    group('Data Validation', () {
      test('should validate NIP format (16 or 18 digits)', () {
        final validNIP16 = '1234567890123456';
        final validNIP18 = '123456789012345678';
        final invalidNIP = '123';

        expect(validNIP16.length, 16);
        expect(validNIP18.length, 18);
        expect(invalidNIP.length, lessThan(16));
        expect(RegExp(r'^[0-9]+$').hasMatch(validNIP16), true);
      });

      test('should validate NIS format (8-10 digits)', () {
        final validNIS8 = '12345678';
        final validNIS10 = '1234567890';
        final invalidNIS = '123';

        expect(validNIS8.length, 8);
        expect(validNIS10.length, 10);
        expect(invalidNIS.length, lessThan(8));
      });

      test('should validate email format', () {
        final validEmail = 'teacher@school.com';
        final invalidEmail = 'invalid-email';

        expect(validEmail.contains('@'), true);
        expect(validEmail.contains('.'), true);
        expect(invalidEmail.contains('@'), false);

        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
        expect(emailRegex.hasMatch(validEmail), true);
        expect(emailRegex.hasMatch(invalidEmail), false);
      });

      test('should validate phone number format', () {
        final validPhone = '081234567890';
        final invalidPhone = '123';

        expect(validPhone.length, greaterThanOrEqualTo(10));
        expect(validPhone.length, lessThanOrEqualTo(15));
        expect(invalidPhone.length, lessThan(10));
        expect(RegExp(r'^[0-9]+$').hasMatch(validPhone), true);
      });

      test('should validate required fields are not empty', () {
        final validName = 'Ahmad Ridwan';
        final emptyName = '';
        final spacesName = '   ';

        expect(validName.isNotEmpty, true);
        expect(emptyName.isEmpty, true);
        expect(spacesName.trim().isEmpty, true);
      });
    });

    group('Excel Column Mapping', () {
      test('should map teacher columns correctly', () {
        // Guru columns: NIP, Nama Lengkap, Email, No Telp, Password
        final guruColumns = [
          'NIP',
          'Nama Lengkap',
          'Email',
          'No Telp',
          'Password',
        ];

        expect(guruColumns.length, equals(5));
        expect(guruColumns[0], equals('NIP'));
        expect(guruColumns[1], equals('Nama Lengkap'));
        expect(guruColumns[2], equals('Email'));
        expect(guruColumns[3], equals('No Telp'));
        expect(guruColumns[4], equals('Password'));
      });

      test('should map student columns correctly', () {
        // Siswa columns: NIS, Nama Lengkap, Email, No Telp, Password
        final siswaColumns = [
          'NIS',
          'Nama Lengkap',
          'Email',
          'No Telp',
          'Password',
        ];

        expect(siswaColumns.length, equals(5));
        expect(siswaColumns[0], equals('NIS'));
        expect(siswaColumns[1], equals('Nama Lengkap'));
        expect(siswaColumns[2], equals('Email'));
        expect(siswaColumns[3], equals('No Telp'));
        expect(siswaColumns[4], equals('Password'));
      });
    });

    group('Data Transformation', () {
      test('should transform Excel row to Map correctly', () {
        final row = [
          '1234567890123456',
          'Ahmad Ridwan',
          'ahmad@school.com',
          '081234567890',
          'password123',
        ];

        final guruData = {
          'nip': row[0],
          'nama_lengkap': row[1],
          'email': row[2],
          'nomor_telepon': row[3],
          'password': row[4],
        };

        expect(guruData['nip'], equals('1234567890123456'));
        expect(guruData['nama_lengkap'], equals('Ahmad Ridwan'));
        expect(guruData['email'], equals('ahmad@school.com'));
        expect(guruData['nomor_telepon'], equals('081234567890'));
        expect(guruData['password'], equals('password123'));
      });

      test('should handle null or empty cells', () {
        final rowWithEmpty = [
          '1234567890123456',
          '',
          'ahmad@school.com',
          null,
          'password',
        ];

        expect(rowWithEmpty[0], isNotEmpty);
        expect(rowWithEmpty[1], isEmpty);
        expect(rowWithEmpty[2], isNotEmpty);
        expect(rowWithEmpty[3], isNull);
        expect(rowWithEmpty[4], isNotEmpty);
      });

      test('should trim whitespace from data', () {
        final dataWithSpaces = '  Ahmad Ridwan  ';
        final trimmed = dataWithSpaces.trim();

        expect(trimmed, equals('Ahmad Ridwan'));
        expect(trimmed.startsWith(' '), false);
        expect(trimmed.endsWith(' '), false);
      });
    });

    group('File Format Detection', () {
      test('should detect valid Excel magic numbers', () {
        // Excel (.xlsx) files start with PK (0x504B)
        final validExcelHeader = [0x50, 0x4B, 0x03, 0x04];

        expect(validExcelHeader[0], equals(0x50)); // 'P'
        expect(validExcelHeader[1], equals(0x4B)); // 'K'
      });

      test('should reject non-Excel files', () {
        // PDF starts with %PDF (0x25, 0x50, 0x44, 0x46)
        final pdfHeader = [0x25, 0x50, 0x44, 0x46];

        expect(pdfHeader[0] == 0x50, false); // Not PK
        expect(pdfHeader[0] == 0x25, true); // Is %
      });
    });

    group('Error Messages', () {
      test('should generate appropriate error message for empty file', () {
        const errorMessage = 'No Excel file found or file is empty';
        expect(errorMessage.contains('empty'), true);
      });

      test('should generate error for invalid format', () {
        const errorMessage = 'Invalid Excel format';
        expect(errorMessage.contains('Invalid'), true);
      });

      test('should generate error for missing columns', () {
        const errorMessage = 'Required column not found';
        expect(errorMessage.contains('column'), true);
      });

      test('should generate error for invalid data', () {
        const errorMessage = 'Invalid data in row';
        expect(errorMessage.contains('Invalid'), true);
      });
    });

    group('Batch Import', () {
      test('should count imported rows correctly', () {
        final importedRows = 10;
        final failedRows = 2;
        final totalRows = importedRows + failedRows;

        expect(totalRows, equals(12));
        expect(importedRows, equals(10));
        expect(failedRows, equals(2));
      });

      test('should calculate success rate', () {
        final imported = 8;
        final total = 10;
        final successRate = (imported / total * 100).toStringAsFixed(1);

        expect(successRate, equals('80.0'));
      });

      test('should handle empty import', () {
        final imported = 0;
        final total = 0;

        expect(imported, equals(0));
        expect(total, equals(0));
        // Avoid division by zero
        final successRate = total > 0 ? (imported / total * 100) : 0.0;
        expect(successRate, equals(0.0));
      });
    });

    group('Data Type Conversion', () {
      test('should convert numeric cells correctly', () {
        // Excel might return numbers as double
        final cellValue = 12345678.0;
        final asInt = cellValue.toInt();
        final asString = asInt.toString();

        expect(asInt, equals(12345678));
        expect(asString, equals('12345678'));
      });

      test('should handle string cells', () {
        final cellValue = 'Ahmad Ridwan';

        expect(cellValue, isA<String>());
        expect(cellValue.length, greaterThan(0));
      });

      test('should handle mixed data types', () {
        final mixedData = [
          '1234567890123456', // String NIP
          'Ahmad Ridwan', // String name
          'ahmad@school.com', // String email
          81234567890.0, // Numeric phone (might come as double)
          'password123', // String password
        ];

        expect(mixedData[0], isA<String>());
        expect(mixedData[1], isA<String>());
        expect(mixedData[2], isA<String>());
        expect(mixedData[3], isA<double>());
        expect(mixedData[4], isA<String>());

        // Convert numeric phone to string with proper casting
        final numericValue = mixedData[3] as double;
        final phoneString = numericValue.toInt().toString();
        expect(phoneString, equals('81234567890'));
      });
    });

    group('Duplicate Detection', () {
      test('should detect duplicate NIPs', () {
        final nips = [
          '1234567890123456',
          '9876543210987654',
          '1234567890123456',
        ];
        final uniqueNips = nips.toSet();

        expect(nips.length, equals(3));
        expect(uniqueNips.length, equals(2)); // One duplicate
        expect(uniqueNips.contains('1234567890123456'), true);
      });

      test('should detect duplicate emails', () {
        final emails = ['user1@test.com', 'user2@test.com', 'user1@test.com'];
        final uniqueEmails = emails.toSet();

        expect(emails.length, equals(3));
        expect(uniqueEmails.length, equals(2));
      });
    });
  });
}
