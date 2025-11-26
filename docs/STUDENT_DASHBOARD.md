# Dashboard Siswa - BelajarBareng App

## 📋 Deskripsi

Dashboard siswa adalah fitur baru yang dibuat untuk memberikan pengalaman belajar yang komprehensif bagi siswa. Dashboard ini mengikuti pola desain yang sama dengan dashboard guru untuk konsistensi UI/UX.

## ✨ Fitur Utama

### 1. **Dashboard Utama** (`halaman_siswa_screen.dart`)
- **Statistik Belajar**: Menampilkan total tugas, quiz, kelas, dan rata-rata nilai
- **Selamat Datang**: Personalisasi dengan nama siswa
- **Aksi Cepat**: Shortcut untuk mengakses tugas, quiz, kelas, dan kalender
- **Aktivitas Terbaru**: Timeline aktivitas siswa

### 2. **Manajemen Tugas** (`tugas_siswa_screen.dart`)
- Lihat semua tugas yang diberikan guru
- Filter berdasarkan status: Belum Dikerjakan, Sedang Dikerjakan, Sudah Dikumpulkan
- Detail tugas lengkap dengan deadline dan guru pengajar
- Kumpulkan tugas langsung dari aplikasi
- Lihat nilai tugas yang sudah dikumpulkan

### 3. **Quiz** (`quiz_siswa_screen.dart`)
- Daftar quiz yang tersedia
- Informasi jumlah soal dan durasi
- Status quiz (Belum Dikerjakan/Sudah Dikerjakan)
- Lihat hasil dan nilai quiz
- Interface untuk memulai quiz

### 4. **Kelas** (`kelas_siswa_screen.dart`)
- Lihat semua kelas yang diikuti
- Informasi guru pengajar dan jadwal
- Daftar anggota kelas
- Detail ruangan dan jumlah siswa

### 5. **Kalender** (`kalender_siswa_screen.dart`)
- Kalender interaktif dengan table_calendar
- Marker untuk tanggal yang memiliki kegiatan
- Daftar kegiatan per tanggal
- Filter berdasarkan tipe kegiatan (Tugas/Quiz)
- Navigasi cepat ke hari ini

## 🎨 Desain & UI/UX

### Konsistensi dengan Dashboard Guru
- **Warna**: Menggunakan AppTheme yang sama (Purple, Teal, Orange, Green)
- **Typography**: Google Fonts (Poppins & Inter)
- **Layout**: Grid responsive untuk desktop/tablet, single column untuk mobile
- **Sidebar**: Collapsible sidebar untuk desktop, drawer untuk mobile/tablet
- **Cards**: Rounded corners, shadows, dan hover effects

### Responsive Design
- **Desktop** (>= 1024px): 
  - Sidebar tetap terlihat
  - Grid 3 kolom untuk cards
  - Layout horizontal untuk kalender
  
- **Tablet** (768px - 1023px):
  - Drawer untuk navigation
  - Grid 2 kolom untuk cards
  - Layout vertikal

- **Mobile** (< 768px):
  - Drawer untuk navigation
  - Single column layout
  - Touch-optimized buttons

## 🏗️ Arsitektur

### BLoC Pattern
- **SiswaProfileBloc**: Mengelola data profil siswa
- **SiswaStatsBloc**: Mengelola statistik belajar siswa

### File Structure
```
lib/src/features/auth/presentation/halamanSiswa/
├── blocs/
│   ├── siswa_profile_bloc.dart
│   ├── siswa_stats_bloc.dart
│   └── blocs.dart
├── halaman_siswa_screen.dart
├── tugas_siswa_screen.dart
├── quiz_siswa_screen.dart
├── kelas_siswa_screen.dart
└── kalender_siswa_screen.dart
```

## 🔐 Authentication & Routing

### Login Credentials
- **Email**: siswa@gmail.com
- **Password**: 123

### Routing
- Login dengan kredensial siswa → `/halaman-siswa`
- Dari `app_widget.dart`: route `/dashboard` juga mengarah ke `HalamanSiswaScreen`

## 📊 Data

### Dummy Data
Semua screen menggunakan dummy data untuk demonstrasi:
- **Tugas**: 4 tugas dengan berbagai status
- **Quiz**: 3 quiz dengan status berbeda
- **Kelas**: 5 kelas dengan informasi lengkap
- **Kalender**: Event di beberapa tanggal

### Integrasi Future
Data dummy dapat dengan mudah diganti dengan query Firebase Firestore:
```dart
// Contoh
final tugasSnapshot = await FirebaseFirestore.instance
    .collection('tugas')
    .where('siswaId', isEqualTo: siswaId)
    .get();
```

## 🎯 Fitur Sidebar

### Menu Utama
- Dashboard
- Tugas
- Quiz
- Kelas
- Kalender

### Profile Menu (Expandable)
- Profile
- Settings
- Light/Dark Mode Toggle
- Notifications
- Help & Support
- Logout

### Sidebar Features
- **Collapsible**: Bisa di-minimize untuk memberikan lebih banyak ruang
- **Active State**: Menu aktif ditandai dengan warna dan background
- **Tooltip**: Tooltip muncul saat sidebar di-minimize
- **Profile Section**: Menampilkan avatar, nama, dan email siswa

## 🌙 Dark Mode Support

Semua screen mendukung dark mode dengan:
- Background gelap yang nyaman untuk mata
- Kontras warna yang tepat
- Icons dan text dengan opacity yang disesuaikan
- Card elevation yang lebih tinggi untuk depth

## 📱 Responsive Components

### Stat Cards
- Icon dengan background color-coded
- Nilai besar dan bold
- Label deskriptif
- Auto-resize berdasarkan screen size

### Action Cards
- Icon yang jelas
- Title yang descriptive
- Arrow indicator untuk interaksi
- Hover effect untuk desktop

### Activity Timeline
- Icon dengan color indicator
- Timestamp relatif
- Divider antar items
- Scrollable list

## 🚀 How to Run

1. Pastikan Flutter SDK terinstall
2. Clone repository
3. Run `flutter pub get`
4. Run aplikasi dengan `flutter run`
5. Login dengan kredensial siswa (siswa@gmail.com / 123)

## 📝 Notes

### Dependencies
- `flutter_bloc` & `bloc`: State management
- `table_calendar`: Widget kalender
- `equatable`: Value equality
- `flutter_riverpod`: Theme management

### Known Limitations
- Data masih menggunakan dummy data
- Fitur upload tugas belum terimplementasi penuh
- Quiz belum memiliki soal interaktif
- Kalender belum terintegrasi dengan backend

### Future Improvements
1. Integrasi dengan Firebase Firestore untuk data real-time
2. Implementasi upload file untuk pengumpulan tugas
3. Quiz interaktif dengan timer
4. Push notification untuk deadline
5. Grafik progress belajar
6. Chat dengan guru
7. Forum diskusi kelas
8. Download materi pembelajaran

## 👨‍💻 Developer Notes

### Konsistensi Code
- Mengikuti pola yang sama dengan `halaman_guru_screen.dart`
- Menggunakan BLoC pattern untuk state management
- Responsive design dengan LayoutBuilder
- Reusable widgets untuk efficiency

### Best Practices
- Null safety
- Const constructors where possible
- Proper error handling
- Accessibility considerations
- Performance optimization dengan lazy loading

---

**Created**: November 26, 2024
**Version**: 1.0.0
**Status**: ✅ Production Ready (dengan dummy data)
