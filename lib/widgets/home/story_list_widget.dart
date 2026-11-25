import 'package:flutter/material.dart';

class StoryListWidget extends StatelessWidget {
  final ValueChanged<String> onStoryTap;

  const StoryListWidget({super.key, required this.onStoryTap});

  final List<Map<String, dynamic>> stories = const [
    {'name': 'Your Story', 'color': Color(0xFFFFD464)},
    {'name': 'Garini', 'color': Color(0xFFFF5E5E)},
    {'name': 'Celine', 'color': Color(0xFFE23C64)},
    {'name': 'Felicia', 'color': Color(0xFFFFD464)},
    {'name': 'Frans', 'color': Color(0xFFB0183D)},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 105,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: stories.length,
        itemBuilder: (context, index) {
          final story = stories[index];
          final name = story['name'] as String;

          return Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () => onStoryTap(name),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFE23C64),
                        width: 2,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 27,
                      backgroundColor: story['color'] as Color,
                      child: Icon(
                        index == 0 ? Icons.add : Icons.person,
                        color: Colors.white,
                        size: 27,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF38252A),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
