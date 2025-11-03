# 🎨 Dashboard BelajarBareng - Modern UI Design

## Overview

Dashboard ini dirancang dengan pendekatan modern dan eye-catching menggunakan color palette yang menarik dan elemen-elemen UI yang interaktif.

## 🎨 Color Palette

### Primary Colors

- **Purple Gradient**: `#6C63FF` → `#8A84FF`
  - Digunakan untuk: Primary actions, highlights, branding

### Secondary Colors

- **Teal/Cyan**: `#26D0CE` → `#4DDBD9`
  - Digunakan untuk: Secondary actions, accents

### Accent Colors

- **Orange**: `#FF6B6B` - Error states, urgent notifications
- **Yellow**: `#FECA57` - Warnings, easy difficulty
- **Green**: `#48C9B0` - Success, beginner level
- **Pink**: `#FF7EB3` - Special highlights

### Neutral Colors

- **Background Light**: `#F8F9FE`
- **Background Dark**: `#1A1A2E`
- **Card Light**: `#FFFFFF`
- **Card Dark**: `#16213E`

## 🧩 Komponen Dashboard

### 1. **App Bar**

- Logo aplikasi dengan gradient background
- Notifikasi button
- User profile avatar
- Transparent background dengan blur effect

### 2. **Search Bar**

- Rounded corners dengan shadow
- Integrated filter button
- Real-time search functionality
- Clean, minimal design

### 3. **Stats Cards** (Grid 2x2)

- **Completed**: Menampilkan jumlah materi yang sudah selesai
- **In Progress**: Materi yang sedang dipelajari
- **Study Groups**: Jumlah grup yang diikuti
- **Total Materials**: Total semua materi

Setiap card memiliki:

- Icon dengan background gradient
- Warna yang berbeda untuk setiap kategori
- Animasi hover/tap
- Shadow untuk depth

### 4. **Categories Filter**

- Horizontal scrollable chips
- Selected state dengan gradient
- Icons untuk setiap kategori:
  - 📱 All
  - 💻 Programming
  - 🔢 Mathematics
  - 🔬 Science
  - 🌍 Languages
  - 🎨 Arts

### 5. **Featured Content Card**

- Full-width gradient card
- Animated background icon
- CTA button
- Eye-catching design untuk highlight konten spesial

### 6. **Trending Materials** (Horizontal Scroll)

Setiap material card menampilkan:

- Thumbnail image dengan fallback gradient
- Category badge
- Title & description
- Duration icon
- Difficulty level badge (color-coded)
- Shadow & rounded corners

### 7. **Study Groups** (Grid 2 Columns)

Setiap group card menampilkan:

- Group avatar/icon
- Group name & category
- Member count dengan progress bar
- Percentage indicator
- Color-coded berdasarkan availability

### 8. **Recent Videos** (Horizontal Scroll)

- YouTube video thumbnails
- Duration overlay
- Video title & channel
- Compact card design

### 9. **Floating Action Button**

- Extended FAB dengan label
- Positioned untuk easy access
- Gradient background

## 🔄 State Management

### Dashboard Provider (Riverpod)

```dart
DashboardState {
  - isLoading: bool
  - trendingMaterials: List<LearningMaterialModel>
  - recommendedMaterials: List<LearningMaterialModel>
  - recentVideos: List<YouTubeVideo>
  - popularGroups: List<StudyGroupModel>
  - userStats: Map<String, int>
  - error: String?
}
```

### Methods:

- `loadDashboardData()` - Load semua data
- `refresh()` - Pull to refresh
- `searchMaterials(query)` - Filter materials

## 🎭 Animations

1. **Rotating Icon** di Featured Card

   - Infinite rotation animation
   - Subtle & non-distracting

2. **Category Chip Selection**

   - Smooth transition
   - Scale & color animation

3. **Card Hover/Tap**
   - Elevation changes
   - Shadow animations

## 📱 Responsive Design

- Grid layouts menyesuaikan dengan screen size
- Horizontal scrolls untuk list panjang
- Collapsed/Expanded app bar
- Optimized untuk phone & tablet

## 🌙 Dark Mode Support

Semua komponen mendukung dark mode dengan:

- Color adjustments untuk readability
- Proper contrast ratios
- Consistent design language

## 🚀 Features

### Implemented:

✅ Modern gradient color scheme
✅ Interactive stats cards
✅ Category filtering
✅ Material browsing
✅ Study groups overview
✅ YouTube integration
✅ Pull to refresh
✅ Search functionality
✅ Empty states
✅ Loading states
✅ Dark mode support

### Future Enhancements:

🔜 AI-powered recommendations
🔜 Personalized dashboard
🔜 Activity feed
🔜 Achievement badges
🔜 Streak counter
🔜 Quick actions menu
🔜 Notifications center

## 📦 Dependencies

```yaml
dependencies:
  flutter_riverpod: ^2.4.9 # State management
  google_fonts: ^6.1.0 # Typography
  firebase_core: ^3.6.0 # Backend
  cloud_firestore: ^5.4.4 # Database
```

## 🎯 Usage

```dart
// Navigasi ke Dashboard
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const DashboardScreen(),
  ),
);

// Atau dengan go_router
context.go('/dashboard');
```

## 💡 Design Philosophy

1. **User-Centric**: Informasi penting di atas fold
2. **Visual Hierarchy**: Gradients & colors guide attention
3. **Consistency**: Reusable components & patterns
4. **Performance**: Lazy loading & optimized rendering
5. **Accessibility**: High contrast, readable fonts, proper spacing

## 🎨 Custom Widgets Created

1. `GradientCard` - Container dengan gradient background
2. `StatCard` - Card untuk statistik
3. `CategoryChip` - Chip untuk filter kategori
4. `MaterialCard` - Card untuk learning materials
5. `StudyGroupCard` - Card untuk study groups
6. `SectionHeader` - Header untuk setiap section

---

**Created by**: BelajarBareng Team  
**Design System**: Modern Purple & Teal Theme  
**Last Updated**: November 2025
