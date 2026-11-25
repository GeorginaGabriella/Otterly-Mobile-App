import 'package:flutter/material.dart';

class HomeHeaderWidget extends StatelessWidget {
  final String userName;
  final VoidCallback? onNotificationTap;

  const HomeHeaderWidget({
    super.key,
    required this.userName,
    this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 23,
          backgroundColor: Color(0xFFFFD464),
          child: Icon(Icons.pets, color: Color(0xFFB0183D), size: 27),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Good morning,',
                style: TextStyle(color: Color(0xFF8B7479), fontSize: 12),
              ),
              Text(
                userName,
                style: const TextStyle(
                  color: Color(0xFF38252A),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: onNotificationTap,
          icon: const Icon(
            Icons.notifications_none_rounded,
            color: Color(0xFFB0183D),
            size: 28,
          ),
        ),
      ],
    );
  }
}
