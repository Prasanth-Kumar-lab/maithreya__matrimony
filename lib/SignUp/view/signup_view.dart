import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:matrimony/constants/constants.dart';
import '../controller/signup-controller.dart';
import 'package:intl/intl.dart'; // Add this for date formatting

class SignupView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignupController>(
      init: SignupController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColors.bgThemeColor,
          body: SafeArea(
            child: Column(
              children: [
                SizedBox(height: 40),
                Lottie.asset(
                  'assets/onboarding2.json',
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 16),
                Text(
                  'Create Your Account',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textColor,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Join us to find your perfect match',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    color: AppColors.textColor,
                  ),
                ),
                SizedBox(height: 24),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.loginSignUpTheme,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32),
                      ),
                      border: Border.all(
                        color: AppColors.animatedContainer,
                        width: 1, // <-- Adjust thickness as needed
                      ),
                      boxShadow: [
                        AppColors.boxShadow
                      ],
                    ),
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(24),
                      child: Form(
                        key: controller.formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: "Full Name",
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                filled: true,
                                fillColor: Colors.grey[100],
                                prefixIcon: Icon(Icons.person, color: AppColors.textFieldIconColor),
                              ),
                              validator: (value) => value!.isEmpty ? 'Please enter your full name' : null,
                              controller: controller.nameController,
                              textInputAction: TextInputAction.next,
                            ),
                            SizedBox(height: 16),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: "Username",
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                filled: true,
                                fillColor: Colors.grey[100],
                                prefixIcon: Icon(Icons.person_outline, color: AppColors.textFieldIconColor),
                              ),
                              validator: (value) => value!.isEmpty ? 'Please enter a username' : null,
                              controller: controller.usernameController,
                              textInputAction: TextInputAction.next,
                            ),
                            SizedBox(height: 16),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: "Phone",
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                filled: true,
                                fillColor: Colors.grey[100],
                                prefixIcon: Icon(Icons.phone, color: AppColors.textFieldIconColor),
                              ),
                              keyboardType: TextInputType.phone,
                              validator: (value) => value!.length < 10 ? 'Please enter a valid phone number' : null,
                              controller: controller.phoneController,
                              textInputAction: TextInputAction.next,
                            ),
                            SizedBox(height: 16),
                            Obx(() => TextFormField(
                              decoration: InputDecoration(
                                labelText: "Password",
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                filled: true,
                                fillColor: Colors.grey[100],
                                prefixIcon: Icon(Icons.lock, color: AppColors.textFieldIconColor),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    controller.obscurePassword.value ? Icons.visibility_off : Icons.visibility,
                                    color: AppColors.textFieldIconColor,
                                  ),
                                  onPressed: controller.togglePasswordVisibility,
                                ),
                              ),
                              obscureText: controller.obscurePassword.value,
                              validator: (value) => value!.length < 6 ? 'Password must be at least 6 characters' : null,
                              controller: controller.passwordController,
                              textInputAction: TextInputAction.next,
                            )),
                            SizedBox(height: 16),
                            Obx(() => TextFormField(
                              decoration: InputDecoration(
                                labelText: "Confirm Password",
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                filled: true,
                                fillColor: Colors.grey[100],
                                prefixIcon: Icon(Icons.lock, color: AppColors.textFieldIconColor),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    controller.obscureConfirmPassword.value ? Icons.visibility_off : Icons.visibility,
                                    color: AppColors.textFieldIconColor,
                                  ),
                                  onPressed: controller.toggleConfirmPasswordVisibility,
                                ),
                              ),
                              obscureText: controller.obscureConfirmPassword.value,
                              validator: (value) => value!.isEmpty ? 'Please confirm your password' : null,
                              controller: controller.confirmPasswordController,
                              textInputAction: TextInputAction.next,
                            )),
                            SizedBox(height: 5),
                            Obx(() => Row(
                              children: [
                                Checkbox(
                                  value: controller.agreeTerms.value,
                                  onChanged: controller.toggleTerms,
                                  activeColor: AppColors.textFieldIconColor,
                                ),
                                Flexible(
                                  child: GestureDetector(
                                    onTap: () => Get.toNamed('/terms'),
                                    child: Text(
                                      "I agree to the terms and conditions",
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 14,
                                        color: Colors.deepPurple,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                            Obx(() {
                              if (controller.errorMessage.value.isNotEmpty) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    controller.errorMessage.value,
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontFamily: 'Poppins',
                                      fontSize: 14,
                                    ),
                                  ),
                                );
                              }
                              return SizedBox.shrink();
                            }),
                            SizedBox(height: 15),
                            Obx(() => controller.isLoading.value
                                ? Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                              ),
                            )
                                : ElevatedButton(
                              onPressed: controller.signup,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.buttonColor,
                                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 5,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Sign Up",
                                    style: TextStyle(
                                      color: AppColors.textColor,
                                      fontSize: 18,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(Icons.arrow_forward, color: AppColors.textFieldIconColor, size: 18),
                                ],
                              ),
                            )),
                            SizedBox(height: 16),
                            TextButton(
                              onPressed: controller.goToLogin,
                              child: Text(
                                "Already have an account? Login",
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  color: Colors.deepPurple,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}