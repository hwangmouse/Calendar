import 'AssignmentData.dart';

class TaskQueue {
  List<AssignmentData> queue = [];

  void addTask(AssignmentData task) {
    queue.add(task);
    // sort by decreasing order
    queue.sort((a, b) => b.priority.compareTo(a.priority));
  }

  AssignmentData? getNextTask() {
    if (queue.isEmpty) {
      return null;
    }
    return queue.removeAt(0);
  }
}
