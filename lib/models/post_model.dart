class CommentModel {
  final String id;
  final String authorName;
  final String text;
  final DateTime createdAt;

  CommentModel({
    required this.id,
    required this.authorName,
    required this.text,
    required this.createdAt,
  });
}

class PostModel {
  final String id;
  final String authorId;
  final String authorName;
  String content;
  String category;
  bool isLiked;
  int likesCount;
  final List<CommentModel> comments;
  final DateTime createdAt;

  PostModel({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.content,
    this.category = 'General',
    this.isLiked = false,
    this.likesCount = 0,
    List<CommentModel>? comments,
    required this.createdAt,
  }) : comments = comments ?? [];
}
