class CalenderData {
  String scheduleName;
  DateTime scheduleDate;

  CalenderData({
    required this.scheduleName,
    required this.scheduleDate,
  });

  String getScheduleName() => scheduleName;
  DateTime getScheduleDate() => scheduleDate;
}
