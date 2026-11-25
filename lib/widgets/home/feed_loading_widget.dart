import 'package:flutter/material.dart';

class FeedLoadingWidget extends StatelessWidget {
  const FeedLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(30),
      child: Center(
        child: Column(
          children: [
            CircularProgressIndicator(color: Color(0xFFE23C64)),
            SizedBox(height: 12),
            Text(
              'Loading your feed...',
              style: TextStyle(color: Color(0xFF8B7479), fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
