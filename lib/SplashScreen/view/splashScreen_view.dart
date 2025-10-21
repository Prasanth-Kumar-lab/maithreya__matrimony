import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controller/splashScreen_controller.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

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
                colors: [
                  Colors.orange.shade700,
                  Colors.white,
                  Colors.purple.shade100,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(
                        () => AnimatedOpacity(
                      opacity: controller.opacity.value,
                      duration: const Duration(milliseconds: 1500),
                      curve: Curves.easeInOut,
                      child: Lottie.asset(
                        model.logoPath,
                        fit: BoxFit.contain,
                        height: 300,
                        width: 300,
                        repeat: false,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Obx(
                        () => AnimatedOpacity(
                      opacity: controller.opacity.value,
                      duration: const Duration(milliseconds: 1500),
                      curve: Curves.easeInOut,
                      child: Text(
                        model.tagline,
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.italic,
                          color: Colors.deepPurple.shade800,
                          letterSpacing: 1.2,
                          shadows: [
                            Shadow(
                              blurRadius: 4.0,
                              color: Colors.black.withOpacity(0.2),
                              offset: const Offset(2, 2),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Obx(
                        () => AnimatedOpacity(
                      opacity: controller.opacity.value,
                      duration: const Duration(milliseconds: 1500),
                      curve: Curves.easeInOut,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.deepPurple.shade600,
                        ),
                        strokeWidth: 3.0,
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