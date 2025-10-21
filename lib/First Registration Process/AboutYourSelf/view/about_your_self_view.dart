import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:matrimony/HomeScreen/view/home_screen_view.dart';
import 'package:matrimony/constants/constants.dart';
import '../../../constants/fade_slide_textfields.dart';
import '../../widgets/textfield.dart';

class AboutYourSelf extends StatefulWidget {
  final String userId;
  const AboutYourSelf({Key? key, required this.userId}) : super(key: key);

  @override
  State<AboutYourSelf> createState() => _AboutYourSelfState();
}

class _AboutYourSelfState extends State<AboutYourSelf> {
  final TextEditingController aboutController = TextEditingController();

  @override
  void dispose() {
    aboutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.bgThemeColor,
        appBar: AppBar(
          title: Text(
            'Tell Us About Yourself',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.textColor,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Stack(
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 40),
                        Text(
                          'Tell Us About Yourself',
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
              ),
              Expanded(
                flex: 2,
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
                        SizedBox(height: 32),
                        FadeSlideTransition(
                          delay: 0.0,
                          child: CustomTextField(
                            label: 'Tell Us About Yourself',
                            controller: aboutController,
                            helperText: 'Briefly describe your background, interests, profession, and anything you’d like to share.',
                          ),
                        ),
                        SizedBox(height: 32),
                        FadeSlideTransition(
                          delay: 0.8,
                          child: ElevatedButton(
                            onPressed: () {
                              if (aboutController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Please fill all fields')),
                                );
                                return;
                              }

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Profile saved successfully!')),
                              );

                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => HomeScreen(userId: widget.userId,)),
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
                                Icon(
                                  Icons.arrow_forward,
                                  color: AppColors.textFieldIconColor,
                                ),
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