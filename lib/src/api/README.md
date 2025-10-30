# API Documentation - BelajarBareng App

Folder ini berisi semua konfigurasi dan service untuk berinteraksi dengan YouTube API dan Firebase/Firestore.

## Struktur Folder

```
lib/src/api/
├── api.dart                    # Index file untuk export semua API
├── api_config.dart            # Konfigurasi API dan konstanta
├── youtube/
│   └── youtube_api_service.dart    # Service untuk YouTube Data API v3
├── firebase/
│   ├── firestore_service.dart     # Service untuk Firestore operations
│   └── firebase_auth_service.dart  # Service untuk Firebase Authentication
├── models/
│   ├── youtube_models.dart        # Model untuk data YouTube
│   └── firebase_models.dart       # Model untuk data Firestore
└── services/
    └── integrated_api_service.dart # Service yang mengintegrasikan YouTube + Firebase
```

## Setup dan Konfigurasi

### 1. YouTube API Setup
1. Pergi ke [Google Cloud Console](https://console.cloud.google.com/)
2. Buat project baru atau pilih project existing
3. Enable YouTube Data API v3
4. Buat API key
5. Update `ApiConfig.youtubeApiKey` di `api_config.dart`

### 2. Firebase Setup
Firebase sudah dikonfigurasi di project ini melalui `firebase_options.dart`. Pastikan services berikut sudah diaktifkan:
- Firebase Authentication
- Cloud Firestore
- Firebase Storage (jika diperlukan)

## Cara Penggunaan

### Import API
```dart
import 'package:belajarbareng_app_mmp/src/api/api.dart';
```

### YouTube API Service
```dart
// Initialize
final youtubeService = YouTubeApiService(apiKey: 'YOUR_API_KEY');

// Search videos
final searchResult = await youtubeService.searchVideos(
  query: 'flutter tutorial',
  maxResults: 10,
);

// Get video details
final videoDetails = await youtubeService.getVideoDetails('VIDEO_ID');

// Get channel info
final channelInfo = await youtubeService.getChannelInfo('CHANNEL_ID');
```

### Firebase Auth Service
```dart
// Initialize
final authService = FirebaseAuthService();

// Register with email/password
final userCredential = await authService.registerWithEmailPassword(
  email: 'user@example.com',
  password: 'password123',
);

// Sign in with Google
final userCredential = await authService.signInWithGoogle();

// Listen to auth changes
authService.authStateChanges.listen((user) {
  if (user != null) {
    print('User signed in: ${user.email}');
  } else {
    print('User signed out');
  }
});
```

### Firestore Service
```dart
// Initialize
final firestoreService = FirestoreService();

// Create user
await firestoreService.createOrUpdateUser(
  userId: 'user123',
  userData: {
    'email': 'user@example.com',
    'displayName': 'John Doe',
    'createdAt': FieldValue.serverTimestamp(),
  },
);

// Create study group
final groupRef = await firestoreService.createStudyGroup({
  'name': 'Flutter Study Group',
  'description': 'Belajar Flutter bersama-sama',
  'category': 'Programming',
  'creatorId': 'user123',
  'isPublic': true,
});

// Add learning material
final materialRef = await firestoreService.addLearningMaterial({
  'title': 'Flutter Tutorial',
  'description': 'Learn Flutter from scratch',
  'category': 'Programming',
  'type': 'youtube_video',
  'url': 'https://youtube.com/watch?v=...',
});
```

### Integrated API Service
Service ini menggabungkan YouTube API dengan Firebase untuk fitur-fitur advanced:

```dart
// Initialize
final youtubeService = YouTubeApiService(apiKey: 'YOUR_API_KEY');
final firestoreService = FirestoreService();
final integratedService = IntegratedApiService(
  youtubeService: youtubeService,
  firestoreService: firestoreService,
);

// Search dan save videos sebagai learning materials
final materials = await integratedService.searchAndSaveVideos(
  query: 'flutter tutorial',
  category: 'Programming',
  creatorId: 'user123',
  maxResults: 5,
);

// Get personalized recommendations
final recommendations = await integratedService.getRecommendations(
  userId: 'user123',
  maxResults: 10,
);

// Save specific video as learning material
final material = await integratedService.saveVideoAsMaterial(
  videoId: 'dQw4w9WgXcQ',
  category: 'Programming',
  creatorId: 'user123',
  additionalTags: ['flutter', 'mobile', 'tutorial'],
);
```

## Models

### YouTube Models
- `YouTubeVideo`: Representasi data video YouTube
- `YouTubeChannel`: Representasi data channel YouTube

### Firebase Models
- `UserModel`: Data user dalam Firestore
- `StudyGroupModel`: Data study group
- `LearningMaterialModel`: Data learning material
- `UserProgressModel`: Progress belajar user

## Error Handling

Semua service menggunakan exception handling yang konsisten:

```dart
try {
  final result = await youtubeService.searchVideos(query: 'flutter');
  // Handle success
} catch (e) {
  if (e.toString().contains('quota')) {
    // Handle quota exceeded
    print('API quota exceeded');
  } else if (e.toString().contains('network')) {
    // Handle network error
    print('Network error');
  } else {
    // Handle other errors
    print('Error: $e');
  }
}
```

## Rate Limiting dan Caching

- YouTube API memiliki rate limiting (lihat `ApiConfig`)
- Implementasikan caching untuk mengurangi API calls
- Gunakan `StreamBuilder` untuk real-time Firestore updates

## Security Notes

1. **API Keys**: Jangan commit API keys ke repository. Gunakan environment variables atau Firebase Remote Config
2. **Firestore Rules**: Setup security rules yang proper di Firestore console
3. **Authentication**: Selalu validate user permissions sebelum operations

## Dependencies

Dependencies yang dibutuhkan sudah ada di `pubspec.yaml`:
- `http`: untuk HTTP requests ke YouTube API
- `firebase_auth`: untuk authentication
- `cloud_firestore`: untuk database operations
- `google_sign_in`: untuk Google OAuth

## Troubleshooting

### YouTube API Errors
- **403 Forbidden**: Check API key dan quota
- **400 Bad Request**: Check parameter yang dikirim
- **404 Not Found**: Video/channel tidak ada

### Firebase Errors
- **Permission Denied**: Check Firestore security rules
- **Network Error**: Check internet connection
- **Quota Exceeded**: Check Firebase usage limits

### Development Tips
1. Gunakan Firebase Emulator untuk development
2. Test dengan data dummy terlebih dahulu
3. Implement proper loading states di UI
4. Add retry mechanisms untuk network failures
5. Log errors untuk debugging

## Future Enhancements

1. **Offline Support**: Cache data untuk offline usage
2. **Background Sync**: Sync data when connection restored
3. **Advanced Search**: Implement filters dan sorting
4. **Recommendation Engine**: Machine learning untuk recommendations
5. **Content Moderation**: Filter inappropriate content
