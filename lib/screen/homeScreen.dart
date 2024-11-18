import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:calendar/components/colors.dart';
import 'package:calendar/components/calendar.dart'; // 캘린더 위젯
import 'package:calendar/components/today_banner.dart'; // 오늘의 날짜와 일정 수를 보여주는 배너
import 'package:calendar/screen/home_addScheduleSheet.dart'; // 일정 추가 및 편집을 위한 하단 시트
import 'package:calendar/provider/schedule_provider.dart'; // 일정 데이터 관리
import 'package:calendar/provider/category_provider.dart'; // 카테고리 데이터 관리
import 'package:intl/intl.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  @override
  void initState() {
    super.initState();

    // 앱 시작 시 카테고리와 일정 정보를 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CategoryProvider>(context, listen: false).loadCategories();
      Provider.of<ScheduleProvider>(context, listen: false).loadSchedules();
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheduleProvider = Provider.of<ScheduleProvider>(context);
    final categoryProvider = Provider.of<CategoryProvider>(context);

    // 선택된 날짜에 해당하는 일정을 필터링
    final filteredSchedules = scheduleProvider.schedules.where((schedule) {
      final startDate = schedule['selectedDate'] as DateTime; // 시작 날짜
      final endDate = schedule['endDate'] as DateTime;       // 종료 날짜
      // 선택된 날짜가 시작 날짜와 종료 날짜 사이에 있는지 확인
      return selectedDate.isAfter(startDate.subtract(Duration(days: 1))) &&
          selectedDate.isBefore(endDate.add(Duration(days: 1)));
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home Screen',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: PRIMARY_COLOR,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await showModalBottomSheet<Map<String, dynamic>>(
            context: context,
            isDismissible: true,
            builder: (_) => ScheduleBottomSheet(
              selectedDate: selectedDate,
              categoryProvider: categoryProvider,
            ),
            isScrollControlled: true,
          );
          if (result != null) {
            scheduleProvider.addSchedule(result, result['category']);
            setState(() {});
          }
        },
        backgroundColor: PRIMARY_COLOR,
        child: Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Main calendar widget
            MainCalendar(
              selectedDate: selectedDate,
              onDaySelected: onDaySelected,
            ),
            SizedBox(height: 8.0),
            // Today banner showing selected date and number of schedules
            TodayBanner(
              selectedDate: selectedDate,
              count: filteredSchedules.length,
            ),
            SizedBox(height: 8.0),
            // Display schedules
            Expanded(
              child: filteredSchedules.isEmpty
                  ? Center(
                child: Text(
                  '선택된 날짜에 일정이 없습니다.',
                  style: TextStyle(fontSize: 16.0, color: DARK_GREY_COLOR),
                ),
              )
                  : ListView(
                children: [
                  // Subject Categories
                  ...categoryProvider.subjectCategories.map((category) {
                    final categorySchedules = filteredSchedules
                        .where((schedule) => schedule['category'] == category)
                        .toList();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category title
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          child: Text(
                            category,
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: PRIMARY_COLOR,
                            ),
                          ),
                        ),
                        // Schedule list or empty message
                        categorySchedules.isEmpty
                            ? Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0),
                          child: Text(
                            '일정이 없습니다.',
                            style: TextStyle(
                              fontSize: 14.0,
                              color: DARK_GREY_COLOR,
                            ),
                          ),
                        )
                            : ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: categorySchedules.length,
                          itemBuilder: (context, index) {
                            final schedule =
                            categorySchedules[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              elevation: 2.0,
                              child: ListTile(
                                title: Text(
                                  schedule['content'],
                                  style: TextStyle(
                                    color: DARK_GREY_COLOR,
                                    decoration:
                                    schedule['isCompleted']
                                        ? TextDecoration
                                        .lineThrough
                                        : TextDecoration.none,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '종료 날짜: ${_formatDate(schedule['endDate'])}',
                                      style: TextStyle(
                                        color: DARK_GREY_COLOR,
                                        fontSize: 12.0,
                                      ),
                                    ),
                                    Text(
                                      '종료 시간: ${_formatTime(schedule['endTime'] as TimeOfDay?)}',
                                      style: TextStyle(
                                        color: DARK_GREY_COLOR,
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  ],
                                ),
                                leading: Checkbox(
                                  value: schedule['isCompleted'],
                                  onChanged: (value) {
                                    scheduleProvider.toggleComplete(
                                        scheduleProvider.schedules
                                            .indexOf(schedule));
                                  },
                                  activeColor: PRIMARY_COLOR,
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.edit,
                                          color: PRIMARY_COLOR),
                                      onPressed: () =>
                                          _editSchedule(
                                              context,
                                              scheduleProvider,
                                              schedule,
                                              categoryProvider),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete,
                                          color:
                                          DARK_GREY_COLOR),
                                      onPressed: () =>
                                          _deleteSchedule(
                                              context,
                                              scheduleProvider,
                                              schedule),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  }).toList(),
                  // General Categories
                  ...categoryProvider.generalCategories.map((category) {
                    final categorySchedules = filteredSchedules
                        .where((schedule) => schedule['category'] == category)
                        .toList();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Category title
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          child: Text(
                            category,
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: PRIMARY_COLOR,
                            ),
                          ),
                        ),
                        // Schedule list or empty message
                        categorySchedules.isEmpty
                            ? Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0),
                          child: Text(
                            '일정이 없습니다.',
                            style: TextStyle(
                              fontSize: 14.0,
                              color: DARK_GREY_COLOR,
                            ),
                          ),
                        )
                            : ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: categorySchedules.length,
                          itemBuilder: (context, index) {
                            final schedule =
                            categorySchedules[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              elevation: 2.0,
                              child: ListTile(
                                title: Text(
                                  schedule['content'],
                                  style: TextStyle(
                                    color: DARK_GREY_COLOR,
                                    decoration:
                                    schedule['isCompleted']
                                        ? TextDecoration
                                        .lineThrough
                                        : TextDecoration.none,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '날짜: ${_formatDate(schedule['endDate'])}',
                                      style: TextStyle(
                                        color: DARK_GREY_COLOR,
                                        fontSize: 12.0,
                                      ),
                                    ),
                                    Text(
                                      '시간: ${_formatTime(schedule['startTime'] as TimeOfDay?)} ~ ${_formatTime(schedule['stopTime'] as TimeOfDay?)}',
                                      style: TextStyle(
                                        color: DARK_GREY_COLOR,
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  ],
                                ),
                                leading: Checkbox(
                                  value: schedule['isCompleted'],
                                  onChanged: (value) {
                                    scheduleProvider.toggleComplete(
                                        scheduleProvider.schedules
                                            .indexOf(schedule));
                                  },
                                  activeColor: PRIMARY_COLOR,
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.edit,
                                          color: PRIMARY_COLOR),
                                      onPressed: () =>
                                          _editSchedule(
                                              context,
                                              scheduleProvider,
                                              schedule,
                                              categoryProvider),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete,
                                          color:
                                          DARK_GREY_COLOR),
                                      onPressed: () =>
                                          _deleteSchedule(
                                              context,
                                              scheduleProvider,
                                              schedule),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  }).toList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 선택된 날짜를 업데이트하는 메서드
  void onDaySelected(DateTime selectedDate, DateTime focusedDate) {
    setState(() {
      this.selectedDate = selectedDate;
    });
  }

  // 일정을 수정하는 함수
  void _editSchedule(BuildContext context, ScheduleProvider provider,
      Map<String, dynamic> schedule, CategoryProvider categoryProvider) async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isDismissible: true,
      builder: (_) => ScheduleBottomSheet(
        selectedDate: schedule['selectedDate'],
        initialEndDate: schedule['endDate'],
        initialContent: schedule['content'],
        categoryProvider: categoryProvider,
      ),
      isScrollControlled: true,
    );

    if (result != null) {
      provider.updateSchedule(
        provider.schedules.indexOf(schedule),
        {...result, 'isCompleted': schedule['isCompleted']},
      );
    }
  }

  // 일정을 삭제하는 함수
  void _deleteSchedule(BuildContext context, ScheduleProvider provider,
      Map<String, dynamic> schedule) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('삭제 확인'),
        content: Text('정말로 이 일정을 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('취소', style: TextStyle(color: Colors.black)),
          ),
          TextButton(
            onPressed: () {
              provider.removeSchedule(provider.schedules.indexOf(schedule));
              Navigator.of(ctx).pop();
            },
            child: Text('삭제', style: TextStyle(color: PRIMARY_COLOR)),
          ),
        ],
      ),
    );
  }

  // 날짜를 문자열로 포맷하는 함수
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }

  String _formatTime(TimeOfDay? time) {
    if (time == null) {
      return "시간 없음"; // 기본 메시지
    }
    final now = DateTime.now();
    final dateTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('hh:mm a').format(dateTime); // AM/PM 포맷
  }
}
