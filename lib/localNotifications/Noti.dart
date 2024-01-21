import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../screens/home/home.dart';

class Noti {
  static Future initialize(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var androidInitialize =
        const AndroidInitializationSettings('mipmap/ic_launcher');

    var initializationsSettings = InitializationSettings(
      android: androidInitialize,
    );
    await Permission.notification.request();
    await flutterLocalNotificationsPlugin.initialize(initializationsSettings);

    tz.initializeTimeZones();

    tz.setLocalLocation(tz.getLocation(DateTime.now().timeZoneName));
  }

  static Future showBigTextNotification(
      {var id = 0,
      required String title,
      required String body,
      var payload,
      required FlutterLocalNotificationsPlugin fln}) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        const AndroidNotificationDetails(
      'bilo_sho_nesto',
      'channel_name',
      channelDescription: 'channel_desc',
      playSound: true,
      // sound: RawResourceAndroidNotificationSound('notification'),
      importance: Importance.max,
      priority: Priority.high,
    );
    print("probuvam");
    var not = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(12345, title, body, not,
        payload: "data");
  }

  static Future showFutureNotif(String title, String body, int year, int months,
      int days, int hours, int minutes) async {
    print(tz.TZDateTime.local(year, months, days, hours, minutes));
    await flutterLocalNotificationsPlugin
        .zonedSchedule(
      12347,
      title,
      body,
      tz.TZDateTime.local(year, months, days, hours, minutes),
      const NotificationDetails(
          android: AndroidNotificationDetails(
        'main_channel', 'MIS',
        channelDescription: 'channel_desc',
        playSound: true,
        // sound: RawResourceAndroidNotificationSound('notification'),
        importance: Importance.max,
        priority: Priority.high,
      )),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    )
        .then((value) async {
      print("zavrsiv eve");
      var res =
          await flutterLocalNotificationsPlugin.pendingNotificationRequests();
      print(res.map((e) => e.id));
    });
  }
}
