import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:matrimony/HomeScreen/controller/home_screen_controller.dart';
import 'package:matrimony/HomeScreen/view/home_screen_view.dart';
import 'package:matrimony/firebase_options.dart';
import 'package:matrimony/themeController.dart';
import 'package:permission_handler/permission_handler.dart';
import 'LoginPage/view/loginpage_view.dart';
import 'SignUp/view/signup_view.dart';
import 'SplashScreen/view/splashScreen_view.dart';
import 'notificationService.dart';
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // No need to show local notification here – FCM handles tray display automatically
  print('Background message: ${message.notification?.title}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.phone.request();
  await Permission.location.request();
  await Permission.sms.request();
  await Permission.camera.request();
  await Permission.photos.request();
  await Permission.notification.request();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await NotificationService.initialize();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
  //Get.put(ProfileController());
  Get.put(ThemeController());
  //Get.put(HomeController());
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
        primaryColor: Colors.deepOrange,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.deepOrange,
          foregroundColor: Colors.white,
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepOrange,
          brightness: Brightness.light,
        ),
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
        //GetPage(name: '/onboarding', page: () => OnboardingView()),
        //GetPage(name: '/matches', page: () => MatchesScreen()),
        GetPage(name: '/login', page: () => LoginView()),
        GetPage(name: '/signup', page: () => SignupView()),
        GetPage(name: '/home', page: () => HomeScreen(userId: Get.find<HomeController>().currentUserId)),
      ],
    ));
  }
}