# 📚 BelajarBareng - Complete Documentation

> Collaborative Learning App with AI and User Generated Content

## 📖 Table of Contents

### 🏗️ Architecture & Setup

- [Project Structure](./architecture/FOLDER_STRUCTURE.md) - Detailed folder structure and architecture explanation
- [Getting Started](./GETTING_STARTED.md) - Quick start guide for developers

**📊 Database Documentation** (Complete Package):

- [Database Docs Summary](./DATABASE_DOCS_SUMMARY.md) - **⭐ START HERE** - Overview & reading guide
- [Database Design](./DATABASE_DESIGN.md) - Complete schema (14 Firestore + 5 SQLite tables)
- [Database ER Diagram](./DATABASE_ER_DIAGRAM.md) - Visual relationships with cardinality
- [Database Connection](./DATABASE_CONNECTION.md) - Firebase setup & code examples
- [Database Implementation](./DATABASE_IMPLEMENTATION_GUIDE.md) - Step-by-step (5 phases, ~7 hours)

### ✨ Features Documentation

- [Dashboard Implementation](./features/DASHBOARD_IMPLEMENTATION.md) - Complete dashboard with stats, materials, groups
- [Theme & Profile Menu](./features/THEME_PROFILE_MENU.md) - Dark/Light mode toggle and profile dropdown
- [YouTube Integration](./features/THEME_YOUTUBE_FEATURES.md) - YouTube video search and player

### 🔧 Troubleshooting

- [handleThenable Fix](./troubleshooting/HANDLETHENABLE_FIX.md) - Firebase authentication web error fix

---

## 🚀 Quick Links

### For New Developers

1. Start with [Getting Started](./GETTING_STARTED.md)
2. Understand the [Project Structure](./architecture/FOLDER_STRUCTURE.md)
3. Explore [Features Documentation](./features/)

### For Feature Development

- **Dashboard**: See [Dashboard Implementation](./features/DASHBOARD_IMPLEMENTATION.md)
- **Theming**: See [Theme & Profile Menu](./features/THEME_PROFILE_MENU.md)
- **YouTube Integration**: See [YouTube Features](./features/THEME_YOUTUBE_FEATURES.md)

### For Debugging

- **Firebase Auth Issues**: Check [handleThenable Fix](./troubleshooting/HANDLETHENABLE_FIX.md)
- **Common Errors**: See Troubleshooting section

---

## 📂 Documentation Structure

```
docs/
├── README.md                          # This file - main index
├── GETTING_STARTED.md                 # Quick start guide
│
├── architecture/                      # Architecture documentation
│   └── FOLDER_STRUCTURE.md           # Project folder structure
│
├── features/                          # Feature-specific docs
│   ├── DASHBOARD_IMPLEMENTATION.md   # Dashboard features
│   ├── THEME_PROFILE_MENU.md        # Theme & profile menu
│   └── THEME_YOUTUBE_FEATURES.md    # YouTube integration
│
└── troubleshooting/                   # Problem solving guides
    └── HANDLETHENABLE_FIX.md         # Firebase auth fix
```

---

## 🎯 Project Overview

**BelajarBareng** adalah aplikasi pembelajaran kolaboratif yang menggabungkan:

- ✅ AI-powered content generation
- ✅ User-generated learning materials
- ✅ Study groups & collaboration
- ✅ YouTube video integration
- ✅ Gamification & progress tracking
- ✅ Modern Material 3 design
- ✅ Dark/Light mode support

---

## 🛠️ Tech Stack

### Framework & Language

- **Flutter**: ^3.9.0
- **Dart**: Latest stable

### State Management

- **flutter_riverpod**: ^2.4.9

### Backend & APIs

- **Firebase**: Auth, Firestore, Storage, Messaging
- **YouTube Data API**: v3
- **OpenAI/Gemini**: AI content generation (planned)

### Navigation & Routing

- **go_router**: ^13.0.1

### Local Storage

- **drift**: ^2.13.0 (SQLite)
- **flutter_secure_storage**: ^9.0.0

### UI & Design

- **google_fonts**: ^6.1.0 (Poppins, Inter)
- **Material 3**: Latest design system

---

## 📊 Current Status

### ✅ Implemented Features

- [x] Modern dashboard with stats and materials
- [x] Dark/Light mode toggle
- [x] Profile dropdown menu
- [x] YouTube video search & player
- [x] Study groups display
- [x] Create material screen
- [x] Dummy data for testing
- [x] Custom theme with purple/teal palette

### 🔜 Coming Soon

- [ ] Firebase authentication
- [ ] Real-time data from Firestore
- [ ] Profile & settings screens
- [ ] Quiz builder & player
- [ ] Q&A forum
- [ ] Leaderboard & gamification
- [ ] AI content generation
- [ ] Notifications system

---

## 🎨 Design System

### Color Palette

- **Primary Purple**: #6C63FF → #8A84FF
- **Secondary Teal**: #26D0CE → #4DDBD9
- **Accent Orange**: #FF6B6B
- **Accent Yellow**: #FECA57
- **Accent Green**: #48C9B0
- **Accent Pink**: #FF8FAB

### Typography

- **Heading**: Poppins (Bold, SemiBold, Medium)
- **Body**: Inter (Regular, Medium)

---

## 👥 Team Collaboration

### Branch Strategy

- `main` - Production ready code
- `develop` - Development branch
- `feature/*` - Feature branches
- `fix/*` - Bug fix branches

### Commit Convention

```
feat: Add new feature
fix: Bug fix
docs: Documentation update
style: Code style update
refactor: Code refactoring
test: Add tests
chore: Maintenance
```

---

## 📞 Support & Contacts

For questions or issues:

1. Check [Troubleshooting](./troubleshooting/) first
2. Review relevant feature documentation
3. Contact the development team

---

**Last Updated**: November 3, 2025  
**Version**: 1.0.0  
**Status**: ✅ Active Development
