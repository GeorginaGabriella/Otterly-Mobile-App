import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/app_constants.dart';
import '../models/friend_profile_model.dart';
import '../models/user_model.dart';
import '../services/social_connection_service.dart';
import 'auth_provider.dart';

class SocialProfileState {
  final String activeUserId;
  final List<StudentProfileModel> students;
  final List<ProfilePostItem> posts;
  final SocialPrivacySettings privacy;
  final String searchQuery;
  final String selectedFacultyFilter;
  final bool isLoading;

  const SocialProfileState({
    this.activeUserId = 'demo_felicia',
    this.students = const [],
    this.posts = const [],
    this.privacy = const SocialPrivacySettings(),
    this.searchQuery = '',
    this.selectedFacultyFilter = 'All',
    this.isLoading = true,
  });

  List<StudentProfileModel> get friends => students
      .where((s) => s.friendshipStatus == FriendshipStatus.friends)
      .toList();

  List<StudentProfileModel> get incomingRequests => students
      .where((s) => s.friendshipStatus == FriendshipStatus.requestedReceived)
      .toList();

  List<StudentProfileModel> get sentRequests => students
      .where((s) => s.friendshipStatus == FriendshipStatus.requestedSent)
      .toList();

  List<StudentProfileModel> get suggestions {
    final list = students
        .where((s) => s.friendshipStatus == FriendshipStatus.none)
        .toList();
    list.sort(
      (a, b) => b.mutualFriendIds.length.compareTo(a.mutualFriendIds.length),
    );
    return list;
  }

  List<StudentProfileModel> get blockedUsers => students
      .where((s) => s.friendshipStatus == FriendshipStatus.blocked)
      .toList();

  List<StudentProfileModel> get followers => students
      .where(
        (s) => s.friendshipStatus != FriendshipStatus.blocked && s.isFollower,
      )
      .toList();

  List<StudentProfileModel> get following => students
      .where(
        (s) => s.friendshipStatus != FriendshipStatus.blocked && s.isFollowing,
      )
      .toList();

  List<StudentProfileModel> get filteredDirectory {
    final query = searchQuery.trim().toLowerCase();
    return students.where((student) {
      if (student.friendshipStatus == FriendshipStatus.blocked) return false;
      final matchesFaculty = selectedFacultyFilter == 'All' ||
          student.faculty == selectedFacultyFilter;
      if (!matchesFaculty) return false;
      if (query.isEmpty) return true;
      return student.fullName.toLowerCase().contains(query) ||
          student.username.toLowerCase().contains(query) ||
          student.nim.toLowerCase().contains(query) ||
          student.faculty.toLowerCase().contains(query) ||
          student.studyProgram.toLowerCase().contains(query);
    }).toList();
  }

  List<ProfilePostItem> get myPosts =>
      posts.where((post) => post.isOwnPost).toList();

  List<ProfilePostItem> get savedPosts =>
      posts.where((post) => post.isSaved).toList();

  List<ProfilePostItem> postsForStudent(String studentId) =>
      posts.where((post) => post.authorId == studentId).toList();

  List<StudentProfileModel> mutualFriendsFor(StudentProfileModel target) {
    final connectedIds = friends.map((f) => f.id).toSet();
    final targetMutuals = target.mutualFriendIds.toSet();
    return students
        .where(
          (student) =>
              student.id != target.id &&
              student.friendshipStatus != FriendshipStatus.blocked &&
              (targetMutuals.contains(student.id) ||
                  (connectedIds.contains(student.id) &&
                      target.mutualFriendIds.contains(student.id))),
        )
        .toList();
  }

  StudentProfileModel? findStudentById(String id) {
    for (final student in students) {
      if (student.id == id) return student;
    }
    return null;
  }

  SocialProfileState copyWith({
    String? activeUserId,
    List<StudentProfileModel>? students,
    List<ProfilePostItem>? posts,
    SocialPrivacySettings? privacy,
    String? searchQuery,
    String? selectedFacultyFilter,
    bool? isLoading,
  }) {
    return SocialProfileState(
      activeUserId: activeUserId ?? this.activeUserId,
      students: students ?? this.students,
      posts: posts ?? this.posts,
      privacy: privacy ?? this.privacy,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedFacultyFilter:
          selectedFacultyFilter ?? this.selectedFacultyFilter,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

final socialConnectionServiceProvider = Provider<SocialConnectionService>((ref) {
  return SocialConnectionService();
});

final socialProfileProvider =
    NotifierProvider<SocialProfileNotifier, SocialProfileState>(
  SocialProfileNotifier.new,
);

UserModel buildFallbackDemoUser() {
  return const UserModel(
    id: 'demo_felicia',
    fullName: 'Felicia Angeline',
    nim: '535250029',
    email: 'felicia.535250029@stu.untar.ac.id',
    faculty: 'Faculty of Information Technology',
    studyProgram: 'Informatics',
    entryYear: '2025',
    avatar: AppConstants.pinkAvatarPath,
    isVerified: true,
    username: 'felicia.angeline',
    bio: 'Informatics @ UNTAR • Building Otter.ly community features 🦦✨',
    coverPreset: 'sunset',
  );
}

class SocialProfileNotifier extends Notifier<SocialProfileState> {
  SocialConnectionService get _service =>
      ref.read(socialConnectionServiceProvider);
  int _stateEpoch = 0;

  @override
  SocialProfileState build() {
    final authUser = ref.watch(authProvider);
    final effectiveUser = authUser ?? buildFallbackDemoUser();
    final loadEpoch = ++_stateEpoch;

    Future.microtask(() => _loadForUser(effectiveUser, loadEpoch));

    return SocialProfileState(
      activeUserId: effectiveUser.id,
      students: SocialConnectionService.seedStudents(),
      posts: SocialConnectionService.seedPosts(effectiveUser),
      privacy: SocialPrivacySettings(isPrivateAccount: effectiveUser.isPrivate),
      isLoading: true,
    );
  }

  Future<void> _loadForUser(UserModel user, int loadEpoch) async {
    final students = await _service.loadStudents(user.id);
    final posts = await _service.loadPosts(user.id, currentUser: user);
    final privacy = await _service.loadPrivacySettings(
      user.id,
      fallbackPrivate: user.isPrivate,
    );

    if (loadEpoch != _stateEpoch) return;

    // Sync own post author display metadata when the user edits their profile.
    final syncedPosts = posts.map((post) {
      if (!post.isOwnPost) return post;
      return post.copyWith(
        authorId: user.id,
        authorName: user.fullName,
        authorAvatar: user.avatar,
        faculty: user.faculty,
      );
    }).toList();

    state = state.copyWith(
      activeUserId: user.id,
      students: students,
      posts: syncedPosts,
      privacy: privacy,
      isLoading: false,
    );
  }

  Future<void> refresh() async {
    final authUser = ref.read(authProvider) ?? buildFallbackDemoUser();
    final loadEpoch = ++_stateEpoch;
    state = state.copyWith(isLoading: true);
    await _loadForUser(authUser, loadEpoch);
  }

  Future<void> _updateStudents(
    List<StudentProfileModel> updated,
  ) async {
    _stateEpoch++;
    state = state.copyWith(students: updated, isLoading: false);
    await _service.saveStudents(state.activeUserId, updated);
  }

  Future<void> _updatePosts(List<ProfilePostItem> updated) async {
    _stateEpoch++;
    state = state.copyWith(posts: updated, isLoading: false);
    await _service.savePosts(state.activeUserId, updated);
  }

  Future<void> sendFriendRequest(String studentId) async {
    final updated = state.students.map((student) {
      if (student.id != studentId) return student;
      return student.copyWith(
        friendshipStatus: FriendshipStatus.requestedSent,
        requestTimestamp: 'Just now',
      );
    }).toList();
    await _updateStudents(updated);
  }

  Future<void> cancelFriendRequest(String studentId) async {
    final updated = state.students.map((student) {
      if (student.id != studentId) return student;
      return student.copyWith(
        friendshipStatus: FriendshipStatus.none,
        clearRequestTimestamp: true,
      );
    }).toList();
    await _updateStudents(updated);
  }

  Future<void> acceptFriendRequest(String studentId) async {
    final updated = state.students.map((student) {
      if (student.id != studentId) return student;
      final addedFollow = !student.isFollowing ? 1 : 0;
      return student.copyWith(
        friendshipStatus: FriendshipStatus.friends,
        friendsCount: student.friendsCount + 1,
        followersCount: student.followersCount + addedFollow,
        isFollowing: true,
        isFollower: true,
        clearRequestTimestamp: true,
      );
    }).toList();
    await _updateStudents(updated);
  }

  Future<void> declineFriendRequest(String studentId) async {
    final updated = state.students.map((student) {
      if (student.id != studentId) return student;
      return student.copyWith(
        friendshipStatus: FriendshipStatus.none,
        clearRequestTimestamp: true,
      );
    }).toList();
    await _updateStudents(updated);
  }

  Future<void> removeFriend(String studentId) async {
    final updated = state.students.map((student) {
      if (student.id != studentId) return student;
      return student.copyWith(
        friendshipStatus: FriendshipStatus.none,
        friendsCount:
            student.friendsCount > 0 ? student.friendsCount - 1 : 0,
        clearRequestTimestamp: true,
      );
    }).toList();
    await _updateStudents(updated);
  }

  Future<void> toggleFollow(String studentId) async {
    final updated = state.students.map((student) {
      if (student.id != studentId) return student;
      final nextFollowing = !student.isFollowing;
      final nextFollowersCount = nextFollowing
          ? student.followersCount + 1
          : (student.followersCount > 0 ? student.followersCount - 1 : 0);
      return student.copyWith(
        isFollowing: nextFollowing,
        followersCount: nextFollowersCount,
      );
    }).toList();
    await _updateStudents(updated);
  }

  Future<void> blockUser(String studentId) async {
    final updated = state.students.map((student) {
      if (student.id != studentId) return student;
      final wasFollowing = student.isFollowing;
      final wasFriend = student.friendshipStatus == FriendshipStatus.friends;
      return student.copyWith(
        friendshipStatus: FriendshipStatus.blocked,
        isFollowing: false,
        isFollower: false,
        friendsCount:
            wasFriend && student.friendsCount > 0 ? student.friendsCount - 1 : student.friendsCount,
        followersCount: wasFollowing && student.followersCount > 0
            ? student.followersCount - 1
            : student.followersCount,
        clearRequestTimestamp: true,
      );
    }).toList();
    await _updateStudents(updated);
  }

  Future<void> unblockUser(String studentId) async {
    final updated = state.students.map((student) {
      if (student.id != studentId) return student;
      return student.copyWith(
        friendshipStatus: FriendshipStatus.none,
        clearRequestTimestamp: true,
      );
    }).toList();
    await _updateStudents(updated);
  }

  Future<void> togglePostLike(String postId) async {
    final updated = state.posts.map((post) {
      if (post.id != postId) return post;
      final nextLiked = !post.isLiked;
      return post.copyWith(
        isLiked: nextLiked,
        likesCount: nextLiked
            ? post.likesCount + 1
            : (post.likesCount > 0 ? post.likesCount - 1 : 0),
      );
    }).toList();
    await _updatePosts(updated);
  }

  Future<void> togglePostSave(String postId) async {
    final updated = state.posts.map((post) {
      if (post.id != postId) return post;
      return post.copyWith(isSaved: !post.isSaved);
    }).toList();
    await _updatePosts(updated);
  }

  Future<void> addProfilePost({
    required UserModel author,
    required String category,
    required String content,
    String? location,
    String audience = 'Public',
    List<String> imagePaths = const [],
    String? videoPath,
  }) async {
    final newPost = ProfilePostItem(
      id: 'post_${DateTime.now().microsecondsSinceEpoch}',
      authorId: author.id,
      authorName: author.fullName,
      authorAvatar: author.avatar,
      faculty: author.faculty,
      category: category,
      content: content.trim(),
      timeAgo: 'Just now',
      likesCount: 0,
      commentsCount: 0,
      isLiked: false,
      isSaved: false,
      isOwnPost: true,
      location: location,
      audience: audience,
      imagePaths: imagePaths,
      videoPath: videoPath,
    );
    await _updatePosts([newPost, ...state.posts]);
  }

  Future<void> deleteProfilePost(String postId) async {
    final updated = state.posts.where((post) => post.id != postId).toList();
    await _updatePosts(updated);
  }

  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void updateFacultyFilter(String faculty) {
    state = state.copyWith(selectedFacultyFilter: faculty);
  }

  Future<void> updatePrivacySettings({
    bool? isPrivateAccount,
    bool? allowRequestsFromMutualsOnly,
    bool? showActivityStatus,
  }) async {
    final nextPrivacy = state.privacy.copyWith(
      isPrivateAccount: isPrivateAccount,
      allowRequestsFromMutualsOnly: allowRequestsFromMutualsOnly,
      showActivityStatus: showActivityStatus,
    );
    state = state.copyWith(privacy: nextPrivacy);
    await _service.savePrivacySettings(state.activeUserId, nextPrivacy);

    if (isPrivateAccount != null) {
      final currentAuthUser = ref.read(authProvider);
      if (currentAuthUser != null &&
          currentAuthUser.isPrivate != isPrivateAccount) {
        await ref.read(authProvider.notifier).updateProfile(
              currentAuthUser.copyWith(isPrivate: isPrivateAccount),
            );
      }
    }
  }
}
