import 'subjectData.dart';
import 'SubjectImportance.dart';
import 'AssignmentData.dart';
import 'calenderData.dart';
import 'AssignmentImportance.dart';
import 'FinalPriority.dart';
import 'TaskQueue.dart';

void main() {
  List<SubjectData> subjects = [
    SubjectData(
      subjectName: 'Math',
      midtermRatio: 0.3,
      finalRatio: 0.3,
      assignmentRatio: 0.3,
      attendanceRatio: 0.1,
      creditHours: 3,
      isMajor: true,
      preferenceLevel: 5,
    ),
    SubjectData(
      subjectName: 'English',
      midtermRatio: 0.2,
      finalRatio: 0.4,
      assignmentRatio: 0.3,
      attendanceRatio: 0.1,
      creditHours: 2,
      isMajor: false,
      preferenceLevel: 3,
    ),
    SubjectData(
      subjectName: 'Science',
      midtermRatio: 0.3,
      finalRatio: 0.4,
      assignmentRatio: 0.2,
      attendanceRatio: 0.1,
      creditHours: 3,
      isMajor: true,
      preferenceLevel: 4,
    ),
    SubjectData(
      subjectName: 'History',
      midtermRatio: 0.2,
      finalRatio: 0.3,
      assignmentRatio: 0.3,
      attendanceRatio: 0.2,
      creditHours: 2,
      isMajor: false,
      preferenceLevel: 3,
    ),
    SubjectData(
      subjectName: 'Art',
      midtermRatio: 0.2,
      finalRatio: 0.3,
      assignmentRatio: 0.4,
      attendanceRatio: 0.1,
      creditHours: 1,
      isMajor: false,
      preferenceLevel: 5,
    ),
    SubjectData(
      subjectName: 'Music',
      midtermRatio: 0.3,
      finalRatio: 0.3,
      assignmentRatio: 0.3,
      attendanceRatio: 0.1,
      creditHours: 2,
      isMajor: false,
      preferenceLevel: 3,
    ),
  ];

  // Calculate subject importance
  SubjectImportance(subjects).calcImportance();

  List<AssignmentData> assignments = [
    AssignmentData(
      subjectName: 'Math',
      assignmentName: 'Summary',
      currentRatio: 0.2,
      latePenalty: 0.1,
      isAlter: 0,
      deadline: DateTime.now().add(Duration(days: 5)),
      expectedPeriod: 2.0,
    ),
    AssignmentData(
      subjectName: 'English',
      assignmentName: 'HW5',
      currentRatio: 0.3,
      latePenalty: 0.0,
      isAlter: 0,
      deadline: DateTime.now().add(Duration(days: 2)),
      expectedPeriod: 1.0,
    ),
    AssignmentData(
      subjectName: 'Science',
      assignmentName: 'Lab Report',
      currentRatio: 0.4,
      latePenalty: 0.2,
      isAlter: 0,
      deadline: DateTime.now().add(Duration(days: 7)),
      expectedPeriod: 3.0,
    ),
    AssignmentData(
      subjectName: 'History',
      assignmentName: 'Term Paper',
      currentRatio: 0.5,
      latePenalty: 0.15,
      isAlter: 1,
      deadline: DateTime.now().add(Duration(days: 4)),
      expectedPeriod: 2.5,
    ),
    AssignmentData(
      subjectName: 'Art',
      assignmentName: 'Project',
      currentRatio: 0.1,
      latePenalty: 0.05,
      isAlter: 0,
      deadline: DateTime.now().add(Duration(days: 3)),
      expectedPeriod: 1.5,
    ),
    AssignmentData(
      subjectName: 'Music',
      assignmentName: 'Performance',
      currentRatio: 0.25,
      latePenalty: 0.0,
      isAlter: 2,
      deadline: DateTime.now().add(Duration(days: 6)),
      expectedPeriod: 2.0,
    ),
  ];

  List<CalenderData> schedules = [
    CalenderData(
        scheduleName: 'Holiday',
        scheduleDate: DateTime.now().add(Duration(days: 3))),
    CalenderData(
        scheduleName: 'Meeting',
        scheduleDate: DateTime.now().add(Duration(days: 1))),
  ];

  // Update assignment importance and recDeadline
  AssignmentImportance assignmentImportanceCalculator =
      AssignmentImportance(assignments, subjects);
  assignmentImportanceCalculator.calcImportance();
  assignmentImportanceCalculator.updateRecDeadlines(schedules);

  // Calculate final priority
  FinalPriority finalPriorityCalculator = FinalPriority(
      subjects, assignments, schedules.map((e) => e.scheduleDate).toList());
  finalPriorityCalculator.calcPriority();

  // Add tasks to TaskQueue and print priority
  TaskQueue taskQueue = TaskQueue();
  for (var assignment in assignments) {
    // Update priority before adding to the queue
    double subjectImportance = subjects
        .firstWhere((subject) => subject.subjectName == assignment.subjectName,
            orElse: () => SubjectData(
                  subjectName: 'Unknown',
                  midtermRatio: 0.0,
                  finalRatio: 0.0,
                  assignmentRatio: 0.0,
                  attendanceRatio: 0.0,
                  creditHours: 0,
                  isMajor: false,
                  preferenceLevel: 0,
                ))
        .importance;

    double recDeadlineImportance =
        finalPriorityCalculator.calcDeadlineImportance(
            assignment.recDeadline, assignment.deadline, DateTime.now());

    double finalPriority =
        subjectImportance + assignment.importance + recDeadlineImportance;
    assignment.priority = finalPriority; // Update priority value

    taskQueue.addTask(assignment);
    print(
        'Added to queue: ${assignment.subjectName}, Priority: ${assignment.priority}');
  }

  // Print FIFO
  print('\n--- Pop to the queue by importance decreasing order---\n');
  while (taskQueue.queue.isNotEmpty) {
    AssignmentData? nextTask = taskQueue.getNextTask();
    if (nextTask != null) {
      double subjectImportance = subjects
          .firstWhere((subject) => subject.subjectName == nextTask.subjectName,
              orElse: () => SubjectData(
                    subjectName: 'Unknown',
                    midtermRatio: 0.0,
                    finalRatio: 0.0,
                    assignmentRatio: 0.0,
                    attendanceRatio: 0.0,
                    creditHours: 0,
                    isMajor: false,
                    preferenceLevel: 0,
                  ))
          .importance;

      double recDeadlineImportance =
          finalPriorityCalculator.calcDeadlineImportance(
              nextTask.recDeadline, nextTask.deadline, DateTime.now());

      print('Assignment: ${nextTask.subjectName}, ${nextTask.assignmentName}');
      String formattedValue = subjectImportance.toStringAsFixed(2);
      print('  Subject Importance: $formattedValue');
      formattedValue = nextTask.importance.toStringAsFixed(2);
      print('  Assignment Importance: ${formattedValue}');
      formattedValue = recDeadlineImportance.toStringAsFixed(2);
      print('  Deadline Importance: $formattedValue');
      double finalPriority =
          subjectImportance + nextTask.importance + recDeadlineImportance;
      formattedValue = finalPriority.toStringAsFixed(2);
      print('  Final Priority: $formattedValue\n');
    }
  }
}
