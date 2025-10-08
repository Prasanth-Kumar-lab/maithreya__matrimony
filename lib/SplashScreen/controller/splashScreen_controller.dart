import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../model/splashScreen_model.dart';

class SplashController extends GetxController {
  final SplashModel model = SplashModel();
  var opacity = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    // Start fade-in animation
    Future.delayed(Duration(milliseconds: 500), () {
      opacity.value = 1.0;
    });
    // Navigate to onboarding after 3 seconds
    Future.delayed(Duration(seconds: 5), () {
      Get.offNamed('/onboarding');
    });
  }
}