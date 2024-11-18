import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';



class CategoryProvider extends ChangeNotifier {
  List<String> _subjectCategories = []; // 과목 카테고리를 저장하는 리스트
  List<String> _generalCategories = []; // 일반 카테고리를 저장하는 리스트

  // 외부에서 과목 및 일반 카테고리에 접근할 수 있는 getter
  List<String> get subjectCategories => _subjectCategories;
  List<String> get generalCategories => _generalCategories;

  // 생성자: 클래스가 초기화될 때 카테고리를 로드
  CategoryProvider() {
    loadCategories(); // 앱 시작 시 카테고리 데이터를 로드
  }

  // SharedPreferences를 통해 저장된 카테고리를 불러오는 함수
  Future<void> loadCategories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // SharedPreferences에서 저장된 데이터 가져오기
    String? subjectData = prefs.getString('subjectCategories'); // 과목 카테고리 데이터
    String? generalData = prefs.getString('generalCategories'); // 일반 카테고리 데이터

    // JSON 데이터를 리스트로 변환
    if (subjectData != null) {
      _subjectCategories = List<String>.from(json.decode(subjectData));
    }
    if (generalData != null) {
      _generalCategories = List<String>.from(json.decode(generalData));
    }

    notifyListeners(); // UI 갱신 요청
  }


  // 카테고리 데이터를 SharedPreferences에 저장하는 함수
  Future<void> saveCategories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // 리스트 데이터를 JSON 문자열로 변환하여 저장
    await prefs.setString('subjectCategories', json.encode(_subjectCategories));
    await prefs.setString('generalCategories', json.encode(_generalCategories));
  }

  // 과목 카테고리 추가
  void addSubjectCategory(String category) {
    _subjectCategories.add(category);
    saveCategories();
    notifyListeners();
  }

  // 일반 카테고리 추가
  void addGeneralCategory(String category) {
    _generalCategories.add(category);
    saveCategories();
    notifyListeners();
  }

  // 과목 카테고리 삭제
  void removeSubjectCategory(String category) {
    _subjectCategories.remove(category);
    saveCategories();
    notifyListeners();
  }

  // 일반 카테고리 삭제
  void removeGeneralCategory(String category) {
    _generalCategories.remove(category);
    saveCategories();
    notifyListeners();
  }

  // 과목 카테고리 이름 수정
  void updateSubjectCategory(int index, String updatedName) {
    _subjectCategories[index] = updatedName;
    saveCategories(); // 저장소 업데이트
    notifyListeners(); // UI 갱신
  }

  // 일반 카테고리 이름 수정
  void updateGeneralCategory(int index, String updatedName) {
    _generalCategories[index] = updatedName;
    saveCategories(); // 저장소 업데이트
    notifyListeners(); // UI 갱신
  }
}