# 🛠️ DATABASE IMPLEMENTATION GUIDE

## 📋 Step-by-Step Implementation Plan

Panduan lengkap implementasi database dari nol hingga production-ready.

---

## 🎯 Phase 1: Firebase Project Setup (30 menit)

### ✅ Checklist

- [ ] 1.1 Buat Firebase project
- [ ] 1.2 Enable Firestore database
- [ ] 1.3 Configure authentication
- [ ] 1.4 Setup security rules
- [ ] 1.5 Configure FlutterFire

---

### 📝 1.1 Buat Firebase Project

1. **Buka Firebase Console**

   - Go to: https://console.firebase.google.com/
   - Click "Add project"

2. **Konfigurasi Project**

   ```
   Project name: belajarbareng-app
   Google Analytics: Enable (recommended)
   Location: Asia/Jakarta
   ```

3. **Add Flutter App**
   - Click "Add app" → Flutter icon
   - Package name: `com.belajarbareng.app`
   - App nickname: `BelajarBareng`

---

### 📝 1.2 Enable Firestore Database

1. **Create Database**

   - Sidebar → Build → Firestore Database
   - Click "Create database"

2. **Select Mode**

   ```
   ✅ Start in test mode (untuk development)

   Nanti ganti ke production mode dengan rules:
   - Setelah authentication siap
   - Setelah security rules configured
   ```

3. **Choose Location**
   ```
   Recommended: asia-southeast1 (Singapore)
   - Closest to Indonesia
   - Low latency
   ```

---

### 📝 1.3 Configure Authentication

1. **Enable Authentication Providers**

   - Sidebar → Build → Authentication
   - Click "Get started"
   - Sign-in method tab

2. **Enable Providers**

   ```
   ✅ Email/Password
   ✅ Google
   ✅ Anonymous (for guest users)

   Optional:
   □ Facebook
   □ Apple
   ```

3. **Authorized Domains**
   - Add: `localhost` (for development)
   - Add your production domain later

---

### 📝 1.4 Setup Security Rules

**Copy paste rules ini ke Firestore Database → Rules**

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // Helper functions
    function isSignedIn() {
      return request.auth != null;
    }

    function isOwner(userId) {
      return request.auth.uid == userId;
    }

    // Users collection
    match /users/{userId} {
      allow read: if isSignedIn();
      allow write: if isOwner(userId);
    }

    // Study Groups
    match /study_groups/{groupId} {
      allow read: if isSignedIn();
      allow create: if isSignedIn();
      allow update: if isSignedIn() &&
        (isOwner(resource.data.creatorId) ||
         request.auth.uid in resource.data.members);
      allow delete: if isOwner(resource.data.creatorId);
    }

    // Learning Materials
    match /learning_materials/{materialId} {
      allow read: if isSignedIn();
      allow create: if isSignedIn();
      allow update, delete: if isOwner(resource.data.creatorId);
    }

    // User Progress
    match /user_progress/{progressId} {
      allow read, write: if isSignedIn() && isOwner(resource.data.userId);
    }

    // Quizzes
    match /quizzes/{quizId} {
      allow read: if isSignedIn();
      allow create: if isSignedIn();
      allow update, delete: if isOwner(resource.data.creatorId);
    }

    // Quiz Attempts
    match /quiz_attempts/{attemptId} {
      allow read, write: if isSignedIn() && isOwner(resource.data.userId);
    }

    // Q&A Questions
    match /qna_questions/{questionId} {
      allow read: if isSignedIn();
      allow create: if isSignedIn();
      allow update: if isSignedIn() &&
        (isOwner(resource.data.authorId) ||
         request.auth.uid in get(/databases/$(database)/documents/users/$(request.auth.uid)).data.roles);
      allow delete: if isOwner(resource.data.authorId);
    }

    // Q&A Answers
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
      allow read: if isSignedIn() && isOwner(resource.data.userId);
      allow write: if false; // Only server can write
    }

    // Badges (read-only for users)
    match /badges/{badgeId} {
      allow read: if isSignedIn();
      allow write: if false; // Admin only
    }

    // User Badges
    match /user_badges/{userBadgeId} {
      allow read: if isSignedIn();
      allow write: if false; // Only server can award badges
    }

    // Leaderboard (read-only)
    match /leaderboard/{leaderboardId} {
      allow read: if isSignedIn();
      allow write: if false; // Only server can update
    }

    // Group Posts
    match /group_posts/{postId} {
      allow read: if isSignedIn();
      allow create: if isSignedIn() &&
        request.auth.uid in get(/databases/$(database)/documents/study_groups/$(request.resource.data.groupId)).data.members;
      allow update, delete: if isOwner(resource.data.authorId);
    }
  }
}
```

**Publish rules** → Click "Publish"

---

### 📝 1.5 Configure FlutterFire

**Di terminal project Flutter:**

```bash
# 1. Install FlutterFire CLI
dart pub global activate flutterfire_cli

# 2. Configure Firebase for Flutter
flutterfire configure

# Pilih:
# - Select project: belajarbareng-app
# - Platforms: android, ios, web
# - Package name: com.belajarbareng.app

# 3. File firebase_options.dart akan auto-generated
```

**Verify `lib/firebase_options.dart` created** ✅

---

## 🎯 Phase 2: Firestore Service Implementation (1-2 jam)

### ✅ Checklist

- [ ] 2.1 Update Firebase Models
- [ ] 2.2 Implement CRUD operations
- [ ] 2.3 Add batch operations
- [ ] 2.4 Test Firestore connection

---

### 📝 2.1 Update Firebase Models

**File: `lib/src/api/models/firebase_models.dart`**

Sudah ada 4 models:

- ✅ UserModel
- ✅ StudyGroupModel
- ✅ LearningMaterialModel
- ✅ UserProgressModel

**Tambahkan models baru:**

```dart
// lib/src/api/models/quiz_models.dart
class QuizModel {
  final String quizId;
  final String title;
  final String description;
  final String category;
  final String creatorId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String difficulty; // easy, medium, hard
  final int estimatedDuration; // in minutes
  final int totalQuestions;
  final double passingScore; // 0.0 - 1.0
  final List<QuizQuestion> questions;
  final List<String> tags;
  final bool isPublished;
  final String? materialId;

  QuizModel({
    required this.quizId,
    required this.title,
    required this.description,
    required this.category,
    required this.creatorId,
    required this.createdAt,
    required this.updatedAt,
    required this.difficulty,
    required this.estimatedDuration,
    required this.totalQuestions,
    required this.passingScore,
    required this.questions,
    required this.tags,
    required this.isPublished,
    this.materialId,
  });

  factory QuizModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return QuizModel(
      quizId: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      creatorId: data['creatorId'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      difficulty: data['difficulty'] ?? 'medium',
      estimatedDuration: data['estimatedDuration'] ?? 0,
      totalQuestions: data['totalQuestions'] ?? 0,
      passingScore: (data['passingScore'] ?? 0.7).toDouble(),
      questions: (data['questions'] as List<dynamic>)
          .map((q) => QuizQuestion.fromMap(q))
          .toList(),
      tags: List<String>.from(data['tags'] ?? []),
      isPublished: data['isPublished'] ?? false,
      materialId: data['materialId'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'creatorId': creatorId,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'difficulty': difficulty,
      'estimatedDuration': estimatedDuration,
      'totalQuestions': totalQuestions,
      'passingScore': passingScore,
      'questions': questions.map((q) => q.toMap()).toList(),
      'tags': tags,
      'isPublished': isPublished,
      if (materialId != null) 'materialId': materialId,
    };
  }
}

class QuizQuestion {
  final String questionText;
  final List<String> options;
  final int correctAnswerIndex;
  final String? explanation;

  QuizQuestion({
    required this.questionText,
    required this.options,
    required this.correctAnswerIndex,
    this.explanation,
  });

  factory QuizQuestion.fromMap(Map<String, dynamic> map) {
    return QuizQuestion(
      questionText: map['questionText'] ?? '',
      options: List<String>.from(map['options'] ?? []),
      correctAnswerIndex: map['correctAnswerIndex'] ?? 0,
      explanation: map['explanation'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'questionText': questionText,
      'options': options,
      'correctAnswerIndex': correctAnswerIndex,
      if (explanation != null) 'explanation': explanation,
    };
  }
}

class QuizAttemptModel {
  final String attemptId;
  final String userId;
  final String quizId;
  final DateTime startedAt;
  final DateTime? completedAt;
  final double score;
  final int correctAnswers;
  final int totalQuestions;
  final int timeSpent; // in seconds
  final List<UserAnswer> answers;
  final bool isPassed;

  QuizAttemptModel({
    required this.attemptId,
    required this.userId,
    required this.quizId,
    required this.startedAt,
    this.completedAt,
    required this.score,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.timeSpent,
    required this.answers,
    required this.isPassed,
  });

  factory QuizAttemptModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return QuizAttemptModel(
      attemptId: doc.id,
      userId: data['userId'] ?? '',
      quizId: data['quizId'] ?? '',
      startedAt: (data['startedAt'] as Timestamp).toDate(),
      completedAt: data['completedAt'] != null
          ? (data['completedAt'] as Timestamp).toDate()
          : null,
      score: (data['score'] ?? 0.0).toDouble(),
      correctAnswers: data['correctAnswers'] ?? 0,
      totalQuestions: data['totalQuestions'] ?? 0,
      timeSpent: data['timeSpent'] ?? 0,
      answers: (data['answers'] as List<dynamic>)
          .map((a) => UserAnswer.fromMap(a))
          .toList(),
      isPassed: data['isPassed'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'quizId': quizId,
      'startedAt': Timestamp.fromDate(startedAt),
      if (completedAt != null) 'completedAt': Timestamp.fromDate(completedAt!),
      'score': score,
      'correctAnswers': correctAnswers,
      'totalQuestions': totalQuestions,
      'timeSpent': timeSpent,
      'answers': answers.map((a) => a.toMap()).toList(),
      'isPassed': isPassed,
    };
  }
}

class UserAnswer {
  final int questionIndex;
  final int selectedAnswerIndex;
  final bool isCorrect;

  UserAnswer({
    required this.questionIndex,
    required this.selectedAnswerIndex,
    required this.isCorrect,
  });

  factory UserAnswer.fromMap(Map<String, dynamic> map) {
    return UserAnswer(
      questionIndex: map['questionIndex'] ?? 0,
      selectedAnswerIndex: map['selectedAnswerIndex'] ?? 0,
      isCorrect: map['isCorrect'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'questionIndex': questionIndex,
      'selectedAnswerIndex': selectedAnswerIndex,
      'isCorrect': isCorrect,
    };
  }
}
```

**Buat juga models untuk:**

- QnAQuestionModel
- QnAAnswerModel
- CommentModel
- NotificationModel
- BadgeModel
- UserBadgeModel
- LeaderboardModel
- GroupPostModel

(Lihat DATABASE_DESIGN.md untuk struktur lengkap)

---

### 📝 2.2 Implement CRUD Operations

**File: `lib/src/api/firebase/firestore_service.dart`**

Tambahkan methods untuk collections baru:

```dart
class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ========== QUIZ METHODS ==========

  Future<void> createQuiz(QuizModel quiz) async {
    await _db.collection('quizzes').doc(quiz.quizId).set(quiz.toFirestore());
  }

  Future<QuizModel?> getQuiz(String quizId) async {
    DocumentSnapshot doc = await _db.collection('quizzes').doc(quizId).get();
    if (!doc.exists) return null;
    return QuizModel.fromFirestore(doc);
  }

  Stream<List<QuizModel>> getQuizzesByCategory(String category) {
    return _db
        .collection('quizzes')
        .where('category', isEqualTo: category)
        .where('isPublished', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => QuizModel.fromFirestore(doc))
            .toList());
  }

  Future<void> submitQuizAttempt(QuizAttemptModel attempt) async {
    await _db.collection('quiz_attempts').doc(attempt.attemptId).set(attempt.toFirestore());
  }

  Stream<List<QuizAttemptModel>> getUserQuizAttempts(String userId) {
    return _db
        .collection('quiz_attempts')
        .where('userId', isEqualTo: userId)
        .orderBy('startedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => QuizAttemptModel.fromFirestore(doc))
            .toList());
  }

  // ========== Q&A METHODS ==========

  Future<void> askQuestion(QnAQuestionModel question) async {
    await _db.collection('qna_questions').doc(question.questionId).set(question.toFirestore());
  }

  Stream<List<QnAQuestionModel>> getQuestions({String? category}) {
    Query query = _db.collection('qna_questions');

    if (category != null) {
      query = query.where('category', isEqualTo: category);
    }

    return query
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => QnAQuestionModel.fromFirestore(doc))
            .toList());
  }

  Future<void> postAnswer(QnAAnswerModel answer) async {
    WriteBatch batch = _db.batch();

    // Add answer
    batch.set(_db.collection('qna_answers').doc(answer.answerId), answer.toFirestore());

    // Increment answer count in question
    batch.update(
      _db.collection('qna_questions').doc(answer.questionId),
      {'answerCount': FieldValue.increment(1)},
    );

    await batch.commit();
  }

  Stream<List<QnAAnswerModel>> getAnswersForQuestion(String questionId) {
    return _db
        .collection('qna_answers')
        .where('questionId', isEqualTo: questionId)
        .orderBy('upvotes', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => QnAAnswerModel.fromFirestore(doc))
            .toList());
  }

  Future<void> acceptAnswer(String questionId, String answerId) async {
    WriteBatch batch = _db.batch();

    // Update question with accepted answer
    batch.update(
      _db.collection('qna_questions').doc(questionId),
      {
        'hasAcceptedAnswer': true,
        'acceptedAnswerId': answerId,
      },
    );

    // Mark answer as accepted
    batch.update(
      _db.collection('qna_answers').doc(answerId),
      {'isAccepted': true},
    );

    await batch.commit();
  }

  // ========== GAMIFICATION METHODS ==========

  Future<void> awardBadge(String userId, String badgeId) async {
    final userBadgeId = '${userId}_${badgeId}';

    final userBadge = UserBadgeModel(
      userBadgeId: userBadgeId,
      userId: userId,
      badgeId: badgeId,
      earnedAt: DateTime.now(),
      progress: 1.0,
    );

    WriteBatch batch = _db.batch();

    // Add user badge
    batch.set(_db.collection('user_badges').doc(userBadgeId), userBadge.toFirestore());

    // Update user's badges array
    batch.update(
      _db.collection('users').doc(userId),
      {
        'badges': FieldValue.arrayUnion([badgeId]),
        'stats.totalBadges': FieldValue.increment(1),
      },
    );

    await batch.commit();
  }

  Future<void> updateLeaderboard(String userId, int pointsToAdd) async {
    DocumentReference leaderboardRef = _db.collection('leaderboard').doc(userId);

    await _db.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(leaderboardRef);

      if (!snapshot.exists) {
        // Create new leaderboard entry
        final user = await _db.collection('users').doc(userId).get();
        final userData = user.data() as Map<String, dynamic>;

        transaction.set(leaderboardRef, {
          'userId': userId,
          'displayName': userData['displayName'],
          'photoUrl': userData['photoUrl'],
          'totalPoints': pointsToAdd,
          'level': 1,
          'rank': 0, // Will be calculated later
          'weeklyPoints': pointsToAdd,
          'monthlyPoints': pointsToAdd,
          'stats': {},
          'updatedAt': FieldValue.serverTimestamp(),
        });
      } else {
        // Update existing entry
        transaction.update(leaderboardRef, {
          'totalPoints': FieldValue.increment(pointsToAdd),
          'weeklyPoints': FieldValue.increment(pointsToAdd),
          'monthlyPoints': FieldValue.increment(pointsToAdd),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
    });
  }

  Stream<List<LeaderboardModel>> getTopLeaderboard({int limit = 100}) {
    return _db
        .collection('leaderboard')
        .orderBy('totalPoints', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => LeaderboardModel.fromFirestore(doc))
            .toList());
  }
}
```

---

### 📝 2.3 Add Batch Operations

**Untuk operasi yang kompleks:**

```dart
// Example: Complete a quiz and update stats
Future<void> completeQuizWithRewards(
  QuizAttemptModel attempt,
  int pointsEarned,
  List<String> badgesEarned,
) async {
  WriteBatch batch = _db.batch();

  // 1. Save quiz attempt
  batch.set(
    _db.collection('quiz_attempts').doc(attempt.attemptId),
    attempt.toFirestore(),
  );

  // 2. Update user stats
  batch.update(_db.collection('users').doc(attempt.userId), {
    'stats.quizzesCompleted': FieldValue.increment(1),
    'stats.totalPoints': FieldValue.increment(pointsEarned),
  });

  // 3. Update leaderboard
  batch.update(_db.collection('leaderboard').doc(attempt.userId), {
    'totalPoints': FieldValue.increment(pointsEarned),
    'weeklyPoints': FieldValue.increment(pointsEarned),
  });

  // 4. Award badges
  for (String badgeId in badgesEarned) {
    final userBadgeId = '${attempt.userId}_${badgeId}';
    batch.set(_db.collection('user_badges').doc(userBadgeId), {
      'userId': attempt.userId,
      'badgeId': badgeId,
      'earnedAt': FieldValue.serverTimestamp(),
      'progress': 1.0,
    });
  }

  await batch.commit();
}
```

---

### 📝 2.4 Test Firestore Connection

**Buat file test: `test/firestore_test.dart`**

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  group('Firestore Connection Tests', () {
    test('Should connect to Firestore', () async {
      final db = FirebaseFirestore.instance;

      // Try to read from users collection
      final snapshot = await db.collection('users').limit(1).get();

      expect(snapshot, isNotNull);
      print('✅ Firestore connection successful');
    });

    test('Should create test user', () async {
      final db = FirebaseFirestore.instance;

      final testUser = {
        'email': 'test@example.com',
        'displayName': 'Test User',
        'createdAt': FieldValue.serverTimestamp(),
      };

      await db.collection('users').doc('test_user').set(testUser);

      final doc = await db.collection('users').doc('test_user').get();
      expect(doc.exists, true);
      expect(doc.data()?['email'], 'test@example.com');

      // Cleanup
      await db.collection('users').doc('test_user').delete();

      print('✅ Create and delete test successful');
    });
  });
}
```

**Run test:**

```bash
flutter test test/firestore_test.dart
```

---

## 🎯 Phase 3: Local Database Setup (1 jam)

### ✅ Checklist

- [ ] 3.1 Install Drift dependencies
- [ ] 3.2 Create database tables
- [ ] 3.3 Generate database code
- [ ] 3.4 Test local database

---

### 📝 3.1 Install Drift Dependencies

**Sudah ada di `pubspec.yaml`:**

```yaml
dependencies:
  drift: ^2.13.0
  path: ^1.8.3

dev_dependencies:
  drift_dev: ^2.13.2
  build_runner: ^2.4.6
```

---

### 📝 3.2 Create Database Tables

**File: `lib/src/data/local/app_database.dart`**

```dart
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

// ========== TABLE DEFINITIONS ==========

class CachedMaterials extends Table {
  TextColumn get materialId => text()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  TextColumn get category => text()();
  TextColumn get type => text()();
  TextColumn get url => text().nullable()();
  TextColumn get thumbnailUrl => text().nullable()();
  TextColumn get creatorId => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get cachedAt => dateTime()();
  TextColumn get tags => text()(); // JSON array
  TextColumn get difficulty => text()();
  IntColumn get estimatedDuration => integer()();
  BoolColumn get isDownloaded => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {materialId};
}

class CachedGroups extends Table {
  TextColumn get groupId => text()();
  TextColumn get name => text()();
  TextColumn get description => text()();
  TextColumn get category => text()();
  TextColumn get creatorId => text()();
  TextColumn get members => text()(); // JSON array
  IntColumn get maxMembers => integer()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get cachedAt => dateTime()();
  BoolColumn get isPublic => boolean()();

  @override
  Set<Column> get primaryKey => {groupId};
}

class OfflineProgress extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get userId => text()();
  TextColumn get materialId => text()();
  RealColumn get progress => real()();
  DateTimeColumn get lastUpdated => dateTime()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  TextColumn get additionalData => text().nullable()(); // JSON
}

class DownloadQueue extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get materialId => text()();
  TextColumn get url => text()();
  TextColumn get localPath => text().nullable()();
  TextColumn get status => text()(); // pending, downloading, completed, failed
  RealColumn get progress => real().withDefault(const Constant(0.0))();
  DateTimeColumn get addedAt => dateTime()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  TextColumn get errorMessage => text().nullable()();
}

class UserSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

// ========== DATABASE CLASS ==========

@DriftDatabase(tables: [
  CachedMaterials,
  CachedGroups,
  OfflineProgress,
  DownloadQueue,
  UserSettings,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // ========== CACHED MATERIALS METHODS ==========

  Future<List<CachedMaterial>> getAllCachedMaterials() =>
      select(cachedMaterials).get();

  Future<CachedMaterial?> getCachedMaterial(String materialId) =>
      (select(cachedMaterials)..where((m) => m.materialId.equals(materialId)))
          .getSingleOrNull();

  Future<void> cacheMaterial(CachedMaterial material) =>
      into(cachedMaterials).insertOnConflictUpdate(material);

  Future<void> deleteCachedMaterial(String materialId) =>
      (delete(cachedMaterials)..where((m) => m.materialId.equals(materialId)))
          .go();

  // ========== OFFLINE PROGRESS METHODS ==========

  Future<List<OfflineProgressData>> getUnsyncedProgress() =>
      (select(offlineProgress)..where((p) => p.isSynced.equals(false))).get();

  Future<void> saveOfflineProgress(OfflineProgressCompanion progress) =>
      into(offlineProgress).insert(progress);

  Future<void> markProgressAsSynced(int id) =>
      (update(offlineProgress)..where((p) => p.id.equals(id)))
          .write(const OfflineProgressCompanion(isSynced: Value(true)));

  // ========== DOWNLOAD QUEUE METHODS ==========

  Future<List<DownloadQueueData>> getPendingDownloads() =>
      (select(downloadQueue)..where((d) => d.status.equals('pending'))).get();

  Future<void> addToDownloadQueue(DownloadQueueCompanion download) =>
      into(downloadQueue).insert(download);

  Future<void> updateDownloadProgress(int id, double progress) =>
      (update(downloadQueue)..where((d) => d.id.equals(id)))
          .write(DownloadQueueCompanion(progress: Value(progress)));

  Future<void> markDownloadCompleted(int id, String localPath) =>
      (update(downloadQueue)..where((d) => d.id.equals(id)))
          .write(DownloadQueueCompanion(
            status: const Value('completed'),
            localPath: Value(localPath),
            completedAt: Value(DateTime.now()),
          ));

  // ========== USER SETTINGS METHODS ==========

  Future<String?> getSetting(String key) async {
    final setting = await (select(userSettings)
          ..where((s) => s.key.equals(key)))
        .getSingleOrNull();
    return setting?.value;
  }

  Future<void> saveSetting(String key, String value) =>
      into(userSettings).insertOnConflictUpdate(
        UserSetting(key: key, value: value),
      );
}

// ========== DATABASE CONNECTION ==========

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'belajarbareng.db'));
    return NativeDatabase(file);
  });
}
```

---

### 📝 3.3 Generate Database Code

```bash
# Run build_runner to generate app_database.g.dart
dart run build_runner build --delete-conflicting-outputs

# Or use watch mode (auto-rebuild on changes)
dart run build_runner watch --delete-conflicting-outputs
```

**Verify: `lib/src/data/local/app_database.g.dart` created** ✅

---

### 📝 3.4 Test Local Database

**File: `test/local_db_test.dart`**

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import '../lib/src/data/local/app_database.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    // Use in-memory database for testing
    database = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  group('Local Database Tests', () {
    test('Should save and retrieve cached material', () async {
      final material = CachedMaterialsCompanion.insert(
        materialId: 'test_1',
        title: 'Test Material',
        description: 'Test Description',
        category: 'programming',
        type: 'video',
        creatorId: 'user_1',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        cachedAt: DateTime.now(),
        tags: '["flutter", "dart"]',
        difficulty: 'medium',
        estimatedDuration: 30,
      );

      await database.cacheMaterial(material);

      final retrieved = await database.getCachedMaterial('test_1');
      expect(retrieved, isNotNull);
      expect(retrieved?.title, 'Test Material');

      print('✅ Local database test successful');
    });
  });
}
```

---

## 🎯 Phase 4: Sync Service (2 jam)

### ✅ Checklist

- [ ] 4.1 Create sync service
- [ ] 4.2 Implement background sync
- [ ] 4.3 Handle conflicts
- [ ] 4.4 Setup Riverpod providers

---

### 📝 4.1 Create Sync Service

**File: `lib/src/data/sync/sync_service.dart`**

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../local/app_database.dart';
import '../../api/firebase/firestore_service.dart';
import '../../api/models/firebase_models.dart';

class SyncService {
  final AppDatabase _localDb;
  final FirestoreService _firestore;
  final Connectivity _connectivity = Connectivity();

  SyncService(this._localDb, this._firestore);

  // ========== SYNC MATERIALS ==========

  Future<void> syncMaterials() async {
    // Check internet connection
    final connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      print('⚠️ No internet connection. Skipping sync.');
      return;
    }

    try {
      // Fetch from Firestore
      final materials = await _firestore.getAllMaterials();

      // Cache to local database
      for (var material in materials) {
        final cached = CachedMaterialsCompanion.insert(
          materialId: material.materialId,
          title: material.title,
          description: material.description,
          category: material.category,
          type: material.type,
          url: Value(material.url),
          thumbnailUrl: Value(material.thumbnailUrl),
          creatorId: material.creatorId,
          createdAt: material.createdAt,
          updatedAt: material.updatedAt,
          cachedAt: DateTime.now(),
          tags: material.tags.join(','),
          difficulty: material.difficulty,
          estimatedDuration: material.estimatedDuration,
        );

        await _localDb.cacheMaterial(cached);
      }

      print('✅ Materials synced successfully');
    } catch (e) {
      print('❌ Error syncing materials: $e');
    }
  }

  // ========== SYNC PROGRESS ==========

  Future<void> syncProgress(String userId) async {
    final connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      print('⚠️ No internet connection. Progress will sync later.');
      return;
    }

    try {
      // Get unsynced progress from local DB
      final unsyncedProgress = await _localDb.getUnsyncedProgress();

      // Upload to Firestore
      for (var progress in unsyncedProgress) {
        await _firestore.updateUserProgress(
          userId,
          progress.materialId,
          progress.progress,
        );

        // Mark as synced
        await _localDb.markProgressAsSynced(progress.id);
      }

      print('✅ Progress synced: ${unsyncedProgress.length} items');
    } catch (e) {
      print('❌ Error syncing progress: $e');
    }
  }

  // ========== AUTO SYNC ==========

  Stream<void> autoSync(String userId) {
    return Stream.periodic(const Duration(minutes: 5), (_) async {
      await syncMaterials();
      await syncProgress(userId);
    }).asyncMap((event) => event);
  }
}
```

---

### 📝 4.2 Setup Riverpod Providers

**File: `lib/src/providers/database_providers.dart`**

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/firebase/firestore_service.dart';
import '../data/local/app_database.dart';
import '../data/sync/sync_service.dart';

// Firestore Service Provider
final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService();
});

// Local Database Provider
final localDatabaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

// Sync Service Provider
final syncServiceProvider = Provider<SyncService>((ref) {
  final localDb = ref.watch(localDatabaseProvider);
  final firestore = ref.watch(firestoreServiceProvider);
  return SyncService(localDb, firestore);
});

// Materials Stream Provider (from Firestore)
final materialsStreamProvider = StreamProvider<List<LearningMaterialModel>>((ref) {
  final firestore = ref.watch(firestoreServiceProvider);
  return firestore.getAllMaterialsStream();
});

// Cached Materials Provider (from local DB)
final cachedMaterialsProvider = FutureProvider<List<CachedMaterial>>((ref) {
  final localDb = ref.watch(localDatabaseProvider);
  return localDb.getAllCachedMaterials();
});
```

**Usage in UI:**

```dart
class DashboardScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final materialsAsync = ref.watch(materialsStreamProvider);

    return materialsAsync.when(
      data: (materials) => ListView.builder(
        itemCount: materials.length,
        itemBuilder: (context, index) {
          final material = materials[index];
          return MaterialCard(material: material);
        },
      ),
      loading: () => Center(child: CircularProgressIndicator()),
      error: (error, stack) {
        // Fallback to cached materials
        final cachedAsync = ref.watch(cachedMaterialsProvider);
        return cachedAsync.when(
          data: (cached) => ListView.builder(
            itemCount: cached.length,
            itemBuilder: (context, index) {
              return CachedMaterialCard(material: cached[index]);
            },
          ),
          loading: () => Center(child: CircularProgressIndicator()),
          error: (e, s) => ErrorWidget(error: 'No data available'),
        );
      },
    );
  }
}
```

---

## 🎯 Phase 5: Testing & Migration (1 jam)

### ✅ Checklist

- [ ] 5.1 Seed initial data
- [ ] 5.2 Test all CRUD operations
- [ ] 5.3 Test offline functionality
- [ ] 5.4 Performance testing

---

### 📝 5.1 Seed Initial Data

**File: `lib/src/core/utils/seed_data.dart`**

```dart
import 'package:cloud_firestore/cloud_firestore.dart';

class SeedData {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> seedBadges() async {
    final badges = [
      {
        'badgeId': 'first_quiz',
        'name': 'Quiz Beginner',
        'description': 'Complete your first quiz',
        'imageUrl': 'https://example.com/badge1.png',
        'category': 'quiz',
        'criteria': {'quizzes_completed': 1},
        'points': 10,
        'rarity': 'common',
      },
      {
        'badgeId': 'quiz_master',
        'name': 'Quiz Master',
        'description': 'Complete 50 quizzes',
        'imageUrl': 'https://example.com/badge2.png',
        'category': 'quiz',
        'criteria': {'quizzes_completed': 50},
        'points': 100,
        'rarity': 'epic',
      },
      // Add more badges...
    ];

    WriteBatch batch = _db.batch();

    for (var badge in badges) {
      batch.set(_db.collection('badges').doc(badge['badgeId'] as String), badge);
    }

    await batch.commit();
    print('✅ Badges seeded successfully');
  }

  Future<void> seedAll() async {
    await seedBadges();
    // Add more seed methods...
  }
}
```

**Run seed:**

```dart
// In main.dart or init screen
final seeder = SeedData();
await seeder.seedAll();
```

---

### 📝 5.2 Test All CRUD Operations

**Create comprehensive tests for each collection**

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/firestore_test.dart

# Run with coverage
flutter test --coverage
```

---

## 📊 Progress Tracker

| Phase       | Task                   | Status     | Time  |
| ----------- | ---------------------- | ---------- | ----- |
| **Phase 1** | Firebase Project Setup | ⏳ Pending | 30min |
| **Phase 1** | Enable Firestore       | ⏳ Pending | 10min |
| **Phase 1** | Configure Auth         | ⏳ Pending | 10min |
| **Phase 1** | Security Rules         | ⏳ Pending | 5min  |
| **Phase 1** | FlutterFire Config     | ⏳ Pending | 5min  |
| **Phase 2** | Update Models          | ⏳ Pending | 30min |
| **Phase 2** | CRUD Operations        | ⏳ Pending | 45min |
| **Phase 2** | Batch Operations       | ⏳ Pending | 15min |
| **Phase 2** | Test Firestore         | ⏳ Pending | 15min |
| **Phase 3** | Drift Setup            | ⏳ Pending | 10min |
| **Phase 3** | Create Tables          | ⏳ Pending | 30min |
| **Phase 3** | Generate Code          | ⏳ Pending | 5min  |
| **Phase 3** | Test Local DB          | ⏳ Pending | 15min |
| **Phase 4** | Sync Service           | ⏳ Pending | 60min |
| **Phase 4** | Riverpod Setup         | ⏳ Pending | 30min |
| **Phase 5** | Seed Data              | ⏳ Pending | 20min |
| **Phase 5** | Integration Tests      | ⏳ Pending | 30min |

**Total Estimated Time**: ~6-7 hours

---

## 🎓 Learning Resources

### Firebase

- [Firebase Documentation](https://firebase.google.com/docs)
- [Firestore Security Rules](https://firebase.google.com/docs/firestore/security/get-started)
- [Firestore Best Practices](https://firebase.google.com/docs/firestore/best-practices)

### Drift

- [Drift Documentation](https://drift.simonbinder.eu/)
- [Drift Examples](https://github.com/simolus3/drift/tree/develop/examples)

### Flutter

- [Riverpod Documentation](https://riverpod.dev/)
- [Connectivity Plus](https://pub.dev/packages/connectivity_plus)

---

## ❓ Troubleshooting

### Firebase Connection Issues

```
Error: Failed to connect to Firestore

Solution:
1. Check internet connection
2. Verify firebase_options.dart exists
3. Re-run: flutterfire configure
4. Check Firebase Console → Project Settings
```

### Build Runner Errors

```
Error: Conflicting outputs

Solution:
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```

### Security Rules Blocked

```
Error: PERMISSION_DENIED

Solution:
1. Check Firestore Rules in Firebase Console
2. Verify user is authenticated
3. Check userId matches request.auth.uid
```

---

**Next Step**: Mulai dari Phase 1 → [DATABASE_CONNECTION.md](./DATABASE_CONNECTION.md)

**Status**: ✅ Ready for Implementation  
**Last Updated**: November 4, 2025
