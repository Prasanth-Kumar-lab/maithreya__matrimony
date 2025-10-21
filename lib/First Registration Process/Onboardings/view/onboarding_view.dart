import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:matrimony/constants/constants.dart';
import '../controller/onbordind_controller.dart';

class OnboardingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<OnboardingController>(
      init: OnboardingController(),
      builder: (controller) {
        final model = controller.model;

        return Scaffold(
          backgroundColor: AppColors.bgThemeColor,
          body: SafeArea(
            top: true,
            bottom: false,
            child: Column(
              children: [
                // Lottie Animation (Top Half)
                Expanded(
                  flex: 5,
                  child: PageView.builder(
                    controller: controller.pageController,
                    itemCount: model.slides.length,
                    onPageChanged: controller.onPageChanged,
                    itemBuilder: (context, index) {
                      final slide = model.slides[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Lottie.asset(
                          slide['imagePath']!,
                          fit: BoxFit.contain,
                        ),
                      );
                    },
                  ),
                ),

                // Indicator below the animation
                Obx(() => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      model.slides.length,
                          (index) => AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        width: controller.currentPage.value == index ? 20 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: controller.currentPage.value == index
                              ? Colors.deepPurple
                              : Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                )),

                // Curved Container
                Expanded(
                  flex: 2,
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.onboardingContainers,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32),
                      ),
                      border: Border(
                        top: BorderSide(
                          color: Colors.orange,
                          width: 3,
                        ),
                      ),
                      /*boxShadow: [
                        BoxShadow(
                          color: AppColors.buttonColor.withOpacity(0.3),
                          blurRadius: 12,
                          spreadRadius: 10,
                          offset: Offset(0, -5),
                        ),
                      ],*/
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 28),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Text content
                          Obx(() {
                            final slide = controller.model.slides[controller.currentPage.value];
                            return Column(
                              children: [
                                Text(
                                  slide['headline']!,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textColor
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 12),
                                Text(
                                  slide['subtext']!,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: AppColors.textColor,
                                    height: 1.4,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            );
                          }),

                          // Buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Back Arrow inside CircleAvatar
                              CircleAvatar(
                                radius: 24,
                                backgroundColor: Colors.black.withOpacity(0.1),
                                child: IconButton(
                                  icon: Icon(Icons.arrow_back_ios_new_rounded),
                                  onPressed: controller.previousPage,
                                  color: AppColors.textFieldIconColor
                                ),
                              ),

                              // Get Started as IconButton with icon + text (not inside CircleAvatar)
                              TextButton.icon(
                                onPressed: controller.onGetStartedPressed,
                                icon: Icon(Icons.check_circle_outline, color: AppColors.textFieldIconColor),
                                label: Text(
                                  "Get Started",
                                  style: TextStyle(
                                    color: AppColors.textColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  backgroundColor: AppColors.buttonColor,
                                ),
                              ),

                              // Forward Arrow inside CircleAvatar
                              CircleAvatar(
                                radius: 24,
                                backgroundColor: Colors.black.withOpacity(0.1),
                                child: IconButton(
                                  icon: Icon(Icons.arrow_forward_ios_rounded),
                                  onPressed: controller.nextPage,
                                  color: AppColors.textFieldIconColor
                                ),
                              ),
                            ],
                          ),
                        ],
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
