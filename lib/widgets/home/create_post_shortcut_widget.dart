import 'package:flutter/material.dart';

class CreatePostShortcutWidget extends StatelessWidget {
  final String userName;
  final VoidCallback onTap;

  const CreatePostShortcutWidget({
    super.key,
    required this.userName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF3D9D5)),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Color(0xFFFFD464),
            child: Icon(Icons.person, color: Color(0xFFB0183D)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFAF0),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Text(
                  'What’s on your mind, $userName?',
                  style: const TextStyle(
                    color: Color(0xFF8B7479),
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: onTap,
            icon: const Icon(Icons.image_outlined, color: Color(0xFFE23C64)),
          ),
        ],
      ),
    );
  }
}
