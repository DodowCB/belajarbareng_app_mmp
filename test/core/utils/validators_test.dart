import 'package:flutter_test/flutter_test.dart';

/// Helper validation functions untuk testing
bool isValidEmail(String email) {
  return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
}

bool isValidNIS(String nis) {
  return nis.length >= 8 &&
      nis.length <= 10 &&
      RegExp(r'^[0-9]+$').hasMatch(nis);
}

bool isValidNIP(String nip) {
  return (nip.length == 16 || nip.length == 18) &&
      RegExp(r'^[0-9]+$').hasMatch(nip);
}

bool isValidPhone(String phone) {
  return phone.length >= 10 &&
      phone.length <= 15 &&
      RegExp(r'^[0-9]+$').hasMatch(phone);
}

bool isValidName(String name) {
  return name.trim().isNotEmpty && name.length >= 3;
}

bool isValidPassword(String password) {
  // Minimal 6 karakter
  return password.length >= 6;
}

void main() {
  group('Email Validation', () {
    test('should return true for valid emails', () {
      expect(isValidEmail('admin@gmail.com'), true);
      expect(isValidEmail('teacher@school.com'), true);
      expect(isValidEmail('student123@example.org'), true);
      expect(isValidEmail('user.name@domain.co.id'), true);
      expect(isValidEmail('test-email@test.com'), true);
    });

    test('should return false for invalid emails', () {
      expect(isValidEmail('invalid'), false);
      expect(isValidEmail('test@'), false);
      expect(isValidEmail('@gmail.com'), false);
      expect(isValidEmail('test@@gmail.com'), false);
      expect(isValidEmail('test@gmail'), false);
      expect(isValidEmail(''), false);
      expect(isValidEmail('test .email@gmail.com'), false);
    });

    test('should handle edge cases', () {
      expect(isValidEmail('a@b.co'), true); // Minimal valid
      expect(
        isValidEmail('very.long.email.address@very.long.domain.name.com'),
        true,
      );
      // Note: Some email validators may not accept 4-char TLDs like .museum
      // This is a known limitation of simple regex patterns
    });
  });

  group('NIS Validation', () {
    test('should return true for valid NIS', () {
      expect(isValidNIS('12345678'), true); // 8 digits
      expect(isValidNIS('123456789'), true); // 9 digits
      expect(isValidNIS('1234567890'), true); // 10 digits
    });

    test('should return false for invalid NIS', () {
      expect(isValidNIS('123'), false); // Too short
      expect(isValidNIS('12345678901'), false); // Too long
      expect(isValidNIS(''), false); // Empty
      expect(isValidNIS('1234567a'), false); // Contains letter
      expect(isValidNIS('1234 5678'), false); // Contains space
    });

    test('should handle boundary cases', () {
      expect(isValidNIS('1234567'), false); // 7 digits - too short
      expect(isValidNIS('12345678901'), false); // 11 digits - too long
    });
  });

  group('NIP Validation', () {
    test('should return true for valid NIP (16 digits)', () {
      expect(isValidNIP('1234567890123456'), true);
      expect(isValidNIP('9876543210987654'), true);
    });

    test('should return true for valid NIP (18 digits)', () {
      expect(isValidNIP('123456789012345678'), true);
      expect(isValidNIP('987654321098765432'), true);
    });

    test('should return false for invalid NIP', () {
      expect(isValidNIP('123456'), false); // Too short
      expect(isValidNIP('12345678901234567890'), false); // Too long
      expect(isValidNIP('123456789012345'), false); // 15 digits
      expect(isValidNIP('12345678901234567'), false); // 17 digits
      expect(isValidNIP(''), false); // Empty
      expect(isValidNIP('123456789012345a'), false); // Contains letter
      expect(isValidNIP('1234567890 123456'), false); // Contains space
    });

    test('should only accept numeric characters', () {
      expect(isValidNIP('ABCDEFGHIJKLMNOP'), false);
      expect(isValidNIP('12345678-9012345'), false);
    });
  });

  group('Phone Validation', () {
    test('should return true for valid phone numbers', () {
      expect(isValidPhone('081234567890'), true); // 12 digits
      expect(isValidPhone('08123456789'), true); // 11 digits
      expect(isValidPhone('0812345678'), true); // 10 digits
      expect(isValidPhone('628123456789'), true); // International format
      expect(isValidPhone('08123456789012'), true); // 14 digits
      expect(isValidPhone('081234567890123'), true); // 15 digits
    });

    test('should return false for invalid phone numbers', () {
      expect(isValidPhone('123'), false); // Too short
      expect(isValidPhone('08123456789012345'), false); // Too long (16 digits)
      expect(isValidPhone(''), false); // Empty
      expect(isValidPhone('0812345678a'), false); // Contains letter
      expect(isValidPhone('0812-345-678'), false); // Contains dash
      expect(isValidPhone('0812 345 678'), false); // Contains space
    });

    test('should handle boundary cases', () {
      expect(isValidPhone('0123456789'), true); // Exactly 10 digits
      expect(isValidPhone('012345678901234'), true); // Exactly 15 digits
      expect(isValidPhone('012345678'), false); // 9 digits - too short
      expect(isValidPhone('0123456789012345'), false); // 16 digits - too long
    });
  });

  group('Name Validation', () {
    test('should return true for valid names', () {
      expect(isValidName('John Doe'), true);
      expect(isValidName('Ahmad Ridwan'), true);
      expect(isValidName('Siti'), true); // Minimal 3 characters
      expect(isValidName('Dr. Smith'), true);
    });

    test('should return false for invalid names', () {
      expect(isValidName(''), false); // Empty
      expect(isValidName('  '), false); // Only spaces
      expect(isValidName('AB'), false); // Too short
      expect(isValidName('A'), false); // Too short
    });

    test('should trim spaces correctly', () {
      expect(isValidName('   John   '), true); // Leading/trailing spaces
      expect(isValidName('John Doe  '), true);
    });
  });

  group('Password Validation', () {
    test('should return true for valid passwords', () {
      expect(isValidPassword('123456'), true); // Minimal 6 characters
      expect(isValidPassword('password'), true);
      expect(isValidPassword('P@ssw0rd!'), true);
      expect(isValidPassword('verylongpassword123'), true);
    });

    test('should return false for invalid passwords', () {
      expect(isValidPassword(''), false); // Empty
      expect(isValidPassword('12345'), false); // Too short (5 chars)
      expect(isValidPassword('pass'), false); // Too short
    });

    test('should handle boundary case', () {
      expect(isValidPassword('12345'), false); // 5 chars - invalid
      expect(isValidPassword('123456'), true); // 6 chars - valid
    });
  });

  group('Combined Validation Scenarios', () {
    test('should validate complete user data', () {
      // Guru data
      final validTeacher = {
        'email': 'teacher@school.com',
        'nip': '1234567890123456',
        'phone': '081234567890',
        'name': 'Ahmad Ridwan',
      };

      expect(isValidEmail(validTeacher['email']!), true);
      expect(isValidNIP(validTeacher['nip']!), true);
      expect(isValidPhone(validTeacher['phone']!), true);
      expect(isValidName(validTeacher['name']!), true);
    });

    test('should validate complete student data', () {
      // Siswa data
      final validStudent = {
        'email': 'student@school.com',
        'nis': '12345678',
        'phone': '081234567890',
        'name': 'Siti Nurhaliza',
      };

      expect(isValidEmail(validStudent['email']!), true);
      expect(isValidNIS(validStudent['nis']!), true);
      expect(isValidPhone(validStudent['phone']!), true);
      expect(isValidName(validStudent['name']!), true);
    });

    test('should reject invalid combined data', () {
      final invalidUser = {
        'email': 'invalid-email',
        'nip': '123', // Too short
        'phone': '123', // Too short
        'name': 'AB', // Too short
      };

      expect(isValidEmail(invalidUser['email']!), false);
      expect(isValidNIP(invalidUser['nip']!), false);
      expect(isValidPhone(invalidUser['phone']!), false);
      expect(isValidName(invalidUser['name']!), false);
    });
  });

  group('Special Character Handling', () {
    test('should handle Indonesian names correctly', () {
      expect(isValidName('Siti Nurhaliza'), true);
      expect(isValidName('Ahmad Dhani'), true);
      expect(isValidName('Dr. H. Muhammad'), true);
    });

    test('should handle email with dots and dashes', () {
      expect(isValidEmail('user.name@domain.com'), true);
      expect(isValidEmail('user-name@domain.com'), true);
      expect(isValidEmail('user_name@domain.com'), true);
    });
  });

  group('Null Safety', () {
    test('should handle empty strings gracefully', () {
      expect(isValidEmail(''), false);
      expect(isValidNIS(''), false);
      expect(isValidNIP(''), false);
      expect(isValidPhone(''), false);
      expect(isValidName(''), false);
      expect(isValidPassword(''), false);
    });
  });
}
