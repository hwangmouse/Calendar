class Assignment {
  String name; // 과제 이름 -> (AssignmentData.dart: int numOfAssignment)
  double currentRatio; // 현재 과제 비율
  double latePenalty; // 늦은 제출 허용 여부 (0.0 = 허용하지 않음)
  int isAlter; // 대체 과제 여부 (0: 일반 과제, 1: 중간 대체, 2: 기말 대체)
  DateTime deadline; // 과제 마감일
  double expectedPeriod; // 과제 완료 예상 시간
  bool isCompleted; // 과제 완료 여부

  Assignment({
    required this.name,
    required this.currentRatio,
    required this.latePenalty,
    required this.isAlter,
    required this.deadline,
    required this.expectedPeriod,
    this.isCompleted = false, // 기본값 false
  });

  // JSON으로 변환하기 위한 메서드
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'currentRatio': currentRatio,
      'latePenalty': latePenalty,
      'isAlter': isAlter,
      'deadline': deadline.toIso8601String(), // 날짜를 ISO 형식의 문자열로 변환
      'expectedPeriod': expectedPeriod,
      'isCompleted': isCompleted,
    };
  }

  // JSON에서 Assignment 객체로 변환하기 위한 생성자
  factory Assignment.fromJson(Map<String, dynamic> json) {
    return Assignment(
      name: json['name'],
      currentRatio: json['currentRatio'],
      latePenalty: json['latePenalty'],
      isAlter: json['isAlter'],
      deadline: DateTime.parse(json['deadline']), // ISO 형식 문자열을 DateTime으로 변환
      expectedPeriod: json['expectedPeriod'],
      isCompleted: json['isCompleted'] ?? false, // 기본값 false로 설정
    );
  }
}
