import 'subjectData.dart';
import 'AssignmentData.dart';

class FinalPriority {
  List<SubjectData> subjects;
  List<AssignmentData> assignments;
  List<DateTime> schedules;

  FinalPriority(this.subjects, this.assignments, this.schedules);

  void calcPriority() {
    final DateTime now = DateTime.now();

    Map<String, double> subjectImportanceMap = {};
    for (var subject in subjects) {
      subjectImportanceMap[subject.subjectName] = subject.importance;
    }

    for (var assignment in assignments) {
      double assignmentImportance = assignment.importance;
      DateTime assignmentRecDeadline = assignment.recDeadline;
      double subjectImportance =
          subjectImportanceMap[assignment.subjectName] ?? 0.0;

      double recDeadlineImportance = calcDeadlineImportance(
          assignmentRecDeadline, assignment.deadline, now);

      double finalPriority =
          subjectImportance + assignmentImportance + recDeadlineImportance;
      assignment.priority = finalPriority;
    }
  }

  double calcDeadlineImportance(
      DateTime recDeadline, DateTime deadline, DateTime currentDate) {
    double baseImportance = 2.5;

    int daysUntilDeadline = deadline.difference(currentDate).inDays;
    // if left duration is less than 3 day, scaling the importance
    if (daysUntilDeadline <= 3) {
      double scalingFactor = 3.0;
      baseImportance +=
          baseImportance * (1 - (daysUntilDeadline / 3)) * scalingFactor;
    } else {
      double totalDays = deadline.difference(recDeadline).inDays.toDouble();
      if (totalDays > 0) {
        baseImportance +=
            (baseImportance * (1 - (daysUntilDeadline / totalDays)));
      }
    }

    if (baseImportance < 2.5) {
      baseImportance = 2.5;
    }
    return baseImportance;
  }
}
