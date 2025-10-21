import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class ProfileModel {
  String userId;
  String? firstName;
  String? lastName;
  String? dob;
  String? gender;
  int? age;
  String? profileImage;
  String? nativePlace;
  String? state;
  String? city;
  String? maritalStatus;
  String? height;
  String? educationalDetails;
  String? vegNonVeg;
  String? annualIncome;
  String? profession;
  String? workingOrganization;
  String? role;
  String? motherName;
  String? fatherName;
  String? birthTime;
  int? noOfSisters;
  int? noOfBrothers;
  String? hobbies;
  String? favouriteMovies;
  String? favouriteBooks;
  String? otherInterests;
  String? aboutYourself;

  ProfileModel({
    required this.userId,
    this.firstName,
    this.lastName,
    this.dob,
    this.gender,
    this.age,
    this.profileImage,
    this.nativePlace,
    this.state,
    this.city,
    this.maritalStatus,
    this.height,
    this.educationalDetails,
    this.vegNonVeg,
    this.annualIncome,
    this.profession,
    this.workingOrganization,
    this.role,
    this.motherName,
    this.fatherName,
    this.birthTime,
    this.noOfSisters,
    this.noOfBrothers,
    this.hobbies,
    this.favouriteMovies,
    this.favouriteBooks,
    this.otherInterests,
    this.aboutYourself,
  });
}

