import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../models/friend_profile_model.dart';

class FriendUserCardWidget extends StatelessWidget {
  final StudentProfileModel student;
  final int mutualFriendsCount;
  final VoidCallback onTapProfile;
  final VoidCallback onPrimaryFriendAction;
  final VoidCallback onToggleFollow;
  final VoidCallback? onViewMutuals;
  final VoidCallback? onRemoveFriend;
  final VoidCallback? onBlockUser;

  const FriendUserCardWidget({
    super.key,
    required this.student,
    required this.mutualFriendsCount,
    required this.onTapProfile,
    required this.onPrimaryFriendAction,
    required this.onToggleFollow,
    this.onViewMutuals,
    this.onRemoveFriend,
    this.onBlockUser,
  });

  Widget _buildPrimaryActionButton() {
    switch (student.friendshipStatus) {
      case FriendshipStatus.friends:
        return OutlinedButton.icon(
          onPressed: onPrimaryFriendAction,
          icon: const Icon(Icons.check_rounded, size: 15),
          label: const Text('Friends'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.burgundy,
            backgroundColor: AppColors.cream.withValues(alpha: 0.65),
            side: const BorderSide(color: AppColors.border),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            minimumSize: const Size(0, 36),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      case FriendshipStatus.requestedSent:
        return OutlinedButton.icon(
          onPressed: onPrimaryFriendAction,
          icon: const Icon(Icons.close_rounded, size: 15),
          label: const Text('Cancel'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.textDark,
            backgroundColor: AppColors.white,
            side: const BorderSide(color: AppColors.border),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            minimumSize: const Size(0, 36),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      case FriendshipStatus.requestedReceived:
        return ElevatedButton.icon(
          onPressed: onPrimaryFriendAction,
          icon: const Icon(Icons.person_add_alt_1_rounded, size: 15),
          label: const Text('Accept'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.pink,
            foregroundColor: AppColors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            minimumSize: const Size(0, 36),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      case FriendshipStatus.blocked:
        return const SizedBox.shrink();
      case FriendshipStatus.none:
        return ElevatedButton.icon(
          onPressed: onPrimaryFriendAction,
          icon: const Icon(Icons.person_add_alt_1_rounded, size: 15),
          label: const Text('Add Friend'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.pink,
            foregroundColor: AppColors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            minimumSize: const Size(0, 36),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: InkWell(
        onTap: onTapProfile,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: AppColors.cream,
                    backgroundImage: AssetImage(student.avatar),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                student.fullName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: AppColors.textDark,
                                ),
                              ),
                            ),
                            if (student.isVerified) ...[
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.verified_rounded,
                                size: 16,
                                color: AppColors.pink,
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '@${student.username} • ${student.studyProgram} \'${student.entryYear.substring(student.entryYear.length >= 2 ? student.entryYear.length - 2 : 0)}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.background,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Text(
                                student.faculty,
                                style: const TextStyle(
                                  fontSize: 10.5,
                                  color: AppColors.burgundy,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            if (mutualFriendsCount > 0)
                              GestureDetector(
                                onTap: onViewMutuals,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.cream,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.group_outlined,
                                        size: 12,
                                        color: AppColors.burgundy,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '$mutualFriendsCount mutual',
                                        style: const TextStyle(
                                          fontSize: 10.5,
                                          color: AppColors.burgundy,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(
                      Icons.more_vert_rounded,
                      size: 20,
                      color: AppColors.textSecondary,
                    ),
                    onSelected: (value) {
                      if (value == 'profile') onTapProfile();
                      if (value == 'mutuals') onViewMutuals?.call();
                      if (value == 'remove') onRemoveFriend?.call();
                      if (value == 'block') onBlockUser?.call();
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'profile',
                        child: Text('View Profile'),
                      ),
                      if (onViewMutuals != null)
                        const PopupMenuItem(
                          value: 'mutuals',
                          child: Text('Mutual Friends'),
                        ),
                      if (student.friendshipStatus == FriendshipStatus.friends &&
                          onRemoveFriend != null)
                        const PopupMenuItem(
                          value: 'remove',
                          child: Text('Remove Friend'),
                        ),
                      if (onBlockUser != null)
                        const PopupMenuItem(
                          value: 'block',
                          child: Text(
                            'Block User',
                            style: TextStyle(color: AppColors.error),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _buildPrimaryActionButton()),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onToggleFollow,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: student.isFollowing
                            ? AppColors.pink
                            : AppColors.burgundy,
                        backgroundColor: AppColors.white,
                        side: BorderSide(
                          color: student.isFollowing
                              ? AppColors.pink
                              : AppColors.border,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        minimumSize: const Size(0, 36),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        student.isFollowing ? 'Following' : 'Follow',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
