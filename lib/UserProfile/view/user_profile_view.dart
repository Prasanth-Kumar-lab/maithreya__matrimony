import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:matrimony/constants/constants.dart';
import '../model/userProfile_model.dart';
class MyProfileScreen extends StatelessWidget {
  final UserProfile user;

  const MyProfileScreen({Key? key, required this.user}) : super(key: key);

  Widget _buildInfoRow(String label, String? value, {IconData? icon}) {
    if (value == null || value.trim().isEmpty) return const SizedBox.shrink();
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
                    text: value,
                    style: const TextStyle(fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String imageUrl = (user.image != null && user.image!.isNotEmpty)
        ? user.image!
        : 'https://via.placeholder.com/150';

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
        elevation: 0,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: AppColors.bgThemeColor,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Header with profile image
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey.shade200,
                      backgroundImage: NetworkImage(imageUrl),
                      onBackgroundImageError: (_, __) {},
                      child: (user.image == null || user.image!.isEmpty)
                          ? const Icon(Icons.person, size: 60, color: Colors.grey)
                          : null,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "${user.name} ${user.lastname ?? ''} ${user.userId}".trim(),
                      style: textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo.shade800,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Basic Info Card
              _buildCardSection("Basic Info", [
                _buildInfoRow("Age", user.age, icon: Icons.cake),
                _buildInfoRow("Gender", user.gender, icon: Icons.person_outline),
                _buildInfoRow("Date of Birth", user.dateOfBirth, icon: Icons.calendar_today),
                _buildInfoRow("Marital Status", user.maritalStatus, icon: Icons.favorite_border),
                _buildInfoRow("Height", user.height, icon: Icons.height),
              ]),

              // Location Info
              _buildCardSection("Location", [
                _buildInfoRow("Native Place", user.nativePlace, icon: Icons.home_outlined),
                _buildInfoRow("State", user.stateName, icon: Icons.map_outlined),
                _buildInfoRow("City", user.city, icon: Icons.location_city),
              ]),

              // Education & Career
              _buildCardSection("Education & Career", [
                _buildInfoRow("Education", user.educationDetails, icon: Icons.school),
                _buildInfoRow("Profession", user.profession, icon: Icons.work_outline),
                _buildInfoRow("Role", user.role, icon: Icons.badge_outlined),
                _buildInfoRow("Organization", user.organization, icon: Icons.apartment_outlined),
                _buildInfoRow("Income", user.income, icon: Icons.attach_money),
              ]),

              // Family Info
              _buildCardSection("Family", [
                _buildInfoRow("Mother's Name", user.motherName, icon: Icons.female),
                _buildInfoRow("Father's Name", user.fatherName, icon: Icons.male),
                _buildInfoRow("Brothers", user.noOfBrothers, icon: Icons.groups_2_outlined),
                _buildInfoRow("Sisters", user.noOfSisters, icon: Icons.groups_3_outlined),
              ]),

              // Preferences
              _buildCardSection("Preferences", [
                _buildInfoRow("Food Preference", user.foodType, icon: Icons.restaurant_menu),
                _buildInfoRow("Hobbies", user.hobbies, icon: Icons.palette_outlined),
                _buildInfoRow("Favourite Movies", user.favouriteMovies, icon: Icons.movie),
                _buildInfoRow("Favourite Books", user.favouriteBooks, icon: Icons.book),
                _buildInfoRow("Other Interests", user.otherInterests, icon: Icons.star_border),
              ]),

              // Additional Info
              _buildCardSection("Additional Info", [
                _buildInfoRow("Birth Time", user.birthTime, icon: Icons.access_time),
                _buildInfoRow("About", user.about, icon: Icons.info_outline),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardSection(String title, List<Widget> children) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12),
      elevation: 2,
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
}

