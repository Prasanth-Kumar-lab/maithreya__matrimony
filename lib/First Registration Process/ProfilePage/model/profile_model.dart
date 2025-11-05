class ProfileModel {
  String userId;
  String? firstName;
  String? dob;
  String? gender;
  int? age;

  ProfileModel({
    required this.userId,
    this.firstName,
    this.dob,
    this.gender,
    this.age,

  });
}
class LocationModel {
  String nativePlace;
  String state;
  String city;

  LocationModel({
    required this.nativePlace,
    required this.state,
    required this.city,
  });
}
// File: lib/models/marital_details_model.dart
class MaritalDetailsModel {
  String maritalStatus = '';
  String height = '';
  String educationalDetails = '';
  String foodType = '';

  MaritalDetailsModel({
    this.maritalStatus = '',
    this.height = '',
    this.educationalDetails = '',
    this.foodType = '',
  });

  // Optional: Method to copy with updates
  MaritalDetailsModel copyWith({
    String? maritalStatus,
    String? height,
    String? educationalDetails,
    String? foodType,
  }) {
    return MaritalDetailsModel(
      maritalStatus: maritalStatus ?? this.maritalStatus,
      height: height ?? this.height,
      educationalDetails: educationalDetails ?? this.educationalDetails,
      foodType: foodType ?? this.foodType,
    );
  }
}
