import 'package:flutter/material.dart';
import 'package:calendar/components/colors.dart';

class ScheduleCard extends StatelessWidget {
  final DateTime? endDate; // 종료 날짜
  final String content;
  final bool isCompleted; // 완료 여부
  final VoidCallback? onToggleComplete; // 완료 상태 변경 콜백
  final VoidCallback? onEdit; // 수정 콜백

  const ScheduleCard({
    this.endDate,
    required this.content,
    required this.isCompleted,
    this.onToggleComplete,
    this.onEdit,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final contentColor = isCompleted ? Colors.grey : Colors.black; // 내용 색상 변경
    final dateColor = isCompleted ? Colors.grey : PRIMARY_COLOR; // 종료 날짜 색상 변경

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 1.0,
          color: PRIMARY_COLOR,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0), // 패딩 조정
      margin: EdgeInsets.only(bottom: 8.0), // 아래 간격 조정
      child: Row(
        children: [
          // 작은 체크박스
          GestureDetector(
            onTap: onToggleComplete,
            child: Container(
              width: 16.0, // 체크박스 크기 축소
              height: 16.0, // 체크박스 크기 축소
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                border: Border.all(
                  color: isCompleted ? PRIMARY_COLOR : Colors.grey,
                  width: 2.0,
                ),
                color: isCompleted ? PRIMARY_COLOR : Colors.transparent,
              ),
              child: isCompleted
                  ? Icon(Icons.check, size: 12.0, color: Colors.white) // 아이콘 크기 축소
                  : null,
            ),
          ),
          SizedBox(width: 12.0), // 체크박스와 텍스트 간격
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (endDate != null)
                  Text(
                    '종료 날짜: ${endDate!.year}-${endDate!.month}-${endDate!.day}',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: dateColor, // 완료 상태에 따라 색상 변경
                      fontSize: 14.0,
                    ),
                  ),
                SizedBox(height: 4.0),
                Text(
                  content,
                  style: TextStyle(
                    fontSize: 12.0,
                    color: contentColor, // 완료 상태에 따른 내용 색상 변경
                  ),
                ),
              ],
            ),
          ),
          if (onEdit != null)
            TextButton(
              onPressed: onEdit,
              child: Text(
                '수정',
                style: TextStyle(
                  color: PRIMARY_COLOR,
                  fontWeight: FontWeight.bold,
                  fontSize: 12.0,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
