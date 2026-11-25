import 'package:flutter/material.dart';
import '../models/post_model.dart';

class CreateEditPostScreen extends StatefulWidget {
  final PostModel? existingPost; // Null = Create mode, Non-null = Edit mode
  final String currentUserId;
  final String currentUserName;

  const CreateEditPostScreen({
    super.key,
    this.existingPost,
    required this.currentUserId,
    required this.currentUserName,
  });

  @override
  State<CreateEditPostScreen> createState() => _CreateEditPostScreenState();
}

class _CreateEditPostScreenState extends State<CreateEditPostScreen> {
  late TextEditingController _contentController;
  String _selectedCategory = 'General';
  final List<String> _categories = ['General', 'Events', 'Campus', 'Help'];

  bool get isEditing => widget.existingPost != null;

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController(
      text: widget.existingPost?.content ?? '',
    );
    if (widget.existingPost != null) {
      _selectedCategory = widget.existingPost!.category;
    }
  }

  void _savePost() {
    final text = _contentController.text.trim();
    if (text.isEmpty) return;

    if (isEditing) {
      widget.existingPost!.content = text;
      widget.existingPost!.category = _selectedCategory;
      Navigator.pop(context, widget.existingPost);
    } else {
      final newPost = PostModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        authorId: widget.currentUserId,
        authorName: widget.currentUserName,
        content: text,
        category: _selectedCategory,
        createdAt: DateTime.now(),
      );
      Navigator.pop(context, newPost);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Post' : 'Create Post'),
        actions: [
          TextButton(
            onPressed: _savePost,
            child: Text(isEditing ? 'Update' : 'Post'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(labelText: 'Category'),
              items: _categories
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (val) => setState(() => _selectedCategory = val!),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: _contentController,
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(
                  hintText: "What's on your mind?",
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
