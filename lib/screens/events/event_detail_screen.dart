import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../models/event_model.dart';

class EventDetailScreen extends StatefulWidget {
  final EventModel event;
  final VoidCallback onJoin;

  const EventDetailScreen({
    super.key,
    required this.event,
    required this.onJoin,
  });

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  late bool isJoined;

  @override
  void initState() {
    super.initState();
    isJoined = widget.event.isJoined;
  }

  void _handleJoin() {
    widget.onJoin();

    setState(() {
      isJoined = !isJoined;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isJoined
              ? 'You joined ${widget.event.title}!'
              : 'You left ${widget.event.title}.',
        ),
        backgroundColor: AppColors.success,
      ),
    );

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final event = widget.event;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.burgundy,
        elevation: 0,
        title: const Text(
          'Event Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 210,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.cream,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.event_available_rounded,
                size: 85,
                color: AppColors.burgundy,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              event.category,
              style: const TextStyle(
                color: AppColors.pink,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              event.title,
              style: const TextStyle(
                color: AppColors.burgundy,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            const SizedBox(height: 20),
            _detailRow(Icons.calendar_today_rounded, event.date),
            _detailRow(Icons.access_time_rounded, event.time),
            _detailRow(Icons.location_on_outlined, event.location),
            _detailRow(Icons.groups_outlined, event.organizer),
            _detailRow(
              Icons.people_outline_rounded,
              '${event.participants} participants',
            ),
            const SizedBox(height: 24),
            const Text(
              'About This Event',
              style: TextStyle(
                color: AppColors.textDark,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              event.description,
              style: const TextStyle(
                color: AppColors.textSecondary,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _handleJoin,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isJoined ? AppColors.textSecondary : AppColors.pink,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  isJoined ? 'Leave Event' : 'Join Event',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.pink, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: AppColors.textDark,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
