import 'event_model.dart';

class EventData {
  EventData._();

  static const List<EventModel> events = [
    EventModel(
      id: 'event_001',
      title: 'UNTAR Techno Festival',
      category: 'Technology',
      description:
          'A campus technology festival featuring workshops, technology exhibitions, competitions, and networking sessions for students.',
      date: '2026-12-05',
      time: '09:00 - 16:00',
      location: 'Universitas Tarumanagara, Jakarta',
      organizer: 'Student Technology Community',
      image: '',
      participants: 120,
    ),
    EventModel(
      id: 'event_002',
      title: 'Creative Design Workshop',
      category: 'Workshop',
      description:
          'Learn the fundamentals of creative design, visual communication, and digital design with fellow students.',
      date: '2026-12-08',
      time: '10:00 - 13:00',
      location: 'Building M, Universitas Tarumanagara',
      organizer: 'Design Student Community',
      image: '',
      participants: 45,
    ),
    EventModel(
      id: 'event_003',
      title: 'Campus Music Night',
      category: 'Entertainment',
      description:
          'Enjoy a night of music, performances, and student creativity in a friendly campus atmosphere.',
      date: '2026-12-12',
      time: '18:00 - 21:00',
      location: 'Campus Main Hall',
      organizer: 'Student Activity Unit',
      image: '',
      participants: 200,
    ),
    EventModel(
      id: 'event_004',
      title: 'AI & Future Technology Seminar',
      category: 'Seminar',
      description:
          'Explore artificial intelligence trends, career opportunities, and the future of technology.',
      date: '2026-12-15',
      time: '09:00 - 12:00',
      location: 'Auditorium, Universitas Tarumanagara',
      organizer: 'Informatics Student Community',
      image: '',
      participants: 85,
    ),
    EventModel(
      id: 'event_005',
      title: 'Student Sports Competition',
      category: 'Sports',
      description:
          'Join an exciting student sports competition and meet new friends from different faculties.',
      date: '2026-12-19',
      time: '08:00 - 15:00',
      location: 'Universitas Tarumanagara Sports Area',
      organizer: 'Campus Sports Community',
      image: '',
      participants: 75,
    ),
  ];
}
