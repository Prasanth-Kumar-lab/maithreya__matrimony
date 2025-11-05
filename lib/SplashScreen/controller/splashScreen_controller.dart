/*
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:matrimony/HomeScreen/controller/home_screen_controller.dart';
import '../../First Registration Process/ProfilePage/controller/profile_controller.dart';
import '../../First Registration Process/ProfilePage/view/profile_view.dart';
import '../../UserProfile/model/userProfile_model.dart';
import '../model/splashScreen_model.dart';
// Assuming CompleteProfileScreen import; add if needed
// import '../../First Registration Process/ProfilePage/view/complete_profile_view.dart'; // Adjust path as per your structure

class SplashController extends GetxController {
  final SplashModel model = SplashModel();
  var opacity = 0.0.obs;

  final HomeController _homeController = Get.find<HomeController>();

  @override
  void onInit() {
    super.onInit();
    // Start fade-in animation
    Future.delayed(Duration(milliseconds: 500), () {
      opacity.value = 1.0;
    });
    // Check login status and navigate after 3 seconds (reduced from 5 for better UX, but can adjust)
    Future.delayed(Duration(seconds: 3), () {
      _checkAndNavigate();
    });
  }

  // Check persistent login status and navigate accordingly
  Future<void> _checkAndNavigate() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedUserId = prefs.getString('userId');
      final savedUserName = prefs.getString('userName');

      if (savedUserId != null && savedUserName != null) {
        // Set currentUserId in HomeController
        _homeController.currentUserId = savedUserId; // Assuming HomeController has RxString currentUserId

        // Fetch user profile to check completeness
        UserProfile? profile = await _homeController.fetchMyProfile(savedUserId);
        int initialStep = _determineInitialStep(profile);

        // Create and initialize ProfileController
        final controller = ProfileController(userId: savedUserId, userName: savedUserName);
        Get.put(controller);

        // Navigate based on profile completeness
        if (initialStep == 0) {
          // All fields are filled, go to HomeScreen
          Get.offAllNamed('/home');
        } else {
          // Some fields are missing, go to CompleteProfileScreen with initial step
          // Note: Add this route to getPages in main.dart if not present:
          // GetPage(name: '/complete_profile', page: () => CompleteProfileScreen(
          //   userId: savedUserId,
          //   userName: savedUserName,
          //   initialStep: initialStep,
          // )),
          Get.offAll(() => CompleteProfileScreen( // Use unnamed if route not set
            userId: savedUserId,
            userName: savedUserName,
            initialStep: initialStep,
          ));
        }
      } else {
        // No saved login, go to onboarding
        Get.offNamed('/onboarding');
      }
    } catch (e) {
      debugPrint('Error checking login status: $e');
      // If error, clear invalid saved data and go to onboarding
      await _clearLoginData();
      Get.offNamed('/onboarding');
    }
  }

  // Clear saved login data (call this on logout)
  Future<void> _clearLoginData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    await prefs.remove('userName');
  }

  // Check if all required profile fields are filled (copied from LoginController)
  int _determineInitialStep(UserProfile? profile) {
    if (profile == null) return 1; // Default to step 1 if profile is null

    // Step 1: Profile
    if (profile.name == null || profile.name!.isEmpty ||
        profile.dateOfBirth == null || profile.dateOfBirth!.isEmpty ||
        profile.gender == null || profile.gender!.isEmpty ||
        profile.age == null || profile.age!.isEmpty ||
        profile.image == null || profile.image!.isEmpty) {
      return 1;
    }
    // Step 2: Location
    if (profile.nativePlace == null || profile.nativePlace!.isEmpty ||
        profile.stateName == null || profile.stateName!.isEmpty ||
        profile.city == null || profile.city!.isEmpty ||
        profile.address == null || profile.address!.isEmpty) {
      return 2;
    }
    // Step 3: Marital
    if (profile.maritalStatus == null || profile.maritalStatus!.isEmpty ||
        profile.height == null || profile.height!.isEmpty ||
        profile.educationDetails == null || profile.educationDetails!.isEmpty ||
        profile.foodType == null || profile.foodType!.isEmpty) {
      return 3;
    }
    // Step 4: Professional
    if (profile.income == null || profile.income!.isEmpty ||
        profile.profession == null || profile.profession!.isEmpty ||
        profile.organization == null || profile.organization!.isEmpty ||
        profile.role == null || profile.role!.isEmpty) {
      return 4;
    }
    // Step 5: Family
    if (profile.motherName == null || profile.motherName!.isEmpty ||
        profile.fatherName == null || profile.fatherName!.isEmpty ||
        profile.birthTime == null || profile.birthTime!.isEmpty ||
        profile.noOfSisters == null || profile.noOfSisters!.isEmpty ||
        profile.noOfBrothers == null || profile.noOfBrothers!.isEmpty) {
      return 5;
    }
    // Step 6: Lifestyle
    if (profile.hobbies == null || profile.hobbies!.isEmpty ||
        profile.favouriteMovies == null || profile.favouriteMovies!.isEmpty ||
        profile.favouriteBooks == null || profile.favouriteBooks!.isEmpty ||
        profile.otherInterests == null || profile.otherInterests!.isEmpty) {
      return 6;
    }
    // Step 7: About
    if (profile.about == null || profile.about!.isEmpty) {
      return 7;
    }
    // All fields are filled
    return 0; // Indicates profile is complete
  }
}*/
/*
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:matrimony/HomeScreen/controller/home_screen_controller.dart';
import '../../First Registration Process/ProfilePage/controller/profile_controller.dart';
import '../../First Registration Process/ProfilePage/view/profile_view.dart';
import '../../UserProfile/model/userProfile_model.dart';
import '../model/splashScreen_model.dart';

class SplashController extends GetxController {
  final SplashModel model = SplashModel();
  var opacity = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    // Start fade-in animation
    Future.delayed(Duration(milliseconds: 500), () {
      opacity.value = 1.0;
    });
    // Check login status and navigate after 3 seconds
    Future.delayed(Duration(seconds: 3), () {
      _checkAndNavigate();
    });
  }

  // Check persistent login status and navigate accordingly
  Future<void> _checkAndNavigate() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedUserId = prefs.getString('userId');
      final savedUserName = prefs.getString('userName');

      if (savedUserId != null && savedUserName != null) {
        // Initialize HomeController with savedUserId
        if (!Get.isRegistered<HomeController>()) {
          Get.put(HomeController(userId: savedUserId));
        } else {
          final controller = Get.find<HomeController>();
          if (controller.currentUserId != savedUserId) {
            controller.currentUserId = savedUserId;
            controller.fetchUserProfiles(); // Refresh profiles
          }
        }
        final homeController = Get.find<HomeController>();

        // Fetch user profile to check completeness
        UserProfile? profile = await homeController.fetchMyProfile(savedUserId);
        int initialStep = _determineInitialStep(profile);

        // Create and initialize ProfileController
        final controller = ProfileController(userId: savedUserId, userName: savedUserName);
        Get.put(controller);

        // Navigate based on profile completeness
        if (initialStep == 0) {
          // All fields are filled, go to HomeScreen
          Get.offAllNamed('/home', arguments: {'userId': savedUserId});
        } else {
          // Some fields are missing, go to CompleteProfileScreen
          Get.offAllNamed('/complete_profile', arguments: {
            'userId': savedUserId,
            'userName': savedUserName,
            'initialStep': initialStep,
          });
        }
      } else {
        // No saved login, go to onboarding
        Get.offNamed('/onboarding');
      }
    } catch (e) {
      debugPrint('Error checking login status: $e');
      // If error, clear invalid saved data and go to onboarding
      await _clearLoginData();
      Get.offNamed('/onboarding');
    }
  }

  // Clear saved login data (call this on logout)
  Future<void> _clearLoginData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    await prefs.remove('userName');
  }

  // Check if all required profile fields are filled
  int _determineInitialStep(UserProfile? profile) {
    if (profile == null) return 1; // Default to step 1 if profile is null

    // Step 1: Profile
    if (profile.name == null || profile.name!.isEmpty ||
        profile.dateOfBirth == null || profile.dateOfBirth!.isEmpty ||
        profile.gender == null || profile.gender!.isEmpty ||
        profile.age == null || profile.age!.isEmpty ||
        profile.image == null || profile.image!.isEmpty) {
      return 1;
    }
    // Step 2: Location
    if (profile.nativePlace == null || profile.nativePlace!.isEmpty ||
        profile.stateName == null || profile.stateName!.isEmpty ||
        profile.city == null || profile.city!.isEmpty ||
        profile.address == null || profile.address!.isEmpty) {
      return 2;
    }
    // Step 3: Marital
    if (profile.maritalStatus == null || profile.maritalStatus!.isEmpty ||
        profile.height == null || profile.height!.isEmpty ||
        profile.educationDetails == null || profile.educationDetails!.isEmpty ||
        profile.foodType == null || profile.foodType!.isEmpty) {
      return 3;
    }
    // Step 4: Professional
    if (profile.income == null || profile.income!.isEmpty ||
        profile.profession == null || profile.profession!.isEmpty ||
        profile.organization == null || profile.organization!.isEmpty ||
        profile.role == null || profile.role!.isEmpty) {
      return 4;
    }
    // Step 5: Family
    if (profile.motherName == null || profile.motherName!.isEmpty ||
        profile.fatherName == null || profile.fatherName!.isEmpty ||
        profile.birthTime == null || profile.birthTime!.isEmpty ||
        profile.noOfSisters == null || profile.noOfSisters!.isEmpty ||
        profile.noOfBrothers == null || profile.noOfBrothers!.isEmpty) {
      return 5;
    }
    // Step 6: Lifestyle
    if (profile.hobbies == null || profile.hobbies!.isEmpty ||
        profile.favouriteMovies == null || profile.favouriteMovies!.isEmpty ||
        profile.favouriteBooks == null || profile.favouriteBooks!.isEmpty ||
        profile.otherInterests == null || profile.otherInterests!.isEmpty) {
      return 6;
    }
    // Step 7: About
    if (profile.about == null || profile.about!.isEmpty||
        profile.photosList ==null || profile.photosList!.isEmpty
    ) {
      return 7;
    }
    // All fields are filled
    return 0; // Indicates profile is complete
  }
}*/
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:matrimony/HomeScreen/controller/home_screen_controller.dart';
import '../../First Registration Process/ProfilePage/controller/profile_controller.dart';
import '../../UserProfile/model/userProfile_model.dart';
import '../model/splashScreen_model.dart';

class SplashController extends GetxController {
  final SplashModel model = SplashModel();
  var opacity = 0.0.obs;

  // Audio player instance
  //final AudioPlayer _audioPlayer = AudioPlayer();
  late final AudioPlayer _audioPlayer;
  @override
  void onInit() {
    super.onInit();
    _audioPlayer = AudioPlayer();
    _playAudio();

    // Start fade-in animation
    Future.delayed(const Duration(milliseconds: 500), () {
      opacity.value = 1.0;
    });

    // Play splash audio once
    _playAudio();

    // Check login status and navigate after 3 seconds
    Future.delayed(const Duration(seconds: 5), () {
      _checkAndNavigate();
    });
  }

  /// Play the splash screen audio (once)
  void _playAudio() async {
    try {
      await _audioPlayer.play(AssetSource('music/bg_music.mp3'));
    } catch (e) {
      debugPrint('Error playing audio: $e');
    }
  }

  @override
  void onClose() {
    _audioPlayer.dispose(); // Dispose audio player when controller closes
    super.onClose();
  }

  /// Check persistent login status and navigate accordingly
  Future<void> _checkAndNavigate() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedUserId = prefs.getString('userId');
      final savedUserName = prefs.getString('userName');

      if (savedUserId != null && savedUserName != null) {
        // Initialize HomeController with savedUserId
        if (!Get.isRegistered<HomeController>()) {
          Get.put(HomeController(userId: savedUserId));
        } else {
          final controller = Get.find<HomeController>();
          if (controller.currentUserId != savedUserId) {
            controller.currentUserId = savedUserId;
            controller.fetchUserProfiles(); // Refresh profiles
          }
        }
        final homeController = Get.find<HomeController>();

        // Fetch user profile to check completeness
        UserProfile? profile = await homeController.fetchMyProfile(savedUserId);
        int initialStep = _determineInitialStep(profile);

        // Create and initialize ProfileController
        final profileController =
        ProfileController(userId: savedUserId, userName: savedUserName);
        Get.put(profileController);

        // Navigate based on profile completeness
        if (initialStep == 0) {
          // All fields are filled, go to HomeScreen
          Get.offAllNamed('/home', arguments: {'userId': savedUserId});
        } else {
          // Some fields are missing, go to CompleteProfileScreen
          Get.offAllNamed('/complete_profile', arguments: {
            'userId': savedUserId,
            'userName': savedUserName,
            'initialStep': initialStep,
          });
        }
      } else {
        // No saved login, go to onboarding
        Get.offNamed('/onboarding');
      }
    } catch (e) {
      debugPrint('Error checking login status: $e');
      // If error, clear invalid saved data and go to onboarding
      await _clearLoginData();
      //Get.offNamed('/onboarding');
      Get.offAllNamed('/login');
    }
  }
  Future<void> _clearLoginData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    await prefs.remove('userName');
  }
  int _determineInitialStep(UserProfile? profile) {
    if (profile == null) return 1; // Default to step 1 if profile is null

    // Step 1: Profile
    if (profile.name == null ||
        profile.name!.isEmpty ||
        profile.dateOfBirth == null ||
        profile.dateOfBirth!.isEmpty ||
        profile.gender == null ||
        profile.gender!.isEmpty ||
        profile.age == null ||
        profile.age!.isEmpty ||
        profile.image == null ||
        profile.image!.isEmpty) {
      return 1;
    }
    // Step 2: Location
    if (profile.nativePlace == null ||
        profile.nativePlace!.isEmpty ||
        profile.stateName == null ||
        profile.stateName!.isEmpty ||
        profile.city == null ||
        profile.city!.isEmpty ||
        profile.address == null ||
        profile.address!.isEmpty) {
      return 2;
    }
    // Step 3: Marital
    if (profile.maritalStatus == null ||
        profile.maritalStatus!.isEmpty ||
        profile.height == null ||
        profile.height!.isEmpty ||
        profile.educationDetails == null ||
        profile.educationDetails!.isEmpty ||
        profile.foodType == null ||
        profile.foodType!.isEmpty) {
      return 3;
    }
    // Step 4: Professional
    if (profile.income == null ||
        profile.income!.isEmpty ||
        profile.profession == null ||
        profile.profession!.isEmpty ||
        profile.organization == null ||
        profile.organization!.isEmpty ||
        profile.role == null ||
        profile.role!.isEmpty) {
      return 4;
    }
    if (profile.zodiacSign == null || profile.zodiacSign!.isEmpty) {
      return 5;
    }
    // Step 5: Family
    if (profile.motherName == null ||
        profile.motherName!.isEmpty ||
        profile.fatherName == null ||
        profile.fatherName!.isEmpty ||
        profile.birthTime == null ||
        profile.birthTime!.isEmpty ||
        profile.noOfSisters == null ||
        profile.noOfSisters!.isEmpty ||
        profile.noOfBrothers == null ||
        profile.noOfBrothers!.isEmpty) {
      return 6;
    }
    // Step 6: Lifestyle
    if (profile.hobbies == null ||
        profile.hobbies!.isEmpty ||
        profile.favouriteMovies == null ||
        profile.favouriteMovies!.isEmpty ||
        profile.favouriteBooks == null ||
        profile.favouriteBooks!.isEmpty ||
        profile.otherInterests == null ||
        profile.otherInterests!.isEmpty) {
      return 7;
    }
    // Step 7: About
    if (profile.about == null ||
        profile.about!.isEmpty ||
        profile.photosList == null ||
        profile.photosList!.isEmpty) {
      return 8;
    }
    // All fields are filled
    return 0; // Indicates profile is complete
  }
}
