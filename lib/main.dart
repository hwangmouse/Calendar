import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:calendar/components/bottom_navigation.dart';
import 'package:calendar/provider/schedule_provider.dart';// ScheduleProvider 파일 가져오기
import 'package:calendar/provider/category_provider.dart'; // CategoryProvider 파일 가져오기
import 'package:calendar/components/colors.dart';
import 'package:calendar/alarm/background_alarm.dart'; // 알림 초기화 및 백그라운드 작업

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Flutter 시스템 초기화
  print("Initializing alarms..."); // 로그 추가
  await initializeAlarms(); // 로컬 알림 초기화
  print("Alarms initialized."); // 로그 추가

  print("Registering background alarms..."); // 로그 추가
  registerBackgroundAlarms(); // 백그라운드 작업 등록
  print("Background alarms registered."); // 로그 추가

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ScheduleProvider()), // 일정 관리 Provider 초기화 및 등록
        ChangeNotifierProvider(create: (_) => CategoryProvider()), // 카테고리 관리 Provider 초기화 및 등록
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navigation Example', // 앱 타이틀 설정
      theme: ThemeData(
        primaryColor: PRIMARY_COLOR, // 주 색상 설정
        scaffoldBackgroundColor: LIGHT_GREY_COLOR, // 기본 배경색 설정
        appBarTheme: AppBarTheme(
          backgroundColor: PRIMARY_COLOR, // 앱바 배경색 설정
          foregroundColor: Colors.white, // 앱바 전경색 설정
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: PRIMARY_COLOR, // 플로팅 액션 버튼 색상 설정
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: DARK_GREY_COLOR), // 기본 텍스트 스타일 설정
          bodyMedium: TextStyle(color: DARK_GREY_COLOR),
        ),
      ),
      home: BottomNavigationScreen(), // 메인 화면으로 하단 네비게이션 화면 설정
    );
  }
}