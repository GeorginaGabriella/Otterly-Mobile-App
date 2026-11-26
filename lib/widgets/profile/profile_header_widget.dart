import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../core/app_constants.dart';
import '../../models/friend_profile_model.dart';
import 'adaptive_image_stub.dart'
    if (dart.library.io) 'adaptive_image_io.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final String fullName;
  final String username;
  final String bio;
  final String avatarAsset;
  final String? customProfileImagePath;
  final String coverPreset;
  final String? coverImagePath;
  final bool isVerified;
  final bool isPrivate;
  final bool isOwnProfile;
  final FriendshipStatus friendshipStatus;
  final bool isFollowing;
  final VoidCallback? onEditProfile;
  final VoidCallback? onOpenFriends;
  final VoidCallback? onOpenPrivacy;
  final VoidCallback? onFriendAction;
  final VoidCallback? onDeclineRequest;
  final VoidCallback? onToggleFollow;
  final VoidCallback? onViewMutuals;
  final VoidCallback? onBlockUser;

  const ProfileHeaderWidget({
    super.key,
    required this.fullName,
    required this.username,
    required this.bio,
    required this.avatarAsset,
    this.customProfileImagePath,
    this.coverPreset = 'sunset',
    this.coverImagePath,
    this.isVerified = false,
    this.isPrivate = false,
    this.isOwnProfile = true,
    this.friendshipStatus = FriendshipStatus.none,
    this.isFollowing = false,
    this.onEditProfile,
    this.onOpenFriends,
    this.onOpenPrivacy,
    this.onFriendAction,
    this.onDeclineRequest,
    this.onToggleFollow,
    this.onViewMutuals,
    this.onBlockUser,
  });

  Widget _buildCoverBanner() {
    final theme = CoverPresetTheme.resolve(coverPreset);

    return Container(
      height: 155,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: theme.gradientColors,
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (coverImagePath != null && coverImagePath!.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: buildAdaptiveFileImage(
                coverImagePath!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
            ),
          Positioned(
            right: -18,
            top: -22,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.14),
              ),
            ),
          ),
          if (coverImagePath == null || coverImagePath!.isEmpty)
            Positioned(
              right: 18,
              bottom: 10,
              child: Opacity(
                opacity: 0.24,
                child: Image.asset(
                  AppConstants.brandMarkPath,
                  width: 66,
                  height: 66,
                  color: AppColors.white,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                ),
              ),
            ),
          Positioned(
            left: 16,
            top: 14,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isPrivate ? Icons.lock_outline : Icons.public,
                    size: 13,
                    color: AppColors.white,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    isPrivate ? 'Private Profile' : 'UNTAR Community',
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isOwnProfile && onEditProfile != null)
            Positioned(
              right: 12,
              top: 12,
              child: Material(
                color: Colors.black.withValues(alpha: 0.28),
                borderRadius: BorderRadius.circular(20),
                child: InkWell(
                  onTap: onEditProfile,
                  borderRadius: BorderRadius.circular(20),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.photo_camera_outlined,
                          color: AppColors.white,
                          size: 14,
                        ),
                        SizedBox(width: 5),
                        Text(
                          'Cover',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    final hasCustom =
        customProfileImagePath != null && customProfileImagePath!.isNotEmpty;
    final resolvedAsset =
        avatarAsset.isNotEmpty ? avatarAsset : AppConstants.pinkAvatarPath;

    return Container(
      width: 96,
      height: 96,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.white,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.pink, width: 2.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.burgundy.withValues(alpha: 0.14),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipOval(
        child: hasCustom
            ? buildAdaptiveFileImage(
                customProfileImagePath!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Image.asset(
                  resolvedAsset,
                  fit: BoxFit.cover,
                ),
              )
            : Image.asset(
                resolvedAsset,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const CircleAvatar(
                  backgroundColor: AppColors.cream,
                  child: Icon(
                    Icons.pets,
                    color: AppColors.burgundy,
                    size: 38,
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildOwnActions() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: onEditProfile,
            icon: const Icon(Icons.edit_outlined, size: 18),
            label: const Text('Edit Profile'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.pink,
              foregroundColor: AppColors.white,
              minimumSize: const Size(0, 44),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onOpenFriends,
            icon: const Icon(Icons.people_outline_rounded, size: 18),
            label: const Text('Find Friends'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.burgundy,
              side: const BorderSide(color: AppColors.border, width: 1.4),
              backgroundColor: AppColors.white,
              minimumSize: const Size(0, 44),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
        if (onOpenPrivacy != null) ...[
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: IconButton(
              tooltip: 'Account Privacy',
              onPressed: onOpenPrivacy,
              icon: Icon(
                isPrivate ? Icons.lock_rounded : Icons.shield_outlined,
                color: AppColors.burgundy,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildOtherUserActions() {
    String friendLabel;
    IconData friendIcon;
    Color friendBg;
    Color friendFg;

    switch (friendshipStatus) {
      case FriendshipStatus.friends:
        friendLabel = 'Friends';
        friendIcon = Icons.how_to_reg_rounded;
        friendBg = AppColors.cream;
        friendFg = AppColors.burgundy;
      case FriendshipStatus.requestedSent:
        friendLabel = 'Requested';
        friendIcon = Icons.schedule_rounded;
        friendBg = AppColors.cream;
        friendFg = AppColors.textDark;
      case FriendshipStatus.requestedReceived:
        friendLabel = 'Accept';
        friendIcon = Icons.check_circle_outline;
        friendBg = AppColors.pink;
        friendFg = AppColors.white;
      case FriendshipStatus.blocked:
        friendLabel = 'Blocked';
        friendIcon = Icons.block;
        friendBg = AppColors.border;
        friendFg = AppColors.textSecondary;
      case FriendshipStatus.none:
        friendLabel = 'Add Friend';
        friendIcon = Icons.person_add_alt_1_rounded;
        friendBg = AppColors.pink;
        friendFg = AppColors.white;
    }

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: onFriendAction,
                icon: Icon(friendIcon, size: 18),
                label: Text(friendLabel),
                style: ElevatedButton.styleFrom(
                  backgroundColor: friendBg,
                  foregroundColor: friendFg,
                  elevation: 0,
                  minimumSize: const Size(0, 44),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
            if (friendshipStatus == FriendshipStatus.requestedReceived &&
                onDeclineRequest != null) ...[
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: onDeclineRequest,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: const BorderSide(color: AppColors.border),
                  backgroundColor: AppColors.white,
                  minimumSize: const Size(0, 44),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text('Decline'),
              ),
            ] else ...[
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onToggleFollow,
                  icon: Icon(
                    isFollowing
                        ? Icons.notifications_active_outlined
                        : Icons.add_rounded,
                    size: 18,
                  ),
                  label: Text(isFollowing ? 'Following' : 'Follow'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor:
                        isFollowing ? AppColors.pink : AppColors.burgundy,
                    backgroundColor: AppColors.white,
                    side: BorderSide(
                      color: isFollowing ? AppColors.pink : AppColors.border,
                      width: 1.3,
                    ),
                    minimumSize: const Size(0, 44),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
            const SizedBox(width: 6),
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: PopupMenuButton<String>(
                icon: const Icon(
                  Icons.more_horiz_rounded,
                  color: AppColors.burgundy,
                ),
                onSelected: (value) {
                  if (value == 'mutuals') onViewMutuals?.call();
                  if (value == 'block') onBlockUser?.call();
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'mutuals',
                    child: Row(
                      children: [
                        Icon(Icons.group_outlined, size: 18),
                        SizedBox(width: 8),
                        Text('Mutual Friends'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'block',
                    child: Row(
                      children: [
                        Icon(Icons.block, size: 18, color: AppColors.error),
                        SizedBox(width: 8),
                        Text(
                          'Block User',
                          style: TextStyle(color: AppColors.error),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final normalizedUsername =
        username.startsWith('@') ? username : '@$username';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              _buildCoverBanner(),
              Positioned(
                left: 14,
                bottom: -42,
                child: _buildAvatar(),
              ),
            ],
          ),
          const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        fullName,
                        style: const TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                    if (isVerified) ...[
                      const SizedBox(width: 6),
                      const Tooltip(
                        message: 'Verified UNTAR Student',
                        child: Icon(
                          Icons.verified_rounded,
                          color: AppColors.pink,
                          size: 20,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  normalizedUsername,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.burgundy,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  bio.trim().isEmpty
                      ? 'No bio yet. Tap Edit Profile to introduce yourself!'
                      : bio,
                  style: const TextStyle(
                    fontSize: 13.5,
                    height: 1.45,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 16),
                if (isOwnProfile)
                  _buildOwnActions()
                else
                  _buildOtherUserActions(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
