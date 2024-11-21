import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:calendar/provider/category_provider.dart';
import 'package:calendar/inapp_algorithm/SubjectData.dart';

class SubjectAddScreen extends StatefulWidget {
  final SubjectData? existingSubject; // For edit mode

  SubjectAddScreen({this.existingSubject});

  @override
  _SubjectAddScreenState createState() => _SubjectAddScreenState();
}

class _SubjectAddScreenState extends State<SubjectAddScreen> {
  final TextEditingController _subjectNameController = TextEditingController();
  bool isMajor = false;
  int creditHours = 1;
  double preferenceLevel = 1.0;
  double attendanceRatio = 0.0;
  double midtermRatio = 0.0;
  double finalRatio = 0.0;
  double assignmentRatio = 0.0;

  @override
  void initState() {
    super.initState();
    // Populate fields for edit mode
    if (widget.existingSubject != null) {
      final subjectData = widget.existingSubject!;
      _subjectNameController.text = subjectData.subjectName;
      isMajor = subjectData.isMajor;
      creditHours = subjectData.creditHours;
      preferenceLevel = subjectData.preferenceLevel.toDouble();
      attendanceRatio = subjectData.attendanceRatio;
      midtermRatio = subjectData.midtermRatio;
      finalRatio = subjectData.finalRatio;
      assignmentRatio = subjectData.assignmentRatio;
    }
  }

  void _saveSubject() {
    if ((attendanceRatio + midtermRatio + finalRatio + assignmentRatio)
        .toStringAsFixed(2) != "1.00") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('성적 비율의 합은 1.0이어야 합니다.')),
      );
      return;
    }

    final newSubject = SubjectData(
      subjectName: _subjectNameController.text.trim(),
      isMajor: isMajor,
      creditHours: creditHours,
      preferenceLevel: preferenceLevel.toInt(),
      attendanceRatio: attendanceRatio,
      midtermRatio: midtermRatio,
      finalRatio: finalRatio,
      assignmentRatio: assignmentRatio,
    );

    Provider.of<CategoryProvider>(context, listen: false).addSubjectCategory(newSubject.subjectName);

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
              controller: _subjectNameController,
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
              value: creditHours,
              items: List.generate(
                3,
                    (index) => DropdownMenuItem(
                  value: index + 1,
                  child: Text('${index + 1} 학점'),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  creditHours = value ?? 1;
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
                        index < preferenceLevel ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                      ),
                      onPressed: () {
                        setState(() {
                          preferenceLevel = index + 1.0;
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
                  midtermRatio = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            _buildRatioInput(
              label: '기말고사 비율',
              onChanged: (value) {
                setState(() {
                  finalRatio = double.tryParse(value) ?? 0.0;
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
