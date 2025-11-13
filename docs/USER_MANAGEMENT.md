# User Management System

Sistem manajemen user untuk aplikasi BelajarBareng yang mendukung 2 tipe user: **Guru** dan **Siswa**.

## 🚀 Fitur

- ✅ Login untuk Guru dan Siswa dari collection Firestore terpisah
- ✅ Global state management dengan UserProvider  
- ✅ Helper class AppUser untuk akses mudah
- ✅ Auto-detect user type (guru/siswa)
- ✅ Data persistence selama session
- ✅ Type-safe access ke user data

## 📁 Structure

```
lib/src/
├── core/
│   ├── providers/
│   │   └── user_provider.dart          # Global state management
│   ├── utils/
│   │   └── app_user.dart               # Helper class untuk akses mudah
│   └── widgets/
│       └── user_info_widget.dart       # Contoh widget usage
└── features/auth/presentation/login/
    ├── login_bloc.dart                 # Login logic dengan dual collection
    ├── login_state.dart                # Updated state dengan userData
    └── login_screen.dart               # UI login
```

## 🔄 Login Flow

1. **Input**: User memasukkan email dan password
2. **Check Guru**: Query collection `guru` dengan email + password
3. **Check Siswa**: Jika tidak ada di guru, query collection `siswa`
4. **Set Global State**: Simpan data user ke UserProvider
5. **Emit Success**: Dengan user data dan optional guru profile

## 📊 Database Structure

### Collection: `guru`
```json
{
  "email": "guru@example.com",
  "password": "password123",
  "namaLengkap": "Pak Budi Santoso",
  "nig": 123456789,
  "mataPelajaran": "Matematika",
  "sekolah": "SMA Negeri 1"
}
```

### Collection: `siswa`  
```json
{
  "email": "siswa@example.com", 
  "password": "password123",
  "namaLengkap": "Siti Nurhaliza",
  "nis": 987654321,
  "kelas": "XII IPA 1",
  "sekolah": "SMA Negeri 1"
}
```

## 💻 Cara Penggunaan

### 1. Import Helper Class
```dart
import 'package:your_app/src/core/utils/app_user.dart';
```

### 2. Check Login Status
```dart
if (AppUser.isLoggedIn) {
  print('User sudah login: ${AppUser.displayName}');
} else {
  // Navigate to login
}
```

### 3. Access User Data
```dart
// Basic info
String? name = AppUser.name;          // Nama lengkap
String? email = AppUser.email;        // Email
String? type = AppUser.userType;      // 'guru' atau 'siswa'

// Role checking
if (AppUser.isGuru) {
  print('NIG: ${AppUser.nig}');
  print('Mata Pelajaran: ${AppUser.mataPelajaran}');
}

if (AppUser.isSiswa) {
  print('NIS: ${AppUser.nis}');
  print('Kelas: ${AppUser.kelas}');
}

// Common fields
print('Sekolah: ${AppUser.sekolah}');
```

### 4. Conditional UI Based on Role
```dart
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Dashboard ${AppUser.roleDisplayName}'),
    ),
    body: Column(
      children: [
        Text(AppUser.greetingMessage),
        
        if (AppUser.isGuru) 
          GuruDashboard()
        else if (AppUser.isSiswa)
          SiswaDashboard(),
      ],
    ),
  );
}
```

### 5. Update User Data
```dart
AppUser.updateData({
  'mataPelajaran': 'Fisika',
  'customField': 'customValue'
});
```

### 6. Logout
```dart
AppUser.logout();
Navigator.pushReplacementNamed(context, '/login');
```

### 7. Using with Provider Pattern
```dart
import 'package:provider/provider.dart';
import 'package:your_app/src/core/providers/user_provider.dart';

// Dalam main.dart
runApp(
  ChangeNotifierProvider(
    create: (_) => UserProvider(),
    child: MyApp(),
  ),
);

// Dalam widget
Consumer<UserProvider>(
  builder: (context, userProvider, child) {
    return Text(userProvider.displayName);
  },
)
```

## 🛠 Advanced Usage

### Custom Fields Access
```dart
// Get any field from userData
String? customField = AppUser.getField<String>('customField');
int? score = AppUser.getField<int>('score');

// Direct access to all data
Map<String, dynamic>? allData = AppUser.data;
```

### Role-based Permissions
```dart
bool canAccessTeacherFeatures = AppUser.hasRole('guru');
bool canAccessStudentFeatures = AppUser.hasRole('siswa');
```

### Debug Info
```dart
print(AppUser.toMap()); // Print all user data
print(AppUser.toString()); // Formatted string
```

## 🔒 Security Notes

⚠️ **PENTING**: Saat ini password disimpan sebagai plain text. Untuk production:

1. Gunakan password hashing (bcrypt, argon2, dll)
2. Implementasi proper authentication dengan tokens
3. Add field validation dan sanitization
4. Implement rate limiting untuk login attempts

## 🔄 Migration from Firebase Auth

Jika ingin kembali ke Firebase Auth, cukup:

1. Uncomment baris Firebase Auth di `login_bloc.dart`
2. Comment baris manual Firestore query
3. UserProvider tetap bisa digunakan dengan sedikit modifikasi

## 🧪 Testing

```dart
// Test login flow
final authBloc = LoginBloc(authRepository: mockAuthRepository);
authBloc.add(LoginRequested(
  email: 'test@example.com',
  password: 'password123'
));

// Test user state
expect(AppUser.isLoggedIn, true);
expect(AppUser.userType, 'guru');
```