import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:matrimony/constants/constants.dart';
/*
import '../../First Registration Process/widgets/profile_images_dialog.dart';
import '../controller/userProfile_controller.dart';
import '../model/userProfile_model.dart';

class UsersProfileScreen extends StatelessWidget {
  final UserProfile user;

  const UsersProfileScreen({Key? key, required this.user}) : super(key: key);

  /// Builds an info row and replaces null/empty values with a placeholder.
  Widget _buildInfoRow(String label, String? value, {IconData? icon}) {
    final displayValue =
    (value == null || value.trim().isEmpty) ? "Not provided" : value;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null)
            Padding(
              padding: const EdgeInsets.only(right: 8.0, top: 2),
              child: Icon(icon, size: 20, color: Colors.indigo),
            ),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 16, color: Colors.black87),
                children: [
                  TextSpan(
                    text: "$label: ",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: displayValue,
                    style: TextStyle(
                      color: (value == null || value.trim().isEmpty)
                          ? Colors.grey
                          : Colors.black87,
                      fontStyle: (value == null || value.trim().isEmpty)
                          ? FontStyle.italic
                          : FontStyle.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardSection(String title, List<Widget> children) {
    return Card(
      color: AppColors.profileSectionCard,
      margin: const EdgeInsets.symmetric(vertical: 12),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MyProfileController(user));
    final String imageUrl =
    (user.image != null && user.image!.isNotEmpty)
        ? user.image!
        : 'https://via.placeholder.com/150';

    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "",
          style: TextStyle(color: AppColors.textColor, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: AppColors.bgThemeColor,
        foregroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios, color: AppColors.appBarIconColor),
        ),
      ),
      body: SafeArea(
        child: Container(
          color: AppColors.bgThemeColor,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Profile header
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 70,
                        backgroundColor: Colors.grey.shade200,
                        backgroundImage: NetworkImage(imageUrl),
                        onBackgroundImageError: (_, __) {},
                        child: (user.image == null || user.image!.isEmpty)
                            ? const Icon(Icons.person, size: 60, color: Colors.grey)
                            : null,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "${user.name ?? ''} ".trim().isEmpty
                            ? "No name provided"
                            : "${user.name ?? ''} ${user.lastname ?? ''}".trim(),
                        style: textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 2),
                _buildPhotosSection(controller),
                // Info sections
                _buildCardSection("Basic Info", [
                  _buildInfoRow("Age", user.age, icon: Icons.cake),
                  _buildInfoRow("Gender", user.gender, icon: Icons.person_outline),
                  _buildInfoRow("Date of Birth", user.dateOfBirth, icon: Icons.calendar_today),
                  _buildInfoRow("Marital Status", user.maritalStatus, icon: Icons.favorite_border),
                  _buildInfoRow("Height", user.height, icon: Icons.height),
                ]),
                //Location Sections
                _buildCardSection("Location", [
                  _buildInfoRow("Native Place", user.nativePlace, icon: Icons.home_outlined),
                  _buildInfoRow("State", user.stateName, icon: Icons.map_outlined),
                  _buildInfoRow("City", user.city, icon: Icons.location_city),
                ]),
                //Education section
                _buildCardSection("Education & Career", [
                  _buildInfoRow("Education", user.educationDetails, icon: Icons.school),
                  _buildInfoRow("Profession", user.profession, icon: Icons.work_outline),
                  _buildInfoRow("Role", user.role, icon: Icons.badge_outlined),
                  _buildInfoRow("Organization", user.organization, icon: Icons.apartment_outlined),
                  _buildInfoRow("Income", user.income, icon: Icons.attach_money),
                ]),
                //Family Section
                _buildCardSection("Family", [
                  _buildInfoRow("Mother's Name", user.motherName, icon: Icons.female),
                  _buildInfoRow("Father's Name", user.fatherName, icon: Icons.male),
                  _buildInfoRow("Brothers", user.noOfBrothers, icon: Icons.groups_2_outlined),
                  _buildInfoRow("Sisters", user.noOfSisters, icon: Icons.groups_3_outlined),
                ]),
                //Interests
                _buildCardSection("Preferences", [
                  _buildInfoRow("Food Preference", user.foodType, icon: Icons.restaurant_menu),
                  _buildInfoRow("Hobbies", user.hobbies, icon: Icons.palette_outlined),
                  _buildInfoRow("Favourite Movies", user.favouriteMovies, icon: Icons.movie),
                  _buildInfoRow("Favourite Books", user.favouriteBooks, icon: Icons.book),
                  _buildInfoRow("Other Interests", user.otherInterests, icon: Icons.star_border),
                ]),
                //About yourself
                _buildCardSection("Additional Info", [
                  _buildInfoRow("Birth Time", user.birthTime, icon: Icons.access_time),
                  _buildInfoRow("About", user.about, icon: Icons.info_outline),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhotosSection(MyProfileController controller) {
    final photos = controller.user.photosList ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Text(
          "Photos",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(height: 8),
        if (photos.isEmpty)
          Container(
            height: 100,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text("No photos available", style: TextStyle(color: Colors.grey)),
          )
        else
          SizedBox(
            height: 120,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: photos.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    showPhotoDialog(
                      context: context,
                      photos: photos,
                      initialIndex: index,
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      photos[index],
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 120,
                        height: 120,
                        color: Colors.grey.shade300,
                        child: const Icon(Icons.broken_image, color: Colors.grey),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        const SizedBox(height: 16),
      ],
    );
  }
}
*/
import 'package:matrimony/HomeScreen/controller/home_screen_controller.dart';
import '../../First Registration Process/widgets/profile_images_dialog.dart';
import '../controller/userProfile_controller.dart';
import '../model/userProfile_model.dart';
class UsersProfileScreen extends StatelessWidget {
  final UserProfile user;
  const UsersProfileScreen({Key? key, required this.user}) : super(key: key);
  Widget _buildInfoRow(String label, String? value, {IconData? icon}) {
    final displayValue =
    (value == null || value.trim().isEmpty) ? "Not provided" : value;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null)
            Padding(
              padding: const EdgeInsets.only(right: 8.0, top: 2),
              child: Icon(icon, size: 20, color: Colors.indigo),
            ),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 16, color: Colors.black87),
                children: [
                  TextSpan(
                    text: "$label: ",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: displayValue,
                    style: TextStyle(
                      color: (value == null || value.trim().isEmpty)
                          ? Colors.grey
                          : Colors.black87,
                      fontStyle: (value == null || value.trim().isEmpty)
                          ? FontStyle.italic
                          : FontStyle.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardSection(String title, List<Widget> children) {
    return Card(
      color: AppColors.profileSectionCard,
      margin: const EdgeInsets.symmetric(vertical: 12),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();
    final myProfileController = Get.put(MyProfileController(user));

    final String imageUrl = (user.image != null && user.image!.isNotEmpty)
        ? user.image!
        : 'https://via.placeholder.com/150';

    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "",
          style:
          TextStyle(color: AppColors.textColor, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: AppColors.bgThemeColor,
        foregroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios, color: AppColors.appBarIconColor),
        ),
      ),
      body: SafeArea(
        child: Container(
          color: AppColors.bgThemeColor,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Profile Header
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 70,
                        backgroundColor: Colors.grey.shade200,
                        backgroundImage: NetworkImage(imageUrl),
                        onBackgroundImageError: (_, __) {},
                        child: (user.image == null || user.image!.isEmpty)
                            ? const Icon(Icons.person,
                            size: 60, color: Colors.grey)
                            : null,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "${user.name ?? ''} ${user.lastname ?? ''}".trim().isEmpty
                            ? "No name provided"
                            : "${user.name ?? ''} ${user.lastname ?? ''}".trim(),
                        style: textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 2),
                _buildPhotosSection(myProfileController),

                // Info Sections
                _buildCardSection("Basic Info", [
                  _buildInfoRow("Age", user.age, icon: Icons.cake),
                  _buildInfoRow("Gender", user.gender,
                      icon: Icons.person_outline),
                  _buildInfoRow("Date of Birth", user.dateOfBirth,
                      icon: Icons.calendar_today),
                  _buildInfoRow("Marital Status", user.maritalStatus,
                      icon: Icons.favorite_border),
                  _buildInfoRow("Height", user.height, icon: Icons.height),
                ]),
                _buildCardSection("Location", [
                  _buildInfoRow("Native Place", user.nativePlace,
                      icon: Icons.home_outlined),
                  _buildInfoRow("State", user.stateName, icon: Icons.map_outlined),
                  _buildInfoRow("City", user.city, icon: Icons.location_city),
                ]),
                _buildCardSection("Education & Career", [
                  _buildInfoRow("Education", user.educationDetails,
                      icon: Icons.school),
                  _buildInfoRow("Profession", user.profession,
                      icon: Icons.work_outline),
                  _buildInfoRow("Role", user.role, icon: Icons.badge_outlined),
                  _buildInfoRow("Organization", user.organization,
                      icon: Icons.apartment_outlined),
                  _buildInfoRow("Income", user.income, icon: Icons.attach_money),
                ]),
                _buildCardSection("Family", [
                  _buildInfoRow("Mother's Name", user.motherName,
                      icon: Icons.female),
                  _buildInfoRow("Father's Name", user.fatherName,
                      icon: Icons.male),
                  _buildInfoRow("Brothers", user.noOfBrothers,
                      icon: Icons.groups_2_outlined),
                  _buildInfoRow("Sisters", user.noOfSisters,
                      icon: Icons.groups_3_outlined),
                ]),
                _buildCardSection("Preferences", [
                  _buildInfoRow("Food Preference", user.foodType,
                      icon: Icons.restaurant_menu),
                  _buildInfoRow("Hobbies", user.hobbies,
                      icon: Icons.palette_outlined),
                  _buildInfoRow("Favourite Movies", user.favouriteMovies,
                      icon: Icons.movie),
                  _buildInfoRow("Favourite Books", user.favouriteBooks,
                      icon: Icons.book),
                  _buildInfoRow("Other Interests", user.otherInterests,
                      icon: Icons.star_border),
                ]),
                _buildCardSection("Additional Info", [
                  _buildInfoRow("Birth Time", user.birthTime,
                      icon: Icons.access_time),
                  _buildInfoRow("About", user.about,
                      icon: Icons.info_outline),
                ]),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),

      // ✅ Floating Action Buttons (replaces Positioned)
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── CALL ──
          _buildFAB(
            icon: Icons.call,
            gradient: const LinearGradient(colors: [Colors.green, Colors.teal]),
            onTap: () async => await homeController.launchCall(),
            tooltip: 'Call',
          ),
          const SizedBox(width: 12),

          // ── MESSAGE ──
          _buildFAB(
            icon: Icons.message,
            gradient: const LinearGradient(colors: [Colors.blue, Colors.indigo]),
            onTap: () async => await homeController.launchMessaging(),
            tooltip: 'Message',
          ),
          const SizedBox(width: 12),

          // ── FAVOURITE (with Lottie + dynamic background) ──
          Builder(
            builder: (context) {
              bool isAnimating = false;
              return StatefulBuilder(
                builder: (context, setState) {
                  return _buildFAB(
                    icon: Icons.favorite,
                    // Dynamic gradient: gold-orange when animating, else pink-red
                    gradient: isAnimating
                        ? const LinearGradient(colors: [Colors.amber, Colors.orange])
                        : const LinearGradient(colors: [Colors.pink, Colors.redAccent]),
                    onTap: () async {
                      if (isAnimating) return;
                      setState(() => isAnimating = true);

                      await homeController.likeProfile(user.userId);
                      Get.snackbar(
                        'Success',
                        'Added to favourites!',
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                      );

                      await Future.delayed(const Duration(milliseconds: 800));
                      setState(() => isAnimating = false);
                    },
                    tooltip: 'Add to Favourites',
                    child: isAnimating
                        ? Lottie.asset(
                      'assets/like (2).json',
                      width: 32,
                      height: 32,
                      fit: BoxFit.contain,
                      repeat: false,
                    )
                        : const Icon(Icons.favorite, color: Colors.white, size: 28),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  // ✅ Reusable Gradient FAB
  Widget _buildFAB({
    required IconData icon,
    required Gradient gradient,
    required VoidCallback onTap,
    required String tooltip,
    Widget? child, // ← NEW: optional custom child
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            gradient: gradient,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: gradient.colors.first.withOpacity(0.6),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: child ?? Icon(icon, color: Colors.white, size: 28),
        ),
      ),
    );
  }

  Widget _buildPhotosSection(MyProfileController controller) {
    final photos = controller.user.photosList ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16),
        const Text(
          "Photos",
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(height: 8),
        if (photos.isEmpty)
          Container(
            height: 100,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            child:
            const Text("No photos available", style: TextStyle(color: Colors.grey)),
          )
        else
          SizedBox(
            height: 120,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: photos.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    showPhotoDialog(
                      context: context,
                      photos: photos,
                      initialIndex: index,
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      photos[index],
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 120,
                        height: 120,
                        color: Colors.grey.shade300,
                        child:
                        const Icon(Icons.broken_image, color: Colors.grey),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        const SizedBox(height: 16),
      ],
    );
  }
}
