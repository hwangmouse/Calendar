import 'Assignment.dart';

class Subject {
  String name;
  bool isMajor;
  int creditHours;
  int preferenceLevel;
  double attendanceRatio;
  double midtermRatio;
  double finalRatio;
  double assignmentRatio;
  List<Assignment> assignments;

  Subject({
    required this.name,
    required this.isMajor,
    required this.creditHours,
    required this.preferenceLevel,
    required this.attendanceRatio,
    required this.midtermRatio,
    required this.finalRatio,
    required this.assignmentRatio,
    this.assignments = const [],
  });

  bool get isValidRatio =>
      (attendanceRatio + midtermRatio + finalRatio + assignmentRatio) == 1.0;

  // JSON으로 변환하기 위한 메서드
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'isMajor': isMajor,
      'creditHours': creditHours,
      'preferenceLevel': preferenceLevel,
      'attendanceRatio': attendanceRatio,
      'midtermRatio': midtermRatio,
      'finalRatio': finalRatio,
      'assignmentRatio': assignmentRatio,
      'assignments': assignments.map((assignment) => assignment.toJson()).toList(),
    };
  }

  // JSON에서 Subject 객체로 변환하기 위한 생성자
  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      name: json['name'],
      isMajor: json['isMajor'],
      creditHours: json['creditHours'],
      preferenceLevel: json['preferenceLevel'],
      attendanceRatio: json['attendanceRatio'],
      midtermRatio: json['midtermRatio'],
      finalRatio: json['finalRatio'],
      assignmentRatio: json['assignmentRatio'],
      assignments: (json['assignments'] as List<dynamic>)
          .map((assignmentJson) => Assignment.fromJson(assignmentJson))
          .toList(),
    );
  }
}

