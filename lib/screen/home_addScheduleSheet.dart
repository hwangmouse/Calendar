import 'package:flutter/material.dart';
import 'package:calendar/components/colors.dart';
import 'package:calendar/provider/category_provider.dart'; // CategoryProvider import
import 'package:provider/provider.dart'; //?

class ScheduleBottomSheet extends StatefulWidget {
  final DateTime selectedDate; // 선택된 날짜
  final DateTime? initialEndDate; // 종료 날짜 (수정 모드일 경우 초기값으로 사용)
  final TimeOfDay? initialEndTime;
  final String? initialContent; // 일정 내용 (수정 모드일 경우 초기값으로 사용)
  final CategoryProvider categoryProvider; // 카테고리 데이터를 관리하는 Provider

  ScheduleBottomSheet({
    required this.selectedDate,
    required this.categoryProvider, // 생성자에 필요한 CategoryProvider 추가
    this.initialEndDate,
    this.initialEndTime,
    this.initialContent,
    Key? key,
  }) : super(key: key);

  @override
  _ScheduleBottomSheetState createState() => _ScheduleBottomSheetState();
}

class _ScheduleBottomSheetState extends State<ScheduleBottomSheet> {
  late DateTime endDate;
  late TimeOfDay endTime;
  late TextEditingController contentController;
  String? selectedCategory; // 선택된 카테고리를 저장하는 변수
  TimeOfDay? startTime; // General category 일정 추가 시 시작 시간
  TimeOfDay? stopTime; // General category 일정 추가 시 종료 시간

  @override
  void initState() {
    super.initState();
    // 종료 날짜의 기본값을 선택된 날짜로 설정
    endDate = widget.initialEndDate ?? widget.selectedDate;
    endTime = widget.initialEndTime ?? TimeOfDay.now();
    contentController = TextEditingController(text: widget.initialContent ?? '');
  }

  @override
  void dispose() {
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // subjectCategories와 generalCategories를 합쳐서 사용 (과목 + 일반 카테고리)
    final combinedCategories = [
      ...widget.categoryProvider.subjectCategories,
      ...widget.categoryProvider.generalCategories
    ];

    final isGeneralCategory = widget.categoryProvider.generalCategories.contains(selectedCategory);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<String>(
                isExpanded: true,
                value: selectedCategory,
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value; // 선택된 카테고리 업데이트
                  });
                },
                items: combinedCategories
                    .map<DropdownMenuItem<String>>((category) {
                  return DropdownMenuItem<String>(
                    value: category, // DropdownButton의 value로 사용할 String 값
                    child: Text(category), // 드롭다운에서 표시될 텍스트
                  );
                }).toList(),
                hint: Text(
                  "카테고리 선택",
                  style: TextStyle(
                    fontWeight: FontWeight.bold, // 글씨를 굵게 설정
                  ),
                ),
              ),
              SizedBox(height: 8.0), // '카테고리 선택'과 '일정 내용' 사이 공백 추가
              TextField(
                controller: contentController,
                decoration: InputDecoration(
                  labelText: '일정 내용',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: TEXT_FIELD_FILL_COLOR,
                ),
              ),
              SizedBox(height: 16.0),

              if (isGeneralCategory) ...[
                // General Category: 날짜와 시작/종료 시간만 받음
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '시작 시간:',
                      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () async {
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: startTime ?? TimeOfDay.now(),
                        );
                        if (pickedTime != null) {
                          setState(() {
                            startTime = pickedTime;
                          });
                        }
                      },
                      child: Text(
                        startTime != null ? startTime!.format(context) : "시간 선택",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: PRIMARY_COLOR,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '종료 시간:',
                      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () async {
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: stopTime ?? TimeOfDay.now(),
                        );
                        if (pickedTime != null) {
                          setState(() {
                            stopTime = pickedTime;
                          });
                        }
                      },
                      child: Text(
                        stopTime != null ? stopTime!.format(context) : "시간 선택",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: PRIMARY_COLOR,
                        ),
                      ),
                    ),
                  ],
                ),
              ] else ...[
                // Subject Category: 종료 날짜와 시간을 받음
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '종료 날짜:',
                      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: endDate,
                          firstDate: widget.selectedDate,
                          lastDate: DateTime(3000),
                        );
                        if (pickedDate != null && pickedDate != endDate) {
                          setState(() {
                            endDate = pickedDate;
                          });
                        }
                      },
                      child: Text(
                        '${endDate.year}-${endDate.month}-${endDate.day}',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: PRIMARY_COLOR,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '종료 시간:',
                      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () async {
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: endTime,
                        );
                        if (pickedTime != null && pickedTime != endTime) {
                          setState(() {
                            endTime = pickedTime;
                          });
                        }
                      },
                      child: Text(
                        '${endTime.format(context)}',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: PRIMARY_COLOR,
                        ),
                      ),
                    ),
                  ],
                ),
              ],

              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (contentController.text.trim().isNotEmpty) {
                        Navigator.of(context).pop({
                          'selectedDate': widget.selectedDate,
                          'endDate': endDate,
                          'endTime': endTime,
                          'startTime': startTime,
                          'stopTime': stopTime,
                          'content': contentController.text.trim(),
                          'category': selectedCategory,
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: PRIMARY_COLOR,
                    ),
                    child: Text('저장'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
