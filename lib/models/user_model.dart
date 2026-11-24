class UserModel {
  final String id;
  final String fullName;
  final String nim;
  final String email;
  final String faculty;
  final String studyProgram;
  final String entryYear;
  final String avatar;
  final bool isVerified;

  const UserModel({
    required this.id,
    required this.fullName,
    required this.nim,
    required this.email,
    required this.faculty,
    required this.studyProgram,
    required this.entryYear,
    required this.avatar,
    this.isVerified = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'nim': nim,
      'email': email,
      'faculty': faculty,
      'studyProgram': studyProgram,
      'entryYear': entryYear,
      'avatar': avatar,
      'isVerified': isVerified,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      nim: json['nim'] as String,
      email: json['email'] as String,
      faculty: json['faculty'] as String,
      studyProgram: json['studyProgram'] as String,
      entryYear: json['entryYear'] as String,
      avatar: json['avatar'] as String,
      isVerified: json['isVerified'] as bool? ?? false,
    );
  }
}
