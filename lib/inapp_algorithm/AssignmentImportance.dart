import 'AssignmentData.dart';
import 'subjectData.dart';
import 'calenderData.dart';

class AssignmentImportance {
  List<AssignmentData> assignments;
  List<SubjectData> subjects;

  AssignmentImportance(this.assignments, this.subjects);

  double _getRatioByName(String subjectName) {
    for (var subject in subjects) {
      if (subject.subjectName == subjectName) {
        return subject.assignmentRatio;
      }
    }
    return 0.0;
  }

  double _getAlterValByName(String subjectName) {
    for (var subject in subjects) {
      if (subject.subjectName == subjectName) {
        return subject.midtermRatio;
      }
    }
    return 0.0;
  }

  void calcImportance() {
    for (var assignment in assignments) {
      double subjectRatio = _getRatioByName(assignment.subjectName);
      double alterVal = _getAlterValByName(assignment.subjectName);
      assignment.calculateImportance(subjectRatio, alterVal);
    }
  }

  void updateRecDeadlines(List<CalenderData> schedules) {
    for (var assignment in assignments) {
      assignment.calculateRecDeadline(schedules);
    }
  }
}
