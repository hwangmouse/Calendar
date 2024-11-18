import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:calendar/provider/category_provider.dart';
import 'package:calendar/components/Subject.dart';

class SubjectAddScreen extends StatefulWidget {
  final Subject? existingSubject; // For edit mode

  SubjectAddScreen({this.existingSubject});

  @override
  _SubjectAddScreenState createState() => _SubjectAddScreenState();
}

class _SubjectAddScreenState extends State<SubjectAddScreen> {
  final TextEditingController _nameController = TextEditingController();
  bool isMajor = false;
  int credit = 1;
  double preference = 1.0;
  double attendanceRatio = 0.0;
  double midExamRatio = 0.0;
  double finalExamRatio = 0.0;
  double assignmentRatio = 0.0;

  @override
  void initState() {
    super.initState();
    // Populate fields for edit mode
    if (widget.existingSubject != null) {
      final subject = widget.existingSubject!;
      _nameController.text = subject.name;
      isMajor = subject.isMajor;
      credit = subject.creditHours;
      preference = subject.preferenceLevel.toDouble();
      attendanceRatio = subject.attendanceRatio;
      midExamRatio = subject.midtermRatio;
      finalExamRatio = subject.finalRatio;
      assignmentRatio = subject.assignmentRatio;
    }
  }

  void _saveSubject() {
    if ((attendanceRatio + midExamRatio + finalExamRatio + assignmentRatio)
        .toStringAsFixed(2) != "1.00") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('성적 비율의 합은 1.0이어야 합니다.')),
      );
      return;
    }

    final newSubject = Subject(
      name: _nameController.text.trim(),
      isMajor: isMajor,
      creditHours: credit,
      preferenceLevel: preference.toInt(),
      attendanceRatio: attendanceRatio,
      midtermRatio: midExamRatio,
      finalRatio: finalExamRatio,
      assignmentRatio: assignmentRatio,
    );

    Provider.of<CategoryProvider>(context, listen: false).addSubjectCategory(newSubject.name);

    Navigator.pop(context, newSubject); // Return updated or new subject
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingSubject == null ? '과목 추가' : '과목 수정'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 과목 이름 입력
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: '과목 이름'),
            ),
            // 전공 여부
            SwitchListTile(
              title: Text('전공 여부'),
              value: isMajor,
              onChanged: (value) {
                setState(() {
                  isMajor = value;
                });
              },
            ),
            // 학점 선택
            DropdownButtonFormField<int>(
              decoration: InputDecoration(labelText: '학점'),
              value: credit,
              items: List.generate(
                3,
                    (index) => DropdownMenuItem(
                  value: index + 1,
                  child: Text('${index + 1} 학점'),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  credit = value ?? 1;
                });
              },
            ),
            // 선호도 선택 (별점)
            Row(
              children: [
                Text('선호도'),
                Spacer(),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    5,
                        (index) => IconButton(
                      icon: Icon(
                        index < preference ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                      ),
                      onPressed: () {
                        setState(() {
                          preference = index + 1.0;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // 성적 비율 입력
            Text(
              '성적 비율 입력 (합이 1.00이어야 함)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _buildRatioInput(
              label: '출석 비율',
              onChanged: (value) {
                setState(() {
                  attendanceRatio = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            _buildRatioInput(
              label: '중간고사 비율',
              onChanged: (value) {
                setState(() {
                  midExamRatio = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            _buildRatioInput(
              label: '기말고사 비율',
              onChanged: (value) {
                setState(() {
                  finalExamRatio = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            _buildRatioInput(
              label: '과제 비율',
              onChanged: (value) {
                setState(() {
                  assignmentRatio = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _saveSubject,
                child: Text(widget.existingSubject == null ? '과목 추가' : '저장'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatioInput({
    required String label,
    required Function(String) onChanged,
  }) {
    return TextField(
      decoration: InputDecoration(labelText: label),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      onChanged: onChanged,
    );
  }
}
