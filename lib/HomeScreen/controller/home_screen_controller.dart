/*
import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_swipecards/flutter_swipecards.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
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

    // Show confirmation dialog
    final confirmed = await _showCallConfirmationDialog(user.name);
    if (!confirmed) return;

    // Record the call via API
    final recorded = await _recordCall(user.userId);
    if (!recorded) {
      _showError('Failed to record call. Proceeding with call anyway.');
    }

    // Proceed with actual call
    await _makeCall(user.number);
  }

  /// Shows a professional confirmation dialog for calling a user
  Future<bool> _showCallConfirmationDialog(String userName) async {
    return await Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.call_outlined, color: Colors.green, size: 24),
            SizedBox(width: 8),
            Text('Confirm Call', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('You are about to call $userName.'),
            SizedBox(height: 8),
            Text(
              'This action will be recorded for your call history. Ensure you are in a quiet environment for a meaningful conversation.',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text('Call', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      barrierDismissible: false,
    ) ?? false;
  }

  /// Records the call via the provided API
  Future<bool> _recordCall(String calledUserId) async {
    try {
      final response = await http.post(
        Uri.parse(ApiEndPoint.callHistoryEndPoint),
        body: {
          'user_id': currentUserId,
          'called_user_id': calledUserId,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['status'] == 'success';
      }
    } catch (e) {
      print('Error recording call: $e');
    }
    return false;
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
}*/
import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:matrimony/accessToken.dart';
import 'package:matrimony/apiEndPoint.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../MatchPage/controller/matches_page_controller.dart';
import '../../MatchPage/model/matches_page.dart';
import '../../UserProfile/model/userProfile_model.dart';
import '../model/home_screen_model.dart';

class HomeController extends GetxController {
  var cardIndex = 0.obs;
  var selectedTabIndex = 0.obs;
  var users = <UserProfiles>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var userProfile = Rxn<UserProfile>();

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

  Future<void> launchCall() async {
    final user = _currentCardUser;
    if (user == null) {
      _showError('No profile available to call');
      return;
    }

    // Show confirmation dialog
    final confirmed = await _showCallConfirmationDialog(user.name);
    if (!confirmed) return;

    // Record the call via API
    final recorded = await _recordCall(user.userId);
    if (!recorded) {
      _showError('Failed to record call. Proceeding with call anyway.');
    }

    // Proceed with actual call
    await _makeCall(user.number);
  }

  /// Shows a professional confirmation dialog for calling a user
  Future<bool> _showCallConfirmationDialog(String userName) async {
    return await Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.call_outlined, color: Colors.green, size: 24),
            SizedBox(width: 8),
            Text('Confirm Call', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('You are about to call $userName.'),
            SizedBox(height: 8),
            Text(
              'This action will be recorded for your call history. Ensure you are in a quiet environment for a meaningful conversation.',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text('Call', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      barrierDismissible: false,
    ) ?? false;
  }

  /// Records the call via the provided API
  Future<bool> _recordCall(String calledUserId) async {
    try {
      final response = await http.post(
        Uri.parse(ApiEndPoint.callHistoryEndPoint),
        body: {
          'user_id': currentUserId,
          'called_user_id': calledUserId,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['status'] == 'success';
      }
    } catch (e) {
      print('Error recording call: $e');
    }
    return false;
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

          // Set full profile
          userProfile.value = UserProfile.fromJson(currentUserData);

          // Now fetch other profiles
          await fetchUserProfiles();
        }
      }
    } catch (e) {
      print('Error fetching current user profile: $e');
      errorMessage.value = 'Error loading profile';
    }
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
          throw Exception('Unexpected response format.');
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
        /*final List<UserProfiles> fetchedUsers = data
            .map((json) => UserProfiles.fromJson(json))
            .where((user) {
          // Skip self
          if (user.userId.toString() == currentUserId) return false;

          // Normalize both genders for comparison
          final String normalizedCurrentGender = currentUserGender.toLowerCase().trim();
          final String normalizedUserGender = (user.gender ?? '').toLowerCase().trim();

          // Debug: Remove later
          print('Current gender: "$normalizedCurrentGender" | User ${user.userId} gender: "$normalizedUserGender"');

          // Skip if same gender (only if current gender is known)
          if (normalizedCurrentGender.isNotEmpty &&
              normalizedUserGender == normalizedCurrentGender) {
            print('Skipping same gender: ${user.name}');
            return false;
          }

          // Skip already liked
          if (alreadyLikedIds.contains(user.userId.toString())) return false;

          return true;
        })
            .toList();*/
        final List<UserProfiles> fetchedUsers = data
            .map((json) => UserProfiles.fromJson(json))
            .where((user) {
          // 1. Skip current user (self)
          if (user.userId.toString() == currentUserId) {
            return false;
          }

          // 2. Normalize genders safely
          final String currentGenderNormalized = currentUserGender
              .toLowerCase()
              .trim()
              .replaceAll(RegExp(r'[^a-z]'), ''); // removes spaces, symbols etc.

          final String userGenderNormalized = (user.gender ?? '')
              .toLowerCase()
              .trim()
              .replaceAll(RegExp(r'[^a-z]'), '');

          // Map common variations to standard 'male' or 'female'
          String standardizeGender(String g) {
            if (g.startsWith('male') || g == 'm') return 'male';
            if (g.startsWith('female') || g == 'f') return 'female';
            return g; // unknown
          }

          final String currentStd = standardizeGender(currentGenderNormalized);
          final String userStd = standardizeGender(userGenderNormalized);

          // 3. If current user's gender is unknown or empty → skip ALL filtering (or show none)
          // But as per your requirement: if current gender unknown → show NO profiles
          if (currentStd.isEmpty || currentStd != 'male' && currentStd != 'female') {
            print('Current user gender unknown or invalid: "$currentUserGender" → Showing no profiles');
            return false; // This will result in empty list if current user has no valid gender
          }

          // 4. If other user's gender is null, empty, or invalid → SKIP them
          if (userStd.isEmpty || (userStd != 'male' && userStd != 'female')) {
            print('Skipping user ${user.name} - invalid/null gender: "${user.gender}"');
            return false;
          }

          // 5. Now check: Must be OPPOSITE gender
          if (currentStd == 'male' && userStd != 'female') {
            return false;
          }
          if (currentStd == 'female' && userStd != 'male') {
            return false;
          }

          // 6. Skip already liked profiles
          if (alreadyLikedIds.contains(user.userId.toString())) {
            return false;
          }

          // All checks passed → include this profile
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
      //errorMessage.value = 'Error fetching users: $e';
    } finally {
      isLoading.value = false;
    }
  }

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
  Future<bool> likeProfile(String likedUserId) async {
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
          final matchesController = Get.find<MatchesController>();
          await matchesController.refreshMatches();
          return true;
        } else {
          Get.snackbar(
            'Error',
            responseData['message'] ?? 'Failed to like profile',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
          );
          return false;
        }
      } else {
        Get.snackbar(
          'Error',
          'Failed to like profile: ${response.statusCode}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error liking profile: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return false;
    }
  }

  // Bottom Navigation - Updated to only update index (no navigation)
  void setSelectedTabIndex(int index) {
    selectedTabIndex.value = index;

  }
}