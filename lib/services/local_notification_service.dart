import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  // ///Singleton pattern
  // ///目的：保證一個類別只會產生一個物件，而且要提供存取該物件的統一方法
  // static final LocalNotificationService _notificationService =
  //     LocalNotificationService._internal();
  // factory LocalNotificationService() {
  //   return _notificationService;
  // }
  // LocalNotificationService._internal();

  static void requestIOSPermissions() {
    notificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  // static void requestIOSPermissions(
  //     FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) {
  //   flutterLocalNotificationsPlugin
  //       .resolvePlatformSpecificImplementation<
  //           IOSFlutterLocalNotificationsPlugin>()
  //       ?.requestPermissions(
  //         alert: true,
  //         badge: true,
  //         sound: true,
  //       );
  // }

  static final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize(BuildContext context) {
    final InitializationSettings initializationSettings = InitializationSettings(

        ///android default icon
        ///route should be: {project}\android\app\src\main\res\drawable\YOUR_APP_ICON.png
        android: AndroidInitializationSettings("@mipmap/ic_launcher"),

        ///ios default setting
        iOS: IOSInitializationSettings(
          requestSoundPermission: false,
          requestBadgePermission: false,
          requestAlertPermission: false,
        ));

    notificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String route) async {
      if (route != null) {
        Navigator.of(context).pushNamed(route);
      }
    });
  }

  Future<void> init(BuildContext context) async {
    //Initialization Settings for Android
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    //Initialization Settings for iOS
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    //InitializationSettings for initializing settings for both platforms (Android & iOS)
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);

    await notificationsPlugin.initialize(initializationSettings,
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

      ///notification 的一些設置，如channel、優先級等
      final notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          "easyapproach",
          "easyapproach channel",
          "this is our channel",
          importance: Importance.max,
          priority: Priority.high,
        ),
      );
      AndroidNotificationDetails _androidNotificationDetails =
          AndroidNotificationDetails(
        'channel ID',
        'channel name',
        'channel description',
        playSound: true,
        priority: Priority.high,
        importance: Importance.high,
      );

      IOSNotificationDetails _iosNotificationDetails = IOSNotificationDetails(
//         presentAlert: bool?,  // Present an alert when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
//         presentBadge: bool?,  // Present the badge number when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
//         presentSound: bool?,  // Play a sound when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
//         sound: String?,  // Specifics the file path to play (only from iOS 10 onwards)
//         badgeNumber: int?, // The application's icon badge number
//         attachments: List<IOSNotificationAttachment>?, (only from iOS 10 onwards)
//         subtitle: String?, //Secondary description  (only from iOS 10 onwards)
//         threadIdentifier: String? (only from iOS 10 onwards)
          );
      NotificationDetails platformChannelSpecifics = NotificationDetails(
          android: _androidNotificationDetails, iOS: _iosNotificationDetails);

      await notificationsPlugin.show(
        id,
        message.notification.title,
        message.notification.body,
        // notificationDetails,
        platformChannelSpecifics,
        payload: message.data["route"],

        ///傳route進去
      );
    } catch (e) {
      print(e);
    }
  }
}
