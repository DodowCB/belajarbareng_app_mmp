# Implementasi Sidebar Siswa - Dokumentasi

## Overview

Dokumen ini menjelaskan implementasi sidebar siswa yang telah diintegrasikan ke semua halaman siswa menggunakan widget reusable `SiswaAppScaffold`.

## Struktur File Baru

### 1. Widget Reusable: `siswa_app_scaffold.dart`

**Lokasi:** `lib/src/features/auth/presentation/widgets/siswa_app_scaffold.dart`

Widget ini menyediakan:

- Sidebar yang konsisten di semua halaman siswa
- Sidebar collapsible (70px collapsed, 250px expanded)
- Expandable profile menu di bagian atas sidebar
- Drawer untuk mobile/tablet
- Responsive design untuk semua ukuran layar

### 2. Fitur Sidebar

#### Desktop Mode (≥1024px)

- Sidebar permanen di sisi kiri
- Dapat di-collapse/expand
- Profile menu expandable di atas
- Navigation menu:
  - Dashboard
  - Tugas
  - Quiz
  - Kelas
  - Kalender

#### Mobile/Tablet Mode (<1024px)

- AppBar dengan drawer button
- Drawer slide dari kiri
- Semua menu tersedia dalam drawer
- Profile section di drawer header

### 3. Profile Menu Expandable

Menu profile berisi:

- Profile (navigasi ke ProfileScreen)
- Settings (navigasi ke SettingsScreen)
- Light/Dark Mode Toggle
- Notifications (navigasi ke NotificationsScreen)
- Help & Support (navigasi ke HelpSupportScreen)
- Logout (dengan konfirmasi dialog)

### 4. Navigation Active State

Setiap halaman memiliki parameter `currentRoute` yang menunjukkan halaman mana yang sedang aktif:

- `/halaman-siswa` → Dashboard
- `/tugas-siswa` → Tugas
- `/quiz-siswa` → Quiz
- `/kelas-siswa` → Kelas
- `/kalender-siswa` → Kalender

## File yang Dimodifikasi

### 1. `tugas_siswa_screen.dart`

**Perubahan:**

- Import `siswa_app_scaffold.dart`
- Mengganti `Scaffold` dengan `SiswaAppScaffold`
- Menambahkan parameter `currentRoute: '/tugas-siswa'`
- Body tetap sama

**Sebelum:**

```dart
return Scaffold(
  appBar: AppBar(
    title: const Text('Tugas Saya'),
  ),
  body: Column(...),
);
```

**Sesudah:**

```dart
return SiswaAppScaffold(
  title: 'Tugas Saya',
  icon: Icons.assignment,
  currentRoute: '/tugas-siswa',
  body: Column(...),
);
```

### 2. `quiz_siswa_screen.dart`

**Perubahan:**

- Import `siswa_app_scaffold.dart`
- Mengganti `Scaffold` dengan `SiswaAppScaffold`
- Menambahkan parameter `currentRoute: '/quiz-siswa'`

### 3. `kelas_siswa_screen.dart`

**Perubahan:**

- Import `siswa_app_scaffold.dart`
- Mengganti `Scaffold` dengan `SiswaAppScaffold`
- Menambahkan parameter `currentRoute: '/kelas-siswa'`

### 4. `kalender_siswa_screen.dart`

**Perubahan:**

- Import `siswa_app_scaffold.dart`
- Mengganti `Scaffold` dengan `SiswaAppScaffold`
- Menambahkan parameter `currentRoute: '/kalender-siswa'`
- Parameter `additionalActions` untuk tombol "Hari Ini"

## Parameter SiswaAppScaffold

```dart
SiswaAppScaffold({
  required String title,              // Judul halaman
  required IconData icon,             // Icon untuk AppBar
  required Widget body,               // Konten halaman
  required String currentRoute,       // Route saat ini untuk active state
  Widget? floatingActionButton,       // Optional FAB
  List<Widget>? additionalActions,    // Optional additional AppBar actions
})
```

## Konsistensi Desain

### Warna Theme

- Primary Purple: `#6C63FF`
- Secondary Teal: `#26D0CE`
- Accent Orange: `#FF6B6B`
- Accent Green: `#48C9B0`

### Typography

- Headings: Google Fonts Poppins
- Body: Google Fonts Inter

### Spacing

- Sidebar width collapsed: 70px
- Sidebar width expanded: 250px
- Padding standard: 16px
- Border radius: 8-12px

## Responsive Breakpoints

- Mobile: < 768px → Drawer
- Tablet: 768px - 1023px → Drawer
- Desktop: ≥ 1024px → Sidebar

## Navigation Flow

### Dari Sidebar/Drawer:

1. Klik menu item
2. `Navigator.pushReplacement` ke halaman target
3. Halaman baru tampil dengan sidebar/drawer yang sama
4. Menu item aktif ditandai dengan background purple light

### Dari Profile Menu:

1. Profile, Settings, Notifications, Help → `Navigator.push` (stack navigation)
2. Logout → Dialog konfirmasi → `Navigator.pushAndRemoveUntil` ke Login

## Dark Mode Support

Semua komponen sidebar mendukung dark mode:

- Background colors auto-adjust
- Text colors auto-adjust
- Border colors auto-adjust
- Icon colors auto-adjust

## State Management

### Local State (StatefulWidget):

- `_isSidebarCollapsed`: Boolean untuk collapse/expand sidebar
- `_isProfileMenuExpanded`: Boolean untuk expand profile menu

### Global State (Provider/BLoC):

- `themeModeProvider`: Theme light/dark
- `SiswaProfileBloc`: Data profile siswa

## Testing Checklist

- [x] Sidebar tampil di semua halaman siswa
- [x] Active menu indicator berfungsi
- [x] Collapse/expand sidebar berfungsi
- [x] Profile menu expand/collapse berfungsi
- [x] Navigation antar halaman berfungsi
- [x] Drawer di mobile/tablet berfungsi
- [x] Dark mode berfungsi
- [x] Responsive design untuk semua ukuran layar
- [x] Logout dialog berfungsi
- [x] No build errors
- [x] No runtime errors

## Fitur Tambahan Kalender

Halaman kalender memiliki additional action button "Hari Ini" yang berfungsi untuk:

- Kembali ke tanggal hari ini
- Set selected date ke hari ini
- Scroll kalender ke bulan ini

```dart
SiswaAppScaffold(
  title: 'Kalender',
  icon: Icons.calendar_today,
  currentRoute: '/kalender-siswa',
  additionalActions: [
    IconButton(
      icon: const Icon(Icons.today),
      onPressed: () {
        setState(() {
          _focusedDay = DateTime.now();
          _selectedDay = DateTime.now();
        });
      },
      tooltip: 'Hari Ini',
    ),
  ],
  body: ...,
);
```

## Best Practices yang Diterapkan

1. **Reusable Widget**: `SiswaAppScaffold` dapat digunakan di semua halaman
2. **Single Source of Truth**: Sidebar structure di satu tempat
3. **Consistent Navigation**: Semua navigasi menggunakan pattern yang sama
4. **Type Safety**: Semua parameter required kecuali optional
5. **Responsive First**: Design mobile-first, enhance untuk desktop
6. **Accessibility**: Tooltip pada collapsed sidebar items
7. **Performance**: Efficient navigation dengan `pushReplacement`
8. **User Experience**: Active state, smooth animations, intuitive navigation

## Maintenance Notes

### Untuk menambah menu item baru:

1. Tambahkan di `_buildSidebar()` dalam `ListView` children
2. Tambahkan di `_buildDrawer()` dalam drawer items
3. Buat screen baru dan gunakan `SiswaAppScaffold`
4. Tambahkan route di `currentRoute` parameter

### Untuk mengubah style:

1. Edit theme colors di `AppTheme` class
2. Style akan otomatis apply ke semua halaman

### Untuk debugging:

1. Check `currentRoute` parameter benar
2. Check import `siswa_app_scaffold.dart` ada
3. Check BLoC provider tersedia di widget tree

## Status Implementasi

✅ **COMPLETED** - Semua halaman siswa sudah memiliki sidebar yang konsisten

- Dashboard: ✅
- Tugas: ✅
- Quiz: ✅
- Kelas: ✅
- Kalender: ✅

**Testing Status:**

- Flutter analyze: ✅ No errors (only warnings & info)
- Flutter run: ✅ Successfully launched on Chrome
- Firebase: ✅ Initialized successfully
- Navigation: ✅ All routes working
- Responsive: ✅ Desktop, Tablet, Mobile tested

## Credits

Implementasi oleh: GitHub Copilot Assistant
Tanggal: 2024
Framework: Flutter 3.9.0+
State Management: flutter_bloc, flutter_riverpod
