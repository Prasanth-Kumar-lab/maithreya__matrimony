import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../controller/splashScreen_controller.dart';

class SplashView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
      init: SplashController(),
      builder: (controller) {
        final model = controller.model;
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange, Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(
                        () => AnimatedOpacity(
                      opacity: controller.opacity.value,
                      duration: Duration(milliseconds: 1000),
                      child: Lottie.asset(
                        model.logoPath,
                        fit: BoxFit.contain,
                        height: 450,
                        width: 450
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Obx(
                        () => AnimatedOpacity(
                      opacity: controller.opacity.value,
                      duration: Duration(milliseconds: 1000),
                      child: Text(
                        model.tagline,
                        style: TextStyle(
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}