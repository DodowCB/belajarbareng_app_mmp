# 🎤 Script Presentasi BelajarBareng App - 2 MENIT

> **Platform Pembelajaran Digital dengan 3 Role: Admin, Guru, dan Siswa**

---

## 💡 TIPS PRESENTASI VIDEO 2 MENIT

**DO's:**
✅ Fokus pada **DEMO VISUAL** - tunjukkan fitur, bukan jelaskan panjang lebar
✅ **Screen recording smooth** - prepare app sudah login & data sudah ada
✅ **Highlight fitur UNIK**: GPS Tracking, YouTube API, Camera, Analytics
✅ Bicara **jelas & cepat** - no filler words
✅ **Music background** yang energetic (opsional)
✅ **Text overlay** untuk fitur penting

**DON'Ts:**
❌ Jangan baca script word-by-word
❌ Jangan loading/waiting time - cut langsung ke hasil
❌ Jangan show too many screens - fokus yang wow
❌ Jangan slow motion - ini bukan drama 😄

**Recording Flow:**
1. Record app demo dulu (raw footage)
2. Edit dengan cuts yang smooth
3. Voice over sambil lihat video
4. Add text overlay/annotations
5. Export & review timing

---

## ⏱️ TIMING GUIDE
- **0:00 - 0:15** → Pembuka
- **0:15 - 0:45** → Admin Highlights (GPS, Camera, Analytics)
- **0:45 - 1:15** → Guru Highlights (YouTube API, Quiz, Absensi)
- **1:15 - 1:45** → Siswa Highlights (Dashboard, Tugas, Quiz)
- **1:45 - 2:00** → Penutup & Tech Stack

---

## 🎯 PEMBUKA (15 detik)

**BelajarBareng** - aplikasi pembelajaran digital dengan **3 role lengkap**: Admin, Guru, dan Siswa. Lebih dari **15 halaman** dengan fitur advanced seperti **GPS tracking, YouTube API, dan Real-time database**.

Mari kita lihat fitur-fitur unggulannya!

---

## 👨‍💼 ADMIN - Control Center (30 detik)

### Demo 1: Dashboard Real-time 📊
> **[Show: Admin Dashboard dengan statistik]**

Dashboard admin dengan **statistik real-time**: Total Guru, Siswa, Kelas, semua update otomatis dari Firebase.

### Demo 2: GPS Tracking 📍  
> **[Show: Guru Location Screen dengan map]**

**Fitur unik!** Track lokasi guru real-time menggunakan **Geolocator API** - untuk monitoring dan absensi digital.

### Demo 3: Camera Integration 📸
> **[Show: Buat pengumuman → ambil foto dari kamera]**

Pengumuman dengan **camera sensor** - ambil foto langsung, upload ke Firebase Storage, terlihat semua user.

### Demo 4: Analytics Charts 📈
> **[Show: Analytics Screen dengan bar chart & pie chart]**

Data visualization dengan **fl_chart** - Bar chart untuk absensi, Pie chart untuk pengumpulan tugas. Interactive dan responsive!

**Bonus:** Excel Import untuk bulk upload data guru/siswa!

---

## 👨‍🏫 GURU - Platform Mengajar Modern (30 detik)

### Demo 1: YouTube API Integration 🎥
> **[Show: Search "Pythagoras Theorem" → results muncul → Add to library]**

**Fitur killer!** Guru bisa **search video YouTube** langsung dari app pakai **YouTube Data API v3**. 
- Ketik keyword → Video muncul dengan thumbnail
- Klik "Add" → Tersimpan sebagai materi
- Siswa langsung bisa nonton - hemat storage!

### Demo 2: Quiz Builder dengan Auto-Grading 📝
> **[Show: Create quiz form → Multiple choice → Set answer → Publish]**

**Quiz builder lengkap:**
- Multiple choice, True/False, Essay
- **Auto-grading** untuk pilihan ganda
- Timer & deadline setting
- Hasil langsung terlihat

### Demo 3: Absensi Digital Color-Coded ✅
> **[Show: Pilih kelas → List siswa → Tap untuk ubah status]**

Absensi modern dengan **color-coding**:
- ✅ Hijau = Hadir
- 🟡 Kuning = Izin  
- 🔵 Biru = Sakit
- 🔴 Merah = Alpha

**Smart:** Default semua hadir, tinggal ubah yang gak masuk. Export to Excel untuk raport!

---

## 👨‍🎓 SISWA - Learning Hub (30 detik)

### Demo 1: Dashboard dengan Stats Cards 📱
> **[Show: Dashboard siswa dengan 5 kartu statistik warna-warni]**

Dashboard interaktif dengan **statistik personal**:
- 📝 Tugas Pending (dengan countdown!)
- ✅ Tugas Selesai
- 📊 Quiz Tersedia
- 📈 Rata-rata Nilai
- 📅 Kehadiran %

**Quick Actions** untuk akses cepat ke semua fitur!

### Demo 2: Tugas Management dengan Countdown ⏰
> **[Show: Tab "Belum Dikerjakan" → Tugas dengan "2 hari 5 jam lagi"]**

**3 Tabs untuk organize:**
- ⏰ Belum Dikerjakan (countdown deadline!)
- 📄 Sedang Dikerjakan (auto-save)
- ✅ Sudah Dikumpulkan (lihat nilai & feedback guru)

**Submit:** Upload file, tulis jawaban, submit → notifikasi langsung ke guru!

### Demo 3: Quiz Player Interactive 📝
> **[Show: Start quiz → Timer countdown → Soal multiple choice → Submit]**

Quiz player dengan:
- ⏱️ **Timer** countdown (merah jika < 5 menit)
- 📊 Progress bar
- ✅ **Auto-save** setiap jawaban
- 🎯 Nilai langsung untuk multiple choice!

### Demo 4: Kalender dengan Event Markers 📅
> **[Show: Calendar dengan dots warna-warni pada tanggal tertentu]**

**Interactive calendar** (table_calendar):
- 🔴 Dot merah → Deadline tugas
- 🔵 Dot biru → Quiz
- 🟢 Dot hijau → Event sekolah

Tap tanggal → list semua event hari itu!

---

## 🎯 TECH STACK & PENUTUP (15 detik)

**Technology yang digunakan:**

### Backend & Database 🔥
- **Firebase Authentication** → Email/password, session management
- **Cloud Firestore** → Real-time NoSQL database dengan 13+ collections
- **Firebase Storage** → File & image storage
- **FCM** → Push notifications

### APIs & Packages 🌐
- **YouTube Data API v3** → Search & embed videos
- **Geolocator** → GPS location tracking
- **Image Picker** → Camera & gallery access
- **fl_chart** → Beautiful data visualization
- **table_calendar** → Interactive calendar

### Architecture 🏗️
- **BLoC Pattern** → State management
- **Clean Architecture** → Separation of concerns
- **Responsive Design** → Mobile, Tablet, Desktop
- **Dark Mode** → Full support

---

## 🎬 CLOSING

**BelajarBareng** - Platform pembelajaran lengkap dengan:
- ✅ **3 Role** (Admin, Guru, Siswa)
- ✅ **15+ Halaman** dengan fitur advanced
- ✅ **Real-time sync** dengan Firebase
- ✅ **Modern UI/UX** responsive dan user-friendly

**Terima kasih!** 🙏

---

## 📋 QUICK REFERENCE - Fitur yang HARUS di-DEMO

**Pastikan show fitur ini dalam video:**

### ADMIN (30 detik - pilih 4 demo)
1. ✅ **Dashboard real-time** dengan statistik auto-update
2. ✅ **GPS Location Screen** - map dengan marker guru
3. ✅ **Camera Integration** - ambil foto untuk pengumuman
4. ✅ **Analytics Charts** - bar chart & pie chart (fl_chart)

### GURU (30 detik - pilih 3 demo)
1. ✅ **YouTube API** - ketik "Pythagoras" → results → add to library
2. ✅ **Quiz Builder** - buat quiz multiple choice → publish
3. ✅ **Absensi Digital** - tap siswa → ubah status color-coded

### SISWA (30 detik - pilih 4 demo)
1. ✅ **Dashboard** - 5 kartu statistik warna-warni
2. ✅ **Tugas Tab** - "Belum Dikerjakan" dengan countdown deadline
3. ✅ **Quiz Player** - start quiz → timer countdown → submit
4. ✅ **Kalender** - calendar dengan dots warna-warni

---

**END - 2:00** ✨

---

## 📝 NOTES TAMBAHAN

**Jika ada waktu extra (+ 30 detik):**
- Show **dark mode toggle** (smooth animation)
- Show **offline banner** (disconnect internet)
- Show **Excel import** untuk bulk upload
- Show **responsive design** (resize window desktop → mobile)

**Text Overlay yang bisa ditambahkan:**
- "Real-time with Firebase 🔥"
- "YouTube API v3 Integration 🎥"
- "GPS Location Tracking 📍"
- "Interactive Charts with fl_chart 📊"
- "BLoC Pattern + Clean Architecture 🏗️"

**Background Music Suggestion:**
- Upbeat, energetic (120-130 BPM)
- Copyright-free (YouTube Audio Library)
- Volume: 20% (jangan ganggu voice over)

**Final Check Before Export:**
- ✅ Total durasi pas 2:00 (± 3 detik OK)
- ✅ Audio clear, no background noise
- ✅ Video quality HD (1080p min)
- ✅ Smooth transitions antar scenes
- ✅ Text overlay visible & readable
- ✅ Demo all "HARUS" features above
