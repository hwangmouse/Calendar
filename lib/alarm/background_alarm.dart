import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';
import 'package:shared_preferences/shared_preferences.dart';

// flutterLocalNotificationsPlugin 정의 및 초기화 함수
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// 알림 초기화 함수
Future<void> initializeAlarms() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'your_channel_id', // 채널 ID
    'Event Notifications', // 채널 이름
    description: 'Notifications for upcoming events', // 채널 설명
    importance: Importance.max,
  );

  final androidPlugin =
      flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
  if (androidPlugin != null) {
    await androidPlugin.createNotificationChannel(channel);
  }
}

// 알림 표시 함수
Future<void> showAlarm(String scheduleName) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'your_channel_id',
    'your_channel_name',
    importance: Importance.max,
    priority: Priority.high,
    showWhen: true,
  );

  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
    DateTime.now().millisecondsSinceEpoch.remainder(300000),
    '이벤트 알림',
    '$scheduleName 30분 후에 마감됩니다.',
    platformChannelSpecifics,
    payload: 'item x',
  );
}

// 백그라운드 작업을 처리하는 콜백 함수
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    final now = DateTime.now();
    print("WorkManager task executed at $now"); // 로그 추가

    final prefs = await SharedPreferences.getInstance();
    final schedulesJson = prefs.getString('schedules');
    print("Loaded schedules JSON: $schedulesJson"); // 로드된 JSON 확인

    if (schedulesJson != null) {
      final schedules =
          List<Map<String, dynamic>>.from(jsonDecode(schedulesJson));
      print("Parsed schedules: $schedules"); // 파싱된 데이터 확인

      for (final schedule in schedules) {
        final deadlineRaw = schedule['deadline'];
        if (deadlineRaw == null) {
          print("Warning: Null deadline in schedule: $schedule");
          continue;
        }

        final deadline = DateTime.parse(deadlineRaw);
        final timeBeforeEvent = deadline.difference(now);

        if (timeBeforeEvent.inMinutes <= 30 && !timeBeforeEvent.isNegative) {
          print("Triggering notification for: ${schedule['content']}"); // 로그 추가
          await showAlarm(schedule['content']);
        }
      }
    } else {
      print("No schedules found in SharedPreferences.");
    }

    return Future.value(true);
  });
}

// 백그라운드 알림 작업 등록 함수
void registerBackgroundAlarms() {
  print("Initializing WorkManager...");
  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  print("WorkManager initialized.");

  print("Registering periodic task...");
  Workmanager().registerPeriodicTask(
    "1",
    "backgroundTask",
    frequency: const Duration(minutes: 15),
  );
  print("Periodic task registered.");
}
