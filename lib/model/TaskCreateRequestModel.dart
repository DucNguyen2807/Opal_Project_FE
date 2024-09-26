class TaskCreateRequestModel {
  final String title;
  final String description;
  final String priority;
  final String dueDate;
  final String timeTask;

  TaskCreateRequestModel({
    required this.title,
    required this.description,
    required this.priority,
    required this.dueDate,
    required this.timeTask,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'priority': priority,
      'dueDate': dueDate,
      'timeTask': timeTask,
    };
  }
}
