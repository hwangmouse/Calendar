import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:calendar/screen/settings_categoryManagementScreen.dart'; // 카테고리 관리 화면 추가
import 'package:calendar/provider/theme_provider.dart'; // 테마 전환을 관리할 Provider 추가

class SettingsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

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
          Divider(),
          ListTile(
            leading: Icon(Icons.brightness_6),
            title: Text('Theme'),
            subtitle: Text('Toggle Light and Dark Mode'),
            trailing: Switch(
              value: themeProvider.isDarkMode, // 현재 테마 상태
              onChanged: (value) {
                themeProvider.toggleTheme(); // 테마 전환
              },
            ),
          ),
        ],
      ),
    );
  }
}
