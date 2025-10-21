import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignupController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Text controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController dobTextController = TextEditingController(); // Manual DOB entry

  // Observable fields
  var name = ''.obs;
  var username = ''.obs;
  var phone = ''.obs;
  var password = ''.obs;
  var confirmPassword = ''.obs;
  var gender = 'Male'.obs;
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
    addressController.addListener(() => address.value = addressController.text);
    dobTextController.addListener(() {});
  }

  @override
  void onClose() {
    nameController.dispose();
    usernameController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    addressController.dispose();
    dobTextController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() => obscurePassword.value = !obscurePassword.value;
  void toggleConfirmPasswordVisibility() => obscureConfirmPassword.value = !obscureConfirmPassword.value;
  void toggleTerms(bool? value) => agreeTerms.value = value ?? false;
  void updateGender(String? value) => gender.value = value ?? 'Male';

  /// Parses DOB from text input and returns in YYYY-MM-DD format for API
  String? get formattedDobForApi {
    final text = dobTextController.text.trim();
    final regex = RegExp(r'^\d{2}-\d{2}-\d{4}$');
    if (!regex.hasMatch(text)) return null;

    try {
      final parts = text.split('-');
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);
      final dob = DateTime(year, month, day);
      if (dob.isAfter(DateTime.now())) return null;

      return "${dob.year.toString().padLeft(4, '0')}-${dob.month.toString().padLeft(2, '0')}-${dob.day.toString().padLeft(2, '0')}";
    } catch (_) {
      return null;
    }
  }

  Future<void> signup() async {
    errorMessage.value = '';

    if (!agreeTerms.value) {
      errorMessage.value = 'Please agree to terms';
      return;
    }

    if (!formKey.currentState!.validate()) return;

    if (password.value != confirmPassword.value) {
      errorMessage.value = 'Passwords do not match';
      return;
    }

    final dobFormatted = formattedDobForApi;
    if (dobFormatted == null) {
      errorMessage.value = 'Invalid date of birth (use DD-MM-YYYY)';
      return;
    }

    isLoading.value = true;

    try {
      final response = await http.post(
        Uri.parse('https://maithreyamatrimony.com/ckr_associates/_api_v1/signup_api.php'),
        body: {
          'date_of_birth': dobFormatted,
          'gender': gender.value,
          'name': name.value,
          'number': phone.value,
          'username': username.value,
          'password': password.value,
          'address': address.value,
        },
      );

      print('API Response: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'Success') {
          Get.toNamed('/login');
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
