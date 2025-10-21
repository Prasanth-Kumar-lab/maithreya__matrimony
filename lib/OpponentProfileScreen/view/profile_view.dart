import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../constants/constants.dart'; // Import your colors and constants here

class ProfileViewScreen extends StatelessWidget {
  const ProfileViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgThemeColor,
      appBar: AppBar(
        backgroundColor: AppColors.bgThemeColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Profile View",
          style: TextStyle(
            color: AppColors.textColor,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: EdgeInsets.all(8),
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
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
        children: [
          Container(
            height: 350,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(15),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      'assets/kajal.jpg', // Replace with actual profile image path
                      //fit: BoxFit.cover,
                      //alignment: Alignment.topCenter,
                    ),
                  ),
                  /*Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: 80,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.blueAccent.withOpacity(0.9),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),*/
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Name, Age, Location
          Text(
            "John Doe",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textColor
            ),
          ).animate(onPlay: (controller) => controller.repeat()).shimmer(
            duration: 2000.ms,
            color: AppColors.textAnimateColor
          ),
          const SizedBox(height: 4),
          Text(
            "28, New York",
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textColor,
              //opacity: 0.7,
            ),
          ),
          const SizedBox(height: 24),

          // About Section
          Text(
            "About",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "I am passionate about exploring new places, trying out different recipes in the kitchen, and going on outdoor adventures. "
                "In my free time, I enjoy hiking, cooking, and traveling to experience different cultures.",
            style: TextStyle(
              fontSize: 16,
              height: 1.5,
              color: AppColors.textColor,
            ),
          ),
          const SizedBox(height: 32),

          // Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonColor,
                  padding:
                  EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 4,
                  shadowColor: Colors.blueAccent.withOpacity(0.4),
                ),
                onPressed: () {
                  // Like action
                },
                icon: Icon(Icons.favorite_border, color: AppColors.buttonIconColor),
                label: Text("Like",style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textColor,),),
              ),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  //foregroundColor: Colors.blueAccent,
                  backgroundColor: AppColors.buttonColor,
                  padding:
                  EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  side: BorderSide(color: Colors.blueAccent),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  // Message action
                },
                icon: Icon(Icons.chat_bubble_outline,color: AppColors.buttonIconColor,),
                label: Text("Message", style: TextStyle(color: AppColors.textColor, fontWeight: FontWeight.bold),),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
