import 'package:flutter/material.dart';
import 'package:calendar/screen/settings_categoryManagementScreen.dart'; // 카테고리 관리 화면 추가

class SettingsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.category),
            title: Text('Manage Categories'),
            subtitle: Text('Add and manage Subject and General categories'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CategoryManagementScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
