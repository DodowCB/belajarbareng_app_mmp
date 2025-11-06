# 🎓 BelajarBareng

> Collaborative Learning App with AI and User Generated Content

[![Flutter](https://img.shields.io/badge/Flutter-3.9.0-02569B?logo=flutter)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-Latest-0175C2?logo=dart)](https://dart.dev/)
[![Firebase](https://img.shields.io/badge/Firebase-Enabled-FFCA28?logo=firebase)](https://firebase.google.com/)

**BelajarBareng** adalah aplikasi pembelajaran kolaboratif modern yang menggabungkan AI-powered content generation dengan user-generated learning materials untuk menciptakan pengalaman belajar yang interaktif dan engaging.

---

## ✨ Features

### 📊 Dashboard

- **Learning Stats**: Track your progress with detailed statistics
- **Trending Materials**: Discover popular learning content
- **Study Groups**: Join collaborative learning groups
- **YouTube Integration**: Search and access educational videos
- **Smart Categories**: Filter content by subject areas

### 🎨 Modern UI/UX

- **Material Design 3**: Clean and modern interface
- **Dark/Light Mode**: Toggle between themes instantly
- **Custom Color Palette**: Purple & Teal design system
- **Responsive Layout**: Works on all screen sizes
- **Smooth Animations**: Polished user experience

### 🔐 Authentication (Coming Soon)

- Email/Password authentication
- Google Sign-In
- Profile management
- Secure data storage

### 🎯 Learning Features (Planned)

- **Q&A Forum**: Ask questions and share knowledge
- **Quiz Builder**: Create and take interactive quizzes
- **AI Content Generation**: Generate learning materials with AI
- **Gamification**: Leaderboards, badges, and achievements
- **Progress Tracking**: Monitor your learning journey

---

## 🚀 Quick Start

### Prerequisites

- Flutter SDK ^3.9.0
- Dart (included with Flutter)
- Chrome/Edge browser (for web testing)

### Installation

```bash
# Clone repository
git clone <repository-url>
cd belajarbareng_app_mmp

# Install dependencies
flutter pub get

# Run on Chrome
flutter run -d chrome

# Or run on Windows
flutter run -d windows
```

### First Time Setup

1. **Get YouTube API Key** (Optional for testing):

   - Visit [Google Cloud Console](https://console.cloud.google.com/)
   - Enable YouTube Data API v3
   - Create credentials
   - Add to `lib/src/api/config/api_config.dart`

2. **Run the app**:
   ```bash
   flutter run -d chrome
   ```

---

## 📚 Documentation

### 📖 Complete Documentation Hub

All project documentation is organized in the [`docs/`](./docs/) folder:

**🏠 Main Index**: [docs/README.md](./docs/README.md)

### � Database Documentation (New!)

Complete database design & implementation guide:

1. **[Database Docs Summary](./docs/DATABASE_DOCS_SUMMARY.md)** ⭐ **START HERE**

   - Overview of all 4 database documents
   - Reading guide & learning paths
   - Use case scenarios

2. **[Database Design](./docs/DATABASE_DESIGN.md)**

   - 14 Firestore collections
   - 5 SQLite tables
   - Security rules

3. **[Database ER Diagram](./docs/DATABASE_ER_DIAGRAM.md)**

   - Visual diagram
   - 18 relationships

4. **[Database Connection](./docs/DATABASE_CONNECTION.md)**

   - Setup guide
   - Code examples

5. **[Database Implementation](./docs/DATABASE_IMPLEMENTATION_GUIDE.md)**
   - 5-phase roadmap
   - ~7 hours total

### 🏗️ Architecture

- [Project Structure](./docs/architecture/FOLDER_STRUCTURE.md)
- [Getting Started](./docs/GETTING_STARTED.md)

### ✨ Features

- [Dashboard Implementation](./docs/features/DASHBOARD_IMPLEMENTATION.md)
- [Theme & Profile Menu](./docs/features/THEME_PROFILE_MENU.md)
- [YouTube Integration](./docs/features/THEME_YOUTUBE_FEATURES.md)

### 🔧 Troubleshooting

- [handleThenable Fix](./docs/troubleshooting/HANDLETHENABLE_FIX.md)

---

## 🛠️ Tech Stack

| Category             | Technology                          |
| -------------------- | ----------------------------------- |
| **Framework**        | Flutter 3.9.0                       |
| **Language**         | Dart                                |
| **State Management** | Riverpod 2.4.9                      |
| **Navigation**       | go_router 13.0.1                    |
| **Backend**          | Firebase (Auth, Firestore, Storage) |
| **APIs**             | YouTube Data API v3                 |
| **Local Storage**    | Drift (SQLite), Secure Storage      |
| **UI/Design**        | Material 3, Google Fonts            |

---

## 📂 Project Structure

```
lib/
├── main.dart                    # Entry point
├── firebase_options.dart        # Firebase configuration
│
└── src/
    ├── core/                    # Shared/common code
    │   ├── app/                # App widget & setup
    │   ├── config/             # Theme, router, constants
    │   ├── providers/          # Global Riverpod providers
    │   ├── utils/              # Helper functions & dummy data
    │   └── widgets/            # Reusable widgets
    │
    ├── api/                     # External API integrations
    │   ├── firebase/           # Firebase services
    │   ├── youtube/            # YouTube API
    │   └── models/             # API data models
    │
    └── features/                # Feature-based modules
        ├── auth/               # Authentication
        ├── dashboard/          # Main dashboard
        ├── profile/            # User profile
        ├── quiz/               # Quiz system
        ├── qna/                # Q&A forum
        └── media/              # Learning media
```

Lihat [Project Structure Documentation](./docs/architecture/FOLDER_STRUCTURE.md) untuk detail lengkap.

---

## 🎨 Design System

### Color Palette

| Color          | Hex       | Usage                        |
| -------------- | --------- | ---------------------------- |
| Primary Purple | `#6C63FF` | Main brand color             |
| Secondary Teal | `#26D0CE` | Accents & highlights         |
| Orange         | `#FF6B6B` | Warnings & important actions |
| Yellow         | `#FECA57` | Success & positive feedback  |
| Green          | `#48C9B0` | Progress & completion        |
| Pink           | `#FF8FAB` | Special features             |

### Typography

- **Headings**: Poppins (Bold, SemiBold, Medium)
- **Body**: Inter (Regular, Medium)

---

## 🎯 Current Status

### ✅ Completed

- [x] Modern dashboard with stats
- [x] Dark/Light mode toggle
- [x] Profile dropdown menu
- [x] YouTube video search
- [x] Study groups display
- [x] Create material screen
- [x] Dummy data implementation
- [x] Custom theme system

### 🚧 In Progress

- [ ] Firebase authentication
- [ ] Real-time Firestore integration
- [ ] Profile & settings screens

### 📋 Planned

- [ ] Quiz builder & player
- [ ] Q&A forum
- [ ] AI content generation
- [ ] Gamification system
- [ ] Notifications
- [ ] Advanced search & filters

---

## 🤝 Contributing

### Development Workflow

1. Create feature branch: `git checkout -b feature/your-feature`
2. Make changes following the architecture
3. Test thoroughly
4. Commit with clear messages: `feat: Add feature description`
5. Push and create pull request

### Code Standards

- Follow [Flutter Style Guide](https://github.com/flutter/flutter/wiki/Style-guide-for-Flutter-repo)
- Use meaningful variable/function names
- Add comments for complex logic
- Update documentation when needed

---

## 📄 License

This project is part of a Multi-Platform Mobile Programming course assignment.

---

## 📞 Support

- **Documentation**: Check [docs/](./docs/) folder
- **Issues**: Create an issue in the repository
- **Questions**: Contact the development team

---

## 🎓 Academic Information

**Course**: Multi-Platform Mobile Programming  
**Instructor**: Ce Esther  
**Semester**: 5  
**Project**: BelajarBareng - Collaborative Learning App

---

**Made with ❤️ using Flutter**

For detailed documentation, visit **[docs/README.md](./docs/README.md)**
