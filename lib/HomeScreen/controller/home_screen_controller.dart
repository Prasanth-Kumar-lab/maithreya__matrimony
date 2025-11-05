/*
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_swipecards/flutter_swipecards.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:matrimony/Messages/view/messages_view.dart';
import 'package:matrimony/MatchPage/view/match_page.dart';
import 'package:matrimony/HomeScreen/view/home_screen_view.dart';
import 'package:matrimony/Plans/view/plans_view.dart';
import 'package:matrimony/accessToken.dart';
import 'package:matrimony/apiEndPoint.dart';
import '../../UserProfile/model/userProfile_model.dart';
import '../../UserProfile/view/user_profile_view.dart';
import '../model/home_screen_model.dart';
class HomeController extends GetxController {
  final CardController cardController = CardController();
  var cardIndex = 0.obs;
  var selectedTabIndex = 0.obs;
  var users = <UserProfiles>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var userProfile = Rxn<UserProfiles>();
  late String currentUserId;
  String currentUserGender = '';
  HomeController({required String userId}) {
    currentUserId = userId;
  }
  @override
  void onInit() {
    super.onInit();
    fetchCurrentUserProfile();
  }
  Future<void> fetchCurrentUserProfile() async {
    try {
      final response = await http.post(
        Uri.parse(ApiEndPoint.listProfileApi),
        body: {'user_id': currentUserId},
      );
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        if (jsonList.isNotEmpty) {
          final currentUserData = jsonList[0];
          currentUserGender = currentUserData['gender']?.toString().toLowerCase() ?? '';
          // Now fetch all user profiles with gender filtering
          await fetchUserProfiles();
        }
      }
    } catch (e) {
      print('Error fetching current user profile: $e');
      errorMessage.value = 'Error loading profile';
    }
  }
  // Check if we should show this user based on gender
  bool shouldShowUser(UserProfiles user) {
    // Skip if it's the current user
    if (user.userId.toString() == currentUserId.toString()) {
      return false;
    }
    // If current user gender is not set, show all profiles (fallback)
    if (currentUserGender.isEmpty) {
      return true;
    }
    // Show all profiles EXCEPT the current user's gender
    return user.gender.toLowerCase() != currentUserGender.toLowerCase();
  }
  Future<void> fetchUserProfiles() async {
    try {
      isLoading.value = true;
      final response = await http.get(Uri.parse(ApiEndPoint.listProfileApi));
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        List<dynamic> data;
        if (decoded is List) {
          data = decoded;
        } else if (decoded is Map && decoded['data'] is List) {
          data = decoded['data'];
        } else {
          throw Exception('Unexpected response format');
        }
        // Filter users based on gender and remove current user
        final List<UserProfiles> fetchedUsers = data
            .map((json) => UserProfiles.fromJson(json))
            .where((user) => shouldShowUser(user)) // Apply gender filter
            .toList();
        fetchedUsers.shuffle(Random());
        users.value = fetchedUsers;
        cardIndex.value = 0;
        errorMessage.value = '';
        // Print user IDs and tokens
        for (var user in users) {
          print('User ID: ${user.userId}, Gender: ${user.gender}, Device Token: ${user.deviceToken}');
        }
        // Print filtering info
        print('Current user gender: $currentUserGender');
        print('Showing ${users.length} profiles (excluding $currentUserGender gender)');
      } else {
        errorMessage.value = 'Failed to load users: ${response.statusCode}';
      }
    } catch (e) {
      errorMessage.value = 'Error fetching users: $e';
    } finally {
      isLoading.value = false;
    }
  }
  Future<UserProfile?> fetchMyProfile(String userId) async {
    final response = await http.post(
      Uri.parse(ApiEndPoint.listProfileApi),
      body: {'user_id': userId},
    );
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      if (jsonList.isNotEmpty) {
        return UserProfile.fromJson(jsonList[0]);
      }
    }
    return null;
  }
  Future<void> sendPushNotification({
    required String deviceToken,
    String title = 'New Like!',
    String body = 'Someone liked your profile!',
  }) async {
    if (deviceToken.isEmpty) {
      print('No device token found.');
      return;
    }
    try {
      final serverKey = await GetServerKey().getServerKeyToken();
      final payload = jsonEncode({
        "message": {
          "token": deviceToken,
          "notification": {
            "title": title,
            "body": body,
          },
          "data": {
            "click_action": "FLUTTER_NOTIFICATION_CLICK",
            "type": "like_notification",
          }
        }
      });
      final response = await http.post(
        Uri.parse(ApiEndPoint.pushNotificationEndPoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $serverKey',
        },
        body: payload,
      );
      if (response.statusCode == 200) {
        print('Push notification sent to $deviceToken');
      } else {
        print('Failed to send notification: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      print('Error sending notification: $e');
    }
  }
  Future<void> likeProfile(String likedUserId) async {
    try {
      final serverKey = await GetServerKey().getServerKeyToken();
      print('Dynamic Server Key Token: $serverKey');
      final response = await http.post(
        Uri.parse(ApiEndPoint.wishlistApi),
        body: {
          'user_id': currentUserId,
          'profile_id': likedUserId,
        },
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          Get.snackbar(
            'Success',
            'Profile liked successfully!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          cardController.triggerUp();
          final likedUser = users.firstWhere((user) => user.userId == likedUserId);
          if (likedUser.deviceToken.isNotEmpty) {
            await sendPushNotification(
              deviceToken: likedUser.deviceToken,
              title: 'New Like!',
              body: '${userProfile.value?.name ?? 'Someone'} liked your profile!',
            );
          } else {
            print('⚠️ Liked user has no device token.');
          }
        } else {
          Get.snackbar(
            'Error',
            responseData['message'] ?? 'Failed to like profile',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          'Error',
          'Failed to like profile: ${response.statusCode}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error liking profile: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }
  void setSelectedTabIndex(int index) {
    selectedTabIndex.value = index;
    navigateToScreen(index);
  }
  void navigateToScreen(int index) {
    switch (index) {
      case 0:
        if (Get.currentRoute != '/home') {
          Get.offAll(() => HomeScreen(userId: currentUserId));
        }
        break;
      case 1:
        Get.to(() => MatchesScreen(userId: currentUserId), preventDuplicates: true);
        break;
      case 2:
        Get.to(() => MessagesView(), preventDuplicates: true);
        break;
      case 3:
        if (Get.context != null) {
          fetchMyProfile(currentUserId).then((user) {
            if (user != null) {
              Get.to(() => MyProfileScreen(user: user));
            }
          });
        }
        break;
      case 4:
        Get.to(() => PlansScreen(), preventDuplicates: true);
        break;
    }
  }
  void swipeLeft() => cardController.triggerLeft();
  void swipeRight() => cardController.triggerRight();
  void swipeUp() {
    if (users.isNotEmpty && cardIndex.value < users.length) {
      final likedUserId = users[cardIndex.value].userId;
      likeProfile(likedUserId);
    } else {
      Get.snackbar(
        'Error',
        'No profile available to like',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }
}*/
import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_swipecards/flutter_swipecards.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:matrimony/Messages/view/messages_view.dart';
import 'package:matrimony/MatchPage/view/match_page.dart';
import 'package:matrimony/HomeScreen/view/home_screen_view.dart';
import 'package:matrimony/Plans/view/plans_view.dart';
import 'package:matrimony/accessToken.dart';
import 'package:matrimony/apiEndPoint.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../MatchPage/model/matches_page.dart';
import '../../UserProfile/model/userProfile_model.dart';
import '../../UserProfile/view/user_profile_view.dart';
import '../model/home_screen_model.dart';

class HomeController extends GetxController {
  final CardController cardController = CardController();
  var cardIndex = 0.obs;
  var selectedTabIndex = 0.obs;
  var users = <UserProfiles>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var userProfile = Rxn<UserProfiles>();

  late String currentUserId;
  String currentUserGender = '';
  var currentUserName = ''.obs; // Stores name of the logged-in user

  HomeController({required String userId}) {
    currentUserId = userId;
  }

  @override
  void onInit() {
    super.onInit();
    fetchCurrentUserProfile();
  }

  /// Returns `true` if `profileId` is already in the current user’s “liked” list.
  Future<bool> _isAlreadyLiked(String profileId) async {
    try {
      final resp = await http.post(
        Uri.parse(ApiEndPoint.wishlistApi),
        body: {'user_id': currentUserId, 'type': 'liked'},
      );
      if (resp.statusCode == 200) {
        final data = MatchResponse.fromJson(json.decode(resp.body));
        return data.data.any((e) => e['id'].toString() == profileId);
      }
    } catch (_) {}
    return false;
  }

  Future<void> launchCall() async {
    final user = _currentCardUser;
    if (user == null) {
      _showError('No profile available to call');
      return;
    }
    await _makeCall(user.number);
  }

  /// Sends a pre-filled SMS to the current card user (if any)
  Future<void> launchMessaging() async {
    final user = _currentCardUser;
    if (user == null) {
      _showError('No profile available to message');
      return;
    }

    final sender = await fetchMyProfile(currentUserId);
    final dynamicMessage = sender != null
        ? "Namaste ${user.name}, I am ${sender.name} from Jeevan Saathiya. "
        "I came across your profile and found it truly inspiring. "
        "Would love to connect and learn more about your journey. "
        "Looking forward to your thoughts!"
        : "Namaste ${user.name}, I came across your profile on Jeevan Saathiya "
        "and would love to connect. Looking forward to knowing you better!";

    await _openSms(user.number, dynamicMessage);
  }

  UserProfiles? get _currentCardUser {
    if (users.isEmpty || cardIndex.value >= users.length) return null;
    return users[cardIndex.value];
  }

  void _showError(String msg) {
    Get.snackbar(
      'Error',
      msg,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
    );
  }

  Future<void> _makeCall(String number) async {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      debugPrint("Device FCM Token (on call): $token");

      if (defaultTargetPlatform == TargetPlatform.android) {
        final made = await FlutterPhoneDirectCaller.callNumber(number);
        if (made == false) _showError('Could not make the call');
      } else {
        final uri = Uri(scheme: 'tel', path: number);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        } else {
          _showError('Could not launch call');
        }
      }
    } catch (e) {
      debugPrint("Error making call: $e");
      _showError('Call failed');
    }
  }

  Future<void> _openSms(String number, String message) async {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      debugPrint("Device FCM Token (on sms): $token");

      final uri = Uri(
        scheme: 'sms',
        path: number,
        queryParameters: {'body': message},
      );

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        _showError('Could not launch messaging');
      }
    } catch (e) {
      debugPrint("Error opening SMS: $e");
      _showError('Messaging failed');
    }
  }
  Future<void> fetchCurrentUserProfile() async {
    try {
      final response = await http.post(
        Uri.parse(ApiEndPoint.listProfileApi),
        body: {'user_id': currentUserId},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        if (jsonList.isNotEmpty) {
          final currentUserData = jsonList[0];

          // Set gender
          currentUserGender = currentUserData['gender']?.toString().toLowerCase() ?? '';

          // Set name (for dynamic notification)
          currentUserName.value = currentUserData['name']?.toString().trim() ?? 'Someone';

          // Now fetch other profiles
          await fetchUserProfiles();
        }
      }
    } catch (e) {
      print('Error fetching current user profile: $e');
      errorMessage.value = 'Error loading profile';
    }
  }

  // Filter: show only opposite gender, skip self
  bool shouldShowUser(UserProfiles user) {
    if (user.userId.toString() == currentUserId.toString()) {
      return false;
    }
    if (currentUserGender.isEmpty) return true;
    return user.gender.toLowerCase() != currentUserGender.toLowerCase();
  }

  // Fetch all profiles and apply filtering
  Future<void> fetchUserProfiles() async {
    try {
      isLoading.value = true;
      final response = await http.get(Uri.parse(ApiEndPoint.listProfileApi));

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        List<dynamic> data;

        if (decoded is List) {
          data = decoded;
        } else if (decoded is Map && decoded['data'] is List) {
          data = decoded['data'];
        } else {
          throw Exception('Unexpected response format');
        }

        // 1. First get the IDs the current user has already liked
        final likedResp = await http.post(
          Uri.parse(ApiEndPoint.wishlistApi),
          body: {'user_id': currentUserId, 'type': 'liked'},
        );
        final Set<String> alreadyLikedIds = <String>{};
        if (likedResp.statusCode == 200) {
          final liked = MatchResponse.fromJson(json.decode(likedResp.body));
          alreadyLikedIds.addAll(
            liked.data.map((e) => e['id'].toString()),
          );
        }


        final List<UserProfiles> fetchedUsers = data
            .map((json) => UserProfiles.fromJson(json))
            .where((user) {
          // skip self
          if (user.userId.toString() == currentUserId) return false;
          // opposite gender
          if (currentUserGender.isNotEmpty &&
              user.gender.toLowerCase() == currentUserGender.toLowerCase()) {
            return false;
          }
          // skip already liked
          if (alreadyLikedIds.contains(user.userId.toString())) return false;
          return true;
        })
            .toList();

        fetchedUsers.shuffle(Random());
        users.value = fetchedUsers;
        cardIndex.value = 0;
        errorMessage.value = '';

        // Debug
        print('Current user: $currentUserName ($currentUserGender) → '
            'Showing ${users.length} profiles (already liked filtered out)');
      } else {
        errorMessage.value = 'Failed to load users: ${response.statusCode}';
      }
    } catch (e) {
      errorMessage.value = 'Error fetching users: $e';
    } finally {
      isLoading.value = false;
    }
  }
  /*Future<void> fetchUserProfiles() async {
    try {
      isLoading.value = true;
      final response = await http.get(Uri.parse(ApiEndPoint.listProfileApi));

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        List<dynamic> data;

        if (decoded is List) {
          data = decoded;
        } else if (decoded is Map && decoded['data'] is List) {
          data = decoded['data'];
        } else {
          throw Exception('Unexpected response format');
        }

        final List<UserProfiles> fetchedUsers = data
            .map((json) => UserProfiles.fromJson(json))
            .where((user) => shouldShowUser(user))
            .toList();

        fetchedUsers.shuffle(Random());
        users.value = fetchedUsers;
        cardIndex.value = 0;
        errorMessage.value = '';

        // Debug logs
        for (var user in users) {
          print('User ID: ${user.userId}, Gender: ${user.gender}, Token: ${user.deviceToken}');
        }
        print('Current user: $currentUserName ($currentUserGender) → Showing ${users.length} profiles');
      } else {
        errorMessage.value = 'Failed to load users: ${response.statusCode}';
      }
    } catch (e) {
      errorMessage.value = 'Error fetching users: $e';
    } finally {
      isLoading.value = false;
    }
  }*/

  // Fetch single profile (for My Profile tab)
  Future<UserProfile?> fetchMyProfile(String userId) async {
    final response = await http.post(
      Uri.parse(ApiEndPoint.listProfileApi),
      body: {'user_id': userId},
    );
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      if (jsonList.isNotEmpty) {
        return UserProfile.fromJson(jsonList[0]);
      }
    }
    return null;
  }

  // Send push notification with dynamic name
  Future<void> sendPushNotification({
    required String deviceToken,
    String title = 'New Like!',
    String body = 'Someone liked your profile!',
  }) async {
    if (deviceToken.isEmpty) {
      print('No device token found.');
      return;
    }

    try {
      final serverKey = await GetServerKey().getServerKeyToken();
      final payload = jsonEncode({
        "message": {
          "token": deviceToken,
          "notification": {
            "title": title,
            "body": body,
          },
          "data": {
            "click_action": "FLUTTER_NOTIFICATION_CLICK",
            "type": "like_notification",
          }
        }
      });

      final response = await http.post(
        Uri.parse(ApiEndPoint.pushNotificationEndPoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $serverKey',
        },
        body: payload,
      );

      if (response.statusCode == 200) {
        print('Push notification sent to $deviceToken: "$body"');
      } else {
        print('Failed to send notification: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      print('Error sending notification: $e');
    }
  }

  // Like a profile + send dynamic notification
  Future<void> likeProfile(String likedUserId) async {
    try {
      final serverKey = await GetServerKey().getServerKeyToken();
      print('Server Key: $serverKey');

      final response = await http.post(
        Uri.parse(ApiEndPoint.wishlistApi),
        body: {
          'user_id': currentUserId,
          'profile_id': likedUserId,
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData['status'] == 'success') {

          // Find liked user
          final likedUser = users.firstWhere((user) => user.userId == likedUserId);

          // Send notification with current user's name
          if (likedUser.deviceToken.isNotEmpty) {
            await sendPushNotification(
              deviceToken: likedUser.deviceToken,
              title: 'New Like!',
              body: '$currentUserName liked your profile!', // Dynamic name
            );
          } else {
            print('Liked user has no device token.');
          }
        } else {
          Get.snackbar(
            'Error',
            responseData['message'] ?? 'Failed to like profile',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          'Error',
          'Failed to like profile: ${response.statusCode}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error liking profile: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  // Bottom Navigation
  void setSelectedTabIndex(int index) {
    selectedTabIndex.value = index;
    navigateToScreen(index);
  }

  void navigateToScreen(int index) {
    switch (index) {
      case 0:
        if (Get.currentRoute != '/home') {
          Get.offAll(() => HomeScreen(userId: currentUserId));
        }
        break;
      case 1:
        Get.to(() => MatchesScreen(userId: currentUserId), preventDuplicates: true);
        break;
      case 2:
        if (Get.context != null) {
          fetchMyProfile(currentUserId).then((user) {
            if (user != null) {
              Get.to(() => MyProfileScreen(user: user));
            }
          });
        }
        break;
      case 3:
        Get.to(() => PlansScreen(), preventDuplicates: true);
        break;
    }
  }

  // Swipe Actions
  void swipeLeft() => cardController.triggerLeft();
  void swipeRight() => cardController.triggerRight();

  // Swipe Up = Like
  void swipeUp() {
    if (users.isEmpty || cardIndex.value >= users.length) {
      Get.snackbar(
        'Error',
        'No profile available to like',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    final likedUserId = users[cardIndex.value].userId;
    likeProfile(likedUserId).then((_) {
      cardController.triggerUp();
    });
  }
}