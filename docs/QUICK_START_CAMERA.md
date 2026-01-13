# 🚀 Quick Start: Camera & Testing

## 📸 Using Camera in Your Code

### Basic Usage
```dart
import 'package:belajarbareng_app_mmp/src/core/services/camera_service.dart';

final cameraService = CameraService();

// Take photo
final photo = await cameraService.takePhoto();

// Pick from gallery
final image = await cameraService.pickFromGallery();

// Validate size (max 5MB)
if (cameraService.isValidImageSize(photo!)) {
  // Upload or use image
}

// Compress if needed
final compressed = await cameraService.compressImage(photo);
```

---

## 🧪 Running Tests

```bash
# All core tests (recommended)
flutter test test/core

# Specific tests
flutter test test/core/services/camera_service_test.dart
flutter test test/core/utils/validators_test.dart
flutter test test/core/services/excel_import_service_test.dart

# With coverage report
flutter test --coverage test/core
```

---

## ✅ Test Results Summary

| Test Suite | Tests | Status |
|-------------|-------|--------|
| CameraService | 16 | ✅ PASSED |
| Validators | 28 | ✅ PASSED |
| ExcelImport | 27 | ✅ PASSED |
| **TOTAL** | **71** | **✅ ALL PASSED** |

---

## 📱 Android Permissions

Already configured in `AndroidManifest.xml`:
- ✅ Camera access
- ✅ Storage read/write
- ✅ Media images (Android 13+)

---

## 🎯 Validation Functions

```dart
// Email
isValidEmail('user@domain.com')  // true

// NIS (8-10 digits)
isValidNIS('12345678')  // true

// NIP (16 or 18 digits)
isValidNIP('1234567890123456')  // true

// Phone (10-15 digits)
isValidPhone('081234567890')  // true
```

---

## 📚 Full Documentation

See [CAMERA_SENSOR_AND_TESTING.md](./CAMERA_SENSOR_AND_TESTING.md) for:
- Complete API reference
- Advanced usage examples
- Test coverage details
- Troubleshooting guide
