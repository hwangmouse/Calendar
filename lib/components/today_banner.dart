import 'package:flutter/material.dart';
import 'package:calendar/components/colors.dart';

class TodayBanner extends StatelessWidget {
  final DateTime selectedDate;
  final int count;

  const TodayBanner({
    required this.selectedDate,
    required this.count,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      color: LIGHT_PRIMARY_COLOR, // PRIMARY_COLOR보다 연한 색상을 배경으로 사용
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${selectedDate.year}-${selectedDate.month}-${selectedDate.day}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
              color: DARK_GREY_COLOR, // 텍스트 색상 어두운 회색
            ),
          ),
          Text(
            '$count개의 일정',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
              color: DARK_GREY_COLOR, // 텍스트 색상 어두운 회색
            ),
          ),
        ],
      ),
    );
  }
}
