/// Model untuk YouTube Video
class YouTubeVideo {
  final String id;
  final String title;
  final String description;
  final String thumbnailUrl;
  final String channelTitle;
  final String channelId;
  final DateTime publishedAt;
  final String duration;
  final int viewCount;
  final int likeCount;
  final int commentCount;

  YouTubeVideo({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.channelTitle,
    required this.channelId,
    required this.publishedAt,
    this.duration = '',
    this.viewCount = 0,
    this.likeCount = 0,
    this.commentCount = 0,
  });

  factory YouTubeVideo.fromJson(Map<String, dynamic> json) {
    final snippet = json['snippet'] as Map<String, dynamic>;
    final statistics = json['statistics'] as Map<String, dynamic>?;
    final contentDetails = json['contentDetails'] as Map<String, dynamic>?;

    return YouTubeVideo(
      id: json['id'] is String ? json['id'] : json['id']['videoId'],
      title: snippet['title'] ?? '',
      description: snippet['description'] ?? '',
      thumbnailUrl: snippet['thumbnails']?['high']?['url'] ??
                   snippet['thumbnails']?['medium']?['url'] ??
                   snippet['thumbnails']?['default']?['url'] ?? '',
      channelTitle: snippet['channelTitle'] ?? '',
      channelId: snippet['channelId'] ?? '',
      publishedAt: DateTime.parse(snippet['publishedAt']),
      duration: contentDetails?['duration'] ?? '',
      viewCount: int.tryParse(statistics?['viewCount'] ?? '0') ?? 0,
      likeCount: int.tryParse(statistics?['likeCount'] ?? '0') ?? 0,
      commentCount: int.tryParse(statistics?['commentCount'] ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'thumbnailUrl': thumbnailUrl,
      'channelTitle': channelTitle,
      'channelId': channelId,
      'publishedAt': publishedAt.toIso8601String(),
      'duration': duration,
      'viewCount': viewCount,
      'likeCount': likeCount,
      'commentCount': commentCount,
    };
  }

  /// Format duration dari ISO8601 ke format yang dapat dibaca (contoh: PT4M13S -> 4:13)
  String get formattedDuration {
    if (duration.isEmpty) return '';

    final regex = RegExp(r'PT(?:(\d+)H)?(?:(\d+)M)?(?:(\d+)S)?');
    final match = regex.firstMatch(duration);

    if (match == null) return duration;

    final hours = int.tryParse(match.group(1) ?? '0') ?? 0;
    final minutes = int.tryParse(match.group(2) ?? '0') ?? 0;
    final seconds = int.tryParse(match.group(3) ?? '0') ?? 0;

    if (hours > 0) {
      return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '$minutes:${seconds.toString().padLeft(2, '0')}';
    }
  }

  /// Format view count ke format yang dapat dibaca (contoh: 1234567 -> 1.2M views)
  String get formattedViewCount {
    if (viewCount < 1000) return '$viewCount views';
    if (viewCount < 1000000) return '${(viewCount / 1000).toStringAsFixed(1)}K views';
    if (viewCount < 1000000000) return '${(viewCount / 1000000).toStringAsFixed(1)}M views';
    return '${(viewCount / 1000000000).toStringAsFixed(1)}B views';
  }

  /// URL untuk membuka video di YouTube
  String get youtubeUrl => 'https://www.youtube.com/watch?v=$id';
}

/// Model untuk YouTube Channel
class YouTubeChannel {
  final String id;
  final String title;
  final String description;
  final String thumbnailUrl;
  final int subscriberCount;
  final int videoCount;
  final int viewCount;

  YouTubeChannel({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    this.subscriberCount = 0,
    this.videoCount = 0,
    this.viewCount = 0,
  });

  factory YouTubeChannel.fromJson(Map<String, dynamic> json) {
    final snippet = json['snippet'] as Map<String, dynamic>;
    final statistics = json['statistics'] as Map<String, dynamic>?;

    return YouTubeChannel(
      id: json['id'],
      title: snippet['title'] ?? '',
      description: snippet['description'] ?? '',
      thumbnailUrl: snippet['thumbnails']?['high']?['url'] ??
                   snippet['thumbnails']?['medium']?['url'] ??
                   snippet['thumbnails']?['default']?['url'] ?? '',
      subscriberCount: int.tryParse(statistics?['subscriberCount'] ?? '0') ?? 0,
      videoCount: int.tryParse(statistics?['videoCount'] ?? '0') ?? 0,
      viewCount: int.tryParse(statistics?['viewCount'] ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'thumbnailUrl': thumbnailUrl,
      'subscriberCount': subscriberCount,
      'videoCount': videoCount,
      'viewCount': viewCount,
    };
  }

  /// Format subscriber count ke format yang dapat dibaca
  String get formattedSubscriberCount {
    if (subscriberCount < 1000) return '$subscriberCount subscribers';
    if (subscriberCount < 1000000) return '${(subscriberCount / 1000).toStringAsFixed(1)}K subscribers';
    if (subscriberCount < 1000000000) return '${(subscriberCount / 1000000).toStringAsFixed(1)}M subscribers';
    return '${(subscriberCount / 1000000000).toStringAsFixed(1)}B subscribers';
  }

  /// URL untuk membuka channel di YouTube
  String get youtubeUrl => 'https://www.youtube.com/channel/$id';
}
