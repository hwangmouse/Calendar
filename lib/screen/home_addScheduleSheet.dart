import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:calendar/components/colors.dart';
import 'package:calendar/provider/category_provider.dart';
import 'package:calendar/inapp_algorithm/AssignmentData.dart';
import 'package:calendar/provider/schedule_provider.dart';

class ScheduleBottomSheet extends StatefulWidget {
  final DateTime selectedDate;
  final DateTime? initialEndDate;
  final TimeOfDay? initialEndTime;
  final String? initialContent;
  final CategoryProvider categoryProvider;

  ScheduleBottomSheet({
    required this.selectedDate,
    required this.categoryProvider,
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
  String? selectedCategory;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _currentRatioController = TextEditingController();
  TextEditingController _expectedPeriodController = TextEditingController();
  bool _isLateSubmissionAllowed = false;
  double? _latePenalty;
  int? _isAlter;
  DateTime? _deadline;

  @override
  void initState() {
    super.initState();
    endDate = widget.initialEndDate ?? widget.selectedDate;
    endTime = widget.initialEndTime ?? TimeOfDay.now();
    contentController = TextEditingController(text: widget.initialContent ?? '');
  }

  @override
  void dispose() {
    contentController.dispose();
    _nameController.dispose();
    _currentRatioController.dispose();
    _expectedPeriodController.dispose();
    super.dispose();
  }

  Future<void> _selectDeadline(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _deadline ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate == null) return;

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_deadline ?? DateTime.now()),
    );
    if (pickedTime == null) return;

    setState(() {
      _deadline = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    });
  }

  void _saveAssignment() {
    if (_nameController.text.isEmpty || _currentRatioController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("모든 필드를 채워주세요.")),
      );
      return;
    }

    final currentRatio = double.tryParse(_currentRatioController.text);
    if (currentRatio == null || currentRatio < 0 || currentRatio > 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("과제 비율은 0.0에서 1.0 사이여야 합니다.")),
      );
      return;
    }

    final expectedPeriod = double.tryParse(_expectedPeriodController.text) ?? 0.0;

    final newAssignment = {
      'content': _nameController.text.trim(),
      'selectedDate': widget.selectedDate,
      'endDate': _deadline ?? DateTime.now(),
      'currentRatio': currentRatio,
      'latePenalty': _isLateSubmissionAllowed ? _latePenalty ?? 0.0 : 0.0,
      'isAlter': _isAlter ?? 0,
      'expectedPeriod': expectedPeriod,
    };

    Provider.of<ScheduleProvider>(context, listen: false)
        .addSchedule(newAssignment, selectedCategory ?? '일반');

    Navigator.pop(context); // BottomSheet 닫기
  }

  @override
  Widget build(BuildContext context) {
    final combinedCategories = [
      ...widget.categoryProvider.subjectCategories,
      ...widget.categoryProvider.generalCategories,
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('일정 추가'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              value: selectedCategory,
              onChanged: (value) => setState(() => selectedCategory = value),
              items: combinedCategories.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              decoration: InputDecoration(labelText: '카테고리 선택'),
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: '과제 이름'),
            ),
            TextField(
              controller: _currentRatioController,
              decoration: InputDecoration(labelText: '현재 과제 비율 (0 ~ 1)'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            SwitchListTile(
              title: Text('늦은 제출 허용 여부'),
              value: _isLateSubmissionAllowed,
              onChanged: (bool value) {
                setState(() {
                  _isLateSubmissionAllowed = value;
                });
              },
            ),
            if (_isLateSubmissionAllowed)
              Slider(
                value: _latePenalty ?? 50.0,
                min: 0.0,
                max: 100.0,
                divisions: 20,
                label: '${_latePenalty?.round()}%',
                onChanged: (double value) {
                  setState(() {
                    _latePenalty = value;
                  });
                },
              ),
            DropdownButtonFormField<int>(
              value: _isAlter,
              onChanged: (int? newValue) {
                setState(() {
                  _isAlter = newValue;
                });
              },
              items: <DropdownMenuItem<int>>[
                DropdownMenuItem<int>(value: 0, child: Text('일반 과제')),
                DropdownMenuItem<int>(value: 1, child: Text('중간고사 대체 과제')),
                DropdownMenuItem<int>(value: 2, child: Text('기말고사 대체 과제')),
              ],
              decoration: InputDecoration(labelText: '대체 과제 여부'),
            ),
            ListTile(
              title: Text('마감일: ${_deadline != null ? _deadline!.toLocal().toString().replaceFirst(' ', ' | ') : '선택되지 않음'}'),
              trailing: Icon(Icons.calendar_today),
              onTap: () => _selectDeadline(context),
            ),
            TextField(
              controller: _expectedPeriodController,
              decoration: InputDecoration(labelText: '예상 소요 시간 (시간)'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _saveAssignment,
              child: Text('과제 추가'),
            ),
          ],
        ),
      ),
    );
  }
}
