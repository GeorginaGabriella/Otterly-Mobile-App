import 'package:flutter/material.dart';

class TrendingPostWidget extends StatelessWidget {
  final String title;
  final String category;
  final int likes;

  const TrendingPostWidget({
    super.key,
    required this.title,
    required this.category,
    required this.likes,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFD464),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.trending_up, color: Color(0xFFB0183D)),
              SizedBox(width: 6),
              Text(
                'TRENDING',
                style: TextStyle(
                  color: Color(0xFFB0183D),
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Color(0xFF38252A),
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Text(category, style: const TextStyle(fontSize: 11)),
              const Spacer(),
              const Icon(Icons.favorite, size: 14, color: Color(0xFFE23C64)),
              const SizedBox(width: 4),
              Text('$likes'),
            ],
          ),
        ],
      ),
    );
  }
}
