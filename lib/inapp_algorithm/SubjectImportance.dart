import 'subjectData.dart';

class SubjectImportance {
  List<SubjectData> subjects;
  final int maxCreditHours = 3;

  SubjectImportance(this.subjects);

  void calcImportance() {
    for (var subject in subjects) {
      double creditScore = subject.creditHours / maxCreditHours;
      double preferenceScore = 1.0;
      switch (subject.preferenceLevel) {
        case 1:
          preferenceScore = 0.8;
          break;
        case 2:
          preferenceScore = 0.85;
          break;
        case 3:
          preferenceScore = 0.9;
          break;
        case 4:
          preferenceScore = 0.95;
          break;
        case 5:
          preferenceScore = 1.0;
          break;
        default:
          print("Error value");
      }
      double majorScore = subject.isMajor ? 1.0 : 0.8;
      double assignmentRatio = subject.assignmentRatio * 4.0;
      double importance =
          (creditScore * majorScore) + preferenceScore + assignmentRatio;
      subject.importance = importance;
    }
  }
}
