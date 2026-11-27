class OrganizationModel {
  final String id;
  final String name;
  final String category;
  final String description;
  final String vision;
  final String activities;
  final String location;
  final String image;
  final int members;
  final bool isJoined;

  const OrganizationModel({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.vision,
    required this.activities,
    required this.location,
    required this.image,
    this.members = 0,
    this.isJoined = false,
  });

  OrganizationModel copyWith({
    bool? isJoined,
    int? members,
  }) {
    return OrganizationModel(
      id: id,
      name: name,
      category: category,
      description: description,
      vision: vision,
      activities: activities,
      location: location,
      image: image,
      members: members ?? this.members,
      isJoined: isJoined ?? this.isJoined,
    );
  }
}
