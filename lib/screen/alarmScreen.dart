import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:calendar/provider/schedule_provider.dart';

class AlarmsScreen extends StatefulWidget {
  const AlarmsScreen({Key? key}) : super(key: key);

  @override
  _AlarmsScreenState createState() => _AlarmsScreenState();
}

class _AlarmsScreenState extends State<AlarmsScreen> {
  @override
  Widget build(BuildContext context) {
    final scheduleProvider = Provider.of<ScheduleProvider>(context);
    final now = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Alarms"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // 오늘의 일정 가져오기
                final todaySchedules =
                    scheduleProvider.schedules.where((schedule) {
                  final deadline = schedule['deadline'];
                  if (deadline == null || deadline is! DateTime) {
                    return false;
                  }
                  return deadline.year == now.year &&
                      deadline.month == now.month &&
                      deadline.day == now.day;
                }).toList();

                print("All schedules: ${scheduleProvider.schedules}");
                print("Filtered todaySchedules: $todaySchedules");

                // 알림 표시
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text("오늘 마감되는 일정"),
                    content: Text(todaySchedules.isEmpty
                        ? "오늘의 일정이 없습니다."
                        : todaySchedules
                            .map((schedule) =>
                                "${schedule['content']} at ${schedule['deadline']}")
                            .join("\n")),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("닫기"),
                      ),
                    ],
                  ),
                );
              },
              child: const Text("오늘의 이벤트 보기"),
            ),
          ],
        ),
      ),
    );
  }
}
