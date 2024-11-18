import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:calendar/components/colors.dart';
import 'package:calendar/provider/schedule_provider.dart';

class MainCalendar extends StatelessWidget {
  final DateTime selectedDate;
  final Function(DateTime, DateTime) onDaySelected;

  MainCalendar({required this.selectedDate, required this.onDaySelected});

  @override
  Widget build(BuildContext context) {
    final scheduleProvider = Provider.of<ScheduleProvider>(context);

    // Generate markers for days with schedules
    final markers = <DateTime, List>{};
    for (var schedule in scheduleProvider.schedules) {
      final date = schedule['selectedDate'] as DateTime;
      markers[date] = (markers[date] ?? [])..add(schedule);
    }

    DateTime today = DateTime.now();

    return TableCalendar(
      focusedDay: selectedDate,
      firstDay: DateTime(2000),
      lastDay: DateTime(2100),
      selectedDayPredicate: (day) =>
      isSameDay(selectedDate, day) && !isSameDay(day, today),
      onDaySelected: onDaySelected,
      calendarStyle: CalendarStyle(
        // 스타일: 오늘 날짜
        todayDecoration: BoxDecoration(
          color: PRIMARY_COLOR, // 항상 진한 민트색
          shape: BoxShape.circle,
        ),
        todayTextStyle: TextStyle(
          color: Colors.white, // 흰색 텍스트
          fontWeight: FontWeight.bold,
        ),

        // 스타일: 선택된 날짜 (오늘이 아닌 경우만)
        selectedDecoration: BoxDecoration(
          color: LIGHT_PRIMARY_COLOR, // 연한 민트색
          shape: BoxShape.circle,
        ),
        selectedTextStyle: TextStyle(
          color: DARK_GREY_COLOR, // 회색 텍스트
        ),

        // 스타일: 기본 날짜
        defaultDecoration: BoxDecoration(
          shape: BoxShape.circle,
        ),
        weekendDecoration: BoxDecoration(
          shape: BoxShape.circle,
        ),

        // 마커 스타일
        markersMaxCount: 1,
        markerDecoration: BoxDecoration(
          color: Colors.grey, // 마커 색상: 흰색
          shape: BoxShape.circle,
        ),
      ),
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
      ),
      eventLoader: (day) => markers[day] ?? [],
    );
  }
}
