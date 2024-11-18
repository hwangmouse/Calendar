import 'package:calendar/inapp_algorithm/CalenderData.dart';

class WeekdayManager {
  final List<CalenderData> schedules;

  WeekdayManager(this.schedules);

  // 특정 요일의 이벤트를 가져오는 메서드
  List<CalenderData> getEventsForDay(int weekday) {
    return schedules
        .where((schedule) => schedule.scheduleDate.weekday == weekday)
        .toList();
  }
}
