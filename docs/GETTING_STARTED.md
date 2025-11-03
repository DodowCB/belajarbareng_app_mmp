# 🚀 Getting Started - BelajarBareng App

> Quick start guide untuk developer baru

## 📋 Prerequisites

Sebelum memulai, pastikan sudah terinstal:

### Required Software

- ✅ **Flutter SDK**: ^3.9.0 ([Download](https://flutter.dev/docs/get-started/install))
- ✅ **Dart**: Included dengan Flutter
- ✅ **Git**: Version control
- ✅ **IDE**: VS Code atau Android Studio

### Optional Tools

- **Chrome**: Untuk testing web
- **Android Studio**: Untuk Android emulator
- **Xcode**: Untuk iOS development (macOS only)

---

## 🔧 Installation Steps

### 1. Clone Repository

```bash
git clone <repository-url>
cd belajarbareng_app_mmp
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Verify Flutter Setup

```bash
flutter doctor
```

Fix any issues yang muncul.

---

## 🔑 API Configuration

### YouTube API Key

1. Buat project di [Google Cloud Console](https://console.cloud.google.com/)
2. Enable **YouTube Data API v3**
3. Create credentials (API Key)
4. Update di `lib/src/api/config/api_config.dart`:

```dart
class ApiConfig {
  static const String youtubeApiKey = 'YOUR_YOUTUBE_API_KEY_HERE';
}
```

### Firebase Setup (Optional - untuk production)

1. Create Firebase project di [Firebase Console](https://console.firebase.google.com/)
2. Add apps (Web, Android, iOS)
3. Run:

```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase
flutterfire configure
```

4. Enable authentication methods (Email/Password, Google)
5. Create Firestore database

---

## ▶️ Running the App

### Development Mode

#### Web

```bash
flutter run -d chrome
```

#### Windows

```bash
flutter run -d windows
```

#### Android

```bash
flutter run -d <device-name>
```

#### iOS (macOS only)

```bash
flutter run -d <ios-device>
```

### Check Available Devices

```bash
flutter devices
```

---

## 📂 Project Structure Overview

```
lib/
├── main.dart                 # Entry point
├── firebase_options.dart     # Firebase config
│
└── src/
    ├── core/                 # Shared code
    │   ├── app/             # App widget
    │   ├── config/          # Theme, router, constants
    │   ├── providers/       # Global providers
    │   ├── utils/           # Helper functions
    │   └── widgets/         # Reusable widgets
    │
    ├── api/                  # External APIs
    │   ├── firebase/        # Firebase services
    │   ├── youtube/         # YouTube API
    │   └── models/          # API models
    │
    └── features/             # App features
        ├── auth/            # Authentication
        ├── dashboard/       # Main dashboard
        ├── profile/         # User profile
        └── ...
```

Lihat [Folder Structure](./architecture/FOLDER_STRUCTURE.md) untuk detail lengkap.

---

## 🎨 Development Workflow

### 1. Working with Features

```bash
# Create feature branch
git checkout -b feature/new-feature-name

# Make changes
# ...

# Commit
git add .
git commit -m "feat: Add new feature description"

# Push
git push origin feature/new-feature-name
```

### 2. Hot Reload

Saat development, gunakan:

- **r**: Hot reload
- **R**: Hot restart
- **q**: Quit

### 3. Testing

```bash
# Run all tests
flutter test

# Run specific test
flutter test test/widget_test.dart
```

---

## 🐛 Common Issues & Solutions

### Issue: Dependency conflicts

```bash
flutter clean
flutter pub get
```

### Issue: Platform tidak terdeteksi

```bash
# Enable platform
flutter create --platforms=web,windows,android,ios .
```

### Issue: Hot reload tidak bekerja

```bash
# Hot restart dengan R
# atau
flutter run --hot
```

### Issue: Firebase error (handleThenable)

Lihat [handleThenable Fix](./troubleshooting/HANDLETHENABLE_FIX.md)

---

## 📱 Testing Features

### Dashboard

1. Run app
2. Lihat stats, materials, groups
3. Test category filters
4. Scroll trending section

### Theme Toggle

1. Klik avatar di pojok kanan atas
2. Toggle Dark/Light mode
3. Verifikasi semua UI berubah

### YouTube Search

1. Klik tombol "Create"
2. Pilih category
3. Search video (contoh: "Flutter tutorial")
4. Klik video untuk open di YouTube

---

## 🔄 State Management (Riverpod)

### Reading State

```dart
// In ConsumerWidget
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeModeProvider);
    return Text('Theme: $theme');
  }
}
```

### Modifying State

```dart
// In widget
ref.read(themeModeProvider.notifier).toggleTheme();
```

### Creating Provider

```dart
final myProvider = StateNotifierProvider<MyNotifier, MyState>((ref) {
  return MyNotifier();
});
```

---

## 🎯 Next Steps After Setup

1. **Explore Dashboard**: Lihat semua features yang sudah ada
2. **Read Documentation**: Check [Features Documentation](./features/)
3. **Try Creating Material**: Test YouTube integration
4. **Customize Theme**: Edit `lib/src/core/config/theme.dart`
5. **Add New Feature**: Follow feature-first architecture

---

## 📚 Learning Resources

### Flutter Basics

- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Widget Catalog](https://flutter.dev/docs/development/ui/widgets)

### State Management

- [Riverpod Documentation](https://riverpod.dev/)
- [Riverpod Examples](https://github.com/rrousselGit/riverpod/tree/master/examples)

### Firebase

- [FlutterFire Documentation](https://firebase.flutter.dev/)
- [Firebase YouTube](https://www.youtube.com/c/Firebase)

---

## 💡 Pro Tips

### Development

- Use **Flutter DevTools** untuk debugging
- Enable **Dart analysis** di IDE
- Use **Flutter Inspector** untuk UI debugging
- Run dengan `--profile` mode untuk performance testing

### Code Quality

- Follow [Flutter Style Guide](https://github.com/flutter/flutter/wiki/Style-guide-for-Flutter-repo)
- Use `flutter analyze` untuk check code quality
- Format code dengan `flutter format .`

### Performance

- Minimize `setState()` calls
- Use `const` constructors
- Avoid rebuilding entire widget tree
- Profile dengan Flutter DevTools

---

## 🤝 Getting Help

### Stuck?

1. Check [Troubleshooting Guide](./troubleshooting/)
2. Review [Feature Documentation](./features/)
3. Read Flutter/Riverpod docs
4. Ask team members

### Contributing

1. Follow branch naming convention
2. Write clear commit messages
3. Add documentation for new features
4. Test before pushing

---

**Ready to Code?** 🎉

```bash
# Start developing!
flutter run -d chrome
```

Selamat coding! 💻✨
