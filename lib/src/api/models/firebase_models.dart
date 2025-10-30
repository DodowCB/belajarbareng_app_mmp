import 'package:cloud_firestore/cloud_firestore.dart';

/// Model untuk User data
class UserModel {
  final String id;
  final String email;
  final String displayName;
  final String? photoUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> joinedGroups;
  final Map<String, dynamic> preferences;

  UserModel({
    required this.id,
    required this.email,
    required this.displayName,
    this.photoUrl,
    required this.createdAt,
    required this.updatedAt,
    this.joinedGroups = const [],
    this.preferences = const {},
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return UserModel(
      id: doc.id,
      email: data['email'] ?? '',
      displayName: data['displayName'] ?? '',
      photoUrl: data['photoUrl'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      joinedGroups: List<String>.from(data['joinedGroups'] ?? []),
      preferences: Map<String, dynamic>.from(data['preferences'] ?? {}),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'joinedGroups': joinedGroups,
      'preferences': preferences,
    };
  }

  UserModel copyWith({
    String? email,
    String? displayName,
    String? photoUrl,
    DateTime? updatedAt,
    List<String>? joinedGroups,
    Map<String, dynamic>? preferences,
  }) {
    return UserModel(
      id: id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      joinedGroups: joinedGroups ?? this.joinedGroups,
      preferences: preferences ?? this.preferences,
    );
  }
}

/// Model untuk Study Group
class StudyGroupModel {
  final String id;
  final String name;
  final String description;
  final String category;
  final String creatorId;
  final List<String> members;
  final int maxMembers;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isPublic;
  final String? imageUrl;
  final Map<String, dynamic> settings;

  StudyGroupModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.creatorId,
    this.members = const [],
    this.maxMembers = 50,
    required this.createdAt,
    required this.updatedAt,
    this.isPublic = true,
    this.imageUrl,
    this.settings = const {},
  });

  factory StudyGroupModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return StudyGroupModel(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      creatorId: data['creatorId'] ?? '',
      members: List<String>.from(data['members'] ?? []),
      maxMembers: data['maxMembers'] ?? 50,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isPublic: data['isPublic'] ?? true,
      imageUrl: data['imageUrl'],
      settings: Map<String, dynamic>.from(data['settings'] ?? {}),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'category': category,
      'creatorId': creatorId,
      'members': members,
      'maxMembers': maxMembers,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'isPublic': isPublic,
      'imageUrl': imageUrl,
      'settings': settings,
    };
  }

  /// Apakah group sudah penuh
  bool get isFull => members.length >= maxMembers;

  /// Jumlah member saat ini
  int get memberCount => members.length;

  /// Apakah user adalah member dari group ini
  bool isMember(String userId) => members.contains(userId);

  /// Apakah user adalah creator dari group ini
  bool isCreator(String userId) => creatorId == userId;
}

/// Model untuk Learning Material
class LearningMaterialModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final String type; // video, document, quiz, etc.
  final String url;
  final String? thumbnailUrl;
  final String creatorId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> tags;
  final int difficulty; // 1-5 scale
  final int estimatedDuration; // in minutes
  final Map<String, dynamic> metadata;

  LearningMaterialModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.type,
    required this.url,
    this.thumbnailUrl,
    required this.creatorId,
    required this.createdAt,
    required this.updatedAt,
    this.tags = const [],
    this.difficulty = 1,
    this.estimatedDuration = 0,
    this.metadata = const {},
  });

  factory LearningMaterialModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return LearningMaterialModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      type: data['type'] ?? '',
      url: data['url'] ?? '',
      thumbnailUrl: data['thumbnailUrl'],
      creatorId: data['creatorId'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      tags: List<String>.from(data['tags'] ?? []),
      difficulty: data['difficulty'] ?? 1,
      estimatedDuration: data['estimatedDuration'] ?? 0,
      metadata: Map<String, dynamic>.from(data['metadata'] ?? {}),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'type': type,
      'url': url,
      'thumbnailUrl': thumbnailUrl,
      'creatorId': creatorId,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'tags': tags,
      'difficulty': difficulty,
      'estimatedDuration': estimatedDuration,
      'metadata': metadata,
    };
  }

  /// Format duration ke format yang dapat dibaca
  String get formattedDuration {
    if (estimatedDuration < 60) {
      return '${estimatedDuration}m';
    } else {
      final hours = estimatedDuration ~/ 60;
      final minutes = estimatedDuration % 60;
      return '${hours}h ${minutes}m';
    }
  }

  /// String difficulty level
  String get difficultyText {
    switch (difficulty) {
      case 1:
        return 'Beginner';
      case 2:
        return 'Easy';
      case 3:
        return 'Intermediate';
      case 4:
        return 'Advanced';
      case 5:
        return 'Expert';
      default:
        return 'Unknown';
    }
  }
}

/// Model untuk User Progress
class UserProgressModel {
  final String id;
  final String userId;
  final String materialId;
  final double progress; // 0.0 - 1.0
  final DateTime lastUpdated;
  final DateTime? completedAt;
  final Map<String, dynamic> additionalData;

  UserProgressModel({
    required this.id,
    required this.userId,
    required this.materialId,
    required this.progress,
    required this.lastUpdated,
    this.completedAt,
    this.additionalData = const {},
  });

  factory UserProgressModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return UserProgressModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      materialId: data['materialId'] ?? '',
      progress: (data['progress'] ?? 0.0).toDouble(),
      lastUpdated: (data['lastUpdated'] as Timestamp?)?.toDate() ?? DateTime.now(),
      completedAt: (data['completedAt'] as Timestamp?)?.toDate(),
      additionalData: Map<String, dynamic>.from(data['additionalData'] ?? {}),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'materialId': materialId,
      'progress': progress,
      'lastUpdated': Timestamp.fromDate(lastUpdated),
      'completedAt': completedAt != null ? Timestamp.fromDate(completedAt!) : null,
      'additionalData': additionalData,
    };
  }

  /// Apakah material sudah selesai
  bool get isCompleted => progress >= 1.0;

  /// Progress dalam persentase
  int get progressPercentage => (progress * 100).round();
}
