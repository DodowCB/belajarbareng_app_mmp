# Google Drive Integration Guide

## Setup Google Drive API

### 1. Buka Google Cloud Console
https://console.cloud.google.com/

### 2. Create atau Select Project
- Pilih project yang sama dengan Firebase Anda
- Atau buat project baru

### 3. Enable Google Drive API
1. Go to **APIs & Services** > **Library**
2. Search "Google Drive API"
3. Click **Enable**

### 4. Create OAuth 2.0 Credentials

#### Untuk Android:
1. Go to **APIs & Services** > **Credentials**
2. Click **Create Credentials** > **OAuth client ID**
3. Select **Android**
4. Package name: `com.example.belajarbareng_app_mmp` (sesuaikan dengan package Anda)
5. SHA-1: Dapatkan dengan command:
   ```bash
   keytool -list -v -keystore "C:\Users\YourUsername\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android
   ```
6. Copy **Client ID** yang dihasilkan

#### Untuk Web:
1. Go to **APIs & Services** > **Credentials**
2. Click **Create Credentials** > **OAuth client ID**
3. Select **Web application**
4. Authorized JavaScript origins:
   - `http://localhost`
   - `http://localhost:5140` (port yang Anda gunakan)
5. Authorized redirect URIs:
   - `http://localhost`
   - `http://localhost:5140`
6. Copy **Client ID** yang dihasilkan

#### Untuk iOS (Optional):
1. Create OAuth client ID untuk iOS
2. Bundle ID: dari `ios/Runner.xcodeproj`
3. Copy **Client ID**

### 5. Update google_drive_options.dart

Edit file `lib/google_drive_options.dart`:

```dart
static const GoogleDriveOptions _instance = GoogleDriveOptions(
  androidClientId: 'PASTE_YOUR_ANDROID_CLIENT_ID_HERE',
  webClientId: 'PASTE_YOUR_WEB_CLIENT_ID_HERE',
  iosClientId: 'PASTE_YOUR_IOS_CLIENT_ID_HERE',
  apiKey: 'YOUR_API_KEY', // Optional
  scopes: [
    'https://www.googleapis.com/auth/drive.file',
    'https://www.googleapis.com/auth/drive.appdata',
  ],
);
```

### 6. Test Upload

1. Run aplikasi
2. Login sebagai Guru
3. Navigate ke **Upload Materi**
4. Click **Sign in to Google Drive**
5. Pilih file dan upload

## Fitur Google Drive yang Tersedia

### 1. Upload File
```dart
final result = await GoogleDriveService().uploadFile(
  filePath: '/path/to/file',
  fileName: 'document.pdf',
  description: 'My document',
);
```

### 2. Download File
```dart
final bytes = await GoogleDriveService().downloadFile(fileId);
```

### 3. List Files
```dart
final result = await GoogleDriveService().listFiles(
  pageSize: 100,
  folderId: 'optional_folder_id',
);
```

### 4. Search Files
```dart
final files = await GoogleDriveService().searchFiles('keyword');
```

### 5. Delete File
```dart
await GoogleDriveService().deleteFile(fileId);
```

### 6. Create Folder
```dart
final folder = await GoogleDriveService().createFolder(
  folderName: 'Materi Kelas 10',
  description: 'Folder untuk materi',
);
```

### 7. Share File
```dart
await GoogleDriveService().shareFile(
  fileId: 'file_id',
  role: 'reader', // reader, writer, commenter
  type: 'anyone', // anyone, user, group, domain
);
```

### 8. Get File Metadata
```dart
final metadata = await GoogleDriveService().getFileMetadata(fileId);
```

## File Types Supported

### Documents
- PDF (`.pdf`)
- Word (`.doc`, `.docx`)
- Excel (`.xls`, `.xlsx`)
- PowerPoint (`.ppt`, `.pptx`)
- Text (`.txt`)

### Media
- Images (`.jpg`, `.jpeg`, `.png`, `.gif`, `.bmp`, `.svg`)
- Videos (`.mp4`, `.avi`, `.mov`, `.wmv`)
- Audio (`.mp3`, `.wav`)

### Archives
- ZIP (`.zip`)
- RAR (`.rar`)
- 7Z (`.7z`)

## Storage di Firestore

Data materi disimpan di collection `materi`:

```json
{
  "id": "1",
  "judul": "Materi Matematika Bab 1",
  "deskripsi": "Pengenalan Aljabar",
  "id_guru": "guru_id",
  "id_kelas": "kelas_id",
  "id_mapel": "mapel_id",
  "files": [
    {
      "id": "google_drive_file_id",
      "name": "materi.pdf",
      "mimeType": "application/pdf",
      "size": 1024000,
      "webViewLink": "https://drive.google.com/file/d/..."
    }
  ],
  "createdAt": Timestamp,
  "updatedAt": Timestamp
}
```

## Troubleshooting

### Error: "Not authenticated"
- Pastikan sudah sign in ke Google Drive
- Check apakah Client ID sudah benar

### Error: "Invalid client"
- Verify Client ID di `google_drive_options.dart`
- Pastikan OAuth consent screen sudah dikonfigurasi

### Error: "Access denied"
- Check scopes yang diminta
- Pastikan user memberikan izin akses

### Upload gagal
- Check koneksi internet
- Verify file path dan file exists
- Check file size limit (5TB per file di Drive)

## Security Notes

1. **Jangan commit Client ID ke public repository**
   - Gunakan environment variables untuk production
   - Add `.env` file ke `.gitignore`

2. **Validate file types di backend**
   - Check MIME type
   - Scan untuk malware

3. **Implement rate limiting**
   - Batasi jumlah upload per user
   - Monitor quota usage

4. **Use secure scopes**
   - Gunakan scope minimal yang dibutuhkan
   - `drive.file` lebih aman dari `drive` (full access)

## Quota & Limits

- **Storage**: 15 GB gratis per akun Google
- **File size**: Max 5 TB per file
- **API calls**: 
  - 1,000 requests per 100 seconds per user
  - 10,000 requests per 100 seconds per project

Untuk quota lebih besar, upgrade ke Google Workspace.
