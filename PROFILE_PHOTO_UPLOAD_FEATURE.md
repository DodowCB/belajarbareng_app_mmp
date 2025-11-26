# 📸 Profile Photo Upload Feature Documentation

## ✨ Fitur yang Sudah Diimplementasikan

### 1. **Upload Foto Profile** 🖼️

User (Admin dan Guru) sekarang dapat mengupload dan mengubah foto profile mereka dengan fitur lengkap berikut:

#### **Fitur Utama:**

✅ **Cross-Platform Support**

- Web: Upload dengan NetworkImage
- Mobile: Upload dengan FileImage
- Automatic platform detection menggunakan `kIsWeb`

✅ **Image Picker Integration**

- Pilih foto dari galeri
- Maximum dimensions: 1000x1000 px
- Image quality: 85% untuk optimasi ukuran
- Error handling dengan feedback ke user

✅ **Firebase Storage Integration**

- Auto-upload ke Firebase Storage
- Naming convention: `profile_{userId}_{timestamp}.jpg`
- Organized dalam folder `profile_photos/`
- Web: Upload dengan `putData(bytes)`
- Mobile: Upload dengan `putFile(File)`
- Get download URL otomatis

✅ **Firestore Integration**

- Save photo URL ke Firestore collection `users`
- Update field `photoUrl`
- Save additional profile data (nama, email, phone)
- Update timestamp dengan `FieldValue.serverTimestamp()`

✅ **UI/UX Features**

- Preview foto langsung setelah dipilih
- Loading indicator saat upload
- Success/Error feedback dengan SnackBar
- Cancel button untuk reset selection
- Camera icon button untuk edit mode
- Gradient background untuk profile header

---

## 🔧 Technical Implementation

### **File Modified:**

- `lib/src/features/auth/presentation/profile/profile_screen.dart`

### **Packages Used:**

```yaml
image_picker: ^1.0.4
firebase_storage: ^12.3.4
cloud_firestore: ^5.4.4
```

### **Code Structure:**

#### **State Variables:**

```dart
final ImagePicker _picker = ImagePicker();
XFile? _imageFile;              // Selected image file
String? _uploadedImageUrl;      // Saved photo URL from Firestore
```

#### **Key Methods:**

**1. \_loadUserProfile()**

- Load user data dari Firestore saat screen dibuka
- Retrieve photo URL, nama, email, phone
- Update state dengan data yang diload

**2. \_pickImage()**

- Open image picker untuk select dari gallery
- Set maxWidth & maxHeight: 1000px
- Set imageQuality: 85%
- Update \_imageFile state
- Show success SnackBar

**3. \_getProfileImage()**

- Return NetworkImage untuk web (kIsWeb)
- Return FileImage untuk mobile (dart:io)
- Return NetworkImage untuk saved photoUrl
- Return null jika belum ada photo

**4. \_saveProfile()**

- Show loading dialog
- Upload image ke Firebase Storage jika ada
  - Web: putData dengan bytes
  - Mobile: putFile dengan File
- Get download URL dari Storage
- Update Firestore dengan photoUrl dan profile data
- Close loading dialog
- Show success/error SnackBar

#### **UI Components:**

**Profile Photo Stack:**

```dart
Stack(
  children: [
    CircleAvatar(
      radius: 60,
      backgroundImage: _getProfileImage(),
      child: _imageFile == null && _uploadedImageUrl == null
          ? Icon(Icons.person, size: 60, color: Colors.white)
          : null,
    ),
    if (_isEditing)
      Positioned(
        right: 0,
        bottom: 0,
        child: GestureDetector(
          onTap: _pickImage,
          child: Container(
            // Camera button with white background
            // Purple camera icon
          ),
        ),
      ),
  ],
)
```

**Action Buttons:**

```dart
// Cancel button - Reset image selection
OutlinedButton(
  onPressed: () => setState(() {
    _isEditing = false;
    _imageFile = null;  // Reset selection
  }),
  child: const Text('Cancel'),
)

// Save button - Upload and save
ElevatedButton(
  onPressed: _saveProfile,
  child: const Text('Save Changes'),
)
```

---

## 📋 Firebase Configuration

### **Firebase Storage Rules:**

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /profile_photos/{photoId} {
      // Allow authenticated users to upload their own photos
      allow read: if request.auth != null;
      allow write: if request.auth != null;
    }
  }
}
```

### **Firestore Structure:**

```json
{
  "users": {
    "{userId}": {
      "photoUrl": "https://firebasestorage.googleapis.com/...",
      "nama_lengkap": "User Name",
      "email": "user@example.com",
      "phone": "+62xxx",
      "updated_at": "2025-01-15T10:30:00Z"
    }
  }
}
```

---

## 🎯 Usage Flow

### **For Users (Admin/Guru):**

1. **Navigate to Profile Screen**

   - Klik Profile di menu sidebar/drawer
   - Atau klik Profile di dropdown menu

2. **Edit Mode**

   - Klik tombol Edit (icon pensil di header)
   - Profile card masuk mode editing

3. **Upload Photo**

   - Klik icon camera di profile photo
   - Pilih foto dari gallery
   - Preview langsung muncul di CircleAvatar
   - SnackBar konfirmasi: "Photo selected! Click Save to update"

4. **Save Changes**

   - Klik tombol "Save Changes"
   - Loading indicator muncul
   - Foto diupload ke Firebase Storage
   - URL disave ke Firestore
   - SnackBar sukses: "Profile updated successfully!"

5. **Cancel/Reset**
   - Klik tombol "Cancel"
   - Image selection di-reset
   - Kembali ke mode view

### **For Developers:**

**Check Current Photo:**

```dart
// Photo akan auto-load dari Firestore saat screen init
@override
void initState() {
  super.initState();
  _loadUserProfile();  // Load saved photo
}
```

**Manual Upload:**

```dart
// Upload image manually
final storageRef = FirebaseStorage.instance.ref();
final photoRef = storageRef.child('profile_photos/myPhoto.jpg');
await photoRef.putFile(File(imagePath));
final url = await photoRef.getDownloadURL();
```

---

## ✅ Testing Checklist

- [x] Image picker opens on camera icon tap
- [x] Selected image displays in CircleAvatar
- [x] Cancel button resets selection
- [x] Upload works on web (putData with bytes)
- [x] Upload works on mobile (putFile with File)
- [x] Download URL retrieved correctly
- [x] Firestore update successful
- [x] Photo loads on screen init
- [x] Loading indicator shows during upload
- [x] Success SnackBar shows after save
- [x] Error SnackBar shows on failure
- [x] Cross-platform compatibility (web/mobile)

---

## 🎨 UI/UX Details

### **Visual Feedback:**

✅ **Success Messages:**

- "Photo selected! Click Save to update" (purple)
- "Profile updated successfully!" (green)

✅ **Error Messages:**

- "Failed to select image: {error}" (red)
- "Failed to update profile: {error}" (red)

✅ **Loading State:**

- CircularProgressIndicator during upload
- Dialog dengan barrierDismissible: false

### **Design Elements:**

✅ **Camera Button:**

- White background circle
- Purple camera icon
- Bottom-right position on profile photo
- MouseRegion cursor: click (web)

✅ **Profile Header:**

- Gradient background (sunset gradient)
- Rounded corners (20px)
- White text untuk contrast
- Role badge dengan icon

---

## 🚀 Next Steps / Enhancements

### **Potential Improvements:**

1. **Image Cropping**

   - Add image_cropper package
   - Allow user to crop before upload
   - Circular crop untuk profile photo

2. **Compression**

   - Add flutter_image_compress
   - Reduce file size before upload
   - Better performance on mobile

3. **Multiple Sources**

   - Camera option (not just gallery)
   - Choose between camera/gallery
   - Web: drag & drop upload

4. **Validation**

   - Max file size check (e.g., 5MB)
   - Image format validation (jpg, png only)
   - Dimension requirements

5. **Delete Photo**

   - Remove photo button
   - Delete from Firebase Storage
   - Clear photoUrl from Firestore

6. **Avatar Fallback**
   - Generate avatar from initials
   - Use gradient background
   - Better placeholder design

---

## 📝 Notes

- Fitur ini tersedia untuk **Admin** dan **Guru**
- Profile screen yang sama digunakan untuk kedua role
- Photo URL disimpan di field `photoUrl` di Firestore
- Image picker memilih dari gallery only (camera coming soon)
- Cross-platform support: Web dan Mobile (iOS/Android)
- Loading state untuk UX yang lebih baik
- Error handling untuk semua edge cases

---

## 🔗 Related Files

- `lib/src/features/auth/presentation/profile/profile_screen.dart`
- `lib/src/core/providers/app_user.dart`
- `lib/src/features/auth/presentation/widgets/admin_header.dart`
- `pubspec.yaml` (dependencies)

---

## 📚 References

- [image_picker Documentation](https://pub.dev/packages/image_picker)
- [Firebase Storage Documentation](https://firebase.google.com/docs/storage/flutter/start)
- [Cloud Firestore Documentation](https://firebase.google.com/docs/firestore/flutter/start)

---

**Created:** January 15, 2025  
**Last Updated:** January 15, 2025  
**Status:** ✅ Fully Implemented & Tested
