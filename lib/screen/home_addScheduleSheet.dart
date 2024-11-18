import 'package:flutter/material.dart';
import 'package:calendar/components/colors.dart';
import 'package:calendar/provider/category_provider.dart'; // CategoryProvider import
import 'package:provider/provider.dart';

class ScheduleBottomSheet extends StatefulWidget {
  final DateTime selectedDate; // 선택된 날짜
  final DateTime? initialEndDate; // 종료 날짜 (수정 모드일 경우 초기값으로 사용)
  final String? initialContent; // 일정 내용 (수정 모드일 경우 초기값으로 사용)
  final CategoryProvider categoryProvider; // 카테고리 데이터를 관리하는 Provider

  ScheduleBottomSheet({
    required this.selectedDate,
    required this.categoryProvider, // 생성자에 필요한 CategoryProvider 추가
    this.initialEndDate,
    this.initialContent,
    Key? key,
  }) : super(key: key);

  @override
  _ScheduleBottomSheetState createState() => _ScheduleBottomSheetState();
}

class _ScheduleBottomSheetState extends State<ScheduleBottomSheet> {
  late DateTime endDate;
  late TextEditingController contentController;
  String? selectedCategory; // 선택된 카테고리를 저장하는 변수

  @override
  void initState() {
    super.initState();
    // 종료 날짜의 기본값을 선택된 날짜로 설정
    endDate = widget.initialEndDate ?? widget.selectedDate;
    contentController = TextEditingController(text: widget.initialContent ?? '');
  }

 //need?
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
                hint: Text("카테고리 선택"),
              ),
              SizedBox(height: 16.0),
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
                        firstDate: widget.selectedDate, // 종료 날짜는 선택된 날짜 이후로만 가능
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
                          'content': contentController.text.trim(),
                          'category': selectedCategory, // 카테고리 정보 추가
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
