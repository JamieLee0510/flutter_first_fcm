import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize(BuildContext context) {
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),

      ///android default icon
    );
    notificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String route) async {
      if (route != null) {
        Navigator.of(context).pushNamed(route);
      }
    });
  }

  static void display(RemoteMessage message) async {
    try {
      ///確保每次都是獨立的id，用datetime
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      ///
      final notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          "easyapproach",
          "easyapproach channel",
          "this is our channel",
          importance: Importance.max,
          priority: Priority.high,
        ),
      );
      await notificationsPlugin.show(
        id,
        message.notification.title,
        message.notification.body,
        notificationDetails,
        payload: message.data["route"],

        ///傳route進去
      );
    } catch (e) {
      print(e);
    }
  }
}
