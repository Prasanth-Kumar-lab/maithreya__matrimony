/*
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:matrimony/SignUp/view/signup_view.dart';
import 'package:matrimony/apiEndPoint.dart';
import '../../First Registration Process/ProfilePage/controller/profile_controller.dart';
import '../../First Registration Process/ProfilePage/view/profile_view.dart';
import '../model/loginpage_model.dart';
import '../../HomeScreen/controller/home_screen_controller.dart';
import '../../HomeScreen/view/home_screen_view.dart';
import '../../UserProfile/model/userProfile_model.dart';
class LoginController extends GetxController {
  final LoginModel model = LoginModel();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  // TextEditingControllers
  final TextEditingController emailOrPhoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  // Observables
  var emailOrPhone = ''.obs;
  var password = ''.obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var obscurePassword = true.obs; // For password visibility toggle
  var selectedState = ''.obs;

  late HomeController _homeController;

  @override
  void onInit() {
    super.onInit();
    // Sync controllers with observables
    emailOrPhoneController.addListener(() {
      emailOrPhone.value = emailOrPhoneController.text;
    });
    passwordController.addListener(() {
      password.value = passwordController.text;
    });
    // Check for persistent login on initialization
    checkLoginStatus();
  }

  @override
  void onClose() {
    // Dispose controllers to prevent memory leaks
    emailOrPhoneController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void updateSelectedState(String value) {
    selectedState.value = value;
  }

  void updateEmailOrPhone(String value) {
    emailOrPhone.value = value;
  }

  void updatePassword(String value) {
    password.value = value;
  }

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  // Check persistent login status and navigate accordingly
  Future<void> checkLoginStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedUserId = prefs.getString('userId');
      final savedUserName = prefs.getString('userName');

      if (savedUserId != null && savedUserName != null) {
        // Fetch user profile to check completeness
        UserProfile? profile = await _homeController.fetchMyProfile(savedUserId);
        int initialStep = _determineInitialStep(profile);

        // Create and initialize ProfileController
        final controller = ProfileController(userId: savedUserId, userName: savedUserName);
        Get.put(controller);

        // Navigate based on profile completeness
        if (initialStep == 0) {
          // All fields are filled, go to HomeScreen
          Get.offAll(() => HomeScreen(userId: savedUserId));
        } else {
          // Some fields are missing, go to CompleteProfileScreen with initial step
          Get.offAll(() => CompleteProfileScreen(
            userId: savedUserId,
            userName: savedUserName,
            initialStep: initialStep, // Pass initial step
          ));
        }
      }
    } catch (e) {
      debugPrint('Error checking login status: $e');
      // If error, clear invalid saved data
      await clearLoginData();
    }
  }

  // Clear saved login data (call this on logout)
  Future<void> clearLoginData() async {
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
    if (profile.about == null || profile.about!.isEmpty) {
      return 7;
    }
    // All fields are filled
    return 0; // Indicates profile is complete
  }

  Future<void> login() async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;
      try {
        final uri = Uri.parse(ApiEndPoint.loginEndPoint);
        var request = http.MultipartRequest('POST', uri);
        request.fields['username'] = emailOrPhone.value;
        request.fields['password'] = password.value;

        final streamedResponse = await request.send();
        final response = await http.Response.fromStream(streamedResponse);

        debugPrint('Server Response Status: ${response.statusCode}');
        debugPrint('Server Response Body: ${response.body}');

        isLoading.value = false;

        if (response.statusCode == 200) {
          try {
            final data = jsonDecode(response.body);
            debugPrint('Parsed JSON: $data');

            if (data['status'] == 'Success' || data['success'] == true || data['status'] == '1') {
              final userId = data['data']['id'].toString();
              final userName = data['data']['name'];

              // Save login data locally
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('userId', userId);
              await prefs.setString('userName', userName);

              // Initialize HomeController dynamically with the logged-in userId
              _homeController = Get.put(HomeController(userId: userId));

              // Fetch profile
              UserProfile? profile = await _homeController.fetchMyProfile(userId);
              int initialStep = _determineInitialStep(profile);

              // Initialize ProfileController
              final controller = ProfileController(userId: userId, userName: userName);
              Get.put(controller);

              // Navigate based on profile completeness
              if (initialStep == 0) {
                Get.offAll(() => HomeScreen(userId: userId));
              } else {
                Get.offAll(() => CompleteProfileScreen(
                  userId: userId,
                  userName: userName,
                  initialStep: initialStep,
                ));
              }
            }
            else {
              errorMessage.value = data['message'] ?? 'Invalid credentials';
              debugPrint('Login failed: ${errorMessage.value}');
            }
          } catch (e) {
            errorMessage.value = 'Error parsing response: $e';
            debugPrint('JSON Parsing Error: $e');
          }
        } else {
          errorMessage.value = 'Server error: ${response.statusCode}';
          debugPrint('Server Error: ${response.statusCode}');
        }
      } catch (e) {
        isLoading.value = false;
        errorMessage.value = 'Network error: $e';
        debugPrint('Network Error during login: $e');
      }
    }
  }

  void goToSignup() {
    Get.to(() => SignupView());
  }

  void forgotPassword() {
    Get.toNamed('/forgot_password');
  }
}*/
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:matrimony/SignUp/view/signup_view.dart';
import 'package:matrimony/apiEndPoint.dart';
import '../../First Registration Process/ProfilePage/controller/profile_controller.dart';
import '../../First Registration Process/ProfilePage/view/profile_view.dart';
import '../model/loginpage_model.dart';
import '../../HomeScreen/controller/home_screen_controller.dart';
import '../../HomeScreen/view/home_screen_view.dart';
import '../../UserProfile/model/userProfile_model.dart';

class LoginController extends GetxController {
  final LoginModel model = LoginModel();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailOrPhoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  var emailOrPhone = ''.obs;
  var password = ''.obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var obscurePassword = true.obs;
  var obscureEmailOrPhone = false.obs;
  var selectedState = ''.obs;
  var rememberMe = false.obs;

  late HomeController _homeController;

  @override
  void onInit() {
    super.onInit();
    emailOrPhoneController.addListener(() {
      emailOrPhone.value = emailOrPhoneController.text;
    });
    passwordController.addListener(() {
      password.value = passwordController.text;
    });
    _loadSavedCredentials();
    checkLoginStatus();
  }

  @override
  void onClose() {
    emailOrPhoneController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  Future<void> _loadSavedCredentials() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedEmailOrPhone = prefs.getString('saved_email_or_phone');
      final savedPassword = prefs.getString('saved_password');
      final isRemembered = prefs.getBool('remember_me') ?? false;

      if (isRemembered && savedEmailOrPhone != null && savedPassword != null) {
        emailOrPhoneController.text = savedEmailOrPhone;
        passwordController.text = savedPassword;
        rememberMe.value = true;
        emailOrPhone.value = savedEmailOrPhone;
        password.value = savedPassword;
      }
    } catch (e) {
      debugPrint('Error loading saved credentials: $e');
    }
  }

  Future<void> _saveCredentials() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('saved_email_or_phone', emailOrPhoneController.text);
      await prefs.setString('saved_password', passwordController.text);
      await prefs.setBool('remember_me', rememberMe.value);
    } catch (e) {
      debugPrint('Error saving credentials: $e');
    }
  }

  void toggleRememberMe(bool value) {
    rememberMe.value = value;
  }

  void toggleEmailOrPhoneVisibility() {
    obscureEmailOrPhone.value = !obscureEmailOrPhone.value;
  }

  void updateSelectedState(String value) {
    selectedState.value = value;
  }

  void updateEmailOrPhone(String value) {
    emailOrPhone.value = value;
  }

  void updatePassword(String value) {
    password.value = value;
  }

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  Future<void> checkLoginStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedUserId = prefs.getString('userId');
      final savedUserName = prefs.getString('userName');

      if (savedUserId != null && savedUserName != null) {

        if (!Get.isRegistered<HomeController>()) {
          Get.put(HomeController(userId: savedUserId));
        } else {
          final controller = Get.find<HomeController>();
          if (controller.currentUserId != savedUserId) {
            controller.currentUserId = savedUserId;
            controller.fetchUserProfiles();
          }
        }
        final homeController = Get.find<HomeController>();
        UserProfile? profile = await homeController.fetchMyProfile(savedUserId);
        int initialStep = _determineInitialStep(profile);
        final controller = ProfileController(userId: savedUserId, userName: savedUserName);
        Get.put(controller);
        if (initialStep == 0) {
          Get.offAll(() => HomeScreen(userId: savedUserId));
        } else {
          Get.offAll(() => CompleteProfileScreen(
            userId: savedUserId,
            userName: savedUserName,
            initialStep: initialStep,
          ));
        }
      }
    } catch (e) {
      debugPrint('Error checking login status: $e');

      await clearLoginData();
    }
  }

  Future<void> clearLoginData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    await prefs.remove('userName');
    // Also clear saved credentials if needed (e.g., on logout)
    await prefs.remove('saved_email_or_phone');
    await prefs.remove('saved_password');
    await prefs.remove('remember_me');
  }


  int _determineInitialStep(UserProfile? profile) {
    if (profile == null) return 1;


    if (profile.name == null || profile.name!.isEmpty ||
        profile.dateOfBirth == null || profile.dateOfBirth!.isEmpty ||
        profile.gender == null || profile.gender!.isEmpty ||
        profile.age == null || profile.age!.isEmpty ||
        profile.image == null || profile.image!.isEmpty) {
      return 1;
    }

    if (profile.nativePlace == null || profile.nativePlace!.isEmpty ||
        profile.stateName == null || profile.stateName!.isEmpty ||
        profile.city == null || profile.city!.isEmpty ||
        profile.address == null || profile.address!.isEmpty) {
      return 2;
    }

    if (profile.maritalStatus == null || profile.maritalStatus!.isEmpty ||
        profile.height == null || profile.height!.isEmpty ||
        profile.educationDetails == null || profile.educationDetails!.isEmpty ||
        profile.foodType == null || profile.foodType!.isEmpty) {
      return 3;
    }

    if (profile.income == null || profile.income!.isEmpty ||
        profile.profession == null || profile.profession!.isEmpty ||
        profile.organization == null || profile.organization!.isEmpty ||
        profile.role == null || profile.role!.isEmpty) {
      return 4;
    }
    if (profile.zodiacSign == null || profile.zodiacSign!.isEmpty) {
      return 5;
    }
    if (profile.motherName == null || profile.motherName!.isEmpty ||
        profile.fatherName == null || profile.fatherName!.isEmpty ||
        profile.birthTime == null || profile.birthTime!.isEmpty ||
        profile.noOfSisters == null || profile.noOfSisters!.isEmpty ||
        profile.noOfBrothers == null || profile.noOfBrothers!.isEmpty) {
      return 6;
    }

    if (profile.hobbies == null || profile.hobbies!.isEmpty ||
        profile.favouriteMovies == null || profile.favouriteMovies!.isEmpty ||
        profile.favouriteBooks == null || profile.favouriteBooks!.isEmpty ||
        profile.otherInterests == null || profile.otherInterests!.isEmpty) {
      return 7;
    }

    if (profile.about == null || profile.about!.isEmpty) {
      return 8;
    }

    return 0;
  }

  Future<void> login() async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;
      try {
        final uri = Uri.parse(ApiEndPoint.loginEndPoint);
        var request = http.MultipartRequest('POST', uri);
        request.fields['username'] = emailOrPhone.value;
        request.fields['password'] = password.value;

        final streamedResponse = await request.send();
        final response = await http.Response.fromStream(streamedResponse);

        debugPrint('Server Response Status: ${response.statusCode}');
        debugPrint('Server Response Body: ${response.body}');

        isLoading.value = false;

        if (response.statusCode == 200) {
          try {
            final data = jsonDecode(response.body);
            debugPrint('Parsed JSON: $data');

            if (data['status'] == 'Success' || data['success'] == true || data['status'] == '1') {
              final userId = data['data']['id'].toString();
              final userName = data['data']['name'];


              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('userId', userId);
              await prefs.setString('userName', userName);

              if (rememberMe.value) {
                await _saveCredentials();
              }

              _homeController = Get.put(HomeController(userId: userId));

              UserProfile? profile = await _homeController.fetchMyProfile(userId);
              int initialStep = _determineInitialStep(profile);

              final controller = ProfileController(userId: userId, userName: userName);
              Get.put(controller);

              if (initialStep == 0) {
                Get.offAll(() => HomeScreen(userId: userId));
              } else {
                Get.offAll(() => CompleteProfileScreen(
                  userId: userId,
                  userName: userName,
                  initialStep: initialStep,
                ));
              }
            }
            else {
              errorMessage.value = data['message'] ?? 'Invalid credentials';
              debugPrint('Login failed: ${errorMessage.value}');
            }
          } catch (e) {
            errorMessage.value = 'Error parsing response: $e';
            debugPrint('JSON Parsing Error: $e');
          }
        } else {
          errorMessage.value = 'Server error: ${response.statusCode}';
          debugPrint('Server Error: ${response.statusCode}');
        }
      } catch (e) {
        isLoading.value = false;
        errorMessage.value = 'Network error: $e';
        debugPrint('Network Error during login: $e');
      }
    }
  }

  void goToSignup() {
    Get.to(() => SignupView());
  }

  void forgotPassword() {
    Get.toNamed('/forgot_password');
  }
}