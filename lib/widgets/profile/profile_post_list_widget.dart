import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../models/friend_profile_model.dart';
import '../media/post_media_gallery_widget.dart';
import '../media/post_video_player_widget.dart';

class ProfilePostListWidget extends StatelessWidget {
  final List<ProfilePostItem> myPosts;
  final List<ProfilePostItem> savedPosts;
  final int selectedTabIndex;
  final ValueChanged<int> onTabChanged;
  final ValueChanged<String> onToggleLike;
  final ValueChanged<String> onToggleSave;
  final ValueChanged<ProfilePostItem>? onEditPost;
  final ValueChanged<String>? onDeletePost;
  final VoidCallback? onCreatePost;
  final bool showSavedTab;
  final bool isLockedPrivateProfile;

  const ProfilePostListWidget({
    super.key,
    required this.myPosts,
    required this.savedPosts,
    required this.selectedTabIndex,
    required this.onTabChanged,
    required this.onToggleLike,
    required this.onToggleSave,
    this.onEditPost,
    this.onDeletePost,
    this.onCreatePost,
    this.showSavedTab = true,
    this.isLockedPrivateProfile = false,
  });

  Widget _buildTabButton({
    required String label,
    required int count,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 11),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.pink : AppColors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? AppColors.pink : AppColors.border,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected ? AppColors.white : AppColors.burgundy,
              ),
              const SizedBox(width: 6),
              Text(
                '$label ($count)',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? AppColors.white : AppColors.textDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLockedState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: const Column(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: AppColors.cream,
            child: Icon(
              Icons.lock_outline_rounded,
              color: AppColors.burgundy,
              size: 28,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'This Account is Private',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: AppColors.textDark,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Send a friend request to connect and view their posts.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.5,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isSavedView) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: AppColors.cream,
            child: Icon(
              isSavedView
                  ? Icons.bookmark_border_rounded
                  : Icons.post_add_rounded,
              color: AppColors.burgundy,
              size: 26,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            isSavedView ? 'No Saved Posts Yet' : 'No Posts Yet',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            isSavedView
                ? 'Bookmark campus posts you love so you can revisit them anytime.'
                : 'Share updates, notes, or campus moments with your UNTAR friends!',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12.5,
              color: AppColors.textSecondary,
            ),
          ),
          if (!isSavedView && onCreatePost != null) ...[
            const SizedBox(height: 14),
            ElevatedButton.icon(
              onPressed: onCreatePost,
              icon: const Icon(Icons.add_rounded, size: 18),
              label: const Text('Create First Post'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.pink,
                foregroundColor: AppColors.white,
                minimumSize: const Size(180, 42),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPostCard(BuildContext context, ProfilePostItem post) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.cream,
                backgroundImage: AssetImage(post.authorAvatar),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.authorName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13.5,
                        color: AppColors.textDark,
                      ),
                    ),
                    Text(
                      '${post.faculty} • ${post.timeAgo} • ${post.audience}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    if (post.location != null && post.location!.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 12,
                            color: AppColors.pink,
                          ),
                          const SizedBox(width: 2),
                          Expanded(
                            child: Text(
                              post.location!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.burgundy,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              if (post.isOwnPost && (onEditPost != null || onDeletePost != null))
                PopupMenuButton<String>(
                  icon: const Icon(
                    Icons.more_horiz_rounded,
                    size: 20,
                    color: AppColors.textSecondary,
                  ),
                  onSelected: (value) {
                    if (value == 'edit') onEditPost?.call(post);
                    if (value == 'delete') onDeletePost?.call(post.id);
                  },
                  itemBuilder: (context) => [
                    if (onEditPost != null)
                      const PopupMenuItem(
                        value: 'edit',
                        child: Text('Edit Post'),
                      ),
                    if (onDeletePost != null)
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text(
                          'Delete Post',
                          style: TextStyle(color: AppColors.error),
                        ),
                      ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.cream,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              post.category,
              style: const TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.bold,
                color: AppColors.burgundy,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            post.content,
            style: const TextStyle(
              fontSize: 13.5,
              height: 1.45,
              color: AppColors.textDark,
            ),
          ),
          if (post.imagePaths.isNotEmpty) ...[
            const SizedBox(height: 12),
            PostMediaGalleryWidget(imagePaths: post.imagePaths),
          ],
          if (post.videoPath != null && post.videoPath!.isNotEmpty) ...[
            const SizedBox(height: 12),
            PostVideoPlayerWidget(videoPath: post.videoPath!),
          ],
          const Divider(height: 22, color: AppColors.border),
          Row(
            children: [
              InkWell(
                onTap: () => onToggleLike(post.id),
                borderRadius: BorderRadius.circular(10),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 4,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        post.isLiked
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        size: 19,
                        color: post.isLiked
                            ? AppColors.pink
                            : AppColors.textSecondary,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '${post.likesCount}',
                        style: const TextStyle(
                          fontSize: 12.5,
                          color: AppColors.textDark,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Row(
                children: [
                  const Icon(
                    Icons.chat_bubble_outline_rounded,
                    size: 18,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    '${post.commentsCount}',
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: AppColors.textDark,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              IconButton(
                tooltip: post.isSaved ? 'Unsave post' : 'Save post',
                onPressed: () => onToggleSave(post.id),
                icon: Icon(
                  post.isSaved
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_border_rounded,
                  color:
                      post.isSaved ? AppColors.pink : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isSavedView = showSavedTab && selectedTabIndex == 1;
    final activePosts = isSavedView ? savedPosts : myPosts;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showSavedTab)
          Row(
            children: [
              _buildTabButton(
                label: 'My Posts',
                count: myPosts.length,
                icon: Icons.article_outlined,
                isSelected: selectedTabIndex == 0,
                onTap: () => onTabChanged(0),
              ),
              const SizedBox(width: 10),
              _buildTabButton(
                label: 'Saved',
                count: savedPosts.length,
                icon: Icons.bookmark_outline_rounded,
                isSelected: selectedTabIndex == 1,
                onTap: () => onTabChanged(1),
              ),
            ],
          )
        else
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Posts',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.burgundy,
                    ),
                  ),
                ),
                Text(
                  '${myPosts.length} posts',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 14),
        if (isLockedPrivateProfile)
          _buildLockedState()
        else if (activePosts.isEmpty)
          _buildEmptyState(isSavedView)
        else
          ...activePosts.map((post) => _buildPostCard(context, post)),
      ],
    );
  }
}
