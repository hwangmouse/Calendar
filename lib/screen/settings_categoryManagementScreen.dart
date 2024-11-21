import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:calendar/provider/category_provider.dart'; // CategoryProvider import
import 'package:calendar/screen/settings_categoryManagement_addSubjectScreen.dart'; // Subject 추가 화면

class CategoryManagementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Category Management'),
      ),
      body: ListView(
        children: [
          // Subject Categories Section
          ListTile(
            leading: Icon(Icons.lock),
            title: Text('Subjects'),
            trailing: IconButton(
              icon: Icon(Icons.add),
              onPressed: () => _addSubjectCategory(context, categoryProvider),
            ),
          ),
          ...categoryProvider.subjectCategories.asMap().entries.map((entry) {
            int index = entry.key;
            String category = entry.value;
            return ListTile(
              title: Text(category),
              leading: Icon(Icons.book),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => _editSubjectCategory(context, categoryProvider, index),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _deleteSubjectCategory(context, categoryProvider, index),
                  ),
                ],
              ),
            );
          }).toList(),
          Divider(),
          // General Categories Section
          ListTile(
            leading: Icon(Icons.lock),
            title: Text('General'),
            trailing: IconButton(
              icon: Icon(Icons.add),
              onPressed: () => _addGeneralCategory(context, categoryProvider),
            ),
          ),
          ...categoryProvider.generalCategories.asMap().entries.map((entry) {
            int index = entry.key;
            String category = entry.value;
            return ListTile(
              title: Text(category),
              leading: Icon(Icons.category),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => _editGeneralCategory(context, categoryProvider, index),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _deleteGeneralCategory(context, categoryProvider, index),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  // Add Subject Category
  void _addSubjectCategory(BuildContext context, CategoryProvider provider) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SubjectAddScreen()),
    ).then((newSubject) {
      if (newSubject != null && newSubject is String) {
        provider.addSubjectCategory(newSubject); // Provider로 추가
      }
    });
  }

  // Add General Category
  void _addGeneralCategory(BuildContext context, CategoryProvider provider) {
    TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add General Category'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Enter General Category Name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String name = controller.text.trim();
                if (name.isNotEmpty) {
                  provider.addGeneralCategory(name); // Provider로 추가
                  Navigator.pop(context);
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  // Edit Subject Category
  void _editSubjectCategory(BuildContext context, CategoryProvider provider, int index) {
    TextEditingController controller = TextEditingController();
    controller.text = provider.subjectCategories[index];
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Subject Category'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Edit Category Name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String updatedName = controller.text.trim();
                if (updatedName.isNotEmpty) {
                  provider.updateSubjectCategory(index, updatedName); // Provider로 수정
                  Navigator.pop(context);
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // Edit General Category
  void _editGeneralCategory(BuildContext context, CategoryProvider provider, int index) {
    TextEditingController controller = TextEditingController();
    controller.text = provider.generalCategories[index];
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit General Category'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Edit Category Name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String updatedName = controller.text.trim();
                if (updatedName.isNotEmpty) {
                  provider.updateGeneralCategory(index, updatedName); // Provider로 수정
                  Navigator.pop(context);
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // Delete Subject Category
  void _deleteSubjectCategory(BuildContext context, CategoryProvider provider, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Subject Category'),
        content: Text('Are you sure you want to delete this category?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              provider.removeSubjectCategory(provider.subjectCategories[index]); // Provider로 삭제
              Navigator.pop(context);
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  // Delete General Category
  void _deleteGeneralCategory(BuildContext context, CategoryProvider provider, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete General Category'),
        content: Text('Are you sure you want to delete this category?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              provider.removeGeneralCategory(provider.generalCategories[index]); // Provider로 삭제
              Navigator.pop(context);
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }
}
