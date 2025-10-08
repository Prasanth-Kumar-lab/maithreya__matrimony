import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../controller/signup-controller.dart';

class SignupView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignupController>(
      init: SignupController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.pink[50], // Background color
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
                    color: Colors.deepPurple,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Join us to find your perfect match',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 24),

                // Curved container (scrollable form section)
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
                                prefixIcon: Icon(Icons.person, color: Colors.deepPurple),
                              ),
                              validator: (value) => value!.isEmpty ? 'Please enter your full name' : null,
                              controller: controller.nameController,
                              textInputAction: TextInputAction.next,
                            ),
                            SizedBox(height: 16),

                            TextFormField(
                              decoration: InputDecoration(
                                labelText: "Email",
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                filled: true,
                                fillColor: Colors.grey[100],
                                prefixIcon: Icon(Icons.email, color: Colors.deepPurple),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) => !value!.contains('@') ? 'Please enter a valid email' : null,
                              controller: controller.emailController,
                              textInputAction: TextInputAction.next,
                            ),
                            SizedBox(height: 16),

                            TextFormField(
                              decoration: InputDecoration(
                                labelText: "Phone",
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                filled: true,
                                fillColor: Colors.grey[100],
                                prefixIcon: Icon(Icons.phone, color: Colors.deepPurple),
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
                                prefixIcon: Icon(Icons.lock, color: Colors.deepPurple),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    controller.obscurePassword.value ? Icons.visibility_off : Icons.visibility,
                                    color: Colors.deepPurple,
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
                                prefixIcon: Icon(Icons.lock, color: Colors.deepPurple),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    controller.obscureConfirmPassword.value ? Icons.visibility_off : Icons.visibility,
                                    color: Colors.deepPurple,
                                  ),
                                  onPressed: controller.toggleConfirmPasswordVisibility,
                                ),
                              ),
                              obscureText: controller.obscureConfirmPassword.value,
                              validator: (value) => value!.isEmpty ? 'Please confirm your password' : null,
                              controller: controller.confirmPasswordController,
                              textInputAction: TextInputAction.next,
                            )),
                            SizedBox(height: 16),

                            Obx(() => DropdownButtonFormField<String>(
                              value: controller.gender.value,
                              decoration: InputDecoration(
                                labelText: "Gender",
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                filled: true,
                                fillColor: Colors.grey[100],
                                prefixIcon: Icon(Icons.person_outline, color: Colors.deepPurple),
                              ),
                              items: ['Male', 'Female', 'Other'].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value, style: TextStyle(fontFamily: 'Poppins')),
                                );
                              }).toList(),
                              onChanged: controller.updateGender,
                            )),
                            SizedBox(height: 16),

                            Obx(() => TextFormField(
                              decoration: InputDecoration(
                                labelText: "Date of Birth",
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                filled: true,
                                fillColor: Colors.grey[100],
                                prefixIcon: Icon(Icons.calendar_today, color: Colors.deepPurple),
                              ),
                              readOnly: true,
                              onTap: () async {
                                DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime.now(),
                                  builder: (context, child) {
                                    return Theme(
                                      data: ThemeData.light().copyWith(
                                        colorScheme: ColorScheme.light(
                                          primary: Colors.deepPurple,
                                          onPrimary: Colors.white,
                                          onSurface: Colors.black,
                                        ),
                                      ),
                                      child: child!,
                                    );
                                  },
                                );
                                controller.updateDob(picked);
                              },
                              controller: TextEditingController(
                                text: controller.dob.value?.toString().split(' ')[0] ?? '',
                              ),
                            )),
                            SizedBox(height: 16),

                            Obx(() => Row(
                              children: [
                                Checkbox(
                                  value: controller.agreeTerms.value,
                                  onChanged: controller.toggleTerms,
                                  activeColor: Colors.deepPurple,
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
                            SizedBox(height: 24),

                            Obx(() => controller.isLoading.value
                                ? Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                              ),
                            )
                                : ElevatedButton(
                              onPressed: controller.signup,
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
                                    "Sign Up",
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