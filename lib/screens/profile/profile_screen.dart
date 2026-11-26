import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/app_colors.dart';
import '../../models/friend_profile_model.dart';
import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/social_profile_provider.dart';
import '../../widgets/friends/mutual_friends_sheet_widget.dart';
import '../../widgets/media/post_composer_sheet.dart';
import '../../widgets/profile/profile_header_widget.dart';
import '../../widgets/profile/profile_post_list_widget.dart';
import '../../widgets/profile/profile_privacy_tile_widget.dart';
import '../../widgets/profile/profile_stats_row_widget.dart';
import '../../widgets/profile/student_info_card_widget.dart';
import '../friends/friends_screen.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  final String? studentId;
  final bool showAppBar;

  const ProfileScreen({
    super.key,
    this.studentId,
    this.showAppBar = false,
  });

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  int _selectedPostTab = 0;

  bool get _isOwnProfile => widget.studentId == null;

  void _openFriendsScreen({int initialTabIndex = 0}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FriendsScreen(initialTabIndex: initialTabIndex),
      ),
    );
  }

  void _openEditProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const EditProfileScreen(),
      ),
    );
  }

  void _openOtherProfile(StudentProfileModel student) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProfileScreen(
          studentId: student.id,
          showAppBar: true,
        ),
      ),
    );
  }

  void _showSnack(String message, {Color background = AppColors.burgundy}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: background,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showConnectionsListSheet({
    required String title,
    required List<StudentProfileModel> users,
    required String emptyMessage,
  }) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$title (${users.length})',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.burgundy,
                ),
              ),
              const SizedBox(height: 12),
              if (users.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Text(
                    emptyMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                )
              else
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: users.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (_, index) {
                      final student = users[index];
                      return ListTile(
                        tileColor: AppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                          side: const BorderSide(color: AppColors.border),
                        ),
                        leading: CircleAvatar(
                          backgroundColor: AppColors.cream,
                          backgroundImage: AssetImage(student.avatar),
                        ),
                        title: Text(
                          student.fullName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: AppColors.textDark,
                          ),
                        ),
                        subtitle: Text(
                          '@${student.username} • ${student.studyProgram}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.chevron_right_rounded,
                          color: AppColors.burgundy,
                        ),
                        onTap: () {
                          Navigator.pop(sheetContext);
                          _openOtherProfile(student);
                        },
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showBlockedUsersSheet() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => Consumer(
        builder: (context, ref, _) {
          final blocked = ref.watch(socialProfileProvider).blockedUsers;
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Blocked Accounts',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.burgundy,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (blocked.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: const Text(
                        'No blocked students.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    )
                  else
                    Flexible(
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: blocked.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (_, index) {
                          final student = blocked[index];
                          return ListTile(
                            tileColor: AppColors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                              side: const BorderSide(color: AppColors.border),
                            ),
                            leading: CircleAvatar(
                              backgroundColor: AppColors.cream,
                              backgroundImage: AssetImage(student.avatar),
                            ),
                            title: Text(student.fullName),
                            subtitle: Text('@${student.username}'),
                            trailing: TextButton(
                              onPressed: () async {
                                await ref
                                    .read(socialProfileProvider.notifier)
                                    .unblockUser(student.id);
                                if (mounted) {
                                  _showSnack(
                                    'Unblocked ${student.fullName}.',
                                    background: AppColors.success,
                                  );
                                }
                              },
                              child: const Text('Unblock'),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showPrivacySheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => Consumer(
        builder: (context, ref, _) {
          final socialState = ref.watch(socialProfileProvider);
          final notifier = ref.read(socialProfileProvider.notifier);

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 4, 18, 22),
              child: ProfilePrivacyTileWidget(
                isPrivateAccount: socialState.privacy.isPrivateAccount,
                allowRequestsFromMutualsOnly:
                    socialState.privacy.allowRequestsFromMutualsOnly,
                showActivityStatus: socialState.privacy.showActivityStatus,
                blockedCount: socialState.blockedUsers.length,
                onPrivateAccountChanged: (val) =>
                    notifier.updatePrivacySettings(isPrivateAccount: val),
                onMutualsOnlyChanged: (val) => notifier.updatePrivacySettings(
                  allowRequestsFromMutualsOnly: val,
                ),
                onActivityStatusChanged: (val) =>
                    notifier.updatePrivacySettings(showActivityStatus: val),
                onManageBlockedUsers: () {
                  Navigator.pop(sheetContext);
                  _showBlockedUsersSheet();
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _showCreateProfilePostDialog(UserModel currentUser) async {
    final result = await PostComposerSheet.show(
      context,
      authorName: currentUser.fullName,
      authorAvatar: currentUser.avatar,
    );
    if (result == null) return;

    await ref.read(socialProfileProvider.notifier).addProfilePost(
          author: currentUser,
          category: result.category,
          content: result.content,
          location: result.location,
          audience: result.audience,
          imagePaths: result.imagePaths,
          videoPath: result.videoPath,
        );
    if (mounted) {
      _showSnack(
        'Posted to your profile!',
        background: AppColors.success,
      );
    }
  }

  Future<void> _confirmDeletePost(String postId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.background,
        title: const Text(
          'Delete Post',
          style: TextStyle(
            color: AppColors.burgundy,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text('Are you sure you want to delete this post?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: AppColors.white,
              minimumSize: const Size(0, 40),
            ),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(socialProfileProvider.notifier).deleteProfilePost(postId);
      if (mounted) {
        _showSnack('Post deleted.');
      }
    }
  }

  Future<void> _handleOtherFriendAction(StudentProfileModel student) async {
    final notifier = ref.read(socialProfileProvider.notifier);
    switch (student.friendshipStatus) {
      case FriendshipStatus.none:
        await notifier.sendFriendRequest(student.id);
        if (mounted) {
          _showSnack(
            'Friend request sent to ${student.fullName}!',
            background: AppColors.success,
          );
        }
      case FriendshipStatus.requestedSent:
        await notifier.cancelFriendRequest(student.id);
        if (mounted) _showSnack('Friend request cancelled.');
      case FriendshipStatus.requestedReceived:
        await notifier.acceptFriendRequest(student.id);
        if (mounted) {
          _showSnack(
            'You are now friends with ${student.fullName}!',
            background: AppColors.success,
          );
        }
      case FriendshipStatus.friends:
        final confirm = await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            backgroundColor: AppColors.background,
            title: const Text(
              'Remove Friend',
              style: TextStyle(
                color: AppColors.burgundy,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text('Unfriend ${student.fullName}?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.pink,
                  foregroundColor: AppColors.white,
                  minimumSize: const Size(0, 40),
                ),
                onPressed: () => Navigator.pop(dialogContext, true),
                child: const Text('Remove'),
              ),
            ],
          ),
        );
        if (confirm == true) {
          await notifier.removeFriend(student.id);
          if (mounted) _showSnack('Removed ${student.fullName} from friends.');
        }
      case FriendshipStatus.blocked:
        await notifier.unblockUser(student.id);
        if (mounted) _showSnack('Unblocked ${student.fullName}.');
    }
  }

  Future<void> _confirmBlockStudent(StudentProfileModel student) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.background,
        title: const Text(
          'Block Student',
          style: TextStyle(
            color: AppColors.error,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text('Block ${student.fullName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: AppColors.white,
              minimumSize: const Size(0, 40),
            ),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Block'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await ref.read(socialProfileProvider.notifier).blockUser(student.id);
      if (mounted) {
        _showSnack('Blocked ${student.fullName}.');
        Navigator.pop(context);
      }
    }
  }

  Widget _buildOwnProfileBody(SocialProfileState socialState) {
    final currentUser = ref.watch(authProvider) ?? buildFallbackDemoUser();
    final friends = socialState.friends;
    final followers = socialState.followers;
    final following = socialState.following;
    final incomingCount = socialState.incomingRequests.length;

    return RefreshIndicator(
      color: AppColors.pink,
      onRefresh: ref.read(socialProfileProvider.notifier).refresh,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
        children: [
          ProfileHeaderWidget(
            fullName: currentUser.fullName,
            username: currentUser.effectiveUsername,
            bio: currentUser.bio,
            avatarAsset: currentUser.avatar,
            customProfileImagePath: currentUser.customProfileImagePath,
            coverPreset: currentUser.coverPreset,
            coverImagePath: currentUser.coverImagePath,
            isVerified: currentUser.isVerified,
            isPrivate: socialState.privacy.isPrivateAccount,
            isOwnProfile: true,
            onEditProfile: _openEditProfile,
            onOpenFriends: () => _openFriendsScreen(initialTabIndex: 0),
            onOpenPrivacy: _showPrivacySheet,
          ),
          const SizedBox(height: 14),
          if (incomingCount > 0) ...[
            Material(
              color: AppColors.cream.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(16),
              child: InkWell(
                onTap: () => _openFriendsScreen(initialTabIndex: 1),
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 18,
                        backgroundColor: AppColors.pink,
                        child: Icon(
                          Icons.person_add_alt_1_rounded,
                          size: 18,
                          color: AppColors.white,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '$incomingCount pending friend request${incomingCount > 1 ? 's' : ''}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13.5,
                            color: AppColors.burgundy,
                          ),
                        ),
                      ),
                      const Text(
                        'Review',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12.5,
                          color: AppColors.pink,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: AppColors.pink,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
          ],
          ProfileStatsRowWidget(
            friendsCount: friends.length,
            followersCount: followers.length,
            followingCount: following.length,
            onFriendsTap: () => _openFriendsScreen(initialTabIndex: 2),
            onFollowersTap: () => _showConnectionsListSheet(
              title: 'Followers',
              users: followers,
              emptyMessage: 'No followers yet.',
            ),
            onFollowingTap: () => _showConnectionsListSheet(
              title: 'Following',
              users: following,
              emptyMessage: 'You are not following anyone yet.',
            ),
          ),
          const SizedBox(height: 14),
          StudentInfoCardWidget(
            faculty: currentUser.faculty,
            studyProgram: currentUser.studyProgram,
            entryYear: currentUser.entryYear,
            nim: currentUser.nim,
            isVerified: currentUser.isVerified,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Activity & Posts',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.burgundy,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: () => _showCreateProfilePostDialog(currentUser),
                icon: const Icon(Icons.add_circle_outline_rounded, size: 18),
                label: const Text('New Post'),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ProfilePostListWidget(
            myPosts: socialState.myPosts,
            savedPosts: socialState.savedPosts,
            selectedTabIndex: _selectedPostTab,
            onTabChanged: (index) => setState(() => _selectedPostTab = index),
            onToggleLike: ref.read(socialProfileProvider.notifier).togglePostLike,
            onToggleSave: ref.read(socialProfileProvider.notifier).togglePostSave,
            onDeletePost: _confirmDeletePost,
            onCreatePost: () => _showCreateProfilePostDialog(currentUser),
            showSavedTab: true,
          ),
        ],
      ),
    );
  }

  Widget _buildOtherProfileBody(
    SocialProfileState socialState,
    StudentProfileModel student,
  ) {
    final notifier = ref.read(socialProfileProvider.notifier);
    final mutuals = socialState.mutualFriendsFor(student);
    final isLockedPrivate =
        student.isPrivate &&
        student.friendshipStatus != FriendshipStatus.friends;
    final posts = socialState.postsForStudent(student.id);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
      children: [
        ProfileHeaderWidget(
          fullName: student.fullName,
          username: student.username,
          bio: student.bio,
          avatarAsset: student.avatar,
          coverPreset: student.coverPreset,
          isVerified: student.isVerified,
          isPrivate: student.isPrivate,
          isOwnProfile: false,
          friendshipStatus: student.friendshipStatus,
          isFollowing: student.isFollowing,
          onFriendAction: () => _handleOtherFriendAction(student),
          onDeclineRequest:
              student.friendshipStatus == FriendshipStatus.requestedReceived
                  ? () => notifier.declineFriendRequest(student.id)
                  : null,
          onToggleFollow: () => notifier.toggleFollow(student.id),
          onViewMutuals: () => MutualFriendsSheetWidget.show(
            context,
            targetName: student.fullName,
            mutualFriends: mutuals,
            onSelectStudent: _openOtherProfile,
          ),
          onBlockUser: () => _confirmBlockStudent(student),
        ),
        const SizedBox(height: 14),
        if (mutuals.isNotEmpty) ...[
          InkWell(
            onTap: () => MutualFriendsSheetWidget.show(
              context,
              targetName: student.fullName,
              mutualFriends: mutuals,
              onSelectStudent: _openOtherProfile,
            ),
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.group_rounded,
                    size: 18,
                    color: AppColors.pink,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '${mutuals.length} mutual friend${mutuals.length > 1 ? 's' : ''} (${mutuals.take(2).map((m) => m.fullName.split(' ').first).join(', ')})',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.burgundy,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
        ],
        ProfileStatsRowWidget(
          friendsCount: student.friendsCount,
          followersCount: student.followersCount,
          followingCount: student.followingCount,
          onFriendsTap: () => MutualFriendsSheetWidget.show(
            context,
            targetName: student.fullName,
            mutualFriends: mutuals,
            onSelectStudent: _openOtherProfile,
          ),
        ),
        const SizedBox(height: 14),
        StudentInfoCardWidget(
          faculty: student.faculty,
          studyProgram: student.studyProgram,
          entryYear: student.entryYear,
          nim: student.nim,
          isVerified: student.isVerified,
          hideSensitiveNim: isLockedPrivate,
        ),
        const SizedBox(height: 16),
        ProfilePostListWidget(
          myPosts: posts,
          savedPosts: const [],
          selectedTabIndex: 0,
          onTabChanged: (_) {},
          onToggleLike: notifier.togglePostLike,
          onToggleSave: notifier.togglePostSave,
          showSavedTab: false,
          isLockedPrivateProfile: isLockedPrivate,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final socialState = ref.watch(socialProfileProvider);

    Widget body;
    String title = 'Profile';

    if (_isOwnProfile) {
      body = _buildOwnProfileBody(socialState);
    } else {
      final student = socialState.findStudentById(widget.studentId!);
      if (student == null) {
        body = const Center(
          child: Text('Student profile not found.'),
        );
      } else {
        title = student.fullName;
        body = _buildOtherProfileBody(socialState, student);
      }
    }

    if (!widget.showAppBar) {
      return body;
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(
          title,
          style: const TextStyle(
            color: AppColors.burgundy,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: body,
    );
  }
}
