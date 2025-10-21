import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:matrimony/constants/constants.dart';
import 'package:matrimony/constants/fade_slide_textfields.dart';
import '../../AboutYourSelf/view/about_your_self_view.dart';
import '../../widgets/textfield.dart';

class LifeStyleDetails extends StatelessWidget {
  final String userId;
  const LifeStyleDetails({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController hobbiesController = TextEditingController();
    final TextEditingController moviesController = TextEditingController();
    final TextEditingController booksController = TextEditingController();
    final TextEditingController interestsController = TextEditingController();

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
                        'Complete Your Lifestyle Details',
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
                  height: double.infinity,
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
                        SizedBox(height: 32),
                        FadeSlideTransition(
                          delay: 0.0,
                          child: CustomTextField(
                            label: 'Hobbies',
                            controller: hobbiesController,
                          ),
                        ),
                        SizedBox(height: 16),
                        FadeSlideTransition(
                          delay: 0.2,
                          child: CustomTextField(
                            label: 'Favourite Movies',
                            controller: moviesController,
                          ),
                        ),
                        SizedBox(height: 16),
                        FadeSlideTransition(
                          delay: 0.4,
                          child: CustomTextField(
                            label: 'Favourite Books',
                            controller: booksController,
                          ),
                        ),
                        SizedBox(height: 16),
                        FadeSlideTransition(
                          delay: 0.6,
                          child: CustomTextField(
                            label: 'Other Interests',
                            controller: interestsController,
                          ),
                        ),
                        SizedBox(height: 32),
                        FadeSlideTransition(
                          delay: 0.8,
                          child: ElevatedButton(
                            onPressed: () {
                              if (hobbiesController.text.isEmpty ||
                                  moviesController.text.isEmpty ||
                                  booksController.text.isEmpty ||
                                  interestsController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Please fill all fields')),
                                );
                                return;
                              }

                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => AboutYourSelf(userId: userId,)),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.buttonColor,
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
                                    color: AppColors.textColor,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(Icons.arrow_forward, color: AppColors.textFieldIconColor),
                              ],
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