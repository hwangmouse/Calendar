import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:calendar/components/colors.dart';
import 'package:calendar/provider/schedule_provider.dart';

class WeeklyTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scheduleProvider = Provider.of<ScheduleProvider>(context);

    // 오늘을 기준으로 한 주 범위 계산
    DateTime today = DateTime.now();
    DateTime startOfWeek = today.subtract(Duration(days: today.weekday - 1)); // Start of the week (Monday)
    DateTime endOfWeek = startOfWeek.add(Duration(days: 6)); // End of the week (Sunday)

    // 현재 주의 일정 필터링
    final weeklySchedules =
    scheduleProvider.getWeeklySchedules(startOfWeek, endOfWeek);

    return Scaffold(
      appBar: AppBar(
        title: Text('Weekly', style: TextStyle(color: Colors.white)),
        backgroundColor: PRIMARY_COLOR,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                '이번 주 일정 (${_formatDate(startOfWeek)} ~ ${_formatDate(endOfWeek)})',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                  color: DARK_GREY_COLOR,
                ),
              ),
            ),
            Expanded(
              child: weeklySchedules.isEmpty
                  ? Center(
                child: Text(
                  '이번 주 일정이 없습니다.',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: DARK_GREY_COLOR,
                  ),
                ),
              )
                  : ListView.builder(
                itemCount: weeklySchedules.length,
                itemBuilder: (context, index) {
                  final schedule = weeklySchedules[index];
                  return Card(
                    margin: EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    elevation: 2.0,
                    child: ListTile(
                      title: Text(
                        schedule['content'],
                        style: TextStyle(
                          color: DARK_GREY_COLOR,
                          decoration: schedule['isCompleted']
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      subtitle: Text(
                        _formatDate(schedule['selectedDate']),
                        style: TextStyle(
                          color: DARK_GREY_COLOR,
                        ),
                      ),
                      trailing: Checkbox(
                        value: schedule['isCompleted'],
                        onChanged: (value) {
                          scheduleProvider.toggleComplete(
                              scheduleProvider.schedules.indexOf(schedule));
                        },
                        activeColor: PRIMARY_COLOR,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }
}
