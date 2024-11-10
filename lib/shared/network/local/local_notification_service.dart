import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:todo/models/task_model.dart';

class LocalNotificationService {
  static FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static StreamController<NotificationResponse> streamController =
      StreamController();

  static onTap(NotificationResponse notificationResponse) async {
    streamController.add(notificationResponse);
  }

  static Future init() async {
    InitializationSettings initializationSettings =
        const InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      ),
    );
    flutterLocalNotificationsPlugin!.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onTap,
      onDidReceiveBackgroundNotificationResponse: onTap,
    );
  }

  static Future basicNotification() async {
    AndroidNotificationDetails android = AndroidNotificationDetails(
      'id 1',
      'Basic Notifications',
      importance: Importance.max,
      priority: Priority.high,
      sound: RawResourceAndroidNotificationSound('sound.wav'.split('.').first),
    );

    NotificationDetails notificationDetails = NotificationDetails(
        android: android, iOS: const DarwinNotificationDetails());

    await flutterLocalNotificationsPlugin!.show(
      0,
      "Basic Notification",
      "I'm trying to do Basic Notification on my device",
      notificationDetails,
      payload: "Basic payload data",
    );
  }

  static Future repeatedNotification() async {
    AndroidNotificationDetails android = const AndroidNotificationDetails(
      'id 2',
      'Repeated Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: android,
    );

    await flutterLocalNotificationsPlugin!.periodicallyShow(
      1,
      "Repeated Notification",
      "I'm trying to do Repeated Notification on my device",
      RepeatInterval.everyMinute,
      notificationDetails,
      payload: "Repeated payload data",
    );
  }

  static Future<void> scheduledNotification({
    required DateTime currentDate,
    required TimeOfDay scheduledTime,
    required TaskModel taskModel,
  }) async {
    // Check platform and request notification permission if on Android
    if (Platform.isAndroid) {
      final status = await Permission.notification.request();
      if (status != PermissionStatus.granted) {
        debugPrint('Notification permission not granted');
        return;
      }
    }

    const channelId = 'id 3';
    const channelName = 'Scheduled Notifications';
    const channelDescription = 'Scheduled notifications from your app';

    // Set up Android-specific notification details
    AndroidNotificationDetails android = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      sound: RawResourceAndroidNotificationSound("sound.wav".split('.').first),
    );

    // Combine platform-specific notification details
    NotificationDetails notificationDetails = NotificationDetails(
      android: android,
    );

    // Initialize time zones
    tz.initializeTimeZones();

    try {
      final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
      final location = tz.getLocation(currentTimeZone);
      tz.setLocalLocation(location); // Set the local timezone location
      debugPrint('Timezone set to: Egypt');
    } catch (error) {
      debugPrint('Error setting timezone: $error');
      return;
    }

    // Schedule the notification
    return await flutterLocalNotificationsPlugin!
        .zonedSchedule(
      taskModel.id,
      taskModel.title,
      taskModel.description,
      tz.TZDateTime(
        tz.local,
        currentDate.year,
        currentDate.month,
        currentDate.day,
        scheduledTime.hour,
        scheduledTime.minute,
      ).subtract(
        const Duration(minutes: 1),
      ),
      // tz.TZDateTime.now(tz.local).add(
      //   const Duration(seconds: 3),
      // ),
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: "Scheduled payload data",
    )
        .then((onValue) {
      debugPrint("Notification scheduled successfully");
    }).catchError((onError) {
      debugPrint("Error scheduling notification: $onError");
    });
  }

  static Future<void> dailyScheduledNotification() async {
    // Set up Android-specific notification details
    AndroidNotificationDetails android = AndroidNotificationDetails(
        'id 4', 'Daily Scheduled Notifications',
        channelDescription: 'Daily Scheduled notifications from your app',
        importance: Importance.max,
        priority: Priority.high,
        sound:
            RawResourceAndroidNotificationSound("sound.wav".split('.').first));

    // Combine platform-specific notification details
    NotificationDetails notificationDetails = NotificationDetails(
      android: android,
    );

    // Initialize time zones
    tz.initializeTimeZones();

    tz.setLocalLocation(tz.getLocation('Africa/Cairo'));
    var currentTime = tz.TZDateTime.now(tz.local);

    var scheduledTime = tz.TZDateTime(
        tz.local, currentTime.year, currentTime.month, currentTime.day, 20, 47);

    if (scheduledTime.isBefore(currentTime)) {
      scheduledTime = scheduledTime.add(const Duration(minutes: 17));
    }

    return await flutterLocalNotificationsPlugin!
        .zonedSchedule(
      3,
      "Daily Scheduled Notification",
      "I'm trying to do a Daily scheduled notification from my device",
      scheduledTime,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: "Daily Scheduled payload data",
    )
        .then((onValue) {
      debugPrint("Daily Notification scheduled successfully");
      debugPrint("The day is: ${scheduledTime.minute}");
    }).catchError((onError) {
      debugPrint("Error Daily scheduling notification: $onError");
    });
  }

  static Future cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin!.cancel(id);
  }
}
