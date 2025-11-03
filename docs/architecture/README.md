# 🏗️ Architecture Documentation

Documentation tentang struktur dan arsitektur aplikasi BelajarBareng.

---

## 📚 Available Documentation

### [Project Structure](./FOLDER_STRUCTURE.md)

**Comprehensive guide** tentang folder structure dan arsitektur aplikasi.

**Isi:**

- ✅ Penjelasan struktur folder lengkap
- ✅ Feature-first architecture pattern
- ✅ Clean Architecture principles
- ✅ Separation of concerns
- ✅ Scalability considerations
- ✅ Team collaboration guidelines

**Who should read:**

- New developers joining the project
- Developers planning new features
- Code reviewers
- Project managers

---

## 🎯 Architecture Principles

### 1. **Feature-First Organization**

Setiap feature memiliki folder sendiri dengan struktur:

```
feature/
├── data/         # Data sources & repositories
├── domain/       # Business logic & providers
└── presentation/ # UI components & screens
```

### 2. **Clean Architecture Layers**

- **Presentation Layer**: UI components, screens, widgets
- **Domain Layer**: Business logic, state management, providers
- **Data Layer**: Repositories, API services, models

### 3. **Dependency Flow**

```
presentation → domain → data
```

- Presentation depends on Domain
- Domain depends on Data
- Data is independent

### 4. **State Management**

- Using **Riverpod** for global state
- StateNotifier pattern for complex state
- Provider pattern for simple state

---

## 📂 Main Directories Explained

### `/lib/src/core/`

**Purpose**: Shared code used across multiple features

**Contains:**

- `app/` - Application widget configuration
- `config/` - Theme, router, constants
- `providers/` - Global providers (theme, auth, etc.)
- `utils/` - Helper functions, validators, formatters
- `widgets/` - Reusable UI components

**When to use:**

- Code needed by 3+ features
- App-wide configurations
- Common utilities

---

### `/lib/src/api/`

**Purpose**: External API integrations

**Contains:**

- `firebase/` - Firebase services (Auth, Firestore, Storage)
- `youtube/` - YouTube Data API integration
- `models/` - API data models
- `config/` - API configurations & keys

**When to use:**

- Integrating external services
- API request/response handling
- Data transformation from APIs

---

### `/lib/src/features/`

**Purpose**: Feature modules (MAIN APPLICATION LOGIC)

**Current features:**

- `auth/` - User authentication
- `dashboard/` - Main dashboard
- `profile/` - User profile management
- `quiz/` - Quiz system (planned)
- `qna/` - Q&A forum (planned)
- `media/` - Learning media (planned)

**Adding new feature:**

1. Create folder in `features/`
2. Add `data/`, `domain/`, `presentation/` subfolders
3. Implement feature following clean architecture
4. Update router configuration

---

## 🔄 Data Flow Example

### Example: Loading Dashboard Data

```
DashboardScreen (presentation)
    ↓ watch
DashboardProvider (domain)
    ↓ fetch
DashboardRepository (data)
    ↓ query
FirestoreService (data)
    ↓
Firebase Cloud
```

**Code flow:**

1. UI watches the provider
2. Provider calls repository
3. Repository uses service
4. Service fetches from Firebase
5. Data flows back up
6. UI rebuilds with new data

---

## 🎨 File Naming Conventions

### Dart Files

- `snake_case.dart` for all files
- `_private.dart` for private files (starts with underscore)

### Classes

- `PascalCase` for class names
- `_PrivateClass` for private classes

### Variables & Functions

- `camelCase` for variables and functions
- `_privateFunction` for private functions

### Constants

- `lowerCamelCase` for constants
- `SCREAMING_SNAKE_CASE` for compile-time constants

---

## 🚀 Best Practices

### 1. **Keep Features Independent**

- Features should not directly depend on each other
- Share code through `core/` folder
- Use providers for cross-feature communication

### 2. **Single Responsibility**

- Each file has one clear purpose
- Each class does one thing well
- Keep functions small and focused

### 3. **Don't Repeat Yourself (DRY)**

- Extract common widgets to `core/widgets/`
- Create utility functions for repeated logic
- Use providers for shared state

### 4. **Consistent Naming**

- Follow naming conventions
- Use descriptive names
- Avoid abbreviations unless widely known

### 5. **Documentation**

- Add comments for complex logic
- Document public APIs
- Update docs when changing architecture

---

## 📖 Further Reading

### Internal Docs

- [Getting Started](../GETTING_STARTED.md) - Setup guide
- [Features Documentation](../features/) - Feature-specific guides

### External Resources

- [Flutter Architecture Samples](https://github.com/brianegan/flutter_architecture_samples)
- [Clean Architecture in Flutter](https://medium.com/ruangguru/an-introduction-to-flutter-clean-architecture-ae00154001b0)
- [Riverpod Documentation](https://riverpod.dev/)

---

**Last Updated**: November 3, 2025  
**Maintained by**: Development Team
