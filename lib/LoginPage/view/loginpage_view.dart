import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../controller/loginpage_controller.dart';

class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      init: LoginController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.pink[50], // Background color
          body: SafeArea(
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
                    fontWeight: FontWeight.w600,
                    color: Colors.deepPurple,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Sign in to find your perfect match',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 24),

                // Curved Container without horizontal padding
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, -4),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(24), // Inner padding only
                      child: Form(
                        key: controller.formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: "Email or Phone",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: Colors.grey[100],
                                prefixIcon: Icon(Icons.email, color: Colors.deepPurple),
                              ),
                              validator: (value) => value!.isEmpty ? 'Please enter email or phone' : null,
                              controller: controller.emailOrPhoneController,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                            ),
                            SizedBox(height: 16),
                            Obx(() => TextFormField(
                              decoration: InputDecoration(
                                labelText: "Password",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: Colors.grey[100],
                                prefixIcon: Icon(Icons.lock, color: Colors.deepPurple),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    controller.obscurePassword.value
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Colors.deepPurple,
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
                            SizedBox(height: 24),
                            Obx(() => controller.isLoading.value
                                ? Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                              ),
                            )
                                : ElevatedButton(
                              onPressed: controller.login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
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
                                    "Login",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                                ],
                              ),
                            )),
                            SizedBox(height: 16),
                            TextButton(
                              onPressed: controller.forgotPassword,
                              child: Text(
                                "Forgot Password?",
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: controller.goToSignup,
                              child: Text(
                                "Don't have an account? Sign Up",
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