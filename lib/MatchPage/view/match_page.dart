import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../OpponentProfileScreen/view/profile_view.dart';
import '../../constants/constants.dart';

class MatchesScreen extends StatelessWidget {
  MatchesScreen({super.key});

  // List of image paths
  final List<String> profileImages = [
    'assets/anushka.jpg',
    'assets/kajal.jpg',
    'assets/Rashmika.jpg',
    'assets/srileela.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.bgThemeColor,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          children: [
            // Custom header with back arrow and title
            Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 24),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.textFieldIconColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 20,
                        color: AppColors.iconColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Matches',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
            // Liked Profiles Section
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "Liked Profiles:",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  height: 1.5,
                ),
              ),
            ).animate(onPlay: (controller) => controller.repeat()).shimmer(
              duration: 2000.ms,
              color: AppColors.textAnimateColor
            ),
            const SizedBox(height: 5),
            _buildProfileList(context, size),

            const SizedBox(height: 2),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                "My Profile Liked Profiles",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  height: 1.5,
                ),
              ),
            ).animate(onPlay: (controller) => controller.repeat()).shimmer(
              duration: 2000.ms,
              color: AppColors.textAnimateColor
            ),
            const SizedBox(height: 5),
            _buildProfileList(context, size),

            // Shortlisted Profiles
            const SizedBox(height: 2),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                "Shortlisted Profiles",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  height: 1.5,
                ),
              ),
            ).animate(onPlay: (controller) => controller.repeat()).shimmer(
              duration: 2000.milliseconds,
              color: AppColors.textAnimateColor
            ),
            const SizedBox(height: 5),
            _buildProfileList(context, size),
          ],
        ),
      ),
    );
  }

  // Reusable profile list builder with staggered animation
  Widget _buildProfileList(BuildContext context, Size size) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: AnimationLimiter(
        child: Row(
          children: AnimationConfiguration.toStaggeredList(
            duration: const Duration(milliseconds: 600),
            delay: const Duration(milliseconds: 150),
            childAnimationBuilder: (widget) => SlideAnimation(
              horizontalOffset: 50.0,
              child: FadeInAnimation(
                child: ScaleAnimation(
                  scale: 0.9,
                  child: widget,
                ),
              ),
            ),
            children: List.generate(
              profileImages.length,
                  (index) => Padding(
                padding: const EdgeInsets.only(right: 5.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileViewScreen(),
                      ),
                    );
                  },
                  child: Container(
                    width: (size.width - 55) / 2,
                    height: 200, // Fixed height, adjust as needed
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[200],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Stack(
                        children: [
                          // Image aligned to top
                          Positioned.fill(
                            child: Image.asset(
                              profileImages[index % profileImages.length],
                              fit: BoxFit.cover,
                              alignment: Alignment.topCenter, // Align image to top
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                          // Text overlay with blue opacity at bottom
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    Colors.blueAccent.withOpacity(0.9),
                                    Colors.black.withOpacity(0.3),
                                  ],
                                ),
                              ),
                              child: const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Name",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white, // White text for contrast
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "Age, Location",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white70, // Slightly transparent white
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}