class UserModel {
  final String id;
  final String fullName;
  final String nim;
  final String email;
  final String faculty;
  final String studyProgram;
  final String entryYear;
  final String avatar;
  final bool isVerified;
  final String username;
  final String bio;
  final String coverPreset;
  final String? coverImagePath;
  final String? customProfileImagePath;
  final bool isPrivate;
  final String friendRequestPrivacy;

  const UserModel({
    required this.id,
    required this.fullName,
    required this.nim,
    required this.email,
    required this.faculty,
    required this.studyProgram,
    required this.entryYear,
    required this.avatar,
    this.isVerified = false,
    this.username = '',
    this.bio = 'UNTAR Student • Exploring campus life on Otter.ly 🦦',
    this.coverPreset = 'sunset',
    this.coverImagePath,
    this.customProfileImagePath,
    this.isPrivate = false,
    this.friendRequestPrivacy = 'everyone',
  });

  String get effectiveUsername {
    final trimmed = username.trim();
    if (trimmed.isNotEmpty) {
      return trimmed.startsWith('@') ? trimmed.substring(1) : trimmed;
    }
    final sanitized = fullName
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9\s]'), '')
        .trim()
        .replaceAll(RegExp(r'\s+'), '.');
    return sanitized.isEmpty ? 'otter.student' : sanitized;
  }

  UserModel copyWith({
    String? id,
    String? fullName,
    String? nim,
    String? email,
    String? faculty,
    String? studyProgram,
    String? entryYear,
    String? avatar,
    bool? isVerified,
    String? username,
    String? bio,
    String? coverPreset,
    String? coverImagePath,
    bool clearCoverImagePath = false,
    String? customProfileImagePath,
    bool clearCustomProfileImagePath = false,
    bool? isPrivate,
    String? friendRequestPrivacy,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      nim: nim ?? this.nim,
      email: email ?? this.email,
      faculty: faculty ?? this.faculty,
      studyProgram: studyProgram ?? this.studyProgram,
      entryYear: entryYear ?? this.entryYear,
      avatar: avatar ?? this.avatar,
      isVerified: isVerified ?? this.isVerified,
      username: username ?? this.username,
      bio: bio ?? this.bio,
      coverPreset: coverPreset ?? this.coverPreset,
      coverImagePath:
          clearCoverImagePath ? null : (coverImagePath ?? this.coverImagePath),
      customProfileImagePath: clearCustomProfileImagePath
          ? null
          : (customProfileImagePath ?? this.customProfileImagePath),
      isPrivate: isPrivate ?? this.isPrivate,
      friendRequestPrivacy: friendRequestPrivacy ?? this.friendRequestPrivacy,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'nim': nim,
      'email': email,
      'faculty': faculty,
      'studyProgram': studyProgram,
      'entryYear': entryYear,
      'avatar': avatar,
      'isVerified': isVerified,
      'username': username,
      'bio': bio,
      'coverPreset': coverPreset,
      'coverImagePath': coverImagePath,
      'customProfileImagePath': customProfileImagePath,
      'isPrivate': isPrivate,
      'friendRequestPrivacy': friendRequestPrivacy,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      nim: json['nim'] as String,
      email: json['email'] as String,
      faculty: json['faculty'] as String,
      studyProgram: json['studyProgram'] as String,
      entryYear: json['entryYear'] as String,
      avatar: json['avatar'] as String,
      isVerified: json['isVerified'] as bool? ?? false,
      username: json['username'] as String? ?? '',
      bio: json['bio'] as String? ??
          'UNTAR Student • Exploring campus life on Otter.ly 🦦',
      coverPreset: json['coverPreset'] as String? ?? 'sunset',
      coverImagePath: json['coverImagePath'] as String?,
      customProfileImagePath: json['customProfileImagePath'] as String?,
      isPrivate: json['isPrivate'] as bool? ?? false,
      friendRequestPrivacy:
          json['friendRequestPrivacy'] as String? ?? 'everyone',
    );
  }
}
