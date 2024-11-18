import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:calendar/inapp_algorithm/AssignmentData.dart'; // AssignmentData 클래스 임포트

class ScheduleProvider with ChangeNotifier {
  // 스케줄 데이터를 저장하는 리스트
  List<Map<String, dynamic>> _schedules = [];

  // AssignmentData 리스트
  List<AssignmentData> _assignmentDataList = [];

  // 외부에서 데이터를 읽을 수 있도록 getter 제공
  List<Map<String, dynamic>> get schedules => _schedules;
  List<AssignmentData> get assignmentDataList => _assignmentDataList;

  // 생성자
  ScheduleProvider() {
    loadSchedules(); // 앱 시작 시 저장된 데이터 로드
  }

  // 저장된 스케줄 데이터 불러오기
  Future<void> loadSchedules() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? scheduleData = prefs.getString('schedules');
    if (scheduleData != null) {
      _schedules = List<Map<String, dynamic>>.from(
        json.decode(scheduleData).map((schedule) {
          return {
            ...schedule,
            'selectedDate': DateTime.parse(schedule['selectedDate']),
            'endDate': DateTime.parse(schedule['endDate']),
          };
        }),
      );
      _convertToAssignmentData(); // AssignmentData로 변환
    }
    notifyListeners();
  }

  // 스케줄 데이터를 저장
  Future<void> _saveSchedules() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'schedules',
      json.encode(
        _schedules.map((schedule) {
          return {
            ...schedule,
            'selectedDate': (schedule['selectedDate'] as DateTime).toIso8601String(),
            'endDate': (schedule['endDate'] as DateTime).toIso8601String(),
          };
        }).toList(),
      ),
    );
  }

  // 스케줄 추가
  void addSchedule(Map<String, dynamic> schedule, String category) {
    _schedules.add({
      ...schedule,
      'category': category,
      'isCompleted': schedule['isCompleted'] ?? false,
    });
    _saveSchedules();
    _addToAssignmentData(schedule, category); // AssignmentData에도 추가
    notifyListeners();
  }

  // AssignmentData 생성 및 추가
  void _addToAssignmentData(Map<String, dynamic> schedule, String category) {
    final assignment = AssignmentData(
      subjectName: category,
      assignmentName: schedule['content'],
      currentRatio: schedule['currentRatio'] ?? 0.0,
      latePenalty: schedule['latePenalty'] ?? 0.0,
      isAlter: schedule['isAlter'] ?? 0,
      deadline: schedule['endDate'],
      expectedPeriod: schedule['expectedPeriod'] ?? 0.0,
    );
    assignment.calculateImportance(schedule['subjectRatio'] ?? 1.0, 0.1);
    _assignmentDataList.add(assignment);
  }

  // 스케줄 완료 상태 변경
  void toggleComplete(int index) {
    if (_schedules[index]['isCompleted'] != null) {
      _schedules[index]['isCompleted'] = !_schedules[index]['isCompleted'];
    } else {
      _schedules[index]['isCompleted'] = false;
    }
    _saveSchedules();
    notifyListeners();
  }

  // 스케줄 업데이트
  void updateSchedule(int index, Map<String, dynamic> updatedSchedule) {
    _schedules[index] = {
      ...updatedSchedule,
      'isCompleted': updatedSchedule['isCompleted'] ?? false,
    };
    _saveSchedules();
    _convertToAssignmentData(); // AssignmentData 갱신
    notifyListeners();
  }

  // 스케줄 삭제
  void removeSchedule(int index) {
    _schedules.removeAt(index);
    _saveSchedules();
    _convertToAssignmentData(); // AssignmentData 갱신
    notifyListeners();
  }

  // 주간 일정 필터링
  List<Map<String, dynamic>> getWeeklySchedules(DateTime startOfWeek, DateTime endOfWeek) {
    return _schedules.where((schedule) {
      final scheduleDate = schedule['selectedDate'] as DateTime;
      return scheduleDate.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
          scheduleDate.isBefore(endOfWeek.add(const Duration(days: 1)));
    }).toList();
  }

  // 일정 정렬 (중요도와 마감일 기준)
  List<AssignmentData> getSortedAssignments() {
    _assignmentDataList.sort((a, b) {
      if (a.importance != b.importance) {
        return b.importance.compareTo(a.importance); // 중요도 내림차순
      } else {
        return a.deadline.compareTo(b.deadline); // 마감일 오름차순
      }
    });
    return _assignmentDataList;
  }

  // AssignmentData 리스트로 변환
  void _convertToAssignmentData() {
    _assignmentDataList.clear();
    for (var schedule in _schedules) {
      _addToAssignmentData(schedule, schedule['category']);
    }
  }
}
