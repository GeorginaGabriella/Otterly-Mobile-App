import 'package:flutter/material.dart';
import '../media/post_media_gallery_widget.dart';
import '../media/post_video_player_widget.dart';

class PostCardWidget extends StatelessWidget {
  final String userName;
  final String faculty;
  final String time;
  final String category;
  final String content;
  final int likeCount;
  final int commentCount;
  final bool isLiked;
  final bool isSaved;
  final List<String> imagePaths;
  final String? videoPath;
  final String? location;
  final String audience;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback onShare;
  final VoidCallback onSave;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const PostCardWidget({
    super.key,
    required this.userName,
    required this.faculty,
    required this.time,
    required this.category,
    required this.content,
    required this.likeCount,
    required this.commentCount,
    required this.isLiked,
    required this.isSaved,
    this.imagePaths = const [],
    this.videoPath,
    this.location,
    this.audience = 'Public',
    required this.onLike,
    required this.onComment,
    required this.onShare,
    required this.onSave,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final audienceIcon = audience == 'Friends'
        ? Icons.people_outline_rounded
        : audience == 'Only Me'
            ? Icons.lock_outline_rounded
            : Icons.public;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF3D9D5)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFB0183D).withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                radius: 21,
                backgroundColor: Color(0xFFFFD464),
                child: Icon(Icons.person, color: Color(0xFFB0183D)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            userName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.5,
                              color: Color(0xFF38252A),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFCEDD8),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            category,
                            style: const TextStyle(
                              fontSize: 10,
                              color: Color(0xFFB0183D),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            '$faculty • $time',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 11.5,
                              color: Color(0xFF8B7479),
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Icon(
                          audienceIcon,
                          size: 13,
                          color: const Color(0xFF8B7479),
                        ),
                      ],
                    ),
                    if (location != null && location!.isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 13,
                            color: Color(0xFFE23C64),
                          ),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text(
                              location!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 11.5,
                                color: Color(0xFFB0183D),
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
              PopupMenuButton<String>(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(
                  Icons.more_horiz_rounded,
                  color: Color(0xFF8B7479),
                ),
                onSelected: (value) {
                  if (value == 'share') onShare();
                  if (value == 'save') onSave();
                  if (value == 'edit') onEdit?.call();
                  if (value == 'delete') onDelete?.call();
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'share',
                    child: Text('Share post'),
                  ),
                  PopupMenuItem(
                    value: 'save',
                    child: Text(isSaved ? 'Unsave post' : 'Save post'),
                  ),
                  if (onEdit != null)
                    const PopupMenuItem(
                      value: 'edit',
                      child: Text('Edit post'),
                    ),
                  if (onDelete != null)
                    const PopupMenuItem(
                      value: 'delete',
                      child: Text(
                        'Delete post',
                        style: TextStyle(color: Color(0xFFCC334D)),
                      ),
                    ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              height: 1.5,
              color: Color(0xFF38252A),
            ),
          ),

          if (imagePaths.isNotEmpty) ...[
            const SizedBox(height: 12),
            PostMediaGalleryWidget(imagePaths: imagePaths),
          ],

          if (videoPath != null && videoPath!.isNotEmpty) ...[
            const SizedBox(height: 12),
            PostVideoPlayerWidget(videoPath: videoPath!),
          ],

          const SizedBox(height: 10),
          const Divider(height: 14, color: Color(0xFFF3D9D5)),

          Row(
            children: [
              InkWell(
                onTap: onLike,
                child: Row(
                  children: [
                    Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                      color: isLiked
                          ? const Color(0xFFE23C64)
                          : const Color(0xFF8B7479),
                    ),
                    const SizedBox(width: 5),
                    Text('$likeCount'),
                  ],
                ),
              ),

              const SizedBox(width: 25),

              InkWell(
                onTap: onComment,
                child: Row(
                  children: [
                    const Icon(
                      Icons.chat_bubble_outline,
                      color: Color(0xFF8B7479),
                    ),
                    const SizedBox(width: 5),
                    Text('$commentCount'),
                  ],
                ),
              ),

              const Spacer(),

              IconButton(
                tooltip: isSaved ? 'Unsave post' : 'Save post',
                onPressed: onSave,
                icon: Icon(
                  isSaved ? Icons.bookmark : Icons.bookmark_border,
                  color: isSaved
                      ? const Color(0xFFE23C64)
                      : const Color(0xFF8B7479),
                ),
              ),

              IconButton(
                onPressed: onShare,
                icon: const Icon(
                  Icons.share_outlined,
                  color: Color(0xFF8B7479),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
