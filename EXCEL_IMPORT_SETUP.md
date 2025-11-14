# Instructions for Adding Excel Import Functionality

To enable Excel import functionality, add the following packages to your `pubspec.yaml`:

```yaml
dependencies:
  # ... existing dependencies
  file_picker: ^8.0.0+1
  excel: ^4.0.3

dev_dependencies:
  # ... existing dev_dependencies
```

After adding these packages:

1. Run `flutter pub get`
2. Uncomment the import lines in both files:
   - `guru_data_screen.dart`
   - `siswa_data_screen.dart`
3. Implement the actual Excel parsing logic in the `_onImportGuruFromExcel` method

## Data Structure for Excel Import

### Guru Data Fields:
- email
- jenis_kelamin
- mata_pelajaran  
- nama_lengkap
- nig
- password
- photo_url
- sekolah
- status
- tanggal_lahir

### Siswa Data Fields:
- email
- jenis_kelamin
- nama
- nis
- password
- photo_url
- status
- tanggal_lahir

## Firebase Collections Structure

Both collections will use `status` field with values:
- `active` - User is enabled
- `disabled` - User is disabled

The `isDisabled` property in the UI is computed from `status == 'disabled'`.