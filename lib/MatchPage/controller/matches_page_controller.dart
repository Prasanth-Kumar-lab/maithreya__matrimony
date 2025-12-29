import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as http;
import '../../UserProfile/model/userProfile_model.dart';
import '../../UserProfile/view/UsersProfile.dart';
import '../../apiEndPoint.dart';
import '../model/matches_page.dart';

class MatchesController extends GetxController {
  final String currentUserId;
  MatchesController(this.currentUserId);
  var isLoading = true.obs;
  var errorMessage = ''.obs;
  var likedProfiles = <dynamic>[].obs;
  var likedMeProfiles = <dynamic>[].obs;
  var callHistory = <dynamic>[].obs;
  var cardLoadingStates = <String, bool>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchLikedProfiles();
    fetchCallHistory();
  }
  Future<void> refreshMatches() async {
    try {
      isLoading(true); // Optional: show loading spinner at the top
      await Future.wait([
        fetchLikedProfiles(),
        fetchCallHistory(),
      ]);
    } catch (e) {
      //errorMessage('Failed to refresh matches: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> deleteLikedUser({
    required String currentUserId,
    required String profileId,
    required String type, // 'liked' or 'liked_me'
    required BuildContext context,
  }) async {
    final url = Uri.parse(ApiEndPoint.wishlistApi);

    try {
      final response = await http.post(
        url,
        body: {
          'user_id': currentUserId,
          'profile_id': profileId,
          'type': type, // will be 'liked' or 'liked_me'
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint('Delete response: $data');

        if (data['success'] == true || data['status'] == 'success') {
          // ✅ Remove the deleted user from the right list
          if (type == 'liked') {
            likedProfiles.removeWhere((p) => p['id'].toString() == profileId);
          } else if (type == 'liked_me') {
            likedMeProfiles.removeWhere((p) => p['id'].toString() == profileId);
          }

        } else {
          throw Exception(data['message'] ?? 'Failed to delete profile.');
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint("Error deleting liked user: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to remove user: $e"),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Future<void> fetchLikedProfiles() async {
    isLoading(true);
    errorMessage('');
    try {
      final likedResp = await http.post(
        Uri.parse(ApiEndPoint.wishlistApi),
        body: {'user_id': currentUserId, 'type': 'liked'},
      );
      final likedMeResp = await http.post(
        Uri.parse(ApiEndPoint.wishlistApi),
        body: {'user_id': currentUserId, 'type': 'liked_me'},
      );
      if (likedResp.statusCode != 200 || likedMeResp.statusCode != 200) {
        throw Exception('Server error');
      }
      final liked = MatchResponse.fromJson(json.decode(likedResp.body));
      final likedMe = MatchResponse.fromJson(json.decode(likedMeResp.body));
      if (!liked.success || !likedMe.success) {
        throw Exception('API returned failure');
      }
      likedProfiles.assignAll(liked.data);
      likedMeProfiles.assignAll(likedMe.data);
    } catch (e) {
      //errorMessage('Error fetching matches: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchCallHistory() async {
    try {
      final response = await http.post(
        Uri.parse(ApiEndPoint.callHistoryEndPoint),
        body: {'user_id': currentUserId},
      );

      if (response.statusCode == 200) {
        print('${response.body}');
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          callHistory.assignAll(data['data'] ?? []);
        }
      }
    } catch (e) {
      debugPrint('Error fetching call history: $e');
      // Optionally set errorMessage
    }
  }

  Future<UserProfile?> fetchProfile(String userId) async {
    try {
      final resp = await http.post(
        Uri.parse(ApiEndPoint.listProfileApi),
        body: {'user_id': userId},
      );
      if (resp.statusCode == 200) {
        final List<dynamic> list = jsonDecode(resp.body);
        if (list.isNotEmpty) {
          return UserProfile.fromJson(list[0]);
        }
      }
    } catch (e) {
      debugPrint('fetchProfile error: $e');
    }
    return null;
  }

  Future<void> viewProfile(BuildContext context, String userId, String cardId) async {
    cardLoadingStates[cardId] = true;
    final profile = await fetchProfile(userId);
    cardLoadingStates[cardId] = false;
    if (profile != null && context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => UsersProfileScreen(user: profile)),
      );
    } else if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to load profile."),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }
}