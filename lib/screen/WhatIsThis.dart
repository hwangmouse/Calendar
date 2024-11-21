import 'package:flutter/material.dart';
import 'package:calendar/inapp_algorithm/AssignmentData.dart';

class AssignmentAddScreen extends StatefulWidget {
  final AssignmentData? assignmentData;

  AssignmentAddScreen({this.assignmentData});

  @override
  _AssignmentAddScreenState createState() => _AssignmentAddScreenState();
}

class _AssignmentAddScreenState extends State<AssignmentAddScreen> {
  final _formKey = GlobalKey<FormState>();

  String? name; // 과제 이름
  String? currentRatio; // 현재 과제 비율  ---
  bool isLateSubmissionAllowed = false; // 늦은 제출 허용 여부
  double? latePenalty; // 늦은 제출 시 반영 비율
  int? isAlter; // 대체 과제 여부
  DateTime? deadline; // 과제 마감일
  String? expectedPeriod; // 예상 시간

  @override
  void initState() {
    super.initState();
    if (widget.assignmentData != null) {
      name = widget.assignmentData!.assignmentName;
      currentRatio = widget.assignmentData!.currentRatio.toString();
      isLateSubmissionAllowed = widget.assignmentData!.latePenalty > 0.0;
      latePenalty = widget.assignmentData!.latePenalty > 0.0
          ? widget.assignmentData!.latePenalty
          : null;
      isAlter = widget.assignmentData!.isAlter;
      deadline = widget.assignmentData!.deadline;
      expectedPeriod = widget.assignmentData!.expectedPeriod.toString();
    }
  }

  Future<void> _selectDeadline(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: deadline ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate == null) return;

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(deadline ?? DateTime.now()),
    );
    if (pickedTime == null) return;

    setState(() {
      deadline = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.assignmentData == null ? "과제 추가" : "과제 수정"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // 과제 이름 입력
              TextFormField(
                decoration: InputDecoration(labelText: "과제 이름"),
                initialValue: name,
                keyboardType: TextInputType.text,
                onChanged: (value) => setState(() => name = value),
                validator: (value) =>
                    value == null || value.isEmpty ? "과제 이름을 입력하세요." : null,
              ),
              // 현재 과제 비율 입력
              TextFormField(
                decoration: InputDecoration(labelText: "현재 과제 비율 (0 ~ 1)"),
                initialValue: currentRatio,
                keyboardType: TextInputType.number,
                onChanged: (value) => setState(() => currentRatio = value),
                validator: (value) {
                  final ratio = double.tryParse(value ?? '');
                  if (ratio == null || ratio < 0 || ratio > 1) {
                    return "0.0에서 1.0 사이의 값을 입력하세요.";
                  }
                  return null;
                },
              ),
              // 늦은 제출 허용 여부 스위치
              SwitchListTile(
                title: Text("늦은 제출 허용 여부"),
                value: isLateSubmissionAllowed,
                onChanged: (value) {
                  setState(() {
                    isLateSubmissionAllowed = value;
                    if (!value) {
                      latePenalty = null; // 비허용 시 비율 초기화
                    }
                  });
                },
              ),
              // 늦은 제출 반영 비율 (허용일 때만 표시)
              if (isLateSubmissionAllowed)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "늦은 제출 시 반영 비율 (%)",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Slider(
                      value: latePenalty ?? 50.0,
                      min: 0.0,
                      max: 100.0,
                      divisions: 20,
                      label: "${latePenalty?.round()}%",
                      onChanged: (value) {
                        setState(() {
                          latePenalty = value;
                        });
                      },
                    ),
                  ],
                ),
              // 대체 과제 여부 드롭다운
              DropdownButtonFormField<int>(
                value: isAlter,
                items: [
                  DropdownMenuItem(value: 0, child: Text("일반 과제")),
                  DropdownMenuItem(value: 1, child: Text("중간고사 대체 과제")),
                  DropdownMenuItem(value: 2, child: Text("기말고사 대체 과제")),
                ],
                onChanged: (value) => setState(() => isAlter = value),
                decoration: InputDecoration(labelText: "대체 과제 여부"),
              ),
              // 마감일 선택
              ListTile(
                title: Text(
                  "마감일: ${deadline != null ? deadline!.toLocal().toString().replaceFirst(' ', ' | ') : '선택되지 않음'}",
                ),
                trailing: Icon(Icons.calendar_today),
                onTap: () => _selectDeadline(context),
              ),
              // 예상 시간 입력
              TextFormField(
                decoration: InputDecoration(labelText: "예상 소요 시간 (시간)"),
                initialValue: expectedPeriod,
                keyboardType: TextInputType.number,
                onChanged: (value) => setState(() => expectedPeriod = value),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final newAssignment = AssignmentData(
                      subjectName: "",  //???
                      assignmentName: name ?? "",
                      currentRatio:
                          double.tryParse(currentRatio ?? '0.0') ?? 0.0,
                      latePenalty:
                          isLateSubmissionAllowed ? (latePenalty ?? 0.0) : 0.0,
                      isAlter: isAlter ?? 0,
                      deadline: deadline ?? DateTime.now(),
                      expectedPeriod:
                          double.tryParse(expectedPeriod ?? '0.0') ?? 0.0,
                    );
                    Navigator.pop(context, newAssignment);
                  }
                },
                child: Text(widget.assignmentData == null ? "과제 추가" : "과제 수정"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
