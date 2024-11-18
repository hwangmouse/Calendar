import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ScheduleProvider with ChangeNotifier {
  // 스케줄 데이터를 저장하는 리스트
  List<Map<String, dynamic>> _schedules = [];

  // 외부에서 스케줄 데이터를 읽을 수 있도록 getter 제공
  List<Map<String, dynamic>> get schedules => _schedules;

  // 생성자: ScheduleProvider가 초기화될 때 호출
  ScheduleProvider() {
    loadSchedules(); // 앱 시작 시 저장된 스케줄 데이터를 로드
  }

  // SharedPreferences를 통해 저장된 스케줄 데이터를 불러오는 함수
  Future<void> loadSchedules() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? scheduleData = prefs.getString('schedules'); // 저장된 스케줄 JSON 가져오기
    if (scheduleData != null) {
      // JSON 데이터를 리스트로 변환하며 DateTime 필드를 복원
      _schedules = List<Map<String, dynamic>>.from(
        json.decode(scheduleData).map((schedule) {
          // 저장된 문자열을 다시 DateTime으로 변환
          return {
            ...schedule,
            'selectedDate': DateTime.parse(schedule['selectedDate']),
            'endDate': DateTime.parse(schedule['endDate']),
          };
        }),
      );
    }
    notifyListeners(); // 데이터 로드 후 UI 갱신
  }


// SharedPreferences에 현재 스케줄 데이터를 저장하는 함수
  Future<void> _saveSchedules() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // 스케줄 데이터를 JSON 형식으로 변환하며 DateTime을 문자열로 변환
    await prefs.setString(
      'schedules',
      json.encode(_schedules.map((schedule) {
        // DateTime을 문자열로 변환해 저장
        return {
          ...schedule,
          'selectedDate': (schedule['selectedDate'] as DateTime).toIso8601String(),
          'endDate': (schedule['endDate'] as DateTime).toIso8601String(),
        };
      }).toList()),
    );
  }

  // 새로운 스케줄을 추가하는 함수
  void addSchedule(Map<String, dynamic> schedule, String category) {
    _schedules.add({
      ...schedule,
      'category': category, // Include category in schedule
      'isCompleted': schedule['isCompleted'] ?? false, // Default to false
    });
    _saveSchedules(); // Save to persistent storage
    notifyListeners();
  }

  // 특정 스케줄의 완료 여부를 토글하는 함수
  void toggleComplete(int index) {
    if (_schedules[index]['isCompleted'] != null) {
      _schedules[index]['isCompleted'] = !_schedules[index]['isCompleted'];
    } else {
      _schedules[index]['isCompleted'] = false; // Default to false
    }
    _saveSchedules();
    notifyListeners();
  }

  // 기존 스케줄 데이터를 업데이트하는 함수
  void updateSchedule(int index, Map<String, dynamic> updatedSchedule) {
    _schedules[index] = {
      ...updatedSchedule,
      'isCompleted': updatedSchedule['isCompleted'] ?? false, // Default to false
    };
    _saveSchedules();
    notifyListeners();
  }

  // 특정 인덱스의 스케줄을 삭제하는 함수
  void removeSchedule(int index) {
    _schedules.removeAt(index);
    _saveSchedules();
    notifyListeners();
  }

  List<Map<String, dynamic>> getWeeklySchedules(DateTime startOfWeek, DateTime endOfWeek) {
    return _schedules.where((schedule) {
      final scheduleDate = schedule['selectedDate'] as DateTime;

      // 주간 범위 내에 포함되는 일정만 반환
      return scheduleDate.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
          scheduleDate.isBefore(endOfWeek.add(const Duration(days: 1)));
    }).toList();
  }
}
