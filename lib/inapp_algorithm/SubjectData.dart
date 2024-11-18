class SubjectData {
  String subjectName;
  double midtermRatio;
  double finalRatio;
  double assignmentRatio;
  double attendanceRatio;
  int creditHours;
  bool isMajor;
  int preferenceLevel;
  double importance;

  SubjectData({
    required this.subjectName,
    required this.midtermRatio,
    required this.finalRatio,
    required this.assignmentRatio,
    required this.attendanceRatio,
    required this.creditHours,
    required this.isMajor,
    required this.preferenceLevel,
    this.importance = 0.0,
  });

  void calculateImportance(int maxCreditHours) {
    double creditScore = creditHours / maxCreditHours;
    double preferenceScore = 1.0;
    switch (preferenceLevel) {
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
    double majorScore = isMajor ? 1.0 : 0.8;
    double assignmentScore = assignmentRatio * 4.0;
    importance = (creditScore * majorScore) + preferenceScore + assignmentScore;
  }
}
