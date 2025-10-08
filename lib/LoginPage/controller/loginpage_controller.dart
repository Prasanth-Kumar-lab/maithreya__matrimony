import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:matrimony/ProfilePage/view/profile_view.dart';
import 'package:matrimony/SignUp/view/signup_view.dart';

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
      // Simulate API call
      await Future.delayed(Duration(seconds: 2));
      isLoading.value = false;
      if (emailOrPhone.value == 'test' && password.value == 'password') {
        Get.to(() => ProfileDetails());
      } else {
        errorMessage.value = 'Invalid credentials';
      }
    }
  }

  void goToSignup() {
    Get.to(()=> SignupView());
  }

  void forgotPassword() {
    Get.toNamed('/forgot_password');
  }
}