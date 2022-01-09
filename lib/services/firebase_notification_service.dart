import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:test_firebase_message/services/local_notification_service.dart';

class FirebaseNotificationService {
  static initFirebaseNotificaiton(BuildContext context) {
    ///初始化LocalNotificationService
    ///傳context是為了使用Navigator
    LocalNotificationService.initialize(context);

    ///give the message which user taps when app is from terminated state
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        final routeFromMessage = message.data['route'];
        Navigator.of(context).pushNamed(routeFromMessage);
        print(routeFromMessage);
      }
    });

    ///stream 的監聽
    ///only work in the foreground
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        print(message.notification.title);
        print(message.notification.body);
      }
      LocalNotificationService.display(message);
    });

    ///stream 監聽
    ///only when app in the background but not close, and
    ///user tap notification
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final routeFromMessage = message.data['route'];
      Navigator.of(context).pushNamed(routeFromMessage);
      print(routeFromMessage);
    });
  }
}
