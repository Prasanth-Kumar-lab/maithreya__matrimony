import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import '../../constants/constants.dart';
import '../controller/matches_page_controller.dart';
class MatchesScreen extends StatelessWidget {
  final String userId;

  const MatchesScreen({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MatchesController(userId));
    final size = MediaQuery
        .of(context)
        .size;
    //  Add reactive variables to control expansion
    final likedExpanded = false.obs;
    final likedMeExpanded = false.obs;
    final callHistoryExpanded = false.obs;
    return Scaffold(
      backgroundColor: AppColors.bgThemeColor,
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: _shimmerLoading(MediaQuery
                  .of(context)
                  .size),
            );
          }
          //if (controller.errorMessage.isNotEmpty) {
          //return Center(child: Text(controller.errorMessage.value));
          //}
          return RefreshIndicator(
            color: AppColors.textColor,
            backgroundColor: Colors.white,
            onRefresh: () => controller.refreshMatches(),
            // <-- Calls the new method
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              children: [
                //_buildHeader(context),
                _buildSectionHeader(
                  title: "Favourites",
                  expanded: likedExpanded,
                  profiles: controller.likedProfiles,
                ),
                const SizedBox(height: 5),
                Obx(() =>
                    _buildProfileList(
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
                Obx(() =>
                    _buildProfileList(
                      context,
                      size,
                      controller.likedMeProfiles,
                      controller,
                      'likedMe',
                      likedMeExpanded.value,
                    )),
                const SizedBox(height: 4),
                _buildCallHistorySection(
                    context, controller, callHistoryExpanded),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCallHistorySection(BuildContext context,
      MatchesController controller,
      RxBool expanded,) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 2).copyWith(bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
              title: "Call History",
              expanded: expanded,
              profiles: controller.callHistory,
            ),
            const SizedBox(height: 5),
            Obx(() {
              if (controller.callHistory.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      'No calls made yet.',
                      style: TextStyle(
                          color: AppColors.textColor, fontSize: 16),
                    ),
                  ),
                );
              }
              final displayCalls = expanded.value
                  ? controller.callHistory
                  : controller.callHistory.take(4).toList();
              return AnimationLimiter(
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: displayCalls.length,
                  separatorBuilder: (context, index) =>
                  const Divider(height: 5, color: Colors.grey),
                  itemBuilder: (context, index) {
                    final callRecord = displayCalls[index];
                    final calledUserName = callRecord['name'] ?? 'Unknown User';
                    final callDate = callRecord['call_date'] ?? 'Unknown Date';
                    final profileId = callRecord['id']?.toString() ?? '';
                    final imageUrl = callRecord['image'] ?? '';
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 500),
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: ListTile(
                            leading: const Icon(
                                Icons.call_made_outlined, color: Colors.green,
                                size: 24),
                            title: Text(
                              'You spoke with $calledUserName',
                              style: TextStyle(fontWeight: FontWeight.bold,
                                  color: AppColors.textColor),
                            ),
                            subtitle: Text(callDate),
                            trailing: GestureDetector(
                              onTap: () =>
                                  controller.viewProfile(
                                  context, profileId, 'call_$profileId'),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  child: imageUrl.isNotEmpty
                                      ? Image.network(
                                    imageUrl,
                                    fit: BoxFit.cover,
                                    alignment: Alignment.topRight,
                                    width: 50,
                                    height: 50,
                                    errorBuilder: (context, error, stackTrace) {
                                      // Show default image or icon when image fails to load
                                      return Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius: BorderRadius.circular(
                                              8),
                                        ),
                                        child: Image.asset(
                                            'assets/default.jpg'),
                                      );
                                    },
                                  )
                                      : Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.person,
                                      color: Colors.blue,
                                      size: 30,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            onTap: () =>
                                controller.viewProfile(
                                context, profileId, 'call_$profileId'),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            tileColor: Colors.grey[100],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
          ],
        ),
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
            Obx(() =>
                TextButton(
                  onPressed: () => expanded.value = !expanded.value,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(expanded.value ? "Show Less" : "Show More",
                        style: TextStyle(fontWeight: FontWeight.bold,
                            color: AppColors.textColor),),
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

  Widget _buildProfileList(BuildContext context,
      Size size,
      List<dynamic> profiles,
      MatchesController controller,
      String section, // 'liked' for Favourites, 'likedMe' for Interests on me
      bool expanded,) {
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
            final isLoading = controller.cardLoadingStates[uniqueCardId] ??
                false;
            return AnimationConfiguration.staggeredGrid(
              position: index,
              duration: const Duration(milliseconds: 500),
              columnCount: 2,
              child: ScaleAnimation(
                scale: 0.9,
                child: FadeInAnimation(
                  child: GestureDetector(
                    onTap: () =>
                        controller.viewProfile(
                        context, profileId, uniqueCardId),
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
                                alignment: Alignment.topCenter,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                const Center(
                                  child: Icon(Icons.person, size: 50,
                                      color: Colors.grey),
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
                                    backgroundColor: Colors.black.withOpacity(
                                        0.8),
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

  Widget _shimmerLoading(Size size) {
    double horizontalPadding = size.width *
        0.04; // 16 on standard 400 width screen
    double verticalPadding = size.height *
        0.015; // 12 on standard 800 height screen

    return ListView(
      padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding, vertical: verticalPadding),
      children: [
        // Favourites Section
        _buildShimmerSectionHeader(title: "Your Favourites", size: size),
        SizedBox(height: size.height * 0.015),
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: 4,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: size.width * 0.03,
            mainAxisSpacing: size.height * 0.015,
            childAspectRatio: 0.75,
          ),
          itemBuilder: (context, index) => _buildShimmerProfileCard(size),
        ),
        SizedBox(height: size.height * 0.03),

        // Interests on Me Section
        _buildShimmerSectionHeader(title: "Interested in You", size: size),
        SizedBox(height: size.height * 0.015),
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: 6,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: size.width * 0.025,
            mainAxisSpacing: size.height * 0.015,
            childAspectRatio: 0.82,
          ),
          itemBuilder: (context, index) => _buildShimmerLikeAvatar(size),
        ),
        SizedBox(height: size.height * 0.03),

        // Call History Section
        _buildShimmerSectionHeader(title: "Recent Calls", size: size),
        SizedBox(height: size.height * 0.015),
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: 5,
          separatorBuilder: (_, __) => SizedBox(height: size.height * 0.015),
          itemBuilder: (_, __) => _buildShimmerCallTile(size),
        ),
        SizedBox(height: size.height * 0.025),
      ],
    );
  }

  // Section header
  Widget _buildShimmerSectionHeader(
      {required String title, required Size size}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: size.height * 0.035,
            width: size.width * 0.5,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        SizedBox(height: size.height * 0.008),
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: size.height * 0.02,
            width: size.width * 0.3,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
      ],
    );
  }

// Profile card
  Widget _buildShimmerProfileCard(Size size) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(size.width * 0.04),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.vertical(
                      top: Radius.circular(size.width * 0.04)),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(size.width * 0.03),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: size.height * 0.025,
                      width: size.width * 0.25,
                      color: Colors.white,
                      margin: EdgeInsets.only(bottom: size.height * 0.01)),
                  Container(height: size.height * 0.018,
                      color: Colors.white,
                      margin: EdgeInsets.only(bottom: size.height * 0.008)),
                  Container(height: size.height * 0.018,
                      width: size.width * 0.2,
                      color: Colors.white),
                  SizedBox(height: size.height * 0.015),
                  Row(
                    children: [
                      Container(height: size.height * 0.035,
                          width: size.width * 0.15,
                          decoration: BoxDecoration(color: Colors.white,
                              borderRadius: BorderRadius.circular(14))),
                      SizedBox(width: size.width * 0.02),
                      Container(height: size.height * 0.035,
                          width: size.width * 0.2,
                          decoration: BoxDecoration(color: Colors.white,
                              borderRadius: BorderRadius.circular(14))),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

// Like avatar
  Widget _buildShimmerLikeAvatar(Size size) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: [
          CircleAvatar(
              radius: size.width * 0.09, backgroundColor: Colors.grey[400]),
          SizedBox(height: size.height * 0.008),
          Container(
            height: size.height * 0.015,
            width: size.width * 0.15,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(6)),
          ),
        ],
      ),
    );
  }

// Call tile
  Widget _buildShimmerCallTile(Size size) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        padding: EdgeInsets.all(size.width * 0.03),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(size.width * 0.04),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            CircleAvatar(
                radius: size.width * 0.07, backgroundColor: Colors.grey[400]),
            SizedBox(width: size.width * 0.035),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: size.height * 0.022,
                      width: size.width * 0.35,
                      color: Colors.white),
                  SizedBox(height: size.height * 0.008),
                  Container(height: size.height * 0.018,
                      width: size.width * 0.25,
                      color: Colors.white),
                ],
              ),
            ),
            Column(
              children: [
                Icon(Icons.call_made, color: Colors.grey[400],
                    size: size.width * 0.05),
                SizedBox(height: size.height * 0.005),
                Container(height: size.height * 0.015,
                    width: size.width * 0.12,
                    color: Colors.white),
              ],
            ),
          ],
        ),
      ),
    );
  }
}