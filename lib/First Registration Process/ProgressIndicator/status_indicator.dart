import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:matrimony/constants/constants.dart';

class RegistrationProgressIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final List<String> stepTitles;

  const RegistrationProgressIndicator({
    Key? key,
    required this.currentStep,
    required this.totalSteps,
    required this.stepTitles,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double progress = currentStep / totalSteps;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // --- Animated Linear Progress Bar with Glow Gradient ---
          AnimatedContainer(
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
            height: 10,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: progress.clamp(0.0, 1.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      colors: [
                        AppColors.buttonColor,
                        Colors.purpleAccent,
                        Colors.indigo,
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purpleAccent.withOpacity(0.4),
                        blurRadius: 8,
                        spreadRadius: 1,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // --- Step Circles + Titles ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(totalSteps, (index) {
              final bool isActive = index < currentStep;
              final bool isCurrent = index == currentStep - 1;

              return Expanded(
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        // Connector line behind circle
                        if (index < totalSteps - 1)
                          Positioned(
                            right: -MediaQuery.of(context).size.width /
                                (totalSteps * 2.5),
                            child: Container(
                              height: 3,
                              width: MediaQuery.of(context).size.width /
                                  totalSteps /
                                  1.4,
                              color: index < currentStep - 1
                                  ? AppColors.buttonColor.withOpacity(0.8)
                                  : Colors.grey.shade300,
                            ),
                          ),

                        // Step circle with shimmer for current step
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 400),
                          height: 36,
                          width: 36,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: isActive
                                ? LinearGradient(
                              colors: [
                                AppColors.buttonColor,
                                Colors.purpleAccent,
                                Colors.indigo,
                              ],
                            )
                                : LinearGradient(
                              colors: [
                                Colors.grey.shade300,
                                Colors.grey.shade400,
                              ],
                            ),
                            boxShadow: isCurrent
                                ? [
                              BoxShadow(
                                color: Colors.purpleAccent.withOpacity(0.4),
                                blurRadius: 8,
                                spreadRadius: 1,
                              )
                            ]
                                : [],
                          ),
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isActive
                                    ? Colors.white
                                    : Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ).animate(
                          onPlay: (controller) =>
                          isCurrent ? controller.repeat() : controller.stop(),
                          effects: isCurrent
                              ? [
                            ShimmerEffect(
                              duration: const Duration(milliseconds: 2000),
                              color: Colors.white,
                            ),
                          ]
                              : [],
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}