import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'post_model.dart';

class PostInteractionBar extends StatefulWidget {
  final PostModel post;
  final String currentUserName;
  final VoidCallback onEditPressed;

  const PostInteractionBar({
    super.key,
    required this.post,
    required this.currentUserName,
    required this.onEditPressed,
  });

  @override
  State<PostInteractionBar> createState() => _PostInteractionBarState();
}

class _PostInteractionBarState extends State<PostInteractionBar> {
  void _toggleLike() {
    setState(() {
      widget.post.isLiked = !widget.post.isLiked;
      widget.post.likesCount += widget.post.isLiked ? 1 : -1;
    });
  }

  void _openComments() {
    final commentController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: SizedBox(
            height: 400,
            child: Column(
              children: [
                const Text(
                  'Comments',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const Divider(),
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.post.comments.length,
                    itemBuilder: (_, i) {
                      final c = widget.post.comments[i];
                      return ListTile(
                        title: Text(
                          c.authorName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(c.text),
                      );
                    },
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: commentController,
                        decoration: const InputDecoration(
                          hintText: 'Add a comment...',
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () {
                        if (commentController.text.trim().isEmpty) return;
                        setModalState(() {
                          widget.post.comments.add(
                            CommentModel(
                              id: DateTime.now().toString(),
                              authorName: widget.currentUserName,
                              text: commentController.text.trim(),
                              createdAt: DateTime.now(),
                            ),
                          );
                        });
                        setState(() {});
                        commentController.clear();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _sharePost() {
    Clipboard.setData(
      ClipboardData(text: '${widget.post.authorName}: ${widget.post.content}'),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Post copied to clipboard!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        TextButton.icon(
          onPressed: _toggleLike,
          icon: Icon(
            widget.post.isLiked ? Icons.favorite : Icons.favorite_border,
            color: widget.post.isLiked ? Colors.red : null,
          ),
          label: Text('${widget.post.likesCount}'),
        ),
        TextButton.icon(
          onPressed: _openComments,
          icon: const Icon(Icons.comment_outlined),
          label: Text('${widget.post.comments.length}'),
        ),
        TextButton.icon(
          onPressed: _sharePost,
          icon: const Icon(Icons.share_outlined),
          label: const Text('Share'),
        ),
      ],
    );
  }
}
