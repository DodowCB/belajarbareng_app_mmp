# 🚀 Quick Start - Google Drive Integration

## ✅ File yang Sudah Dibuat

1. **`lib/google_drive_options.dart`** - Konfigurasi Client ID (seperti firebase_options.dart)
2. **`lib/src/core/services/google_drive_service.dart`** - Service untuk operasi Google Drive
3. **`lib/src/features/auth/presentation/halamanGuru/component/upload_materi_screen.dart`** - UI untuk upload materi
4. **`docs/GOOGLE_DRIVE_SETUP.md`** - Dokumentasi lengkap setup dan penggunaan

## 📝 Langkah Setup (WAJIB)

### 1. Dapatkan Client ID dari Google Cloud Console

#### Untuk Web:
```bash
1. Buka https://console.cloud.google.com/
2. Pilih project Firebase Anda
3. Go to: APIs & Services > Credentials
4. Create Credentials > OAuth client ID > Web application
5. Authorized JavaScript origins: http://localhost:5140
6. Copy Client ID
```

#### Untuk Android:
```bash
1. Dapatkan SHA-1 dengan command:
   keytool -list -v -keystore "C:\Users\YourUsername\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android

2. Di Google Cloud Console:
   - Create Credentials > OAuth client ID > Android
   - Package name: com.example.belajarbareng_app_mmp
   - Paste SHA-1
   - Copy Client ID
```

### 2. Update google_drive_options.dart

Edit `lib/google_drive_options.dart` baris 45-48:

```dart
static const GoogleDriveOptions _instance = GoogleDriveOptions(
  androidClientId: 'PASTE_ANDROID_CLIENT_ID_HERE.apps.googleusercontent.com',
  webClientId: 'PASTE_WEB_CLIENT_ID_HERE.apps.googleusercontent.com',
  iosClientId: 'PASTE_IOS_CLIENT_ID_HERE.apps.googleusercontent.com', // Optional
  apiKey: 'YOUR_API_KEY', // Optional
  scopes: [
    'https://www.googleapis.com/auth/drive.file',
    'https://www.googleapis.com/auth/drive.appdata',
  ],
);
```

### 3. Enable Google Drive API

```bash
1. Di Google Cloud Console
2. Go to: APIs & Services > Library
3. Search "Google Drive API"
4. Click Enable
```

### 4. Test Aplikasi

```bash
flutter run -d chrome --web-port=5140
```

Atau untuk Android:
```bash
flutter run -d android
```

## 🎯 Cara Menggunakan

### Upload Materi:
1. Login sebagai Guru
2. Di Dashboard, klik **"Unggah Materi Baru"**
3. Klik **"Sign in to Google Drive"**
4. Isi form:
   - Judul Materi
   - Deskripsi
   - Pilih Kelas
   - Pilih Mata Pelajaran
5. Klik **"Pilih File untuk Upload"**
6. Pilih file (PDF, DOC, PPT, XLS, JPG, PNG, MP4, ZIP)
7. Klik **"Simpan Materi"**

## 🎨 Fitur yang Tersedia

### ✅ Sudah Diimplementasikan:
- ✅ Upload file ke Google Drive
- ✅ Sign in/out dengan Google account
- ✅ List uploaded files
- ✅ Delete files from list
- ✅ Simpan metadata ke Firestore
- ✅ Form validation
- ✅ File type icons
- ✅ File size formatting
- ✅ Support multiple files per materi
- ✅ Dark mode support

### 🚀 Bisa Ditambahkan:
- Download file dari Drive
- Share file dengan link
- Organize files dalam folder
- Search files
- View file thumbnail
- Preview PDF/images
- File versioning
- Batch upload
- Progress indicator untuk upload
- Compress files sebelum upload

## 📦 Dependencies (Sudah Ada)

```yaml
google_sign_in: ^6.2.1  ✅
http: ^1.2.2  ✅
file_picker: ^8.0.0+1  ✅
cloud_firestore: ^5.4.4  ✅
```

Tidak perlu install dependency tambahan!

## 🔥 Firestore Structure

### Collection: `materi`

```json
{
  "id": "1",
  "judul": "Materi Matematika Bab 1",
  "deskripsi": "Pengenalan Aljabar",
  "id_guru": "guru_123",
  "id_kelas": "kelas_10_ipa_1",
  "id_mapel": "matematika",
  "files": [
    {
      "id": "1a2b3c4d5e6f",
      "name": "materi_aljabar.pdf",
      "mimeType": "application/pdf",
      "size": 2048000,
      "webViewLink": "https://drive.google.com/file/d/1a2b3c4d5e6f/view"
    }
  ],
  "createdAt": Timestamp,
  "updatedAt": Timestamp
}
```

## 🛡️ Security & Best Practices

1. **Jangan commit Client ID ke public repo**
   - Gunakan environment variables
   - Add `.env` ke `.gitignore`

2. **Validate file types**
   - Check MIME type di backend
   - Scan untuk malware

3. **Monitor quota**
   - Free tier: 15 GB storage
   - 1,000 API requests per 100 seconds

4. **Use minimal scopes**
   - `drive.file` = Access only to files created by app
   - `drive` = Full access (tidak disarankan)

## 📱 Testing Checklist

- [ ] Sign in to Google Drive works
- [ ] File picker opens correctly
- [ ] File uploads to Drive
- [ ] File appears in uploaded list
- [ ] Delete file from list works
- [ ] Form validation works
- [ ] Save to Firestore successful
- [ ] Data appears in Firebase Console
- [ ] Sign out works
- [ ] Works on Android
- [ ] Works on Web
- [ ] Dark mode works

## 🐛 Common Issues

### "Not authenticated"
→ Sign in to Google Drive first

### "Invalid client"
→ Check Client ID di `google_drive_options.dart`

### "Access denied"
→ Enable Google Drive API di Cloud Console

### Upload stuck
→ Check internet connection dan file size

## 📚 Resources

- [Google Drive API Docs](https://developers.google.com/drive/api/v3/about-sdk)
- [OAuth 2.0 Setup](https://developers.google.com/identity/protocols/oauth2)
- [File Types](https://developers.google.com/drive/api/v3/mime-types)
- [Quota Limits](https://developers.google.com/drive/api/v3/limits)

---

**Need Help?** Check `docs/GOOGLE_DRIVE_SETUP.md` untuk dokumentasi lengkap!
