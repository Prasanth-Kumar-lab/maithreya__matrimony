// controllers/profile_controller.dart

import '../model/profile_model.dart';
class ProfileController {
  late ProfileModel profile;

  ProfileController() {
    // Dummy data for UI demo
    profile = ProfileModel(
      fullName: "Rohit Sharma",
      gender: "Male",
      dob: DateTime(1995, 8, 20),
      religion: "Hindu",
      caste: "Brahmin",
      maritalStatus: "Never Married",
      motherTongue: "Hindi",
      education: "MBA",
      profession: "Software Engineer",
      income: "₹12 LPA",
      currentCity: "Bangalore",
      country: "India",
      nativePlace: "Uttar Pradesh",
      fatherOccupation: "Businessman",
      motherOccupation: "Homemaker",
      brothers: 1,
      sisters: 0,
      diet: "Vegetarian",
      smoking: "No",
      drinking: "No",
      hobbies: "Reading, Traveling, Music",
      partnerAgeRange: "25 - 30",
      partnerReligion: "Hindu",
      partnerEducation: "Graduate and above",
      partnerLocation: "Any metro city in India",
    );
  }
}
