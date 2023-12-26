import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationScerviceClass {
  final FlutterLocalNotificationsPlugin _flutterNotificationPlugin =
      FlutterLocalNotificationsPlugin();

  final AndroidInitializationSettings _androidInitializationSettings =
      const AndroidInitializationSettings("logo");

  void initialiseNotification() async {
    InitializationSettings initialiseSetting = InitializationSettings(
      android: _androidInitializationSettings,
    );
    await _flutterNotificationPlugin.initialize(initialiseSetting);
  }

  void sendNotification(String title, String body) async {
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails(
      "channelId",
      "channelName",
      importance: Importance.max,
      priority: Priority.high,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    await _flutterNotificationPlugin.show(
      0,
      title,
      body,
      notificationDetails,
    );
  }

  void seheduleNotification(String title, String body) async {
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails(
      "channelId",
      "channelName",
      importance: Importance.max,
      priority: Priority.high,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );
    // RepeatInterval repeatInterval = RepeatInterval.everyMinute;

    await _flutterNotificationPlugin.periodicallyShow(
      1,
      title,
      body,
      RepeatInterval.everyMinute,
      notificationDetails,
    );
  }
}
