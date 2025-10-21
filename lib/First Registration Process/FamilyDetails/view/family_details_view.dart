import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:matrimony/constants/constants.dart';
import 'package:matrimony/constants/fade_slide_textfields.dart';
import '../../LifestyleDetails/view/lifestyle_details_view.dart';
import '../../widgets/textfield.dart';

class FamilyDetails extends StatelessWidget {
  final String userId;
  const FamilyDetails({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController motherNameController = TextEditingController();
    final TextEditingController fatherNameController = TextEditingController();
    final TextEditingController birthTimeController = TextEditingController();
    final TextEditingController sistersController = TextEditingController();
    final TextEditingController brothersController = TextEditingController();

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.bgThemeColor,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              SizedBox(height: 0),
              Stack(
                alignment: Alignment.center,
                children: [
                  Positioned.fill(
                    child: Lottie.asset(
                      LottieAssets.registrationLottie,
                      fit: BoxFit.cover,
                      repeat: false,
                    ),
                  ),
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
                          color: AppColors.textColor,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        RegistrationTitles.registrationSubTitle,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          color: AppColors.textColor,
                        ),
                      ),
                      SizedBox(height: 12),
                    ],
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.registrationProcess,
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
                        SizedBox(height: 8),
                        FadeSlideTransition(
                          delay: 0.0,
                          child: CustomTextField(
                            label: 'Mother Name',
                            controller: motherNameController,
                          ),
                        ),
                        SizedBox(height: 16),
                        FadeSlideTransition(
                          delay: 0.2,
                          child: CustomTextField(
                            label: 'Father Name',
                            controller: fatherNameController,
                          ),
                        ),
                        SizedBox(height: 16),
                        FadeSlideTransition(
                          delay: 1.0,
                          child: CustomTextField(
                            label: 'Birth Time',
                            controller: birthTimeController,
                          ),
                        ),
                        SizedBox(height: 16),
                        FadeSlideTransition(
                          delay: 1.2,
                          child: CustomTextField(
                            label: 'No. Of Sisters',
                            controller: sistersController,
                          ),
                        ),
                        SizedBox(height: 16),
                        FadeSlideTransition(
                          delay: 1.4,
                          child: CustomTextField(
                            label: 'No. Of Brothers',
                            controller: brothersController,
                          ),
                        ),
                        SizedBox(height: 20),
                        SafeArea(
                          child: FadeSlideTransition(
                            delay: 1.6,
                            child: ElevatedButton(
                              onPressed: () {
                                if (motherNameController.text.isEmpty ||
                                    fatherNameController.text.isEmpty ||
                                    birthTimeController.text.isEmpty ||
                                    sistersController.text.isEmpty ||
                                    brothersController.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Please fill all fields')),
                                  );
                                  return;
                                }

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => LifeStyleDetails(userId: userId,)),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.buttonColor,
                                padding: EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 2,
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
                                      color: AppColors.textColor,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(Icons.arrow_forward, color: AppColors.textFieldIconColor),
                                ],
                              ),
                            ),
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