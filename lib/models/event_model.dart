class EventModel {
  final String id;
  final String title;
  final String category;
  final String description;
  final String date;
  final String time;
  final String location;
  final String organizer;
  final String image;
  final int participants;
  final bool isJoined;

  const EventModel({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.date,
    required this.time,
    required this.location,
    required this.organizer,
    required this.image,
    this.participants = 0,
    this.isJoined = false,
  });

  EventModel copyWith({
    bool? isJoined,
    int? participants,
  }) {
    return EventModel(
      id: id,
      title: title,
      category: category,
      description: description,
      date: date,
      time: time,
      location: location,
      organizer: organizer,
      image: image,
      participants: participants ?? this.participants,
      isJoined: isJoined ?? this.isJoined,
    );
  }
}
