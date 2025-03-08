
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../data/appvalues.dart';

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
  FlutterLocalNotificationsPlugin();

  bool isFlutterNotificationInitialized = false;

  Future<void> initialize(BuildContext context) async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    try {
      String? token = await _fcm.getToken();
      if (token != null) {
        AppValues.fcm = token;
        print("FCM Token: $token");
      } else {
        print("FCM Token is null");
      }
    } catch (e, stackTrace) {
    print("Error obtaining FCM token: $e");
    }
    await requestPermission();
    await _setupFlutterNotifications(context);
    await _setupMessageHandlers(context);
  }

  Future<void> requestPermission() async {
    final settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    print(
        "Notification permission status: ${settings.authorizationStatus}");
  }

  Future<void> _setupFlutterNotifications(BuildContext context) async {
    if (isFlutterNotificationInitialized) {
      print("Already it's initialized");
      return;
    }

    const channel = AndroidNotificationChannel(
      'finance_updates_channel',
      'finance Updates Channel',
      description: 'This channel contains updates of finance in the application.',
      importance: Importance.max,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    const androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettings = InitializationSettings(
      android: androidSettings,
    );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (response) async {
        if (response.payload != null) {
          print("From initialization");
        }
      },
    );
    // await _checkInitialNotification(context);

    isFlutterNotificationInitialized = true;
  }

  Future<void> _setupMessageHandlers(BuildContext context) async {
    FirebaseMessaging.onMessage.listen((message) {
      print("Notification received");
      if (message.notification != null) {
        showNotification(message);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      if (message.data.isNotEmpty) {

      }
    });

    try {
      // Check for initial message when app starts
      RemoteMessage? initialMessage = await _fcm.getInitialMessage();

      if (initialMessage != null) {
        print("Initial message received when app was terminated");
      }
    } catch (e, stackTrace) {
      print("Error handling initial message: $e");
    }
  }

  Future<void> showNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'finance_updates_channel',
      'finance Updates Channel',
      importance: Importance.max,
      priority: Priority.high,
    );

    NotificationDetails details = NotificationDetails(android: androidDetails);

    await _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      details,
      payload: jsonEncode(message.data),
    );
  }


}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print(
      "Notification from the background handler function : ${message.data}");
  // await Firebase.initializeApp();
  // await NotificationService.instance._setupFlutterNotifications();
  // await NotificationService.instance.showMessage(message,"background");
}