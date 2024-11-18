import 'package:flutter/material.dart';

class AlarmProvider with ChangeNotifier {
  List<Map<String, dynamic>> _alarms = []; // 알림 데이터 리스트

  List<Map<String, dynamic>> get alarms => _alarms;

  // 알림 추가
  void addAlarm(Map<String, dynamic> alarm) {
    _alarms.add(alarm);
    notifyListeners(); // UI 업데이트
  }

  // 모든 알림 삭제
  void clearAlarms() {
    _alarms.clear();
    notifyListeners(); // UI 업데이트
  }
}
