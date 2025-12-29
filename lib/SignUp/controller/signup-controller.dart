import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:matrimony/LoginPage/view/loginpage_view.dart';
import 'dart:convert';

import 'package:matrimony/apiEndPoint.dart';

class SignupController extends GetxController {
  final GlobalKey<FormState> formKeyyy = GlobalKey<FormState>();

  // Text controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  // Observable fields
  var name = ''.obs;
  var username = ''.obs;
  var phone = ''.obs;
  var password = ''.obs;
  var confirmPassword = ''.obs;
  var agreeTerms = false.obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var obscurePassword = true.obs;
  var obscureConfirmPassword = true.obs;
  var address = ''.obs;


  @override
  void onInit() {
    super.onInit();
    nameController.addListener(() => name.value = nameController.text);
    usernameController.addListener(() => username.value = usernameController.text);
    phoneController.addListener(() => phone.value = phoneController.text);
    passwordController.addListener(() => password.value = passwordController.text);
    confirmPasswordController.addListener(() => confirmPassword.value = confirmPasswordController.text);
  }

  @override
  void onClose() {
    nameController.dispose();
    usernameController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() => obscurePassword.value = !obscurePassword.value;
  void toggleConfirmPasswordVisibility() => obscureConfirmPassword.value = !obscureConfirmPassword.value;
  void toggleTerms(bool? value) => agreeTerms.value = value ?? false;

  /// Parses DOB from text input and returns in YYYY-MM-DD format for API


  Future<void> signup() async {
    errorMessage.value = '';

    if (!agreeTerms.value) {
      errorMessage.value = 'Please agree to terms';
      return;
    }

    if (!formKeyyy.currentState!.validate()) return;

    if (password.value != confirmPassword.value) {
      errorMessage.value = 'Passwords do not match';
      return;
    }

    isLoading.value = true;

    try {
      final response = await http.post(
        Uri.parse(ApiEndPoint.signUpEndPoint),
        body: {
          'name': name.value,
          'number': phone.value,
          'username': username.value,
          'password': password.value,
        },
      );

      print('API Response: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'Success') {
          Get.offAll(()=>LoginView());
        } else {
          errorMessage.value = data['message'] ?? 'Signup failed';
        }
      } else {
        errorMessage.value = 'Server error';
      }
    } catch (e) {
      errorMessage.value = 'An error occurred';
      print('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void goToLogin() => Get.toNamed('/login');
}
