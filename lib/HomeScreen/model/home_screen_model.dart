/*
class UserProfiles {
  final String imagePath;
  final String name;
  final int age;
  final String location;

  UserProfiles({
    required this.imagePath,
    required this.name,
    required this.age,
    required this.location,
  });
}*/
class UserProfiles {
  final String userId;
  final String name;
  final int age;
  final String location;
  final String image;

  UserProfiles({
    required this.userId,
    required this.name,
    required this.age,
    required this.location,
    required this.image,
  });

  factory UserProfiles.fromJson(Map<String, dynamic> json) {
    return UserProfiles(
      userId: json['user_id'] ?? '',
      name: json['name'] ?? '',
      age: int.tryParse(json['age']?.toString() ?? '0') ?? 0,
      location: '${json['city'] ?? ''}, ${json['state_name'] ?? ''}',
      image: json['image'] ?? '',
    );
  }
}
