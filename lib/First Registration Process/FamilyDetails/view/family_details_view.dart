import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lottie/lottie.dart';
import 'package:matrimony/LifestyleDetails/view/lifestyle_details_view.dart';

class FamilyDetails extends StatelessWidget {
  const FamilyDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController motherNameController = TextEditingController();
    final TextEditingController fathernameController = TextEditingController();
    final TextEditingController gothramController = TextEditingController();
    final TextEditingController nakshatramController = TextEditingController();
    final TextEditingController rasiController = TextEditingController();
    final TextEditingController birthTimeController = TextEditingController();
    final TextEditingController sistersController = TextEditingController();
    final TextEditingController brothersController = TextEditingController();

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
                        'Complete Your Family Details',
                        textAlign: TextAlign.center,
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
                        SizedBox(height: 32),
                        // Date of Birth Field
                        TextField(
                          readOnly: true,
                          controller: motherNameController,
                          decoration: InputDecoration(
                            labelText: 'Mother name',
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
                          keyboardType: TextInputType.number,
                          controller: fathernameController,
                          decoration: InputDecoration(
                            labelText: 'Father name',
                            labelStyle: TextStyle(fontFamily: 'Poppins'),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey[100],
                          ),
                        ),
                        SizedBox(height: 16,),
                        TextField(
                          controller: gothramController,
                          decoration: InputDecoration(
                            labelText: 'Gothram',
                            labelStyle: TextStyle(fontFamily: 'Poppins'),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey[100],
                          ),
                        ),
                        SizedBox(height: 16,),
                        TextField(
                          controller: nakshatramController,
                          decoration: InputDecoration(
                            labelText: 'Nakshatram',
                            labelStyle: TextStyle(fontFamily: 'Poppins'),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey[100],
                          ),
                        ),
                        SizedBox(height: 16,),
                        TextField(
                          controller: rasiController,
                          decoration: InputDecoration(
                            labelText: 'Rasi',
                            labelStyle: TextStyle(fontFamily: 'Poppins'),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey[100],
                          ),
                        ),
                        SizedBox(height: 16,),
                        TextField(
                          controller: birthTimeController,
                          decoration: InputDecoration(
                            labelText: 'Birth time',
                            labelStyle: TextStyle(fontFamily: 'Poppins'),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey[100],
                          ),
                        ),
                        SizedBox(height: 16,),
                        TextField(
                          controller: sistersController,
                          decoration: InputDecoration(
                            labelText: 'No.of sisters',
                            labelStyle: TextStyle(fontFamily: 'Poppins'),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey[100],
                          ),
                        ),
                        SizedBox(height: 16,),
                        TextField(
                          controller: brothersController,
                          decoration: InputDecoration(
                            labelText: 'No.of brothers',
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
                            Get.to(()=>LifeStyleDetails());
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