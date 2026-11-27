import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../models/event_data.dart';
import '../../models/event_model.dart';
import '../../widgets/events/event_card_widget.dart';
import '../../widgets/events/event_category_widget.dart';
import '../../widgets/events/event_empty_widget.dart';
import '../../widgets/events/event_search_widget.dart';
import 'event_detail_screen.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  String searchQuery = '';
  String selectedCategory = 'All';

  final List<String> categories = const [
    'All',
    'Technology',
    'Workshop',
    'Entertainment',
    'Seminar',
    'Sports',
  ];

  late List<EventModel> events;

  @override
  void initState() {
    super.initState();
    events = List<EventModel>.from(EventData.events);
  }

  List<EventModel> get filteredEvents {
    return events.where((event) {
      final matchesCategory = selectedCategory == 'All' ||
          event.category == selectedCategory;

      final query = searchQuery.toLowerCase();

      final matchesSearch = event.title.toLowerCase().contains(query) ||
          event.category.toLowerCase().contains(query) ||
          event.location.toLowerCase().contains(query);

      return matchesCategory && matchesSearch;
    }).toList();
  }

  void _toggleJoin(EventModel event) {
    setState(() {
      final index = events.indexWhere((item) => item.id == event.id);

      if (index == -1) return;

      final current = events[index];
      final joining = !current.isJoined;

      events[index] = current.copyWith(
        isJoined: joining,
        participants: current.participants + (joining ? 1 : -1),
      );
    });
  }

  Future<void> _openEvent(EventModel event) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => EventDetailScreen(
          event: event,
          onJoin: () => _toggleJoin(event),
        ),
      ),
    );

    if (result == true && mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final results = filteredEvents;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Campus Events',
                    style: TextStyle(
                      color: AppColors.burgundy,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Discover activities and events around campus!',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 18),
                  EventSearchWidget(
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  EventCategoryWidget(
                    categories: categories,
                    selectedCategory: selectedCategory,
                    onSelected: (value) {
                      setState(() {
                        selectedCategory = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Upcoming Events (${results.length})',
                style: const TextStyle(
                  color: AppColors.textDark,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: results.isEmpty
                  ? const EventEmptyWidget()
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      itemCount: results.length,
                      itemBuilder: (context, index) {
                        final event = results[index];

                        return EventCardWidget(
                          event: event,
                          onTap: () => _openEvent(event),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
