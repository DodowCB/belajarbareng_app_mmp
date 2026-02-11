# 🔧 Fix Google Drive Login di APK Release

## ❌ Masalah
Google Drive login gagal atau null exception di APK release, tapi berjalan normal di debug mode.

---

## 🎯 Penyebab Utama (90% kasus)

### **SHA-1/SHA-256 Certificate Fingerprint Tidak Terdaftar**

Google Sign In memerlukan SHA-1 certificate fingerprint dari keystore yang digunakan untuk sign APK.

**Debug mode:** Menggunakan `debug.keystore` (sudah auto-configured)  
**Release mode:** Menggunakan `upload-keystore.jks` (HARUS didaftarkan manual!)

---

## ✅ Solusi Lengkap

### **STEP 1: Generate Release Keystore** (Skip jika sudah punya)

```powershell
# Generate keystore baru
keytool -genkey -v -keystore C:/Users/Acer/upload-keystore.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias upload

# Masukkan informasi:
# Password: [SIMPAN PASSWORD INI!]
# Name: Your Name
# Organization: Your Company
# City: Jakarta
# State: DKI Jakarta
# Country: ID
```

---

### **STEP 2: Get SHA-1 & SHA-256 dari Release Keystore**

```powershell
# Get fingerprints dari RELEASE keystore
keytool -list -v -keystore C:/Users/Acer/upload-keystore.jks -alias upload

# Masukkan password keystore
# Output akan berisi:
```

```
Certificate fingerprints:
  SHA1: AA:BB:CC:DD:EE:FF:00:11:22:33:44:55:66:77:88:99:AA:BB:CC:DD
  SHA256: 11:22:33:44:55:66:77:88:99:AA:BB:CC:DD:EE:FF:00:11:22:33:44:55:66:77:88:99:AA:BB:CC:DD:EE:FF:00:11
```

**❗ COPY SHA-1 dan SHA-256 ini!**

---

### **STEP 3: Daftarkan SHA-1/SHA-256 di Firebase Console**

#### A. Firebase Console

```
1. Buka: https://console.firebase.google.com/
2. Pilih project Anda
3. Klik ⚙️ (Settings) > Project settings
4. Tab "General"
5. Scroll ke section "Your apps"
6. Pilih Android app (ikon Android)
7. Klik "Add fingerprint"
8. Paste SHA-1 dari RELEASE keystore
9. Klik "Save"
10. Klik "Add fingerprint" lagi
11. Paste SHA-256 dari RELEASE keystore
12. Klik "Save"
```

#### B. Download google-services.json Terbaru

```
1. Masih di halaman yang sama
2. Klik "Download google-services.json"
3. Replace file di: android/app/google-services.json
```

---

### **STEP 4: Daftarkan SHA-1 di Google Cloud Console** (PENTING!)

```
1. Buka: https://console.cloud.google.com/
2. Pilih project yang sama dengan Firebase
3. Navigation menu > APIs & Services > Credentials
4. Cari "OAuth 2.0 Client IDs"
5. Klik Edit (icon pensil) pada "Android client"
6. Di section "SHA-1 certificate fingerprints"
7. Klik "Add fingerprint"
8. Paste SHA-1 dari RELEASE keystore
9. Klik "Save"
```

**⚠️ Tunggu 5-10 menit setelah save untuk propagasi perubahan!**

---

### **STEP 5: Update key.properties**

Edit file: `android/key.properties`

```properties
storePassword=GANTI_DENGAN_PASSWORD_ANDA
keyPassword=GANTI_DENGAN_PASSWORD_ANDA
keyAlias=upload
storeFile=C:/Users/Acer/upload-keystore.jks
```

**⚠️ JANGAN commit file ini ke Git! Sudah ditambahkan ke .gitignore**

---

### **STEP 6: Clean & Build APK Release**

```powershell
# Clean project
flutter clean

# Get dependencies
flutter pub get

# Build release APK
flutter build apk --release

# Output: build/app/outputs/flutter-apk/app-release.apk
```

---

### **STEP 7: Test di Real Device**

```powershell
# Install APK ke device
adb install build/app/outputs/flutter-apk/app-release.apk

# Atau transfer APK manual ke device dan install
```

---

## 🔍 Troubleshooting

### Problem 1: "SIGN_IN_FAILED" atau "PlatformException"

**Penyebab:** SHA-1 belum terdaftar atau salah

**Solusi:**
```powershell
# 1. Pastikan SHA-1 yang didaftarkan benar
keytool -list -v -keystore C:/Users/Acer/upload-keystore.jks -alias upload

# 2. Cek di Firebase Console: Settings > Your apps > Android
#    Pastikan SHA-1 yang terdaftar SAMA dengan output di atas

# 3. Tunggu 5-10 menit setelah menambahkan SHA-1
```

---

### Problem 2: Google Sign In dialog tidak muncul

**Penyebab:** OAuth Client ID tidak dikonfigurasi

**Solusi:**
```
1. Google Cloud Console > APIs & Services > Credentials
2. Pastikan ada "Android client" dengan SHA-1 yang benar
3. Jika tidak ada, buat baru:
   - Click "Create Credentials" > "OAuth client ID"
   - Type: Android
   - Name: Android Client
   - Package name: com.example.belajarbareng_app_mmp
   - SHA-1: [paste SHA-1 dari keystore]
```

---

### Problem 3: "Network Error" atau timeout

**Penyebab:** Internet permission atau Google Play Services

**Solusi:**
```xml
<!-- Cek AndroidManifest.xml sudah ada: -->
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
```

```
Dan pastikan Google Play Services update di device:
- Buka Settings > Apps > Google Play Services
- Update jika ada versi baru
```

---

### Problem 4: Works di debug, fails di release

**Penyebab:** ProGuard menghapus kode Google Sign In

**Solusi:** File `proguard-rules.pro` sudah ditambahkan otomatis. Pastikan `build.gradle.kts` sudah update dengan config yang benar.

---

### Problem 5: "API not enabled"

**Penyebab:** Google Drive API belum diaktifkan

**Solusi:**
```
1. Google Cloud Console > APIs & Services > Library
2. Cari "Google Drive API"
3. Klik "Enable"
4. Tunggu beberapa menit
```

---

## 📋 Checklist Final

Sebelum build & deploy, pastikan:

- [ ] Release keystore sudah dibuat (`upload-keystore.jks`)
- [ ] SHA-1 & SHA-256 sudah didapatkan dari release keystore
- [ ] SHA-1 & SHA-256 sudah ditambahkan di Firebase Console
- [ ] SHA-1 sudah ditambahkan di Google Cloud Console (OAuth Client ID)
- [ ] `google-services.json` sudah di-download ulang dan di-replace
- [ ] `key.properties` sudah diisi dengan password yang benar
- [ ] `proguard-rules.pro` sudah ditambahkan
- [ ] `build.gradle.kts` sudah update dengan signing config
- [ ] AndroidManifest.xml sudah ada INTERNET permission
- [ ] Tunggu 5-10 menit setelah perubahan di Firebase/GCloud
- [ ] Test di real device dengan APK release

---

## 🎯 Quick Test Commands

```powershell
# Full build & install pipeline
flutter clean
flutter pub get
flutter build apk --release
adb install -r build/app/outputs/flutter-apk/app-release.apk

# Check logs real-time
adb logcat -s flutter,GoogleSignIn,GoogleAuth
```

---

## 📱 Verifikasi di Device

Setelah install APK release:

```
1. Buka app
2. Login dengan email
3. Klik fitur yang menggunakan Google Drive
4. Popup Google Sign In harus muncul
5. Pilih account Google
6. Allow permissions
7. ✅ Login berhasil!
```

---

## 🔑 Poin Penting

1. **SHA-1 Release vs Debug BERBEDA!**
   - Debug: Auto-configured
   - Release: HARUS daftar manual

2. **Daftar di 2 Tempat:**
   - Firebase Console (untuk Firebase Auth)
   - Google Cloud Console (untuk OAuth)

3. **Tunggu Propagasi:**
   - Perubahan butuh 5-10 menit untuk aktif
   - Jangan langsung test setelah update

4. **Keep Keystore Safe:**
   - Backup `upload-keystore.jks`
   - Simpan password dengan aman
   - Jangan commit ke Git

5. **Test di Real Device:**
   - Emulator mungkin tidak akurat
   - Test dengan APK release, bukan debug

---

## 🆘 Jika Masih Gagal

Check logs detail:

```powershell
# Android logs
adb logcat -s flutter

# Cari error messages:
# - "SIGN_IN_FAILED"
# - "PlatformException"
# - "ApiException"
# - "Network error"
```

Atau hubungi developer dengan informasi:
- Error message lengkap
- Android version device
- Google Play Services version
- Screenshot error

---

## 📚 Resources

- [Firebase Console](https://console.firebase.google.com/)
- [Google Cloud Console](https://console.cloud.google.com/)
- [Flutter Google Sign In Docs](https://pub.dev/packages/google_sign_in)
- [Keytool Documentation](https://docs.oracle.com/javase/8/docs/technotes/tools/windows/keytool.html)

---

**Last Updated:** January 2026  
**Status:** ✅ Tested & Working
