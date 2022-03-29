import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class MyNotification {
  int counter = 0;
  Map<String, Function(String)> _handlers = {};

  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  factory MyNotification() => _instance;
  static MyNotification _instance = MyNotification._();

  MyNotification._() {
    Future onSelectNotification(String? payload) async {
      if (payload != null) {
        var s = payload.split(' ');
        var f = _handlers[s[0]];
        if (f != null) f(s[1]);
      }
    }

    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

    tz.initializeTimeZones();
  }

// example payload = 'handlername handlerargument'
  Future schedule(
      {String? title, String? body, DateTime? dateTime, String? payload}) {
    counter++;
    if (dateTime != null)
      return _flutterLocalNotificationsPlugin.zonedSchedule(
          counter,
          title,
          body,
          tz.TZDateTime.from(dateTime, tz.local),
          const NotificationDetails(
              android: AndroidNotificationDetails(
                  'your channel id', 'your channel name',
                  channelDescription: 'your channel description')),
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          payload: payload);
    else
      return _flutterLocalNotificationsPlugin.show(
          counter,
          title,
          body,
          const NotificationDetails(
              android: AndroidNotificationDetails(
                  'your channel id', 'your channel name',
                  channelDescription: 'your channel description')),
          payload: payload);
  }

  void addHandler(String name, Function(String arg) func) {
    _handlers[name] = func;
  }
}
