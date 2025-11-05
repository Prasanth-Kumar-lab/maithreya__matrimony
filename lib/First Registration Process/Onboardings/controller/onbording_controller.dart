/*
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../model/onboarding_model.dart';

class OnboardingController extends GetxController {
  final PageController pageController = PageController();
  final RxInt currentPage = 0.obs;

  final model = OnboardingModel([
    {
      'imagePath': 'assets/onboarding1.json',
      'headline': 'Welcome to the App!',
      'subtext': 'Your journey begins here. Let’s get started.'
    },
    {
      'imagePath': 'assets/onboarding2.json',
      'headline': 'Stay Organized',
      'subtext': 'Manage your tasks and time efficiently.'
    },
    {
      'imagePath': 'assets/onboarding1.json',
      'headline': 'Achieve More',
      'subtext': 'Unlock your productivity with powerful features.'
    },
  ]);

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  void onSkipPressed() {
    // Navigate or skip logic
    Get.offAllNamed('/login'); // Example
  }

  void onGetStartedPressed() {
    // Final action
    Get.offAllNamed('/login');
  }

  void nextPage() {
    if (currentPage.value < model.slides.length - 1) {
      pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void previousPage() {
    if (currentPage.value > 0) {
      pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
}
*/