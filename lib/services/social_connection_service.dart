import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/app_constants.dart';
import '../models/friend_profile_model.dart';
import '../models/user_model.dart';

class SocialPrivacySettings {
  final bool isPrivateAccount;
  final bool allowRequestsFromMutualsOnly;
  final bool showActivityStatus;

  const SocialPrivacySettings({
    this.isPrivateAccount = false,
    this.allowRequestsFromMutualsOnly = false,
    this.showActivityStatus = true,
  });

  SocialPrivacySettings copyWith({
    bool? isPrivateAccount,
    bool? allowRequestsFromMutualsOnly,
    bool? showActivityStatus,
  }) {
    return SocialPrivacySettings(
      isPrivateAccount: isPrivateAccount ?? this.isPrivateAccount,
      allowRequestsFromMutualsOnly:
          allowRequestsFromMutualsOnly ?? this.allowRequestsFromMutualsOnly,
      showActivityStatus: showActivityStatus ?? this.showActivityStatus,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isPrivateAccount': isPrivateAccount,
      'allowRequestsFromMutualsOnly': allowRequestsFromMutualsOnly,
      'showActivityStatus': showActivityStatus,
    };
  }

  factory SocialPrivacySettings.fromJson(Map<String, dynamic> json) {
    return SocialPrivacySettings(
      isPrivateAccount: json['isPrivateAccount'] as bool? ?? false,
      allowRequestsFromMutualsOnly:
          json['allowRequestsFromMutualsOnly'] as bool? ?? false,
      showActivityStatus: json['showActivityStatus'] as bool? ?? true,
    );
  }
}

class SocialConnectionService {
  static const String _studentsKeyPrefix = 'otterly_social_students_';
  static const String _postsKeyPrefix = 'otterly_social_posts_';
  static const String _privacyKeyPrefix = 'otterly_social_privacy_';

  Future<List<StudentProfileModel>> loadStudents(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('$_studentsKeyPrefix$userId');
    if (raw == null || raw.isEmpty) {
      final seeded = seedStudents();
      await saveStudents(userId, seeded);
      return seeded;
    }

    final List<dynamic> decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map(
          (item) => StudentProfileModel.fromJson(
            Map<String, dynamic>.from(item as Map),
          ),
        )
        .toList();
  }

  Future<void> saveStudents(
    String userId,
    List<StudentProfileModel> students,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(students.map((s) => s.toJson()).toList());
    await prefs.setString('$_studentsKeyPrefix$userId', encoded);
  }

  Future<List<ProfilePostItem>> loadPosts(
    String userId, {
    required UserModel currentUser,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('$_postsKeyPrefix$userId');
    if (raw == null || raw.isEmpty) {
      final seeded = seedPosts(currentUser);
      await savePosts(userId, seeded);
      return seeded;
    }

    final List<dynamic> decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map(
          (item) => ProfilePostItem.fromJson(
            Map<String, dynamic>.from(item as Map),
          ),
        )
        .toList();
  }

  Future<void> savePosts(String userId, List<ProfilePostItem> posts) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(posts.map((p) => p.toJson()).toList());
    await prefs.setString('$_postsKeyPrefix$userId', encoded);
  }

  Future<SocialPrivacySettings> loadPrivacySettings(
    String userId, {
    bool fallbackPrivate = false,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('$_privacyKeyPrefix$userId');
    if (raw == null || raw.isEmpty) {
      return SocialPrivacySettings(isPrivateAccount: fallbackPrivate);
    }

    final Map<String, dynamic> decoded =
        Map<String, dynamic>.from(jsonDecode(raw) as Map);
    return SocialPrivacySettings.fromJson(decoded);
  }

  Future<void> savePrivacySettings(
    String userId,
    SocialPrivacySettings settings,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      '$_privacyKeyPrefix$userId',
      jsonEncode(settings.toJson()),
    );
  }

  static List<StudentProfileModel> seedStudents() {
    return const [
      StudentProfileModel(
        id: 'stu_georgina',
        fullName: 'Georgina Gabriella',
        username: 'georgina.g',
        nim: '535250014',
        faculty: 'Faculty of Information Technology',
        studyProgram: 'Informatics',
        entryYear: '2025',
        avatar: AppConstants.pinkAvatarPath,
        bio: 'Mobile dev & UI enthusiast at FTI UNTAR. Coffee + Flutter = ❤️',
        coverPreset: 'sunset',
        isVerified: true,
        friendsCount: 42,
        followersCount: 118,
        followingCount: 74,
        mutualFriendIds: ['stu_garini', 'stu_celine', 'stu_fransiska'],
        friendshipStatus: FriendshipStatus.friends,
        isFollowing: true,
        isFollower: true,
      ),
      StudentProfileModel(
        id: 'stu_garini',
        fullName: 'Garini Cinkalisty',
        username: 'garinicinka',
        nim: '535250017',
        faculty: 'Faculty of Information Technology',
        studyProgram: 'Informatics',
        entryYear: '2025',
        avatar: AppConstants.blueAvatarPath,
        bio: 'Building Otter.ly campus feed 🦦 | Loves design systems & matcha',
        coverPreset: 'peach',
        isVerified: true,
        friendsCount: 38,
        followersCount: 95,
        followingCount: 68,
        mutualFriendIds: ['stu_georgina', 'stu_celine'],
        friendshipStatus: FriendshipStatus.friends,
        isFollowing: true,
        isFollower: true,
      ),
      StudentProfileModel(
        id: 'stu_celine',
        fullName: 'Celine Aurora Anastasia',
        username: 'celine.aurora',
        nim: '535250018',
        faculty: 'Faculty of Information Technology',
        studyProgram: 'Informatics',
        entryYear: '2025',
        avatar: AppConstants.pinkAvatarPath,
        bio: 'Exploring campus organizations & software engineering projects ✨',
        coverPreset: 'berry',
        isVerified: true,
        friendsCount: 51,
        followersCount: 132,
        followingCount: 89,
        mutualFriendIds: ['stu_georgina', 'stu_garini', 'stu_fransiska'],
        friendshipStatus: FriendshipStatus.friends,
        isFollowing: true,
        isFollower: true,
      ),
      StudentProfileModel(
        id: 'stu_fransiska',
        fullName: 'Fransiska',
        username: 'fransiska.untar',
        nim: '535250037',
        faculty: 'Faculty of Information Technology',
        studyProgram: 'Informatics',
        entryYear: '2025',
        avatar: AppConstants.blueAvatarPath,
        bio: 'Campus events explorer & informatics student at UNTAR.',
        coverPreset: 'golden',
        isVerified: true,
        friendsCount: 29,
        followersCount: 64,
        followingCount: 52,
        mutualFriendIds: ['stu_georgina', 'stu_celine'],
        friendshipStatus: FriendshipStatus.requestedReceived,
        isFollowing: false,
        isFollower: true,
        requestTimestamp: '2h ago',
      ),
      StudentProfileModel(
        id: 'stu_kevin',
        fullName: 'Kevin Wijaya',
        username: 'kevinwijaya.ti',
        nim: '535240081',
        faculty: 'Faculty of Information Technology',
        studyProgram: 'Information Systems',
        entryYear: '2024',
        avatar: AppConstants.blueAvatarPath,
        bio: 'BEM FTI Coordinator • Happy to help freshmen navigate campus!',
        coverPreset: 'peach',
        isVerified: true,
        friendsCount: 67,
        followersCount: 184,
        followingCount: 102,
        mutualFriendIds: ['stu_georgina', 'stu_garini', 'stu_celine'],
        friendshipStatus: FriendshipStatus.requestedReceived,
        isFollowing: false,
        isFollower: true,
        requestTimestamp: '5h ago',
      ),
      StudentProfileModel(
        id: 'stu_nadia',
        fullName: 'Nadia Santoso',
        username: 'nadiasantoso',
        nim: '115240112',
        faculty: 'Faculty of Economics and Business',
        studyProgram: 'Management',
        entryYear: '2024',
        avatar: AppConstants.pinkAvatarPath,
        bio: 'Danus & entrepreneurship club @FEB UNTAR. Open for collabs!',
        coverPreset: 'golden',
        isVerified: true,
        friendsCount: 54,
        followersCount: 210,
        followingCount: 95,
        mutualFriendIds: ['stu_georgina', 'stu_celine'],
        friendshipStatus: FriendshipStatus.none,
        isFollowing: false,
        isFollower: false,
      ),
      StudentProfileModel(
        id: 'stu_bryan',
        fullName: 'Bryan Tanoto',
        username: 'bryantanoto',
        nim: '315230045',
        faculty: 'Faculty of Engineering',
        studyProgram: 'Civil Engineering',
        entryYear: '2023',
        avatar: AppConstants.blueAvatarPath,
        bio: 'Campus photography UKM & civil engineering student 📸',
        coverPreset: 'sunset',
        isVerified: true,
        friendsCount: 45,
        followersCount: 120,
        followingCount: 61,
        mutualFriendIds: ['stu_garini'],
        friendshipStatus: FriendshipStatus.none,
        isFollowing: true,
        isFollower: false,
      ),
      StudentProfileModel(
        id: 'stu_clarissa',
        fullName: 'Clarissa Hartono',
        username: 'clarissah',
        nim: '705250019',
        faculty: 'Faculty of Psychology',
        studyProgram: 'Psychology',
        entryYear: '2025',
        avatar: AppConstants.pinkAvatarPath,
        bio: 'Peer counselor & mental health advocate at UNTAR 💛',
        coverPreset: 'berry',
        isVerified: true,
        isPrivate: true,
        friendsCount: 31,
        followersCount: 88,
        followingCount: 44,
        mutualFriendIds: ['stu_georgina', 'stu_garini', 'stu_celine'],
        friendshipStatus: FriendshipStatus.requestedSent,
        isFollowing: false,
        isFollower: false,
        requestTimestamp: '1d ago',
      ),
      StudentProfileModel(
        id: 'stu_darren',
        fullName: 'Darren Kusuma',
        username: 'darrenk.dkv',
        nim: '625240033',
        faculty: 'Faculty of Art and Design',
        studyProgram: 'Visual Communication Design',
        entryYear: '2024',
        avatar: AppConstants.blueAvatarPath,
        bio: 'Illustrator behind campus posters & Otter mascot sketches 🎨',
        coverPreset: 'peach',
        isVerified: true,
        friendsCount: 73,
        followersCount: 245,
        followingCount: 112,
        mutualFriendIds: ['stu_celine', 'stu_garini'],
        friendshipStatus: FriendshipStatus.none,
        isFollowing: false,
        isFollower: true,
      ),
      StudentProfileModel(
        id: 'stu_jessica',
        fullName: 'Jessica Halim',
        username: 'jessicahalim.law',
        nim: '205230090',
        faculty: 'Faculty of Law',
        studyProgram: 'Law',
        entryYear: '2023',
        avatar: AppConstants.pinkAvatarPath,
        bio: 'Moot court team & student senate member ⚖️',
        coverPreset: 'sunset',
        isVerified: true,
        isPrivate: true,
        friendsCount: 28,
        followersCount: 79,
        followingCount: 53,
        mutualFriendIds: ['stu_georgina'],
        friendshipStatus: FriendshipStatus.none,
        isFollowing: false,
        isFollower: false,
      ),
      StudentProfileModel(
        id: 'stu_rafael',
        fullName: 'Rafael Lim',
        username: 'rafael.fikom',
        nim: '915240058',
        faculty: 'Faculty of Communication Sciences',
        studyProgram: 'Communication Science',
        entryYear: '2024',
        avatar: AppConstants.blueAvatarPath,
        bio: 'UNTAR Radio host & campus MC 🎙️ DM for event partnerships!',
        coverPreset: 'golden',
        isVerified: false,
        friendsCount: 84,
        followersCount: 310,
        followingCount: 140,
        mutualFriendIds: ['stu_georgina', 'stu_celine'],
        friendshipStatus: FriendshipStatus.none,
        isFollowing: false,
        isFollower: false,
      ),
    ];
  }

  static List<ProfilePostItem> seedPosts(UserModel currentUser) {
    return [
      ProfilePostItem(
        id: 'post_own_1',
        authorId: currentUser.id,
        authorName: currentUser.fullName,
        authorAvatar: currentUser.avatar,
        faculty: currentUser.faculty,
        category: 'Events',
        content:
            'Jangan lupa cek informasi event kampus terbaru minggu ini! Banyak seminar dan booth UKM seru di Gedung Utama UNTAR 🦦✨',
        timeAgo: '2 hours ago',
        likesCount: 19,
        commentsCount: 4,
        isLiked: false,
        isSaved: false,
        isOwnPost: true,
      ),
      ProfilePostItem(
        id: 'post_own_2',
        authorId: currentUser.id,
        authorName: currentUser.fullName,
        authorAvatar: currentUser.avatar,
        faculty: currentUser.faculty,
        category: 'Campus Life',
        content:
            'Selesai kelas Mobile Programming langsung nugas bareng tim Otter.ly di perpustakaan lantai 4. Semangat semuanya! 💻💗',
        timeAgo: '1 day ago',
        likesCount: 31,
        commentsCount: 7,
        isLiked: true,
        isSaved: false,
        isOwnPost: true,
      ),
      const ProfilePostItem(
        id: 'post_stu_georgina_1',
        authorId: 'stu_georgina',
        authorName: 'Georgina Gabriella',
        authorAvatar: AppConstants.pinkAvatarPath,
        faculty: 'Faculty of Information Technology',
        category: 'Academic',
        content:
            'Semangat untuk semua mahasiswa yang sedang mengerjakan tugas Mobile Programming! Jangan lupa istirahat juga. 💗',
        timeAgo: '30 min ago',
        likesCount: 18,
        commentsCount: 5,
        isLiked: true,
        isSaved: true,
        isOwnPost: false,
      ),
      const ProfilePostItem(
        id: 'post_stu_garini_1',
        authorId: 'stu_garini',
        authorName: 'Garini Cinkalisty',
        authorAvatar: AppConstants.blueAvatarPath,
        faculty: 'Faculty of Information Technology',
        category: 'Campus Life',
        content:
            'Hello Otter friends! Ada yang tahu kegiatan menarik di kampus minggu ini? Yuk sharing di sini! 🦦',
        timeAgo: '10 min ago',
        likesCount: 24,
        commentsCount: 8,
        isLiked: false,
        isSaved: true,
        isOwnPost: false,
      ),
      const ProfilePostItem(
        id: 'post_stu_celine_1',
        authorId: 'stu_celine',
        authorName: 'Celine Aurora Anastasia',
        authorAvatar: AppConstants.pinkAvatarPath,
        faculty: 'Faculty of Information Technology',
        category: 'Organization',
        content:
            'Yuk ikut kegiatan organisasi kampus dan tambah pengalaman serta teman baru!',
        timeAgo: '1 hour ago',
        likesCount: 32,
        commentsCount: 12,
        isLiked: false,
        isSaved: false,
        isOwnPost: false,
      ),
      const ProfilePostItem(
        id: 'post_stu_nadia_1',
        authorId: 'stu_nadia',
        authorName: 'Nadia Santoso',
        authorAvatar: AppConstants.pinkAvatarPath,
        faculty: 'Faculty of Economics and Business',
        category: 'Promotion',
        content:
            'Danus BEM FEB hari ini ada risol mayo & es kopi susu di selasar Gedung A! Yuk mampir sebelum kehabisan 🧋✨',
        timeAgo: '4 hours ago',
        likesCount: 41,
        commentsCount: 9,
        isLiked: false,
        isSaved: false,
        isOwnPost: false,
      ),
    ];
  }
}
