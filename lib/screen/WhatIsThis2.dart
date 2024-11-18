import 'package:flutter/material.dart';
import 'package:calendar/screen/settings_categoryManagement_addSubjectScreen.dart';

class SubjectListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('과목 관리'),
      ),
      body: ListView(
        children: [
          // 여기에 과목 리스트를 동적으로 표시할 수 있는 로직 추가
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SubjectAddScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
