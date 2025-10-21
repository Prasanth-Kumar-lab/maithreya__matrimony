/*
import 'package:flutter_swipecards/flutter_swipecards.dart';
import 'package:get/get.dart';
import 'package:matrimony/Messages/view/messages_view.dart';
import '../../MatchPage/view/match_page.dart';
import '../model/home_screen_model.dart';
import '../view/home_screen_view.dart';
class HomeController extends GetxController {
  final CardController cardController = CardController();
  var currentIndex = 0.obs; // Reactive current index

  final List<UserProfiles> users = [
    UserProfiles(
      imagePath: 'assets/anushka.jpg',
      name: 'Anushka',
      age: 26,
      location: 'Hyderabad, India',
    ),
    UserProfiles(
      imagePath: 'assets/Rashmika.jpg',
      name: 'Rashmika Mandana',
      age: 28,
      location: 'Mumbai, India',
    ),
    UserProfiles(
      imagePath: 'assets/srileela.jpg',
      name: 'Sri leela',
      age: 24,
      location: 'Bangalore, India',
    ),
    UserProfiles(
      imagePath: 'assets/kajal.jpg',
      name: 'Kaja Agarwal',
      age: 30,
      location: 'Delhi, India',
    ),
    UserProfiles(
      imagePath: 'assets/anushka.jpg',
      name: 'Anushka',
      age: 26,
      location: 'Hyderabad, India',
    ),
    UserProfiles(
      imagePath: 'assets/Rashmika.jpg',
      name: 'Rashmika Mandana',
      age: 28,
      location: 'Mumbai, India',
    ),
    UserProfiles(
      imagePath: 'assets/srileela.jpg',
      name: 'Sri leela',
      age: 24,
      location: 'Bangalore, India',
    ),
    UserProfiles(
      imagePath: 'assets/kajal.jpg',
      name: 'Kaja Agarwal',
      age: 30,
      location: 'Delhi, India',
    ),
    UserProfiles(
      imagePath: 'assets/anushka.jpg',
      name: 'Anushka',
      age: 26,
      location: 'Hyderabad, India',
    ),
    UserProfiles(
      imagePath: 'assets/Rashmika.jpg',
      name: 'Rashmika Mandana',
      age: 28,
      location: 'Mumbai, India',
    ),
    UserProfiles(
      imagePath: 'assets/srileela.jpg',
      name: 'Sri leela',
      age: 24,
      location: 'Bangalore, India',
    ),
    UserProfiles(
      imagePath: 'assets/kajal.jpg',
      name: 'Kaja Agarwal',
      age: 30,
      location: 'Delhi, India',
    ),
    UserProfiles(
      imagePath: 'assets/anushka.jpg',
      name: 'Anushka',
      age: 26,
      location: 'Hyderabad, India',
    ),
    UserProfiles(
      imagePath: 'assets/Rashmika.jpg',
      name: 'Rashmika Mandana',
      age: 28,
      location: 'Mumbai, India',
    ),
    UserProfiles(
      imagePath: 'assets/srileela.jpg',
      name: 'Sri leela',
      age: 24,
      location: 'Bangalore, India',
    ),
    UserProfiles(
      imagePath: 'assets/kajal.jpg',
      name: 'Kaja Agarwal',
      age: 30,
      location: 'Delhi, India',
    ),
  ];

  void setCurrentIndex(int index) {
    currentIndex.value = index;
    navigateToScreen(index);
  }

  void navigateToScreen(int index) {
    switch (index) {
      case 0:
      // If already on HomeScreen, pop to it if necessary
        if (Get.currentRoute != '/home') {
          Get.offAll(() => const HomeScreen());
        }
        break;
      case 1:
        Get.to(() => MatchesScreen(), preventDuplicates: true);
        break;
      case 2:
        Get.to(() => MessagesView(), preventDuplicates: true);
        break;
      case 3:
        Get.to(() => HomeScreen(), preventDuplicates: true);
        break;
      case 4:
        Get.to(() => HomeScreen(), preventDuplicates: true);
        break;
    }
  }

  void swipeLeft() {
    cardController.triggerLeft();
  }

  void swipeRight() {
    cardController.triggerRight();
  }

  void swipeUp() {
    cardController.triggerUp();
  }
}*/
import 'package:flutter_swipecards/flutter_swipecards.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:matrimony/Messages/view/messages_view.dart';
import 'package:matrimony/MatchPage/view/match_page.dart';
import 'package:matrimony/HomeScreen/view/home_screen_view.dart';
import 'package:matrimony/apiEndPoint.dart';
import '../../UserProfile/model/userProfile_model.dart';
import '../../UserProfile/view/user_profile_view.dart';
import '../model/home_screen_model.dart';

class HomeController extends GetxController {
  final CardController cardController = CardController();
  var currentIndex = 0.obs; // Reactive current index
  var users = <UserProfiles>[].obs; // Reactive list for users
  var isLoading = false.obs; // Loading state
  var errorMessage = ''.obs; // Error message state
  var userProfile = Rxn<UserProfiles>(); // Add this to the controller
  String currentUserId = '0';

  @override
  void onInit() {
    super.onInit();
    fetchUserProfiles(); // Fetch users when controller is initialized
  }

  Future<void> fetchUserProfiles() async {
    try {
      isLoading.value = true;
      final response = await http.get(
        Uri.parse(ApiEndPoint.listProfileApi),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        users.value = data.map((json) => UserProfiles.fromJson(json)).toList();
        errorMessage.value = '';
      } else {
        errorMessage.value = 'Failed to load users: ${response.statusCode}';
      }
    } catch (e) {
      errorMessage.value = 'Error fetching users: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<UserProfile?> fetchMyProfile(String userId) async {
    final response = await http.post(
      Uri.parse(ApiEndPoint.listProfileApi),
      body: {'user_id': userId},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      if (jsonList.isNotEmpty) {
        return UserProfile.fromJson(jsonList[0]); // Pick the first user only
      }
    }
    return null;
  }


  void setCurrentIndex(int index) {
    currentIndex.value = index;
    navigateToScreen(index);
  }

  void navigateToScreen(int index) {
    switch (index) {
      case 0:
        if (Get.currentRoute != '/home') {
          Get.offAll(() => HomeScreen(userId: currentUserId));
        }
        break;
      case 1:
        Get.to(() => MatchesScreen(), preventDuplicates: true);
        break;
      case 2:
        Get.to(() => MessagesView(), preventDuplicates: true);
        break;
      case 3:
        if (Get.context != null) {
          fetchMyProfile(currentUserId).then((user) {
            if (user != null) {
              Get.to(() => MyProfileScreen(user: user));
            }
          });
        }
        break;


      case 4:
        Get.to(() => HomeScreen(userId: currentUserId), preventDuplicates: true);
        break;
    }
  }

  void swipeLeft() {
    cardController.triggerLeft();
  }

  void swipeRight() {
    cardController.triggerRight();
  }

  void swipeUp() {
    cardController.triggerUp();
  }
}