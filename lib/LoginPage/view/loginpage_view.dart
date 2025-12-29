/*
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:matrimony/LoginPage/view/otp_login.dart';
import 'package:matrimony/constants/constants.dart';
import '../controller/loginpage_controller.dart';
class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      init: LoginController(),
      builder: (controller) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: AppColors.bgThemeColor, // Background color
          body: SafeArea(
            bottom: false,
            top: true,
            child: Column(
              children: [
                SizedBox(height: 40),
                // App Logo
                Lottie.asset(
                  'assets/onboarding2.json', // Assume logo asset
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 16),
                Text(
                  'Welcome Back',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 28,
                    fontWeight: AppColors.fontWeight,
                    color: AppColors.textColor,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Sign in to find your perfect match',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: AppColors.fontWeight,
                    color: AppColors.textColor,
                  ),
                ),
                SizedBox(height: 24),
                // Curved Container without horizontal padding
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
                      padding: EdgeInsets.all(24), // Inner padding only
                      child: Form(
                        key: controller.formKeyy,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Obx(() => TextFormField(
                              decoration: InputDecoration(
                                labelText: "Email or Phone",
                                labelStyle: TextStyle(color: AppColors.textColor),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: Colors.grey[100],
                                prefixIcon: Icon(Icons.email, color: AppColors.textFieldIconColor),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    controller.obscureEmailOrPhone.value
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: AppColors.textFieldIconColor,
                                  ),
                                  onPressed: controller.toggleEmailOrPhoneVisibility,
                                ),
                              ),
                              obscureText: controller.obscureEmailOrPhone.value,
                              validator: (value) => value!.isEmpty ? 'Please enter email or phone' : null,
                              controller: controller.emailOrPhoneController,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                            )),
                            SizedBox(height: 16),
                            Obx(() => TextFormField(
                              decoration: InputDecoration(
                                labelText: "Password",
                                labelStyle: TextStyle(color: AppColors.textColor),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: Colors.grey[100],
                                prefixIcon: Icon(Icons.lock, color: AppColors.textFieldIconColor),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    controller.obscurePassword.value
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: AppColors.textFieldIconColor,
                                  ),
                                  onPressed: controller.togglePasswordVisibility,
                                ),
                              ),
                              obscureText: controller.obscurePassword.value,
                              validator: (value) => value!.length < 6 ? 'Password must be at least 6 characters' : null,
                              controller: controller.passwordController,
                              textInputAction: TextInputAction.done,
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
                            // Remember Me Checkbox
                            Obx(() => Row(
                              children: [
                                Checkbox(
                                  value: controller.rememberMe.value,
                                  onChanged: (value) {
                                    controller.toggleRememberMe(value ?? false);
                                  },
                                  activeColor: AppColors.buttonColor,
                                ),
                                Text(
                                  'Remember Me',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 14,
                                    color: AppColors.textColor,
                                  ),
                                ),
                              ],
                            )),
                            Obx(() => controller.isLoading.value
                                ? Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                              ),
                            )
                                : ElevatedButton(
                              onPressed: controller.login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.buttonColor.shade400,
                                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 2,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Login",
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: controller.forgotPassword,
                                  child: Text(
                                    "Forgot Password?",
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 14,
                                      color: AppColors.forgotPassword,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                Get.to(()=>OtpLogin());
                              },
                              icon: Icon(Icons.phone_android, color: AppColors.buttonIconColor),
                              label: Text(
                                "Login with Mobile Number",
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 17,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.buttonColor.shade400,
                                foregroundColor: AppColors.textColor,
                                padding: EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 2,
                              ),
                            ),
                            TextButton(
                              onPressed: controller.goToSignup,
                              child: Text(
                                "Don't have an account? Sign Up",
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  color: AppColors.forgotPassword,
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
}*/                                                                       // OLD
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:matrimony/LoginPage/view/otp_login.dart';
import 'package:matrimony/constants/constants.dart';
import '../controller/loginpage_controller.dart';

class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      init: LoginController(),
      builder: (controller) {
        return Scaffold(
          // Ensures the layout adjusts when the keyboard opens
          resizeToAvoidBottomInset: true,
          backgroundColor: AppColors.bgThemeColor,
          body: SafeArea(
            bottom: false,
            top: true,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  // App Logo / Animation
                  Lottie.asset(
                    'assets/onboarding2.json',
                    fit: BoxFit.contain,
                    height: 200, // Added height for consistency
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Welcome Back',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 28,
                      fontWeight: AppColors.fontWeight,
                      color: AppColors.textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sign in to find your perfect match',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: AppColors.fontWeight,
                      color: AppColors.textColor,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Form Container
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.loginSignUpTheme,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32),
                      ),
                      border: Border.all(
                        color: AppColors.animatedContainer,
                        width: 1,
                      ),
                      boxShadow: [AppColors.boxShadow],
                    ),
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: controller.formKeyy,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Email or Phone Field
                          Obx(() => TextFormField(
                            decoration: InputDecoration(
                              labelText: "Email or Phone",
                              labelStyle: TextStyle(color: AppColors.textColor),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.grey[100],
                              prefixIcon: Icon(Icons.email, color: AppColors.textFieldIconColor),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  controller.obscureEmailOrPhone.value
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: AppColors.textFieldIconColor,
                                ),
                                onPressed: controller.toggleEmailOrPhoneVisibility,
                              ),
                            ),
                            obscureText: controller.obscureEmailOrPhone.value,
                            validator: (value) => value!.isEmpty ? 'Please enter email or phone' : null,
                            controller: controller.emailOrPhoneController,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                          )),
                          const SizedBox(height: 16),

                          // Password Field
                          Obx(() => TextFormField(
                            decoration: InputDecoration(
                              labelText: "Password",
                              labelStyle: TextStyle(color: AppColors.textColor),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.grey[100],
                              prefixIcon: Icon(Icons.lock, color: AppColors.textFieldIconColor),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  controller.obscurePassword.value
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: AppColors.textFieldIconColor,
                                ),
                                onPressed: controller.togglePasswordVisibility,
                              ),
                            ),
                            obscureText: controller.obscurePassword.value,
                            validator: (value) => value!.length < 6 ? 'Password must be at least 6 characters' : null,
                            controller: controller.passwordController,
                            textInputAction: TextInputAction.done,
                          )),

                          // Error Message
                          Obx(() {
                            if (controller.errorMessage.value.isNotEmpty) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  controller.errorMessage.value,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontFamily: 'Poppins',
                                    fontSize: 14,
                                  ),
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          }),

                          // Remember Me Checkbox
                          Obx(() => Row(
                            children: [
                              Checkbox(
                                value: controller.rememberMe.value,
                                onChanged: (value) {
                                  controller.toggleRememberMe(value ?? false);
                                },
                                activeColor: AppColors.buttonColor,
                              ),
                              Text(
                                'Remember Me',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  color: AppColors.textColor,
                                ),
                              ),
                            ],
                          )),

                          const SizedBox(height: 10),

                          // Login Button / Loading Indicator
                          Obx(() => controller.isLoading.value
                              ? const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                            ),
                          )
                              : ElevatedButton(
                            onPressed: controller.login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.buttonColor.shade400,
                              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 2,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Login",
                                  style: TextStyle(
                                    color: AppColors.textColor,
                                    fontSize: 18,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Icon(Icons.arrow_forward, color: AppColors.textFieldIconColor, size: 18),
                              ],
                            ),
                          )),

                          // Forgot Password
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: controller.forgotPassword,
                                child: Text(
                                  "Forgot Password?",
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 14,
                                    color: AppColors.forgotPassword,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Mobile Login Button
                          ElevatedButton.icon(
                            onPressed: () {
                              Get.to(() => OtpLogin());
                            },
                            icon: Icon(Icons.phone_android, color: AppColors.buttonIconColor),
                            label: const Text(
                              "Login with Mobile Number",
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 17,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.buttonColor.shade400,
                              foregroundColor: AppColors.textColor,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 2,
                            ),
                          ),

                          // Signup Link
                          TextButton(
                            onPressed: controller.goToSignup,
                            child: Text(
                              "Don't have an account? Sign Up",
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                color: AppColors.forgotPassword,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 40), // Bottom padding for scroll
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}