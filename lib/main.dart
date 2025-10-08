import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:matrimony/HomeScreen/view/home_screen_view.dart';
import 'package:matrimony/themeController.dart';
import 'LoginPage/view/loginpage_view.dart';
import 'Onboardings/view/onboarding_view.dart';
import 'ProfilePage/controller/profile_controller.dart';
import 'SignUp/view/signup_view.dart';
import 'SplashScreen/view/splashScreen_view.dart';

void main() {
  runApp(const MyApp());
  Get.put(ProfileController());
  Get.put(ThemeController());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    return Obx(() => GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Matrimony App',
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: themeController.isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
      initialRoute: '/splash',
      getPages: [
        GetPage(name: '/splash', page: () => SplashView()),
        GetPage(name: '/onboarding', page: () => OnboardingView()),
        GetPage(name: '/login', page: () => LoginView()),
        GetPage(name: '/signup', page: () => SignupView()),
        GetPage(name: '/home', page: () => HomeScreen()),
        GetPage(name: '/forgot_password', page: () => Center(child: Text('data'),)),
      ],
    ));
  }
}