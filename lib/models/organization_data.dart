import 'organization_model.dart';

class OrganizationData {
  OrganizationData._();

  static const List<OrganizationModel> organizations = [
    OrganizationModel(
      id: 'org_001',
      name: 'BEM Fakultas Teknologi Informasi',
      category: 'Student Government',
      description:
          'Student government organization that represents students and supports student activities within the faculty.',
      vision:
          'Building an active, collaborative, and supportive student community.',
      activities:
          'Student programs, leadership development, campus events, and student advocacy.',
      location: 'Universitas Tarumanagara',
      image: '',
      members: 85,
    ),
    OrganizationModel(
      id: 'org_002',
      name: 'Himpunan Mahasiswa Informatika',
      category: 'Academic',
      description:
          'A student association for Informatics students to develop academic skills and build connections.',
      vision:
          'Creating a collaborative and innovative Informatics student community.',
      activities:
          'Programming workshops, coding competitions, study groups, and seminars.',
      location: 'Faculty of Information Technology',
      image: '',
      members: 120,
    ),
    OrganizationModel(
      id: 'org_003',
      name: 'UNTAR Photography Club',
      category: 'Creative',
      description:
          'A creative community for students interested in photography and visual storytelling.',
      vision:
          'Developing creativity and visual communication through photography.',
      activities:
          'Photo walks, photography workshops, exhibitions, and creative projects.',
      location: 'Universitas Tarumanagara',
      image: '',
      members: 42,
    ),
    OrganizationModel(
      id: 'org_004',
      name: 'UNTAR Basketball Community',
      category: 'Sports',
      description:
          'A student sports community that brings basketball enthusiasts together.',
      vision:
          'Building teamwork, sportsmanship, and a healthy student lifestyle.',
      activities:
          'Weekly practice, friendly matches, tournaments, and sports events.',
      location: 'Universitas Tarumanagara Sports Area',
      image: '',
      members: 60,
    ),
    OrganizationModel(
      id: 'org_005',
      name: 'UNTAR English Club',
      category: 'Language',
      description:
          'A community for students who want to improve their English communication skills.',
      vision:
          'Encouraging confidence and effective communication in English.',
      activities:
          'English discussions, speaking sessions, language games, and workshops.',
      location: 'Universitas Tarumanagara',
      image: '',
      members: 55,
    ),
  ];
}
