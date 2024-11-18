import 'package:flutter/material.dart';
import 'package:calendar/screen/homeScreen.dart' as home_screen; // HomeScreen 별칭 추가
import 'package:calendar/screen/weeklyScreen.dart';
import 'package:calendar/screen/settingsScreen.dart';
import 'package:calendar/components/colors.dart';

class BottomNavigationScreen extends StatefulWidget {
  @override
  _BottomNavigationScreenState createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  int _currentIndex = 0; // 현재 선택된 탭의 인덱스
  final List<Widget> _screens = [
    home_screen.HomeScreen(), // 별칭을 사용하여 HomeScreen 참조
    WeeklyTab(), // This Week 화면
    SettingsTab(), // Alarm 화면
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex], // 현재 선택된 화면 표시
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // 선택된 탭 업데이트
          });
        },
        selectedItemColor: PRIMARY_COLOR, // 선택된 아이템 색상
        unselectedItemColor: DARK_GREY_COLOR, // 선택되지 않은 아이템 색상
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check),
            label: 'Weekly',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}