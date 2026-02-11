# 🚀 Quick Reference: Google Drive Release Fix

## 🎯 Masalah
Google Drive login gagal di APK release (null exception)

## ⚡ Quick Fix (5 Langkah)

### 1️⃣ Get SHA-1 & SHA-256
```powershell
.\get-sha.ps1
# atau manual:
keytool -list -v -keystore C:/Users/Acer/upload-keystore.jks -alias upload
```

### 2️⃣ Firebase Console
```
https://console.firebase.google.com/
→ Settings → Project settings → Your apps → Android
→ Add fingerprint (SHA-1)
→ Add fingerprint (SHA-256)
→ Save
→ Download google-services.json
→ Replace di: android/app/google-services.json
```

### 3️⃣ Google Cloud Console
```
https://console.cloud.google.com/
→ APIs & Services → Credentials
→ Edit "Android client" OAuth
→ Add SHA-1 fingerprint
→ Save
```

### 4️⃣ Update key.properties
```properties
# File: android/key.properties
storePassword=YOUR_PASSWORD
keyPassword=YOUR_PASSWORD
keyAlias=upload
storeFile=C:/Users/Acer/upload-keystore.jks
```

### 5️⃣ Build & Test
```powershell
.\build-release.ps1
# atau manual:
flutter clean
flutter pub get
flutter build apk --release
adb install build/app/outputs/flutter-apk/app-release.apk
```

---

## 🔍 Quick Troubleshooting

| Error | Solusi |
|-------|--------|
| `SIGN_IN_FAILED` | SHA-1 belum terdaftar atau salah |
| `PlatformException` | Tunggu 5-10 menit setelah update Firebase |
| Dialog tidak muncul | OAuth Client ID belum dikonfigurasi |
| Network error | Check INTERNET permission di AndroidManifest |
| Works di debug only | ProGuard rules (sudah ditambahkan) |

---

## 📁 Files yang Sudah Ditambahkan

✅ `android/app/proguard-rules.pro` - ProGuard config  
✅ `android/key.properties` - Keystore config (update password!)  
✅ `android/app/build.gradle.kts` - Release signing config  
✅ `get-sha.ps1` - Script get SHA fingerprints  
✅ `build-release.ps1` - Script build & install APK  
✅ `docs/troubleshooting/GOOGLE_DRIVE_RELEASE_FIX.md` - Full documentation  

---

## ⚠️ Penting!

- Daftar SHA-1 di **2 tempat**: Firebase Console + Google Cloud Console
- Tunggu **5-10 menit** setelah update untuk propagasi
- Test dengan **APK release** di **real device**, bukan emulator
- **Backup keystore** dan simpan password dengan aman!

---

## 📞 Check Status

```powershell
# Check SHA-1 yang terdaftar
.\get-sha.ps1

# Check APK info
keytool -printcert -jarfile build/app/outputs/flutter-apk/app-release.apk

# Check device connection
adb devices

# Monitor logs
adb logcat -s flutter,GoogleSignIn
```

---

## ✅ Verification Checklist

- [ ] SHA-1 & SHA-256 didapat dari release keystore
- [ ] SHA-1 & SHA-256 ditambahkan di Firebase Console
- [ ] SHA-1 ditambahkan di Google Cloud Console (OAuth)
- [ ] google-services.json di-download ulang
- [ ] key.properties diisi dengan password yang benar
- [ ] Tunggu 5-10 menit
- [ ] Build release APK
- [ ] Test di real device
- [ ] Google Drive login berhasil ✅

---

**Estimated Time:** 15-20 menit  
**Success Rate:** 99% jika mengikuti semua langkah
