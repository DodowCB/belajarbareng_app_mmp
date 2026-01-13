# Camera Sensor untuk Pengumuman - Admin Panel

## 📸 Fitur Implementasi

Fitur camera sensor telah berhasil diimplementasikan untuk halaman pengumuman admin, memungkinkan admin untuk menambahkan foto/gambar saat membuat pengumuman baru.

## ✅ Fitur yang Sudah Diimplementasikan

### 1. **Camera Integration dalam Add Pengumuman Dialog**
   - ✅ Pilihan untuk ambil foto dari kamera
   - ✅ Pilihan untuk pilih foto dari galeri
   - ✅ Preview gambar sebelum di-upload
   - ✅ Validasi ukuran gambar (maksimal 5MB)
   - ✅ Menampilkan ukuran file gambar
   - ✅ Tombol delete untuk menghapus gambar yang dipilih

### 2. **Firebase Storage Upload**
   - ✅ Auto-upload gambar ke Firebase Storage
   - ✅ Path: `pengumuman_images/pengumuman_{id}_{timestamp}.jpg`
   - ✅ Mendapatkan download URL otomatis
   - ✅ Error handling jika upload gagal

### 3. **Model Update**
   - ✅ PengumumanModel ditambahkan field `imageUrl`
   - ✅ Update fromFirestore untuk handle imageUrl
   - ✅ Update toMap untuk save imageUrl
   - ✅ Update copyWith untuk imageUrl

### 4. **Event & BLoC Update**
   - ✅ AddPengumuman event ditambahkan parameter `imagePath`
   - ✅ PengumumanBloc handle upload image ke Firebase Storage
   - ✅ Save imageUrl ke Firestore setelah upload berhasil

### 5. **UI Display**
   - ✅ Pengumuman detail dialog menampilkan gambar jika ada
   - ✅ Loading indicator saat gambar diload
   - ✅ Error handling jika gagal load gambar
   - ✅ Responsive design dengan max height 300px

## 🎯 Cara Penggunaan

### Untuk Admin:

1. **Buka Halaman Pengumuman**
   - Navigate ke halaman admin pengumuman

2. **Tambah Pengumuman Baru**
   - Klik tombol "+" untuk membuat pengumuman baru
   - Isi judul dan deskripsi pengumuman

3. **Menambahkan Gambar**
   - **Opsi 1 - Ambil Foto dari Kamera:**
     - Klik tombol "Ambil Foto" (ikon kamera)
     - Izinkan akses kamera jika diminta
     - Ambil foto
     
   - **Opsi 2 - Pilih dari Galeri:**
     - Klik tombol "Pilih dari Galeri" (ikon folder)
     - Izinkan akses galeri jika diminta
     - Pilih foto yang diinginkan

4. **Preview & Validasi**
   - Gambar akan muncul di preview area
   - Ukuran file ditampilkan di bawah gambar
   - Jika ukuran > 5MB, akan muncul error message
   - Klik icon "×" untuk menghapus gambar

5. **Submit Pengumuman**
   - Klik tombol "Add" untuk submit
   - Gambar akan otomatis di-upload ke Firebase Storage
   - Pengumuman akan tersimpan dengan link gambar

## 📱 Permissions Required

File `AndroidManifest.xml` sudah dikonfigurasi dengan permissions:

```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES" />
```

## 🏗️ Arsitektur & File Changes

### Files Modified:

1. **pengumuman_event.dart**
   - Added `imagePath` parameter to `AddPengumuman` event

2. **pengumuman_model.dart**
   - Added `imageUrl` field
   - Updated `fromFirestore`, `toMap`, `copyWith` methods

3. **pengumuman_bloc.dart**
   - Added `dart:io` and `firebase_storage` imports
   - Implemented image upload logic in `_onAddPengumuman`
   - Upload to `pengumuman_images/{filename}`

4. **pengumuman_screen.dart**
   - Added `dart:io` and `CameraService` imports
   - Added `_selectedImage` state variable in dialog
   - Added camera and gallery buttons
   - Added image preview section
   - Added image size validation
   - Updated `_submitPengumuman` to pass image path
   - Updated detail dialog to display image

## 🔧 Technical Details

### Image Upload Flow:
```
1. User selects image (camera/gallery)
   ↓
2. Validate size (max 5MB)
   ↓
3. Show preview
   ↓
4. User submits form
   ↓
5. BLoC uploads to Firebase Storage
   ↓
6. Get download URL
   ↓
7. Save to Firestore with imageUrl
```

### Storage Structure:
```
Firebase Storage
└── pengumuman_images/
    ├── pengumuman_1_1234567890.jpg
    ├── pengumuman_2_1234567891.jpg
    └── ...
```

### Firestore Document:
```json
{
  "judul": "Pengumuman Title",
  "deskripsi": "Description...",
  "pembuat": "admin",
  "imageUrl": "https://firebasestorage.googleapis.com/...",
  "createdAt": "Timestamp",
  "updatedAt": null
}
```

## 🧪 Testing

### Manual Testing Checklist:
- ✅ Camera access permission
- ✅ Gallery access permission
- ✅ Image capture from camera
- ✅ Image selection from gallery
- ✅ Image preview display
- ✅ File size validation (>5MB)
- ✅ Delete selected image
- ✅ Upload to Firebase Storage
- ✅ Save URL to Firestore
- ✅ Display image in detail view
- ✅ Loading indicator
- ✅ Error handling

### Unit Tests:
Refer to `test/core/services/camera_service_test.dart` untuk testing CameraService yang digunakan dalam fitur ini.

## 🎨 UI Components

### Add Pengumuman Dialog:
- Title and Description text fields
- Image preview (if selected)
  - 200px height
  - Rounded corners
  - Delete button overlay
- File size display
- Camera button (orange outline)
- Gallery button (orange outline)
- Cancel and Add buttons

### Detail Pengumuman Dialog:
- Title
- Image (if available)
  - Max 300px height
  - Fit contain
  - Loading indicator
  - Error fallback
- Description
- Posted by
- Date & Time
- Edit button

## 🚀 Future Enhancements

Potential improvements yang bisa ditambahkan:

1. **Multiple Images**
   - Support untuk upload multiple images per pengumuman
   - Image gallery/slider untuk menampilkan semua gambar

2. **Image Editing**
   - Crop image sebelum upload
   - Apply filters
   - Resize/rotate image

3. **Compression**
   - Auto-compress image sebelum upload untuk menghemat storage
   - Thumbnail generation untuk preview

4. **Delete Image**
   - Kemampuan untuk delete image dari Firebase Storage saat edit/delete pengumuman

5. **Image Cache**
   - Cache downloaded images untuk improve performance

## 📝 Notes

- Image diupload dengan nama unik: `pengumuman_{id}_{timestamp}.jpg`
- Maksimal ukuran file: 5MB
- Format yang didukung: JPG, PNG (semua format yang didukung image_picker)
- Jika upload image gagal, pengumuman tetap akan tersimpan tanpa gambar
- Image URL disimpan sebagai String nullable di Firestore

## 🐛 Troubleshooting

### Camera tidak muncul:
- Pastikan permissions sudah di-grant di device settings
- Pastikan device memiliki kamera
- Restart aplikasi setelah grant permission

### Upload gagal:
- Check koneksi internet
- Pastikan Firebase Storage sudah dikonfigurasi
- Check Firebase Storage rules

### Gambar tidak muncul di detail:
- Check imageUrl di Firestore
- Check Firebase Storage public access
- Check network connectivity

## 📚 Dependencies Used

```yaml
dependencies:
  image_picker: ^1.0.7  # Camera & Gallery access
  firebase_storage: ^11.6.0  # Upload to Firebase Storage
  cloud_firestore: ^4.15.0  # Save to Firestore
```

## ✨ Conclusion

Fitur camera sensor untuk pengumuman sudah fully implemented dan tested. Admin sekarang bisa menambahkan gambar visual ke pengumuman untuk membuat komunikasi lebih engaging dan informatif.
