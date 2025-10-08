import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/signup_model.dart';

class SignupController extends GetxController {
  final SignupModel model = SignupModel();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // TextEditingControllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  // Observables
  var name = ''.obs;
  var email = ''.obs;
  var phone = ''.obs;
  var password = ''.obs;
  var confirmPassword = ''.obs;
  var gender = 'Male'.obs;
  var dob = Rx<DateTime?>(null);
  var agreeTerms = false.obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var obscurePassword = true.obs; // For password visibility
  var obscureConfirmPassword = true.obs; // For confirm password visibility

  @override
  void onInit() {
    super.onInit();
    // Sync controllers with observables
    nameController.addListener(() {
      name.value = nameController.text;
    });
    emailController.addListener(() {
      email.value = emailController.text;
    });
    phoneController.addListener(() {
      phone.value = phoneController.text;
    });
    passwordController.addListener(() {
      password.value = passwordController.text;
    });
    confirmPasswordController.addListener(() {
      confirmPassword.value = confirmPasswordController.text;
    });
  }

  @override
  void onClose() {
    // Dispose controllers to prevent memory leaks
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void updateName(String value) {
    name.value = value;
  }

  void updateEmail(String value) {
    email.value = value;
  }

  void updatePhone(String value) {
    phone.value = value;
  }

  void updatePassword(String value) {
    password.value = value;
  }

  void updateConfirmPassword(String value) {
    confirmPassword.value = value;
  }

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  void toggleConfirmPasswordVisibility() {
    obscureConfirmPassword.value = !obscureConfirmPassword.value;
  }

  void updateGender(String? value) {
    gender.value = value ?? 'Male';
  }

  void updateDob(DateTime? value) {
    dob.value = value;
  }

  void toggleTerms(bool? value) {
    agreeTerms.value = value ?? false;
  }

  Future<void> signup() async {
    if (formKey.currentState!.validate() && agreeTerms.value) {
      if (password.value != confirmPassword.value) {
        errorMessage.value = 'Passwords do not match';
        return;
      }
      isLoading.value = true;
      // Simulate API call
      await Future.delayed(Duration(seconds: 2));
      isLoading.value = false;
      Get.toNamed('/home');
    } else if (!agreeTerms.value) {
      errorMessage.value = 'Please agree to terms';
    }
  }

  void goToLogin() {
    Get.toNamed('/login');
  }
}