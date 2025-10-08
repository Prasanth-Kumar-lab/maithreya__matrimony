// models/profile_model.dart

class ProfileModel {
  // Personal Info
  final String fullName;
  final String gender;
  final DateTime dob;
  final String religion;
  final String caste;
  final String maritalStatus;
  final String motherTongue;

  // Education & Career
  final String education;
  final String profession;
  final String income;

  // Location
  final String currentCity;
  final String country;
  final String nativePlace;

  // Family
  final String fatherOccupation;
  final String motherOccupation;
  final int brothers;
  final int sisters;

  // Lifestyle
  final String diet;
  final String smoking;
  final String drinking;
  final String hobbies;

  // Partner Preferences
  final String partnerAgeRange;
  final String partnerReligion;
  final String partnerEducation;
  final String partnerLocation;

  ProfileModel({
    required this.fullName,
    required this.gender,
    required this.dob,
    required this.religion,
    required this.caste,
    required this.maritalStatus,
    required this.motherTongue,
    required this.education,
    required this.profession,
    required this.income,
    required this.currentCity,
    required this.country,
    required this.nativePlace,
    required this.fatherOccupation,
    required this.motherOccupation,
    required this.brothers,
    required this.sisters,
    required this.diet,
    required this.smoking,
    required this.drinking,
    required this.hobbies,
    required this.partnerAgeRange,
    required this.partnerReligion,
    required this.partnerEducation,
    required this.partnerLocation,
  });
}
