import 'package:flutter/material.dart';
import '../../First Registration Process/ProfilePage/model/profile_model.dart';
import '../../OpponentProfileScreen/view/profile_view.dart';
import '../controller/match_controller.dart';

class MatchesScreen extends StatelessWidget {
  const MatchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = MatchesController();
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        flexibleSpace: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.notifications, size: 24),
                  ),
                ),
                const Text(
                  "Matches",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        children: [
          _buildSection(
            title: "Liked Profiles",
            profiles: controller.likedProfiles,
            size: size,
            context: context,
          ),
          _buildSection(
            title: "My Profile Liked Profiles",
            profiles: controller.myProfileLikedProfiles,
            size: size,
            context: context,
          ),
          _buildSection(
            title: "Shortlisted Profiles",
            profiles: controller.shortlistedProfiles,
            size: size,
            context: context,
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<ProfileModel> profiles,
    required Size size,
    required BuildContext context,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            height: 1.5,
          ),
        ),
        const Text(
          "Matches",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: profiles.map((profile) {
              return Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfileViewScreen(),
                      ),
                    );
                  },
                  child: Container(
                    width: (size.width - 55) / 2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[200],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(10),
                            ),
                            color: Colors.grey[400],
                            image: profile.imageUrl.isNotEmpty
                                ? DecorationImage(
                              image: NetworkImage(profile.imageUrl),
                              fit: BoxFit.cover,
                            )
                                : null,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                profile.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                profile.ageLocation,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
