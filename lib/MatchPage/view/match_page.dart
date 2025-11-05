import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:lottie/lottie.dart';
import '../../constants/constants.dart';
import '../controller/matches_page_controller.dart';

class MatchesScreen extends StatelessWidget {
  final String userId;
  const MatchesScreen({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MatchesController(userId));
    final size = MediaQuery.of(context).size;

    // Add reactive variables to control expansion
    final likedExpanded = false.obs;
    final likedMeExpanded = false.obs;

    return Scaffold(
      backgroundColor: AppColors.bgThemeColor,
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.errorMessage.isNotEmpty) {
            return Center(child: Text(controller.errorMessage.value));
          }

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            children: [
              _buildHeader(context),

              _buildSectionHeader(
                title: "Favourites",
                expanded: likedExpanded,
                profiles: controller.likedProfiles,
              ),
              const SizedBox(height: 5),
              Obx(() => _buildProfileList(
                context,
                size,
                controller.likedProfiles,
                controller,
                'liked',
                likedExpanded.value,
              )),
              const SizedBox(height: 4),

              _buildSectionHeader(
                title: "Interests on me",
                expanded: likedMeExpanded,
                profiles: controller.likedMeProfiles,
              ),
              const SizedBox(height: 5),
              Obx(() => _buildProfileList(
                context,
                size,
                controller.likedMeProfiles,
                controller,
                'likedMe',
                likedMeExpanded.value,
              )),
            ],
          );
        }),
      ),
    );
  }
  Widget _buildHeader(BuildContext context) {
    return Padding(
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
              child: Icon(Icons.arrow_back_ios_new,
                  size: 20, color: AppColors.iconColor),
            ),
          ),
          const SizedBox(width: 16),
          const Text(
            'Matches',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
  Widget _buildSectionHeader({
    required String title,
    required RxBool expanded,
    required List<dynamic> profiles,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, height: 1.5),
          ),
          if (profiles.isNotEmpty)
            Obx(() => TextButton(
              onPressed: () => expanded.value = !expanded.value,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(expanded.value ? "Show Less" : "Show More", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textColor),),
                  const SizedBox(width: 4),
                  AnimatedRotation(
                    turns: expanded.value ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(Icons.arrow_right, size: 20,),
                  ),
                ],
              ),
            )),
        ],
      ),
    ).animate().shimmer(duration: 2000.ms, color: AppColors.textAnimateColor);
  }
  Widget _buildProfileList(
      BuildContext context,
      Size size,
      List<dynamic> profiles,
      MatchesController controller,
      String section, // 'liked' for Favourites, 'likedMe' for Interests on me
      bool expanded,
      ) {
    if (profiles.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('No profiles found.'),
        ),
      );
    }

    // Limit to first 4 profiles unless expanded
    final displayProfiles = expanded ? profiles : profiles.take(4).toList();

    return AnimationLimiter(
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: displayProfiles.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Two columns
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.8,
        ),
        itemBuilder: (context, index) {
          final profile = displayProfiles[index];
          final imageUrl = profile['image'] ?? '';
          final name = profile['name'] ?? 'Unknown';
          final gender = profile['gender'] ?? '';
          final profileId = profile['id']?.toString() ?? '';
          final uniqueCardId = '$section$profileId';

          return Obx(() {
            final isLoading = controller.cardLoadingStates[uniqueCardId] ?? false;

            return AnimationConfiguration.staggeredGrid(
              position: index,
              duration: const Duration(milliseconds: 500),
              columnCount: 2,
              child: ScaleAnimation(
                scale: 0.9,
                child: FadeInAnimation(
                  child: GestureDetector(
                    onTap: () => controller.viewProfile(context, profileId, uniqueCardId),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[200],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Stack(
                          children: [
                            // Profile image
                            Positioned.fill(
                              child: Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const Center(
                                  child: Icon(Icons.person, size: 50, color: Colors.grey),
                                ),
                              ),
                            ),

                            // Bottom gradient with name and gender
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
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      gender,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // ✅ Show close icon only for Favourites
                            if (section == 'liked')
                              Positioned(
                                top: 8,
                                right: 8,
                                child: GestureDetector(
                                  onTap: () {
                                    controller.deleteLikedUser(
                                      currentUserId: controller.currentUserId,
                                      profileId: profileId,
                                      type: section,
                                      context: context,
                                    );
                                  },
                                  child: CircleAvatar(
                                    radius: 14,
                                    backgroundColor: Colors.black.withOpacity(0.8),
                                    child: Icon(
                                      Icons.close,
                                      color: AppColors.iconColor,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ),

                            // Loading overlay
                            if (isLoading)
                              Positioned.fill(
                                child: Container(
                                  color: Colors.black.withOpacity(0.5),
                                  child: Center(
                                    child: Lottie.asset(
                                      LottieAssets.fetchingProfile,
                                      height: 120,
                                      width: 120,
                                    ),
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
            );
          });
        },
      ),
    );
  }

}
