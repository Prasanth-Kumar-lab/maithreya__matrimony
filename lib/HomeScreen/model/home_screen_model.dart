/*
class UserProfiles {
  final String userId;
  final String name;
  final int age;
  final String location;
  final String image;
  final List<String> photosList;
  final String number;
  final String deviceToken;
  final String gender;

  UserProfiles({
    required this.userId,
    required this.name,
    required this.age,
    required this.location,
    required this.image,
    required this.photosList,
    required this.number,
    required this.deviceToken,
    required this.gender,
  });

  factory UserProfiles.fromJson(Map<String, dynamic> json) {
    // Parse photos_list
    final List<String> photos = List<String>.from(json['photos_list'] ?? []);
    final String singleImage = json['image'] ?? '';
    if (singleImage.isNotEmpty && !photos.contains(singleImage)) {
      photos.insert(0, singleImage);
    }

    // device_tokens might be String or List — normalize to String
    String tokenValue = '';
    if (json['device_tokens'] != null) {
      if (json['device_tokens'] is List && (json['device_tokens'] as List).isNotEmpty) {
        tokenValue = (json['device_tokens'] as List).first.toString();
      } else if (json['device_tokens'] is String) {
        tokenValue = json['device_tokens'];
      }
    }

    return UserProfiles(
        userId: json['user_id'] ?? '',
        name: json['name'] ?? '',
        age: int.tryParse(json['age']?.toString() ?? '0') ?? 0,
        location: '${json['city'] ?? ''}, ${json['state_name'] ?? ''}',
        image: singleImage,
        photosList: photos,
        number: json['number'] ?? '',
        deviceToken: tokenValue,
        gender: json['gender'] ?? ''
    );
  }
}
*/
class UserProfiles {
  final String userId;
  final String name;
  final int age;
  final String location;
  final String image;
  final List<String> photosList;
  final String number;
  final String deviceToken;
  final String gender;
  final String profession;
  final String qualification;
  UserProfiles({
    required this.userId,
    required this.name,
    required this.age,
    required this.location,
    required this.image,
    required this.photosList,
    required this.number,
    required this.deviceToken,
    required this.gender,
    required this.profession,
    required this.qualification,
  });
  factory UserProfiles.fromJson(Map<String, dynamic> json) {
    // Parse photos_list
    final List<String> photos = List<String>.from(json['photos_list'] ?? []);
    final String singleImage = json['image'] ?? '';
    if (singleImage.isNotEmpty && !photos.contains(singleImage)) {
      photos.insert(0, singleImage);
    }
    // device_tokens might be String or List — normalize to String
    String tokenValue = '';
    if (json['device_token'] != null) {
      if (json['device_token'] is List && (json['device_token'] as List).isNotEmpty) {
        tokenValue = (json['device_token'] as List).first.toString();
      } else if (json['device_token'] is String) {
        tokenValue = json['device_token'];
      }
    }
    return UserProfiles(
      userId: json['user_id'] ?? '',
      name: json['name'] ?? '',
      age: int.tryParse(json['age']?.toString() ?? '0') ?? 0,
      location: '${json['city'] ?? ''}, ${json['state_name'] ?? ''}',
      image: singleImage,
      photosList: photos,
      number: json['number'] ?? '',
      deviceToken: tokenValue,
      gender: json['gender'] ?? '',
      profession: json['profession'] ?? '',
      qualification: json['education_details'] ?? '',
    );
  }
}