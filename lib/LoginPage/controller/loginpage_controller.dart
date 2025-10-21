/*
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import 'package:matrimony/SignUp/view/signup_view.dart';
import '../../First Registration Process/AboutYourSelf/view/about_your_self_view.dart';
import '../../First Registration Process/ProfilePage/controller/profile_controller.dart';
import '../../First Registration Process/ProfilePage/view/profile_view.dart';
import '../model/loginpage_model.dart';

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
  }

  @override
  void onClose() {
    // Dispose controllers to prevent memory leaks
    emailOrPhoneController.dispose();
    passwordController.dispose();
    super.onClose();
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

  Future<void> login() async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;
      try {
        final uri = Uri.parse('https://maithreyamatrimony.com/ckr_associates/_api_v1/login_api.php');
        var request = http.MultipartRequest('POST', uri);
        request.fields['username'] = emailOrPhone.value;
        request.fields['password'] = password.value;

        final streamedResponse = await request.send();
        final response = await http.Response.fromStream(streamedResponse);

        // Log the server response to the console
        debugPrint('Server Response Status: ${response.statusCode}');
        debugPrint('Server Response Body: ${response.body}');

        isLoading.value = false;

        if (response.statusCode == 200) {
          try {
            final data = jsonDecode(response.body);
            // Log the parsed JSON for debugging
            debugPrint('Parsed JSON: $data');

            // Check for success condition
            if (data['status'] == 'Success' || data['success'] == true || data['status'] == '1') {
              debugPrint('Login successful');
              // Extract id, name, gender, and date_of_birth from the response
              final userId = data['data']['id'].toString();
              final userName = data['data']['name'];
              final gender = data['data']['gender'];
              final dateOfBirth = data['data']['date_of_birth'];

              // Create and initialize ProfileController
              final controller = ProfileController(userId: userId, userName: userName);

              Get.put(controller); // Put controller in GetX dependency injection
              Get.to(() => ProfileDetails(
                userId: userId,
                userName: userName,
              ));
            } else {
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
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import 'package:matrimony/SignUp/view/signup_view.dart';
import '../../First Registration Process/AboutYourSelf/view/about_your_self_view.dart';
import '../../First Registration Process/ProfilePage/controller/profile_controller.dart';
import '../../First Registration Process/ProfilePage/view/profile_view.dart';
import '../model/loginpage_model.dart';
import 'package:matrimony/HomeScreen/view/home_screen_view.dart';
import 'package:matrimony/HomeScreen/controller/home_screen_controller.dart';

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
  }

  @override
  void onClose() {
    // Dispose controllers to prevent memory leaks
    emailOrPhoneController.dispose();
    passwordController.dispose();
    super.onClose();
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

  Future<void> login() async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;
      try {
        final uri = Uri.parse('https://maithreyamatrimony.com/ckr_associates/_api_v1/login_api.php');
        var request = http.MultipartRequest('POST', uri);
        request.fields['username'] = emailOrPhone.value;
        request.fields['password'] = password.value;

        final streamedResponse = await request.send();
        final response = await http.Response.fromStream(streamedResponse);

        // Log the server response to the console
        debugPrint('Server Response Status: ${response.statusCode}');
        debugPrint('Server Response Body: ${response.body}');

        isLoading.value = false;

        if (response.statusCode == 200) {
          try {
            final data = jsonDecode(response.body);
            // Log the parsed JSON for debugging
            debugPrint('Parsed JSON: $data');

            // Check for success condition
            if (data['status'] == 'Success' || data['success'] == true || data['status'] == '1') {
              debugPrint('Login successful');
              // Extract id from the response
              final userId = data['data']['id'].toString();

              // Set the current user id in HomeController
              Get.find<HomeController>().currentUserId = userId;

              Get.offAll(() => HomeScreen(userId: userId));
            } else {
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