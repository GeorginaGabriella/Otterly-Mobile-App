import 'package:flutter/material.dart';

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
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback onShare;
  final VoidCallback onSave;

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
    required this.onLike,
    required this.onComment,
    required this.onShare,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF3D9D5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                backgroundColor: Color(0xFFFFD464),
                child: Icon(Icons.person, color: Color(0xFFB0183D)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF38252A),
                      ),
                    ),
                    Text(
                      '$faculty • $time',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF8B7479),
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'share') onShare();
                  if (value == 'save') onSave();
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
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFFCEDB8),
              borderRadius: BorderRadius.circular(15),
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

          const SizedBox(height: 12),

          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              height: 1.5,
              color: Color(0xFF38252A),
            ),
          ),

          const Divider(height: 25, color: Color(0xFFF3D9D5)),

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
