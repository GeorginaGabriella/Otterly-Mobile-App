import 'package:flutter/material.dart';
import '../core/app_colors.dart';

enum FriendshipStatus {
  none,
  requestedSent,
  requestedReceived,
  friends,
  blocked,
}

class CoverPresetTheme {
  final String id;
  final String label;
  final List<Color> gradientColors;

  const CoverPresetTheme({
    required this.id,
    required this.label,
    required this.gradientColors,
  });

  static const List<CoverPresetTheme> presets = [
    CoverPresetTheme(
      id: 'sunset',
      label: 'Otter Sunset',
      gradientColors: [AppColors.burgundy, AppColors.pink, AppColors.coral],
    ),
    CoverPresetTheme(
      id: 'peach',
      label: 'Warm Peach',
      gradientColors: [AppColors.pink, AppColors.coral, AppColors.yellow],
    ),
    CoverPresetTheme(
      id: 'golden',
      label: 'Golden Cream',
      gradientColors: [Color(0xFFF09819), AppColors.yellow, AppColors.cream],
    ),
    CoverPresetTheme(
      id: 'berry',
      label: 'Campus Berry',
      gradientColors: [Color(0xFF6B1028), AppColors.burgundy, AppColors.pink],
    ),
  ];

  static CoverPresetTheme resolve(String id) {
    return presets.firstWhere(
      (preset) => preset.id == id,
      orElse: () => presets.first,
    );
  }
}

class StudentProfileModel {
  final String id;
  final String fullName;
  final String username;
  final String nim;
  final String faculty;
  final String studyProgram;
  final String entryYear;
  final String avatar;
  final String bio;
  final String coverPreset;
  final bool isVerified;
  final bool isPrivate;
  final int friendsCount;
  final int followersCount;
  final int followingCount;
  final List<String> mutualFriendIds;
  final FriendshipStatus friendshipStatus;
  final bool isFollowing;
  final bool isFollower;
  final String? requestTimestamp;

  const StudentProfileModel({
    required this.id,
    required this.fullName,
    required this.username,
    required this.nim,
    required this.faculty,
    required this.studyProgram,
    required this.entryYear,
    required this.avatar,
    required this.bio,
    this.coverPreset = 'sunset',
    this.isVerified = true,
    this.isPrivate = false,
    this.friendsCount = 0,
    this.followersCount = 0,
    this.followingCount = 0,
    this.mutualFriendIds = const [],
    this.friendshipStatus = FriendshipStatus.none,
    this.isFollowing = false,
    this.isFollower = false,
    this.requestTimestamp,
  });

  StudentProfileModel copyWith({
    String? id,
    String? fullName,
    String? username,
    String? nim,
    String? faculty,
    String? studyProgram,
    String? entryYear,
    String? avatar,
    String? bio,
    String? coverPreset,
    bool? isVerified,
    bool? isPrivate,
    int? friendsCount,
    int? followersCount,
    int? followingCount,
    List<String>? mutualFriendIds,
    FriendshipStatus? friendshipStatus,
    bool? isFollowing,
    bool? isFollower,
    String? requestTimestamp,
    bool clearRequestTimestamp = false,
  }) {
    return StudentProfileModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      username: username ?? this.username,
      nim: nim ?? this.nim,
      faculty: faculty ?? this.faculty,
      studyProgram: studyProgram ?? this.studyProgram,
      entryYear: entryYear ?? this.entryYear,
      avatar: avatar ?? this.avatar,
      bio: bio ?? this.bio,
      coverPreset: coverPreset ?? this.coverPreset,
      isVerified: isVerified ?? this.isVerified,
      isPrivate: isPrivate ?? this.isPrivate,
      friendsCount: friendsCount ?? this.friendsCount,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
      mutualFriendIds: mutualFriendIds ?? this.mutualFriendIds,
      friendshipStatus: friendshipStatus ?? this.friendshipStatus,
      isFollowing: isFollowing ?? this.isFollowing,
      isFollower: isFollower ?? this.isFollower,
      requestTimestamp: clearRequestTimestamp
          ? null
          : (requestTimestamp ?? this.requestTimestamp),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'username': username,
      'nim': nim,
      'faculty': faculty,
      'studyProgram': studyProgram,
      'entryYear': entryYear,
      'avatar': avatar,
      'bio': bio,
      'coverPreset': coverPreset,
      'isVerified': isVerified,
      'isPrivate': isPrivate,
      'friendsCount': friendsCount,
      'followersCount': followersCount,
      'followingCount': followingCount,
      'mutualFriendIds': mutualFriendIds,
      'friendshipStatus': friendshipStatus.name,
      'isFollowing': isFollowing,
      'isFollower': isFollower,
      'requestTimestamp': requestTimestamp,
    };
  }

  factory StudentProfileModel.fromJson(Map<String, dynamic> json) {
    final statusName = json['friendshipStatus'] as String? ?? 'none';
    final status = FriendshipStatus.values.firstWhere(
      (value) => value.name == statusName,
      orElse: () => FriendshipStatus.none,
    );

    return StudentProfileModel(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      username: json['username'] as String,
      nim: json['nim'] as String,
      faculty: json['faculty'] as String,
      studyProgram: json['studyProgram'] as String,
      entryYear: json['entryYear'] as String,
      avatar: json['avatar'] as String,
      bio: json['bio'] as String,
      coverPreset: json['coverPreset'] as String? ?? 'sunset',
      isVerified: json['isVerified'] as bool? ?? true,
      isPrivate: json['isPrivate'] as bool? ?? false,
      friendsCount: json['friendsCount'] as int? ?? 0,
      followersCount: json['followersCount'] as int? ?? 0,
      followingCount: json['followingCount'] as int? ?? 0,
      mutualFriendIds: List<String>.from(
        json['mutualFriendIds'] as List<dynamic>? ?? const [],
      ),
      friendshipStatus: status,
      isFollowing: json['isFollowing'] as bool? ?? false,
      isFollower: json['isFollower'] as bool? ?? false,
      requestTimestamp: json['requestTimestamp'] as String?,
    );
  }
}

class ProfilePostItem {
  final String id;
  final String authorId;
  final String authorName;
  final String authorAvatar;
  final String faculty;
  final String category;
  final String content;
  final String timeAgo;
  final int likesCount;
  final int commentsCount;
  final bool isLiked;
  final bool isSaved;
  final bool isOwnPost;
  final List<String> imagePaths;
  final String? videoPath;
  final String? location;
  final String audience;

  const ProfilePostItem({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.authorAvatar,
    required this.faculty,
    required this.category,
    required this.content,
    required this.timeAgo,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.isLiked = false,
    this.isSaved = false,
    this.isOwnPost = false,
    this.imagePaths = const [],
    this.videoPath,
    this.location,
    this.audience = 'Public',
  });

  ProfilePostItem copyWith({
    String? id,
    String? authorId,
    String? authorName,
    String? authorAvatar,
    String? faculty,
    String? category,
    String? content,
    String? timeAgo,
    int? likesCount,
    int? commentsCount,
    bool? isLiked,
    bool? isSaved,
    bool? isOwnPost,
    List<String>? imagePaths,
    String? videoPath,
    bool clearVideoPath = false,
    String? location,
    bool clearLocation = false,
    String? audience,
  }) {
    return ProfilePostItem(
      id: id ?? this.id,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      authorAvatar: authorAvatar ?? this.authorAvatar,
      faculty: faculty ?? this.faculty,
      category: category ?? this.category,
      content: content ?? this.content,
      timeAgo: timeAgo ?? this.timeAgo,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      isLiked: isLiked ?? this.isLiked,
      isSaved: isSaved ?? this.isSaved,
      isOwnPost: isOwnPost ?? this.isOwnPost,
      imagePaths: imagePaths ?? this.imagePaths,
      videoPath: clearVideoPath ? null : (videoPath ?? this.videoPath),
      location: clearLocation ? null : (location ?? this.location),
      audience: audience ?? this.audience,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'authorId': authorId,
      'authorName': authorName,
      'authorAvatar': authorAvatar,
      'faculty': faculty,
      'category': category,
      'content': content,
      'timeAgo': timeAgo,
      'likesCount': likesCount,
      'commentsCount': commentsCount,
      'isLiked': isLiked,
      'isSaved': isSaved,
      'isOwnPost': isOwnPost,
      'imagePaths': imagePaths,
      'videoPath': videoPath,
      'location': location,
      'audience': audience,
    };
  }

  factory ProfilePostItem.fromJson(Map<String, dynamic> json) {
    return ProfilePostItem(
      id: json['id'] as String,
      authorId: json['authorId'] as String,
      authorName: json['authorName'] as String,
      authorAvatar: json['authorAvatar'] as String,
      faculty: json['faculty'] as String,
      category: json['category'] as String,
      content: json['content'] as String,
      timeAgo: json['timeAgo'] as String,
      likesCount: json['likesCount'] as int? ?? 0,
      commentsCount: json['commentsCount'] as int? ?? 0,
      isLiked: json['isLiked'] as bool? ?? false,
      isSaved: json['isSaved'] as bool? ?? false,
      isOwnPost: json['isOwnPost'] as bool? ?? false,
      imagePaths: List<String>.from(
        json['imagePaths'] as List<dynamic>? ?? const [],
      ),
      videoPath: json['videoPath'] as String?,
      location: json['location'] as String?,
      audience: json['audience'] as String? ?? 'Public',
    );
  }
}
