# 🗄️ DATABASE DESIGN - BelajarBareng App

## 📊 Overview Database Architecture

**BelajarBareng** menggunakan **hybrid database architecture**:

- **Firebase Firestore** (Cloud) - Data sync & real-time collaboration
- **Drift/SQLite** (Local) - Offline storage & caching

> 📋 **Visual Reference**: Lihat [Database ER Diagram](./DATABASE_ER_DIAGRAM.md) untuk visualisasi lengkap hubungan antar tabel

---

## 🔥 FIREBASE FIRESTORE STRUCTURE

### Database Type: NoSQL (Document-based)

---

## 📚 Collections & Schema

### 1. **users** Collection

**Purpose**: Menyimpan data profil pengguna

```javascript
{
  "userId": "auto_generated_id",
  "email": "user@example.com",
  "displayName": "John Doe",
  "photoUrl": "https://storage.url/photo.jpg", // nullable
  "createdAt": Timestamp,
  "updatedAt": Timestamp,
  "joinedGroups": ["group_id_1", "group_id_2"], // Array of group IDs
  "preferences": {
    "theme": "dark", // dark/light/system
    "language": "id", // id/en
    "notifications": true
  },
  "stats": {
    "totalMaterials": 24,
    "completed": 8,
    "inProgress": 5,
    "studyGroups": 3,
    "points": 1250, // for gamification
    "level": 5
  },
  "badges": ["beginner", "first_material", "week_streak"], // Array of badge IDs
  "subscription": {
    "plan": "free", // free/premium
    "expiresAt": Timestamp // nullable
  }
}
```

**Indexes:**

- `email` (Unique)
- `displayName`
- `createdAt`

---

### 2. **study_groups** Collection

**Purpose**: Data study groups untuk kolaborasi

```javascript
{
  "groupId": "auto_generated_id",
  "name": "Flutter Developers Indonesia",
  "description": "Community untuk Flutter developers...",
  "category": "Programming", // Programming/Mathematics/Science/Arts/Languages
  "creatorId": "user_id", // Reference to users
  "members": ["user_id_1", "user_id_2", ...], // Array of user IDs
  "maxMembers": 50,
  "createdAt": Timestamp,
  "updatedAt": Timestamp,
  "isPublic": true,
  "imageUrl": "https://storage.url/group.jpg", // nullable
  "settings": {
    "allowInvites": true,
    "requireApproval": false,
    "allowMaterialSharing": true
  },
  "stats": {
    "totalMaterials": 15,
    "totalDiscussions": 42,
    "activeMembers": 28
  },
  "tags": ["flutter", "mobile", "indonesia"]
}
```

**Indexes:**

- `category`
- `creatorId`
- `isPublic`
- `createdAt`

---

### 3. **learning_materials** Collection

**Purpose**: Konten pembelajaran (video, dokumen, quiz, dll)

```javascript
{
  "materialId": "auto_generated_id",
  "title": "Introduction to Flutter & Dart",
  "description": "Learn the basics of Flutter framework...",
  "category": "Programming",
  "type": "youtube_video", // youtube_video/document/quiz/article/course
  "url": "https://www.youtube.com/watch?v=...",
  "thumbnailUrl": "https://i.ytimg.com/.../maxresdefault.jpg",
  "creatorId": "user_id", // Reference to users
  "createdAt": Timestamp,
  "updatedAt": Timestamp,
  "tags": ["flutter", "dart", "mobile", "programming"],
  "difficulty": 1, // 1-5 (Beginner/Easy/Intermediate/Advanced/Expert)
  "estimatedDuration": 45, // in minutes
  "metadata": {
    "viewCount": 125000,
    "likeCount": 8500,
    "commentCount": 450,
    "channelTitle": "Code Academy", // for YouTube videos
    "publishedAt": Timestamp,
    "language": "id" // id/en
  },
  "isPublished": true,
  "isPremium": false,
  "groupId": "group_id", // nullable - if shared in a group
  "relatedMaterials": ["material_id_1", "material_id_2"] // Array of material IDs
}
```

**Indexes:**

- `category`
- `type`
- `creatorId`
- `difficulty`
- `isPublished`
- `createdAt`
- `tags` (Array-contains)

---

### 4. **user_progress** Collection

**Purpose**: Tracking progress belajar user

```javascript
{
  "progressId": "userId_materialId", // Composite key
  "userId": "user_id",
  "materialId": "material_id",
  "progress": 0.75, // 0.0 - 1.0 (0% - 100%)
  "lastUpdated": Timestamp,
  "completedAt": Timestamp, // nullable - when progress = 1.0
  "startedAt": Timestamp,
  "timeSpent": 2700, // in seconds
  "additionalData": {
    "currentPosition": "15:30", // for videos
    "lastPage": 25, // for documents
    "quizScore": 85, // for quizzes
    "attempts": 2
  },
  "notes": "Catatan pribadi tentang material ini...", // nullable
  "rating": 4.5, // 0-5, nullable
  "isFavorite": false
}
```

**Indexes:**

- `userId`
- `materialId`
- `progress`
- `lastUpdated`
- Composite: `userId + materialId` (Unique)

---

### 5. **quizzes** Collection

**Purpose**: Data quiz/kuis

```javascript
{
  "quizId": "auto_generated_id",
  "title": "Flutter Basics Quiz",
  "description": "Test your Flutter knowledge!",
  "category": "Programming",
  "creatorId": "user_id",
  "createdAt": Timestamp,
  "updatedAt": Timestamp,
  "difficulty": 2,
  "estimatedDuration": 15, // in minutes
  "totalQuestions": 10,
  "passingScore": 70, // percentage
  "questions": [
    {
      "questionId": "q1",
      "question": "What is Flutter?",
      "type": "multiple_choice", // multiple_choice/true_false/fill_blank
      "options": ["Framework", "Language", "IDE", "Database"],
      "correctAnswer": 0, // index or value
      "explanation": "Flutter is a UI framework...",
      "points": 10
    }
  ],
  "tags": ["flutter", "basics", "beginner"],
  "isPublished": true,
  "materialId": "material_id" // nullable - if related to a material
}
```

**Indexes:**

- `category`
- `creatorId`
- `difficulty`
- `isPublished`

---

### 6. **quiz_attempts** Collection

**Purpose**: Hasil quiz yang diambil user

```javascript
{
  "attemptId": "auto_generated_id",
  "userId": "user_id",
  "quizId": "quiz_id",
  "startedAt": Timestamp,
  "completedAt": Timestamp, // nullable if not finished
  "score": 85, // percentage
  "correctAnswers": 17,
  "totalQuestions": 20,
  "timeSpent": 900, // in seconds
  "answers": [
    {
      "questionId": "q1",
      "userAnswer": 0,
      "isCorrect": true,
      "timeSpent": 45
    }
  ],
  "isPassed": true
}
```

**Indexes:**

- `userId`
- `quizId`
- `completedAt`

---

### 7. **qna_questions** Collection

**Purpose**: Forum Q&A - Pertanyaan

```javascript
{
  "questionId": "auto_generated_id",
  "title": "How to implement Riverpod in Flutter?",
  "content": "I'm having trouble understanding...",
  "category": "Programming",
  "tags": ["flutter", "riverpod", "state-management"],
  "authorId": "user_id",
  "createdAt": Timestamp,
  "updatedAt": Timestamp,
  "viewCount": 245,
  "upvotes": 15,
  "downvotes": 2,
  "answerCount": 3,
  "hasAcceptedAnswer": true,
  "acceptedAnswerId": "answer_id", // nullable
  "isClosed": false,
  "closedReason": "", // nullable
  "attachments": ["url1", "url2"], // Array of URLs
  "relatedQuestions": ["question_id_1", "question_id_2"]
}
```

**Indexes:**

- `category`
- `authorId`
- `tags` (Array-contains)
- `createdAt`
- `hasAcceptedAnswer`

---

### 8. **qna_answers** Collection

**Purpose**: Forum Q&A - Jawaban

```javascript
{
  "answerId": "auto_generated_id",
  "questionId": "question_id",
  "content": "You can implement Riverpod by...",
  "authorId": "user_id",
  "createdAt": Timestamp,
  "updatedAt": Timestamp,
  "upvotes": 12,
  "downvotes": 1,
  "isAccepted": false,
  "attachments": ["url1", "url2"],
  "codeSnippets": [
    {
      "language": "dart",
      "code": "final provider = StateProvider<int>..."
    }
  ]
}
```

**Indexes:**

- `questionId`
- `authorId`
- `isAccepted`
- `createdAt`

---

### 9. **comments** Collection

**Purpose**: Komentar untuk materials, questions, answers

```javascript
{
  "commentId": "auto_generated_id",
  "parentType": "material", // material/question/answer/comment
  "parentId": "parent_id",
  "content": "Great explanation!",
  "authorId": "user_id",
  "createdAt": Timestamp,
  "updatedAt": Timestamp,
  "upvotes": 5,
  "downvotes": 0,
  "replyCount": 2,
  "isEdited": false,
  "isDeleted": false
}
```

**Indexes:**

- `parentType + parentId` (Composite)
- `authorId`
- `createdAt`

---

### 10. **notifications** Collection

**Purpose**: Notifikasi user

```javascript
{
  "notificationId": "auto_generated_id",
  "userId": "user_id",
  "type": "new_answer", // new_answer/group_invite/material_shared/achievement/system
  "title": "New answer to your question",
  "message": "John Doe answered your question about...",
  "data": {
    "questionId": "question_id",
    "answerId": "answer_id"
  },
  "imageUrl": "https://...", // nullable
  "isRead": false,
  "createdAt": Timestamp,
  "expiresAt": Timestamp // nullable
}
```

**Indexes:**

- `userId`
- `isRead`
- `createdAt`

---

### 11. **badges** Collection

**Purpose**: Badges untuk gamification

```javascript
{
  "badgeId": "auto_generated_id",
  "name": "First Material",
  "description": "Complete your first learning material",
  "imageUrl": "https://storage.url/badge.png",
  "category": "learning", // learning/social/achievement/special
  "criteria": {
    "type": "material_completion",
    "threshold": 1
  },
  "points": 50,
  "rarity": "common" // common/rare/epic/legendary
}
```

---

### 12. **user_badges** Collection

**Purpose**: Tracking badges yang dimiliki user

```javascript
{
  "userBadgeId": "auto_generated_id",
  "userId": "user_id",
  "badgeId": "badge_id",
  "earnedAt": Timestamp,
  "progress": 1.0 // for progressive badges
}
```

**Indexes:**

- `userId`
- `badgeId`
- Composite: `userId + badgeId` (Unique)

---

### 13. **leaderboard** Collection

**Purpose**: Ranking users

```javascript
{
  "leaderboardId": "auto_generated_id",
  "userId": "user_id",
  "displayName": "John Doe",
  "photoUrl": "https://...",
  "totalPoints": 5250,
  "level": 12,
  "rank": 15,
  "weeklyPoints": 450,
  "monthlyPoints": 1800,
  "stats": {
    "materialsCompleted": 45,
    "quizzesPassed": 28,
    "questionsAnswered": 67,
    "badgesEarned": 18
  },
  "updatedAt": Timestamp
}
```

**Indexes:**

- `totalPoints` (Descending)
- `weeklyPoints` (Descending)
- `monthlyPoints` (Descending)
- `userId` (Unique)

---

### 14. **group_posts** Collection

**Purpose**: Post dalam study group

```javascript
{
  "postId": "auto_generated_id",
  "groupId": "group_id",
  "authorId": "user_id",
  "type": "discussion", // discussion/material_share/announcement/poll
  "title": "New Flutter 3.0 Features",
  "content": "Let's discuss the new features...",
  "attachments": ["url1", "url2"],
  "materialId": "material_id", // nullable - if sharing material
  "createdAt": Timestamp,
  "updatedAt": Timestamp,
  "likeCount": 25,
  "commentCount": 8,
  "isPinned": false
}
```

**Indexes:**

- `groupId`
- `authorId`
- `type`
- `createdAt`

---

## 💾 SQLITE/DRIFT (LOCAL DATABASE)

### Purpose: Offline storage & caching

---

### Tables Schema

### 1. **cached_materials** Table

```sql
CREATE TABLE cached_materials (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  description TEXT,
  category TEXT,
  type TEXT,
  url TEXT,
  thumbnail_url TEXT,
  creator_id TEXT,
  created_at INTEGER, -- Unix timestamp
  updated_at INTEGER,
  tags TEXT, -- JSON array
  difficulty INTEGER,
  estimated_duration INTEGER,
  metadata TEXT, -- JSON object
  cached_at INTEGER, -- Unix timestamp
  is_favorite INTEGER DEFAULT 0 -- Boolean (0/1)
);

CREATE INDEX idx_category ON cached_materials(category);
CREATE INDEX idx_type ON cached_materials(type);
CREATE INDEX idx_is_favorite ON cached_materials(is_favorite);
```

---

### 2. **cached_groups** Table

```sql
CREATE TABLE cached_groups (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT,
  category TEXT,
  creator_id TEXT,
  members TEXT, -- JSON array
  max_members INTEGER,
  created_at INTEGER,
  updated_at INTEGER,
  is_public INTEGER,
  image_url TEXT,
  settings TEXT, -- JSON object
  cached_at INTEGER
);

CREATE INDEX idx_group_category ON cached_groups(category);
```

---

### 3. **offline_progress** Table

```sql
CREATE TABLE offline_progress (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  material_id TEXT NOT NULL,
  progress REAL, -- 0.0 to 1.0
  last_updated INTEGER,
  completed_at INTEGER,
  time_spent INTEGER,
  additional_data TEXT, -- JSON object
  sync_status TEXT, -- 'pending', 'synced', 'error'
  UNIQUE(user_id, material_id)
);

CREATE INDEX idx_user_progress ON offline_progress(user_id);
CREATE INDEX idx_sync_status ON offline_progress(sync_status);
```

---

### 4. **download_queue** Table

```sql
CREATE TABLE download_queue (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  material_id TEXT NOT NULL,
  url TEXT NOT NULL,
  local_path TEXT,
  status TEXT, -- 'pending', 'downloading', 'completed', 'error'
  progress REAL,
  file_size INTEGER,
  downloaded_size INTEGER,
  created_at INTEGER,
  completed_at INTEGER,
  error_message TEXT
);

CREATE INDEX idx_download_status ON download_queue(status);
```

---

### 5. **user_settings** Table

```sql
CREATE TABLE user_settings (
  key TEXT PRIMARY KEY,
  value TEXT NOT NULL,
  updated_at INTEGER
);
```

---

## 🔗 DATABASE RELATIONSHIPS

### Firestore Relationships (Reference-based)

```
users (1) ─────< (N) learning_materials
  │                     │
  │                     └─< (N) user_progress
  │
  ├─────< (N) study_groups (as creator)
  │
  ├─────< (N) group_members (many-to-many via array)
  │
  ├─────< (N) qna_questions
  │
  ├─────< (N) qna_answers
  │
  ├─────< (N) comments
  │
  ├─────< (N) notifications
  │
  └─────< (N) user_badges

study_groups (1) ─────< (N) group_posts
             (1) ─────< (N) learning_materials

learning_materials (1) ─────< (N) user_progress
                   (1) ─────< (N) comments
                   (1) ─────< (N) quizzes

quizzes (1) ─────< (N) quiz_attempts

qna_questions (1) ─────< (N) qna_answers
              (1) ─────< (N) comments

qna_answers (1) ─────< (N) comments

badges (1) ─────< (N) user_badges
```

---

## 🔄 DATA SYNC STRATEGY

### Firebase ↔ Local SQLite

```dart
// Sync Strategy
class DataSyncService {
  // 1. Fetch from Firestore
  Future<void> syncFromCloud() async {
    // Fetch latest data from Firestore
    // Store in local SQLite
    // Update cached_at timestamp
  }

  // 2. Upload to Firestore
  Future<void> syncToCloud() async {
    // Get pending offline data
    // Upload to Firestore
    // Update sync_status
  }

  // 3. Periodic sync (every 15 minutes when online)
  void startPeriodicSync() {
    Timer.periodic(Duration(minutes: 15), (_) {
      if (isOnline) {
        syncFromCloud();
        syncToCloud();
      }
    });
  }
}
```

---

## 📊 INDEXING STRATEGY

### Firestore Indexes

```javascript
// Composite Indexes
study_groups: [category, isPublic, createdAt];
learning_materials: [category, difficulty, createdAt];
learning_materials: [type, isPublished, createdAt];
user_progress: [userId, materialId];
qna_questions: [category, hasAcceptedAnswer, createdAt];
notifications: [userId, isRead, createdAt];
```

### SQLite Indexes

```sql
-- Already defined in table creation
-- Additional composite indexes
CREATE INDEX idx_progress_sync ON offline_progress(user_id, sync_status);
CREATE INDEX idx_materials_category_difficulty ON cached_materials(category, difficulty);
```

---

## 🔒 SECURITY RULES (Firestore)

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // Helper functions
    function isSignedIn() {
      return request.auth != null;
    }

    function isOwner(userId) {
      return isSignedIn() && request.auth.uid == userId;
    }

    // Users collection
    match /users/{userId} {
      allow read: if isSignedIn();
      allow create: if isSignedIn() && isOwner(userId);
      allow update: if isOwner(userId);
      allow delete: if isOwner(userId);
    }

    // Study groups
    match /study_groups/{groupId} {
      allow read: if isSignedIn();
      allow create: if isSignedIn();
      allow update: if isSignedIn() &&
        (isOwner(resource.data.creatorId) ||
         request.auth.uid in resource.data.members);
      allow delete: if isOwner(resource.data.creatorId);
    }

    // Learning materials
    match /learning_materials/{materialId} {
      allow read: if isSignedIn();
      allow create: if isSignedIn();
      allow update: if isOwner(resource.data.creatorId);
      allow delete: if isOwner(resource.data.creatorId);
    }

    // User progress
    match /user_progress/{progressId} {
      allow read: if isOwner(resource.data.userId);
      allow write: if isSignedIn() && isOwner(request.resource.data.userId);
    }

    // Quizzes
    match /quizzes/{quizId} {
      allow read: if isSignedIn();
      allow write: if isOwner(resource.data.creatorId);
    }

    // Q&A
    match /qna_questions/{questionId} {
      allow read: if isSignedIn();
      allow create: if isSignedIn();
      allow update, delete: if isOwner(resource.data.authorId);
    }

    match /qna_answers/{answerId} {
      allow read: if isSignedIn();
      allow create: if isSignedIn();
      allow update, delete: if isOwner(resource.data.authorId);
    }

    // Comments
    match /comments/{commentId} {
      allow read: if isSignedIn();
      allow create: if isSignedIn();
      allow update, delete: if isOwner(resource.data.authorId);
    }

    // Notifications
    match /notifications/{notificationId} {
      allow read: if isOwner(resource.data.userId);
      allow write: if false; // Only server can write
    }
  }
}
```

---

## 📈 PERFORMANCE OPTIMIZATION

### 1. **Pagination**

```dart
// Firestore pagination
Query query = FirebaseFirestore.instance
  .collection('learning_materials')
  .orderBy('createdAt', descending: true)
  .limit(20);

// Load more
query = query.startAfterDocument(lastDocument);
```

### 2. **Caching Strategy**

```dart
// Cache-first approach
Future<List<Material>> getMaterials() async {
  // Try local cache first
  final cached = await localDb.getMaterials();
  if (cached.isNotEmpty && !isStale(cached)) {
    return cached;
  }

  // Fetch from cloud
  final cloud = await firestore.getMaterials();
  await localDb.cacheMaterials(cloud);
  return cloud;
}
```

### 3. **Batch Operations**

```dart
// Firestore batch write
WriteBatch batch = FirebaseFirestore.instance.batch();
batch.set(ref1, data1);
batch.update(ref2, data2);
batch.delete(ref3);
await batch.commit();
```

---

## 🎯 MIGRATION PLAN

### Phase 1: Basic Setup

- ✅ Setup Firebase project
- ✅ Create basic collections (users, materials, groups)
- ✅ Implement Firestore service
- ✅ Setup local SQLite

### Phase 2: Core Features

- 🔜 User authentication & profiles
- 🔜 Learning materials CRUD
- 🔜 Study groups CRUD
- 🔜 Progress tracking

### Phase 3: Advanced Features

- 🔜 Quiz system
- 🔜 Q&A forum
- 🔜 Comments & interactions
- 🔜 Notifications

### Phase 4: Gamification

- 🔜 Badges & achievements
- 🔜 Leaderboard
- 🔜 Points system

---

## 📝 NOTES

### Best Practices

1. ✅ Use subcollections for nested data
2. ✅ Denormalize when needed for performance
3. ✅ Keep documents under 1MB
4. ✅ Use pagination for large lists
5. ✅ Implement proper indexes
6. ✅ Cache frequently accessed data locally
7. ✅ Use batch/transaction for related writes

### Scalability Considerations

- Firestore supports up to 1M concurrent connections
- Use Cloud Functions for complex backend logic
- Implement data archiving for old data
- Monitor and optimize query costs

---

**Status**: ✅ Design Complete  
**Ready for**: Implementation  
**Last Updated**: November 4, 2025
