import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:matrimony/LocationDetails/View/location_view.dart';

class ProfileDetails extends StatelessWidget {
  const ProfileDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController dobController = TextEditingController();
    final TextEditingController ageController = TextEditingController();

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.pink[50],
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 0),
              Stack(
                alignment: Alignment.center,
                children: [
                  // Background Lottie animation
                  Positioned.fill(
                    child: Lottie.asset(
                      'assets/Stream of Hearts.json', // Replace with actual path
                      fit: BoxFit.cover,
                      repeat: false,
                    ),
                  ),
                  // Overlaying the text exactly as before
                  Column(
                    children: [
                      SizedBox(height: 80),
                      Text(
                        'Complete Your Profile',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                          color: Colors.deepPurple,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Let us know you better',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // Curved Container
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Profile Picture
                        Center(
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 60,
                                backgroundImage:
                                AssetImage('assets/images/default.png'),
                              ),
                              SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Gallery Icon Button
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Colors.white,
                                    child: IconButton(
                                      icon: Icon(Icons.image,
                                          size: 20, color: Colors.deepPurple),
                                      onPressed: () {
                                        // Gallery functionality
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  // Camera Icon Button
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Colors.white,
                                    child: IconButton(
                                      icon: Icon(Icons.camera_alt,
                                          size: 20, color: Colors.deepPurple),
                                      onPressed: () {
                                        // Camera functionality
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 32),

                        // First Name Field
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'First Name',
                            labelStyle: TextStyle(fontFamily: 'Poppins'),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey[100],
                          ),
                        ),
                        SizedBox(height: 16),

                        // Last Name Field
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Last Name',
                            labelStyle: TextStyle(fontFamily: 'Poppins'),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey[100],
                          ),
                        ),
                        SizedBox(height: 16),

                        // Date of Birth Field
                        TextField(
                          readOnly: true,
                          controller: dobController,
                          decoration: InputDecoration(
                            labelText: 'Date of Birth',
                            labelStyle: TextStyle(fontFamily: 'Poppins'),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey[100],
                          ),
                          onTap: () {
                            // No functionality
                          },
                        ),
                        SizedBox(height: 16),

                        // Age Field
                        TextField(
                          controller: ageController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Age',
                            labelStyle: TextStyle(fontFamily: 'Poppins'),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey[100],
                          ),
                        ),
                        SizedBox(height: 32),

                        // Continue Button
                        ElevatedButton(
                          onPressed: () {
                            Get.to(()=>LocationDetails());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 5,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Continue",
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward, color: Colors.white),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}