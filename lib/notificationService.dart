/*

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'HomeScreen/controller/home_screen_controller.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();
  // Unique identifiers
  static const String _categoryId = 'like_category';
  static const String _okActionId = 'ok_action';

  // Top-level background handler (required for action taps when app is in background)
  @pragma('vm:entry-point')
  static void notificationTapBackground(NotificationResponse response) {
    debugPrint('BACKGROUND: Notification tapped');
    debugPrint('BACKGROUND: Action ID = ${response.actionId}'); // Will be 'ok_action' if button tapped, null if body
    debugPrint('BACKGROUND: Payload = ${response.payload}');
    if (response.input != null) {
      debugPrint('BACKGROUND: User input = ${response.input}');
    }
    // Note: Heavy logic (like GetX navigation) won't work here reliably in background isolate
  }

  static Future<void> initialize() async {
    // Android initialization
    const AndroidInitializationSettings androidInit =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS/macOS initialization (kept for completeness, but we're focusing on Android)
    final DarwinInitializationSettings iOSInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      notificationCategories: [
        DarwinNotificationCategory(
          _categoryId,
          actions: [
            DarwinNotificationAction.plain(
              _okActionId,
              'OK',
              options: {DarwinNotificationActionOption.foreground},
            ),
          ],
        ),
      ],
    );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidInit,
    );

    await _notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // This runs when app is in FOREGROUND or when action brings app to foreground

        debugPrint('FOREGROUND: Notification tapped');
        debugPrint('FOREGROUND: Action ID = ${response.actionId}');
        debugPrint('FOREGROUND: Payload = ${response.payload}');
        _handleNotificationTap(response);
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground, // Key addition for background!
    );

    // Android high-importance channel
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'Used for important alerts like new likes and messages.',
      importance: Importance.high,
      playSound: true,
    );

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  /// Show notification with "OK" action button
  static Future<void> showNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      channelDescription: 'Used for important alerts like new likes and messages.',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      actions: [
        AndroidNotificationAction(
          _okActionId,
          'OK',
          showsUserInterface: true, // Brings app to foreground on tap
          cancelNotification: true,
        ),
      ],
    );

    const DarwinNotificationDetails iOSDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      categoryIdentifier: _categoryId,
    );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    await _notificationsPlugin.show(
      notification.hashCode,
      notification.title ?? 'New Notification',
      notification.body ?? 'You have a new update!',
      platformDetails,
      payload: message.data.toString(),
    );
  }

  /// Handle when app is launched from terminated state by tapping a notification
  static void handleInitialMessage(RemoteMessage message) {
    final fakeResponse = NotificationResponse(
      notificationResponseType: NotificationResponseType.selectedNotification,
      payload: message.data.toString(),
      actionId: null,
    );
    _handleNotificationTap(fakeResponse);
  }

  /// Common handling logic (runs in foreground isolate)
  static void _handleNotificationTap(NotificationResponse response) {
    print('Notification tapped (foreground handler): Action ID = ${response.actionId}');
    print('Payload: ${response.payload}');
    try {
      final homeController = Get.find<HomeController>();
      homeController.setSelectedTabIndex(1); // Go to Matches tab
    } catch (e) {
      print('Error handling notification tap: $e');
    }
  }
}*/

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import 'HomeScreen/controller/home_screen_controller.dart';
import 'MatchPage/controller/matches_page_controller.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  // Unique identifiers
  static const String _categoryId = 'like_category';
  static const String _okActionId = 'ok_action';

  // Store the current user ID (set this when user logs in)
  static String? _currentUserId;

  // Set the current user ID - call this when user logs in or app starts
  static void setCurrentUserId(String userId) {
    _currentUserId = userId;
  }

  // Top-level background handler (required for action taps when app is in background)
  @pragma('vm:entry-point')
  static void notificationTapBackground(NotificationResponse response) {
    debugPrint('BACKGROUND: Notification tapped');
    debugPrint('BACKGROUND: Action ID = ${response.actionId}');
    debugPrint('BACKGROUND: Payload = ${response.payload}');

    if (response.input != null) {
      debugPrint('BACKGROUND: User input = ${response.input}');
    }

    // Note: Heavy logic (like GetX navigation) won't work here reliably in background isolate
  }

  static Future<void> initialize() async {
    // Android initialization
    const AndroidInitializationSettings androidInit =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS/macOS initialization
    final DarwinInitializationSettings iOSInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      notificationCategories: [
        DarwinNotificationCategory(
          _categoryId,
          actions: [
            DarwinNotificationAction.plain(
              _okActionId,
              'OK',
              options: {DarwinNotificationActionOption.foreground},
            ),
          ],
        ),
      ],
    );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidInit,
    );

    await _notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // This runs when app is in FOREGROUND or when action brings app to foreground
        debugPrint('FOREGROUND: Notification tapped');
        debugPrint('FOREGROUND: Action ID = ${response.actionId}');
        debugPrint('FOREGROUND: Payload = ${response.payload}');
        _handleNotificationTap(response);
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    // Android high-importance channel
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'Used for important alerts like new likes and messages.',
      importance: Importance.high,
      playSound: true,
    );

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  /// Show notification with "OK" action button
  static Future<void> showNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      channelDescription: 'Used for important alerts like new likes and messages.',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      actions: [
        AndroidNotificationAction(
          _okActionId,
          'OK',
          showsUserInterface: true,
          cancelNotification: true,
        ),
      ],
    );

    const DarwinNotificationDetails iOSDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      categoryIdentifier: _categoryId,
    );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    await _notificationsPlugin.show(
      notification.hashCode,
      notification.title ?? 'New Notification',
      notification.body ?? 'You have a new update!',
      platformDetails,
      payload: message.data.toString(),
    );
  }

  /// Handle when app is launched from terminated state by tapping a notification
  static void handleInitialMessage(RemoteMessage message) {
    debugPrint('App launched from terminated state by notification');
    final fakeResponse = NotificationResponse(
      notificationResponseType: NotificationResponseType.selectedNotification,
      payload: message.data.toString(),
      actionId: null,
    );
    _handleNotificationTap(fakeResponse);
  }

  /// Common handling logic (runs in foreground isolate)
  static void _handleNotificationTap(NotificationResponse response) {
    debugPrint('Notification tapped (foreground handler): Action ID = ${response.actionId}');
    debugPrint('Payload: ${response.payload}');

    try {
      // 1. Try to get existing MatchesController instance
      MatchesController? matchesController;
      try {
        matchesController = Get.find<MatchesController>();
        debugPrint('Found existing MatchesController instance');
      } catch (e) {
        debugPrint('No existing MatchesController found, checking for HomeController: $e');

        // 2. Try to get HomeController to get currentUserId
        try {
          final homeController = Get.find<HomeController>();
          debugPrint('Found HomeController, user ID: ${homeController.currentUserId}');

          // Create or find MatchesController with the user ID from HomeController
          if (homeController.currentUserId.isNotEmpty) {
            matchesController = Get.put(MatchesController(homeController.currentUserId));
            debugPrint('Created new MatchesController with user ID: ${homeController.currentUserId}');
          }
        } catch (e2) {
          debugPrint('HomeController not found: $e2');
        }
      }

      // 3. If still no controller, use stored currentUserId
      if (matchesController == null && _currentUserId != null && _currentUserId!.isNotEmpty) {
        matchesController = Get.put(MatchesController(_currentUserId!));
        debugPrint('Created MatchesController with stored user ID: $_currentUserId');
      }

      // 4. If we have a controller, call refreshMatches
      if (matchesController != null) {
        debugPrint('Calling refreshMatches() for user ID: ${matchesController.currentUserId}');
        matchesController.refreshMatches();
        debugPrint('refreshMatches() called successfully');
      } else {
        debugPrint('ERROR: Could not get user ID to call refreshMatches()');
      }

      // 5. Navigate to Matches tab (index 1) - keep existing navigation
      try {
        final homeController = Get.find<HomeController>();
        homeController.setSelectedTabIndex(1); // Go to Matches tab
        debugPrint('Navigated to Matches tab (index 1)');
      } catch (e) {
        debugPrint('Error navigating to Matches tab: $e');
      }

    } catch (e) {
      debugPrint('Error handling notification tap: $e');
    }
  }
}